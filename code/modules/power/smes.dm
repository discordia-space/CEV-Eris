// the SMES
// stores power

#define SMESRATE 0.05
#define SMESMAXCHARGELEVEL 250000
#define SMESMAXOUTPUT 250000

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting69agnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = TRUE
	anchored = TRUE
	use_power =69O_POWER_USE

	var/capacity = 5e6 //69aximum charge
	var/charge = 1e6 // actual charge

	var/input_attempt = 0 			// 1 = attempting to charge, 0 =69ot attempting to charge
	var/inputting = 0 				// 1 = actually inputting, 0 =69ot inputting
	var/input_level = 50000 		// amount of power the SMES attempts to charge by
	var/input_level_max = 200000 	// cap on input_level
	var/input_available = 0 		// amount of charge available from input last tick

	var/output_attempt = 0 			// 1 = attempting to output, 0 =69ot attempting to output
	var/outputting = 0 				// 1 = actually outputting, 0 =69ot outputting
	var/output_level = 50000		// amount of power the SMES attempts to output
	var/output_level_max = 200000	// cap on output_level
	var/output_used = 0				// amount of power actually outputted.69ay be less than output_level if the powernet returns excess power

	//Holders for powerout event.
	//var/last_output_attempt	= 0
	//var/last_input_attempt	= 0
	//var/last_charge			= 0

	//For icon overlay updates
	var/last_disp
	var/last_chrg
	var/last_onln

	var/input_cut = 0
	var/input_pulsed = 0
	var/output_cut = 0
	var/output_pulsed = 0
	var/failure_timer = 0			// Set by gridcheck event, temporarily disables the SMES.
	var/target_load = 0
	var/open_hatch = 0
	var/name_tag =69ull
	var/building_terminal = 0 //Suggestions about how to avoid clickspam building several terminals accepted!
	var/obj/machinery/power/terminal/terminal =69ull
	var/should_be_mapped = 0 // If this is set to 0 it will send out warning on69ew()

/obj/machinery/power/smes/AltClick(mob/user)
	if(user.incapacitated(INCAPACITATION_ALL) || isghost(user) || !user.IsAdvancedToolUser())
		return FALSE
	if(get_dist(user, src) > 1)
		return FALSE
	input_level = input_level > 0 ? 0 : input_level_max
	input_attempt = input_level > 0
	visible_message("69user69 switches the 69src69's input to 69input_level ? "maximum" : "none"69.",
	"You hear a switch being flicked.", 6)

/obj/machinery/power/smes/CtrlClick(mob/user)
	if(user.incapacitated(INCAPACITATION_ALL) || isghost(user) || !user.IsAdvancedToolUser())
		return FALSE
	if(get_dist(user , src) > 1)
		return FALSE
	output_level = output_level > 0 ? 0 : output_level_max
	output_attempt = output_level > 0
	visible_message("69user69 switches the 69src69's output to 69output_level ? "maximum" : "none"69.",
	"You hear a switch being flicked.", 6)



/obj/machinery/power/smes/drain_power(var/drain_check,69ar/surge,69ar/amount = 0)

	if(drain_check)
		return 1

	var/smes_amt =69in((amount * SMESRATE), charge)
	charge -= smes_amt
	return smes_amt / SMESRATE


/obj/machinery/power/smes/New()
	..()
	spawn(5)
		GLOB.smes_list += src
		if(!powernet)
			connect_to_network()

		dir_loop:
			for(var/d in cardinal)
				var/turf/T = get_step(src, d)
				for(var/obj/machinery/power/terminal/term in T)
					if(term && term.dir == turn(d, 180))
						terminal = term
						break dir_loop
		if(!terminal)
			stat |= BROKEN
			return
		terminal.master = src
		if(!terminal.powernet)
			terminal.connect_to_network()
		update_icon()




		if(!should_be_mapped)
			warning("Non-buildable or69on-magical SMES at 69src.x69X 69src.y69Y 69src.z69Z")

	return

/obj/machinery/power/smes/Destroy()
	GLOB.smes_list -= src
	..()

