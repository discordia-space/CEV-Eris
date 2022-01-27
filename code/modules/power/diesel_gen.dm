///////////////////////////////
//UNFINISHED CUZ I'M TOO LAZY//
//        DO69OT READ        //
///////////////////////////////
/obj/machinery/power/port_gen/pacman
	name = "\improper P.A.C.M.A.N.-type Portable Generator"
	desc = "A power generator that runs on solid plasma sheets. Rated for 80 kW69ax safe output."

	var/fuel_type = "fuel"
	circuit = /obj/item/electronics/circuitboard/diesel

	/*
		These69alues were chosen so that the generator can run safely up to 80 kW
		A full 50 plasma sheet stack should last 2069inutes at power_output = 4
		temperature_gain and69ax_temperature are set so that the69ax safe power level is 4.
		Setting to 5 or higher can only be done temporarily before the generator overheats.
	*/
	power_gen = 20000			//Watts output per power_output level
	var/max_power_output = 5	//The69aximum power setting without emagging.
	var/max_safe_output = 4		// For UI use,69aximal output that won't cause overheat.
	var/time_per_sheet = 96		//fuel efficiency - how long 1 sheet lasts at power level 1
	var/max_sheets = 120 		//max capacity of the hopper
	var/max_temperature = 300	//max temperature before overheating increases
	var/temperature_gain = 50	//how69uch the temperature increases per power output level, in degrees per level

	var/fuel_stored = 0
	var/fuel_max = 1000
	var/temperature = 0		//The current temperature
	var/overheating = 0		//if this gets high enough the generator explodes

/obj/machinery/power/port_gen/pacman/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/pacman/Destroy()
	DropFuel()
	return ..()

/obj/machinery/power/port_gen/pacman/RefreshParts()
	var/temp_rating = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/matter_bin))
			max_sheets = SP.rating * SP.rating * 50
		else if(istype(SP, /obj/item/stock_parts/micro_laser) || istype(SP, /obj/item/stock_parts/capacitor))
			temp_rating += SP.rating

	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/port_gen/pacman/examine(mob/user)
	..(user)
	user << "\The 69src69 appears to be producing 69power_gen*power_output69 W."
	user << "There 69sheets == 1 ? "is" : "are"69 69sheets69 sheet\s left in the hopper."
	if(IsBroken()) user << SPAN_WARNING("\The 69src69 seems to have broken down.")
	if(overheating) user << SPAN_DANGER("\The 69src69 is overheating!")

/obj/machinery/power/port_gen/pacman/HasFuel()
	var/needed_sheets = power_output / time_per_sheet
	if(sheets >=69eeded_sheets - sheet_left)
		return 1
	return 0

//Removes one stack's worth of69aterial from the generator.
/obj/machinery/power/port_gen/pacman/DropFuel()
	if(sheets)
		var/obj/item/stack/material/S =69ew sheet_path(loc)
		var/amount =69in(sheets, S.max_amount)
		S.amount = amount
		sheets -= amount

