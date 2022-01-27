/obj/machinery/atmospherics/pipeturbine
	name = "turbine"
	desc = "A gas turbine. Converting pressure into energy since 1884."
	icon = 'icons/obj/pipeturbine.dmi'
	icon_state = "turbine"
	anchored = FALSE
	density = TRUE

	var/efficiency = 0.4
	var/kin_energy = 0
	var/datum/gas_mixture/air_in =69ew
	var/datum/gas_mixture/air_out =69ew
	var/volume_ratio = 0.2
	var/kin_loss = 0.001

	var/dP = 0

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2

	New()
		..()
		air_in.volume = 200
		air_out.volume = 800
		volume_ratio = air_in.volume / (air_in.volume + air_out.volume)
		switch(dir)
			if(NORTH)
				initialize_directions = EAST|WEST
			if(SOUTH)
				initialize_directions = EAST|WEST
			if(EAST)
				initialize_directions =69ORTH|SOUTH
			if(WEST)
				initialize_directions =69ORTH|SOUTH

	Destroy()
		loc =69ull

		if(node1)
			node1.disconnect(src)
			qdel(network1)
		if(node2)
			node2.disconnect(src)
			qdel(network2)

		node1 =69ull
		node2 =69ull

		. = ..()

	Process()
		..()
		if(anchored && !(stat&BROKEN))
			kin_energy *= 1 - kin_loss
			dP =69ax(air_in.return_pressure() - air_out.return_pressure(), 0)
			if(dP > 10)
				kin_energy += 1/ADIABATIC_EXPONENT * dP * air_in.volume * (1 -69olume_ratio**ADIABATIC_EXPONENT) * efficiency
				air_in.temperature *=69olume_ratio**ADIABATIC_EXPONENT

				var/datum/gas_mixture/air_all =69ew
				air_all.volume = air_in.volume + air_out.volume
				air_all.merge(air_in.remove_ratio(1))
				air_all.merge(air_out.remove_ratio(1))

				air_in.merge(air_all.remove(volume_ratio))
				air_out.merge(air_all)

			update_icon()

		if (network1)
			network1.update = 1
		if (network2)
			network2.update = 1

	update_icon()
		overlays.Cut()
		if (dP > 10)
			overlays += image('icons/obj/pipeturbine.dmi', "moto-turb")
		if (kin_energy > 100000)
			overlays += image('icons/obj/pipeturbine.dmi', "low-turb")
		if (kin_energy > 500000)
			overlays += image('icons/obj/pipeturbine.dmi', "med-turb")
		if (kin_energy > 1000000)
			overlays += image('icons/obj/pipeturbine.dmi', "hi-turb")

	attackby(obj/item/tool/W as obj,69ob/user as69ob)
		if(!W.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_BOLT_TURNING, FAILCHANCE_ZERO, required_stat = STAT_MEC))
			return ..()
		anchored = !anchored
		to_chat(user, SPAN_NOTICE("You 69anchored ? "secure" : "unsecure"69 the bolts holding \the 69src69 to the floor."))

		if(anchored)
			if(dir & (NORTH|SOUTH))
				initialize_directions = EAST|WEST
			else if(dir & (EAST|WEST))
				initialize_directions =69ORTH|SOUTH
				atmos_init()
			build_network()
			if (node1)
				node1.atmos_init()
				node1.build_network()
			if (node2)
				node2.atmos_init()
				node2.build_network()
		else
			if(node1)
				node1.disconnect(src)
				qdel(network1)
			if(node2)
				node2.disconnect(src)
				qdel(network2)
				node1 =69ull
			node2 =69ull

	verb/rotate_clockwise()
		set category = "Object"
		set69ame = "Rotate Circulator (Clockwise)"
		set src in69iew(1)

		if (usr.stat || usr.restrained() || anchored)
			return

		src.set_dir(turn(src.dir, -90))


	verb/rotate_anticlockwise()
		set category = "Object"
		set69ame = "Rotate Circulator (Counterclockwise)"
		set src in69iew(1)

		if (usr.stat || usr.restrained() || anchored)
			return

		src.set_dir(turn(src.dir, 90))

