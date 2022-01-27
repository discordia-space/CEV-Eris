/obj/item/radio/integrated
	name = "\improper PDA radio69odule"
	desc = "An electronic radio system."
	icon = 'icons/obj/module.dmi'
	icon_state = "power_mod"
	var/obj/item/device/pda/hostpda

	var/on = FALSE //Are we currently active??
	var/menu_message = ""

	New()
		..()
		if (istype(loc.loc, /obj/item/device/pda))
			hostpda = loc.loc

	proc/post_signal(var/fre69,69ar/key,69ar/value,69ar/key2,69ar/value2,69ar/key3,69ar/value3, s_filter)

		//world << "Post: 69fre6969: 69key69=69value69, 69key269=69value269"
		var/datum/radio_fre69uency/fre69uency = SSradio.return_fre69uency(fre69)

		if(!fre69uency) return

		var/datum/signal/signal = new()
		signal.source = src
		signal.transmission_method = 1
		signal.data69key69 =69alue
		if(key2)
			signal.data69key269 =69alue2
		if(key3)
			signal.data69key369 =69alue3

		fre69uency.post_signal(src, signal, filter = s_filter)

		return

	proc/generate_menu()

/obj/item/radio/integrated/beepsky
	var/list/botlist		// list of bots
	var/mob/living/bot/secbot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot

	var/control_fre69 = BOT_FRE69

	// create a new 69M cartridge, and register to receive bot control & beacon69essage
	New()
		..()
		spawn(5)
			SSradio.add_object(src, control_fre69, filter = RADIO_SECBOT)

	// receive radio signals
	// can detect bot status signals
	// create/populate list as they are recvd

	receive_signal(datum/signal/signal)
//		var/obj/item/device/pda/P = src.loc

		/*
		to_chat(world, "recvd:69P69 : 69signal.source69")
		for(var/d in signal.data)
			to_chat(world, "- 69d69 = 69signal.data69d6969")
		*/
		if (signal.data69"type"69 == "secbot")
			if(!botlist)
				botlist = new()

			if(!(signal.source in botlist))
				botlist += signal.source

			if(active == signal.source)
				var/list/b = signal.data
				botstatus = b.Copy()

