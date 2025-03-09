//this works as is to create a single checked item, but has no back end code for toggleing the check yet
#define TOGGLE_CHECKBOX(PARENT, CHILD) PARENT/CHILD/abstract = TRUE;PARENT/CHILD/checkbox = CHECKBOX_TOGGLE;PARENT/CHILD/verb/CHILD

//Example usage TOGGLE_CHECKBOX(datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()

//override because we don't want to save preferences twice.
/datum/verbs/menu/Settings/Set_checked(client/C, verbpath)
	if (checkbox == CHECKBOX_GROUP)
		C.prefs.menuoptions[type] = verbpath
	else if (checkbox == CHECKBOX_TOGGLE)
		var/checked = Get_checked(C)
		C.prefs.menuoptions[type] = !checked
		winset(C, "[verbpath]", "is-checked = [!checked]")

/datum/verbs/menu/Settings/verb/setup_character()
	set name = "Настройки Игры"
	set category = "Preferences"
	set desc = "Открывает настройки игры"
	usr.client.prefs.current_tab = 1
	usr.client.prefs.ShowChoices(usr)

//toggles
/datum/verbs/menu/Settings/Ghost/chatterbox
	name = "Спам чата"

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_ears)()
	set name = "Вкл/выкл Уши"
	set category = "Preferences.Ghost"
	set desc = "Слышать все"
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTEARS
	to_chat(usr, "Как призрак, вы теперь [(usr.client.prefs.chat_toggles & CHAT_GHOSTEARS) ? "будете слышать абсолютно всех" : "будете слышать только тех, кто рядом с вами"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Ears", "[usr.client.prefs.chat_toggles & CHAT_GHOSTEARS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_ears/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTEARS

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_sight)()
	set name = "Вкл/выкл Взгляд"
	set category = "Preferences.Ghost"
	set desc = "Видеть все эмоции"
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTSIGHT
	to_chat(usr, "Как призрак, вы теперь [(usr.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) ? "видите абсолютно все эмоции" : "видите эмоции только тех, кто рядом с вами"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Sight", "[usr.client.prefs.chat_toggles & CHAT_GHOSTSIGHT ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_sight/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTSIGHT

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_whispers)()
	set name = "Вкл/выкл Шептание"
	set category = "Preferences.Ghost"
	set desc = "Видеть все шептания"
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTWHISPER
	to_chat(usr, "Как призрак, вы теперь [(usr.client.prefs.chat_toggles & CHAT_GHOSTWHISPER) ? "видите абсолютно все шептания" : "видите шептания только тех, кто рядом с вами"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Whispers", "[usr.client.prefs.chat_toggles & CHAT_GHOSTWHISPER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_whispers/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTWHISPER

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_radio)()
	set name = "Вкл/выкл Радиопереговоры"
	set category = "Preferences.Ghost"
	set desc = "Видеть все радио переговоры"
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTRADIO
	to_chat(usr, "Как призрак, вы теперь [(usr.client.prefs.chat_toggles & CHAT_GHOSTRADIO) ? "видите абсолютно все радиопереговоры" : "не видите радиопереговоры"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Radio", "[usr.client.prefs.chat_toggles & CHAT_GHOSTRADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc! //social experiment, increase the generation whenever you copypaste this shamelessly GENERATION 1
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_radio/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTRADIO

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox, toggle_ghost_pda)()
	set name = "Вкл/выкл КПК"
	set category = "Preferences.Ghost"
	set desc = "видеть все сообщения с КПК"
	usr.client.prefs.chat_toggles ^= CHAT_GHOSTPDA
	to_chat(usr, "Как призрак, вы теперь видите [(usr.client.prefs.chat_toggles & CHAT_GHOSTPDA) ? "все сообщения с КПК" : "видите лишь сообщения с КПК рядом с вами"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost PDA", "[usr.client.prefs.chat_toggles & CHAT_GHOSTPDA ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/chatterbox/toggle_ghost_pda/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_GHOSTPDA

/datum/verbs/menu/Settings/Ghost/chatterbox/Events
	name = "Events"

//please be aware that the following two verbs have inverted stat output, so that "Toggle Deathrattle|1" still means you activated it
TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox/Events, toggle_deathrattle)()
	set name = "Переключить Агонию"
	set category = "Preferences.Ghost"
	set desc = "Смерть"
	usr.client.prefs.toggles ^= DISABLE_DEATHRATTLE
	usr.client.prefs.save_preferences()
	to_chat(usr, "Теперь вы [(usr.client.prefs.toggles & DISABLE_DEATHRATTLE) ? "больше не будете" : "будете"] получать сообщения о агонии.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Deathrattle", "[!(usr.client.prefs.toggles & DISABLE_DEATHRATTLE) ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, maybe you should spend some time reading the comments.
/datum/verbs/menu/Settings/Ghost/chatterbox/Events/toggle_deathrattle/Get_checked(client/C)
	return !(C.prefs.toggles & DISABLE_DEATHRATTLE)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost/chatterbox/Events, toggle_arrivalrattle)()
	set name = "Переключить Прибытие"
	set category = "Preferences.Ghost"
	set desc = "Прибытие нового игрока"
	usr.client.prefs.toggles ^= DISABLE_ARRIVALRATTLE
	to_chat(usr, "Теперь вы [(usr.client.prefs.toggles & DISABLE_ARRIVALRATTLE) ? "больше не будете" : "будете"] получать сообщения когда кто-то прибудет на станцию.")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Arrivalrattle", "[!(usr.client.prefs.toggles & DISABLE_ARRIVALRATTLE) ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, maybe you should rethink where your life went so wrong.
/datum/verbs/menu/Settings/Ghost/chatterbox/Events/toggle_arrivalrattle/Get_checked(client/C)
	return !(C.prefs.toggles & DISABLE_ARRIVALRATTLE)

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Ghost, togglemidroundantag)()
	set name = "Переключить Среднераундового антагониста"
	set category = "Preferences"
	set desc = "Среднераундовый антагонист"
	usr.client.prefs.toggles ^= MIDROUND_ANTAG
	usr.client.prefs.save_preferences()
	to_chat(usr, "Теперь вы [(usr.client.prefs.toggles & MIDROUND_ANTAG) ? "будете" : "больше не будете"] выбрано на роль среднераундового антагониста.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Midround Antag", "[usr.client.prefs.toggles & MIDROUND_ANTAG ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Ghost/togglemidroundantag/Get_checked(client/C)
	return C.prefs.toggles & MIDROUND_ANTAG

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggletitlemusic)()
	set name = "Вкл/Выкл Музыка в лобби"
	set category = "Preferences.Sounds"
	set desc = "Слышать музыку в лобби"
	usr.client.prefs.toggles ^= SOUND_LOBBY
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_LOBBY)
		to_chat(usr, "Теперь вы слышите музыку в лобби.")
		if(isnewplayer(usr))
			usr.client.playtitlemusic()
	else
		to_chat(usr, "Больше не слышите музыку в лобби.")
		usr.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Lobby Music", "[usr.client.prefs.toggles & SOUND_LOBBY ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggletitlemusic/Get_checked(client/C)
	return C.prefs.toggles & SOUND_LOBBY

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, togglemidis)()
	set name = "Вкл/Выкл Миди"
	set category = "Preferences.Sounds"
	set desc = "Слышать звуки, активируемые админами (Midis)"
	usr.client.prefs.toggles ^= SOUND_MIDI
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_MIDI)
		to_chat(usr, "Теперь вы слышите музыку включенную админами.")
	else
		to_chat(usr, "Теперь вы не слышите музыку включенную админами")
		usr.stop_sound_channel(CHANNEL_ADMIN)
		var/client/C = usr.client
		C?.tgui_panel?.stop_music()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Hearing Midis", "[usr.client.prefs.toggles & SOUND_MIDI ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/togglemidis/Get_checked(client/C)
	return C.prefs.toggles & SOUND_MIDI


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_instruments)()
	set name = "Вкл/Выкл Инструментарий"
	set category = "Preferences.Sounds"
	set desc = "Слышать инструментарии"
	usr.client.prefs.toggles ^= SOUND_INSTRUMENTS
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_INSTRUMENTS)
		to_chat(usr, "Теперь вы слышите музыкальные инструменты.")
	else
		to_chat(usr, "Теперь вы не слышите музыкальные инструменты.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Instruments", "[usr.client.prefs.toggles & SOUND_INSTRUMENTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_instruments/Get_checked(client/C)
	return C.prefs.toggles & SOUND_INSTRUMENTS

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_jukeboxes)()
	set name = "Вкл/Выкл Бумбоксы"
	set category = "Preferences.Sounds"
	set desc = "Слышать бумбоксы"
	usr.client.prefs.toggles ^= SOUND_JUKEBOXES
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_JUKEBOXES)
		to_chat(usr, "Теперь вы слышите бумбоксы.")
	else
		to_chat(usr, "Теперь вы не слышите бумбоксы.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Jukeboxes", "[usr.client.prefs.toggles & SOUND_JUKEBOXES ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/Sound/toggle_jukeboxes/Get_checked(client/C)
	return C.prefs.toggles & SOUND_JUKEBOXES

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, Toggle_Soundscape)()
	set name = "Вкл/Выкл Эмбиент"
	set category = "Preferences.Sounds"
	set desc = "Слышать эмбиент"
	usr.client.prefs.toggles ^= SOUND_AMBIENCE
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_AMBIENCE)
		to_chat(usr, "Теперь вы слышите эмбиент.")
	else
		to_chat(usr, "Теперь вы не слышите эмбиент.")
		SSambience.remove_ambience_client(src)
		usr.stop_sound_channel(CHANNEL_AMBIENCE)
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ambience", "[usr.client.prefs.toggles & SOUND_AMBIENCE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/Toggle_Soundscape/Get_checked(client/C)
	return C.prefs.toggles & SOUND_AMBIENCE


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_ship_ambience)()
	set name = "Вкл/Выкл Постояннный эмбиент"
	set category = "Preferences.Sounds"
	set desc = "Слышать постоянный эмбиент"
	usr.client.prefs.toggles ^= SOUND_SHIP_AMBIENCE
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE)
		to_chat(usr, "Теперь вы слышите постоянный эмбиент.")
	else
		to_chat(usr, "Теперь вы не слышите постоянный эмбиент.")
		usr.stop_sound_channel(CHANNEL_BUZZ)
		usr.client.ambience_playing = 0
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Constant Ambience", "[usr.client.prefs.toggles & SOUND_SHIP_AMBIENCE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, I bet you read this comment expecting to see the same thing :^)
/datum/verbs/menu/Settings/Sound/toggle_ship_ambience/Get_checked(client/C)
	return C.prefs.toggles & SOUND_SHIP_AMBIENCE


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_announcement_sound)()
	set name = "Вкл/Выкл Звук уведомлений"
	set category = "Preferences.Sounds"
	set desc = "Слышать звук объявлений"
	usr.client.prefs.toggles ^= SOUND_ANNOUNCEMENTS
	to_chat(usr, "You will now [(usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS) ? "hear announcement sounds" : "no longer hear announcements"].")
	usr.client.prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Announcement Sound", "[usr.client.prefs.toggles & SOUND_ANNOUNCEMENTS ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/Sound/toggle_announcement_sound/Get_checked(client/C)
	return C.prefs.toggles & SOUND_ANNOUNCEMENTS


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggleprayersounds)()
	set name = "Вкл/Выкл Звуки игроков"
	set category = "Preferences.Sounds"
	set desc = "Слышать звуки игроков"
	usr.client.prefs.toggles ^= SOUND_PRAYERS
	usr.client.prefs.save_preferences()
	if(usr.client.prefs.toggles & SOUND_PRAYERS)
		to_chat(usr, "Теперь вы слышите звуки игроков.")
	else
		to_chat(usr, "Теперь вы не слышите звуки игроков.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Sounds", "[usr.client.prefs.toggles & SOUND_PRAYERS ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/Sound/toggleprayersounds/Get_checked(client/C)
	return C.prefs.toggles & SOUND_PRAYERS


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings/Sound, toggle_bark)()
	set name = "Вкл/Выкл Барки"
	set category = "Preferences.Sounds"
	set desc = "Слышать барки"
	usr.client.prefs.toggles ^= SOUND_BARK
	usr.client.prefs.save_preferences()
	to_chat(usr, "Теперь вы [(usr.client.prefs.toggles & SOUND_BARK) ? "слышите" : "больше не слышите"] барки во время разговора игроков.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Vocal Barks", "[usr.client.prefs.toggles & SOUND_BARK ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/Sound/toggle_bark/Get_checked(client/C)
	return C.prefs.toggles & SOUND_BARK

/datum/verbs/menu/Settings/Sound/verb/stop_client_sounds()
	set name = "Остановить звуки"
	set category = "Preferences.Sounds"
	set desc = "Останавливает все звуки"
	SEND_SOUND(usr, sound(null))
	var/client/C = usr.client
	C?.tgui_panel?.stop_music()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Stop Self Sounds")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_ooc)()
	set name = "Вкл/Выкл Показ ООС"
	set category = "Preferences.OOC"
	set desc = "Показать ООС"
	usr.client.prefs.chat_toggles ^= CHAT_OOC
	usr.client.prefs.save_preferences()
	to_chat(usr, "Теперь вы [(usr.client.prefs.chat_toggles & CHAT_OOC) ? "видите" : "не видете"] ООС чат.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Seeing OOC", "[usr.client.prefs.chat_toggles & CHAT_OOC ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/datum/verbs/menu/Settings/listen_ooc/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_OOC

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_looc)()
	set name = "Вкл/Выкл показ LOOC"
	set category = "Preferences.OOC"
	set desc = "Показ LOOC"
	usr.client.prefs.chat_toggles ^= CHAT_LOOC
	usr.client.prefs.save_preferences()
	to_chat(usr, "Теперь вы [(usr.client.prefs.chat_toggles & CHAT_LOOC) ? "видете" : "не видете"] LOOC чат.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Seeing LOOC", "[usr.client.prefs.chat_toggles & CHAT_LOOC ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/listen_ooc/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_LOOC

TOGGLE_CHECKBOX(/datum/verbs/menu/Settings, listen_bank_card)()
	set name = "Показать/убрать уведомление дохода"
	set category = "Настройки"
	set desc = "Показывает или убирает обновления вашего дохода"
	usr.client.prefs.chat_toggles ^= CHAT_BANKCARD
	usr.client.prefs.save_preferences()
	to_chat(usr, "Теперь вы [(usr.client.prefs.chat_toggles & CHAT_BANKCARD) ? "будите" : "больше не будите"] уведомлены о доходе.")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Income Notifications", "[(usr.client.prefs.chat_toggles & CHAT_BANKCARD) ? "Enabled" : "Disabled"]"))
/datum/verbs/menu/Settings/listen_bank_card/Get_checked(client/C)
	return C.prefs.chat_toggles & CHAT_BANKCARD

GLOBAL_LIST_INIT(ghost_forms, list("ghost","ghostking","ghostian2","skeleghost","ghost_red","ghost_black", \
							"ghost_blue","ghost_yellow","ghost_green","ghost_pink", \
							"ghost_cyan","ghost_dblue","ghost_dred","ghost_dgreen", \
							"ghost_dcyan","ghost_grey","ghost_dyellow","ghost_dpink", "ghost_purpleswirl","ghost_funkypurp","ghost_pinksherbert","ghost_blazeit",\
							"ghost_mellow","ghost_rainbow","ghost_camo","ghost_fire", "catghost"))
/client/proc/pick_form()
	if(!is_content_unlocked())
		alert("Это только для людей с BYOND premuim.")
		return
	var/new_form = input(src, "Спасибо за поддержку BYOND - Выберете форму вашего призрака:","Спасибо за поддержку BYOND",null) as null|anything in GLOB.ghost_forms
	if(new_form)
		prefs.ghost_form = new_form
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_icon(new_form)

GLOBAL_LIST_INIT(ghost_orbits, list(GHOST_ORBIT_CIRCLE,GHOST_ORBIT_TRIANGLE,GHOST_ORBIT_SQUARE,GHOST_ORBIT_HEXAGON,GHOST_ORBIT_PENTAGON))

/client/proc/pick_ghost_orbit()
	if(!is_content_unlocked())
		alert("Это только для людей с BYOND premuim.")
		return
	var/new_orbit = input(src, "Спасибо за поддержку BYOND - Выберете тип вашей орбиты:","Спасибо за поддержку BYOND",null) as null|anything in GLOB.ghost_orbits
	if(new_orbit)
		prefs.ghost_orbit = new_orbit
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.ghost_orbit = new_orbit

/client/proc/pick_ghost_accs()
	var/new_ghost_accs = alert("Хотите ли вы, чтобы ваш призрак показывал полные аксессуары, где это возможно, скрывал аксессуары, но все равно использовал направленные спрайты, где это возможно, или также игнорировать направления и придерживаться спрайтов по умолчанию?",,"полные аксессуары", "только направленные спрайты", "спрайты по умолчанию")
	if(new_ghost_accs)
		switch(new_ghost_accs)
			if("полные аксессуары")
				prefs.ghost_accs = GHOST_ACCS_FULL
			if("только направленные спрайты")
				prefs.ghost_accs = GHOST_ACCS_DIR
			if("спрайты по умолчанию")
				prefs.ghost_accs = GHOST_ACCS_NONE
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_icon()

/client/verb/pick_ghost_customization()
	set name = "Кастомизация призрака"
	set category = "Preferences.Ghost"
	set desc = "Кастомизируйте вашего призрака."
	if(is_content_unlocked())
		switch(alert("Какую настройку вы хотите изменить?",,"Форма призрака","Орбита призрака","Аксессуары призрака"))
			if("Форма призрака")
				pick_form()
			if("Орбита призрака")
				pick_ghost_orbit()
			if("Аксессуары призрака")
				pick_ghost_accs()
	else
		pick_ghost_accs()

/client/verb/pick_ghost_others()
	set name = "Призраки других"
	set category = "Preferences.Ghost"
	set desc = "Изменение отображение других призраков."
	var/new_ghost_others = alert("Хотите ли вы, чтобы призраки других людей отображались в их собственных настройках, в качестве спрайтов по умолчанию или всегда в виде белого призрака по умолчанию?",,"Их настройки", "Спрайты по умолчанию", "Белый призрак")
	if(new_ghost_others)
		switch(new_ghost_others)
			if("Их настройки")
				prefs.ghost_others = GHOST_OTHERS_THEIR_SETTING
			if("Спрайты по умолчанию")
				prefs.ghost_others = GHOST_OTHERS_DEFAULT_SPRITE
			if("Белый призрак")
				prefs.ghost_others = GHOST_OTHERS_SIMPLE
		prefs.save_preferences()
		if(isobserver(mob))
			var/mob/dead/observer/O = mob
			O.update_sight()

/client/verb/toggle_intent_style()
	set name = "Toggle Intent Selection Style"
	set category = "Preferences"
	set desc = "Toggle between directly clicking the desired intent or clicking to rotate through."
	prefs.toggles ^= INTENT_STYLE
	to_chat(src, "[(prefs.toggles & INTENT_STYLE) ? "Clicking directly on intents selects them." : "Clicking on intents rotates selection clockwise."]")
	prefs.save_preferences()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Intent Selection", "[prefs.toggles & INTENT_STYLE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_hud_pref()
	set name = "Toggle Ghost HUD"
	set category = "Preferences.Ghost"
	set desc = "Hide/Show Ghost HUD"

	prefs.ghost_hud = !prefs.ghost_hud
	to_chat(src, "Ghost HUD will now be [prefs.ghost_hud ? "visible" : "hidden"].")
	prefs.save_preferences()
	if(isobserver(mob))
		mob.hud_used.show_hud()
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost HUD", "[prefs.ghost_hud ? "Enabled" : "Disabled"]"))

/client/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Preferences.Ghost"

	prefs.inquisitive_ghost = !prefs.inquisitive_ghost
	prefs.save_preferences()
	if(prefs.inquisitive_ghost)
		to_chat(src, "<span class='notice'>You will now examine everything you click on.</span>")
	else
		to_chat(src, "<span class='notice'>You will no longer examine things you click on.</span>")
	SSblackbox.record_feedback("nested tally", "preferences_verb", 1, list("Toggle Ghost Inquisitiveness", "[prefs.inquisitive_ghost ? "Enabled" : "Disabled"]"))

//Admin Preferences
/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences.Admin"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!holder)
		return
	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Adminhelp Sound", "[prefs.toggles & SOUND_ADMINHELP ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleannouncelogin()
	set name = "Do/Don't Announce Login"
	set category = "Preferences.Admin"
	set desc = "Toggle if you want an announcement to admins when you login during a round"
	if(!holder)
		return
	prefs.toggles ^= ANNOUNCE_LOGIN
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & ANNOUNCE_LOGIN) ? "now" : "no longer"] have an announcement to other admins when you login.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Login Announcement", "[prefs.toggles & ANNOUNCE_LOGIN ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_hear_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Preferences.Admin"
	set desc = "Toggle seeing radiochatter from nearby radios and speakers"
	if(!holder)
		return
	prefs.chat_toggles ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.chat_toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from nearby radios or speakers")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Radio Chatter", "[prefs.chat_toggles & CHAT_RADIO ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/deadchat()
	set name = "Show/Hide Deadchat"
	set category = "Preferences.Admin"
	set desc ="Toggles seeing deadchat"
	prefs.chat_toggles ^= CHAT_DEAD
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Deadchat Visibility", "[prefs.chat_toggles & CHAT_DEAD ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences.Admin"
	set desc = "Toggles seeing prayers"
	prefs.chat_toggles ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.chat_toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Prayer Visibility", "[prefs.chat_toggles & CHAT_PRAYER ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
