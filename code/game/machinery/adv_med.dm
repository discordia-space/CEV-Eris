// Pretty69uch everythin69 here is stolen from the dna scanner FYI


/obj/machinery/bodyscanner
	var/mob/livin69/carbon/occupant
	var/obj/machinery/body_scanconsole/connected
	var/locked
	name = "Body Scanner"
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "scanner_off"
	density = TRUE
	anchored = TRUE

	use_power = IDLE_POWER_USE
	idle_power_usa69e = 60
	active_power_usa69e = 10000	//10 kW. It's a bi69 all-body scanner.

/obj/machinery/bodyscanner/relaymove(mob/user as69ob)
	if (user.stat)
		return
	src.69o_out()
	return

/obj/machinery/bodyscanner/verb/eject()
	set src in oview(1)
	set cate69ory = "Object"
	set name = "Eject Body Scanner"

	if (usr.stat != 0)
		return
	src.69o_out()
	add_fin69erprint(usr)
	return

/obj/machinery/bodyscanner/verb/move_inside()
	set src in oview(1)
	set cate69ory = "Object"
	set name = "Enter Body Scanner"

	if(usr.stat)
		return
	if(src.occupant)
		to_chat(usr, SPAN_WARNIN69("The scanner is already occupied!"))
		return
	if(usr.abiotic())
		to_chat(usr, SPAN_WARNIN69("The subject cannot have abiotic items on."))
		return
	set_occupant(usr)
	src.add_fin69erprint(usr)
	return

/obj/machinery/bodyscanner/proc/69o_out()
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

/obj/machinery/bodyscanner/proc/set_occupant(var/mob/livin69/L)
	L.forceMove(src)
	src.occupant = L
	update_use_power(2)
	update_icon()
	src.add_fin69erprint(usr)


/obj/machinery/bodyscanner/affect_69rab(var/mob/user,69ar/mob/tar69et)
	if (src.occupant)
		to_chat(user, SPAN_NOTICE("The scanner is already occupied!"))
		return
	if(tar69et.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attemptin69 to69ove them."))
		return
	if(tar69et.abiotic())
		to_chat(user, SPAN_NOTICE("Subject cannot have abiotic items on."))
		return
	set_occupant(tar69et)
	src.add_fin69erprint(user)
	return TRUE

/obj/machinery/bodyscanner/MouseDrop_T(var/mob/tar69et,69ar/mob/user)
	if(!ismob(tar69et))
		return
	if (src.occupant)
		to_chat(user, SPAN_WARNIN69("The scanner is already occupied!"))
		return
	if (tar69et.abiotic())
		to_chat(user, SPAN_WARNIN69("Subject cannot have abiotic items on."))
		return
	if (tar69et.buckled)
		to_chat(user, SPAN_NOTICE("Unbuckle the subject before attemptin69 to69ove them."))
		return
	user.visible_messa69e(
		SPAN_NOTICE("\The 69user69 be69ins placin69 \the 69tar69et69 into \the 69src69."),
		SPAN_NOTICE("You start placin69 \the 69tar69et69 into \the 69src69.")
	)
	if(!do_after(user, 30, src) || !Adjacent(tar69et))
		return
	set_occupant(tar69et)
	src.add_fin69erprint(user)
	return

/obj/machinery/bodyscanner/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A in src)
				A.forceMove(loc)
				A.ex_act(severity)
			69del(src)
		if(2)
			if (prob(50))
				for(var/atom/movable/A in src)
					A.forceMove(loc)
					A.ex_act(severity)
				69del(src)
		if(3)
			if (prob(25))
				for(var/atom/movable/A in src)
					A.forceMove(loc)
					A.ex_act(severity)
				69del(src)

/obj/machinery/body_scanconsole/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			if (prob(50))
				69del(src)
				return

/obj/machinery/body_scanconsole/power_chan69e()
	..()
	update_icon()

/obj/machinery/body_scanconsole
	var/obj/machinery/bodyscanner/connected
	var/known_implants = list(
		/obj/item/implant/chem,
		/obj/item/implant/death_alarm,
		/obj/item/implant/trackin69,
		/obj/item/implant/core_implant/cruciform,
		/obj/item/implant/excelsior
	)
	var/delete
	var/temphtml
	name = "Body Scanner Console"
	icon = 'icons/obj/Cryo69enic2.dmi'
	icon_state = "scanner_terminal_off"
	density = TRUE
	anchored = TRUE


/obj/machinery/body_scanconsole/New()
	..()
	spawn(5)
		for(var/dir in cardinal)
			connected = locate(/obj/machinery/bodyscanner) in 69et_step(src, dir)
			if(connected)
				return

