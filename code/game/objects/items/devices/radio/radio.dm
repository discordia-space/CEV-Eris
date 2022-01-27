// Access check is of the type re69uires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
var/global/list/default_internal_channels = list(
	num2text(PUB_FRE69) = list(),
	num2text(AI_FRE69)  = list(access_synth),
	num2text(COMM_FRE69)= list(access_heads),
	num2text(ENG_FRE69) = list(access_engine_e69uip, access_atmospherics),
	num2text(MED_FRE69) = list(access_medical_e69uip),
	num2text(NT_FRE69) = list(access_nt_disciple),
	num2text(MED_I_FRE69)=list(access_medical_e69uip),
	num2text(SEC_FRE69) = list(access_security),
	num2text(SEC_I_FRE69)=list(access_security),
	num2text(SCI_FRE69) = list(access_tox,access_robotics,access_xenobiology),
	num2text(SUP_FRE69) = list(access_cargo),
	num2text(SRV_FRE69) = list(access_janitor, access_hydroponics)
)

var/global/list/uni69ue_internal_channels = list(
	num2text(DTH_FRE69) = list(access_cent_specops)
)

var/global/list/default_medbay_channels = list(
	num2text(PUB_FRE69) = list(),
	num2text(MED_FRE69) = list(access_medical_e69uip),
	num2text(MED_I_FRE69) = list(access_medical_e69uip)
)

/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "ship bounced radio"
	suffix = "\693\69"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEM_SIZE_SMALL

	matter = list(MATERIAL_PLASTIC = 3,69ATERIAL_GLASS = 1)

	var/on = TRUE // 0 for off
	var/last_transmission
	var/fre69uency = PUB_FRE69 //common chat
	var/contractor_fre69uency = 0 //tune to fre69uency to unlock contractor supplies
	var/canhear_range = 3 // the range which69obs can hear this radio from
	var/datum/wires/radio/wires
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/subspace_transmission = 0
	var/syndie = 0//Holder to see if it's a syndicate encrypted radio
	var/const/FRE69_LISTENING = 1
	var/list/internal_channels

/obj/item/device/radio
	var/datum/radio_fre69uency/radio_connection
	var/list/datum/radio_fre69uency/secure_radio_connections = new

/obj/item/device/radio/proc/set_fre69uency(new_fre69uency)
	SSradio.remove_object(src, fre69uency)
	fre69uency = new_fre69uency
	radio_connection = SSradio.add_object(src, fre69uency, RADIO_CHAT)

/obj/item/device/radio/New()
	..()
	wires = new(src)
	internal_channels = default_internal_channels.Copy()
	if(syndie)
		internal_channels += uni69ue_internal_channels.Copy()
	add_hearing()

/obj/item/device/radio/Destroy()
	remove_hearing()
	69DEL_NULL(wires)
	SSradio.remove_object(src, fre69uency)
	for (var/ch_name in channels)
		SSradio.remove_object(src, radiochannels69ch_name69)

	return ..()


/obj/item/device/radio/Initialize()
	. = ..()

	if(fre69uency < RADIO_LOW_FRE69 || fre69uency > RADIO_HIGH_FRE69)
		fre69uency = sanitize_fre69uency(fre69uency, RADIO_LOW_FRE69, RADIO_HIGH_FRE69)
	set_fre69uency(fre69uency)

	for (var/ch_name in channels)
		secure_radio_connections69ch_name69 = SSradio.add_object(src, radiochannels69ch_name69,  RADIO_CHAT)

/obj/item/device/radio/attack_self(mob/user as69ob)
	user.set_machine(src)
	add_fingerprint(user)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return 0

	if(b_stat)
		wires.Interact(user)

	return ui_interact(user)

