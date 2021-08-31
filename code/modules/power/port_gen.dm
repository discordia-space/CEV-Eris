//Baseline portable generator. Has all the default handling. Not intended to be used on it's own (since it generates unlimited power).
/obj/machinery/power/port_gen
	name = "Placeholder Generator"	//seriously, don't use this. It can't be anchored without VV magic.
	desc = "A portable generator for emergency backup power"
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE

	var/active = 0
	var/power_gen = 5000
	var/open = 0
	var/recent_fault = 0
	var/power_output = 1

/obj/machinery/power/port_gen/proc/IsBroken()
	return (stat & (BROKEN|EMPED))

/obj/machinery/power/port_gen/proc/HasFuel() //Placeholder for fuel check.
	return 1

/obj/machinery/power/port_gen/proc/UseFuel() //Placeholder for fuel use.
	return

/obj/machinery/power/port_gen/proc/DropFuel()
	return

/obj/machinery/power/port_gen/proc/handleInactive()
	return

/obj/machinery/power/port_gen/Process()
	if(active && HasFuel() && !IsBroken() && anchored && powernet)
		add_avail(power_gen * power_output)
		UseFuel()
		src.updateDialog()
	else
		active = 0
		handleInactive()

	update_icon()

/obj/machinery/power/powered()
	return 1 //doesn't require an external power source

/obj/machinery/power/port_gen/attack_hand(mob/user as mob)
	if(..())
		return
	if(!anchored)
		return

/obj/machinery/power/port_gen/on_update_icon()
	if(!active)
		icon_state = initial(icon_state)

/obj/machinery/power/port_gen/examine(mob/user)
	if(!..(user,1 ))
		return
	if(active)
		to_chat(user, SPAN_NOTICE("The generator is on."))
	else
		to_chat(user, SPAN_NOTICE("The generator is off."))

/obj/machinery/power/port_gen/emp_act(severity)
	var/duration = 6000 //ten minutes
	switch(severity)
		if(1)
			stat &= BROKEN
			if(prob(75)) explode()
		if(2)
			if(prob(25)) stat &= BROKEN
			if(prob(10)) explode()
		if(3)
			if(prob(10)) stat &= BROKEN
			duration = 300

	stat |= EMPED
	if(duration)
		spawn(duration)
			stat &= ~EMPED

/obj/machinery/power/port_gen/proc/explode()
	explosion(src.loc, -1, 3, 5, -1)
	qdel(src)

#define TEMPERATURE_DIVISOR 40
#define TEMPERATURE_CHANGE_MAX 20

//A power generator that runs on solid plasma sheets.
/obj/machinery/power/port_gen/pacman
	name = "\improper P.A.C.M.A.N.-type Portable Generator"
	desc = "A power generator that runs on solid plasma sheets. Rated for 80 kW max safe output."

	var/sheet_name = "Plasma Sheets"
	var/sheet_path = /obj/item/stack/material/plasma
	circuit = /obj/item/electronics/circuitboard/pacman

	/*
		These values were chosen so that the generator can run safely up to 80 kW
		A full 50 plasma sheet stack should last 20 minutes at power_output = 4
		temperature_gain and max_temperature are set so that the max safe power level is 4.
		Setting to 5 or higher can only be done temporarily before the generator overheats.
	*/
	power_gen = 20000			//Watts output per power_output level
	var/max_power_output = 5	//The maximum power setting without emagging.
	var/max_safe_output = 4		// For UI use, maximal output that won't cause overheat.
	var/time_per_fuel_unit = 96		//fuel efficiency - how long 1 unit of sheet/reagent lasts at power level 1
	var/max_fuel_volume = 100 		//max capacity of the hopper
	var/max_temperature = 300	//max temperature before overheating increases
	var/temperature_gain = 50	//how much the temperature increases per power output level, in degrees per level

	var/sheets = 0			//How many sheets of material are loaded in the generator
	var/sheet_left = 0		//How much is left of the current sheet
	var/temperature = 0		//The current temperature
	var/overheating = 0		//if this gets high enough the generator explodes

	var/use_reagents_as_fuel = FALSE // designed to work with premade classes, rather than for in-game VV editing.
	var/fuel_name // uses reagent id to get the name
	var/fuel_reagent_id = "fuel"

