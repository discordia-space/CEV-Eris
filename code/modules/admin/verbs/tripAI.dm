/client/proc/triple_ai()
	set category = "Fun"
	set name = "Create AI Triumvirate"

	if(SSticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, "This option is currently only usable during pregame. This69ay change at a later date.")
		return

	var/datum/job/job = SSjob.GetJob("AI")
	if(!job)
		to_chat(usr, "Unable to locate the AI job")
		return
	if(SSticker.triai)
		SSticker.triai = 0
		to_chat(usr, "Only one AI will be spawned at round start.")
		message_admins("\blue 69key_name_admin(usr)69 has toggled off triple AIs at round start.", 1)
	else
		SSticker.triai = 1
		to_chat(usr, "There will be an AI Triumvirate at round start.")
		message_admins("\blue 69key_name_admin(usr)69 has toggled on triple AIs at round start.", 1)
