/datum/language/binary
	name = LANGUAGE_ROBOT
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = list("states")
	ask_verb = list("queries")
	exclaim_verb = list("declares")
	key = "b"
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	var/message_start = "<i><span class='game say'>69name69, <span class='name'>69speaker.name69</span>"
	var/message_body = "<span class='message'>69speaker.say_quote(message)69, \"69message69\"</span></span></i>"

	for (var/mob/M in GLOB.dead_mob_list)
		if (isangel(M))
			M.show_message("69message_start69 69message_body69", 2)
		if(!isnewplayer(M) && !isbrain(M)) //No69eta-evesdropping
			M.show_message("69message_start69 (69ghost_follow_link(speaker,69)69) 69message_body69", 2)

	for (var/mob/living/S in GLOB.living_mob_list)

		if(drone_only && !isdrone(S))
			continue
		else if(istype(S , /mob/living/silicon/ai))
			message_start = "<i><span class='game say'>69name69, <a href='byond://?src=\ref69S69;track2=\ref69S69;track=\ref69speaker69;trackname=69html_encode(speaker.name)69'><span class='name'>69speaker.name69</span></a></span></i>"
		else if (!S.binarycheck())
			continue

		S.show_message("69message_start69 69message_body69", 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(issilicon(M) ||69.binarycheck())
			continue
		M.show_message("<i><span class='game say'><span class='name'>synthesised69oice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>",2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components69"comms"69
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = LANGUAGE_DRONE
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = list("transmits")
	ask_verb = list("transmits")
	exclaim_verb = list("transmits")
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = 1

/datum/language/binary/blitz
	name = LANGUAGE_BLITZ
	desc = "An encrypted binary-stream language used for agent co-ordination."
	speech_verb = list("transmits")
	ask_verb = list("transmits")
	exclaim_verb = list("transmits")
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = 1