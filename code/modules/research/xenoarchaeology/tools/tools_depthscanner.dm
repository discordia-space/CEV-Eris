
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Depth scanner - scans rock turfs / boulders and tells players if there is anything interesting inside, logs all finds + coordinates + times

//also known as the x-ray diffractor
/obj/item/device/depth_scanner
	name = "depth analysis scanner"
	desc = "Used to check spatial depth and density of rock outcroppings."
	icon = 'icons/obj/pda.dmi'
	icon_state = "crap"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	var/list/positive_locations = list()
	var/datum/depth_scan/current

/datum/depth_scan
	var/time = ""
	var/coords = ""
	var/depth = 0
	var/clearance = 0
	var/record_index = 1
	var/dissonance_spread = 1
	var/material = "unknown"

/obj/item/device/depth_scanner/proc/scan_atom(var/mob/user,69ar/atom/A)
	user.visible_message("\blue 69user69 scans 69A69, the air around them humming gently.")
	if(istype(A,/turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		if((M.finds &&69.finds.len) ||69.artifact_find)

			//create a69ew scanlog entry
			var/datum/depth_scan/D =69ew()
			D.coords = "69M.x69.69rand(0,9)69:69M.y69.69rand(0,9)69:6910 *69.z69.69rand(0,9)69"
			D.time = stationtime2text()
			D.record_index = positive_locations.len + 1
			D.material =69.mineral ?69.mineral.display_name : "Rock"

			//find the first artifact and store it
			if(M.finds.len)
				var/datum/find/F =69.finds69169
				D.depth = F.excavation_re69uired * 2		//0-100% and 0-200cm
				D.clearance = F.clearance_range * 2
				D.material = get_responsive_reagent(F.find_type)

			positive_locations.Add(D)

			for(var/mob/L in range(src, 1))
				to_chat(L, "\blue \icon69src69 69src69 pings.")

	else if(istype(A,/obj/structure/boulder))
		var/obj/structure/boulder/B = A
		if(B.artifact_find)
			//create a69ew scanlog entry
			var/datum/depth_scan/D =69ew()
			D.coords = "6910 * B.x69.69rand(0,9)69:6910 * B.y69.69rand(0,9)69:6910 * B.z69.69rand(0,9)69"
			D.time = stationtime2text()
			D.record_index = positive_locations.len + 1

			//these69alues are arbitrary
			D.depth = rand(75,100)
			D.clearance = rand(5,25)
			D.dissonance_spread = rand(750,2500) / 100

			positive_locations.Add(D)

			for(var/mob/L in range(src, 1))
				to_chat(L, "\blue \icon69src69 69src69 pings 69pick("madly","wildly","excitedly","crazily")69!")

/obj/item/device/depth_scanner/attack_self(var/mob/user as69ob)
	return src.interact(user)

/obj/item/device/depth_scanner/interact(var/mob/user as69ob)
	var/dat = "<b>Co-ordinates with positive69atches</b><br>"
	dat += "<A href='?src=\ref69src69;clear=0'>== Clear all ==</a><br>"
	if(current)
		dat += "Time: 69current.time69<br>"
		dat += "Coords: 69current.coords69<br>"
		dat += "Anomaly depth: 69current.depth69 cm<br>"
		dat += "Clearance above anomaly depth: 69current.clearance69 cm<br>"
		dat += "Dissonance spread: 69current.dissonance_spread69<br>"
		var/index = responsive_carriers.Find(current.material)
		if(index > 0 && index <= finds_as_strings.len)
			dat += "Anomaly69aterial: 69finds_as_strings69index6969<br>"
		else
			dat += "Anomaly69aterial: Unknown<br>"
		dat += "<A href='?src=\ref69src69;clear=69current.record_index69'>clear entry</a><br>"
	else
		dat += "Select an entry from the list<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
	dat += "<hr>"
	if(positive_locations.len)
		for(var/index=1, index<=positive_locations.len, index++)
			var/datum/depth_scan/D = positive_locations69index69
			dat += "<A href='?src=\ref69src69;select=69index69'>69D.time69, coords: 69D.coords69</a><br>"
	else
		dat += "No entries recorded."
	dat += "<hr>"
	dat += "<A href='?src=\ref69src69;refresh=1'>Refresh</a><br>"
	dat += "<A href='?src=\ref69src69;close=1'>Close</a><br>"
	user << browse(dat,"window=depth_scanner;size=300x500")
	onclose(user, "depth_scanner")

/obj/item/device/depth_scanner/Topic(href, href_list)
	..()
	usr.set_machine(src)

	if(href_list69"select"69)
		var/index = text2num(href_list69"select"69)
		if(index && index <= positive_locations.len)
			current = positive_locations69index69
	else if(href_list69"clear"69)
		var/index = text2num(href_list69"clear"69)
		if(index)
			if(index <= positive_locations.len)
				var/datum/depth_scan/D = positive_locations69index69
				positive_locations.Remove(D)
				69del(D)
		else
			//GC will hopefully pick them up before too long
			positive_locations = list()
			69del(current)
	else if(href_list69"close"69)
		usr.unset_machine()
		usr << browse(null, "window=depth_scanner")

	updateSelfDialog()
