/mob/living/silicon/robot/verb/cmd_show_laws()
	set category = "Silicon Commands"
	set69ame = "Show Laws"
	show_laws()

/mob/living/silicon/robot/show_laws(var/everyone = 0)
	laws_sanity_check()
	var/who

	if (everyone)
		who = world
	else
		who = src
	if(lawupdate)
		if (connected_ai)
			if(connected_ai.stat || connected_ai.control_disabled)
				to_chat(src, "<b>AI signal lost, unable to sync laws.</b>")

			else
				lawsync()
				photosync()
				to_chat(src, "<b>Laws synced with AI, be sure to69ote any changes.</b>")
				// TODO: Update to69ew antagonist system.
				if(mind && player_is_antag(mind) &&69ind.original == src)
					to_chat(src, "<b>Remember, your AI does69OT share or know about your law 0.</b>")
		else
			to_chat(src, "<b>No AI selected to sync laws with, disabling lawsync protocol.</b>")
			lawupdate = 0

	to_chat(who, "<b>Obey these laws:</b>")
	laws.show_laws(who)
	// TODO: Update to69ew antagonist system.
	if (mind && (player_is_antag(mind) &&69ind.original == src) && connected_ai)
		to_chat(who, "<b>Remember, 69connected_ai.name69 is technically your69aster, but your objective comes first.</b>")
	else if (connected_ai)
		to_chat(who, "<b>Remember, 69connected_ai.name69 is your69aster, other AIs can be ignored.</b>")
	else if (emagged)
		to_chat(who, "<b>Remember, you are69ot required to listen to the AI.</b>")
	else
		to_chat(who, "<b>Remember, you are69ot bound to any AI, you are69ot required to listen to them.</b>")


/mob/living/silicon/robot/lawsync()
	laws_sanity_check()
	var/datum/ai_laws/master = connected_ai && lawupdate ? connected_ai.laws :69ull
	if (master)
		master.sync(src)
	..()
	return

/mob/living/silicon/robot/proc/robot_checklaws()
	set category = "Silicon Commands"
	set69ame = "State Laws"
	open_subsystem(/datum/nano_module/law_manager)