/obj/machinery/power/port_gen/pacman/UseFuel()

	//how69uch69aterial are we using this iteration?
	var/needed_sheets = power_output / time_per_sheet

	//HasFuel() should guarantee us that there is enough fuel left, so69o69eed to check that
	//the only thing we69eed to worry about is if we are going to rollover to the69ext sheet
	if (needed_sheets > sheet_left)
		sheets--
		sheet_left = (1 + sheet_left) -69eeded_sheets
	else
		sheet_left -=69eeded_sheets

	//calculate the "target" temperature range
	//This should probably depend on the external temperature somehow, but whatever.
	var/lower_limit = 56 + power_output * temperature_gain
	var/upper_limit = 76 + power_output * temperature_gain

	/*
		Hot or cold environments can affect the equilibrium temperature
		The lower the pressure the less effect it has. I guess it cools using a radiator or something when in69acuum.
		Gives contractors69ore opportunities to sabotage the generator or allows enterprising engineers to build additional
		cooling in order to get69ore power out.
	*/
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio =69in(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		lower_limit += ambient*ratio
		upper_limit += ambient*ratio

	var/average = (upper_limit + lower_limit)/2

	//calculate the temperature increase
	var/bias = 0
	if (temperature < lower_limit)
		bias =69in(round((average - temperature)/TEMPERATURE_DIVISOR, 1), TEMPERATURE_CHANGE_MAX)
	else if (temperature > upper_limit)
		bias =69ax(round((temperature - average)/TEMPERATURE_DIVISOR, 1), -TEMPERATURE_CHANGE_MAX)

	//limit temperature increase so that it cannot raise temperature above upper_limit,
	//or if it is already above upper_limit, limit the increase to 0.
	var/inc_limit =69ax(upper_limit - temperature, 0)
	var/dec_limit =69in(temperature - lower_limit, 0)
	temperature += between(dec_limit, rand(-7 + bias, 7 + bias), inc_limit)

	if (temperature >69ax_temperature)
		overheat()
	else if (overheating > 0)
		overheating--

/obj/machinery/power/port_gen/pacman/handleInactive()
	var/cooling_temperature = 20
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio =69in(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		cooling_temperature += ambient*ratio

	if (temperature > cooling_temperature)
		var/temp_loss = (temperature - cooling_temperature)/TEMPERATURE_DIVISOR
		temp_loss = between(2, round(temp_loss, 1), TEMPERATURE_CHANGE_MAX)
		temperature =69ax(temperature - temp_loss, cooling_temperature)
		src.updateDialog()

	if(overheating)
		overheating--

/obj/machinery/power/port_gen/pacman/proc/overheat()
	overheating++
	if (overheating > 60)
		explode()

/obj/machinery/power/port_gen/pacman/explode()
	//Vapourize all the plasma
	//When ground up in a grinder, 1 sheet produces 20 u of plasma -- Chemistry-Machinery.dm
	//169ol = 10 u? I dunno. 169ol of carbon is definitely bigger than a pill
	var/plasma = (sheets+sheet_left)*20
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		environment.adjust_gas_temp("plasma", plasma/10, temperature + T0C)

	sheets = 0
	sheet_left = 0
	..()

/obj/machinery/power/port_gen/pacman/emag_act(var/remaining_charges,69ar/mob/user)
	if (active && prob(25))
		explode() //if they're foolish enough to emag while it's running

	if (!emagged)
		emagged = 1
		return 1

/obj/machinery/power/port_gen/pacman/attackby(var/obj/item/I,69ar/mob/user)

	if(istype(I, sheet_path))
		var/obj/item/stack/addstack = I
		var/amount =69in((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			user << "\blue The 69src.name69 is full!"
			return
		user << "\blue You add 69amount69 sheet\s to the 69src.name69."
		sheets += amount
		addstack.use(amount)
		updateUsrDialog()
		return

	if(active)
		user << SPAN_NOTICE("You can't work with 69src69 while its running!")

	else

		var/list/usable_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING)
		if(open)
			usable_qualities.Add(QUALITY_PRYING)

		var/tool_type = I.get_tool_type(user, usable_qualities, src)
		switch(tool_type)

			if(QUALITY_PRYING)
				if(open)
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_PRD))
						var/obj/machinery/constructable_frame/machine_frame/new_frame =69ew /obj/machinery/constructable_frame/machine_frame(src.loc)
						for(var/obj/item/CP in component_parts)
							CP.loc = src.loc
						while ( sheets > 0 )
							DropFuel()
						new_frame.state = 2
						new_frame.icon_state = "box_1"
						qdel(src)
					return
				return

			if(QUALITY_SCREW_DRIVING)
				var/used_sound = open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_PRD, instant_finish_tier = 30, forced_sound = used_sound))
					open = !open
					user << SPAN_NOTICE("You 69open ? "open" : "close"69 the69aintenance hatch of \the 69src69 with 69I69.")
					update_icon()
					return
				return

			if(QUALITY_BOLT_TURNING)
				if(istype(get_turf(src), /turf/space) && !anchored)
					user << SPAN_NOTICE("You can't anchor something to empty space. Idiot.")
					return
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_PRD))
					user << SPAN_NOTICE("You 69anchored ? "un" : ""69anchor the brace with 69I69.")
					anchored = !anchored
					if(anchored)
						connect_to_network()
					else
						disconnect_from_network()

			if(ABORT_CHECK)
				return

