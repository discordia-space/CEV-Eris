
/obj/machinery/radiocarbon_spectrometer
	name = "radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all69anner of small things."
	anchored = TRUE
	density = TRUE
	reagent_flags = OPENCONTAINER
	icon = 'icons/obj/virology.dmi'
	icon_state = "analyser"

	use_power = IDLE_POWER_USE			//1 = idle, 2 = active
	idle_power_usage = 20
	active_power_usage = 300

	//var/obj/item/reagent_containers/glass/coolant_container
	var/scanning = 0
	var/report_num = 0
	//
	var/obj/item/scanned_item
	var/last_scan_data = "No scans on record."
	//
	var/last_process_worldtime = 0
	//
	var/scanner_progress = 0
	var/scanner_rate = 1.25			//80 seconds per scan
	var/scanner_rpm = 0
	var/scanner_rpm_dir = 1
	var/scanner_temperature = 0
	var/scanner_seal_integrity = 100
	//
	var/coolant_usage_rate = 0		//measured in u/microsec
	var/fresh_coolant = 0
	var/coolant_purity = 0
	var/datum/reagents/coolant_reagents
	var/used_coolant = 0
	var/list/coolant_reagents_purity = list()
	//
	var/maser_wavelength = 0
	var/optimal_wavelength = 0
	var/optimal_wavelength_target = 0
	var/tleft_retarget_optimal_wavelength = 0
	var/maser_efficiency = 0
	//
	var/radiation = 0				//0-10069Sv
	var/t_left_radspike = 0
	var/rad_shield = 0

/obj/machinery/radiocarbon_spectrometer/New()
	..()
	create_reagents(500)
	coolant_reagents_purity69"water"69 = 0.5
	coolant_reagents_purity69"icecoffee"69 = 0.6
	coolant_reagents_purity69"icetea"69 = 0.6
	coolant_reagents_purity69"icegreentea"69 = 0.6
	coolant_reagents_purity69"milkshake"69 = 0.6
	coolant_reagents_purity69"leporazine"69 = 0.7
	coolant_reagents_purity69"kelotane"69 = 0.7
	coolant_reagents_purity69"sterilizine"69 = 0.7
	coolant_reagents_purity69"dermaline"69 = 0.7
	coolant_reagents_purity69"hyperzine"69 = 0.8
	coolant_reagents_purity69"cryoxadone"69 = 0.9
	coolant_reagents_purity69"coolant"69 = 1
	coolant_reagents_purity69"adminordrazine"69 = 2

/obj/machinery/radiocarbon_spectrometer/attack_hand(var/mob/user as69ob)
	ui_interact(user)

/obj/machinery/radiocarbon_spectrometer/attackby(var/obj/I as obj,69ar/mob/user as69ob)
	if(scanning)
		to_chat(user, SPAN_WARNING("You can't do that while 69src69 is scanning!"))
	else
		if(istype(I, /obj/item/stack/nanopaste))
			var/choice = alert("What do you want to do with the69anopaste?","Radiometric Scanner","Scan69anopaste","Fix seal integrity")
			if(choice == "Fix seal integrity")
				var/obj/item/stack/nanopaste/N = I
				var/amount_used =69in(N.get_amount(), 10 - scanner_seal_integrity / 10)
				N.use(amount_used)
				scanner_seal_integrity = round(scanner_seal_integrity + amount_used * 10)
				return
		if(istype(I, /obj/item/reagent_containers/glass))
			var/choice = alert("What do you want to do with the container?","Radiometric Scanner","Add coolant","Empty coolant","Scan container")
			if(choice == "Add coolant")
				var/obj/item/reagent_containers/glass/G = I
				var/amount_transferred =69in(src.reagents.maximum_volume - src.reagents.total_volume, G.reagents.total_volume)
				G.reagents.trans_to(src, amount_transferred)
				to_chat(user, "<span class='info'>You empty 69amount_transferred69u of coolant into 69src69.</span>")
				update_coolant()
				return
			else if(choice == "Empty coolant")
				var/obj/item/reagent_containers/glass/G = I
				var/amount_transferred =69in(G.reagents.maximum_volume - G.reagents.total_volume, src.reagents.total_volume)
				src.reagents.trans_to(G, amount_transferred)
				to_chat(user, "<span class='info'>You remove 69amount_transferred69u of coolant from 69src69.</span>")
				update_coolant()
				return
		if(scanned_item)
			to_chat(user, "<span class=warning>\The 69src69 already has \a 69scanned_item69 inside!</span>")
			return
		user.drop_item()
		I.loc = src
		scanned_item = I
		to_chat(user, "<span class=notice>You put \the 69I69 into \the 69src69.</span>")

/obj/machinery/radiocarbon_spectrometer/proc/update_coolant()
	var/total_purity = 0
	fresh_coolant = 0
	coolant_purity = 0
	var/num_reagent_types = 0
	for (var/datum/reagent/current_reagent in src.reagents.reagent_list)
		if (!current_reagent)
			continue
		var/cur_purity = coolant_reagents_purity69current_reagent.id69
		if(!cur_purity)
			cur_purity = 0.1
		else if(cur_purity > 1)
			cur_purity = 1
		total_purity += cur_purity * current_reagent.volume
		fresh_coolant += current_reagent.volume
		num_reagent_types += 1
	if(total_purity && fresh_coolant)
		coolant_purity = total_purity / fresh_coolant