/obj/item/device/radio/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data69"mic_status"69 = broadcasting
	data69"speaker"69 = listening
	data69"fre69"69 = format_fre69uency(fre69uency)
	data69"rawfre69"69 = num2text(fre69uency)

	data69"mic_cut"69 = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data69"spk_cut"69 = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data69"chan_list"69 = chanlist
		data69"chan_list_len"69 = chanlist.len

	if(syndie)
		data69"useSyndMode"69 = 1

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "69name69", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/device/radio/proc/list_secure_channels(var/mob/user)
	var/dat69069

	for(var/ch_name in channels)
		var/chan_stat = channels69ch_name69
		var/listening = !!(chan_stat & FRE69_LISTENING) != 0

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "chan_span" = fre69uency_span_class(radiochannels69ch_name69))))

	return dat

/obj/item/device/radio/proc/list_internal_channels(var/mob/user)
	var/dat69069
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_fre69uency_name(text2num(internal_chan)), "chan_span" = fre69uency_span_class(text2num(internal_chan)))))

	return dat

/obj/item/device/radio/proc/has_channel_access(var/mob/user,69ar/fre69)
	if(!user)
		return 0

	if(!(fre69 in internal_channels))
		return 0

	return user.has_internal_radio_channel_access(internal_channels69fre6969)

/mob/proc/has_internal_radio_channel_access(var/list/re69_one_accesses)
	var/obj/item/card/id/I = GetIdCard()
	return has_access(list(), re69_one_accesses, I ? I.GetAccess() : list())

/mob/observer/ghost/has_internal_radio_channel_access(var/list/re69_one_accesses)
	return can_admin_interact()

/obj/item/device/radio/proc/text_wires()
	if (b_stat)
		return wires.GetInteractWindow()
	return


