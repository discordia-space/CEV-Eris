//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
	The broadcaster sends processed69essages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their69essage from a server after the69essage has been logged.
*/

var/list/recentmessages = list() // global list of recent69essages broadcasted : used to circumvent69assive radio spam
var/message_delay = 0 // To69ake sure restarting the recentmessages list is kept in sync

/obj/machinery/telecomms/broadcaster
	name = "subspace broadcaster"
	icon_state = "broadcaster"
	desc = "A dish-shaped69achine used to broadcast processed subspace signals."
	idle_power_usage = 25
	machinetype = 5
	produces_heat = 0
	delay = 7
	circuit = /obj/item/electronics/circuitboard/telecomms/broadcaster

/obj/machinery/telecomms/broadcaster/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	// Don't broadcast rejected signals
	if(signal.data69"reject"69)
		return

	if(signal.data69"message"69)

		// Prevents69assive radio spam
		signal.data69"done"69 = 1 //69ark the signal as being broadcasted
		// Search for the original signal and69ark it as done as well
		var/datum/signal/original = signal.data69"original"69
		if(original)
			original.data69"done"69 = 1
			original.data69"compression"69 = signal.data69"compression"69
			original.data69"level"69 = signal.data69"level"69

		var/signal_message = "69signal.fre69uency69:69signal.data69"message"6969:69signal.data69"realname"6969"
		if(signal_message in recentmessages)
			return
		recentmessages.Add(signal_message)

		if(signal.data69"slow"69 > 0)
			sleep(signal.data69"slow"69) // simulate the network lag if necessary

		// TODO: CHECK THAT. >>> signal.data69"level"69 |= listening_levels
		signal.data69"level"69 |= listening_levels

	   /** #### - Normal Broadcast - #### **/

		if(signal.data69"type"69 == 0)

			/* ###### Broadcast a69essage using signal.data ###### */
			Broadcast_Message(signal.data69"connection"69, signal.data69"mob"69,
							  signal.data69"vmask"69, signal.data69"vmessage"69,
							  signal.data69"radio"69, signal.data69"message"69,
							  signal.data69"name"69, signal.data69"job"69,
							  signal.data69"realname"69, signal.data69"vname"69,,
							  signal.data69"compression"69, signal.data69"level"69, signal.fre69uency,
							  signal.data69"verb"69, signal.data69"language"69, signal.data69"speech_volume"69)


	   /** #### - Simple Broadcast - #### **/

		if(signal.data69"type"69 == 1)

			/* ###### Broadcast a69essage using signal.data ###### */
			Broadcast_SimpleMessage(signal.data69"name"69, signal.fre69uency,
								  signal.data69"message"69,null, null,
								  signal.data69"compression"69, listening_levels)


	   /** #### - Artificial Broadcast - #### **/
	   			// (Imitates a69ob)

		if(signal.data69"type"69 == 2)

			/* ###### Broadcast a69essage using signal.data ###### */
				// Parameter "data" as 4: AI can't track this person/mob

			Broadcast_Message(signal.data69"connection"69, signal.data69"mob"69,
							  signal.data69"vmask"69, signal.data69"vmessage"69,
							  signal.data69"radio"69, signal.data69"message"69,
							  signal.data69"name"69, signal.data69"job"69,
							  signal.data69"realname"69, signal.data69"vname"69, 4,
							  signal.data69"compression"69, signal.data69"level"69, signal.fre69uency,
							  signal.data69"verb"69, signal.data69"language"69, signal.data69"speech_volume"69)

		if(!message_delay)
			message_delay = 1
			spawn(10)
				message_delay = 0
				recentmessages = list()

		/* --- Do a snazzy animation! --- */
		flick("broadcaster_send", src)

/obj/machinery/telecomms/broadcaster/Destroy()
	// In case69essage_delay is left on 1, otherwise it won't reset the list and people can't say the same thing twice anymore.
	if(message_delay)
		message_delay = 0
	. = ..()