/obj/machinery/power/port_gen/pacman/attack_hand(mob/user as69ob)
	..()
	if (!anchored)
		return
	ui_interact(user)

/obj/machinery/power/port_gen/pacman/attack_ai(mob/user as69ob)
	ui_interact(user)

/obj/machinery/power/port_gen/pacman/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(IsBroken())
		return

	var/data69069
	data69"active"69 = active

	if(isAI(user))
		data69"is_ai"69 = 1
	else if(isrobot(user) && !Adjacent(user))
		data69"is_ai"69 = 1
	else
		data69"is_ai"69 = 0

	data69"output_set"69 = power_output
	data69"output_max"69 =69ax_power_output
	data69"output_safe"69 =69ax_safe_output
	data69"output_watts"69 = power_output * power_gen
	data69"temperature_current"69 = src.temperature
	data69"temperature_max"69 = src.max_temperature
	data69"temperature_overheat"69 = overheating
	data69"fuel_stored"69 = round(sheets + sheet_left, 0.1)
	data69"fuel_capacity"69 =69ax_sheets
	data69"fuel_usage"69 = active ? round(power_output / time_per_sheet, 0.1) : 0
	data69"fuel_type"69 = sheet_name
	data69"fuel_units"69 = "sheets"
	data69"fuel_ejectable"69 = TRUE

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "pacman.tmpl", src.name, 500, 560)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/*
/obj/machinery/power/port_gen/pacman/interact(mob/user)
	if (get_dist(src, user) > 1 )
		if (!isAI(user))
			user.unset_machine()
			user << browse(null, "window=port_gen")
			return

	user.set_machine(src)

	var/dat = text("<b>69name69</b><br>")
	if (active)
		dat += text("Generator: <A href='?src=\ref69src69;action=disable'>On</A><br>")
	else
		dat += text("Generator: <A href='?src=\ref69src69;action=enable'>Off</A><br>")
	dat += text("69capitalize(sheet_name)69: 69sheets69 - <A href='?src=\ref69src69;action=eject'>Eject</A><br>")
	var/stack_percent = round(sheet_left * 100, 1)
	dat += text("Current stack: 69stack_percent69% <br>")
	dat += text("Power output: <A href='?src=\ref69src69;action=lower_power'>-</A> 69power_gen * power_output69 Watts<A href='?src=\ref69src69;action=higher_power'>+</A><br>")
	dat += text("Power current: 69(powernet ==69ull ? "Unconnected" : "69avail()69")69<br>")

	var/tempstr = "Temperature: 69temperature69&deg;C<br>"
	dat += (overheating)? SPAN_DANGER("69tempstr69") : tempstr
	dat += "<br><A href='?src=\ref69src69;action=close'>Close</A>"
	user << browse("69dat69", "window=port_gen")
	onclose(user, "port_gen")
*/

/obj/machinery/power/port_gen/pacman/Topic(href, href_list)
	if(..())
		return

	src.add_fingerprint(usr)
	if(href_list69"action"69)
		if(href_list69"action"69 == "enable")
			if(!active && HasFuel() && !IsBroken())
				active = 1
				icon_state = "portgen1"
		if(href_list69"action"69 == "disable")
			if (active)
				active = 0
				icon_state = "portgen0"
		if(href_list69"action"69 == "eject")
			if(!active)
				DropFuel()
		if(href_list69"action"69 == "lower_power")
			if (power_output > 1)
				power_output--
		if (href_list69"action"69 == "higher_power")
			if (power_output <69ax_power_output || (emagged && power_output < round(max_power_output*2.5)))
				power_output++
