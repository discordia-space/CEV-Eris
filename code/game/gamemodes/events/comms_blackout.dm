/datum/storyevent/comms_blackout
	id = "comms_blackout"
	name = "communications blackout"

	event_type =/datum/event/communications_blackout
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_COMMUNAL, TAG_SCARY, TAG_NEGATIVE)

/////////////////////////////////////////////////
/datum/event/communications_blackout/announce()
	var/alert = pick(	"Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
						"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v�-BZZZT", \
						"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT", \
						"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT", \
						"Ionospheri:%�69Cayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>�%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in GLOB.player_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, SPAN_WARNING("<b>69alert69</b>"))
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		command_announcement.Announce(alert, new_sound = sound('sound/misc/interference.ogg',69olume=25))


/datum/event/communications_blackout/start()
	log_and_message_admins("Communication blackout event triggered,")
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)


/proc/communications_blackout(var/silent = 1)

	if(!silent)
		command_announcement.Announce("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT", new_sound = 'sound/misc/interference.ogg')
	else // AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
		for(var/mob/living/silicon/ai/A in GLOB.player_list)
			to_chat(A, "<br>")
			to_chat(A, SPAN_WARNING("<b>Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT</b>"))
			to_chat(A, "<br>")
	for(var/obj/machinery/telecomms/T in telecomms_list)
		T.emp_act(1)