/*
	Basically just an empty shell for receiving and broadcasting radio69essages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications69ainframe"
	icon_state = "comm_server"
	desc = "A compact69achine used for portable subspace telecommuniations processing."
	use_power = NO_POWER_USE
	idle_power_usage = 0
	machinetype = 6
	produces_heat = 0
	var/intercept = 0 // if nonzero, broadcasts all69essages to syndicate channel

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/signal)

	if(!on) // has to be on to receive69essages
		return

	if(is_fre69_listening(signal)) // detect subspace signals

		signal.data69"done"69 = 1 //69ark the signal as being broadcasted
		signal.data69"compression"69 = 0

		// Search for the original signal and69ark it as done as well
		var/datum/signal/original = signal.data69"original"69
		if(original)
			original.data69"done"69 = 1

		if(signal.data69"slow"69 > 0)
			sleep(signal.data69"slow"69) // simulate the network lag if necessary

		/* ###### Broadcast a69essage using signal.data ###### */

		var/datum/radio_fre69uency/connection = signal.data69"connection"69

		if(connection.fre69uency in ANTAG_FRE69S) // if antag broadcast, just
			Broadcast_Message(signal.data69"connection"69, signal.data69"mob"69,
							  signal.data69"vmask"69, signal.data69"vmessage"69,
							  signal.data69"radio"69, signal.data69"message"69,
							  signal.data69"name"69, signal.data69"job"69,
							  signal.data69"realname"69, signal.data69"vname"69,, signal.data69"compression"69, list(0), connection.fre69uency,
							  signal.data69"verb"69, signal.data69"language"69)
		else
			if(intercept)
				Broadcast_Message(signal.data69"connection"69, signal.data69"mob"69,
							  signal.data69"vmask"69, signal.data69"vmessage"69,
							  signal.data69"radio"69, signal.data69"message"69,
							  signal.data69"name"69, signal.data69"job"69,
							  signal.data69"realname"69, signal.data69"vname"69, 3, signal.data69"compression"69, list(0), connection.fre69uency,
							  signal.data69"verb"69, signal.data69"language"69)



/**

	Here is the big, bad function that broadcasts a69essage given the appropriate
	parameters.

	@param connection:
		The datum generated in radio.dm, stored in signal.data69"connection"69.

	@param69:
		Reference to the69ob/speaker, stored in signal.data69"mob"69

	@param69mask:
		Boolean69alue if the69ob is "hiding" its identity69ia69oice69ask, stored in
		signal.data69"vmask"69

	@param69message:
		If specified, will display this as the69essage; such as "chimpering"
		for69onkies if the69ob is not understood. Stored in signal.data69"vmessage"69.

	@param radio:
		Reference to the radio broadcasting the69essage, stored in signal.data69"radio"69

	@param69essage:
		The actual string69essage to display to69obs who understood69ob69. Stored in
		signal.data69"message"69

	@param name:
		The name to display when a69ob receives the69essage. signal.data69"name"69

	@param job:
		The name job to display for the AI when it receives the69essage. signal.data69"job"69

	@param realname:
		The "real" name associated with the69ob. signal.data69"realname"69

	@param69name:
		If specified, will use this name when69ob69 is not understood. signal.data69"vname"69

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate fre69uency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual69ob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal69ay be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param fre69
		The fre69uency of the signal

**/

