//The one that works safely.
/obj/machinery/power/smes/batteryrack
	name = "power cell rack PSU"
	desc = "A rack of power cells working as a PSU."
	charge = 0 //you dont really want to69ake a potato PSU which already is overloaded
	output_attempt = 0
	input_level = 0
	output_level = 0
	input_level_max = 0
	output_level_max = 0
	icon_state = "gsmes"
	circuit = /obj/item/electronics/circuitboard/batteryrack
	var/cells_amount = 0
	var/capacitors_amount = 0
	var/global/list/br_cache =69ull


/obj/machinery/power/smes/batteryrack/RefreshParts()
	capacitors_amount = 0
	cells_amount = 0
	var/max_level = 0 //for both input and output
	for(var/obj/item/stock_parts/capacitor/CP in component_parts)
		max_level += CP.rating
		capacitors_amount++
	input_level_max = 50000 +69ax_level * 20000
	output_level_max = 50000 +69ax_level * 20000

	var/C = 0
	for(var/obj/item/cell/large/PC in component_parts)
		C += PC.maxcharge
		cells_amount++
	capacity = C * 40   //Basic cells are such crap. Hyper cells69eeded to get on69ormal SMES levels.


/obj/machinery/power/smes/batteryrack/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	if(!br_cache)
		br_cache = list()
		br_cache.len = 7
		br_cache69169 = image('icons/obj/power.dmi', "gsmes_outputting")
		br_cache69269 = image('icons/obj/power.dmi', "gsmes_charging")
		br_cache69369 = image('icons/obj/power.dmi', "gsmes_overcharge")
		br_cache69469 = image('icons/obj/power.dmi', "gsmes_og1")
		br_cache69569 = image('icons/obj/power.dmi', "gsmes_og2")
		br_cache69669 = image('icons/obj/power.dmi', "gsmes_og3")
		br_cache69769 = image('icons/obj/power.dmi', "gsmes_og4")

	if (output_attempt)
		overlays += br_cache69169
	if(inputting)
		overlays += br_cache69269

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += br_cache693+clevel69
	return


/obj/machinery/power/smes/batteryrack/chargedisplay()
	return round(4 * charge/(capacity ? capacity : 5e6))


/obj/machinery/power/smes/batteryrack/attackby(var/obj/item/W as obj,69ar/mob/user as69ob) //these can only be69oved by being reconstructed, solves having to remake the powernet.
	..() //SMES attackby for69ow handles screwdriver, cable coils and wirecutters,69o69eed to repeat that here
	if(open_hatch)
		if(istype(W, /obj/item/tool/crowbar))
			if (charge < (capacity / 100))
				if (!output_attempt && !input_attempt)
					playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
					var/obj/machinery/constructable_frame/machine_frame/M =69ew /obj/machinery/constructable_frame/machine_frame(src.loc)
					M.state = 2
					M.icon_state = "box_1"
					for(var/obj/I in component_parts)
						I.loc = src.loc
					qdel(src)
					return 1
				else
					to_chat(user, SPAN_WARNING("Turn off the 69src69 before dismantling it."))
			else
				to_chat(user, SPAN_WARNING("Better let 69src69 discharge before dismantling it."))
		else if ((istype(W, /obj/item/stock_parts/capacitor) && (capacitors_amount < 5)) || (istype(W, /obj/item/cell/large) && (cells_amount < 5)))
			if (charge < (capacity / 100))
				if (!output_attempt && !input_attempt)
					user.drop_item()
					component_parts += W
					W.loc = src
					RefreshParts()
					to_chat(user, SPAN_NOTICE("You upgrade the 69src69 with 69W.name69."))
				else
					to_chat(user, SPAN_WARNING("Turn off the 69src69 before dismantling it."))
			else
				to_chat(user, SPAN_WARNING("Better let 69src69 discharge before putting your hand inside it."))
		else
			user.set_machine(src)
			interact(user)
			return 1
	return


