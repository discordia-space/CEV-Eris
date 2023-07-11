// Pretty much everything here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/living/carbon/occupant
	var/obj/machinery/body_scanconsole/connected
	var/locked
	name = "Body Scanner"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_off"
	density = TRUE
	anchored = TRUE

	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000	//10 kW. It's a big all-body scanner.

/obj/machinery/bodyscanner/relaymove(mob/user as mob)
	if (user.stat)
		return
	src.go_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject Body Scanner"

	if (usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set category = "Object"
	set name = "Enter Body Scanner"

	if(usr.stat)
		return
	if(src.occupant)
		to_chat(usr, SPAN_WARNING("The scanner is already occupied!"))
		return
	if(usr.abiotic())
		to_chat(usr, SPAN_WARNING("The subject cannot have abiotic items on."))
		return
	set_occupant(usr)
	src.add_fingerprint(usr)
	return

/obj/machinery/bodyscanner/proc/go_out()
	if (!occupant || locked)
		return
	for(var/obj/O in src)
		O.forceMove(loc)
	src.occupant.forceMove(loc)
	src.occupant.reset_view()
	src.occupant = null
	update_use_power(1)
	update_icon()

/obj/machinery/bodyscanner/AltClick(mob/user)
	if(Adjacent(user))
		eject()

/obj/machinery/bodyscanner/proc/set_occupant(var/mob/living/L)
	L.forceMove(src)
	src.occupant = L
	update_use_power(2)
	update_icon()
	src.add_fingerprint(usr)


/obj/machinery/bodyscanner/affect_grab(var/mob/user, var/mob/target)
	if (src.occupant)
		to_chat(user, SPAN_NOTICE("The scanner is already occupied!"))
		return
	if(target.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attempting to move them."))
		return
	if(target.abiotic())
		to_chat(user, SPAN_NOTICE("Subject cannot have abiotic items on."))
		return
	set_occupant(target)
	src.add_fingerprint(user)
	return TRUE

/obj/machinery/bodyscanner/MouseDrop_T(var/mob/target, var/mob/user)
	if(!ismob(target))
		return
	if (src.occupant)
		to_chat(user, SPAN_WARNING("The scanner is already occupied!"))
		return
	if (target.abiotic())
		to_chat(user, SPAN_WARNING("Subject cannot have abiotic items on."))
		return
	if (target.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attempting to move them."))
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] begins placing \the [target] into \the [src]."),
		SPAN_NOTICE("You start placing \the [target] into \the [src].")
	)
	if(!do_after(user, 30, src) || !Adjacent(target))
		return
	set_occupant(target)
	src.add_fingerprint(user)
	return

/obj/machinery/bodyscanner/explosion_act(target_power, explosion_handler/handler)
	if(target_power > health)
		for(var/atom/movable/A in src)
			A.forceMove(loc)
			A.explosion_act(target_power)
	. = ..()

/obj/machinery/body_scanconsole/power_change()
	..()
	update_icon()

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/known_implants = list(
		/obj/item/implant/chem,
		/obj/item/implant/death_alarm,
		/obj/item/implant/tracking,
		/obj/item/implant/core_implant/cruciform,
		/obj/item/implant/excelsior
	)
	var/delete
	var/temphtml
	name = "Body Scanner Console"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_terminal_off"
	density = TRUE
	anchored = TRUE


/obj/machinery/body_scanconsole/New()
	..()
	spawn(5)
		for(var/dir in cardinal)
			connected = locate(/obj/machinery/bodyscanner) in get_step(src, dir)
			if(connected)
				return

/obj/machinery/body_scanconsole/attack_hand(user as mob)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		to_chat(user, SPAN_WARNING("This console is not connected to a functioning body scanner."))
		return
	if(!ishuman(connected.occupant))
		to_chat(user, SPAN_WARNING("This device can only scan compatible lifeforms."))
		return

	var/dat
	if (src.delete && src.temphtml) //Window in buffer but its just simple message, so nothing
		src.delete = src.delete
	else if (!src.delete && src.temphtml) //Window in buffer - its a menu, dont add clear message
		dat = text("[]<BR><BR><A href='?src=\ref[];clear=1'>Main Menu</A>", src.temphtml, src)
	else
		if (src.connected) //Is something connected?
			dat = format_occupant_data(src.connected.get_occupant_data())
			dat += "<HR><A href='?src=\ref[src];print=1'>Print</A><BR>"
		else
			dat = SPAN_WARNING("Error: No Body Scanner connected.")

	dat += text("<BR><A href='?src=\ref[];mach_close=scanconsole'>Close</A>", user)
	user << browse(dat, "window=scanconsole;size=430x600")
	return


/obj/machinery/body_scanconsole/Topic(href, href_list)
	if (..())
		return

	if (href_list["print"])
		if (!src.connected)
			to_chat(usr, "\icon[src]<span class='warning'>Error: No body scanner connected.</span>")
			return
		var/mob/living/carbon/human/occupant = src.connected.occupant
		if (!src.connected.occupant)
			to_chat(usr, "\icon[src]<span class='warning'>The body scanner is empty.</span>")
			return
		if (!ishuman(occupant))
			to_chat(usr, "\icon[src]<span class='warning'>The body scanner cannot scan that lifeform.</span>")
			return
		var/obj/item/paper/R = new(src.loc)
		R.name = "[occupant.get_visible_name()] scan report"
		R.info = format_occupant_data(src.connected.get_occupant_data())
		R.update_icon()


/obj/machinery/bodyscanner/proc/get_occupant_data()
	if (!occupant || !ishuman(occupant))
		return
	var/mob/living/carbon/human/H = occupant
	var/list/occupant_data = list(
		"name" = H.get_visible_name(),
		"stationtime" = stationtime2text(),
		"stat" = H.stat,
		"health" = round(H.health / H.maxHealth * 100),
		"bruteloss" = H.getBruteLoss(),
		"fireloss" = H.getFireLoss(),
		"oxyloss" = H.getOxyLoss(),
		"toxloss" = H.chem_effects[CE_TOXIN] + H.chem_effects[CE_ALCOHOL_TOXIC],
		"rads" = H.radiation,
		"brainloss" = H.getBrainLoss(),
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = H.reagents.get_reagent_amount("inaprovaline"),
		"dexalin_amount" = H.reagents.get_reagent_amount("dexalin"),
		"stoxin_amount" = H.reagents.get_reagent_amount("stoxin"),
		"bicaridine_amount" = H.reagents.get_reagent_amount("bicaridine"),
		"dermaline_amount" = H.reagents.get_reagent_amount("dermaline"),
		"blood_amount" = round((H.vessel.get_reagent_amount("blood") / H.species.blood_volume)*100),
		"disabilities" = H.sdisabilities,
		"external_organs" = H.organs.Copy(),
		"internal_organs" = H.internal_organs.Copy(),
		"species_organs" = H.species.has_process, //Just pass a reference for this, it shouldn't ever be modified outside of the datum.
		"NSA" = max(0, H.metabolism_effects.get_nsa()),
		"NSA_threshold" = H.metabolism_effects.nsa_threshold
		)
	return occupant_data


/obj/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<font color='blue'><b>Scan performed at [occ["stationtime"]]</b></font><br>"
	dat += "<font color='blue'><b>Occupant Statistics:</b></font><br>"
	dat += text("ID Name: <i>[]</i><br>", occ["name"])
	var/aux
	switch (occ["stat"])
		if(0)
			aux = "Conscious"
		if(1)
			aux = "Unconscious"
		else
			aux = "Dead"
	dat += text("[]\t-Critical Health %: [] ([])</font><br>", ("<font color='[occ["health"] > 80 ? "blue" : "red"]'>"), occ["health"], aux)
	if (occ["virus_present"])
		dat += "<font color='red'>Viral pathogen detected in blood stream.</font><br>"
	dat += text("[]\t-Brute Damage: []</font><br>", ("<font color='[occ["bruteloss"] < 60  ? "blue" : "red"]'>"), occ["bruteloss"])
	dat += text("[]\t-Burn Severity: []</font><br>", ("<font color='[occ["fireloss"] < 60  ? "blue" : "red"]'>"), occ["fireloss"])
	dat += text("[]\t-Respiratory Damage %: []</font><br><br>", ("<font color='[occ["oxyloss"] < 60  ? "blue" : "red"]'>"), occ["oxyloss"])

	dat += text("[]\tToxicity: []</font><br>", ("<font color='[occ["toxloss"] < 60  ? "blue" : "red"]'>"), occ["toxloss"] ? occ["toxloss"] : "0")
	dat += text("[]\tRadiation Level %: []</font><br>", ("<font color='[occ["rads"] < 10  ? "blue" : "red"]'>"), occ["rads"])
	dat += text("[]\tApprox. Brain Damage %: []</font><br>", ("<font color='[occ["brainloss"] < 1  ? "blue" : "red"]'>"), occ["brainloss"])
	dat += text("[]\tNeural System Accumulation: []/[]</font><br>", ("<font color='[occ["NSA"] < occ["NSA_threshold"]  ? "blue" : "red"]'>"), occ["NSA"], occ["NSA_threshold"])
	dat += text("Paralysis Summary %: [] ([] seconds left!)<br>", occ["paralysis"], round(occ["paralysis"] / 4))
	dat += text("Body Temperature: [occ["bodytemp"]-T0C]&deg;C ([occ["bodytemp"]*1.8-459.67]&deg;F)<br><HR>")

	if(occ["borer_present"])
		dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<br>"

	dat += text("[]\tBlood Level %: [] ([] units)</FONT><BR>", ("<font color='[occ["blood_amount"] > 80  ? "blue" : "red"]'>"), occ["blood_amount"], occ["blood_amount"])

	dat += text("Inaprovaline: [] units<BR>", occ["inaprovaline_amount"])
	dat += text("Soporific: [] units<BR>", occ["stoxin_amount"])
	dat += text("[]\tDermaline: [] units</FONT><BR>", ("<font color='[occ["dermaline_amount"] < 30  ? "black" : "red"]'>"), occ["dermaline_amount"])
	dat += text("[]\tBicaridine: [] units</font><BR>", ("<font color='[occ["bicaridine_amount"] < 30  ? "black" : "red"]'>"), occ["bicaridine_amount"])
	dat += text("[]\tDexalin: [] units</font><BR>", ("<font color='[occ["dexalin_amount"] < 30  ? "black" : "red"]'>"), occ["dexalin_amount"])

	dat += "<HR><table border='1'>"
	dat += "<tr>"
	dat += "<th>Organ</th>"
	dat += "<th>Burn Damage</th>"
	dat += "<th>Brute Damage</th>"
	dat += "<th>Status</th>"
	dat += "</tr>"

	for(var/obj/item/organ/external/e in occ["external_organs"])
		var/list/other_wounds = list()
		var/significant = FALSE

		for(var/obj/item/organ/internal/I in e.internal_organs) // I put this before the actual external organ
			if(I.scanner_hidden) // so that I could set significant based on internal organ results.
				continue

			var/list/internal_wounds = list()
			if(BP_IS_ASSISTED(I))
				internal_wounds += "Assisted"
			if(BP_IS_ROBOTIC(I))
				internal_wounds += "Prosthetic"

			var/total_brute_and_misc_damage = 0
			var/total_burn_damage = 0

			if(I.status & ORGAN_DEAD)
				internal_wounds += "<font color='red'>Dead</font>"
			else
				if(I.rejecting)
					internal_wounds += "being rejected"

				var/list/internal_wound_comps = I.GetComponents(/datum/component/internal_wound)

				for(var/datum/component/internal_wound/IW in internal_wound_comps)
					var/severity = IW.severity
					internal_wounds += "[IW.name] ([severity]/[IW.severity_max])"
					if(istype(IW, /datum/component/internal_wound/organic/burn) || istype(IW, /datum/component/internal_wound/robotic/emp_burn))
						total_burn_damage += severity
					else
						total_brute_and_misc_damage += severity

			// Format internal wounds
			var/internal_wounds_details
			if(LAZYLEN(internal_wounds))
				internal_wounds_details = jointext(internal_wounds, ",<br>")

			if(internal_wounds_details)
				significant = TRUE
				dat += "<tr>"
				dat += "<td>[I.name],<br><i>[e.name]</i></td><td>[total_burn_damage]</td><td>[total_brute_and_misc_damage]</td><td>[internal_wounds_details ? internal_wounds_details : "None"]</td><td></td>"
				dat += "</tr>"

		if(e.status & ORGAN_SPLINTED)
			other_wounds += "Splinted"
		if(e.status & ORGAN_BLEEDING)
			other_wounds += "Bleeding"
		if(BP_IS_ASSISTED(e))
			other_wounds += "Assisted"
		if(BP_IS_ROBOTIC(e))
			other_wounds += "Prosthetic"
		if(e.open)
			other_wounds += "Open"

		if(e.rejecting)
			other_wounds += "being rejected"
		if (e.implants.len)
			var/unknown_body = FALSE
			for(var/I in e.implants)
				if(is_type_in_list(I,known_implants))
					var/obj/item/implant/device = I
					other_wounds += "[device.get_scanner_name()] implanted"
				else if(istype(I, /obj/item/material/shard/shrapnel))
					other_wounds += "Embedded shrapnel"
				else if(istype(I, /obj/item/implant))
					var/obj/item/implant/device = I
					if(!device.scanner_hidden)
						unknown_body = TRUE
				else
					unknown_body = TRUE
			if(unknown_body)
				other_wounds += "Unknown body present"
		if (e.is_stump() || e.burn_dam || e.brute_dam || other_wounds.len)
			significant = TRUE
			dat += "<tr>"
		if(!e.is_stump() && significant)
			dat += "<td>[e.name]</td><td>[e.burn_dam]</td><td>[e.brute_dam]</td><td>[other_wounds.len ? jointext(other_wounds, ":") : "None"]</td>"
		else if (significant)
			dat += "<td>[e.name]</td><td>-</td><td>-</td><td>Not Found</td>"
		else
			continue
		dat += "</tr>"


	dat += "</table>"

	var/list/species_organs = occ["species_organs"]
	for(var/organ_name in species_organs)
		if(!locate(species_organs[organ_name]) in occ["internal_organs"])
			dat += text("<font color='red'>No [organ_name] detected.</font><BR>")

	if(occ["sdisabilities"] & BLIND)
		dat += text("<font color='red'>Cataracts detected.</font><BR>")
	if(occ["sdisabilities"] & NEARSIGHTED)
		dat += text("<font color='red'>Retinal misalignment detected.</font><BR>")
	return dat

/obj/machinery/bodyscanner/update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "scanner_off"
		set_light(0)
	else
		if(connected)
			connected.update_icon()
		if(occupant)
			var/occupant_condition = round((occupant.health / occupant.maxHealth) * 100)
			if(occupant_condition>=100 && !occupant.getBruteLoss() && !occupant.getFireLoss())
				icon_state = "scanner_green"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_LIME)
			else if(occupant_condition>=0)
				icon_state = "scanner_yellow"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_YELLOW)
			else if(occupant_condition>=-90)
				icon_state = "scanner_red"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
			else
				icon_state = "scanner_death"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
		else
			icon_state = "scanner_open"
			set_light(0)

/obj/machinery/body_scanconsole/update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "scanner_terminal_off"
		set_light(0)
	else
		if(connected)
			if(connected.occupant)
				if(connected.occupant.health>=100)
					icon_state = "scanner_terminal_green"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_LIME)
				else if(connected.occupant.health>=-90)
					icon_state = "scanner_terminal_red"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
				else
					icon_state = "scanner_terminal_dead"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
			else
				icon_state = "scanner_terminal_blue"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_BLUE)
		else
			icon_state = "scanner_terminal_off"
			set_light(0)
