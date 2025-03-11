/client/proc/create_poll()
	set name = "Создать голосование"
	set category = "Специальные возможности"
	if(!check_rights(R_POLL))
		return
	if(!SSdbcore.Connect())
		to_chat(src, "<span class='danger'>Не удалось установить соединение с базой данных.</span>")
		return
	var/polltype = input("Выберите тип голосования.","Тип голосования") as null|anything in list("Одиночный вариант","Текстовый ответ","Оценка","Множественный выбор", "Голосование за мгновенный рестарт")
	var/choice_amount = 0
	switch(polltype)
		if("Одиночный вариант")
			polltype = POLLTYPE_OPTION
		if("Текстовый ответ")
			polltype = POLLTYPE_TEXT
		if("Оценка")
			polltype = POLLTYPE_RATING
		if("Множественный выбор")
			polltype = POLLTYPE_MULTI
			choice_amount = input("Как много будет вариантов ответа?","Выберите количество") as num|null
			switch(choice_amount)
				if(0)
					to_chat(src, "Опрос с множественным выбором должен иметь по крайней мере один разрешенный вариант выбора.")
					return
				if(1)
					polltype = POLLTYPE_OPTION
				if(null)
					return
		if ("Голосование за мгновенный рестарт")
			polltype = POLLTYPE_IRV
		else
			return FALSE
	var/starttime = SQLtime()
	var/endtime = input("Установите время окончания опроса в формате ГГГГ-ММ-ДД ЧЧ:ММ:СС. Все время указано по времени сервера. ЧЧ:ММ:СС необязательно и в формате 24 часа. Должно быть позже времени начала по очевидным причинам", "Установите время окончания", SQLtime()) as text
	if(!endtime)
		return
	var/datum/db_query/query_validate_time = SSdbcore.NewQuery({"
		SELECT IF(STR_TO_DATE(:endtime,'%Y-%c-%d %T') > NOW(), STR_TO_DATE(:endtime,'%Y-%c-%d %T'), 0)
		"}, list("endtime" = endtime))
	if(!query_validate_time.warn_execute() || QDELETED(usr) || !src)
		qdel(query_validate_time)
		return
	if(query_validate_time.NextRow())
		var/checktime = text2num(query_validate_time.item[1])
		if(!checktime)
			to_chat(src, "Введенная дата и время имеют неправильный формат или не позднее текущего времени сервера..")
			qdel(query_validate_time)
			return
		endtime = query_validate_time.item[1]
	qdel(query_validate_time)
	var/adminonly
	switch(alert("Голосвание только для админов?",,"Да","Нет","Назад"))
		if("Да")
			adminonly = 1
		if("Нет")
			adminonly = 0
		else
			return
	var/dontshow
	switch(alert("Скрыть результаты опроса от отслеживания до его завершения?",,"Да","Нет","Назад"))
		if("Да")
			dontshow = 1
		if("Нет")
			dontshow = 0
		else
			return
	var/question = input("Напишите ваш вопрос","Вопрос") as message|null
	if(!question)
		return
	var/list/sql_option_list = list()
	if(polltype != POLLTYPE_TEXT)
		var/add_option = 1
		while(add_option)
			var/option = input("Введите ваш ответ","ответ") as message|null
			if(!option)
				return
			var/default_percentage_calc = 0
			if(polltype != POLLTYPE_IRV)
				switch(alert("Должен ли этот параметр быть включен по умолчанию при формировании процентных значений результатов опроса?",,"Да","Нет","Назад"))
					if("Да")
						default_percentage_calc = 1
					if("Нет")
						default_percentage_calc = 0
					else
						return
			var/minval = 0
			var/maxval = 0
			var/descmin = ""
			var/descmid = ""
			var/descmax = ""
			if(polltype == POLLTYPE_RATING)
				minval = input("Установить минимальное значение рейтинга.","Минимальный рейтинг") as num|null
				if(minval == null)
					return
				maxval = input("Установить максимальное значение рейтинга.","Максимальный рейтинг") as num|null
				if(minval >= maxval)
					to_chat(src, "Максимальное значение рейтинга не может быть меньше или равно минимальному значению рейтинга.")
					continue
				if(maxval == null)
					return
				descmin = input("Необязательно: Задайте описание для минимального рейтинга", "Описание минимального рейтинга") as message|null
				if(descmin == null)
					return
				descmid = input("Необязательно: Задайте описание для среднего рейтинга","Описание среднего рейтинга") as message|null
				if(descmid == null)
					return
				descmax = input("Необязательно: Задайте описание для максимального рейтинга","Описание максимального рейтинга") as message|null
				if(descmax == null)
					return
			sql_option_list += list(list(
				"text" = option, "minval" = minval, "maxval" = maxval,
				"descmin" = descmin, "descmid" = descmid, "descmax" = descmax,
				"default_percentage_calc" = default_percentage_calc))
			switch(alert(" ",,"Добавить ответ","Готово", "Назад"))
				if("Добавить ответ")
					add_option = 1
				if("Готово")
					add_option = 0
				else
					return FALSE
	var/m1 = "[key_name(usr)] Создал серверное голосование. Тип голосования: [polltype] - Только для админов: [adminonly ? "Да" : "Нет"] - Вопрос: [question]"
	var/m2 = "[key_name_admin(usr)] Создал серверное голосование. Тип голосования: [polltype] - Только для админов: [adminonly ? "Да" : "Нет"] - Вопрос: [question]"
	var/datum/db_query/query_polladd_question = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("poll_question")] (polltype, starttime, endtime, question, adminonly, multiplechoiceoptions, createdby_ckey, createdby_ip, dontshow)
		VALUES (:polltype, :starttime, :endtime, :question, :adminonly, :choice_amount, :ckey, INET_ATON(:address), :dontshow)
		"}, list(
			"polltype" = polltype, "starttime" = starttime, "endtime" = endtime,
			"question" = question, "adminonly" = adminonly, "choice_amount" = choice_amount,
			"ckey" = ckey, "address" = address, "dontshow" = dontshow
		))
	if(!query_polladd_question.warn_execute())
		qdel(query_polladd_question)
		return
	qdel(query_polladd_question)
	if(polltype != POLLTYPE_TEXT)
		var/pollid = 0
		var/datum/db_query/query_get_id = SSdbcore.NewQuery("SELECT LAST_INSERT_ID()")
		if(!query_get_id.warn_execute())
			qdel(query_get_id)
			return
		if(query_get_id.NextRow())
			pollid = query_get_id.item[1]
		qdel(query_get_id)
		for(var/list/i in sql_option_list)
			i |= list("pollid" = "'[pollid]'")
		SSdbcore.MassInsert(format_table_name("poll_option"), sql_option_list, warn = TRUE)
	log_admin(m1)
	message_admins(m2)