/obj/machinery/body_scanconsole/attack_hand(user as69ob)
	if(..())
		return
	if(stat & (NOPOWER|BROKEN))
		return
	if(!connected || (connected.stat & (NOPOWER|BROKEN)))
		to_chat(user, SPAN_WARNIN69("This console is not connected to a functionin69 body scanner."))
		return
	if(!ishuman(connected.occupant))
		to_chat(user, SPAN_WARNIN69("This device can only scan compatible lifeforms."))
		return

	var/dat
	if (src.delete && src.temphtml) //Window in buffer but its just simple69essa69e, so nothin69
		src.delete = src.delete
	else if (!src.delete && src.temphtml) //Window in buffer - its a69enu, dont add clear69essa69e
		dat = text("6969<BR><BR><A href='?src=\ref6969;clear=1'>Main69enu</A>", src.temphtml, src)
	else
		if (src.connected) //Is somethin69 connected?
			dat = format_occupant_data(src.connected.69et_occupant_data())
			dat += "<HR><A href='?src=\ref69src69;print=1'>Print</A><BR>"
		else
			dat = SPAN_WARNIN69("Error: No Body Scanner connected.")

	dat += text("<BR><A href='?src=\ref6969;mach_close=scanconsole'>Close</A>", user)
	user << browse(dat, "window=scanconsole;size=430x600")
	return


/obj/machinery/body_scanconsole/Topic(href, href_list)
	if (..())
		return

	if (href_list69"print"69)
		if (!src.connected)
			to_chat(usr, "\icon69src69<span class='warnin69'>Error: No body scanner connected.</span>")
			return
		var/mob/livin69/carbon/human/occupant = src.connected.occupant
		if (!src.connected.occupant)
			to_chat(usr, "\icon69src69<span class='warnin69'>The body scanner is empty.</span>")
			return
		if (!ishuman(occupant))
			to_chat(usr, "\icon69src69<span class='warnin69'>The body scanner cannot scan that lifeform.</span>")
			return
		var/obj/item/paper/R = new(src.loc)
		R.name = "69occupant.69et_visible_name()69 scan report"
		R.info = format_occupant_data(src.connected.69et_occupant_data())
		R.update_icon()


/obj/machinery/bodyscanner/proc/69et_occupant_data()
	if (!occupant || !ishuman(occupant))
		return
	var/mob/livin69/carbon/human/H = occupant
	var/list/occupant_data = list(
		"name" = H.69et_visible_name(),
		"stationtime" = stationtime2text(),
		"stat" = H.stat,
		"health" = round(H.health/H.maxHealth)*100,
		"virus_present" = H.virus2.len,
		"bruteloss" = H.69etBruteLoss(),
		"fireloss" = H.69etFireLoss(),
		"oxyloss" = H.69etOxyLoss(),
		"toxloss" = H.69etToxLoss(),
		"rads" = H.radiation,
		"cloneloss" = H.69etCloneLoss(),
		"brainloss" = H.69etBrainLoss(),
		"paralysis" = H.paralysis,
		"bodytemp" = H.bodytemperature,
		"borer_present" = H.has_brain_worms(),
		"inaprovaline_amount" = H.rea69ents.69et_rea69ent_amount("inaprovaline"),
		"dexalin_amount" = H.rea69ents.69et_rea69ent_amount("dexalin"),
		"stoxin_amount" = H.rea69ents.69et_rea69ent_amount("stoxin"),
		"bicaridine_amount" = H.rea69ents.69et_rea69ent_amount("bicaridine"),
		"dermaline_amount" = H.rea69ents.69et_rea69ent_amount("dermaline"),
		"blood_amount" = round((H.vessel.69et_rea69ent_amount("blood") / H.species.blood_volume)*100),
		"disabilities" = H.sdisabilities,
		"lun69_ruptured" = H.is_lun69_ruptured(),
		"external_or69ans" = H.or69ans.Copy(),
		"internal_or69ans" = H.internal_or69ans.Copy(),
		"species_or69ans" = H.species.has_process, //Just pass a reference for this, it shouldn't ever be69odified outside of the datum.
		"NSA" =69ax(0, H.metabolism_effects.69et_nsa()),
		"NSA_threshold" = H.metabolism_effects.nsa_threshold
		)
	return occupant_data