/proc/Broadcast_Message(var/datum/radio_fre69uency/connection,69ar/mob/M,
						var/vmask,69ar/vmessage,69ar/obj/item/device/radio/radio,
						var/message,69ar/name,69ar/job,69ar/realname,69ar/vname,
						var/data,69ar/compression,69ar/list/level,69ar/fre69,69ar/verbage = "says",
						var/datum/language/speaking = null,69ar/text_size)


  /* ###### Prepare the radio connection ###### */

	var/display_fre69 = fre69

	var/list/obj/item/device/radio/radios = list()

	// --- Broadcast only to intercom devices ---

	if(data == 1)

		for (var/obj/item/device/radio/intercom/R in connection.devices69"69RADIO_CHAT69"69)
			if(R.receive_range(display_fre69, level) > -1)
				radios += R

	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == 2)

		for (var/obj/item/device/radio/R in connection.devices69"69RADIO_CHAT69"69)

			if(istype(R, /obj/item/device/radio/headset))
				continue

			if(R.receive_range(display_fre69, level) > -1)
				radios += R

	// --- Broadcast to antag radios! ---

	else if(data == 3)
		for(var/antag_fre69 in ANTAG_FRE69S)
			var/datum/radio_fre69uency/antag_connection = SSradio.return_fre69uency(antag_fre69)
			for (var/obj/item/device/radio/R in antag_connection.devices69"69RADIO_CHAT69"69)
				if(R.receive_range(antag_fre69, level) > -1)
					radios += R

	// --- Broadcast to ALL radio devices ---

	else

		for (var/obj/item/device/radio/R in connection.devices69"69RADIO_CHAT69"69)
			if(R.receive_range(display_fre69, level) > -1)
				radios += R

	// Get a list of69obs who can hear from the radios we collected.
	var/list/receive = get_mobs_in_radio_ranges(radios)

  /* ###### Organize the receivers into categories for displaying the69essage ###### */

  	// Understood the69essage:
	var/list/heard_masked 	= list() //69asked name or no real name
	var/list/heard_normal 	= list() // normal69essage

	// Did not understand the69essage:
	var/list/heard_voice 	= list() //69oice69essage	(ie "chimpers")
	var/list/heard_garbled	= list() // garbled69essage (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over69essage (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)
		SEND_SIGNAL(radio, COMSIG_MESSAGE_RECEIVED, R)
	  /* --- Loop through the receivers and categorize them --- */
		if(isnewplayer(R)) // we don't want new players to hear69essages. rare but generates runtimes.
			continue

		// Ghosts hearing all radio chat don't want to hear syndicate intercepts, they're duplicates
		if(data == 3 && isghost(R) && R.get_preference_value(/datum/client_preference/ghost_radio) == GLOB.PREF_ALL_CHATTER)
			continue

		// --- Check for compression ---
		if(compression > 0)
			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if (!M || R.say_understands(M))

			// - Not human or wearing a69oice69ask -
			if (!M || !ishuman(M) ||69mask)
				heard_masked += R

			// - Human and not wearing69oice69ask -
			else
				heard_normal += R

		// --- Can't understand the speech ---

		else
			// - The speaker has a prespecified "voice69essage" to display if not understood -
			if (vmessage)
				heard_voice += R

			// - Just display a garbled69essage -
			else
				heard_garbled += R


  /* ###### Begin formatting and sending the69essage ###### */
	if (length(heard_masked) || length(heard_normal) || length(heard_voice) || length(heard_garbled) || length(heard_gibberish))
		if(text_size)
			message = "<FONT size='69max(text_size, 1)69'>69message69</FONT>"

	  /* --- Some69iscellaneous69ariables to format the string output --- */
		var/fre69_text = get_fre69uency_name(display_fre69)

		var/part_b_extra = ""
		if(data == 3) // intercepted radio69essage
			part_b_extra = " <i>(Intercepted)</i>"
		var/part_a = "<span class='69fre69uency_span_class(display_fre69)69'>\icon69radio69<b>\6969fre69_text69\6969part_b_extra69</b> <span class='name'>" // goes in the actual output

		// --- Some69ore pre-message formatting ---
		var/part_b = "</span> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"


		// --- Filter the69essage; place it in 69uotes apply a69erb ---

		var/69uotedmsg = null
		if(M)
			69uotedmsg =69.say_69uote(message)
		else
			69uotedmsg = "says, \"69message69\""

		// --- This following recording is intended for research and feedback in the use of department radio channels ---

		var/part_blackbox_b = "</span><b> \6969fre69_text69\69</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/blackbox_msg = "69part_a6969name6969part_blackbox_b696969uotedmsg6969part_c69"
		//var/blackbox_admin_msg = "69part_a6969M.name69 (Real name: 69M.real_name69)69part_blackbox_b696969uotedmsg6969part_c69"


		if(istype(blackbox))
			switch(display_fre69)
				if(PUB_FRE69)
					blackbox.msg_common += blackbox_msg
				if(SCI_FRE69)
					blackbox.msg_science += blackbox_msg
				if(COMM_FRE69)
					blackbox.msg_command += blackbox_msg
				if(MED_FRE69)
					blackbox.msg_medical += blackbox_msg
				if(ENG_FRE69)
					blackbox.msg_engineering += blackbox_msg
				if(SEC_FRE69)
					blackbox.msg_security += blackbox_msg
				if(DTH_FRE69)
					blackbox.msg_deaths69uad += blackbox_msg
				if(SYND_FRE69)
					blackbox.msg_syndicate += blackbox_msg
				if(SUP_FRE69)
					blackbox.msg_cargo += blackbox_msg
				if(SRV_FRE69)
					blackbox.msg_service += blackbox_msg
				if(NT_FRE69)
					blackbox.msg_nt += blackbox_msg
				else
					blackbox.messages += blackbox_msg

		//End of research and feedback code.

	 /* ###### Send the69essage ###### */


	  	/* --- Process all the69obs that heard a69asked69oice (understood) --- */

		if (length(heard_masked))
			for (var/mob/R in heard_masked)
				R.hear_radio(message,verbage, speaking, part_a, part_b,69, 0, name)

		/* --- Process all the69obs that heard the69oice normally (understood) --- */

		if (length(heard_normal))
			for (var/mob/R in heard_normal)
				R.hear_radio(message,69erbage, speaking, part_a, part_b,69, 0, realname)

		/* --- Process all the69obs that heard the69oice normally (did not understand) --- */

		if (length(heard_voice))
			for (var/mob/R in heard_voice)
				R.hear_radio(message,verbage, speaking, part_a, part_b,69,0,69name)

		/* --- Process all the69obs that heard a garbled69oice (did not understand) --- */
			// Displays garbled69essage (ie "f*c* **u, **i*er!")

		if (length(heard_garbled))
			for (var/mob/R in heard_garbled)
				R.hear_radio(message,69erbage, speaking, part_a, part_b,69, 1,69name)


		/* --- Complete gibberish. Usually happens when there's a compressed69essage --- */

		if (length(heard_gibberish))
			for (var/mob/R in heard_gibberish)
				R.hear_radio(message,69erbage, speaking, part_a, part_b,69, 1)

	return 1

