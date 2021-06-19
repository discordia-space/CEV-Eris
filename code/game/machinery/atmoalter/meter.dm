/obj/machinery/meter
	name = "gas flow meter"
	desc = "It measures something."
	icon = 'icons/obj/meter.dmi'
	icon_state = "meterX"
	layer = GAS_PUMP_LAYER
	power_channel = ENVIRON
	use_power = IDLE_POWER_USE
	idle_power_usage = 15
	anchored = TRUE
	var/frequency = 0
	var/id
	var/obj/machinery/atmospherics/pipe/target = null

/obj/machinery/meter/Initialize(mapload, new_piping_layer)
	// if(!isnull(new_piping_layer))
	// 	target_layer = new_piping_layer
	// SSair.start_processing_machine(src)
	if(!target)
		target = locate(/obj/machinery/atmospherics/pipe) in loc
		// reattach_to_layer()
	return ..()

/obj/machinery/meter/process() //process_atmos()
	if(!(target?.flags_1 & INITIALIZED_1) || !initialized)
		icon_state = "meterX"
		return FALSE

	if(stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return FALSE

	use_power(5)

	var/datum/gas_mixture/environment = target.return_air()
	if(!environment)
		icon_state = "meterX"
		return FALSE

	var/env_pressure = environment.return_pressure()
	if(env_pressure <= 0.15*ONE_ATMOSPHERE)
		icon_state = "meter0"
	else if(env_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		icon_state = "meter1_[val]"
	else if(env_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		icon_state = "meter2_[val]"
	else if(env_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		icon_state = "meter3_[val]"
	else
		icon_state = "meter4"

	if(frequency)
		var/datum/radio_frequency/radio_connection = SSradio.return_frequency(frequency)

		if(!radio_connection)
			return

		var/datum/signal/signal = new
		signal.source = src
		signal.transmission_method = 1
		signal.data = list(
			"id_tag" = id, // future
			"tag" = id,
			"device" = "AM",
			"pressure" = round(env_pressure),
			"sigtype" = "status"
		)
		radio_connection.post_signal(src, signal)

/obj/machinery/meter/proc/status()
	if (target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			. = "The pressure gauge reads [round(environment.return_pressure(), 0.01)] kPa; [round(environment.temperature,0.01)] K ([round(environment.temperature-T0C,0.01)]&deg;C)."
		else
			. = "The sensor error light is blinking."
	else
		. = "The connect error light is blinking."

/obj/machinery/meter/examine(mob/user)
	var/t = "A gas flow meter. "

	if(get_dist(user, src) > 3 && !(isAI(user) || isghost(user)))
		t += SPAN_WARNING("You are too far away to read it.")

	else if(stat & (NOPOWER|BROKEN))
		t += SPAN_WARNING("The display is off.")

	else if(src.target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			t += "The pressure gauge reads [round(environment.return_pressure(), 0.01)] kPa; [round(environment.temperature,0.01)]K ([round(environment.temperature-T0C,0.01)]&deg;C)"
		else
			t += "The sensor error light is blinking."
	else
		t += "The connect error light is blinking."

	to_chat(user, t)

/obj/machinery/meter/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (!istype(W, /obj/item/weapon/tool/wrench))
		return ..()
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if (do_after(user, 40, src))
		user.visible_message(
			"[user] unfastens \the [src].",
			"<span class='notice'>You unfasten \the [src].</span>",
			"<span class='hear'>You hear ratchet.</span>")
		if(!(flags_1 & NODECONSTRUCT_1))
			new /obj/item/pipe_meter(loc)
		qdel(src)

/obj/machinery/meter/interact(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	else
		to_chat(user, status())

// TURF METER - REPORTS A TILE'S AIR CONTENTS
// why are you yelling?
/obj/machinery/meter/turf

/obj/machinery/meter/turf/Initialize()
	. = ..()
	if (!target)
		src.target = loc