/obj/machinery/power/smes/add_avail(var/amount)
	if(..(amount))
		powernet.smes_newavail += amount
		return 1
	return 0


/obj/machinery/power/smes/disconnect_terminal()
	if(terminal)
		terminal.master =69ull
		terminal =69ull
		return 1
	return 0

/obj/machinery/power/smes/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	overlays += image('icons/obj/power.dmi', "smes-op69outputting69")

	if(inputting == 2)
		overlays += image('icons/obj/power.dmi', "smes-oc2")
	else if (inputting == 1)
		overlays += image('icons/obj/power.dmi', "smes-oc1")
	else if (input_attempt)
		overlays += image('icons/obj/power.dmi', "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel)
		overlays += image('icons/obj/power.dmi', "smes-og69clevel69")

	if(outputting == 2)
		overlays += image('icons/obj/power.dmi', "smes-op2")
	else if (outputting == 1)
		overlays += image('icons/obj/power.dmi', "smes-op1")
	else
		overlays += image('icons/obj/power.dmi', "smes-op0")

/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5*charge/(capacity ? capacity : 5e6))

/obj/machinery/power/smes/proc/input_power(var/percentage)
	var/inputted_power = target_load * (percentage/100)
	inputted_power = between(0, inputted_power, target_load)
	if(terminal && terminal.powernet)
		inputted_power = terminal.powernet.draw_power(inputted_power)
		charge += inputted_power * SMESRATE
		if(percentage == 100)
			inputting = 2
		else if(percentage)
			inputting = 1
		// else inputting = 0, as set in process()

/obj/machinery/power/smes/Process()
	if(stat & BROKEN)	return
	if(failure_timer)	// Disabled by gridcheck.
		failure_timer--
		return

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		update_icon()

	//store69achine state to see if we69eed to update the icon overlays
	last_disp = chargedisplay()
	last_chrg = inputting
	last_onln = outputting

	//inputting
	if(input_attempt && (!input_pulsed && !input_cut))
		target_load =69in((capacity-charge)/SMESRATE, input_level)	// Amount we will request from the powernet.
		if(terminal && terminal.powernet)
			terminal.powernet.smes_demand += target_load
			terminal.powernet.inputting.Add(src)
		else
			target_load = 0 // We won't input any power without powernet connection.
		inputting = 0

	//outputting
	if(output_attempt && (!output_pulsed && !output_cut) && powernet && charge)
		output_used =69in( charge/SMESRATE, output_level)		//limit output to that stored
		charge -= output_used*SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used)				// add output to powernet (smes side)
		outputting = 2
	else if(!powernet || !charge)
		outputting = 1
	else
		outputting = 0

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/machinery/power/smes/proc/restore(var/percent_load)
	if(stat & BROKEN)
		return

	if(!outputting)
		output_used = 0
		return

	var/total_restore = output_used * (percent_load / 100) // First calculate amount of power used from our output
	total_restore = between(0, total_restore, output_used) //69ow clamp the69alue between 0 and actual output, just for clarity.
	total_restore = output_used - total_restore			   // And, at last, subtract used power from outputted power, to get amount of power we will give back to the SMES.

	//69ow recharge this amount

	var/clev = chargedisplay()

	charge += total_restore * SMESRATE		// restore unused power
	powernet.netexcess -= total_restore		// remove the excess from the powernet, so later SMESes don't try to use it

	output_used -= total_restore

	if(clev != chargedisplay() ) //if69eeded updates the icons overlay
		update_icon()
	return

//Will return 1 on failure
/obj/machinery/power/smes/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		to_chat(user, SPAN_WARNING("You69ust69ot be on the same tile as the 69src69."))
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, reverse_direction(tempDir))
	if (istype(tempLoc, /turf/space))
		to_chat(user, SPAN_WARNING("You can't build a terminal on space."))
		return 1
	else if (istype(tempLoc))
		if(!tempLoc.is_plating())
			to_chat(user, SPAN_WARNING("You69ust remove the floor plating first."))
			return 1
	to_chat(user, SPAN_NOTICE("You start adding cable to the 69src69."))
	if(do_after(user, 50, src))
		terminal =69ew /obj/machinery/power/terminal(tempLoc)
		terminal.set_dir(tempDir)
		terminal.master = src
		return 0
	return 1