/obj/item/device/radio/proc/text_sec_channel(var/chan_name,69ar/chan_stat)
	var/list = !!(chan_stat&FRE69_LISTENING)!=0
	return {"
			<B>69chan_name69</B><br>
			Speaker: <A href='byond://?src=\ref69src69;ch_name=69chan_name69;listen=69!list69'>69list ? "Engaged" : "Disengaged"69</A><BR>
			"}

/obj/item/device/radio/proc/ToggleBroadcast()
	broadcasting = !broadcasting && !(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/device/radio/proc/ToggleReception()
	listening = !listening && !(wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

/obj/item/device/radio/CanUseTopic()
	if(!on)
		return STATUS_CLOSE
	return ..()

/obj/item/device/radio/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	if (href_list69"track"69)
		var/mob/target = locate(href_list69"track"69)
		var/mob/living/silicon/ai/A = locate(href_list69"track2"69)
		if(A && target)
			A.ai_actual_track(target)
		. = 1

	else if (href_list69"fre69"69)
		var/new_fre69uency = (fre69uency + text2num(href_list69"fre69"69))
		if ((new_fre69uency < PUBLIC_LOW_FRE69 || new_fre69uency > PUBLIC_HIGH_FRE69))
			new_fre69uency = sanitize_fre69uency(new_fre69uency)
		set_fre69uency(new_fre69uency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, fre69uency))
				hidden_uplink.trigger(usr)
				return
		. = 1
	else if (href_list69"talk"69)
		ToggleBroadcast()
		. = 1
	else if (href_list69"listen"69)
		var/chan_name = href_list69"ch_name"69
		if (!chan_name)
			ToggleReception()
		else
			if (channels69chan_name69 & FRE69_LISTENING)
				channels69chan_name69 &= ~FRE69_LISTENING
			else
				channels69chan_name69 |= FRE69_LISTENING
		. = 1
	else if(href_list69"spec_fre69"69)
		var fre69 = href_list69"spec_fre69"69
		if(has_channel_access(usr, fre69))
			set_fre69uency(text2num(fre69))
		. = 1
	if(href_list69"nowindow"69) // here for pAIs,69aybe others will want it, idk
		return 1

	if(.)
		SSnano.update_uis(src)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)

/obj/item/device/radio/proc/autosay(var/message,69ar/from,69ar/channel) //BS12 EDIT
	var/datum/radio_fre69uency/connection = null
	if(channel && channels && channels.len > 0)
		if (channel == "department")
			channel = channels69169
		connection = secure_radio_connections69channel69
	else
		connection = radio_connection
		channel = null
	if (!istype(connection))
		return
	if (!connection)
		return

	Broadcast_Message(connection, null,
						0, "*garbled automated announcement*", src,
						message, from, "Automated Announcement", from, "synthesized69oice",
						4, 0, list(0), connection.fre69uency, "states")
	return

// Interprets the69essage69ode when talking into a radio, possibly returning a connection datum
/obj/item/device/radio/proc/handle_message_mode(mob/living/M as69ob,69essage,69essage_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode ||69essage_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if (message_mode == "department") // Department radio shortcut
			message_mode = channels69169

		if (channels69message_mode69) // only broadcast if the channel is set on
			return secure_radio_connections69message_mode69

	// If we were to send to a channel we don't have, drop it.
	return null

/obj/item/device/radio/talk_into(mob/living/M as69ob,69essage, channel,69ar/verb = "says",69ar/datum/language/speaking = null,69ar/speech_volume)
	if(!on) return 0 // the device has to be on
	//  Fix for permacell radios, but kinda eh about actually fixing them.
	if(!M || !message) return 0

	//  Uncommenting this. To the above comment:
	// 	The permacell radios aren't suppose to be able to transmit, this isn't a bug and this "fix" is just69aking radio wires useless. -Giacom
	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return 0

	if(!radio_connection)
		set_fre69uency(fre69uency)

	/* 69uick introduction:
		This new radio system uses a69ery robust FTL signaling technology unoriginally
		dubbed "subspace" which is somewhat similar to 'blue-space' but can't
		actually transmit large69ass. Headsets are the only radio devices capable
		of sending subspace transmissions to the Communications Satellite.

		A headset sends a signal to a subspace listener/reciever elsewhere in space,
		the signal gets processed and logged, and an audible transmission gets sent
		to each individual headset.
	*/

	//#### Grab the connection datum ####//
	var/datum/radio_fre69uency/connection = handle_message_mode(M,69essage, channel)
	if (!istype(connection))
		return 0
	if (!connection)
		return 0

	var/turf/position = get_turf(src)

	//#### Tagging the signal with all appropriate identity69alues ####//

	// ||-- The69ob's name identity --||
	var/displayname =69.name	// grab the display name (name you get when you hover over someone's icon)
	var/real_name =69.real_name //69ob's real name
	var/mobkey = "none" // player key associated with69ob
	var/voicemask = 0 // the speaker is wearing a69oice69ask
	if(M.client)
		mobkey =69.key // assign the69ob's key


	var/jobname // the69ob's "job"

	// --- Human: use their actual job ---
	if (ishuman(M))
		var/mob/living/carbon/human/H =69
		jobname = H.get_assignment()

	// --- Carbon Nonhuman ---
	else if (iscarbon(M)) // Nonhuman carbon69ob
		jobname = "No id"

	// --- AI ---
	else if (isAI(M))
		jobname = "AI"

	// --- Cyborg ---
	else if (isrobot(M))
		jobname = "Robot"

	// --- Personal AI (pAI) ---
	else if (istype(M, /mob/living/silicon/pai))
		jobname = "Personal AI"

	// --- Unidentifiable69ob ---
	else
		jobname = "Unknown"


	// ---69odifications to the69ob's identity ---

	// The69ob is disguising their identity:
	if (ishuman(M) &&69.GetVoice() != real_name)
		displayname =69.GetVoice()
		jobname = "Unknown"
		voicemask = 1
	SEND_SIGNAL(src, COMSIG_MESSAGE_SENT)



  /* ###### Radio headsets can only broadcast through subspace ###### */

	if(subspace_transmission)
		// First, we want to generate a new radio signal
		var/datum/signal/signal = new
		signal.transmission_method = 2 // 2 would be a subspace transmission.
									   // transmission_method could probably be enumerated through #define. Would be neater.

		// --- Finally, tag the actual signal with the appropriate69alues ---
		signal.data = list(
		  // Identity-associated tags:
			"mob" =69, // store a reference to the69ob
			"mobtype" =69.type, 	// the69ob's type
			"realname" = real_name, // the69ob's real name
			"name" = displayname,	// the69ob's display name
			"job" = jobname,		// the69ob's job
			"key" =69obkey,			// the69ob's key
			"vmessage" = pick(M.speak_emote), // the69essage to display if the69oice wasn't understood
			"vname" =69.voice_name, // the name to display if the69oice wasn't understood
			"vmask" =69oicemask,	// 1 if the69ob is using a69oice gas69ask

			// We store things that would otherwise be kept in the actual69ob
			// so that they can be logged even AFTER the69ob is deleted or something

		  // Other tags:
			"compression" = rand(45,50), // compressed radio signal
			"message" =69essage, // the actual sent69essage
			"connection" = connection, // the radio connection to use
			"radio" = src, // stores the radio used for transmission
			"slow" = 0, // how69uch to sleep() before broadcasting - simulates net lag
			"traffic" = 0, // dictates the total traffic sum that the signal went through
			"type" = 0, // determines what type of radio input it is: normal broadcast
			"server" = null, // the last server to log this signal
			"reject" = 0,	// if nonzero, the signal will not be accepted by any broadcasting69achinery
			"level" = position.z, // The source's z level
			"language" = speaking,
			"verb" =69erb,
			"speech_volume" = speech_volume
		)
		signal.fre69uency = connection.fre69uency // 69uick fre69uency set

	  //#### Sending the signal to all subspace receivers ####//

		for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
			R.receive_signal(signal)

		// Allinone can act as receivers.
		for(var/obj/machinery/telecomms/allinone/R in telecomms_list)
			R.receive_signal(signal)

		// Receiving code can be located in Telecommunications.dm
		return signal.data69"done"69 && (position.z in signal.data69"level"69)


  /* ###### Intercoms and station-bounced radios ###### */

	var/filter_type = 2

	/* --- Intercoms can only broadcast to other intercoms, but bounced radios can broadcast to bounced radios and intercoms --- */
	if(istype(src, /obj/item/device/radio/intercom))
		filter_type = 1


	var/datum/signal/signal = new
	signal.transmission_method = 2


	/* --- Try to send a normal subspace broadcast first */

	signal.data = list(

		"mob" =69, // store a reference to the69ob
		"mobtype" =69.type, 	// the69ob's type
		"realname" = real_name, // the69ob's real name
		"name" = displayname,	// the69ob's display name
		"job" = jobname,		// the69ob's job
		"key" =69obkey,			// the69ob's key
		"vmessage" = pick(M.speak_emote), // the69essage to display if the69oice wasn't understood
		"vname" =69.voice_name, // the name to display if the69oice wasn't understood
		"vmask" =69oicemask,	// 1 if the69ob is using a69oice gas69as

		"compression" = 0, // uncompressed radio signal
		"message" =69essage, // the actual sent69essage
		"connection" = connection, // the radio connection to use
		"radio" = src, // stores the radio used for transmission
		"slow" = 0,
		"traffic" = 0,
		"type" = 0,
		"server" = null,
		"reject" = 0,
		"level" = position.z,
		"language" = speaking,
		"verb" =69erb,
		"speech_volume" = speech_volume
	)
	signal.fre69uency = connection.fre69uency // 69uick fre69uency set

	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)


	sleep(rand(10,25)) // wait a little...

	if(signal.data69"done"69 && (position.z in signal.data69"level"69))
		// we're done here.
		return 1

	// Oh69y god; the comms are down or something because the signal hasn't been broadcasted yet in our level.
	// Send a69undane broadcast with limited targets:

	//THIS IS TEMPORARY. YEAH RIGHT. STATE OF SS13 DEVELOPMENT...
	if(!connection)	return 0	//~Carn

	return Broadcast_Message(connection,69,69oicemask, pick(M.speak_emote),
					  src,69essage, displayname, jobname, real_name,69.voice_name,
					  filter_type, signal.data69"compression"69, list(position.z), connection.fre69uency,verb,speaking, speech_volume)


/obj/item/device/radio/hear_talk(mob/M as69ob,69sg,69ar/verb = "says",69ar/datum/language/speaking = null, speech_volume)

	if (broadcasting)
		if(get_dist(src,69) <= canhear_range)
			talk_into(M,69sg,null,verb,speaking, speech_volume)


/*
/obj/item/device/radio/proc/accept_rad(obj/item/device/radio/R as obj,69essage)

	if ((R.fre69uency == fre69uency &&69essage))
		return 1
	else if

	else
		return null
	return
*/


/obj/item/device/radio/proc/receive_range(fre69, level)
	// check if this radio can receive on the given fre69uency, and if so,
	// what the range is in which69obs will hear the radio
	// returns: -1 if can't receive, range otherwise

	if (wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!listening)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(!position || !(position.z in level))
			return -1
	if(fre69 in ANTAG_FRE69S)
		if(!(src.syndie))//Checks to see if it's allowed on that fre69uency, based on the encryption keys
			return -1
	if (!on)
		return -1

	if (!fre69) //recieved on69ain fre69uency
		if (!listening)
			return -1
	else
		var/accept = (fre69==fre69uency && listening)
		if (!accept)
			for (var/ch_name in channels)
				var/datum/radio_fre69uency/RF = secure_radio_connections69ch_name69
				if (RF.fre69uency==fre69 && (channels69ch_name69&FRE69_LISTENING))
					accept = 1
					break

		if (!accept)
			return -1
	return canhear_range

/obj/item/device/radio/proc/send_hear(fre69, level)

	var/range = receive_range(fre69, level)
	if(range > -1)
		return get_mobs_or_objects_in_view(canhear_range, src)


/obj/item/device/radio/examine(mob/user)
	. = ..()
	if ((in_range(src, user) || loc == user))
		if (b_stat)
			user.show_message(SPAN_NOTICE("\The 69src69 can be attached and69odified!"))
		else
			user.show_message(SPAN_NOTICE("\The 69src69 can not be69odified or attached!"))
	return

/obj/item/device/radio/attackby(obj/item/W as obj,69ob/user as69ob)
	..()
	user.set_machine(src)
	if (!( istype(W, /obj/item/tool/screwdriver) ))
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/device/radio/beacon))
		if (b_stat)
			user.show_message(SPAN_NOTICE("\The 69src69 can now be attached and69odified!"))
		else
			user.show_message(SPAN_NOTICE("\The 69src69 can no longer be69odified or attached!"))
		updateDialog()
			//Foreach goto(83)
		add_fingerprint(user)
		return
	else return