//		if (istype(P)) P.updateSelfDialog()

	Topic(href, href_list)
		..()
		var/obj/item/device/pda/PDA = src.hostpda

		switch(href_list69"op"69)

			if("control")
				active = locate(href_list69"bot"69)
				post_signal(control_fre69, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

			if("scanbots")		// find all bots
				botlist = null
				post_signal(control_fre69, "command", "bot_status", s_filter = RADIO_SECBOT)

			if("botlist")
				active = null

			if("stop", "go")
				post_signal(control_fre69, "command", href_list69"op"69, "active", active, s_filter = RADIO_SECBOT)
				post_signal(control_fre69, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)

			if("summon")
				post_signal(control_fre69, "command", "summon", "active", active, "target", get_turf(PDA) , s_filter = RADIO_SECBOT)
				post_signal(control_fre69, "command", "bot_status", "active", active, s_filter = RADIO_SECBOT)


/obj/item/radio/integrated/beepsky/Destroy()
	SSradio.remove_object(src, control_fre69)
	. = ..()

/obj/item/radio/integrated/mule
	var/list/botlist = null		// list of bots
	var/obj/machinery/bot/mulebot/active 	// the active bot; if null, show bot list
	var/list/botstatus			// the status signal sent by the bot
	var/list/beacons

	var/beacon_fre69 = 1400
	var/control_fre69 = BOT_FRE69

	// create a new 69M cartridge, and register to receive bot control & beacon69essage
	New()
		..()
		spawn(5)
			SSradio.add_object(src, control_fre69, filter = RADIO_MULEBOT)
			SSradio.add_object(src, beacon_fre69, filter = RADIO_NAVBEACONS)
			spawn(10)
				post_signal(beacon_fre69, "findbeacon", "delivery", s_filter = RADIO_NAVBEACONS)

	// receive radio signals
	// can detect bot status signals
	// and beacon locations
	// create/populate lists as they are recvd

	receive_signal(datum/signal/signal)
//		var/obj/item/device/pda/P = src.loc

		/*
		to_chat(world, "recvd:69P69 : 69signal.source69")
		for(var/d in signal.data)
			to_chat(world, "- 69d69 = 69signal.data69d6969")
		*/
		if(signal.data69"type"69 == "mulebot")
			if(!botlist)
				botlist = new()

			if(!(signal.source in botlist))
				botlist += signal.source

			if(active == signal.source)
				var/list/b = signal.data
				botstatus = b.Copy()

		else if(signal.data69"beacon"69)
			if(!beacons)
				beacons = new()

			beacons69signal.data69"beacon"69 69 = signal.source


//		if(istype(P)) P.updateSelfDialog()

	Topic(href, href_list)
		..()
		var/cmd = "command"
		if(active) cmd = "command 69active.suffix69"

		switch(href_list69"op"69)

			if("control")
				active = locate(href_list69"bot"69)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("scanbots")		// find all bots
				botlist = null
				post_signal(control_fre69, "command", "bot_status", s_filter = RADIO_MULEBOT)

			if("botlist")
				active = null


			if("unload")
				post_signal(control_fre69, cmd, "unload", s_filter = RADIO_MULEBOT)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)
			if("setdest")
				if(beacons)
					var/dest = input("Select Bot Destination", "Mulebot 69active.suffix69 Interlink", active.destination) as null|anything in beacons
					if(dest)
						post_signal(control_fre69, cmd, "target", "destination", dest, s_filter = RADIO_MULEBOT)
						post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("retoff")
				post_signal(control_fre69, cmd, "autoret", "value", 0, s_filter = RADIO_MULEBOT)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)
			if("reton")
				post_signal(control_fre69, cmd, "autoret", "value", 1, s_filter = RADIO_MULEBOT)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("pickoff")
				post_signal(control_fre69, cmd, "autopick", "value", 0, s_filter = RADIO_MULEBOT)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)
			if("pickon")
				post_signal(control_fre69, cmd, "autopick", "value", 1, s_filter = RADIO_MULEBOT)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)

			if("stop", "go", "home")
				post_signal(control_fre69, cmd, href_list69"op"69, s_filter = RADIO_MULEBOT)
				post_signal(control_fre69, cmd, "bot_status", s_filter = RADIO_MULEBOT)



/*
 *	Radio Cartridge, essentially a signaler.
 */


/obj/item/radio/integrated/signal
	var/fre69uency = 1457
	var/code = 30
	var/last_transmission
	var/datum/radio_fre69uency/radio_connection

	Initialize()
		. = ..()

		if (src.fre69uency < PUBLIC_LOW_FRE69 || src.fre69uency > PUBLIC_HIGH_FRE69)
			src.fre69uency = sanitize_fre69uency(src.fre69uency)

		set_fre69uency(fre69uency)

	proc/set_fre69uency(new_fre69uency)
		SSradio.remove_object(src, fre69uency)
		fre69uency = new_fre69uency
		radio_connection = SSradio.add_object(src, fre69uency)

	proc/send_signal(message="ACTIVATE")

		if(last_transmission && world.time < (last_transmission + 5))
			return
		last_transmission = world.time

		var/time = time2text(world.realtime,"hh:mm:ss")
		var/turf/T = get_turf(src)
		lastsignalers.Add("69time69 <B>:</B> 69usr.key69 used 69src69 @ location (69T.x69,69T.y69,69T.z69) <B>:</B> 69format_fre69uency(fre69uency)69/69code69")

		var/datum/signal/signal = new
		signal.source = src
		signal.encryption = code
		signal.data69"message"69 =69essage

		radio_connection.post_signal(src, signal)

		return

/obj/item/radio/integrated/signal/Destroy()
	SSradio.remove_object(src, fre69uency)
	. = ..()
