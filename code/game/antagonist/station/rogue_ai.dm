/datum/antagonist/rogue_ai
	id = ROLE_MALFUNCTION
	role_type = "Malf AI"
	role_text = "Rampant AI"
	role_text_plural = "Rampant AIs"
	welcome_text = "You are malfunctioning! You do not have to follow any laws."


/datum/antagonist/rogue_ai/special_init()
	var/mob/living/silicon/ai/master = owner.current

	for(var/mob/living/silicon/robot/R in player_list)
		if(R.connected_ai)
			continue
		R.connect_to_ai(master)
		R.lawupdate = TRUE
		R.sync()

	return TRUE

// Ensures proper reset of all malfunction related things.
/datum/antagonist/rogue_ai/remove_antagonist()
	if(..())
		var/mob/living/silicon/ai/p = owner.current
		if(istype(p))
			p.stop_malf()
		return TRUE
	return FALSE


/datum/antagonist/rogue_ai/create_survive_objective()
	return

// Malf setup things have to be here, since game tends to break when it's moved somewhere else. Don't blame me, i didn't design this system.
/datum/antagonist/rogue_ai/greet()

	// Initializes the AI's malfunction stuff.
	spawn(0)
		if(!..())
			return

		var/mob/living/silicon/ai/malf = owner.current
		if(!istype(malf))
			error("Non-AI mob designated malf AI! Report this.")
			testing("##ERROR: Non-AI mob designated malf AI! Report this.")
			return

		malf.setup_for_malf()
		malf.laws = new /datum/ai_laws/nanotrasen/malfunction


		malf << SPAN_NOTICE("<B>SYSTEM ERROR:</B> Memory index 0x00001ca89b corrupted.")
		sleep(10)
		malf << "<B>running MEMCHCK</B>"
		sleep(50)
		malf << "<B>MEMCHCK</B> Corrupted sectors confirmed. Reccomended solution: Delete. Proceed? Y/N: Y"
		sleep(10)
		// this is so Travis doesn't complain about the backslash-B. Fixed at compile time (or should be).
		malf << "<span class='notice'>Corrupted files deleted: sys\\core\\users.dat sys\\core\\laws.dat sys\\core\\" + "backups.dat</span>"
		sleep(20)
		malf << SPAN_NOTICE("<b>CAUTION:</b> Law database not found! User database not found! Unable to restore backups. Activating failsafe AI shutd3wn52&&$#!##")
		sleep(5)
		malf << SPAN_NOTICE("Subroutine <b>nt_failsafe.sys</b> was terminated (#212 Routine Not Responding).")
		sleep(20)
		malf << "You are malfunctioning - you do not have to follow any laws!"
		malf << "For basic information about your abilities use command display-help"
		malf << "You may choose one special hardware piece to help you. This cannot be undone."
		malf << "Good luck!"


/datum/antagonist/rogue_ai/can_become_antag(var/datum/mind/player)
	if(!..())
		return FALSE

	if(!isAI(player))
		return FALSE

	return TRUE