/obj/machinery/body_scanconsole/proc/format_occupant_data(var/list/occ)
	var/dat = "<font color='blue'><b>Scan performed at 69occ69"stationtime"6969</b></font><br>"
	dat += "<font color='blue'><b>Occupant Statistics:</b></font><br>"
	dat += text("ID Name: <i>6969</i><br>", occ69"name"69)
	var/aux
	switch (occ69"stat"69)
		if(0)
			aux = "Conscious"
		if(1)
			aux = "Unconscious"
		else
			aux = "Dead"
	dat += text("6969\tHealth %: 6969 (6969)</font><br>", ("<font color='69occ69"health"69 > 50 ? "blue" : "red"69>"), occ69"health"69, aux)
	if (occ69"virus_present"69)
		dat += "<font color='red'>Viral patho69en detected in blood stream.</font><br>"
	dat += text("6969\t-Brute Dama69e %: 6969</font><br>", ("<font color='69occ69"bruteloss"69 < 60  ? "blue" : "red"69'>"), occ69"bruteloss"69)
	dat += text("6969\t-Respiratory Dama69e %: 6969</font><br>", ("<font color='69occ69"oxyloss"69 < 60  ? "blue" : "red"69'>"), occ69"oxyloss"69)
	dat += text("6969\t-Toxin Content %: 6969</font><br>", ("<font color='69occ69"toxloss"69 < 60  ? "blue" : "red"69'>"), occ69"toxloss"69)
	dat += text("6969\t-Burn Severity %: 6969</font><br><br>", ("<font color='69occ69"fireloss"69 < 60  ? "blue" : "red"69'>"), occ69"fireloss"69)

	dat += text("6969\tRadiation Level %: 6969</font><br>", ("<font color='69occ69"rads"69 < 10  ? "blue" : "red"69'>"), occ69"rads"69)
	dat += text("6969\t69enetic Tissue Dama69e %: 6969</font><br>", ("<font color='69occ69"cloneloss"69 < 1  ? "blue" : "red"69'>"), occ69"cloneloss"69)
	dat += text("6969\tApprox. Brain Dama69e %: 6969</font><br>", ("<font color='69occ69"brainloss"69 < 1  ? "blue" : "red"69'>"), occ69"brainloss"69)
	dat += text("6969\tNeural System Accumulation: 6969/6969</font><br>", ("<font color='69occ69"NSA"69 < occ69"NSA_threshold"69  ? "blue" : "red"69'>"), occ69"NSA"69, occ69"NSA_threshold"69)
	dat += text("Paralysis Summary %: 6969 (6969 seconds left!)<br>", occ69"paralysis"69, round(occ69"paralysis"69 / 4))
	dat += text("Body Temperature: 69occ69"bodytemp"69-T0C69&de69;C (69occ69"bodytemp"69*1.8-459.6769&de69;F)<br><HR>")

	if(occ69"borer_present"69)
		dat += "Lar69e 69rowth detected in frontal lobe, possibly cancerous. Sur69ical removal is recommended.<br>"

	dat += text("6969\tBlood Level %: 6969 (6969 units)</FONT><BR>", ("<font color='69occ69"blood_amount"69 > 80  ? "blue" : "red"69'>"), occ69"blood_amount"69, occ69"blood_amount"69)

	dat += text("Inaprovaline: 6969 units<BR>", occ69"inaprovaline_amount"69)
	dat += text("Soporific: 6969 units<BR>", occ69"stoxin_amount"69)
	dat += text("6969\tDermaline: 6969 units</FONT><BR>", ("<font color='69occ69"dermaline_amount"69 < 30  ? "black" : "red"69'>"), occ69"dermaline_amount"69)
	dat += text("6969\tBicaridine: 6969 units</font><BR>", ("<font color='69occ69"bicaridine_amount"69 < 30  ? "black" : "red"69'>"), occ69"bicaridine_amount"69)
	dat += text("6969\tDexalin: 6969 units</font><BR>", ("<font color='69occ69"dexalin_amount"69 < 30  ? "black" : "red"69'>"), occ69"dexalin_amount"69)

	dat += "<HR><table border='1'>"
	dat += "<tr>"
	dat += "<th>Or69an</th>"
	dat += "<th>Burn Dama69e</th>"
	dat += "<th>Brute Dama69e</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/obj/item/or69an/external/e in occ69"external_or69ans"69)
		var/list/other_wounds = list()
		var/si69nificant = FALSE

		for(var/obj/item/or69an/internal/I in e.internal_or69ans) // I put this before the actual external or69an
			if(I.scanner_hidden) // so that I could set si69nificant based on internal or69an results.
				continue
	
			var/list/internal_wounds = list()
			if(BP_IS_ASSISTED(I))
				internal_wounds += "Assisted"
			if(BP_IS_ROBOTIC(I))
				internal_wounds += "Prosthetic"
	
			var/obj/item/or69an/internal/bone/B = I
			if(istype(B))
				if(B.parent.status & OR69AN_BROKEN)
					internal_wounds += "69B.broken_description69"
	
			switch (I.69erm_level)
				if (0 to INFECTION_LEVEL_ONE - 1) //in the case of no infection, do nothin69.
				if (1 to INFECTION_LEVEL_ONE + 200)
					internal_wounds += "Mild Infection"
				if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
					internal_wounds += "Mild Infection+"
				if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
					internal_wounds += "Mild Infection++"
				if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
					internal_wounds += "Acute Infection"
				if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
					internal_wounds += "Acute Infection+"
				if (INFECTION_LEVEL_TWO + 300 to INFINITY)
					internal_wounds += "Acute Infection++"
			if(I.rejectin69)
				internal_wounds += "bein69 rejected"
			if (I.dama69e || internal_wounds.len)
				si69nificant = TRUE
				dat += "<tr>"
				dat += "<td>69I.name69</td><td>N/A</td><td>69I.dama69e69</td><td>69other_wounds.len ? jointext(other_wounds, ":") : "None"69</td><td></td>"
				dat += "</tr>"

		for(var/datum/wound/W in e.wounds) if(W.internal)
			other_wounds += "Internal bleedin69"
			break
		if(e.or69an_ta69 == BP_CHEST && occ69"lun69_ruptured"69)
			other_wounds += "Lun69 ruptured"
		if(e.status & OR69AN_SPLINTED)
			other_wounds += "Splinted"
		if(e.status & OR69AN_BLEEDIN69)
			other_wounds += "Bleedin69"
		if(BP_IS_ASSISTED(e))
			other_wounds += "Assisted"
		if(BP_IS_ROBOTIC(e))
			other_wounds += "Prosthetic"
		if(e.open)
			other_wounds += "Open"

		switch (e.69erm_level)
			if (0 to INFECTION_LEVEL_ONE - 1) //in the case of no infection, do nothin69.
			if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + 200)
				other_wounds += "Mild Infection"
			if (INFECTION_LEVEL_ONE + 200 to INFECTION_LEVEL_ONE + 300)
				other_wounds += "Mild Infection+"
			if (INFECTION_LEVEL_ONE + 300 to INFECTION_LEVEL_ONE + 400)
				other_wounds += "Mild Infection++"
			if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + 200)
				other_wounds += "Acute Infection"
			if (INFECTION_LEVEL_TWO + 200 to INFECTION_LEVEL_TWO + 300)
				other_wounds += "Acute Infection+"
			if (INFECTION_LEVEL_TWO + 300 to INFECTION_LEVEL_TWO + 400)
				other_wounds += "Acute Infection++"
			if (INFECTION_LEVEL_THREE to INFINITY)
				other_wounds += "Septic"
		if(e.rejectin69)
			other_wounds += "bein69 rejected"
		if (e.implants.len)
			var/unknown_body = FALSE
			for(var/I in e.implants)
				if(is_type_in_list(I,known_implants))
					var/obj/item/implant/device = I
					other_wounds += "69device.69et_scanner_name()69 implanted"
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
			si69nificant = TRUE
			dat += "<tr>"
		if(!e.is_stump() && si69nificant)
			dat += "<td>69e.name69</td><td>69e.burn_dam69</td><td>69e.brute_dam69</td><td>69other_wounds.len ? jointext(other_wounds, ":") : "None"69</td>"
		else if (si69nificant)
			dat += "<td>69e.name69</td><td>-</td><td>-</td><td>Not Found</td>"
		else
			continue
		dat += "</tr>"


	dat += "</table>"

	var/list/species_or69ans = occ69"species_or69ans"69
	for(var/or69an_name in species_or69ans)
		if(!locate(species_or69ans69or69an_name69) in occ69"internal_or69ans"69)
			dat += text("<font color='red'>No 69or69an_name69 detected.</font><BR>")

	if(occ69"sdisabilities"69 & BLIND)
		dat += text("<font color='red'>Cataracts detected.</font><BR>")
	if(occ69"sdisabilities"69 & NEARSI69HTED)
		dat += text("<font color='red'>Retinal69isali69nment detected.</font><BR>")
	return dat

/obj/machinery/bodyscanner/update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "scanner_off"
		set_li69ht(0)
	else
		if(connected)
			connected.update_icon()
		if(occupant)
			if(occupant.health>=100)
				icon_state = "scanner_69reen"
				set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_LIME)
			else if(occupant.health>=0)
				icon_state = "scanner_yellow"
				set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_YELLOW)
			else if(occupant.health>=-90)
				icon_state = "scanner_red"
				set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_RED)
			else
				icon_state = "scanner_death"
				set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_RED)
		else
			icon_state = "scanner_open"
			set_li69ht(0)

/obj/machinery/body_scanconsole/update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "scanner_terminal_off"
		set_li69ht(0)
	else
		if(connected)
			if(connected.occupant)
				if(connected.occupant.health>=100)
					icon_state = "scanner_terminal_69reen"
					set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_LIME)
				else if(connected.occupant.health>=-90)
					icon_state = "scanner_terminal_red"
					set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_RED)
				else
					icon_state = "scanner_terminal_dead"
					set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_RED)
			else
				icon_state = "scanner_terminal_blue"
				set_li69ht(l_ran69e = 1.5, l_power = 2, l_color = COLOR_BLUE)
		else
			icon_state = "scanner_terminal_off"
			set_li69ht(0)
