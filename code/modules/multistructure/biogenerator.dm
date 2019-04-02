//TODO
//End up the ui
//Add activation/deactivation litanies
//Tinker all that shit and make sure that everything works fine
//Handle deconstruction sheit


/datum/multistructure/biogenerator
	structure = list(
		list(/obj/machinery/multistructure/biogenerator_part/generator, /obj/machinery/multistructure/biogenerator_part/console, /obj/machinery/multistructure/biogenerator_part/port)
					)
	var/obj/machinery/multistructure/biogenerator_part/console/screen
	var/obj/machinery/multistructure/biogenerator_part/port/port
	var/obj/machinery/multistructure/biogenerator_part/generator/generator

	var/working = TRUE
	var/last_output_power = 0


/datum/multistructure/biogenerator/init()
	..()
	START_PROCESSING(SSprocessing, src)


/datum/multistructure/biogenerator/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()


/datum/multistructure/biogenerator/connect_elements()
	..()
	screen 		= locate() in elements
	port 		= locate() in elements
	generator	= locate() in elements


/datum/multistructure/biogenerator/is_operational()
	. = ..()
	if(!.)
		world << "fuck"
		return FALSE

	if(!working)
		return FALSE

	if(!generator.core || !generator.chamber)
		return FALSE
	if(!generator.core.coil || !generator.core.coil_condition || !generator.chamber.wires || !generator.chamber.wires_integrity)
		return FALSE

	if(port.pipes_dirtiness == 5)
		return FALSE

	return TRUE


/datum/multistructure/biogenerator/Process()
	if(is_operational() && generator.chamber.network1 && generator.chamber.network2)
		if(port.tank)
			var/biomatter_amount = 1/max(1, port.pipes_dirtiness)
			if(port.tank.reagents.remove_reagent("biomatter", biomatter_amount))
				generator.chamber.consume_and_produce()
				var/output_power = 100000

				//port wearout
				port.working_cycles++
				if(port.working_cycles >= port.wearout_cycle)
					if(prob(50))
						port.pipes_dirtiness++

				//chamber wearout
				generator.chamber.working_cycles++
				if(generator.chamber.working_cycles >= generator.chamber.wearout_cycle)
					generator.chamber.wires_integrity--

				//core wearout
				//casual heating
				generator.core.coil_temperature += 1
				if(generator.core.coil_temperature >= generator.core.coil_critical_temperature)
					generator.core.coil_condition--
					if(generator.core.coil_condition == 0)
						generator.core.coil.name = "burnt [generator.core.coil.name]"
						generator.core.coil.ChargeCapacity = 0
						generator.core.coil.IOCapacity = 0


				var/chamber_contribution = (output_power/2) / 100 * generator.chamber.wires_integrity
				var/core_contribution = (output_power/2) / 100 * generator.core.coil_condition
				output_power = (chamber_contribution + core_contribution) * biomatter_amount
				generator.core.add_avail(output_power)
				last_output_power = output_power
				world << "current output: [output_power]"
				screen.metrics_update(src)
				activate()
	else
		//casual cooling
		if(generator && generator.core.coil && generator.core.coil_temperature > T0C+30)
			generator.core.coil_temperature--
		deactivate()
		screen.metrics_update(src)


/datum/multistructure/biogenerator/proc/activate()
	generator.icon_state 		= "generator-working"
	generator.core.icon_state 	= "core-working"
	port.icon_state 			= "port-working"
	working = TRUE


/datum/multistructure/biogenerator/proc/deactivate()
	generator.icon_state 		= initial(generator.icon_state)
	generator.core.icon_state 	= initial(generator.core.icon_state)
	port.icon_state 			= initial(port.icon_state)
	working = FALSE


/obj/machinery/multistructure/biogenerator_part
	name = "biogenerator part"
	icon = 'icons/obj/machines/biogenerator.dmi'
	anchored = TRUE
	density = TRUE
	MS_type = /datum/multistructure/biogenerator



//console
/obj/machinery/multistructure/biogenerator_part/console
	name = "biogenerator screen"
	icon_state = "screen-working"

	var/list/metrics = list("operational" = FALSE,
							"output_power" = 0,
							"O2_input" = FALSE,
							"CO2_output" = FALSE,
							"tank" = FALSE,
							"tank_bio_amount" = 0,
							"pipes_condition" = 0,
							"coil" = FALSE,
							"coil_condition" = 0,
							"coil_temperature" = 0,
							"wires" = FALSE,
							"wires_integrity" = 0)


