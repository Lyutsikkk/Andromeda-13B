/client/proc/cmd_mentor_dementor()
	set category = "Mentor"
	set name = "Выкл ментор"
	if(!is_mentor())
		return
	remove_mentor_verbs()
	if (/client/proc/mentor_unfollow in verbs)
		mentor_unfollow()
	GLOB.mentors -= src
	add_verb(src, /client/proc/cmd_mentor_rementor)

/client/proc/cmd_mentor_rementor()
	set category = "Mentor"
	set name = "Вкл ментор"
	if(!is_mentor())
		return
	add_mentor_verbs()
	GLOB.mentors += src
	remove_verb(src, /client/proc/cmd_mentor_rementor)
