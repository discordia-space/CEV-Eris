//DNA69achine
/obj/machinery/dnaforensics
	name = "DNA analyzer"
	desc = "A high tech69achine that is designed to read DNA samples properly."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnaopen"
	anchored = TRUE
	density = TRUE

	var/obj/item/forensics/swab/bloodsamp = null
	var/closed = 0
	var/scanning = 0
	var/scanner_progress = 0
	var/scanner_rate = 2.50
	var/last_process_worldtime = 0
	var/report_num = 0

/obj/machinery/dnaforensics/attackby(var/obj/item/W,69ob/user as69ob)

	if(bloodsamp)
		to_chat(user, SPAN_WARNING("There is already a sample in the69achine."))
		return

	if(closed)
		to_chat(user, SPAN_WARNING("Open the cover before inserting the sample."))
		return

	var/obj/item/forensics/swab/swab = W
	if(istype(swab) && swab.is_used())
		user.unEquip(W)
		src.bloodsamp = swab
		swab.loc = src
		to_chat(user, SPAN_NOTICE("You insert \the 69W69 into \the 69src69."))
	else
		to_chat(user, SPAN_WARNING("\The 69src69 only accepts used swabs."))
		return

/obj/machinery/dnaforensics/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	if(stat & (NOPOWER)) return
	if(user.stat || user.restrained()) return
	var/list/data = list()
	data69"scan_progress"69 = round(scanner_progress)
	data69"scanning"69 = scanning
	data69"bloodsamp"69 = (bloodsamp ? bloodsamp.name : "")
	data69"bloodsamp_desc"69 = (bloodsamp ? (bloodsamp.desc ? bloodsamp.desc : "No information on record.") : "")
	data69"lidstate"69 = closed

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "dnaforensics.tmpl", "QuikScan DNA Analyzer", 540, 326)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/dnaforensics/Topic(href, href_list)

	if(..()) return 1

	if(stat & (NOPOWER))
		return 0 // don't update UIs attached to this object

	if(href_list69"scanItem"69)
		if(scanning)
			scanning = 0
		else
			if(bloodsamp)
				if(closed == 1)
					scanner_progress = 0
					scanning = 1
					to_chat(usr, SPAN_NOTICE("Scan initiated."))
					update_icon()
				else
					to_chat(usr, SPAN_NOTICE("Please close sample lid before initiating scan."))
			else
				to_chat(usr, SPAN_WARNING("Insert an item to scan."))

	if(href_list69"ejectItem"69)
		if(bloodsamp)
			bloodsamp.forceMove(src.loc)
			bloodsamp = null

	if(href_list69"toggleLid"69)
		toggle_lid()

	return 1

/obj/machinery/dnaforensics/Process()
	if(scanning)
		if(!bloodsamp || bloodsamp.loc != src)
			bloodsamp = null
			scanning = 0
		else if(scanner_progress >= 100)
			complete_scan()
			return
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1
			scanner_progress =69in(100, scanner_progress + scanner_rate * deltaT)
	last_process_worldtime = world.time

/obj/machinery/dnaforensics/proc/complete_scan()
	src.visible_message(SPAN_NOTICE("\icon69src6969akes an insistent chime."), 2)
	update_icon()
	if(bloodsamp)
		var/obj/item/paper/P = new(src)
		P.name = "69src69 report #69++report_num69: 69bloodsamp.name69"
		P.stamped = list(/obj/item/stamp)
		P.overlays = list("paper_stamped")
		//dna data itself
		var/data = "No scan information available."
		if(bloodsamp.dna != null)
			data = "Spectometric analysis on provided sample has determined the presence of 69bloodsamp.dna.len69 strings of DNA.<br><br>"
			for(var/blood in bloodsamp.dna)
				data += "\blue Blood type: 69bloodsamp.dna69blood6969<br>\nDNA: 69blood69<br><br>"
		else
			data += "No DNA found.<br>"
		P.info = "<b>69src69 analysis report #69report_num69</b><br>"
		P.info += "<b>Scanned item:</b><br>69bloodsamp.name69<br>69bloodsamp.desc69<br><br>" + data
		P.forceMove(src.loc)
		P.update_icon()
		scanning = 0
		update_icon()
	return

/obj/machinery/dnaforensics/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/dnaforensics/verb/toggle_lid()
	set category = "Object"
	set name = "Toggle Lid"
	set src in oview(1)

	if(usr.stat || !isliving(usr))
		return

	if(scanning)
		to_chat(usr, SPAN_WARNING("You can't do that while 69src69 is scanning!"))
		return

	closed = !closed
	src.update_icon()

/obj/machinery/dnaforensics/update_icon()
	..()
	if(!(stat & NOPOWER) && scanning)
		icon_state = "dnaworking"
	else if(closed)
		icon_state = "dnaclosed"
	else
		icon_state = "dnaopen"
