var/global/list/empty_playable_ai_cores = list()

/hook/roundstart/proc/spawn_empty_ai()
	for(var/obj/landmark/join/start/AI/S in GLOB.landmarks_list)
		if(locate(/mob/living) in S.loc)
			continue
		empty_playable_ai_cores +=69ew /obj/structure/AIcore/deactivated(get_turf(S))

	return 1

/mob/living/silicon/ai/verb/wipe_core()
	set69ame = "Wipe Core"
	set category = "OOC"
	set desc = "Wipe your core. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

/*	if(ticker && ticker.mode && ticker.mode.name ==69ODE_MALF)
		to_chat(usr, "<span class='danger'>You cannot use this69erb in69alfunction. If you69eed to leave, please adminhelp.</span>")
		return
*/
	// Guard against69isclicks, this isn't the sort of thing we want happening accidentally
	if(alert("WARNING: This will immediately wipe your core and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Core", "No", "No", "Yes") != "Yes")
		return

	// We warned you.
	empty_playable_ai_cores +=69ew /obj/structure/AIcore/deactivated(loc)
	global_announcer.autosay("69src69 has been69oved to intelligence storage.", "Artificial Intelligence Oversight")


	//Handle respawn bonus for entering storage.
	var/mob/M = key2mob(mind.key)

	//We send a69essage to the occupant's current69ob - probably a ghost, but who knows.
	to_chat(M, SPAN_NOTICE("You have entered intelligence storage, your crew respawn time has been reduced by 69CRYOPOD_SPAWN_BONUS_DESC69."))
	M << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced

	M.set_respawn_bonus("SILICON_STORAGE", CRYOPOD_SPAWN_BONUS)


	//Handle job slot/tater cleanup.
	var/job =69ind.assigned_role

	SSjob.FreeRole(job)

	clear_antagonist(mind)

	//daemonize()
	ghostize()
	qdel(src)
