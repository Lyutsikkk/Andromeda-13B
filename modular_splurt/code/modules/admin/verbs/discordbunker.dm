/client/proc/discordbunker()
	set category = "Сервер"
	set name = "Переключить Discord бункер"
	if(!SSdbcore.IsConnected())
		to_chat(usr, "<span class='adminnotice'>Датабаза не подключена/включена!</span>")
		return

	var/new_dbun = !CONFIG_GET(flag/need_discord_to_join)
	CONFIG_SET(flag/need_discord_to_join, new_dbun)

	log_admin("[key_name(usr)] переключил Discord бункер, теперь он [new_dbun ? "Включен" : "Выключен"]")
	message_admins("[key_name_admin(usr)] переключил Discord бункер, теперь он [new_dbun ? "Включен" : "Выключен"].")
	SSblackbox.record_feedback("nested tally", "discord_toggle", 1, list("Переключить Discord бункер", "[new_dbun ? "Включено" : "Выключено"]"))
	send2adminchat("Переключить Discord бункер", "[key_name(usr)] переключил Discord бункер, теперь он [new_dbun ? "Включен" : "Выключен"].")

/client/proc/adddiscordbypass(ckeytobypass as text) // Если какая-то пизда слишком ленива.
	set category = "Специальные возможности"
	set name = "Добавить Discord проход"
	set desc = "Позволяет на раунд пройти введёному сикею сквозь Discord бункер."
	if(!SSdbcore.IsConnected())
		to_chat(usr, "<span class='adminnotice'>Датабаза не подключена!</span>")
		return
	if(!SSdiscord)
		to_chat(usr, "<span class='adminnotice'>Подсистема Discord еще не инициализирована!</span>")
		return
	if(!CONFIG_GET(flag/need_discord_to_join))
		to_chat(usr, "<span class='adminnotice'>Discord бункер выключен!</span>")
		return

	GLOB.discord_passthrough |= ckey(ckeytobypass)
	GLOB.discord_passthrough[ckey(ckeytobypass)] = world.realtime
	log_admin("[key_name(usr)] добавил [ckeytobypass] на этот раунд в список прохода Discord бункера.")
	message_admins("[key_name_admin(usr)] добавил [ckeytobypass] на этот раунд в список прохода Discord бункера.")
	send2adminchat("Discord бункер", "[key_name(usr)] добавил [ckeytobypass] на этот раунд в список прохода Discord бункера.")

/client/proc/revokediscordbypass(ckeytobypass as text) // Если какая-то пизда оказалась набегатором.
	set category = "Специальные возможности"
	set name = "Отозвать Discord проход"
	set desc = "Отзывает возможность пройти сквозь Discord бункер на данный раунд."
	if(!SSdbcore.IsConnected())
		to_chat(usr, "<span class='adminnotice'>Датабаза не подключена!</span>")
		return
	if(!SSdiscord)
		to_chat(usr, "<span class='adminnotice'>Подсистема Discord еще не инициализирована!</span>")
		return
	if(!CONFIG_GET(flag/need_discord_to_join))
		to_chat(usr, "<span class='adminnotice'>Discord бункер выключен!</span>")
		return

	GLOB.discord_passthrough -= ckey(ckeytobypass)
	log_admin("[key_name(usr)] убрал [ckeytobypass] из списка прохода сквозь Discord бункер.")
	message_admins("[key_name_admin(usr)] убрал [ckeytobypass] из списка прохода сквозь Discord бункер.")
	send2adminchat("Discord бункер", "[key_name(usr)] убрал [ckeytobypass] из списка прохода сквозь Discord бункер.")