/obj/machinery/power/port_gen/pacman/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()
	if(use_reagents_as_fuel)
		create_reagents(max_fuel_volume)
		fuel_name = GLOB.chemical_reagents_list[fuel_reagent_id]
		desc = "A power generator that runs on [fuel_name]. Rated for [(power_gen * max_safe_output) / 1000] kW max safe output."

/obj/machinery/power/port_gen/pacman/Destroy()
	DropFuel()
	return ..()

/obj/machinery/power/port_gen/pacman/RefreshParts()
	var/temp_rating = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/matter_bin))
			if(!use_reagents_as_fuel)
				max_fuel_volume = SP.rating * SP.rating * 50
			else
				max_fuel_volume = SP.rating * 300
				create_reagents(max_fuel_volume)
		else if(istype(SP, /obj/item/stock_parts/micro_laser) || istype(SP, /obj/item/stock_parts/capacitor))
			temp_rating += SP.rating

	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/port_gen/pacman/examine(mob/user)
	..(user)
	to_chat(user, "\The [src] appears to be producing [power_gen*power_output] W.")
	if(!use_reagents_as_fuel)
		to_chat(user, "There [sheets == 1 ? "is" : "are"] [sheets] sheet\s left in the hopper.")

	if(IsBroken())
		to_chat(user, SPAN_WARNING("\The [src] seems to have broken down."))
	if(overheating)
		to_chat(user, SPAN_DANGER("\The [src] is overheating!"))

/obj/machinery/power/port_gen/pacman/HasFuel()
	var/needed_fuel = power_output / time_per_fuel_unit
	if(!use_reagents_as_fuel)
		if(sheets >= needed_fuel - sheet_left)
			return TRUE
	else
		if(reagents.has_reagent(fuel_reagent_id, needed_fuel))
			return TRUE
	return FALSE

//Removes one stack's worth of material or purge all reagents from the generator.
/obj/machinery/power/port_gen/pacman/DropFuel()
	if(sheets)
		var/obj/item/stack/material/S = new sheet_path(loc)
		var/amount = min(sheets, S.max_amount)
		S.amount = amount
		sheets -= amount
	if(use_reagents_as_fuel)
		reagents.clear_reagents()

