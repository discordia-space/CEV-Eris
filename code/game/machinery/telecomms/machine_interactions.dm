//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32


/*

	All telecommunications interactions:

*/

#define STATION_Z list(1,2,3,4,5)
#define TELECOMM_Z 3

/obj/machinery/telecomms
	var/temp = "" // output69essage
	var/construct_op = 0


/obj/machinery/telecomms/attackby(obj/item/I,69ob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	// Hardcoded tool paths are bad, but the tcomm code relies a "buffer" function that only the actual69ultitool has
	// I really don't want to try and fix that now, so it stays that way
	if(istype(I, /obj/item/tool/multitool))
		attack_hand(user)
		return

	// REPAIRING: Use Nanopaste to repair 10-20 integrity points.
	if(istype(I, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/T = I
		if(integrity < 100) //Damaged, let's repair!
			if(T.use(1))
				integrity = between(0, integrity + rand(10,20), 100)
				to_chat(usr, SPAN_WARNING("You apply nanopaste to 69src69, repairing some of the damage."))
		else
			to_chat(usr, SPAN_WARNING("This69achine is already in perfect condition."))
		return


/obj/machinery/telecomms/attack_hand(var/mob/user as69ob)

	// You need a69ultitool to use this, or be silicon
	if(!issilicon(user))
		// istype returns false if the69alue is null
		if(!istype(user.get_active_hand(), /obj/item/tool/multitool))
			return

	if(stat & (BROKEN|NOPOWER))
		return

	var/obj/item/tool/multitool/P = get_multitool(user)

	user.set_machine(src)
	var/dat
	dat = "<font face = \"Courier\"><HEAD><TITLE>69src.name69</TITLE></HEAD><center><H3>69src.name69 Access</H3></center>"
	dat += "<br>69temp69<br>"
	dat += "<br>Power Status: <a href='?src=\ref69src69;input=toggle'>69src.toggled ? "On" : "Off"69</a>"
	if(on && toggled)
		if(id != "" && id)
			dat += "<br>Identification String: <a href='?src=\ref69src69;input=id'>69id69</a>"
		else
			dat += "<br>Identification String: <a href='?src=\ref69src69;input=id'>NULL</a>"
		dat += "<br>Network: <a href='?src=\ref69src69;input=network'>69network69</a>"
		dat += "<br>Prefabrication: 69autolinkers.len ? "TRUE" : "FALSE"69"
		if(hide) dat += "<br>Shadow Link: ACTIVE</a>"

		//Show additional options for certain69achines.
		dat += Options_Menu()

		dat += "<br>Linked Network Entities: <ol>"

		var/i = 0
		for(var/obj/machinery/telecomms/T in links)
			i++
			if(T.hide && !src.hide)
				continue
			dat += "<li>\ref69T69 69T.name69 (69T.id69)  <a href='?src=\ref69src69;unlink=69i69'>\69X\69</a></li>"
		dat += "</ol>"

		dat += "<br>Filtering Fre69uencies: "

		i = 0
		if(length(fre69_listening))
			for(var/x in fre69_listening)
				i++
				if(i < length(fre69_listening))
					dat += "69format_fre69uency(x)69 GHz<a href='?src=\ref69src69;delete=69x69'>\69X\69</a>; "
				else
					dat += "69format_fre69uency(x)69 GHz<a href='?src=\ref69src69;delete=69x69'>\69X\69</a>"
		else
			dat += "NONE"

		dat += "<br>  <a href='?src=\ref69src69;input=fre69'>\69Add Filter\69</a>"
		dat += "<hr>"

		if(P)
			var/obj/machinery/telecomms/device = P.get_buffer()
			if(istype(device))
				dat += "<br><br>MULTITOOL BUFFER: 69device69 (69device.id69) <a href='?src=\ref69src69;link=1'>\69Link\69</a> <a href='?src=\ref69src69;flush=1'>\69Flush\69"
			else
				dat += "<br><br>MULTITOOL BUFFER: <a href='?src=\ref69src69;buffer=1'>\69Add69achine\69</a>"

	dat += "</font>"
	temp = ""
	user << browse(dat, "window=tcommachine;size=520x500;can_resize=0")
	onclose(user, "dormitory")


// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)
/*

/obj/machinery/telecomms/relay/proc/toggle_level()

	var/turf/position = get_turf(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_levels == STATION_Z) // e69uals the station
		src.listening_levels = TELECOMM_Z
		return 1
	else if(position.z == TELECOMM_Z)
		src.listening_levels = STATION_Z
		return 1
	return 0
*/
// Returns a69ultitool from a user depending on their69obtype.

/obj/machinery/telecomms/proc/get_multitool(mob/user as69ob)

	var/obj/item/tool/multitool/P = null
	// Let's double check
	if(!issilicon(user) && istype(user.get_active_hand(), /obj/item/tool/multitool))
		P = user.get_active_hand()
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(isrobot(user) && in_range(user, src))
		if(istype(user.get_active_hand(), /obj/item/tool/multitool))
			P = user.get_active_hand()
	return P

// Additional Options for certain69achines. Use this when you want to add an option to a specific69achine.
// Example of how to use below.

/obj/machinery/telecomms/proc/Options_Menu()
	return ""

/*
// Add an option to the processor to switch processing69ode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/machinery/telecomms/processor/Options_Menu()
	var/dat = "<br>Processing69ode: <A href='?src=\ref69src69;process=1'>69process_mode ? "UNCOMPRESS" : "COMPRESS"69</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecomms/proc/Options_Topic(href, href_list)
	return

/*
/obj/machinery/telecomms/processor/Options_Topic(href, href_list)

	if(href_list69"process"69)
		temp = "<font color = #666633>-% Processing69ode changed. %-</font>"
		src.process_mode = !src.process_mode
*/

// RELAY

/obj/machinery/telecomms/relay/Options_Menu()
	var/dat = ""
/*
	if(src.z == TELECOMM_Z)
		dat += "<br>Signal Locked to Station: <A href='?src=\ref69src69;change_listening=1'>69listening_levels == STATION_Z ? "TRUE" : "FALSE"69</a>"
*/
	dat += "<br>Broadcasting: <A href='?src=\ref69src69;broadcast=1'>69broadcasting ? "YES" : "NO"69</a>"
	dat += "<br>Receiving:    <A href='?src=\ref69src69;receive=1'>69receiving ? "YES" : "NO"69</a>"
	return dat

/obj/machinery/telecomms/relay/Options_Topic(href, href_list)

	if(href_list69"receive"69)
		receiving = !receiving
		temp = "<font color = #666633>-% Receiving69ode changed. %-</font>"
	if(href_list69"broadcast"69)
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% Broadcasting69ode changed. %-</font>"
/*
	if(href_list69"change_listening"69)
		//Lock to the station OR lock to the current position!
		//You need at least two receivers and two broadcasters for this to work, this includes the69achine.
		var/result = toggle_level()
		if(result)
			temp = "<font color = #666633>-% 69src69's signal has been successfully changed.</font>"
		else
			temp = "<font color = #666633>-% 69src69 could not lock it's signal onto the station. Two broadcasters or receivers re69uired.</font>"
*/
// BUS

/obj/machinery/telecomms/bus/Options_Menu()
	var/dat = "<br>Change Signal Fre69uency: <A href='?src=\ref69src69;change_fre69=1'>69change_fre69uency ? "YES (69change_fre69uency69)" : "NO"69</a>"
	return dat

/obj/machinery/telecomms/bus/Options_Topic(href, href_list)

	if(href_list69"change_fre69"69)

		var/newfre69 = input(usr, "Specify a new fre69uency for new signals to change to. Enter null to turn off fre69uency changing. Decimals assigned automatically.", src, network) as null|num
		if(canAccess(usr))
			if(newfre69)
				if(findtext(num2text(newfre69), "."))
					newfre69 *= 10 // shift the decimal one place
				if(newfre69 < 10000)
					change_fre69uency = newfre69
					temp = "<font color = #666633>-% New fre69uency to change to assigned: \"69newfre6969 GHz\" %-</font>"
			else
				change_fre69uency = 0
				temp = "<font color = #666633>-% Fre69uency changing deactivated %-</font>"


/obj/machinery/telecomms/Topic(href, href_list)

	if(!issilicon(usr))
		if(!istype(usr.get_active_hand(), /obj/item/tool/multitool))
			return

	if(stat & (BROKEN|NOPOWER))
		return

	var/obj/item/tool/multitool/P = get_multitool(usr)

	if(href_list69"input"69)
		switch(href_list69"input"69)

			if("toggle")

				src.toggled = !src.toggled
				temp = "<font color = #666633>-% 69src69 has been 69src.toggled ? "activated" : "deactivated"69.</font>"
				update_power()

			/*
			if("hide")
				src.hide = !hide
				temp = "<font color = #666633>-% Shadow Link has been 69src.hide ? "activated" : "deactivated"69.</font>"
			*/

			if("id")
				var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this69achine", src, id) as null|text),1,MAX_MESSAGE_LEN)
				if(newid && canAccess(usr))
					id = newid
					temp = "<font color = #666633>-% New ID assigned: \"69id69\" %-</font>"

			if("network")
				var/newnet = input(usr, "Specify the new network for this69achine. This will break all current links.", src, network) as null|text
				if(newnet && canAccess(usr))

					if(length(newnet) > 15)
						temp = "<font color = #666633>-% Too69any characters in new network tag %-</font>"

					else
						for(var/obj/machinery/telecomms/T in links)
							T.links.Remove(src)

						network = newnet
						links = list()
						temp = "<font color = #666633>-% New network tag assigned: \"69network69\" %-</font>"


			if("fre69")
				var/newfre69 = input(usr, "Specify a new fre69uency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
				if(newfre69 && canAccess(usr))
					if(findtext(num2text(newfre69), "."))
						newfre69 *= 10 // shift the decimal one place
					if(!(newfre69 in fre69_listening) && newfre69 < 10000)
						fre69_listening.Add(newfre69)
						temp = "<font color = #666633>-% New fre69uency filter assigned: \"69newfre6969 GHz\" %-</font>"

	if(href_list69"delete"69)

		// changed the layout about to workaround a pesky runtime -- Doohl

		var/x = text2num(href_list69"delete"69)
		temp = "<font color = #666633>-% Removed fre69uency filter 69x69 %-</font>"
		fre69_listening.Remove(x)

	if(href_list69"unlink"69)

		if(text2num(href_list69"unlink"69) <= length(links))
			var/obj/machinery/telecomms/T = links69text2num(href_list69"unlink"69)69
			temp = "<font color = #666633>-% Removed \ref69T69 69T.name69 from linked entities. %-</font>"

			// Remove link entries from both T and src.

			if(src in T.links)
				T.links.Remove(src)
			links.Remove(T)

	if(href_list69"link"69)

		if(P)
			var/obj/machinery/telecomms/device = P.get_buffer()
			if(istype(device) && device != src)
				if(!(src in device.links))
					device.links.Add(src)

				if(!(device in src.links))
					src.links.Add(device)

				temp = "<font color = #666633>-% Successfully linked with \ref69device69 69device.name69 %-</font>"

			else
				temp = "<font color = #666633>-% Unable to ac69uire buffer %-</font>"

	if(href_list69"buffer"69)

		P.set_buffer(src)
		var/atom/buffer = P.get_buffer()
		temp = "<font color = #666633>-% Successfully stored \ref69buffer69 69buffer.name69 in buffer %-</font>"


	if(href_list69"flush"69)

		temp = "<font color = #666633>-% Buffer successfully flushed. %-</font>"
		P.set_buffer(null)

	src.Options_Topic(href, href_list)

	usr.set_machine(src)
	src.add_fingerprint(usr)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)

	updateUsrDialog()

/obj/machinery/telecomms/proc/canAccess(var/mob/user)
	if(issilicon(user) || in_range(user, src))
		return 1
	return 0

#undef TELECOMM_Z
#undef STATION_Z
