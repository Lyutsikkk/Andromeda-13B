/// The default command report announcement sound.
#define DEFAULT_ANNOUNCEMENT_SOUND "default_announcement"

/// Preset central command names to chose from for centcom reports.
#define CENTCOM_PRESET "Центральное Командование"
#define SYNDICATE_PRESET "Триглав"
#define WIZARD_PRESET "Космическая Федерация Магов"
#define CUSTOM_PRESET "Введите Текст"

// ^ ^ ^ BlueMoon edit

/client/proc/cmd_admin_drop_everything(mob/M in GLOB.mob_list)
	set category = null
	set name = "Drop Everything"
	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		if(!M.dropItemToGround(W))
			qdel(W)
			M.regenerate_icons()

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	var/msg = "[key_name_admin(usr)] made [ADMIN_LOOKUPFLW(M)] drop everything!"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Drop Everything") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// Unless I am dent-skulled, there is no way to do (mob/M in GLOB.mob_list, someothervar) with context-menu buttons, hence the instant proc call.
/client/proc/cmd_admin_subtle_message(mob/M in GLOB.mob_list)
	set category = "Админ.Ивенты"
	set name = "Subtle Message"

	cmd_admin_subtle_headset_message(M)

/client/proc/cmd_admin_mod_antag_rep(client/C in GLOB.clients, var/operation)
	set category = "Special Verbs"
	set name = "Modify Antagonist Reputation"

	if(!check_rights(R_ADMIN))
		return

	var/msg = ""
	var/log_text = ""

	if(operation == "zero")
		log_text = "Set to 0"
		SSpersistence.antag_rep -= C.ckey
	else
		var/prompt = "Please enter the amount of reputation to [operation]:"

		if(operation == "set")
			prompt = "Please enter the new reputation value:"

		msg = input("Message:", prompt) as num|null

		if (!msg)
			return

		var/ANTAG_REP_MAXIMUM = CONFIG_GET(number/antag_rep_maximum)

		if(operation == "set")
			log_text = "Set to [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(0, min(msg, ANTAG_REP_MAXIMUM))
		else if(operation == "add")
			log_text = "Added [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = min(SSpersistence.antag_rep[C.ckey]+msg, ANTAG_REP_MAXIMUM)
		else if(operation == "subtract")
			log_text = "Subtracted [num2text(msg)]"
			SSpersistence.antag_rep[C.ckey] = max(SSpersistence.antag_rep[C.ckey]-msg, 0)
		else
			to_chat(src, "Invalid operation for antag rep modification: [operation] by user [key_name(usr)]")
			return

		if(SSpersistence.antag_rep[C.ckey] <= 0)
			SSpersistence.antag_rep -= C.ckey

	log_admin("[key_name(usr)]: Modified [key_name(C)]'s antagonist reputation [log_text]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)]: Modified [key_name(C)]'s antagonist reputation ([log_text])</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Modify Antagonist Reputation") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_world_narrate()
	set category = "Админ.Ивенты"
	set name = "Global Narrate"

	if(!check_rights(R_ADMIN))
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text|null

	if (!msg)
		return
	to_chat(world, "[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] Sent a global narrate</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Global Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(mob/M)
	set category = "Админ.Ивенты"
	set name = "Direct Narrate"

	if(!check_rights(R_ADMIN))
		return

	if(!M)
		M = input("Direct narrate to whom?", "Active Players") as null|anything in GLOB.player_list

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text|null

	if( !msg )
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	msg = "<span class='adminnotice'><b> DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]):</b> [msg]<BR></span>"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Direct Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_local_narrate(atom/A)
	set category = "Админ.Ивенты"
	set name = "Local Narrate"

	if(!check_rights(R_ADMIN))
		return
	if(!A)
		return
	var/range = input("Range:", "Narrate to mobs within how many tiles:", 7) as num|null
	if(!range)
		return
	var/msg = input("Message:", text("Enter the text you wish to appear to everyone within view:")) as text|null
	if (!msg)
		return
	for(var/mob/M in view(range,A))
		to_chat(M, msg)

	log_admin("LocalNarrate: [key_name(usr)] at [AREACOORD(A)]: [msg]")
	message_admins("<span class='adminnotice'><b> LocalNarrate: [key_name_admin(usr)] at [ADMIN_VERBOSEJMP(A)]:</b> [msg]<BR></span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Local Narrate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M in GLOB.mob_list)
	set category = "Админ.Игра"
	set name = "Godmode"
	if(!check_rights(R_ADMIN))
		return

	M.status_flags ^= GODMODE
	to_chat(usr, "<span class='adminnotice'>Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]</span>")

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	var/msg = "[key_name_admin(usr)] has toggled [ADMIN_LOOKUPFLW(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Godmode", "[M.status_flags & GODMODE ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/proc/cmd_admin_mute(whom, mute_type, automute = 0)
	if(!whom)
		return

	var/muteunmute
	var/mute_string
	var/feedback_string
	switch(mute_type)
		if(MUTE_IC)
			mute_string = "IC (say and emote)"
			feedback_string = "IC"
		if(MUTE_OOC)
			mute_string = "OOC"
			feedback_string = "OOC"
		if(MUTE_PRAY)
			mute_string = "pray"
			feedback_string = "Pray"
		if(MUTE_ADMINHELP)
			mute_string = "adminhelp, admin PM and ASAY"
			feedback_string = "Adminhelp"
		if(MUTE_DEADCHAT)
			mute_string = "deadchat and DSAY"
			feedback_string = "Deadchat"
		if(MUTE_ALL)
			mute_string = "everything"
			feedback_string = "Everything"
		else
			return

	var/client/C
	if(istype(whom, /client))
		C = whom
	else if(istext(whom))
		C = GLOB.directory[whom]
	else
		return

	var/datum/preferences/P
	if(C)
		P = C.prefs
	else
		P = GLOB.preferences_datums[whom]
	if(!P)
		return

	if(automute)
		if(!CONFIG_GET(flag/automute_on))
			return
	else
		if(!check_rights())
			return

	if(automute)
		muteunmute = "auto-muted"
		P.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(whom)] from [mute_string]")
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(whom)] from [mute_string].")
		if(C)
			to_chat(C, "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin.")
		SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Auto Mute [feedback_string]", "1")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return

	if(P.muted & mute_type)
		muteunmute = "unmuted"
		P.muted &= ~mute_type
	else
		muteunmute = "muted"
		P.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(whom)] from [mute_string]")
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(whom)] from [mute_string].")
	if(C)
		to_chat(C, "You have been [muteunmute] from [mute_string] by [key_name(usr, include_name = FALSE)].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Mute [feedback_string]", "[P.muted & mute_type]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


//I use this proc for respawn character too. /N
/proc/create_xeno(ckey)
	if(!ckey)
		var/list/candidates = list()
		for(var/mob/M in GLOB.player_list)
			if(M.stat != DEAD)
				continue	//we are not dead!
			if(!(ROLE_ALIEN in M.client.prefs.be_special))
				continue	//we don't want to be an alium
			if(M.client.is_afk())
				continue	//we are afk
			if(M.mind && M.mind.current && M.mind.current.stat != DEAD)
				continue	//we have a live body we are tied to
			candidates += M.ckey
		if(candidates.len)
			ckey = input("Pick the player you want to respawn as a xeno.", "Suitable Candidates") as null|anything in candidates
		else
			to_chat(usr, "<span class='danger'>Error: create_xeno(): no suitable candidates.</span>")
	if(!istext(ckey))
		return FALSE

	var/alien_caste = input(usr, "Please choose which caste to spawn.","Pick a caste",null) as null|anything in list("Queen","Praetorian","Hunter","Sentinel","Drone","Larva")
	var/obj/effect/landmark/spawn_here = GLOB.xeno_spawn.len ? pick(GLOB.xeno_spawn) : null
	var/mob/living/carbon/alien/new_xeno
	switch(alien_caste)
		if("Queen")
			new_xeno = new /mob/living/carbon/alien/humanoid/royal/queen(spawn_here)
		if("Praetorian")
			new_xeno = new /mob/living/carbon/alien/humanoid/royal/praetorian(spawn_here)
		if("Hunter")
			new_xeno = new /mob/living/carbon/alien/humanoid/hunter(spawn_here)
		if("Sentinel")
			new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(spawn_here)
		if("Drone")
			new_xeno = new /mob/living/carbon/alien/humanoid/drone(spawn_here)
		if("Larva")
			new_xeno = new /mob/living/carbon/alien/larva(spawn_here)
		else
			return FALSE
	if(!spawn_here)
		SSjob.SendToLateJoin(new_xeno, FALSE)

	new_xeno.ckey = ckey
	var/msg = "<span class='notice'>[key_name_admin(usr)] has spawned [ckey] as a filthy xeno [alien_caste].</span>"
	message_admins(msg)
	admin_ticket_log(new_xeno, msg)
	return TRUE

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = "Админ.Игра"
	set name = "Respawn Character"
	set desc = "Respawn a person that has been gibbed/dusted/killed. They must be a ghost for this to work and preferably should not have a body to go back into."
	if(!check_rights(R_ADMIN))
		return

	var/input = ckey(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return

	var/mob/dead/observer/G_found
	for(var/mob/dead/observer/G in GLOB.player_list)
		if(G.ckey == input)
			G_found = G
			break

	if(!G_found)//If a ghost was not found.
		to_chat(usr, "<font color='red'>There is no active key like that in the game or the person is not currently a ghost.</font>")
		return

	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		//Check if they were an alien
		if(G_found.mind.assigned_role == ROLE_ALIEN)
			if(alert("This character appears to have been an alien. Would you like to respawn them as such?",,"Да","Нет")=="Yes")
				var/turf/T
				if(GLOB.xeno_spawn.len)
					T = pick(GLOB.xeno_spawn)

				var/mob/living/carbon/alien/new_xeno
				switch(G_found.mind.special_role)//If they have a mind, we can determine which caste they were.
					if("Hunter")
						new_xeno = new /mob/living/carbon/alien/humanoid/hunter(T)
					if("Sentinel")
						new_xeno = new /mob/living/carbon/alien/humanoid/sentinel(T)
					if("Drone")
						new_xeno = new /mob/living/carbon/alien/humanoid/drone(T)
					if("Praetorian")
						new_xeno = new /mob/living/carbon/alien/humanoid/royal/praetorian(T)
					if("Queen")
						new_xeno = new /mob/living/carbon/alien/humanoid/royal/queen(T)
					else//If we don't know what special role they have, for whatever reason, or they're a larva.
						create_xeno(G_found.ckey)
						return

				if(!T)
					SSjob.SendToLateJoin(new_xeno, FALSE)

				//Now to give them their mind back.
				G_found.mind.transfer_to(new_xeno)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				G_found.transfer_ckey(new_xeno, FALSE)
				to_chat(new_xeno, "You have been fully respawned. Enjoy the game.")
				var/msg = "<span class='adminnotice'>[key_name_admin(usr)] has respawned [new_xeno.key] as a filthy xeno.</span>"
				message_admins(msg)
				admin_ticket_log(new_xeno, msg)
				return	//all done. The ghost is auto-deleted

		//check if they were a monkey
		else if(findtext(G_found.real_name,"monkey"))
			if(alert("This character appears to have been a monkey. Would you like to respawn them as such?",,"Да","Нет")=="Yes")
				var/mob/living/carbon/monkey/new_monkey = new
				SSjob.SendToLateJoin(new_monkey)
				G_found.mind.transfer_to(new_monkey)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				G_found.transfer_ckey(new_monkey, FALSE)
				to_chat(new_monkey, "You have been fully respawned. Enjoy the game.")
				var/msg = "<span class='adminnotice'>[key_name_admin(usr)] has respawned [new_monkey.key] as a filthy xeno.</span>"
				message_admins(msg)
				admin_ticket_log(new_monkey, msg)
				return	//all done. The ghost is auto-deleted


	//Ok, it's not a xeno or a monkey. So, spawn a human.
	var/mob/living/carbon/human/new_character = new//The mob being spawned.
	SSjob.SendToLateJoin(new_character)

	var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through GLOB.data_core.
		This isn't an exact science but it does the trick more often than not.*/
		var/id = md5("[G_found.real_name][G_found.mind.assigned_role]")

		record_found = find_record("id", id, GLOB.data_core.locked)

	if(record_found)//If they have a record we can determine a few things.
		new_character.real_name = record_found.fields["name"]
		new_character.gender = record_found.fields["gender"]
		new_character.age = record_found.fields["age"]
		new_character.hardset_dna(record_found.fields["identity"], record_found.fields["enzymes"], null, record_found.fields["name"], record_found.fields["blood_type"], new record_found.fields["species"], record_found.fields["features"])
	else
		var/datum/preferences/A = new()
		A.copy_to(new_character)
		A.real_name = G_found.real_name
		new_character.dna.update_dna_identity()

	new_character.name = new_character.real_name

	if(G_found.mind && !G_found.mind.active)
		G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the mind isn't in use
	else
		new_character.mind_initialize()
	if(!new_character.mind.assigned_role)
		new_character.mind.assigned_role = "Assistant"//If they somehow got a null assigned role.

	G_found.transfer_ckey(new_character, FALSE)

	/*
	The code below functions with the assumption that the mob is already a traitor if they have a special role.
	So all it does is re-equip the mob with powers and/or items. Or not, if they have no special role.
	If they don't have a mind, they obviously don't have a special role.
	*/

	//Two variables to properly announce later on.
	var/admin = key_name_admin(src)
	var/player_key = G_found.key

	//Now for special roles and equipment.
	var/datum/antagonist/traitor/traitordatum = new_character.mind.has_antag_datum(/datum/antagonist/traitor)
	if(traitordatum)
		SSjob.EquipRank(new_character, new_character.mind.assigned_role, 1)
		traitordatum.equip()


	switch(new_character.mind.special_role)
		if(ROLE_WIZARD)
			new_character.forceMove(pick(GLOB.wizardstart))
			var/datum/antagonist/wizard/A = new_character.mind.has_antag_datum(/datum/antagonist/wizard,TRUE)
			A.equip_wizard()
		if(ROLE_INTEQ)
			new_character.forceMove(pick(GLOB.nukeop_start))
			var/datum/antagonist/nukeop/N = new_character.mind.has_antag_datum(/datum/antagonist/nukeop,TRUE)
			N.equip_op()
		if(ROLE_SLAVER)
			new_character.forceMove(pick(GLOB.slaver_start))
			var/datum/antagonist/slaver/S = new_character.mind.has_antag_datum(/datum/antagonist/slaver,TRUE)
			S.equip_slaver()
		if(ROLE_NINJA)
			var/list/ninja_spawn = list()
			for(var/obj/effect/landmark/carpspawn/L in GLOB.landmarks_list)
				ninja_spawn += L
			var/datum/antagonist/ninja/ninjadatum = new_character.mind.has_antag_datum(/datum/antagonist/ninja)
			ninjadatum.equip_space_ninja()
			if(ninja_spawn.len)
				new_character.forceMove(pick(ninja_spawn))

		else//They may also be a cyborg or AI.
			switch(new_character.mind.assigned_role)
				if("Cyborg")//More rigging to make em' work and check if they're traitor.
					new_character = new_character.Robotize(TRUE)
				if("AI")
					new_character = new_character.AIize()
				else
					SSjob.EquipRank(new_character, new_character.mind.assigned_role, 1)//Or we simply equip them.

	//Announces the character on all the systems, based on the record.
	if(!issilicon(new_character))//If they are not a cyborg/AI.
		if(!record_found&&new_character.mind.assigned_role!=new_character.mind.special_role)//If there are no records for them. If they have a record, this info is already in there. MODE people are not announced anyway.
			//Power to the user!
			if(alert(new_character,"Warning: No data core entry detected. Would you like to announce the arrival of this character by adding them to various databases, such as medical records?",,"No","Yes")=="Yes")
				GLOB.data_core.manifest_inject(new_character)

			if(alert(new_character,"Would you like an active AI to announce this character?",,"No","Yes")=="Yes")
				announce_arrival(new_character, new_character.mind.assigned_role)

	var/msg = "<span class='adminnotice'>[admin] has respawned [player_key] as [new_character.real_name].</span>"
	message_admins(msg)
	admin_ticket_log(new_character, msg)

	to_chat(new_character, "You have been fully respawned. Enjoy the game.")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Respawn Character") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return new_character

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Админ.Ивенты"
	set name = "Add Custom AI law"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null
	if(!input)
		return

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]")

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	var/announce_ion_laws = (show_log == "Yes" ? 100 : 0)

	var/datum/round_event/ion_storm/add_law_only/ion = new()
	ion.announce_chance = announce_ion_laws
	ion.ionMessage = input

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Add Custom AI Law") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_create_centcom_report()
	set category = "Админ.Ивенты"
	set name = "Create Command Report"

	if(!check_rights(R_ADMIN))
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Create Command Report") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//BlueMoon edit START
	var/datum/command_report_menu/tgui = new(usr)
	tgui.ui_interact(usr)
	//BlueMoon edit END

//BlueMoon edit START

/datum/command_report_menu
	/// The mob using the UI.
	var/mob/ui_user
	/// The name of central command that will accompany our report
	var/command_name = CENTCOM_PRESET
	/// Whether we are using a custom name instead of a preset.
	var/custom_name
	/// The actual contents of the report we're going to send.
	var/command_report_content
	/// Whether the report's contents are announced.
	var/announce_contents = TRUE
	/// The sound that's going to accompany our message.
	var/played_sound = DEFAULT_ANNOUNCEMENT_SOUND
	/// Custom Sound
	var/custom_sound
	/// A static list of preset names that can be chosen.
	var/list/preset_names = list(CENTCOM_PRESET, SYNDICATE_PRESET, WIZARD_PRESET, CUSTOM_PRESET)

/datum/command_report_menu/New(mob/user)
	ui_user = user
	if(command_name() != CENTCOM_PRESET)
		command_name = command_name()
		preset_names.Insert(1, command_name())

/datum/command_report_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/command_report_menu/ui_close()
	qdel(src)

/datum/command_report_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommandReport")
		ui.open()

/datum/command_report_menu/ui_data(mob/user)
	var/list/data = list()
	data["command_name"] = command_name
	data["custom_name"] = custom_name
	data["command_report_content"] = command_report_content
	data["announce_contents"] = announce_contents
	data["played_sound"] = played_sound

	return data

/datum/command_report_menu/ui_static_data(mob/user)
	var/list/data = list()
	data["command_name_presets"] = preset_names
	data["announcer_sounds"] = list(DEFAULT_ANNOUNCEMENT_SOUND) + GLOB.announcer_keys

	return data

/datum/command_report_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("update_command_name")
			if(params["updated_name"] == CUSTOM_PRESET)
				custom_name = TRUE
			else if (params["updated_name"] in preset_names)
				custom_name = FALSE

			command_name = params["updated_name"]
		if("set_report_sound")
			played_sound = params["picked_sound"]
		if("toggle_announce")
			announce_contents = !announce_contents
		if("submit_report")
			if(!command_name)
				to_chat(ui_user, span_danger("You can't send a report with no command name."))
				return
			if(!params["report"])
				to_chat(ui_user, span_danger("You can't send a report with no contents."))
				return
			command_report_content = params["report"]
			send_announcement()

			// Save this message to be shown on the TGUI command messages panel (centcom_communications.dm)
			var/list/message_log = list()
			message_log["message"] = command_report_content
			message_log["sender_name"] = command_name
			message_log["time_sent"] = world.time
			message_log["handled"] = TRUE
			LAZYADD(GLOB.centcom_communications_messages, list(message_log))

	return TRUE

/*
 * The actual proc that sends the priority announcement and reports
 *
 * Uses the variables set by the user on our datum as the arguments for the report.
 */
/datum/command_report_menu/proc/send_announcement()
	/// Our current command name to swap back to after sending the report.
	var/original_command_name = command_name()
	change_command_name(command_name)

	/// The sound we're going to play on report.
	var/report_sound = played_sound
	if(played_sound == DEFAULT_ANNOUNCEMENT_SOUND)
		report_sound = SSstation.announcer.get_rand_report_sound()

	if(announce_contents)
		priority_announce(command_report_content, null, report_sound, has_important_message = TRUE)
	print_command_report(command_report_content, "[announce_contents ? "" : "Секретно:"] [command_name]", !announce_contents)

	change_command_name(original_command_name)

	log_admin("[key_name(ui_user)] has created a command report: \"[command_report_content]\", sent from \"[command_name]\" with the sound \"[played_sound]\".")
	message_admins("[key_name_admin(ui_user)] has created a command report, sent from \"[command_name]\" with the sound \"[played_sound]\"")


#undef DEFAULT_ANNOUNCEMENT_SOUND

#undef CENTCOM_PRESET
#undef SYNDICATE_PRESET
#undef WIZARD_PRESET
#undef CUSTOM_PRESET

//BlueMoon edit END

/client/proc/cmd_admin_make_priority_announcement()
	set category = "Админ.Ивенты"
	set name = "Make Priority Announcement"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Enter a priority announcement. Ensure it makes sense IC.", "What?", "") as message|null
	if(!input)
		return

	var/title = input(src, "What should the title be?", "What?","") as text|null

	var/special_name = input(src, "Who is making the announcement?", "Who?", "") as text|null
	priority_announce(input, title, sender_override = special_name)

	log_admin("[key_name(src)] has sent a priority announcement: [input]")
	message_admins("[key_name_admin(src)] has made a priority announcement")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Priority Announcement") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_change_command_name()
	set category = "Админ.Ивенты"
	set name = "Change Command Name"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please input a new name for Central Command.", "What?", "") as text|null
	if(!input)
		return
	change_command_name(input)
	message_admins("[key_name_admin(src)] has changed Central Command's name to [input]")
	log_admin("[key_name(src)] has changed the Central Command name to: [input]")

/client/proc/cmd_admin_delete(atom/A as obj|mob|turf in world)
	set category = "Админ"
	set name = "Delete"

	if(!check_rights(R_SPAWN|R_DEBUG))
		return

	admin_delete(A)

/client/proc/cmd_admin_list_open_jobs()
	set category = "Админ.Игра"
	set name = "Manage Job Slots"

	if(!check_rights(R_ADMIN))
		return
	holder.manage_free_slots()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Manage Job Slots") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category =  "Admin.Fun"
	set name = "Explosion"

	if(!check_rights(R_ADMIN))
		return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null)
		return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null)
		return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null)
		return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null)
		return
	var/flames = input("Range of flames. -1 to none", text("Input"))  as num|null
	if(flames == null)
		return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1) || (flames != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20) || (flames > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash, null, null,flames)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(O)]")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(O)]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Explosion") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set category = "Админ.Веселье"
	set name = "EM Pulse"

	if(!check_rights(R_ADMIN))
		return

	var/range = input("Range.", text("Input"))  as num|null
	if(!range)
		return
	log_admin("[key_name(usr)] created an EM Pulse - log below") //because we'll just log the empulse itself
	message_admins("[key_name_admin(usr)] created an EM Pulse at [AREACOORD(O)] with range [range]")
	empulse_using_range(O, range, TRUE) //its details get shown too

	SSblackbox.record_feedback("tally", "admin_verb", 1, "EM Pulse") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_gib(mob/M in GLOB.mob_list)
	set category = "Админ.Веселье"
	set name = "Gib"

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Drop a brain?", "Confirm", "Yes", "No","Cancel")
	if(confirm == "Cancel")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(!M)
		return

	log_admin("[key_name(usr)] has gibbed [key_name(M)]")
	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(M)]")

	if(isobserver(M))
		new /obj/effect/gibspawner/generic(get_turf(M))
		return
	if(confirm == "Yes")
		M.gib()
	else
		M.gib(1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "Админ.Веселье"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		log_admin("[key_name(usr)] used gibself.")
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] used gibself.</span>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Gib Self") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		mob.gib(1, 1, 1)

