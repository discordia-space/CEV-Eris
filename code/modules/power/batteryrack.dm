#define OVERKEY_PSU_CAPACITORS "CapacitorOverlays"
#define OVERKEY_PSU_INPUT "InputOverlays"
#define OVERKEY_PSU_OUTPUT "OutputOverlays"
//The one that works safely.
/obj/machinery/power/smes/batteryrack
	name = "power cell rack PSU"
	desc = "A rack of power cells working as a PSU."
	icon_state = "mpsu_closed"
	charge = 0 //you dont really want to make a potato PSU which already is overloaded
	output_attempt = 0
	input_level = 0
	output_level = 0
	input_level_max = 0
	output_level_max = 0
	circuit = /obj/item/electronics/circuitboard/batteryrack
	var/cells_amount = 0
	var/capacitors_amount = 0
	var/global/list/br_cache = null

/obj/machinery/power/smes/batteryrack/examine(mob/user, extra_description = "")
	if(open_hatch)
		extra_description += SPAN_NOTICE("\nIt currently hosts [cells_amount] cells.")
		if(get_dist(user, src) < 2)
			extra_description += SPAN_NOTICE("\nClick any cell below to remove them from \the [src]:")
			for(var/obj/item/cell/battery in component_parts)
				extra_description += SPAN_NOTICE("\n<a href='?src=\ref[src];remove_cell_in_hand=\ref[battery];user=\ref[user]'>\icon[battery] [battery.name]</a>")
	else
		extra_description += SPAN_NOTICE("\nThe hatch needs to be opened with a screwdriver to interact with the cells inside!")
	extra_description += SPAN_NOTICE("\nIt currently has [capacitors_amount] capacitors installed.")
	extra_description += SPAN_NOTICE("\nIt has a LCD screen. Left side is for charging and right side for discharging. Green means operating. Yellow means not discharging/charging or no network.")
	extra_description += SPAN_NOTICE("\nCan toggle input and output on/off with CtrlClick and AltClick. It is currently set to discharge at a maximum rate of [output_level] W, and recharge at a maximum rate of [input_level] W.")
	..(user, extra_description)

/obj/machinery/power/smes/batteryrack/attack_hand(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(open_hatch && !user.incapacitated(INCAPACITATION_DEFAULT))
		var/list/inputs = list()
		for(var/obj/item/cell/large/battery in component_parts)
			inputs.Add(battery)
		var/obj/item/input = input(user, "Choose cell to remove", "Cell removal UI", null) as anything in inputs
		if(input)
			if(!Adjacent(user))
				return
			if(!component_parts.Find(input))
				return
			input.forceMove(get_turf(user))
			user.put_in_active_hand(input)

/obj/machinery/power/smes/batteryrack/Topic(href, href_list)// May be better to strip this completely as it currently is, force a reconstruction for cell removal.
	/// For any UI related fuckery to NanoUI/Tgui
	. = ..()
	if(QDELETED(src))
		return
	if(open_hatch)
		if(href_list["remove_cell_in_hand"])
			var/mob/living/target = locate(href_list["user"])
			var/obj/item/cell/battery = locate(href_list["remove_cell_in_hand"])
			if(!target || !battery)
				return
			// No funny HREF switching to grab anything in the world... or anything inside the machine.
			// Don't use locate here , it searches by Type instead of reference
			if(!component_parts.Find(battery) || !istype(battery))
				return
			if(target.incapacitated(INCAPACITATION_DEFAULT))
				return
			if(!Adjacent(target))
				to_chat(target, SPAN_NOTICE("You are too far away from \the [src]."))
				return
			to_chat(target, SPAN_NOTICE("You remove \the [battery] from \the [src]."))
			component_parts.Remove(battery)
			battery.forceMove(get_turf(target))
			target.put_in_active_hand(battery)
			RefreshParts()
			update_icon()

/obj/machinery/power/smes/batteryrack/Initialize(mapload, d)
	. = ..()
	var/datum/component/overlay_manager/overlay_manager = AddComponent(/datum/component/overlay_manager)
	overlay_manager.addOverlay(OVERKEY_PSU_CAPACITORS, mutable_appearance(icon, "caps_0"))
	overlay_manager.addOverlay(OVERKEY_PSU_INPUT, mutable_appearance(icon, "mpsu_tryinginput"))
	overlay_manager.addOverlay(OVERKEY_PSU_OUTPUT, mutable_appearance(icon, "mpsu_tryingdischarge"))


/obj/machinery/power/smes/batteryrack/RefreshParts()
	capacitors_amount = 0
	cells_amount = 0
	var/max_level = 0 //for both input and output
	for(var/obj/item/stock_parts/capacitor/CP in component_parts)
		max_level += CP.rating
		capacitors_amount++
	input_level_max = 50000 + max_level * 20000
	output_level_max = 50000 + max_level * 20000
	output_level = output_level_max
	input_level = input_level_max

	var/C = 0
	for(var/obj/item/cell/large/PC in component_parts)
		C += PC.maxcharge
		cells_amount++
	capacity = C * 40   //Basic cells are such crap. Hyper cells needed to get on normal SMES levels.


/obj/machinery/power/smes/batteryrack/update_icon()
	if(!open_hatch)
		icon_state = "mpsu_closed"
	else
		switch(cells_amount)
			if(0)
				icon_state = "mpsu_0"
			if(1)
				icon_state = "mpsu_1"
			if(2 to 3)
				icon_state = "mpsu_3"
			if(4 to 5)
				icon_state = "mpsu_5"
	var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
	overlay_manager.updateOverlay(OVERKEY_PSU_CAPACITORS, mutable_appearance(icon, "caps_[capacitors_amount]"))
	overlay_manager.updateOverlay(OVERKEY_PSU_INPUT, mutable_appearance(icon, inputting == 2 ? "mpsu_input" : "mpsu_tryinginput"))
	overlay_manager.updateOverlay(OVERKEY_PSU_OUTPUT, mutable_appearance(icon, outputting == 2 ? "mpsu_discharging" : "mpsu_tryingdischarge"))
	return

#undef OVERKEY_PSU_CAPACITORS


/obj/machinery/power/smes/batteryrack/chargedisplay()
	return round(4 * charge/(capacity ? capacity : 5e6))


/obj/machinery/power/smes/batteryrack/attackby(var/obj/item/W as obj, var/mob/user as mob) //these can only be moved by being reconstructed, solves having to remake the powernet.
	..() //SMES attackby for now handles screwdriver, cable coils and wirecutters, no need to repeat that here
	// we need to update icon incase we get opened in the parent call
	update_icon()
	if(open_hatch)
		if(istype(W, /obj/item/tool/crowbar))
			if (charge < (capacity / 100) || capacity == 0)
				if (!output_attempt && !input_attempt)
					playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1)
					dismantle()
				else
					to_chat(user, SPAN_WARNING("Turn off the [src] before dismantling it."))
			else
				to_chat(user, SPAN_WARNING("Better let [src] discharge before dismantling it."))
		else if ((istype(W, /obj/item/stock_parts/capacitor) && (capacitors_amount < 5)) || (istype(W, /obj/item/cell/large) && (cells_amount < 5)))
			if (charge < (capacity / 100) || capacity == 0)
				if (!output_attempt && !input_attempt)
					user.drop_item()
					component_parts += W
					W.forceMove(src)
					RefreshParts()
					to_chat(user, SPAN_NOTICE("You upgrade the [src] with [W.name]."))
					update_icon()
				else
					to_chat(user, SPAN_WARNING("Turn off the [src] before dismantling it."))
			else
				to_chat(user, SPAN_WARNING("Better let [src] discharge before putting your hand inside it."))
		else
			user.set_machine(src)
			interact(user)
			return 1
	return