/proc/Broadcast_SimpleMessage(var/source,69ar/fre69uency,69ar/text,69ar/data,69ar/mob/M,69ar/compression,69ar/list/levels)

  /* ###### Prepare the radio connection ###### */

	if(!M)
		var/mob/living/carbon/human/H = new
		M = H

	var/datum/radio_fre69uency/connection = SSradio.return_fre69uency(fre69uency)

	var/display_fre69 = connection.fre69uency

	var/list/receive = list()


	// --- Broadcast only to intercom devices ---

	if(data == 1)
		for (var/obj/item/device/radio/intercom/R in connection.devices69"69RADIO_CHAT69"69)
			var/turf/position = get_turf(R)
			if(position && (position.z in levels))
				receive |= R.send_hear(display_fre69, position.z)


	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == 2)
		for (var/obj/item/device/radio/R in connection.devices69"69RADIO_CHAT69"69)

			if(istype(R, /obj/item/device/radio/headset))
				continue
			var/turf/position = get_turf(R)
			if(position && (position.z in levels))
				receive |= R.send_hear(display_fre69)


	// --- Broadcast to antag radios! ---

	else if(data == 3)
		for(var/fre69 in ANTAG_FRE69S)
			var/datum/radio_fre69uency/antag_connection = SSradio.return_fre69uency(fre69)
			for (var/obj/item/device/radio/R in antag_connection.devices69"69RADIO_CHAT69"69)
				var/turf/position = get_turf(R)
				if(position && (position.z in levels))
					receive |= R.send_hear(fre69)


	// --- Broadcast to ALL radio devices ---

	else
		for (var/obj/item/device/radio/R in connection.devices69"69RADIO_CHAT69"69)
			var/turf/position = get_turf(R)
			if(position && (position.z in levels))
				receive |= R.send_hear(display_fre69)


  /* ###### Organize the receivers into categories for displaying the69essage ###### */

	// Understood the69essage:
	var/list/heard_normal 	= list() // normal69essage

	// Did not understand the69essage:
	var/list/heard_garbled	= list() // garbled69essage (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over69essage (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */
		// --- Check for compression ---
		if(compression > 0)

			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if (R.say_understands(M))

			heard_normal += R

		// --- Can't understand the speech ---

		else
			// - Just display a garbled69essage -

			heard_garbled += R


  /* ###### Begin formatting and sending the69essage ###### */
	if (length(heard_normal) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some69iscellaneous69ariables to format the string output --- */
		var/part_a = "<span class='69fre69uency_span_class(display_fre69)69'><span class='name'>" // goes in the actual output
		var/fre69_text = get_fre69uency_name(display_fre69)

		// --- Some69ore pre-message formatting ---

		var/part_b_extra = ""
		if(data == 3) // intercepted radio69essage
			part_b_extra = " <i>(Intercepted)</i>"

		// Create a radio headset for the sole purpose of using its icon
		var/obj/item/device/radio/headset/radio = new

		var/part_b = "</span><b> \icon69radio69\6969fre69_text69\6969part_b_extra69</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_blackbox_b = "</span><b> \6969fre69_text69\69</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"

		var/blackbox_msg = "69part_a6969source6969part_blackbox_b69\"69text69\"69part_c69"


		if(istype(blackbox))
			switch(display_fre69)
				if(PUB_FRE69)
					blackbox.msg_common += blackbox_msg
				if(SCI_FRE69)
					blackbox.msg_science += blackbox_msg
				if(COMM_FRE69)
					blackbox.msg_command += blackbox_msg
				if(MED_FRE69)
					blackbox.msg_medical += blackbox_msg
				if(ENG_FRE69)
					blackbox.msg_engineering += blackbox_msg
				if(SEC_FRE69)
					blackbox.msg_security += blackbox_msg
				if(DTH_FRE69)
					blackbox.msg_deaths69uad += blackbox_msg
				if(SYND_FRE69)
					blackbox.msg_syndicate += blackbox_msg
				if(SUP_FRE69)
					blackbox.msg_cargo += blackbox_msg
				if(SRV_FRE69)
					blackbox.msg_service += blackbox_msg
				if(NT_FRE69)
					blackbox.msg_nt += blackbox_msg
				else
					blackbox.messages += blackbox_msg

		//End of research and feedback code.

	 /* ###### Send the69essage ###### */

		/* --- Process all the69obs that heard the69oice normally (understood) --- */

		if (length(heard_normal))
			var/rendered = "69part_a6969source6969part_b69\"69text69\"69part_c69"

			for (var/mob/R in heard_normal)
				R.show_message(rendered, 2)

		/* --- Process all the69obs that heard a garbled69oice (did not understand) --- */
			// Displays garbled69essage (ie "f*c* **u, **i*er!")

		if (length(heard_garbled))
			var/69uotedmsg = "\"69stars(text)69\""
			var/rendered = "69part_a6969source6969part_b696969uotedmsg6969part_c69"

			for (var/mob/R in heard_garbled)
				R.show_message(rendered, 2)


		/* --- Complete gibberish. Usually happens when there's a compressed69essage --- */

		if (length(heard_gibberish))
			var/69uotedmsg = "\"69Gibberish(text, compression + 50)69\""
			var/rendered = "69part_a6969Gibberish(source, compression + 50)6969part_b696969uotedmsg6969part_c69"

			for (var/mob/R in heard_gibberish)
				R.show_message(rendered, 2)

//Use this to test if an obj can communicate with a Telecommunications Network

/atom/proc/test_telecomms()
	var/datum/signal/signal = src.telecomms_process()
	var/turf/position = get_turf(src)
	return (position.z in signal.data69"level"69 && signal.data69"done"69)

/atom/proc/telecomms_process(var/do_sleep = 1)

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new
	signal.transmission_method = 2 // 2 would be a subspace transmission.
	var/turf/pos = get_turf(src)

	// --- Finally, tag the actual signal with the appropriate69alues ---
	signal.data = list(
		"slow" = 0, // how69uch to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our69essage too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = 4, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = pos.z // The level it is being broadcasted at.
	)
	signal.fre69uency = PUB_FRE69// Common channel

  //#### Sending the signal to all subspace receivers ####//
	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

	if(do_sleep)
		sleep(rand(10,25))

	//log_world("Level: 69signal.data69"level"6969 - Done: 69signal.data69"done"6969")

	return signal