/client/proc/cmd_admin_check_contents(mob/living/M in GLOB.mob_list)
	set category = "Special Verbs"
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		to_chat(usr, "[t]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Check Contents") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_view_range()
	set category = "Админ.Игра"
	set name = "Change View Range"
	set desc = "switches between 1x and custom views"

	if(view_size.getView() == view_size.default)
		view_size.setTo(input("Select view range:", "FUCK YE", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,37) - 7)
	else
		view_size.resetToDefault(getScreenSize(prefs.widescreenpref))

	log_admin("[key_name(usr)] changed their view range to [view].")
	//message_admins("\blue [key_name_admin(usr)] changed their view range to [view].")	//why? removed by order of XSI

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Change View Range", "[view]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_call_shuttle()
	set category = "Админ.Ивенты"
	set name = "Call Shuttle"

	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes")
		return

	SSshuttle.emergency.request()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Call Shuttle") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-called the emergency shuttle.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] admin-called the emergency shuttle.</span>")
	return

/client/proc/admin_cancel_shuttle()
	set category = "Админ.Ивенты"
	set name = "Cancel Shuttle"
	if(!check_rights(0))
		return
	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return

	if(EMERGENCY_AT_LEAST_DOCKED)
		return

	SSshuttle.emergency.cancel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Cancel Shuttle") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-recalled the emergency shuttle.")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] admin-recalled the emergency shuttle.</span>")

	return