/obj/machinery/power/port_gen/pacman/UseFuel()

	//how much material are we using this iteration?
	var/needed_fuel = power_output / time_per_fuel_unit
	if(!use_reagents_as_fuel)
		//HasFuel() should guarantee us that there is enough fuel left, so no need to check that
		//the only thing we need to worry about is if we are going to rollover to the next sheet
		if (needed_fuel > sheet_left)
			sheets--
			sheet_left = (1 + sheet_left) - needed_fuel
		else
			sheet_left -= needed_fuel
	else
		reagents.remove_reagent(fuel_reagent_id, needed_fuel)

	//calculate the "target" temperature range
	//This should probably depend on the external temperature somehow, but whatever.
	var/lower_limit = 56 + power_output * temperature_gain
	var/upper_limit = 76 + power_output * temperature_gain

	/*
		Hot or cold environments can affect the equilibrium temperature
		The lower the pressure the less effect it has. I guess it cools using a radiator or something when in vacuum.
		Gives traitors more opportunities to sabotage the generator or allows enterprising engineers to build additional
		cooling in order to get more power out.
	*/
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio = min(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		lower_limit += ambient*ratio
		upper_limit += ambient*ratio

	var/average = (upper_limit + lower_limit)/2

	//calculate the temperature increase
	var/bias = 0
	if (temperature < lower_limit)
		bias = min(round((average - temperature)/TEMPERATURE_DIVISOR, 1), TEMPERATURE_CHANGE_MAX)
	else if (temperature > upper_limit)
		bias = max(round((temperature - average)/TEMPERATURE_DIVISOR, 1), -TEMPERATURE_CHANGE_MAX)

	//limit temperature increase so that it cannot raise temperature above upper_limit,
	//or if it is already above upper_limit, limit the increase to 0.
	var/inc_limit = max(upper_limit - temperature, 0)
	var/dec_limit = min(temperature - lower_limit, 0)
	temperature += between(dec_limit, rand(-7 + bias, 7 + bias), inc_limit)

	if (temperature > max_temperature)
		overheat()
	else if (overheating > 0)
		overheating--

/obj/machinery/power/port_gen/pacman/handleInactive()
	var/cooling_temperature = 20
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio = min(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		cooling_temperature += ambient*ratio

	if (temperature > cooling_temperature)
		var/temp_loss = (temperature - cooling_temperature)/TEMPERATURE_DIVISOR
		temp_loss = between(2, round(temp_loss, 1), TEMPERATURE_CHANGE_MAX)
		temperature = max(temperature - temp_loss, cooling_temperature)
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
	//1 mol = 10 u? I dunno. 1 mol of carbon is definitely bigger than a pill
	var/plasma = 0
	if(!use_reagents_as_fuel)
		plasma = (sheets+sheet_left)*20
		sheets = 0
		sheet_left = 0
	else
		plasma = reagents.get_reagent_amount(fuel_reagent_id)*20
		reagents.clear_reagents()

	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		environment.adjust_gas_temp("plasma", plasma/10, temperature + T0C)

	..()

/obj/machinery/power/port_gen/pacman/emag_act(var/remaining_charges, var/mob/user)
	if (active && prob(25))
		explode() //if they're foolish enough to emag while it's running

	if (!emagged)
		emagged = 1
		return 1

/obj/machinery/power/port_gen/pacman/attackby(var/obj/item/I, var/mob/user)

	if(!use_reagents_as_fuel && istype(I, sheet_path))
		var/obj/item/stack/addstack = I
		var/amount = min((max_fuel_volume - sheets), addstack.amount)
		if(amount < 1)
			to_chat(user, "\blue The [src.name] is full!")
			return
		to_chat(user, "\blue You add [amount] sheet\s to the [src.name].")
		sheets += amount
		addstack.use(amount)
		updateUsrDialog()
		return

	if(active)
		to_chat(user, SPAN_NOTICE("You can't work with [src] while its running!"))

	else

		var/list/usable_qualities = list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING)
		if(open)
			usable_qualities.Add(QUALITY_PRYING)

		var/tool_type = I.get_tool_type(user, usable_qualities, src)
		switch(tool_type)

			if(QUALITY_PRYING)
				if(open)
					if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
						var/obj/machinery/constructable_frame/machine_frame/new_frame = new /obj/machinery/constructable_frame/machine_frame(src.loc)
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
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					open = !open
					to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] the maintenance hatch of \the [src] with [I]."))
					update_icon()
					return
				return

			if(QUALITY_BOLT_TURNING)
				if(istype(get_turf(src), /turf/space) && !anchored)
					to_chat(user, SPAN_NOTICE("You can't anchor something to empty space. Idiot."))
					return
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]anchor the brace with [I]."))
					anchored = !anchored
					if(anchored)
						connect_to_network()
					else
						disconnect_from_network()

			if(ABORT_CHECK)
				return

/obj/machinery/power/port_gen/pacman/attack_hand(mob/user)
	..()
	if (!anchored)
		return
	ui_interact(user)

/obj/machinery/power/port_gen/pacman/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	if(IsBroken())
		return

	var/data[0]
	data["active"] = active

	if(isAI(user))
		data["is_ai"] = 1
	else if(isrobot(user) && !Adjacent(user))
		data["is_ai"] = 1
	else
		data["is_ai"] = 0

	data["output_set"] = power_output
	data["output_max"] = max_power_output
	data["output_safe"] = max_safe_output
	data["output_watts"] = power_output * power_gen
	data["temperature_current"] = src.temperature
	data["temperature_max"] = src.max_temperature
	data["temperature_overheat"] = overheating
	// 1 sheet = 1000cm3?
	data["fuel_stored"] = !use_reagents_as_fuel ?  round((sheets * 1000) + (sheet_left * 1000)) : round(reagents.total_volume * 1000, 0.1)
	data["fuel_capacity"] = round(max_fuel_volume * 1000, 0.1)
	data["fuel_usage"] = active ? round((power_output / time_per_fuel_unit) * 1000) : 0
	data["fuel_type"] = !use_reagents_as_fuel ? sheet_name : fuel_name
	data["fuel_units"] = "sheets"
	data["fuel_ejectable"] = TRUE

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "pacman.tmpl", src.name, 500, 560)
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

	var/dat = text("<b>[name]</b><br>")
	if (active)
		dat += text("Generator: <A href='?src=\ref[src];action=disable'>On</A><br>")
	else
		dat += text("Generator: <A href='?src=\ref[src];action=enable'>Off</A><br>")
	dat += text("[capitalize(sheet_name)]: [sheets] - <A href='?src=\ref[src];action=eject'>Eject</A><br>")
	var/stack_percent = round(sheet_left * 100, 1)
	dat += text("Current stack: [stack_percent]% <br>")
	dat += text("Power output: <A href='?src=\ref[src];action=lower_power'>-</A> [power_gen * power_output] Watts<A href='?src=\ref[src];action=higher_power'>+</A><br>")
	dat += text("Power current: [(powernet == null ? "Unconnected" : "[avail()]")]<br>")

	var/tempstr = "Temperature: [temperature]&deg;C<br>"
	dat += (overheating)? SPAN_DANGER("[tempstr]") : tempstr
	dat += "<br><A href='?src=\ref[src];action=close'>Close</A>"
	user << browse("[dat]", "window=port_gen")
	onclose(user, "port_gen")
