/obj/machinery/portable_atmospherics/powered/scrubber
	name = "portable air scrubber"
	icon_state = "pscrubber:0"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL
	volume = 1000

	///Is the machine on?
	var/on = FALSE
	///the rate the machine will scrub air
	var/volume_rate = 1000
	///Multiplier with ONE_ATMOSPHERE, if the enviroment pressure is higher than that, the scrubber won't work
	var/overpressure_m = 80

	power_rating = 7500 //7500 W ~ 10 HP
	power_losses = 150

	var/minrate = 0
	var/maxrate = 10 * ONE_ATMOSPHERE

	var/list/scrubbing_gas = list("plasma", "carbon_dioxide", "sleeping_agent")

/obj/machinery/portable_atmospherics/powered/scrubber/Destroy() // boom
	var/turf/T = get_turf(src)
	T.assume_air(air_contents)
	return ..()

/obj/machinery/portable_atmospherics/powered/scrubber/Initialize()
	. = ..()
	cell = new /obj/item/weapon/cell/medium/high(src)

/obj/machinery/portable_atmospherics/powered/scrubber/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(prob(50/severity))
		on = !on
		update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/powered/scrubber/on_update_icon()
	src.set_overlays(0)

	icon_state = "pscrubber:[on]"

	if(holding)
		add_overlays("scrubber-open")

	if(connected_port)
		add_overlays("scrubber-connector")

	return

/obj/machinery/portable_atmospherics/powered/scrubber/process_atmos()
	if(!on || !cell || (cell && !cell.charge))
		return ..()

	excited = TRUE

	var/power_draw = -1
	var/atom/target = holding || get_turf(src)

	if(air_contents.return_pressure() >= overpressure_m * ONE_ATMOSPHERE)
		return
	var/datum/gas_mixture/mixture = target.return_air()
	var/transfer_moles = min(1, volume_rate / mixture.volume) * mixture.total_moles

	power_draw = scrub_gas(src, scrubbing_gas, mixture, air_contents, transfer_moles, power_rating)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		power_draw = max(power_draw, power_losses)
		cell.use(power_draw * CELLRATE)
		last_power_draw = power_draw

		// update_connected_network()

	//ran out of charge
	if (!cell.charge)
		power_change()
		update_icon()

	return ..()

/obj/machinery/portable_atmospherics/powered/scrubber/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableScrubber", name)
		ui.open()

/obj/machinery/portable_atmospherics/powered/scrubber/ui_data()
	var/data = list()
	data["on"] = on
	data["connected"] = connected_port ? 1 : 0
	data["pressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["power_draw"] = round(last_power_draw)
	data["cell_charge"] = cell ? cell.charge : 0
	data["cell_max_charge"] = cell ? cell.maxcharge : 1

	data["id_tag"] = -1 //must be defined in order to reuse code between portable and vent scrubbers
	data["filter_types"] = list() // iirc it's not configurable, dumb and bad!
	// for(var/path in GLOB.meta_gas_info)
	// 	var/list/gas = GLOB.meta_gas_info[path]
	// 	data["filter_types"] += list(list("gas_id" = gas[META_GAS_ID], "gas_name" = gas[META_GAS_NAME], "enabled" = (path in scrubbing)))

	if(holding)
		data["holding"] = list()
		data["holding"]["name"] = holding.name
		var/datum/gas_mixture/holding_mix = holding.return_air()
		data["holding"]["pressure"] = round(holding_mix.return_pressure())
	else
		data["holding"] = null
	return data

/obj/machinery/portable_atmospherics/powered/scrubber/replace_tank(mob/living/user, close_valve)
	. = ..()
	if(!.)
		return
	if(close_valve)
		if(on)
			on = FALSE
			update_icon()
	else if(on && holding)
		investigate_log("[key_name(user)] started a transfer into [holding].", INVESTIGATE_ATMOS)

/obj/machinery/portable_atmospherics/powered/scrubber/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			on = !on
			if(on)
				SSair.start_processing_machine(src)
			. = TRUE
		if("eject")
			if(holding)
				replace_tank(usr, FALSE)
				. = TRUE
		// if("toggle_filter")
		// 	scrubbing ^= gas_id2path(params["val"])
		// 	. = TRUE
	update_icon()

//Huge scrubber
/obj/machinery/portable_atmospherics/powered/scrubber/huge
	name = "huge air scrubber"
	icon_state = "scrubber:0"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 500		//internal circuitry, friction losses and stuff
	active_power_usage = 100000	//100 kW ~ 135 HP

	overpressure_m = 200
	volume = 50000
	volume_rate = 5000

	var/global/gid = 1
	var/id = 0

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Initialize()
	. = ..()
	cell = null

	id = gid
	gid++

	name = "[name] (ID [id])"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attack_hand(mob/user)
	to_chat(usr, SPAN_NOTICE("You can't directly interact with this machine. Use the scrubber control console."))
	return TRUE // cancel attack chain

/obj/machinery/portable_atmospherics/powered/scrubber/huge/on_update_icon()
	src.set_overlays(0)

	if(on && !(stat & (NOPOWER|BROKEN)))
		icon_state = "scrubber:1"
	else
		icon_state = "scrubber:0"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/power_change()
	var/old_stat = stat
	..()
	if (old_stat != stat)
		update_icon()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/Process()
	if(!on || (stat & (NOPOWER|BROKEN)))
		update_use_power(0)
		last_flow_rate = 0
		last_power_draw = 0
		return 0

	var/power_draw = -1

	var/datum/gas_mixture/environment = loc.return_air()

	var/transfer_moles = min(1, volume_rate/environment.volume)*environment.total_moles

	power_draw = scrub_gas(src, scrubbing_gas, environment, air_contents, transfer_moles, active_power_usage)

	if (power_draw < 0)
		last_flow_rate = 0
		last_power_draw = 0
	else
		use_power(power_draw)
		update_connected_network()

/obj/machinery/portable_atmospherics/powered/scrubber/huge/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(on)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")

		return

	//doesn't use power cells
	if(istype(I, /obj/item/weapon/cell/large))
		return
	if (istype(I, /obj/item/weapon/tool/screwdriver))
		return

	//doesn't hold tanks
	if(istype(I, /obj/item/weapon/tank))
		return

	return


/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary
	name = "Stationary Air Scrubber"

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/attackby(var/obj/item/I as obj, var/mob/user as mob)
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		to_chat(user, SPAN_WARNING("The bolts are too tight for you to unscrew!"))
		return

	..()