/*
/client/proc/admin_disable_shuttle()
	set category = "Админ.Ивенты"
	set name = "Disable Shuttle"

	if(!check_rights(R_ADMIN))
		return
	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED)
		to_chat(usr, "<span class='warning'>Error, shuttle is already disabled.</span>")
		return
	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] disabled the shuttle.</span>")
	SSshuttle.lastMode = SSshuttle.emergency.mode
	SSshuttle.lastCallTime = SSshuttle.emergency.timeLeft(1)
	SSshuttle.adminEmergencyNoRecall = TRUE
	SSshuttle.emergency.setTimer(0)
	SSshuttle.emergency.mode = SHUTTLE_DISABLED
	priority_announce("Warning: Emergency Shuttle uplink failure, shuttle disabled until further notice.", "Emergency Shuttle Uplink Alert", 'sound/misc/announce_dig.ogg')

/client/proc/admin_enable_shuttle()
	set category = "Админ - Events"
	set category = "Админ.Ивенты"
	set name = "Enable Shuttle"

	if(!check_rights(R_ADMIN))
		return
	if(SSshuttle.emergency.mode != SHUTTLE_DISABLED)
		to_chat(usr, "<span class='warning'>Error, shuttle not disabled.</span>")
		return
	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes")
		return
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] enabled the emergency shuttle.</span>")
	SSshuttle.adminEmergencyNoRecall = FALSE
	SSshuttle.emergencyNoRecall = FALSE
	if(SSshuttle.lastMode == SHUTTLE_DISABLED) //If everything goes to shit, fix it.
		SSshuttle.lastMode = SHUTTLE_IDLE
	SSshuttle.emergency.mode = SSshuttle.lastMode
	if(SSshuttle.lastCallTime < 10 SECONDS && SSshuttle.lastMode != SHUTTLE_IDLE)
		SSshuttle.lastCallTime = 10 SECONDS //Make sure no insta departures.
	SSshuttle.emergency.setTimer(SSshuttle.lastCallTime)
	priority_announce("Warning: Emergency Shuttle uplink reestablished, shuttle enabled.", "Emergency Shuttle Uplink Alert", 'sound/misc/announce_dig.ogg')
*/
/client/proc/everyone_random()
	set category = "Админ.Веселье"
	set name = "Make Everyone Random"
	set desc = "Make everyone have a random appearance. You can only use this before rounds!"

	if(SSticker.HasRoundStarted())
		to_chat(usr, "Nope you can't do this, the game's already started. This only works before rounds!")
		return

	var/frn = CONFIG_GET(flag/force_random_names)
	if(frn)
		CONFIG_SET(flag/force_random_names, FALSE)
		message_admins("Admin [key_name_admin(usr)] has disabled \"Everyone is Special\" mode.")
		to_chat(usr, "Disabled.")
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(src)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(usr)] has forced the players to have random appearances.")

	if(notifyplayers == "Yes")
		to_chat(world, "<span class='adminnotice'>Admin [usr.key] has forced the players to have completely random identities!</span>")

	to_chat(usr, "<i>Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet</i>.")

	CONFIG_SET(flag/force_random_names, TRUE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Make Everyone Random") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_random_events()
	set category = "Server"
	set name = "Toggle random events on/off"
	set desc = "Toggles random events such as meteors, black holes, blob (but not space dust) on/off"
	var/new_are = !CONFIG_GET(flag/allow_random_events)
	CONFIG_SET(flag/allow_random_events, new_are)
	if(new_are)
		to_chat(usr, "Random events enabled")
		message_admins("Admin [key_name_admin(usr)] has enabled random events.")
	else
		to_chat(usr, "Random events disabled")
		message_admins("Admin [key_name_admin(usr)] has disabled random events.")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Random Events", "[new_are ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_enable_disk_inactive_msg()
	set category = "Server"
	set name = "Toggle nuke disk stationary admin logging"
	set desc = "Toggles nuke disk stationary admin logs for all admins"
	var/current_state = !CONFIG_GET(flag/admin_disk_inactive_msg)
	CONFIG_SET(flag/admin_disk_inactive_msg, current_state)
	if(current_state)
		to_chat(usr, "Inactive disk admin logging enabled")
		message_admins("Admin [key_name_admin(usr)] has enabled inactive disk admin logging")
	else
		to_chat(usr, "Inactive disk admin logging disabled")
		message_admins("Admin [key_name_admin(usr)] has disabled inactive disk admin logging")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle nuke disk stationary admin logging", "[current_state ? "Enabled" : "Disabled"]"))

/client/proc/admin_change_sec_level()
	set category = "Админ.Ивенты"
	set name = "Set Security Level"
	set desc = "Changes the security level. Announcement only, i.e. setting to Delta won't activate nuke"

	if(!check_rights(R_ADMIN))
		return

	var/level = input("Select security level to change to","Set Security Level") as null|anything in list("green","blue","orange","violet","amber","red","lambda","epsilon","delta")
	if(level)
		set_security_level(level)

		log_admin("[key_name(usr)] changed the security level to [level]")
		message_admins("[key_name_admin(usr)] changed the security level to [level]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Security Level [capitalize(level)]") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_hostile_environment()
	set category = "Админ.Ивенты"
	set name = "Hostile Environment"

	if(!check_rights(R_ADMIN))
		return

	switch(tgui_alert(usr, "Select an Option", "Hostile Environment Manager", list("Enable", "Disable", "Clear All")))
		if("Enable")
			if (SSshuttle.hostileEnvironments["Admin"] == TRUE)
				to_chat(usr, span_warning("Error, admin hostile environment already enabled."))
			else
				message_admins(span_adminnotice("[key_name_admin(usr)] Enabled an admin hostile environment"))
				SSshuttle.registerHostileEnvironment("Admin")
		if("Disable")
			if (!SSshuttle.hostileEnvironments["Admin"])
				to_chat(usr, span_warning("Error, no admin hostile environment found."))
			else
				message_admins(span_adminnotice("[key_name_admin(usr)] Disabled the admin hostile environment"))
				SSshuttle.clearHostileEnvironment("Admin")
		if("Clear All")
			message_admins(span_adminnotice("[key_name_admin(usr)] Disabled all current hostile environment sources"))
			SSshuttle.hostileEnvironments.Cut()
			SSshuttle.checkHostileEnvironment()

/client/proc/toggle_nuke(obj/machinery/nuclearbomb/N in GLOB.nuke_list)
	set name = "Toggle Nuke"
	set category = "Админ.Ивенты"
	set popup_menu = 0
	if(!check_rights(R_DEBUG))
		return

	if(!N.timing)
		var/newtime = input(usr, "Set activation timer.", "Activate Nuke", "[N.timer_set]") as num|null
		if(!newtime)
			return
		N.timer_set = newtime
	N.set_safety()
	N.set_active()

	log_admin("[key_name(usr)] [N.timing ? "activated" : "deactivated"] a nuke at [AREACOORD(N)].")
	message_admins("[ADMIN_LOOKUPFLW(usr)] [N.timing ? "activated" : "deactivated"] a nuke at [ADMIN_VERBOSEJMP(N)].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Nuke", "[N.timing]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/create_outfits()
	set category = "Debug"
	set name = "Create Custom Outfit"

	if(!check_rights(R_DEBUG))
		return

	holder.create_outfit()

/datum/admins/proc/create_outfit()
	var/list/uniforms = typesof(/obj/item/clothing/under)
	var/list/suits = typesof(/obj/item/clothing/suit)
	var/list/gloves = typesof(/obj/item/clothing/gloves)
	var/list/shoes = typesof(/obj/item/clothing/shoes)
	var/list/headwear = typesof(/obj/item/clothing/head)
	var/list/glasses = typesof(/obj/item/clothing/glasses)
	var/list/masks = typesof(/obj/item/clothing/mask)
	var/list/ids = typesof(/obj/item/card/id)

	var/uniform_select = "<select name=\"outfit_uniform\"><option value=\"\">None</option>"
	for(var/path in uniforms)
		uniform_select += "<option value=\"[path]\">[path]</option>"
	uniform_select += "</select>"

	var/suit_select = "<select name=\"outfit_suit\"><option value=\"\">None</option>"
	for(var/path in suits)
		suit_select += "<option value=\"[path]\">[path]</option>"
	suit_select += "</select>"

	var/gloves_select = "<select name=\"outfit_gloves\"><option value=\"\">None</option>"
	for(var/path in gloves)
		gloves_select += "<option value=\"[path]\">[path]</option>"
	gloves_select += "</select>"

	var/shoes_select = "<select name=\"outfit_shoes\"><option value=\"\">None</option>"
	for(var/path in shoes)
		shoes_select += "<option value=\"[path]\">[path]</option>"
	shoes_select += "</select>"

	var/head_select = "<select name=\"outfit_head\"><option value=\"\">None</option>"
	for(var/path in headwear)
		head_select += "<option value=\"[path]\">[path]</option>"
	head_select += "</select>"

	var/glasses_select = "<select name=\"outfit_glasses\"><option value=\"\">None</option>"
	for(var/path in glasses)
		glasses_select += "<option value=\"[path]\">[path]</option>"
	glasses_select += "</select>"

	var/mask_select = "<select name=\"outfit_mask\"><option value=\"\">None</option>"
	for(var/path in masks)
		mask_select += "<option value=\"[path]\">[path]</option>"
	mask_select += "</select>"

	var/id_select = "<select name=\"outfit_id\"><option value=\"\">None</option>"
	for(var/path in ids)
		id_select += "<option value=\"[path]\">[path]</option>"
	id_select += "</select>"

	var/dat = {"
	<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><title>Create Outfit</title></head><body>
	<form name="outfit" action="byond://?src=[REF(src)];[HrefToken()]" method="get">
	<input type="hidden" name="src" value="[REF(src)]">
	[HrefTokenFormField()]
	<input type="hidden" name="create_outfit" value="1">
	<table>
		<tr>
			<th>Name:</th>
			<td>
				<input type="text" name="outfit_name" value="Custom Outfit">
			</td>
		</tr>
		<tr>
			<th>Uniform:</th>
			<td>
				[uniform_select]
			</td>
		</tr>
		<tr>
			<th>Suit:</th>
			<td>
				[suit_select]
			</td>
		</tr>
		<tr>
			<th>Back:</th>
			<td>
				<input type="text" name="outfit_back" value="">
			</td>
		</tr>
		<tr>
			<th>Belt:</th>
			<td>
				<input type="text" name="outfit_belt" value="">
			</td>
		</tr>
		<tr>
			<th>Gloves:</th>
			<td>
				[gloves_select]
			</td>
		</tr>
		<tr>
			<th>Shoes:</th>
			<td>
				[shoes_select]
			</td>
		</tr>
		<tr>
			<th>Head:</th>
			<td>
				[head_select]
			</td>
		</tr>
		<tr>
			<th>Mask:</th>
			<td>
				[mask_select]
			</td>
		</tr>
		<tr>
			<th>Ears:</th>
			<td>
				<input type="text" name="outfit_ears" value="">
			</td>
		</tr>
		<tr>
			<th>Glasses:</th>
			<td>
				[glasses_select]
			</td>
		</tr>
		<tr>
			<th>ID:</th>
			<td>
				[id_select]
			</td>
		</tr>
		<tr>
			<th>Left Pocket:</th>
			<td>
				<input type="text" name="outfit_l_pocket" value="">
			</td>
		</tr>
		<tr>
			<th>Right Pocket:</th>
			<td>
				<input type="text" name="outfit_r_pocket" value="">
			</td>
		</tr>
		<tr>
			<th>Suit Store:</th>
			<td>
				<input type="text" name="outfit_s_store" value="">
			</td>
		</tr>
		<tr>
			<th>Right Hand:</th>
			<td>
				<input type="text" name="outfit_r_hand" value="">
			</td>
		</tr>
		<tr>
			<th>Left Hand:</th>
			<td>
				<input type="text" name="outfit_l_hand" value="">
			</td>
		</tr>
	</table>
	<br>
	<input type="submit" value="Save">
	</form></body></html>
	"}
	usr << browse(dat, "window=dressup;size=550x600")

/client/proc/toggle_combo_hud()
	set category = "Админ.Игра"
	set name = "Toggle Combo HUD"
	set desc = "Toggles the Admin Combo HUD (antag, sci, med, eng)"

	if(!check_rights(R_ADMIN))
		return

	var/adding_hud = !has_antag_hud()

	for(var/hudtype in list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED, DATA_HUD_ANTAGTARGET)) // add data huds
		var/datum/atom_hud/H = GLOB.huds[hudtype]
		(adding_hud) ? H.add_hud_to(usr) : H.remove_hud_from(usr)
	for(var/datum/atom_hud/antag/H in GLOB.huds) // add antag huds
		(adding_hud) ? H.add_hud_to(usr) : H.remove_hud_from(usr)

	if(prefs.toggles & COMBOHUD_LIGHTING)
		if(adding_hud)
			mob.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			mob.lighting_alpha = initial(mob.lighting_alpha)

	mob.update_sight()

	to_chat(usr, "You toggled your admin combo HUD [adding_hud ? "ON" : "OFF"].")
	message_admins("[key_name_admin(usr)] toggled their admin combo HUD [adding_hud ? "ON" : "OFF"].")
	log_admin("[key_name(usr)] toggled their admin combo HUD [adding_hud ? "ON" : "OFF"].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Combo HUD", "[adding_hud ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/has_antag_hud()
	var/datum/atom_hud/A = GLOB.huds[ANTAG_HUD_TRAITOR]
	return A.hudusers[mob]


/client/proc/run_weather()
	set category = "Админ.Ивенты"
	set name = "Run Weather"
	set desc = "Triggers a weather on the z-level you choose."

	if(!holder)
		return

	var/weather_type = input("Choose a weather", "Weather")  as null|anything in subtypesof(/datum/weather)
	if(!weather_type)
		return

	var/z_level = input("Z-Level to target? Leave blank to target current Z-Level.", "Z-Level")  as num|null
	if(!isnum(z_level))
		if(!src.mob)
			return
		z_level = src.mob.z

	SSweather.run_weather(weather_type, z_level)

	message_admins("[key_name_admin(usr)] started weather of type [weather_type] on the z-level [z_level].")
	log_admin("[key_name(usr)] started weather of type [weather_type] on the z-level [z_level].")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Run Weather")

/client/proc/mass_zombie_infection()
	set category = "Админ.Веселье"
	set name = "Mass Zombie Infection"
	set desc = "Infects all humans with a latent organ that will zombify \
		them on death."

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Please confirm you want to add latent zombie organs in all humans?", "Confirm Zombies", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/mob/living/carbon/human/H in GLOB.carbon_list)
		new /obj/item/organ/zombie_infection/nodamage(H)

	message_admins("[key_name_admin(usr)] added a latent zombie infection to all humans.")
	log_admin("[key_name(usr)] added a latent zombie infection to all humans.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Mass Zombie Infection")

/client/proc/mass_zombie_cure()
	set category = "Админ.Веселье"
	set name = "Mass Zombie Cure"
	set desc = "Removes the zombie infection from all humans, returning them to normal."
	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Please confirm you want to cure all zombies?", "Confirm Zombie Cure", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/organ/zombie_infection/nodamage/I in GLOB.zombie_infection_list)
		qdel(I)

	message_admins("[key_name_admin(usr)] cured all zombies.")
	log_admin("[key_name(usr)] cured all zombies.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Mass Zombie Cure")

/client/proc/polymorph_all()
	set category = "Админ.Веселье"
	set name = "Polymorph All"
	set desc = "Applies the effects of the bolt of change to every single mob."

	if(!check_rights(R_ADMIN))
		return

	var/confirm = alert(src, "Please confirm you want polymorph all mobs?", "Confirm Polymorph", "Yes", "No")
	if(confirm != "Yes")
		return

	var/list/mobs = shuffle(GLOB.alive_mob_list.Copy()) // might change while iterating
	var/who_did_it = key_name_admin(usr)

	message_admins("[key_name_admin(usr)] started polymorphed all living mobs.")
	log_admin("[key_name(usr)] polymorphed all living mobs.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Polymorph All")

	for(var/mob/living/M in mobs)
		CHECK_TICK

		if(!M)
			continue

		M.audible_message("<span class='italics'>...wabbajack...wabbajack...</span>")
		playsound(M.loc, 'sound/magic/staff_change.ogg', 50, 1, -1)

		wabbajack(M)

	message_admins("Mass polymorph started by [who_did_it] is complete.")


/client/proc/show_tip()
	set category = "Админ"
	set name = "Show Tip"
	set desc = "Sends a tip (that you specify) to all players. After all \
		you're the experienced player here."

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please specify your tip that you want to send to the players.", "Tip", "") as message|null
	if(!input)
		return

	if(!SSticker)
		return

	SSticker.selected_tip = input

	// If we've already tipped, then send it straight away.
	if(SSticker.tipped)
		SSticker.send_tip_of_the_round()


	message_admins("[key_name_admin(usr)] sent a tip of the round.")
	log_admin("[key_name(usr)] sent \"[input]\" as the Tip of the Round.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Tip")

/client/proc/modify_goals()
	set category = "Debug"
	set name = "Modify goals"

	if(!check_rights(R_ADMIN))
		return

	holder.modify_goals()

/datum/admins/proc/modify_goals()
	var/dat = ""
	for(var/datum/station_goal/S in SSticker.mode.station_goals)
		dat += "[S.name] - <a href='?src=[REF(S)];[HrefToken()];announce=1'>Announce</a> | <a href='?src=[REF(S)];[HrefToken()];remove=1'>Remove</a> | <a href='?src=[REF(S)];[HrefToken()];complete=1'>Complete</a><br>"
	dat += "<br><a href='?src=[REF(src)];[HrefToken()];add_station_goal=1'>Add New Goal</a>"
	usr << browse(dat, "window=goals;size=400x400")

/client/proc/toggle_hub()
	set category = "Server"
	set name = "Toggle Hub"

	world.update_hub_visibility(!GLOB.hub_visibility)

	log_admin("[key_name(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	message_admins("[key_name_admin(usr)] has toggled the server's hub status for the round, it is now [(GLOB.hub_visibility?"on":"off")] the hub.")
	if (GLOB.hub_visibility && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a filewall is blocking incoming connections.")

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Hub Visibility", "[GLOB.hub_visibility ? "Enabled" : "Disabled"]")) //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_toggle_fov()
	set category = "Админ.Веселье"
	set name = "Enable/Disable Field of Vision"

	var/static/busy_toggling_fov = FALSE
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return

	var/on_off = CONFIG_GET(flag/use_field_of_vision)

	if(busy_toggling_fov)
		to_chat(usr, "<span class='warning'>A previous call of this function is still busy toggling FoV [on_off ? "on" : "off"]. Have some patiece</span>.")
		return
	busy_toggling_fov = TRUE

	log_admin("[key_name(usr)] has [on_off ? "disabled" : "enabled"] the Field of Vision configuration.")
	CONFIG_SET(flag/use_field_of_vision, !on_off)

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Field of Vision", "[on_off ? "Enabled" : "Disabled"]"))

	if(on_off)
		for(var/k in GLOB.mob_list)
			if(!k)
				continue
			var/mob/M = k
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(!(H.dna?.species.has_field_of_vision))
					continue
			else if(!M.has_field_of_vision)
				continue
			var/datum/component/field_of_vision/FoV = M.GetComponent(/datum/component/field_of_vision)
			if(FoV)
				qdel(FoV)
			CHECK_TICK
	else
		for(var/k in GLOB.clients)
			if(!k)
				continue
			var/client/C = k
			var/mob/M = C.mob
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(!(H.dna?.species.has_field_of_vision))
					continue
			else if(!M.has_field_of_vision)
				continue
			M.LoadComponent(/datum/component/field_of_vision, M.field_of_vision_type)
			CHECK_TICK

	busy_toggling_fov = FALSE

/client/proc/smite(mob/living/target as mob)
	set name = "Smite"
	set category = "Админ.Веселье"
	if(!check_rights(R_ADMIN) || !check_rights(R_FUN))
		return


	var/punishment = tgui_input_list(usr, "Choose a punishment", "DIVINE SMITING", GLOB.smites)

	if(QDELETED(target) || !punishment)
		return

	var/smite_path = GLOB.smites[punishment]
	var/datum/smite/smite = new smite_path
	var/configuration_success = smite.configure(usr)
	if (configuration_success == FALSE)
		return
	smite.effect(src, target)


/proc/breadify(atom/movable/target)
	var/obj/item/reagent_containers/food/snacks/store/bread/plain/funnyBread = new(get_turf(target))
	target.forceMove(funnyBread)

/proc/bookify(atom/movable/target)
	var/obj/item/reagent_containers/food/snacks/store/book/funnyBook = new(get_turf(target))
	target.forceMove(funnyBook)
	funnyBook.name = "Book of " + target.name
/**
  * firing_squad is a proc for the :B:erforate smite to shoot each individual bullet at them, so that we can add actual delays without sleep() nonsense
  *
  * Hilariously, if you drag someone away mid smite, the bullets will still chase after them from the original spot, possibly hitting other people. Too funny to fix imo
  *
  * Arguments:
  * * target- guy we're shooting obviously
  * * source_turf- where the bullet begins, preferably on a turf next to the target
  * * body_zone- which bodypart we're aiming for, if there is one there
  * * wound_bonus- the wounding power we're assigning to the bullet, since we don't care about the base one
  * * damage- the damage we're assigning to the bullet, since we don't care about the base one
  */
/proc/firing_squad(mob/living/carbon/target, turf/source_turf, body_zone, wound_bonus, damage)
	if(!target.get_bodypart(body_zone))
		return
	playsound(target, 'sound/weapons/shot.ogg', 100)
	var/obj/item/projectile/bullet/smite/divine_wrath = new(source_turf)
	divine_wrath.damage = damage
	divine_wrath.wound_bonus = wound_bonus
	divine_wrath.original = target
	divine_wrath.def_zone = body_zone
	divine_wrath.spread = 0
	divine_wrath.preparePixelProjectile(target, source_turf)
	divine_wrath.fire()

/client/proc/punish_log(var/whom, var/punishment)
	var/msg = "[key_name_admin(src)] punished [key_name_admin(whom)] with [punishment]."
	message_admins(msg)
	admin_ticket_log(whom, msg)
	log_admin("[key_name(src)] punished [key_name(whom)] with [punishment].")

/client/proc/trigger_centcom_recall()
	if(!check_rights(R_ADMIN))
		return
	var/message = pick(GLOB.admiral_messages)
	message = input("Enter message from the on-call admiral to be put in the recall report.", "Admiral Message", message) as text|null

	if(!message)
		return

	message_admins("[key_name_admin(usr)] triggered a CentCom recall, with the admiral message of: [message]")
	log_game("[key_name(usr)] triggered a CentCom recall, with the message of: [message]")
	SSshuttle.centcom_recall(SSshuttle.emergency.timer, message)

/client/proc/cmd_admin_check_player_exp()	//Allows admins to determine who the newer players are.
	set category = "Админ"
	set name = "Player Playtime"

	if(!check_rights(R_ADMIN))
		return

	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='warning'>Tracking is disabled in the server configuration file.</span>")
		return

	new /datum/player_playtime(usr)

/obj/effect/temp_visual/fireball
	icon = 'icons/obj/wizard.dmi'
	icon_state = "fireball"
	name = "fireball"
	desc = "Get out of the way!"
	layer = FLY_LAYER
	randomdir = FALSE
	duration = 9
	pixel_z = 270

/obj/effect/temp_visual/fireball/Initialize(mapload)
	. = ..()
	animate(src, pixel_z = 0, time = duration)

/obj/effect/temp_visual/target
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "sniper_zoom"
	layer = BELOW_MOB_LAYER
	light_range = 2
	duration = 9

/obj/effect/temp_visual/target/ex_act(severity, target, origin)
	return

/obj/effect/temp_visual/target/Initialize(mapload, list/flame_hit)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fall), flame_hit)

/obj/effect/temp_visual/target/proc/fall(list/flame_hit)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, 1)
	new /obj/effect/temp_visual/fireball(T)
	sleep(duration)
	if(ismineralturf(T))
		var/turf/closed/mineral/M = T
		M.gets_drilled()
	playsound(T, "explosion", 80, 1)
	new /obj/effect/hotspot(T)
	T.hotspot_expose(700, 50, 1)
	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/megafauna/dragon))
			continue
		if(islist(flame_hit) && !flame_hit[L])
			L.adjustFireLoss(40)
			to_chat(L, "<span class='userdanger'>You're hit by the drake's fire breath!</span>")
			flame_hit[L] = TRUE
		else
			L.adjustFireLoss(10) //if we've already hit them, do way less damage

/datum/admins/proc/cmd_show_exp_panel(client/client_to_check)
	if(!check_rights(R_ADMIN))
		return
	if(!client_to_check)
		to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>", confidential = TRUE)
		return
	if(!CONFIG_GET(flag/use_exp_tracking))
		to_chat(usr, "<span class='warning'>Tracking is disabled in the server configuration file.</span>", confidential = TRUE)
		return

	new /datum/job_report_menu(client_to_check, usr)

/datum/admins/proc/toggle_exempt_status(client/C)
	if(!check_rights(R_ADMIN))
		return
	if(!C)
		to_chat(usr, "<span class='danger'>ERROR: Client not found.</span>")
		return

	if(!C.set_db_player_flags())
		to_chat(usr, "<span class='danger'>ERROR: Unable read player flags from database. Please check logs.</span>")
	var/dbflags = C.prefs.db_flags
	var/newstate = FALSE
	if(dbflags & DB_FLAG_EXEMPT)
		newstate = FALSE
	else
		newstate = TRUE

	if(C.update_flag_db(DB_FLAG_EXEMPT, newstate))
		to_chat(usr, "<span class='danger'>ERROR: Unable to update player flags. Please check logs.</span>")
	else
		message_admins("[key_name_admin(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name_admin(C)]")
		log_admin("[key_name(usr)] has [newstate ? "activated" : "deactivated"] job exp exempt status on [key_name(C)]")

/// Allow admin to add or remove traits of datum
/datum/admins/proc/modify_traits(datum/D)
	if(!D)
		return

	var/add_or_remove = input("Remove/Add?", "Trait Remove/Add") as null|anything in list("Add","Remove")
	if(!add_or_remove)
		return
	var/list/availible_traits = list()

	switch(add_or_remove)
		if("Add")
			for(var/key in GLOB.traits_by_type)
				if(istype(D,key))
					availible_traits += GLOB.traits_by_type[key]
		if("Remove")
			if(!GLOB.trait_name_map)
				GLOB.trait_name_map = generate_trait_name_map()
			for(var/trait in D.status_traits)
				var/name = GLOB.trait_name_map[trait] || trait
				availible_traits[name] = trait

	var/chosen_trait = input("Select trait to modify", "Trait") as null|anything in sort_list(availible_traits)
	if(!chosen_trait)
		return
	chosen_trait = availible_traits[chosen_trait]

	var/source = "adminabuse"
	switch(add_or_remove)
		if("Add") //Not doing source choosing here intentionally to make this bit faster to use, you can always vv it.
			ADD_TRAIT(D,chosen_trait,source)
		if("Remove")
			var/specific = input("All or specific source ?", "Trait Remove/Add") as null|anything in list("All","Specific")
			if(!specific)
				return
			switch(specific)
				if("All")
					source = null
				if("Specific")
					source = input("Source to be removed","Trait Remove/Add") as null|anything in sort_list(D.status_traits[chosen_trait])
					if(!source)
						return
			REMOVE_TRAIT(D,chosen_trait,source)

/client/proc/spawn_floor_cluwne()
	set name = "Unleash Floor Cluwne"
	set category = "Админ.Веселье"
	set desc = "Pick a specific target or just let it select randomly and spawn the floor cluwne mob on the station. Be warned: spawning more than one may cause issues!"
	var/target

	if(!check_rights(R_FUN))
		return

	var/turf/T = get_turf(usr)
	target = input("Any specific target in mind? Please note only live, non cluwned, human targets are valid.", "Target", target) as null|anything in GLOB.player_list

	if(target)
		log_admin("[key_name(usr)] spawned floor cluwne, heading for [target].")
		message_admins("[key_name(usr)] spawned floor cluwne, heading for [target].")
	else
		log_admin("[key_name(usr)] spawned floor cluwne, roaming freely.")
		message_admins("[key_name(usr)] spawned floor cluwne, roaming freely.")

	var/mob/living/carbon/human/H = target
	if(istype(H))
		var/mob/living/simple_animal/hostile/floor_cluwne/FC = new(T)
		FC.Acquire_Victim(H)
	else
		new /mob/living/simple_animal/hostile/floor_cluwne(T)
	log_admin("[key_name(usr)] spawned floor cluwne.")
	message_admins("[key_name(usr)] spawned floor cluwne.")

/// "Immerse", or how I made the entire playerbase quit the game.
/proc/immerse_player(mob/living/carbon/target, toggle=TRUE, remove=FALSE)
	var/list/immersion_components = list(/datum/component/manual_breathing, /datum/component/manual_blinking)

	for(var/immersies in immersion_components)
		var/has_component = target.GetComponent(immersies)

		if(has_component && (toggle || remove))
			qdel(has_component)
		else if(toggle || !remove)
			target.AddComponent(immersies)

/proc/mass_immerse(remove=FALSE)
	for(var/mob/living/carbon/M in GLOB.mob_list)
		immerse_player(M, toggle=FALSE, remove=remove)