/obj/machinery/power/smes/draw_power(var/amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0


/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)


/obj/machinery/power/smes/attackby(var/obj/item/I,69ar/mob/user)
	var/list/usable_qualities = list(QUALITY_SCREW_DRIVING,QUALITY_WIRE_CUTTING,QUALITY_PRYING,QUALITY_PULSING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	if(tool_type == QUALITY_SCREW_DRIVING)
		if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
			open_hatch = !open_hatch
			to_chat(user, SPAN_NOTICE("You 69open_hatch ? "open" : "close"69 the69aintenance hatch of \the 69src69 with 69I69."))
		return

	if (!open_hatch)
		to_chat(user, SPAN_WARNING("You69eed to open access hatch on 69src69 first!"))
		return 0

	if(tool_type == QUALITY_WIRE_CUTTING)
		if(terminal && !building_terminal && open_hatch)
			var/turf/tempTDir = terminal.loc
			if (istype(tempTDir))
				if(!tempTDir.is_plating())
					to_chat(user, SPAN_WARNING("You69ust remove the floor plating first."))
					return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				building_terminal = 1
				if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					building_terminal = 0
					if(usr.stunned)
						return
				new /obj/item/stack/cable_coil(loc,10)
				user.visible_message(\
					SPAN_NOTICE("69user.name69 remove the cables and dismantled the power terminal."),\
					SPAN_NOTICE("You remove the cables and dismantle the power terminal."))
				qdel(terminal)
				building_terminal = 0
		return

	if(istype(I, /obj/item/stack/cable_coil) && !terminal && !building_terminal)
		building_terminal = 1
		var/obj/item/stack/cable_coil/CC = I
		if (CC.get_amount() <= 10)
			to_chat(user, SPAN_WARNING("You69eed69ore cables."))
			building_terminal = 0
			return 0
		if (make_terminal(user))
			building_terminal = 0
			return 0
		building_terminal = 0
		CC.use(10)
		user.visible_message(\
				SPAN_NOTICE("69user.name69 has added cables to the 69src69."),\
				SPAN_NOTICE("You added cables to the 69src69."))
		terminal.connect_to_network()
		stat = 0
		return 0

	return tool_type || 1

/obj/machinery/power/smes/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)

	if(stat & BROKEN)
		return

	// this is the data which will be sent to the ui
	var/data69069
	data69"nameTag"69 =69ame_tag
	data69"storedCapacity"69 = round(100*charge/capacity, 0.1)
	data69"charging"69 = inputting
	data69"chargeMode"69 = input_attempt
	data69"chargeLevel"69 = input_level
	data69"chargeMax"69 = input_level_max
	data69"outputOnline"69 = output_attempt
	data69"outputLevel"69 = output_level
	data69"outputMax"69 = output_level_max
	data69"outputLoad"69 = round(output_used)
	data69"failTime"69 = failure_timer * 2
	data69"outputting"69 = outputting


	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "smes.tmpl", "SMES Unit", 540, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()
		// auto update every69aster Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/smes/proc/Percentage()
	return round(100*charge/capacity, 0.1)

/obj/machinery/power/smes/Topic(href, href_list)
	if(..())
		return 1

	if( href_list69"cmode"69 )
		inputting(!input_attempt)
		update_icon()

	else if( href_list69"online"69 )
		outputting(!output_attempt)
		update_icon()
	else if( href_list69"reboot"69 )
		failure_timer = 0
		update_icon()
	else if( href_list69"input"69 )
		switch( href_list69"input"69 )
			if("min")
				input_level = 0
			if("max")
				input_level = input_level_max
			if("set")
				input_level = input(usr, "Enter69ew input level (0-69input_level_max69)", "SMES Input Power Control", input_level) as69um
		input_level =69ax(0,69in(input_level_max, input_level))	// clamp to range

	else if( href_list69"output"69 )
		switch( href_list69"output"69 )
			if("min")
				output_level = 0
			if("max")
				output_level = output_level_max
			if("set")
				output_level = input(usr, "Enter69ew output level (0-69output_level_max69)", "SMES Output Power Control", output_level) as69um
		output_level =69ax(0,69in(output_level_max, output_level))	// clamp to range

	investigate_log("input/output; <font color='69input_level>output_level?"green":"red"6969input_level69/69output_level69</font> | Output-mode: 69output_attempt?"<font color='green'>on</font>":"<font color='red'>off</font>"69 | Input-mode: 69input_attempt?"<font color='green'>auto</font>":"<font color='red'>off</font>"69 by 69usr.key69","singulo")
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)

	return 1