*/

/obj/machinery/power/port_gen/pacman/on_update_icon()
	if(active)
		icon_state = "portgen1"
	else
		icon_state = "portgen0"

/obj/machinery/power/port_gen/pacman/Topic(href, href_list)
	if(..())
		return

	if(href_list["action"])
		if(href_list["action"] == "enable")
			if(!active && HasFuel() && !IsBroken())
				active = 1
				update_icon()
		if(href_list["action"] == "disable")
			if (active)
				active = 0
				update_icon()
		if(href_list["action"] == "eject")
			if(!active)
				DropFuel()
		if(href_list["action"] == "lower_power")
			if (power_output > 1)
				power_output--
		if (href_list["action"] == "higher_power")
			if (power_output < max_power_output || (emagged && power_output < round(max_power_output*2.5)))
				power_output++

/obj/machinery/power/port_gen/pacman/super
	name = "S.U.P.E.R.P.A.C.M.A.N.-type Portable Generator"
	desc = "A power generator that utilizes uranium sheets as fuel. Can run for much longer than the standard PACMAN type generators. Rated for 80 kW max safe output."
	icon_state = "portgen1"
	sheet_path = /obj/item/stack/material/uranium
	sheet_name = "Uranium Sheets"
	time_per_fuel_unit = 576 //same power output, but a 50 sheet stack will last 2 hours at max safe power
	circuit = /obj/item/electronics/circuitboard/pacman/super

/obj/machinery/power/port_gen/pacman/super/UseFuel()
	//produces a tiny amount of radiation when in use
	if (prob(2*power_output))
		for (var/mob/living/L in range(src, 5))
			L.apply_effect(1, IRRADIATE) //should amount to ~5 rads per minute at max safe power
	..()

/obj/machinery/power/port_gen/pacman/super/explode()
	//a nice burst of radiation
	var/rads = 50 + (sheets + sheet_left)*1.5
	for (var/mob/living/L in range(src, 10))
		//should really fall with the square of the distance, but that makes the rads value drop too fast
		//I dunno, maybe physics works different when you live in 2D -- SM radiation also works like this, apparently
		L.apply_effect(max(20, round(rads/get_dist(L,src))), IRRADIATE)

	explosion(src.loc, 3, 3, 5, 3)
	qdel(src)

/obj/machinery/power/port_gen/pacman/mrs
	name = "M.R.S.P.A.C.M.A.N.-type Portable Generator"
	desc = "An advanced power generator that runs on tritium. Rated for 200 kW maximum safe output!"
	icon_state = "portgen2"
	sheet_path = /obj/item/stack/material/tritium
	sheet_name = "Tritium Fuel Sheets"

	//I don't think tritium has any other use, so we might as well make this rewarding for players
	//max safe power output (power level = 8) is 200 kW and lasts for 1 hour - 3 or 4 of these could power the station
	power_gen = 25000 //watts
	max_power_output = 10
	max_safe_output = 8
	time_per_fuel_unit = 576
	max_temperature = 800
	temperature_gain = 90
	circuit = /obj/item/electronics/circuitboard/pacman/mrs

/obj/machinery/power/port_gen/pacman/mrs/explode()
	//no special effects, but the explosion is pretty big (same as a supermatter shard).
	explosion(src.loc, 3, 6, 12, 16, 1)
	qdel(src)