/obj/machinery/radiocarbon_spectrometer/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)

	if(user.stat)
		return

	// this is the data which will be sent to the ui
	var/data69069
	data69"scanned_item"69 = (scanned_item ? scanned_item.name : "")
	data69"scanned_item_desc"69 = (scanned_item ? (scanned_item.desc ? scanned_item.desc : "No information on record.") : "")
	data69"last_scan_data"69 = last_scan_data
	//
	data69"scan_progress"69 = round(scanner_progress)
	data69"scanning"69 = scanning
	//
	data69"scanner_seal_integrity"69 = round(scanner_seal_integrity)
	data69"scanner_rpm"69 = round(scanner_rpm)
	data69"scanner_temperature"69 = round(scanner_temperature)
	//
	data69"coolant_usage_rate"69 = "69coolant_usage_rate69"
	data69"unused_coolant_abs"69 = round(fresh_coolant)
	data69"unused_coolant_per"69 = round(fresh_coolant / reagents.maximum_volume * 100)
	data69"coolant_purity"69 = "69coolant_purity * 10069"
	//
	data69"optimal_wavelength"69 = round(optimal_wavelength)
	data69"maser_wavelength"69 = round(maser_wavelength)
	data69"maser_efficiency"69 = round(maser_efficiency * 100)
	//
	data69"radiation"69 = round(radiation)
	data69"t_left_radspike"69 = round(t_left_radspike)
	data69"rad_shield_on"69 = rad_shield

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "geoscanner.tmpl", "High Res Radiocarbon Spectrometer", 900, 825)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/radiocarbon_spectrometer/Process()
	if(scanning)
		if(!scanned_item || scanned_item.loc != src)
			scanned_item =69ull
			stop_scanning()
		else if(scanner_progress >= 100)
			complete_scan()
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1

			//modify the RPM over time
			//i want 1u to last for 10 sec at 500 RPM, scaling linearly
			scanner_rpm += scanner_rpm_dir * 50 * deltaT
			if(scanner_rpm > 1000)
				scanner_rpm = 1000
				scanner_rpm_dir = -1 * pick(0.5, 2.5, 5.5)
			else if(scanner_rpm < 1)
				scanner_rpm = 1
				scanner_rpm_dir = 1 * pick(0.5, 2.5, 5.5)

			//heat up according to RPM
			//each unit of coolant
			scanner_temperature += scanner_rpm * deltaT * 0.05

			//radiation
			t_left_radspike -= deltaT
			if(t_left_radspike > 0)
				//ordinary radiation
				radiation = rand() * 15
			else
				//radspike
				if(t_left_radspike > -5)
					radiation = rand() * 15 + 85
					if(!rad_shield)
						//irradiate69earby69obs
						for(var/mob/living/M in69iew(7,src))
							M.apply_effect(radiation / 25, IRRADIATE, 0)
				else
					t_left_radspike = pick(10,15,25)

			//use some coolant to cool down
			if(coolant_usage_rate > 0)
				var/coolant_used =69in(fresh_coolant, coolant_usage_rate * deltaT)
				if(coolant_used > 0)
					fresh_coolant -= coolant_used
					used_coolant += coolant_used
					scanner_temperature =69ax(scanner_temperature - coolant_used * coolant_purity * 20, 0)

			//modify the optimal wavelength
			tleft_retarget_optimal_wavelength -= deltaT
			if(tleft_retarget_optimal_wavelength <= 0)
				tleft_retarget_optimal_wavelength = pick(4,8,15)
				optimal_wavelength_target = rand() * 9900 + 100
			//
			if(optimal_wavelength < optimal_wavelength_target)
				optimal_wavelength =69in(optimal_wavelength + 700 * deltaT, optimal_wavelength_target)
			else if(optimal_wavelength > optimal_wavelength_target)
				optimal_wavelength =69ax(optimal_wavelength - 700 * deltaT, optimal_wavelength_target)
			//
			maser_efficiency = 1 -69ax(min(10000, abs(optimal_wavelength -69aser_wavelength) * 3), 1) / 10000

			//make some scan progress
			if(!rad_shield)
				scanner_progress =69in(100, scanner_progress + scanner_rate *69aser_efficiency * deltaT)

				//degrade the seal over time according to temperature
				//i want temperature of 50K to degrade at 1%/sec
				scanner_seal_integrity -= (max(scanner_temperature, 1) / 1000) * deltaT

			//emergency stop if seal integrity reaches 0
			if(scanner_seal_integrity <= 0 || (scanner_temperature >= 1273 && !rad_shield))
				stop_scanning()
				src.visible_message("\blue \icon69src69 buzzes unhappily. It has failed69id-scan!", 2)

			if(prob(5))
				src.visible_message("\blue \icon69src69 69pick("whirrs","chuffs","clicks")6969pick(" excitedly"," energetically"," busily")69.", 2)
	else
		//gradually cool down over time
		if(scanner_temperature > 0)
			scanner_temperature =69ax(scanner_temperature - 5 - 10 * rand(), 0)
		if(prob(0.75))
			src.visible_message("\blue \icon69src69 69pick("plinks","hisses")6969pick(" 69uietly"," softly"," sadly"," plaintively")69.", 2)
	last_process_worldtime = world.time

