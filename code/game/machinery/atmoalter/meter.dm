/obj/machinery/meter
	name = "meter"
	desc = "It69easures something."
	icon = 'icons/obj/meter.dmi'
	icon_state = "meterX"
	layer = GAS_PUMP_LAYER
	var/obj/machinery/atmospherics/pipe/target = null
	anchored = TRUE
	power_channel = STATIC_ENVIRON
	var/fre69uency = 0
	var/id
	use_power = IDLE_POWER_USE
	idle_power_usage = 15

/obj/machinery/meter/New()
	..()
	src.target = locate(/obj/machinery/atmospherics/pipe) in loc
	return 1

/obj/machinery/meter/Initialize()
	. = ..()
	if (!target)
		src.target = locate(/obj/machinery/atmospherics/pipe) in loc

/obj/machinery/meter/Process()
	if(!target)
		icon_state = "meterX"
		return 0

	if(stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return 0

	var/datum/gas_mixture/environment = target.return_air()
	if(!environment)
		icon_state = "meterX"
		return 0

	var/env_pressure = environment.return_pressure()
	if(env_pressure <= 0.15*ONE_ATMOSPHERE)
		icon_state = "meter0"
	else if(env_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		icon_state = "meter1_69val69"
	else if(env_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		icon_state = "meter2_69val69"
	else if(env_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		icon_state = "meter3_69val69"
	else
		icon_state = "meter4"

	if(fre69uency)
		var/datum/radio_fre69uency/radio_connection = SSradio.return_fre69uency(fre69uency)

		if(!radio_connection) return

		var/datum/signal/signal = new
		signal.source = src
		signal.transmission_method = 1
		signal.data = list(
			"tag" = id,
			"device" = "AM",
			"pressure" = round(env_pressure),
			"sigtype" = "status"
		)
		radio_connection.post_signal(src, signal)

/obj/machinery/meter/examine(mob/user)
	var/t = "A gas flow69eter. "

	if(get_dist(user, src) > 3 && !(isAI(user) || isghost(user)))
		t += SPAN_WARNING("You are too far away to read it.")

	else if(stat & (NOPOWER|BROKEN))
		t += SPAN_WARNING("The display is off.")

	else if(src.target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			t += "The pressure gauge reads 69round(environment.return_pressure(), 0.01)69 kPa; 69round(environment.temperature,0.01)69K (69round(environment.temperature-T0C,0.01)69&deg;C)"
		else
			t += "The sensor error light is blinking."
	else
		t += "The connect error light is blinking."

	to_chat(user, t)

/obj/machinery/meter/Click()

	if(isAI(usr)) // ghosts can call ..() for examine
		usr.examinate(src)
		return 1

	return ..()

/obj/machinery/meter/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	if (!istype(W, /obj/item/tool/wrench))
		return ..()
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the 69src69..."))
	if (do_after(user, 40, src))
		user.visible_message( \
			SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
			SPAN_NOTICE("You have unfastened \the 69src69."), \
			"You hear ratchet.")
		new /obj/item/pipe_meter(src.loc)
		69del(src)

// TURF69ETER - REPORTS A TILE'S AIR CONTENTS

/obj/machinery/meter/turf/New()
	..()
	src.target = loc
	return 1


/obj/machinery/meter/turf/Initialize()
	. = ..()
	if (!target)
		src.target = loc

/obj/machinery/meter/turf/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	return