/obj/machinery/multistructure/biogenerator_part/console/proc/metrics_update(var/datum/multistructure/biogenerator/master)
	metrics["operational"] = master.is_operational()
	metrics["output_power"] = master.last_output_power
	if(master.generator && master.generator.chamber && master.generator.chamber.air1 && master.generator.chamber.network1)
		metrics["O2_input"] = TRUE
	else
		metrics["O2_input"] = FALSE
	if(master.generator && master.generator.chamber && master.generator.chamber.air2 && master.generator.chamber.network2)
		metrics["CO2_output"] = TRUE
	else
		metrics["CO2_output"] = FALSE
	if(master.port)
		if(master.port.tank)
			metrics["tank"] = TRUE
			metrics["tank_bio_amount"] = master.port.tank.reagents.get_reagent_amount("biomatter")
		else
			metrics["tank"] = FALSE
		metrics["pipes_condition"] = master.port.pipes_dirtiness
	if(master.generator && master.generator.core)
		if(master.generator.core.coil)
			metrics["coil"] = TRUE
			metrics["coil_condition"] = master.generator.core.coil_condition
			if(master.generator.core.coil_temperature >= master.generator.core.coil_critical_temperature)
				metrics["coil_temperature"] = "CRITICAL"
			else
				metrics["coil_temperature"] = master.generator.core.coil_temperature - T0C
		else
			metrics["coil"] = FALSE
	if(master.generator && master.generator.chamber)
		if(master.generator.chamber.wires)
			metrics["wires"] = TRUE
			metrics["wires_integrity"] = master.generator.chamber.wires_integrity
		else
			metrics["wires"] = FALSE


/obj/machinery/multistructure/biogenerator_part/console/attack_hand(mob/user as mob)
	return ui_interact(user)

//UI
/obj/machinery/multistructure/biogenerator_part/console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = metrics


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nt_biogen.tmpl", src.name, 400, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)




//port
/obj/machinery/multistructure/biogenerator_part/port
	name = "biogenerator port"
	icon_state = "port"
	density = FALSE
	var/obj/structure/reagent_dispensers/tank
	var/working_cycles = 0
	var/wearout_cycle = 30
	var/pipes_dirtiness = 0
	var/cover_closed = TRUE


/obj/machinery/multistructure/biogenerator_part/port/update_icon()
	overlays.Cut()
	if(!cover_closed)
		overlays += "port-opened"
		if(pipes_dirtiness)
			if(pipes_dirtiness == 1)
				overlays += "port_dirty_low"
			else if(pipes_dirtiness <= 3)
				overlays += "port_dirty_medium"
			else
				overlays += "port_dirty_full"




/obj/machinery/multistructure/biogenerator_part/port/attackby(var/obj/item/I, var/mob/user)
	var/tool_type = I.get_tool_type(user, list(QUALITY_BOLT_TURNING, QUALITY_SCREW_DRIVING), src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING)
			if(!cover_closed)
				to_chat(user, SPAN_WARNING("Cover is not closed. You should close it first."))
				return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				if(tank)
					tank.anchored = FALSE
					tank = null
					playsound(src, 'sound/machines/airlock_ext_open.ogg', 60, 1)
					to_chat(user, SPAN_NOTICE("You attached [tank] to [src]."))
				else
					tank = locate(/obj/structure/reagent_dispensers) in get_turf(src)
					if(tank)
						tank.anchored = TRUE
						playsound(src, 'sound/machines/airlock_ext_close.ogg', 60, 1)
						to_chat(user, SPAN_NOTICE("You detached [tank] from [src]."))

		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				playsound(src, WORKSOUND_SCREW_DRIVING, 60, 1)
				cover_closed = !cover_closed
				to_chat(user, SPAN_NOTICE("You [cover_closed ? "open" : "close"] the panel."))

	if(!cover_closed && (istype(I, /obj/item/weapon/soap) || istype(I, /obj/item/weapon/reagent_containers/glass/rag)))
		if(pipes_dirtiness)
			pipes_dirtiness--
			if(pipes_dirtiness < 0)
				pipes_dirtiness = 0
			to_chat(user, SPAN_NOTICE("You clean the pipes a bit."))
			if(!pipes_dirtiness)
				working_cycles = 0
		else
			to_chat(user, SPAN_WARNING("Pipes are already clean."))
	update_icon()



//generator
/obj/machinery/multistructure/biogenerator_part/generator
	name = "generator"
	icon_state = "generator"
	layer = LOW_OBJ_LAYER
	var/obj/machinery/atmospherics/binary/biogen_chamber/chamber
	var/obj/machinery/power/biogenerator_core/core


/obj/machinery/multistructure/biogenerator_part/generator/New()
	. = ..()
	chamber 	= new(loc)
	chamber.generator = src
	core 		= new(loc)
	core.generator = src


/obj/machinery/multistructure/biogenerator_part/generator/Destroy()
	if(chamber)
		qdel(chamber)
	if(core)
		qdel(core)
	return ..()


/obj/machinery/atmospherics/binary/biogen_chamber
	name = "biogenerator chambers"
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "chambers"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/obj/machinery/multistructure/biogenerator_part/generator/generator
	var/working_cycles = 0
	var/wearout_cycle = 40
	var/wires_integrity = 100
	var/opened = FALSE
	var/wires = TRUE


/obj/machinery/atmospherics/binary/biogen_chamber/Destroy()
	if(generator)
		generator.chamber = null
		generator = null
	return ..()


/obj/machinery/atmospherics/binary/biogen_chamber/update_icon()
	if(opened)
		if(wires)
			icon_state = "chambers-wires"
		else
			icon_state = "chambers-wireless"
	else
		icon_state = initial(icon_state)


