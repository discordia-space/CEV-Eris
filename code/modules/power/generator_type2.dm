/obj/machinery/power/generator_type2
	name = "thermoelectric generator"
	desc = "A high-efficiency thermoelectric generator."
	icon_state = "teg"
	anchored = TRUE
	density = TRUE
	use_power =69O_POWER_USE

	var/obj/machinery/atmospherics/unary/generator_input/input1
	var/obj/machinery/atmospherics/unary/generator_input/input2

	var/lastgen = 0
	var/lastgenlev = -1


/obj/machinery/power/generator_type2/New()
	..()
	spawn(5)
		input1 = locate(/obj/machinery/atmospherics/unary/generator_input) in get_step(src,turn(dir, 90))
		input2 = locate(/obj/machinery/atmospherics/unary/generator_input) in get_step(src,turn(dir, -90))
		if(!input1 || !input2)
			stat |= BROKEN
		updateicon()


/obj/machinery/power/generator_type2/proc/updateicon()

	if(stat & (NOPOWER|BROKEN))
		overlays.Cut()
	else
		overlays.Cut()

		if(lastgenlev != 0)
			overlays += image('icons/obj/power.dmi', "teg-op69lastgenlev69")

#define GENRATE 800		// generator output coefficient from Q


/obj/machinery/power/generator_type2/Process()
	if(!input1 || !input2)
		return

	var/datum/gas_mixture/air1 = input1.return_exchange_air()
	var/datum/gas_mixture/air2 = input2.return_exchange_air()


	lastgen = 0

	if(air1 && air2)
		var/datum/gas_mixture/hot_air = air1
		var/datum/gas_mixture/cold_air = air2
		if(hot_air.temperature < cold_air.temperature)
			hot_air = air2
			cold_air = air1

		var/hot_air_heat_capacity = hot_air.heat_capacity()
		var/cold_air_heat_capacity = cold_air.heat_capacity()

		var/delta_temperature = hot_air.temperature - cold_air.temperature

		if(delta_temperature > 1 && cold_air_heat_capacity > 0.01 && hot_air_heat_capacity > 0.01)
			var/efficiency = (1 - cold_air.temperature/hot_air.temperature)*0.65 //65% of Carnot efficiency

			var/energy_transfer = delta_temperature*hot_air_heat_capacity*cold_air_heat_capacity/(hot_air_heat_capacity+cold_air_heat_capacity)

			var/heat = energy_transfer*(1-efficiency)
			lastgen = energy_transfer*efficiency

			hot_air.temperature = hot_air.temperature - energy_transfer/hot_air_heat_capacity
			cold_air.temperature = cold_air.temperature + heat/cold_air_heat_capacity

			//world << "POWER: 69lastgen69 W generated at 69efficiency*10069% efficiency and sinks sizes 69cold_air_heat_capacity69, 69hot_air_heat_capacity69"

			if(input1.network)
				input1.network.update = 1

			if(input2.network)
				input2.network.update = 1

			add_avail(lastgen)
	// update icon overlays only if displayed level has changed

	var/genlev =69ax(0,69in( round(11*lastgen / 100000), 11))
	if(genlev != lastgenlev)
		lastgenlev = genlev
		updateicon()

	src.updateDialog()


/obj/machinery/power/generator_type2/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER)) return
	interact(user)


/obj/machinery/power/generator_type2/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) && (!isAI(user)))
		user.unset_machine()
		user << browse(null, "window=teg")
		return

	user.set_machine(src)

	var/t = "<PRE><B>Thermo-Electric Generator</B><HR>"

	t += "Output : 69round(lastgen)69 W<BR><BR>"

	t += "<B>Cold loop</B><BR>"
	t += "Temperature: 69round(input1.air_contents.temperature, 0.1)69 K<BR>"
	t += "Pressure: 69round(input1.air_contents.return_pressure(), 0.1)69 kPa<BR>"

	t += "<B>Hot loop</B><BR>"
	t += "Temperature: 69round(input2.air_contents.temperature, 0.1)69 K<BR>"
	t += "Pressure: 69round(input2.air_contents.return_pressure(), 0.1)69 kPa<BR>"

	t += "<BR><HR><A href='?src=\ref69src69;close=1'>Close</A>"

	t += "</PRE>"
	user << browse(t, "window=teg;size=460x300")
	onclose(user, "teg")
	return 1


/obj/machinery/power/generator_type2/Topic(href, href_list)
	..()

	if( href_list69"close"69 )
		usr << browse(null, "window=teg")
		usr.unset_machine()
		return 0

	return 1


/obj/machinery/power/generator_type2/power_change()
	..()
	updateicon()