/obj/item/device/radio/emp_act(severity)
	broadcasting = 0
	listening = 0
	for (var/ch_name in channels)
		channels69ch_name69 = 0
	..()

///////////////////////////////
//////////Borg Radios//////////
///////////////////////////////
//Giving borgs their own radio to have some69ore room to work with -Sieve

/obj/item/device/radio/borg
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = 1
	spawn_fre69uency = 0
	var/mob/living/silicon/robot/myborg // Cyborg which owns this radio. Used for power checks
	var/obj/item/device/encryptionkey/keyslot //Borg radios can handle a single encryption key
	var/shut_up = 1

/obj/item/device/radio/borg/Destroy()
	myborg = null
	return ..()

/obj/item/device/radio/borg/list_channels(mob/user)
	return list_secure_channels(user)

/obj/item/device/radio/borg/talk_into(mob/living/M,69essage, channel,69ar/verb = "says",69ar/datum/language/speaking = null,69ar/speech_volume)
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components69"radio"69
		R.cell_use_power(C.active_usage)

/obj/item/device/radio/borg/attackby(obj/item/W,69ob/user)
	//..()
	user.set_machine(src)
	if (!( istype(W, /obj/item/tool/screwdriver) || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(istype(W, /obj/item/tool/screwdriver))
		if(keyslot)


			for(var/ch_name in channels)
				SSradio.remove_object(src, radiochannels69ch_name69)
				secure_radio_connections69ch_name69 = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.loc = T
					keyslot = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			user.drop_item()
			W.loc = src
			keyslot = W

		recalculateChannels()

	return

/obj/item/device/radio/borg/proc/recalculateChannels()
	src.channels = list()
	src.syndie = 0

	var/mob/living/silicon/robot/D = src.loc
	if(D.module)
		for(var/ch_name in D.module.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels69ch_name69 += D.module.channels69ch_name69
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in src.channels)
				continue
			src.channels += ch_name
			src.channels69ch_name69 += keyslot.channels69ch_name69

		if(keyslot.syndie)
			src.syndie = 1

	for (var/ch_name in src.channels)
		secure_radio_connections69ch_name69 = SSradio.add_object(src, radiochannels69ch_name69,  RADIO_CHAT)

	return

/obj/item/device/radio/borg/Topic(href, href_list)
	if(..())
		return 1
	if (href_list69"mode"69)
		var/enable_subspace_transmission = text2num(href_list69"mode"69)
		if(enable_subspace_transmission != subspace_transmission)
			subspace_transmission = !subspace_transmission
			if(subspace_transmission)
				to_chat(usr, SPAN_NOTICE("Subspace Transmission is enabled"))
			else
				to_chat(usr, SPAN_NOTICE("Subspace Transmission is disabled"))

			if(subspace_transmission == 0)//Simple as fuck, clears the channel list to prevent talking/listening over them if subspace transmission is disabled
				channels = list()
			else
				recalculateChannels()
		. = 1
	if (href_list69"shutup"69) // Toggle loudspeaker69ode, AKA everyone around you hearing your radio.
		var/do_shut_up = text2num(href_list69"shutup"69)
		if(do_shut_up != shut_up)
			shut_up = !shut_up
			if(shut_up)
				canhear_range = 0
				to_chat(usr, SPAN_NOTICE("Loadspeaker disabled."))
			else
				canhear_range = 3
				to_chat(usr, SPAN_NOTICE("Loadspeaker enabled."))
		. = 1

	if(.)
		SSnano.update_uis(src)

/obj/item/device/radio/borg/interact(mob/user as69ob)
	if(!on)
		return

	. = ..()

/obj/item/device/radio/borg/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069

	data69"mic_status"69 = broadcasting
	data69"speaker"69 = listening
	data69"fre69"69 = format_fre69uency(fre69uency)
	data69"rawfre69"69 = num2text(fre69uency)

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data69"chan_list"69 = chanlist
		data69"chan_list_len"69 = chanlist.len

	if(syndie)
		data69"useSyndMode"69 = 1

	data69"has_loudspeaker"69 = 1
	data69"loudspeaker"69 = !shut_up
	data69"has_subspace"69 = 1
	data69"subspace"69 = subspace_transmission

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "69name69", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/config(op)
	for (var/ch_name in channels)
		SSradio.remove_object(src, radiochannels69ch_name69)
	secure_radio_connections = new
	channels = op
	for (var/ch_name in op)
		secure_radio_connections69ch_name69 = SSradio.add_object(src, radiochannels69ch_name69,  RADIO_CHAT)
	return

/obj/item/device/radio/off
	listening = 0

/obj/item/device/radio/phone
	broadcasting = 0
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	listening = 1
	name = "phone"

/obj/item/device/radio/phone/medbay
	fre69uency =69ED_I_FRE69

/obj/item/device/radio/phone/medbay/New()
	..()
	internal_channels = default_medbay_channels.Copy()

/obj/item/device/radio/random_radio
	name = "Random wave radio"
	desc = "Radio that can pick up69essages from secure channels, but with small chance. Provides intel about hidden loot over time. It can be repaired by oddity with69echanical aspect."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "random_radio"
	item_state = "random_radio"
	slot_flags = FALSE
	canhear_range = 4
	var/random_hear = 20
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "NT69oice" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "AI Private" = 1)
	price_tag = 20000
	origin_tech = list(TECH_DATA = 7, TECH_ENGINEERING = 7, TECH_COVERT = 7)
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	var/list/obj/item/oddity/used_oddity = list()
	var/last_produce = 0
	var/cooldown = 4069INUTES
	var/max_cooldown = 4069INUTES
	var/min_cooldown = 1569INUTES
	w_class = ITEM_SIZE_BULKY

/obj/item/device/radio/random_radio/New()
	..()
	GLOB.all_faction_items69src69 = GLOB.department_guild
	START_PROCESSING(SSobj, src)

/obj/item/device/radio/random_radio/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/mob/living/carbon/human/H in69iewers(get_turf(src)))
		SEND_SIGNAL(H, COMSIG_OBJ_FACTION_ITEM_DESTROY, src)
	GLOB.all_faction_items -= src
	GLOB.guild_faction_item_loss++
	. = ..()

