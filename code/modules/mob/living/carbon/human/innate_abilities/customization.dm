/datum/action/innate/ability/humanoid_customization
	name = "Alter Form"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "alter_form" //placeholder
	icon_icon = 'modular_citadel/icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	var/body_size_max
	var/body_size_min

/datum/action/innate/ability/humanoid_customization/Activate()
	if(owner.get_ability_property(INNATE_ABILITY_HUMANOID_CUSTOMIZATION, PROPERTY_CUSTOMIZATION_SILENT))
		owner.visible_message("<span class='notice'>[owner] gains a look of \
		concentration while standing perfectly still.\
			Their body seems to shift and starts getting more goo-like.</span>",
		"<span class='notice'>You focus intently on altering your body while \
		standing perfectly still...</span>")
	change_form()

///////
/////// NOTICE: This currently doens't support skin tone - if anyone wants to add this to non slimes, it's up to YOU to do this.
////// (someone should also add genital color switching, more mutant color selection)
///// maybe just make this entire thing tgui based. maybe.
///////

/datum/action/innate/ability/humanoid_customization/proc/change_form()
	var/mob/living/carbon/human/H = owner

	var/select_alteration = input(owner, "Выберите, какую часть вашей формы следует изменить", "Изменение формы", "Отменить") in list("Цвет тела", "Цвет глаз","Стиль причёски", "Гениталии", "Хвост", "Морда", "Крылья", "Окрас", "Уши", "Taur body", "Пенис", "Вагина", "Длина пениса", "Размер груди", "Форма груди", "Размер задницы", "Размер живота", "Размер тела", "Цвет гениталий", "Рога", "Цвет волос", "Тон кожи (Не мутант)", "Гендер и непристойности", "Ноги", "Отменить")

	if(select_alteration == "Цвет тела")
		var/new_color = input(owner, "Выберите свой цвет кожи:", "Смена расы","#"+H.dna.features["mcolor"]) as color|null
		if(new_color)
			var/temp_hsv = RGBtoHSV(new_color)
			if(ReadHSV(temp_hsv)[3] >= ReadHSV(MINIMUM_MUTANT_COLOR)[3] || !CONFIG_GET(flag/character_color_limits)) // mutantcolors must be bright //SPLURT EDIT
				H.dna.features["mcolor"] = sanitize_hexcolor(new_color, 6)
				H.update_body()
				H.update_hair()
			else
				to_chat(H, "<span class='notice'>Недопустимый цвет. У вас недостаточно яркий цвет.</span>")
	else if(select_alteration == "Eye Color")
		if(iscultist(H) && HAS_TRAIT(H, TRAIT_CULT_EYES))
			to_chat(H, "<span class='cultlarge'>\"Мне больше не нужно, чтобы ты прятался, наслаждайся моим подарком.\"</span>")
			return

		var/heterochromia = input(owner, "Вы хотите иметь гетерохромию?", "Подтвердите многоцветность") in list("Да", "Нет")
		if(heterochromia == "Yes")
			var/new_color1 = input(owner, "Выберите цвет левого глаза:", "Изменение цвета глаз","#"+H.dna?.features["left_eye_color"]) as color|null
			if(new_color1)
				H.left_eye_color = sanitize_hexcolor(new_color1, 6)
			var/new_color2 = input(owner, "Выберите цвет правого глаза:",  "Изменение цвета глаз","#"+H.dna?.features["right_eye_color"]) as color|null
			if(new_color2)
				H.right_eye_color = sanitize_hexcolor(new_color2, 6)
		else
			var/new_eyes = input(owner, "Выберите цвет глаз:", "Предпочтения персонажа","#"+H.dna?.features["left_eye_color"]) as color|null
			if(new_eyes)
				H.left_eye_color = sanitize_hexcolor(new_eyes, 6)
				H.right_eye_color = sanitize_hexcolor(new_eyes, 6)
		H.dna?.update_ui_block(DNA_LEFT_EYE_COLOR_BLOCK)
		H.dna?.update_ui_block(DNA_RIGHT_EYE_COLOR_BLOCK)
		H.update_body()
	else if(select_alteration == "Стиль причёски")
		if(H.gender == MALE)
			var/new_style = input(owner, "Выберите растительность на лице", "Изменения в растительности")  as null|anything in GLOB.facial_hair_styles_list
			if(new_style)
				H.facial_hair_style = new_style
		else
			H.facial_hair_style = "Бритый"
		//handle normal hair
		var/new_style = input(owner, "Выберите стиль причёски", "Изменения в причёске")  as null|anything in GLOB.hair_styles_list
		if(new_style)
			H.hair_style = new_style
			H.update_hair()
	else if (select_alteration == "Гениталии")
		var/operation = input("Выберите операцию на органе", "Изменение органов", "Отмена") in list("Добавить половой орган", "Убрать половой орган", "Отмена")
		switch(operation)
			if("Добавить половой орган")
				var/new_organ = input("Выберите половой орган:", "Изменение полового органа") as null|anything in GLOB.genitals_list
				if(!new_organ)
					return
				H.give_genital(GLOB.genitals_list[new_organ])

			if("Убрать половой орган")
				var/list/organs = list()
				for(var/obj/item/organ/genital/X in H.internal_organs)
					var/obj/item/organ/I = X
					organs["[I.name] ([I.type])"] = I
				var/obj/item/O = input("Выберите половой орган:", "Изменение полового органа", null) as null|anything in organs
				var/obj/item/organ/genital/G = organs[O]
				if(!G)
					return
				G.forceMove(get_turf(H))
				qdel(G)
				H.update_genitals()

	else if (select_alteration == "Уши")
		var/list/snowflake_ears_list = list("Normal" = null)
		for(var/path in GLOB.mam_ears_list)
			var/datum/sprite_accessory/ears/mam_ears/instance = GLOB.mam_ears_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_ears_list[S.name] = path
		var/new_ears
		new_ears = input(owner, "Выберите уши:", "Изменение ушей") as null|anything in snowflake_ears_list
		if(new_ears)
			H.dna.features["mam_ears"] = new_ears
		H.update_body()

	else if (select_alteration == "Лицо")
		var/list/snowflake_snouts_list = list("Normal" = null)
		for(var/path in GLOB.mam_snouts_list)
			var/datum/sprite_accessory/snouts/mam_snouts/instance = GLOB.mam_snouts_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_snouts_list[S.name] = path
		var/new_snout
		new_snout = input(owner, "Выберите лицо:", "Изменение лица") as null|anything in snowflake_snouts_list
		if(new_snout)
			H.dna.features["mam_snouts"] = new_snout
		H.update_body()

	else if (select_alteration == "Крылья")
		var/new_color = input(owner, "Выберите цвет крыльев:", "Смена расы","#"+H.dna.features["wings_color"]) as color|null
		if(new_color)
			H.dna.features["wings_color"] = sanitize_hexcolor(new_color, 6)
			H.update_body()
			H.update_hair()
		var/list/snowflake_wings_list = list("Normal" = null)
		for(var/path in GLOB.deco_wings_list)
			var/datum/sprite_accessory/deco_wings/instance = GLOB.deco_wings_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_wings_list[S.name] = path
		var/new_wings
		new_wings = input(owner, "Выберите крылья", "Изменение крыльев") as null|anything in snowflake_wings_list
		if(new_wings)
			H.dna.features["deco_wings"] = new_wings
		H.update_body()

	else if (select_alteration == "Отметины")
		var/list/snowflake_markings_list = list("None")
		for(var/path in GLOB.mam_body_markings_list)
			var/datum/sprite_accessory/mam_body_markings/instance = GLOB.mam_body_markings_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_markings_list[S.name] = path
		var/new_mam_body_markings
		new_mam_body_markings = input(H, "Выберите отметины:", "Изменение отметин") as null|anything in snowflake_markings_list
		if(new_mam_body_markings)
			H.dna.features["mam_body_markings"] = new_mam_body_markings
		for(var/X in H.bodyparts) //propagates the markings changes
			var/obj/item/bodypart/BP = X
			BP.update_limb(FALSE, H)
		H.update_body()

	else if (select_alteration == "Хвост")
		var/list/snowflake_tails_list = list("Normal" = null)
		for(var/path in GLOB.mam_tails_list)
			var/datum/sprite_accessory/tails/mam_tails/instance = GLOB.mam_tails_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_tails_list[S.name] = path
		var/new_tail
		new_tail = input(owner, "Выберите хвост:", "Изменение хвоста") as null|anything in snowflake_tails_list
		if(new_tail)
			H.dna.features["mam_tail"] = new_tail
			if(new_tail != "None")
				H.dna.features["taur"] = "None"
		H.update_body()

	else if (select_alteration == "Taur body")
		var/list/snowflake_taur_list = list("Normal" = null)
		for(var/path in GLOB.taur_list)
			var/datum/sprite_accessory/taur/instance = GLOB.taur_list[path]
			if(istype(instance, /datum/sprite_accessory))
				var/datum/sprite_accessory/S = instance
				if(S.ignore)
					continue
				if((!S.ckeys_allowed) || (S.ckeys_allowed.Find(H.client.ckey)))
					snowflake_taur_list[S.name] = path
		var/new_taur
		new_taur = input(owner, "Choose your character's tauric body:", "Tauric Alteration") as null|anything in snowflake_taur_list
		if(new_taur)
			H.dna.features["taur"] = new_taur
			if(new_taur != "None")
				H.dna.features["mam_tail"] = "None"
		H.update_body()

	else if (select_alteration == "Пенис")
		for(var/obj/item/organ/genital/penis/X in H.internal_organs)
			qdel(X)
		var/new_shape
		new_shape = input(owner, "Выберите пенис", "Изменение гениталий") as null|anything in GLOB.cock_shapes_list
		if(new_shape)
			H.dna.features["cock_shape"] = new_shape
		H.update_genitals()
		H.give_genital(/obj/item/organ/genital/testicles)
		H.give_genital(/obj/item/organ/genital/penis)
		H.apply_overlay()


	else if (select_alteration == "Вагина")
		for(var/obj/item/organ/genital/vagina/X in H.internal_organs)
			qdel(X)
		var/new_shape
		new_shape = input(owner, "Выберите вагину", "Изменение гениталий") as null|anything in GLOB.vagina_shapes_list
		if(new_shape)
			H.dna.features["vag_shape"] = new_shape
		H.update_genitals()
		H.give_genital(/obj/item/organ/genital/womb)
		H.give_genital(/obj/item/organ/genital/vagina)
		H.apply_overlay()

	else if (select_alteration == "Длина пениса")
		for(var/obj/item/organ/genital/penis/X in H.internal_organs)
			qdel(X)
		var/min_D = CONFIG_GET(number/penis_min_inches_prefs)
		var/max_D = CONFIG_GET(number/penis_max_inches_prefs)
		var/new_length = input(owner, "Длина пениса в сантиметраз:\n([min_D]-[max_D])", "Изменение гениталий") as num|null
		if(new_length)
			H.dna.features["cock_length"] = clamp(round(new_length), min_D, max_D)
		H.update_genitals()
		H.apply_overlay()
		H.give_genital(/obj/item/organ/genital/testicles)
		H.give_genital(/obj/item/organ/genital/penis)

	else if (select_alteration == "Размер груди")
		for(var/obj/item/organ/genital/breasts/X in H.internal_organs)
			qdel(X)
		var/new_size = input(owner, "Размер груди", "Изменение гениталий") as null|anything in CONFIG_GET(keyed_list/breasts_cups_prefs)
		if(new_size)
			H.dna.features["breasts_size"] = new_size
		H.update_genitals()
		H.apply_overlay()
		H.give_genital(/obj/item/organ/genital/breasts)

	else if (select_alteration == "Форма груди")
		for(var/obj/item/organ/genital/breasts/X in H.internal_organs)
			qdel(X)
		var/new_shape
		new_shape = input(owner, "Форма груди", "Изменение гениталий") as null|anything in GLOB.breasts_shapes_list
		if(new_shape)
			H.dna.features["breasts_shape"] = new_shape
		H.update_genitals()
		H.apply_overlay()
		H.give_genital(/obj/item/organ/genital/breasts)