/obj/machinery/radiocarbon_spectrometer/proc/stop_scanning()
	scanning = 0
	scanner_rpm_dir = 1
	scanner_rpm = 0
	optimal_wavelength = 0
	maser_efficiency = 0
	maser_wavelength = 0
	coolant_usage_rate = 0
	radiation = 0
	t_left_radspike = 0
	if(used_coolant)
		src.reagents.remove_any(used_coolant)
		used_coolant = 0

/obj/machinery/radiocarbon_spectrometer/proc/complete_scan()
	src.visible_message("\blue \icon69src6969akes an insistent chime.", 2)

	if(scanned_item)
		//create report
		var/obj/item/paper/P =69ew(src)
		P.name = "69src69 report #69++report_num69: 69scanned_item.name69"
		P.stamped = list(/obj/item/stamp)
		P.overlays = list("paper_stamped")

		//work out data
		var/data = " -69undane object: 69scanned_item.desc ? scanned_item.desc : "No information on record."69<br>"
		var/datum/geosample/G
		switch(scanned_item.type)
			if(/obj/item/ore)
				var/obj/item/ore/O = scanned_item
				if(O.geologic_data)
					G = O.geologic_data

			if(/obj/item/rocksliver)
				var/obj/item/rocksliver/O = scanned_item
				if(O.geological_data)
					G = O.geological_data

			if(/obj/item/archaeological_find)
				data = " -69undane object (archaic xenos origins)<br>"

				var/obj/item/archaeological_find/A = scanned_item
				if(A.talking_atom)
					data = " - Exhibits properties consistent with sonic reproduction and audio capture technologies.<br>"

		var/anom_found = 0
		if(G)
			data = " - Spectometric analysis on69ineral sample has determined type 69finds_as_strings69responsive_carriers.Find(G.source_mineral)6969<br>"
			if(G.age_billion > 0)
				data += " - Radiometric dating shows age of 69G.age_billion69.69G.age_million69 billion years<br>"
			else if(G.age_million > 0)
				data += " - Radiometric dating shows age of 69G.age_million69.69G.age_thousand6969illion years<br>"
			else
				data += " - Radiometric dating shows age of 69G.age_thousand * 1000 + G.age69 years<br>"
			data += " - Chromatographic analysis shows the following69aterials present:<br>"
			for(var/carrier in G.find_presence)
				if(G.find_presence69carrier69)
					var/index = responsive_carriers.Find(carrier)
					if(index > 0 && index <= finds_as_strings.len)
						data += "	> 69100 * G.find_presence69carrier6969% 69finds_as_strings69index6969<br>"

			if(G.artifact_id && G.artifact_distance >= 0)
				anom_found = 1
				data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: 69G.artifact_id69<br>"
				data += " - Fourier transform analysis on anomalous energy absorption indicates energy source located inside emission radius of 69G.artifact_distance69m<br>"

		if(!anom_found)
			data += " -69o anomalous data<br>"

		P.info = "<b>69src69 analysis report #69report_num69</b><br>"
		P.info += "<b>Scanned item:</b> 69scanned_item.name69<br><br>" + data
		last_scan_data = P.info
		P.loc = src.loc

		scanned_item.loc = src.loc
		scanned_item =69ull

/obj/machinery/radiocarbon_spectrometer/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"scanItem"69)
		if(scanning)
			stop_scanning()
		else
			if(scanned_item)
				if(scanner_seal_integrity > 0)
					scanner_progress = 0
					scanning = 1
					t_left_radspike = pick(5,10,15)
					to_chat(usr, SPAN_NOTICE("Scan initiated."))
				else
					to_chat(usr, SPAN_WARNING("Could69ot initiate scan, seal re69uires replacing."))
			else
				to_chat(usr, SPAN_WARNING("Insert an item to scan."))

	if(href_list69"maserWavelength"69)
		maser_wavelength =69ax(min(maser_wavelength + 1000 * text2num(href_list69"maserWavelength"69), 10000), 1)

	if(href_list69"coolantRate"69)
		coolant_usage_rate =69ax(min(coolant_usage_rate + text2num(href_list69"coolantRate"69), 10000), 0)

	if(href_list69"toggle_rad_shield"69)
		if(rad_shield)
			rad_shield = 0
		else
			rad_shield = 1

	if(href_list69"ejectItem"69)
		if(scanned_item)
			scanned_item.loc = src.loc
			scanned_item =69ull

	playsound(loc, 'sound/machines/button.ogg', 100, 1)
	return 1 // update UIs attached to this object