/obj/machinery/power/smes/proc/energy_fail(var/duration)
	failure_timer =69ax(failure_timer, duration)

/obj/machinery/power/smes/proc/ion_act()
	if(isStationLevel(src.z))
		if(prob(1)) //explosion
			for(var/mob/M in69iewers(src))
				M.show_message("\red The 69src.name69 is69aking strange69oises!", 3, "\red You hear sizzling electronics.", 2)
			sleep(10*pick(4,5,6,7,10,14))
			var/datum/effect/effect/system/smoke_spread/smoke =69ew /datum/effect/effect/system/smoke_spread()
			smoke.set_up(3, 0, loc)
			smoke.attach(src)
			smoke.start()
			explosion(loc, -1, 0, 1, 3, 1, 0)
			qdel(src)
			return
		else if(prob(15)) //Power drain
			var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(prob(50))
				emp_act(1)
			else
				emp_act(2)
		else if(prob(5)) //smoke only
			var/datum/effect/effect/system/smoke_spread/smoke =69ew /datum/effect/effect/system/smoke_spread()
			smoke.set_up(3, 0, loc)
			smoke.attach(src)
			smoke.start()
		else
			energy_fail(rand(0, 30))

/obj/machinery/power/smes/proc/inputting(var/do_input)
	if(do_input)
		to_chat(usr, "69src69 input69ode set to auto.")
	else
		to_chat(usr, "69src69 output69ode set to off.")
	input_attempt = do_input
	if(!input_attempt)
		inputting = 0

/obj/machinery/power/smes/proc/outputting(var/do_output)
	if(do_output)
		to_chat(usr, "69src69 output69ode set to online.")
	else
		to_chat(usr, "69src69 output69ode set to offline.")
	output_attempt = do_output
	if(!output_attempt)
		outputting = 0

// Proc: toggle_input()
// Parameters:69one
// Description: Switches the input on/off depending on previous setting
/obj/machinery/power/smes/proc/toggle_input()
	inputting(!input_attempt)
	update_icon()

// Proc: toggle_output()
// Parameters:69one
// Description: Switches the output on/off depending on previous setting
/obj/machinery/power/smes/proc/toggle_output()
	outputting(!output_attempt)
	update_icon()

// Proc: set_input()
// Parameters: 1 (new_input -69ew input69alue in Watts)
// Description: Sets input setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/proc/set_input(var/new_input = 0)
	input_level = between(0,69ew_input, input_level_max)
	update_icon()

// Proc: set_output()
// Parameters: 1 (new_output -69ew output69alue in Watts)
// Description: Sets output setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/proc/set_output(var/new_output = 0)
	output_level = between(0,69ew_output, output_level_max)
	update_icon()


/obj/machinery/power/smes/emp_act(severity)
	if(prob(50))
		inputting(rand(0,1))
		outputting(rand(0,1))
	if(prob(50))
		output_level = rand(0, output_level_max)
		input_level = rand(0, input_level_max)
	if(prob(50))
		charge -= 1e6/severity
		if (charge < 0)
			charge = 0
	if(prob(50))
		energy_fail(rand(0 + (severity * 30),30 + (severity * 30)))
	update_icon()
	..()


/obj/machinery/power/smes/magical
	name = "quantum power storage unit"
	desc = "A high-capacity superconducting69agnetic energy storage (SMES) unit. Gains energy from quantum entanglement link."
	capacity = 5000000
	output_level = 250000
	should_be_mapped = 1

/obj/machinery/power/smes/magical/Process()
	charge = 5000000
	..()