/// SPLURT EDIT START
	else if (select_alteration == "Размер задницы")
		for(var/obj/item/organ/genital/butt/X in H.internal_organs)
			qdel(X)
		var/min_B = CONFIG_GET(number/butt_min_size_prefs)
		var/max_B = CONFIG_GET(number/butt_max_size_prefs)
		var/new_length = input(owner, "Размер задницы:\n([min_B]-[max_B])", "Изменение гениталий") as num|null
		if(new_length)
			H.dna.features["butt_size"] = clamp(round(new_length), min_B, max_B)
		H.update_genitals()
		H.apply_overlay()
		H.give_genital(/obj/item/organ/genital/butt)

	else if (select_alteration == "Размер живота")
		for(var/obj/item/organ/genital/belly/X in H.internal_organs)
			qdel(X)
		var/min_belly = CONFIG_GET(number/belly_min_size_prefs)
		var/max_belly = CONFIG_GET(number/belly_max_size_prefs)
		var/new_length = input(owner, "Размер живота:\n([min_belly]-[max_belly])", "Изменение гениталий") as num|null
		if(new_length)
			H.dna.features["belly_size"] = clamp(round(new_length), min_belly, max_belly)
		H.update_genitals()
		H.apply_overlay()
		H.give_genital(/obj/item/organ/genital/belly)

	//BLUEMOON CHANGE изменение размера требует время, сколько слишком сильно отличается в особенностях механик от сплюрта, как и в тематике сервера, чтобы давать возможность его так легко изменять
	else if (select_alteration == "Ращмер тела")
		// Check if the user has the size_normalized component attached, to avoid body size accumulation bug
		var/datum/component/size_normalized = H.GetComponent(/datum/component/size_normalized)
		if (size_normalized)
			to_chat(owner, "<span class='warning'>Разумные нормы не позволяют вам корректировать размеры всего вашего тела.</span>")
			return
		else
			if(!body_size_max) body_size_max = CONFIG_GET(number/body_size_max)
			if(!body_size_min) body_size_min = CONFIG_GET(number/body_size_min)
			var/owner_size = get_size(H)
			var/new_body_size = input(owner, "Выберите желаемый размер спрайта: ([body_size_min * 100]-[body_size_max * 100]%)\nВнимание: это может привести к искажению внешнего вида вашего персонажа. Кроме того, любой размер влияет на скорость и максимальное количество здоровья", "Изменение предпочтений", H.dna.features["body_size"]*100) as num|null
			if(new_body_size)
				var/chosen_size = clamp(new_body_size * 0.01, body_size_min, body_size_max)
				var/diff = abs(chosen_size - owner_size)
				if(diff)
					var/time_to_use = diff * 40 //10 секунд на 25% размера
					to_chat(H, span_warning("Вам нужно [time_to_use] секунд для изменения собственного размера."))
					if(do_after(owner, time_to_use SECONDS, target = owner))
						H.update_size(chosen_size)
	//BLUEMOON CHANGE END

	else if (select_alteration == "Цвет гениталий")
		var/genital_part = input(owner, "Выберите, какую часть ваших гениталий следует изменить", "Цвет гениталий", "Отмена") in list("Пенис", "Задница", "Машонка", "Анус", "Вагина", "Груди", "Живот", "Переключайте гениталии с помощью оттенка кожи", "Отмена")
		if(genital_part == "Toggle genitals using skintone")
			var/use_skintone = input(owner, "Вы хотите использовать свой тон кожи для всех гениталий? (Подходит только для тех рас, у которых поддерживается соответствующий оттенок кожи)", "Цвет гениталий") in list("Да", "Нет")
			if(use_skintone == "Да")
				H.dna.features["genitals_use_skintone"] = TRUE
			else
				H.dna.features["genitals_use_skintone"] = FALSE
		else
			var/hex_color = null
			if (genital_part == "Пенис")
				hex_color = input(owner, "Выберите " + "пениса" + " цвет:", "Цвет гениталий", "#" + H.dna.features["cock_color"]) as color|null
				genital_part = "хуй"
			else if (genital_part == "Вагина")
				hex_color = input(owner, "Выберите " + "вагины" + " цвет:", "Цвет гениталий", "#" + H.dna.features["vag_color"]) as color|null
				genital_part = "лоно"
			else if (genital_part == "Машонка")
				hex_color = input(owner, "Выберите " + "машонки" + " цвет:", "Цвет гениталий", "#" + H.dna.features["balls_color"]) as color|null
				genital_part = "яйца"
			else if (genital_part == "Груди")
				hex_color = input(owner, "Выберите " + "грудей" + " цвет:", "Цвет гениталий", "#" + H.dna.features["breasts_color"]) as color|null
				genital_part = "сиськи"
			else if (genital_part == "Задница")
				hex_color = input(owner, "Выберите " + "задницы" + " цвет:", "Цвет гениталий", "#" + H.dna.features["butt_color"]) as color|null
				genital_part = "жопа"
			else if (genital_part == "Анус")
				hex_color = input(owner, "Выберите " + "ануса" + " цвет:", "Цвет гениталий", "#" + H.dna.features["anus_color"]) as color|null
				genital_part = "дыра"
			else if (genital_part == "Живот")
				hex_color = input(owner, "Выберите " + "живота" + " цвет:", "Цвет гениталий", "#" + H.dna.features["belly_color"]) as color|null
				genital_part = "пузо"

			if (hex_color)
				H.dna.features[genital_part + "_color"] = sanitize_hexcolor(hex_color, 6)
				H.dna.features["genitals_use_skintone"] = FALSE

		H.update_genitals()

	else if (select_alteration == "Рога")
		var/new_horns = input(owner, "Выберите рога:", "Изменение предпочтений") as null|anything in GLOB.horns_list
		if(new_horns)
			H.dna.features["рога"] = new_horns

		var/new_horn_color = input(owner, "Выберите цвет рогов:", "Изменение предпочтений", "#" + H.dna.features["horns_color"]) as color|null
		if(new_horn_color)
			if (new_horn_color == "#000000" && H.dna.features["horns_color"] != "85615A")
				H.dna.features["horns_color"] = "85615A"
			else
				H.dna.features["horns_color"] = sanitize_hexcolor(new_horn_color, 6)

			H.update_body()

	else if (select_alteration == "Цвет волос")
		var/new_hair_color = input(owner, "Выберите цвет волос:", "Изменение предпочтений", "#" + H.dna.features["hair_color"]) as color|null
		if (new_hair_color)
			H.hair_color = sanitize_hexcolor(new_hair_color, 6)
		H.update_hair()

	else if(select_alteration == "Тон кожи (не мутант)") // Skin tone, different than mutant color
		var/list/choices = GLOB.skin_tones - GLOB.nonstandard_skin_tones
		if(CONFIG_GET(flag/allow_custom_skintones))
			choices += "пользовательский"
		var/new_s_tone = input(owner, "Выберите тон кожи: (Этот параметр отличается от параметра 'Цвет тела', который изменяет цвета мутантов вашего персонажа)", "Изменение предпочтений")  as null|anything in choices
		if(new_s_tone)
			if(new_s_tone == "пользовательский")
				var/default = H.skin_tone
				var/custom_tone = input(owner, "Выберите тон кожи: (Этот параметр отличается от параметра 'Цвет тела', который изменяет цвета мутантов вашего персонажа)", "Изменение предпочтений", default) as color|null
				if(custom_tone)
					var/temp_hsv = RGBtoHSV(custom_tone)
					if(ReadHSV(temp_hsv)[3] < ReadHSV("#333333")[3] && CONFIG_GET(flag/character_color_limits)) // rgb(50,50,50) //SPLURT EDIT
						to_chat(owner,"<span class='danger'>Недопустимый цвет. У вас недостаточно яркий цвет.</span>")
					else
						H.skin_tone = custom_tone
			else
				H.skin_tone = new_s_tone
			H.update_body()

	else if (select_alteration == "Гендер и непристойности")
		var/lewd_selection = input(owner, "Выберите, какой аспект гендера и непристойных предпочтений следует изменить", "Гендер и непристойности", "Отмена") in list("Гендер", "Модель тела", "Отмена")
		if(lewd_selection == "Гендер")
			var/new_gender = input(owner, "Выберите гендер:", "Изменение гендера") as null|anything in list("Мужчина", "Женщина", "Небинарный", "Объект")
			if(new_gender)
				switch(new_gender)
					if("Мужчина")
						H.gender = MALE
					if("Женщина")
						H.gender = FEMALE
					if("Небинарный")
						H.gender = PLURAL
					if("Объект")
						H.gender = NEUTER
		if(lewd_selection == "Тип тела")
			var/new_body_model = input(owner, "Выберите тип тела:", "Изменение модели тела") as null|anything in list("Мужеподобный", "Женоподобный")
			if(new_body_model)
				H.dna.features["body_model"] = new_body_model == "Мужеподобный" ? MALE : FEMALE
				H.update_body()

	else if (select_alteration == "Ноги")
		var/leg_choice = input(owner, "Выберите тип ног:", "Изменение типа ног") as null|anything in list("Прямоходящий", "Лапы", "Отмена")
		if(leg_choice)
			switch(leg_choice)
				if("Прямоходящий")
					H.dna.features["ноги"] = "Прямоходящий"
					H.dna.species.mutant_bodyparts["ноги"] = "Прямоходящий"
					H.Digitigrade_Leg_Swap(TRUE)
				if("Лапы")
					H.dna.features["ноги"] = "Лапы"
					H.dna.species.mutant_bodyparts["ноги"] = "Лапы"
					H.Digitigrade_Leg_Swap(FALSE)
			H.update_body()

/// SPLURT EDIT END
	else
		return