/obj/machinery/atmospherics/binary/biogen_chamber/attackby(var/obj/item/I, var/mob/user)
	var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING, QUALITY_WIRE_CUTTING), src)
	switch(tool_type)
		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				playsound(src, WORKSOUND_SCREW_DRIVING, 60, 1)
				opened = !opened
				to_chat(user, SPAN_NOTICE("You [opened ? "open" : "close"] the cover."))

		if(QUALITY_WIRE_CUTTING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				if(opened)
					if(wires)
						playsound(src, WORKSOUND_WIRECUTTING, 60, 1)
						wires = FALSE
						to_chat(user, SPAN_NOTICE("You cut old wires."))
					else
						to_chat(user, SPAN_WARNING("There are no wires here."))
				else
					to_chat(user, SPAN_WARNING("You need open cover first."))

	if(istype(I, /obj/item/stack/cable_coil))
		if(!opened)
			to_chat(user, SPAN_WARNING("Cover is closed."))
			return
		if(wires)
			to_chat(user, SPAN_WARNING("You need cut old wires first."))
			return
		var/obj/item/stack/cable_coil/cables = I
		if(cables.use(10))
			wires_integrity = 100
			working_cycles = 0
			wires = TRUE
		else
			to_chat(user, SPAN_WARNING("Not enough cables."))
	update_icon()


/obj/machinery/atmospherics/binary/biogen_chamber/proc/consume_and_produce()
	var/gas_output_temperature = 0
	var/core_temperature = generator.core.coil_temperature - T0C
	if(air1 && air2)
		if(air1.gas["oxygen"])
			air1.gas["oxygen"] -= 1
			gas_output_temperature = air1.temperature + rand(20, 30) + core_temperature
			air1.update_values()
			air2.adjust_gas_temp("carbon_dioxide", 1, gas_output_temperature)
			network1.update = TRUE
			network2.update = TRUE


/obj/machinery/power/biogenerator_core
	name = "biogenerator core"
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "core"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/obj/machinery/multistructure/biogenerator_part/generator/generator
	var/coil_condition = 100
	var/coil_temperature = T0C + 30
	var/coil_critical_temperature = T0C + 300
	var/obj/item/weapon/smes_coil/coil
	var/coil_frame = TRUE
	var/coil_bolts = TRUE


/obj/machinery/power/biogenerator_core/Initialize()
	. = ..()
	coil = new(src)


/obj/machinery/power/biogenerator_core/Destroy()
	if(generator)
		generator.core = null
		generator = null
	return ..()


/obj/machinery/power/biogenerator_core/update_icon()
	if(!coil)
		icon_state = "core-coilless"
		return
	if(!coil_bolts)
		icon_state = "core-boltless"
		return
	if(!coil_frame)
		icon_state = "core-frameless"
		return
	icon_state = initial(icon_state)


/obj/machinery/power/biogenerator_core/attackby(var/obj/item/I, var/mob/user)
	if(generator.MS.is_operational())
		shock(user)
		return

	var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING, QUALITY_BOLT_TURNING), src)
	switch(tool_type)
		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				playsound(src, WORKSOUND_SCREW_DRIVING, 60, 1)
				if(coil_frame)
					coil_frame = FALSE
					to_chat(user, SPAN_NOTICE("You carefully screw out the frame mechanism of [src]."))
				else
					if(!coil_bolts)
						to_chat(user, SPAN_WARNING("You need to tighten the bolts first!"))
						return
					coil_frame = TRUE
					to_chat(user, SPAN_NOTICE("You screw frame mechanism of [src] back."))

		if(QUALITY_BOLT_TURNING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				if(coil_frame)
					to_chat(user, SPAN_WARNING("You need to screw the frame first!"))
					return
				if(!coil)
					to_chat(user, SPAN_WARNING("You need to insert coil first."))
					return
				playsound(src, WORKSOUND_WRENCHING, 60, 1)
				if(coil_bolts)
					coil_bolts = FALSE
					to_chat(user, SPAN_NOTICE("You unscrew the coil holder bolts of [src]."))
				else
					coil_bolts = TRUE
					to_chat(user, SPAN_NOTICE("You tighten the bolts of coil holder back."))

	if(!coil && istype(I, /obj/item/weapon/smes_coil))
		if(!coil_frame && !coil_bolts)
			user.drop_from_inventory(I, src)
			coil = I
			if(coil.ChargeCapacity && coil.IOCapacity)
				coil_temperature = T0C + 30
				coil_condition = 100
			to_chat(user, SPAN_NOTICE("You insert [I] into [src]'s coil holder."))
			playsound(src, 'sound/items/Deconstruct.ogg', 70, 1)
	update_icon()


/obj/machinery/power/biogenerator_core/attack_hand(mob/user as mob)
	if(generator.MS.is_operational())
		shock(user)
		return
	if(!coil_frame && !coil_bolts && coil)
		to_chat(user, SPAN_NOTICE("You carefully take [coil] from [src]."))
		user.put_in_active_hand(coil)
		coil = null
		update_icon()
