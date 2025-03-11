/client/proc/vpnbunker()
	set category = "Сервер"
	set name = "Переключить блокиратор ВПН'а"

	var/new_vpnbun = !CONFIG_GET(flag/kick_vpn)
	CONFIG_SET(flag/kick_vpn, new_vpnbun)

	log_admin("[key_name(usr)] переключил блокиратор ВПН'а, теперь он [new_vpnbun ? "Включен" : "Выключен"]")
	message_admins("[key_name_admin(usr)] переключил блокиратор ВПН'а, теперь он [new_vpnbun ? "Включен" : "Выключен"].")
	SSblackbox.record_feedback("nested tally", "vpn_toggle", 1, list("Переключить блокиратор ВПН'а", "[new_vpnbun ? "Включен" : "Выключен"]"))
	send2adminchat("Блокировака ВПН'а", "[key_name(usr)] переключил блокиратор ВПН'а, теперь он [new_vpnbun ? "Включен" : "Выключен"].")

/client/proc/addvpnbypass(ckeytobypass as text)
	set category = "Специальные возможности"
	set name = "Добавить в обход ВПН'а"
	set desc = "Добавляет сикей в список обхода блокиратора ВПН'а."
	if(!CONFIG_GET(flag/kick_vpn))
		to_chat(usr, span_adminnotice("Блокиратор ВПН'а выключен!"))

	var/datum/config_entry/multi_keyed_flag/vpn_bypass/bypasses = CONFIG_GET_ENTRY(multi_keyed_flag/vpn_bypass)
	bypasses.add_bypass(ckeytobypass)
	log_admin("[key_name(usr)] добавил [ckeytobypass] в данный на этот раунд список обхода блокиратора ВПН'а.")
	message_admins("[key_name_admin(usr)] добавил [ckeytobypass] в данный на этот раунд список обхода блокиратора ВПН'а.")
	send2adminchat("Блокиратор ВПН'а", "[key_name(usr)] добавил [ckeytobypass] в данный на этот раунд список обхода блокиратора ВПН'а.")

/client/proc/revokevpnbypass(ckeytobypass as text)
	set category = "Специальные возможности"
	set name = "Отозвать из обхода ВПН'а"
	set desc = "Убирает сикей из списка для обхода ВПН блокиратор."
	if(!CONFIG_GET(flag/kick_vpn))
		to_chat(usr, span_adminnotice("Блокиратор ВПН'а выключен!"))

	var/datum/config_entry/multi_keyed_flag/vpn_bypass/bypasses = CONFIG_GET_ENTRY(multi_keyed_flag/vpn_bypass)
	bypasses.rev_bypass(ckeytobypass)
	log_admin("[key_name(usr)] убрал [ckeytobypass] из данный на этот раунд списка обхода блокиратора ВПН'а.")
	message_admins("[key_name_admin(usr)] убрал [ckeytobypass] из данный на этот раунд списка обхода блокиратора ВПН'а.")
	send2adminchat("Блокиратор ВПН'а", "[key_name(usr)] убрал [ckeytobypass] из данный на этот раунд списка обхода блокиратора ВПН'а.")