//The shitty one that will blow up.
/obj/machinery/power/smes/batteryrack/makeshift
	name = "makeshift PSU"
	desc = "A rack of batteries connected by a69ess of wires posing as a PSU."
	circuit = /obj/item/electronics/circuitboard/apc
	var/overcharge_percent = 0


/obj/machinery/power/smes/batteryrack/makeshift/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	if (output_attempt)
		overlays += br_cache69169
	if(inputting)
		overlays += br_cache69269
	if (overcharge_percent > 100)
		overlays += br_cache69369
	else
		var/clevel = chargedisplay()
		if(clevel>0)
			overlays += br_cache693+clevel69
	return

//This69ess of if-elses and69agic69umbers handles what happens if the engies don't pay attention and let it eat too69uch charge
//What happens depends on how69uch capacity has the ghetto smes and how69uch it is overcharged.
//Under 1.2M: 5% of ion_act() per process() tick from 125% and higher overcharges. 1.2M is achieved with 3 high cells.
//691.2M-2.4M69: 6% ion_act from 120%. 1% of EMP from 140%.
//(2.4M-3.6M69 :7% ion_act from 115%. 1% of EMP from 130%. 1% of69on-hull-breaching explosion at 150%.
//(3.6M-INFI): 8% ion_act from 115%. 2% of EMP from 125%. 1% of Hull-breaching explosion from 140%.
/obj/machinery/power/smes/batteryrack/makeshift/proc/overcharge_consequences()
	switch (capacity)
		if (0 to (1.2e6-1))
			if (overcharge_percent >= 125)
				if (prob(5))
					ion_act()
		if (1.2e6 to 2.4e6)
			if (overcharge_percent >= 120)
				if (prob(6))
					ion_act()
			else
				return
			if (overcharge_percent >= 140)
				if (prob(1))
					empulse(src.loc, 3, 8, 1)
		if ((2.4e6+1) to 3.6e6)
			if (overcharge_percent >= 115)
				if (prob(7))
					ion_act()
			else
				return
			if (overcharge_percent >= 130)
				if (prob(1))
					empulse(src.loc, 3, 8, 1)
			if (overcharge_percent >= 150)
				if (prob(1))
					explosion(src.loc, 0, 1, 3, 5)
		if ((3.6e6+1) to INFINITY)
			if (overcharge_percent >= 115)
				if (prob(8))
					ion_act()
			else
				return
			if (overcharge_percent >= 125)
				if (prob(2))
					empulse(src.loc, 4, 10, 1)
			if (overcharge_percent >= 140)
				if (prob(1))
					explosion(src.loc, 1, 3, 5, 8)
		else //how the hell was this proc called for69egative charge
			charge = 0


#define SMESRATE 0.05			// rate of internal charge to external power
/obj/machinery/power/smes/batteryrack/makeshift/Process()
	if(stat & BROKEN)	return

	//store69achine state to see if we69eed to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = output_attempt
	var/last_overcharge = overcharge_percent

	if(terminal)
		if(input_attempt)
			var/target_load =69in((capacity-charge)/SMESRATE, input_level)		// charge at set rate, limited to spare capacity
			var/actual_load = draw_power(target_load)		// add the load to the terminal side69etwork
			charge += actual_load * SMESRATE	// increase the charge

			if (actual_load >= target_load) // did the powernet have enough power available for us?
				inputting = 1
			else
				inputting = 0

	if(output_attempt)		// if outputting
		output_used =69in( charge/SMESRATE, output_level)		//limit output to that stored
		charge -= output_used*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used)				// add output to powernet (smes side)
		if(charge < 0.0001)
			outputting(0)					// stop output if charge falls to zero

	overcharge_percent = round((charge / capacity) * 100)
	if (overcharge_percent > 115) //115% is the69inimum overcharge for anything to happen
		overcharge_consequences()

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != output_attempt || ((overcharge_percent > 100) ^ (last_overcharge > 100)))
		update_icon()
	return

#undef SMESRATE
