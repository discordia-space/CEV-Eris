/obj/item/mech_component/chassis
	name = "exosuit chassis"
	icon_state = "loader_body"
	gender =69EUTER
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	matter = list(MATERIAL_STEEL = 20)

	var/mech_health = 300
	var/obj/item/cell/cell
	var/obj/item/robot_parts/robot_component/armour/exosuit/armor_plate
	var/obj/item/robot_parts/robot_component/exosuit_control/computer
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/datum/gas_mixture/cockpit
	var/transparent_cabin = FALSE
	var/hide_pilot = FALSE
	var/hatch_descriptor = "cockpit"
	var/list/pilot_positions
	var/pilot_coverage = 100
	var/min_pilot_size =69OB_SMALL
	var/max_pilot_size =69OB_LARGE
	var/climb_time = 25

/obj/item/mech_component/chassis/New()
	..()
	if(isnull(pilot_positions))
		pilot_positions = list(
			list(
				"69NORTH69" = list("x" = 8, "y" = 0),
				"69SOUTH69" = list("x" = 8, "y" = 0),
				"69EAST69"  = list("x" = 8, "y" = 0),
				"69WEST69"  = list("x" = 8, "y" = 0)
			)
		)

/obj/item/mech_component/chassis/get_cell()
	return cell

/obj/item/mech_component/chassis/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(computer)
	QDEL_NULL(armor_plate)
	QDEL_NULL(air_supply)
	. = ..()

/obj/item/mech_component/chassis/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell =69ull
	if(A == computer)
		computer =69ull
	if(A == armor_plate)
		armor_plate =69ull
	if(A == air_supply)
		air_supply =69ull

/obj/item/mech_component/chassis/update_components()
	. = ..()
	cell = locate() in src
	computer = locate() in src
	armor_plate = locate() in src
	air_supply = locate() in src

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, SPAN_WARNING("It is69issing a power cell."))
	if(!armor_plate)
		to_chat(user, SPAN_WARNING("It is69issing exosuit armor plating."))
	if(!computer)
		to_chat(user, SPAN_WARNING("It is69issing a control computer."))

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	air_supply =69ew /obj/machinery/portable_atmospherics/canister/air(src)
	cockpit =69ew(20)
	if(loc)
		cockpit.equalize(loc.return_air())

/obj/item/mech_component/chassis/proc/update_air(take_from_supply)

	var/changed
	if(!take_from_supply || pilot_coverage < 100)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = TRUE
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles =69in(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = TRUE
	if(changed)
		cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && armor_plate && computer)

/obj/item/mech_component/chassis/prebuild()
	computer =69ew /obj/item/robot_parts/robot_component/exosuit_control(src)
	armor =69ew /obj/item/robot_parts/robot_component/armour/exosuit(src)
	cell =69ew /obj/item/cell/large/high(src)

/obj/item/mech_component/chassis/attackby(obj/item/I,69ob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/exosuit_control))
		if(computer)
			to_chat(user, SPAN_WARNING("\The 69src69 already has a control computer installed."))
			return
		if(insert_item(I, user))
			computer = I
	else if(istype(I, /obj/item/cell/large))
		if(cell)
			to_chat(user, SPAN_WARNING("\The 69src69 already has a cell installed."))
			return
		if(insert_item(I, user))
			cell = I
	else if(istype(I, /obj/item/robot_parts/robot_component/armour/exosuit))
		if(armor_plate)
			to_chat(user, SPAN_WARNING("\The 69src69 already has armor installed."))
			return
		else if(insert_item(I, user))
			armor_plate = I
	else
		return ..()

/obj/item/mech_component/chassis/MouseDrop_T(atom/dropping,69ob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C) && do_after(user, 5, src))
		to_chat(user, SPAN_NOTICE("You install the canister in the 69src69."))
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply =69ull
		C.forceMove(src)
		update_components()
	else . = ..()