/obj/item/device/radio/random_radio/Process()
	if(world.time >= (last_produce + cooldown))
		var/datum/stash/stash = pick_n_take_stash_datum()
		if(!stash)
			return
		stash.select_location()
		stash.spawn_stash()
		var/obj/item/paper/stash_note = stash.spawn_note(get_turf(src))
		visible_message(SPAN_NOTICE("69src69 spits out a 69stash_note69."))
		last_produce = world.time

/obj/item/device/radio/random_radio/receive_range(fre69, level)

	if (wires.IsIndexCut(WIRE_RECEIVE))
		return -1
	if(!listening)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(!position || !(position.z in level))
			return -1
	if(fre69 in ANTAG_FRE69S)
		if(!(src.syndie))//Checks to see if it's allowed on that fre69uency, based on the encryption keys
			return -1
	if (!on)
		return -1

	if(random_hear)
		if(prob(random_hear))
			return canhear_range

/obj/item/device/radio/random_radio/emag_act(mob/user)
	if(!syndie)
		syndie = TRUE
		channels |= list("Mercenary" = 1)
		playsound(loc, "sparks", 75, 1, -1)
		to_chat(user, SPAN_NOTICE("You use the cryptographic se69uencer on the 69name69."))
	else
		to_chat(user, SPAN_NOTICE("The 69name69 has already been emagged."))
		return NO_EMAG_ACT