/obj/machinery/power/smes/batteryrack/attack_hand()


//The shitty one that will blow up.
/obj/machinery/power/smes/batteryrack/makeshift
	name = "makeshift PSU"
	desc = "A rack of batteries connected by a mess of wires posing as a PSU."
	icon_state = "gsmes"
	circuit = /obj/item/electronics/circuitboard/apc
	var/overcharge_percent = 0


/obj/machinery/power/smes/batteryrack/makeshift/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	if(!br_cache)
		br_cache = list()
		br_cache.len = 7
		br_cache[1] = image('icons/obj/power.dmi', "gsmes_outputting")
		br_cache[2] = image('icons/obj/power.dmi', "gsmes_charging")
		br_cache[3] = image('icons/obj/power.dmi', "gsmes_overcharge")
		br_cache[4] = image('icons/obj/power.dmi', "gsmes_og1")
		br_cache[5] = image('icons/obj/power.dmi', "gsmes_og2")
		br_cache[6] = image('icons/obj/power.dmi', "gsmes_og3")
		br_cache[7] = image('icons/obj/power.dmi', "gsmes_og4")

	if (output_attempt)
		overlays += br_cache[1]
	if(inputting)
		overlays += br_cache[2]
	if (overcharge_percent > 100)
		overlays += br_cache[3]
	else
		var/clevel = chargedisplay()
		if(clevel>0)
			overlays += br_cache[3+clevel]
	return

//This mess of if-elses and magic numbers handles what happens if the engies don't pay attention and let it eat too much charge
//What happens depends on how much capacity has the ghetto smes and how much it is overcharged.
//Under 1.2M: 5% of ion_act() per process() tick from 125% and higher overcharges. 1.2M is achieved with 3 high cells.
//[1.2M-2.4M]: 6% ion_act from 120%. 1% of EMP from 140%.
//(2.4M-3.6M] :7% ion_act from 115%. 1% of EMP from 130%. 1% of non-hull-breaching explosion at 150%.
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
					explosion(get_turf(src), 500, 100)
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
					explosion(get_turf(src), 500, 50)
		else //how the hell was this proc called for negative charge
			charge = 0


#define SMESRATE 0.05			// rate of internal charge to external power
/obj/machinery/power/smes/batteryrack/makeshift/Process()
	if(stat & BROKEN)	return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = output_attempt
	var/last_overcharge = overcharge_percent

	if(terminal)
		if(input_attempt)
			var/target_load = min((capacity-charge)/SMESRATE, input_level)		// charge at set rate, limited to spare capacity
			var/actual_load = draw_power(target_load)		// add the load to the terminal side network
			charge += actual_load * SMESRATE	// increase the charge

			if (actual_load >= target_load) // did the powernet have enough power available for us?
				inputting = 1
			else
				inputting = 0

	if(output_attempt)		// if outputting
		output_used = min( charge/SMESRATE, output_level)		//limit output to that stored
		charge -= output_used*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used)				// add output to powernet (smes side)
		if(charge < 0.0001)
			outputting(0)					// stop output if charge falls to zero

	overcharge_percent = round((charge / capacity) * 100)
	if (overcharge_percent > 115) //115% is the minimum overcharge for anything to happen
		overcharge_consequences()

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != output_attempt || ((overcharge_percent > 100) ^ (last_overcharge > 100)))
		update_icon()
	return

#undef SMESRATE