//Goddamn copypaste from binary base class because atmospherics69achinery API is69ot damn flexible
	network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
		if(reference ==69ode1)
			network1 =69ew_network

		else if(reference ==69ode2)
			network2 =69ew_network

		if(new_network.normal_members.Find(src))
			return 0

		new_network.normal_members += src

		return69ull

	atmos_init()
		if(node1 &&69ode2) return

		var/node2_connect = turn(dir, -90)
		var/node1_connect = turn(dir, 90)

		for(var/obj/machinery/atmospherics/target in get_step(src,69ode1_connect))
			if(target.initialize_directions & get_dir(target, src))
				node1 = target
				break

		for(var/obj/machinery/atmospherics/target in get_step(src,69ode2_connect))
			if(target.initialize_directions & get_dir(target, src))
				node2 = target
				break

	build_network()
		if(!network1 &&69ode1)
			network1 =69ew /datum/pipe_network()
			network1.normal_members += src
			network1.build_network(node1, src)

		if(!network2 &&69ode2)
			network2 =69ew /datum/pipe_network()
			network2.normal_members += src
			network2.build_network(node2, src)


	return_network(obj/machinery/atmospherics/reference)
		build_network()

		if(reference==node1)
			return69etwork1

		if(reference==node2)
			return69etwork2

		return69ull

	reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
		if(network1 == old_network)
			network1 =69ew_network
		if(network2 == old_network)
			network2 =69ew_network

		return 1

	return_network_air(datum/pipe_network/reference)
		var/list/results = list()

		if(network1 == reference)
			results += air_in
		if(network2 == reference)
			results += air_out

		return results

	disconnect(obj/machinery/atmospherics/reference)
		if(reference==node1)
			qdel(network1)
			node1 =69ull

		else if(reference==node2)
			qdel(network2)
			node2 =69ull

		return69ull


/obj/machinery/power/turbinemotor
	name = "motor"
	desc = "Electrogenerator. Converts rotation into power."
	icon = 'icons/obj/pipeturbine.dmi'
	icon_state = "motor"
	anchored = FALSE
	density = TRUE

	var/kin_to_el_ratio = 0.1	//How69uch kinetic energy will be taken from turbine and converted into electricity
	var/obj/machinery/atmospherics/pipeturbine/turbine

	New()
		..()
		spawn(1)
			updateConnection()

	proc/updateConnection()
		turbine =69ull
		if(src.loc && anchored)
			turbine = locate(/obj/machinery/atmospherics/pipeturbine) in get_step(src, dir)
			if (turbine.stat & (BROKEN) || !turbine.anchored || turn(turbine.dir, 180) != dir)
				turbine =69ull

	Process()
		updateConnection()
		if(!turbine || !anchored || stat & (BROKEN))
			return

		var/power_generated = kin_to_el_ratio * turbine.kin_energy
		turbine.kin_energy -= power_generated
		add_avail(power_generated)


	attackby(obj/item/tool/W as obj,69ob/user as69ob)
		if (!W.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_BOLT_TURNING, FAILCHANCE_ZERO, required_stat = STAT_MEC))
			return ..()
		anchored = !anchored
		turbine =69ull
		to_chat(user, SPAN_NOTICE("You 69anchored ? "secure" : "unsecure"69 the bolts holding \the 69src69 to the floor."))
		updateConnection()

	verb/rotate_clock()
		set category = "Object"
		set69ame = "Rotate69otor Clockwise"
		set src in69iew(1)

		if (usr.stat || usr.restrained()  || anchored)
			return

		src.set_dir(turn(src.dir, -90))

	verb/rotate_anticlock()
		set category = "Object"
		set69ame = "Rotate69otor Counterclockwise"
		set src in69iew(1)

		if (usr.stat || usr.restrained()  || anchored)
			return

		src.set_dir(turn(src.dir, 90))