/obj/item/device/radio/random_radio/attackby(obj/item/W,69ob/user, params)
	if(nt_sword_attack(W, user))
		return FALSE
	user.set_machine(src)

	if(istype(W, /obj/item/oddity))
		var/obj/item/oddity/D = W
		if(D.oddity_stats)
			var/usefull = FALSE

			if(random_hear >= 100)
				to_chat(user, SPAN_WARNING("The 69src69 is in perfect condition."))
				return

			to_chat(user, SPAN_NOTICE("You begin repairing 69src69 using 69D69."))

			if(!do_after(user, 20 SECONDS, src))
				to_chat(user, SPAN_WARNING("You've stopped repairing 69src69."))
				return

			if(D in used_oddity)
				to_chat(user, SPAN_WARNING("You've already used 69D69 to repair 69src69!"))
				return

			for(var/stat in D.oddity_stats)
				if(stat == STAT_MEC)
					var/increase = D.oddity_stats69stat69 * 3
					random_hear += increase
					if(random_hear > 100)
						random_hear = 100
					cooldown -= (D.oddity_stats69stat69)69INUTES
					if(cooldown <69in_cooldown)
						cooldown =69in_cooldown
					to_chat(user, SPAN_NOTICE("You69ake use of 69D69, and repaired 69src69 by 69increase69%."))
					usefull = TRUE
					used_oddity += D
					return


			if(!usefull)
				to_chat(user, SPAN_WARNING("You cannot find any use of 69D69,69aybe you need something related to69echanic to repair this?"))
		else
			to_chat(user, SPAN_WARNING("The 69D69 is useless here. Try to find another one."))
