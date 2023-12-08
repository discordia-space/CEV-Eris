/obj/machinery/pulsar //Not meant to be destroyed, snowflake object for control, lots of things hold refs to it so it would harddel
	name = "pulsar starmap"
	icon = 'icons/obj/pulsar_machinery.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	var/obj/effect/pulsar/linked
	var/obj/effect/pulsar_ship/ship
	var/obj/structure/pulsar_fuel_tank/tank
	var/map_active
	var/shield_power = 45
	var/last_light_lvl = 0

/obj/machinery/pulsar/Initialize(mapload, d)
	linked = GLOB.maps_data.pulsar_star
	ship = locate(/obj/effect/pulsar_ship) in get_area(linked)
	if(ship)
		RegisterSignal(ship, COMSIG_MOVABLE_MOVED, .proc/onShipMoved)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/pulsar/LateInitialize()
	scan_for_fuel()
	. = ..()


/obj/machinery/pulsar/relaymove(mob/user, direction)
	if(map_active && linked)
		linked.relaymove(user,direction)
		return TRUE

/obj/machinery/pulsar/Process()
	SSnano.update_uis(src)
	ship.try_overcharge(shield_power < get_required_shielding() ? TRUE : FALSE)

/obj/machinery/pulsar/power_change()
	..()
	SSnano.update_uis(src)


/obj/machinery/pulsar/check_eye(mob/user)
	if(isAI(user))
		user.unset_machine()
		if(map_active)
			user.reset_view(user.eyeobj)
	if(!map_active || (get_dist(user, src) > 1) || user.blinded || !linked )
		user.unset_machine()
		map_active = 0
		return -1

/obj/machinery/pulsar/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		user.unset_machine()
		map_active = 0
		return
	map_active = 1
	if(linked && map_active)
		user.set_machine(src)
		user.reset_view(linked)
		user.client.view = "[GLOB.maps_data.pulsar_size + 1]x[GLOB.maps_data.pulsar_size + 1]"
	nano_ui_interact(user)

/obj/machinery/pulsar/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(stat & (BROKEN|NOPOWER))
		return
	if(user.stat || user.restrained())
		return

	var/list/data = ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "pulsar.tmpl", name, 550, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/pulsar/ui_data()
	var/list/data = list()
	data["power_produced"] = get_produced_power()
	data["ship_fuel"] = round(tank?.air_contents.get_total_moles())
	data["no_tank"] = !tank
	data["thrust_cost"] = get_thrust_cost()
	data["shield_power"] = shield_power
	data["shield_power_req"] = get_required_shielding()
	data["effective_power_produced"] = get_effective_power_porduced()
	data["decay_time"] = ship.decay_timer / (1 MINUTES)

	return data

/obj/machinery/pulsar/Topic(href, href_list)
	if(href_list["move"])
		if(tank)
			var/thrust_cost = get_thrust_cost()
			if(tank.air_contents.get_total_moles() >= thrust_cost)
				tank.air_contents.remove(thrust_cost)
				var/newdir = text2num(href_list["move"])
				ship.try_move(newdir, TRUE)

	else if(href_list["scan_fuel"])
		scan_for_fuel()

	else if(href_list["set_shield"])
		var/target_level = input(usr, "Set shielding power", "Shield control", 50) as num
		if(target_level < 100)
			shield_power = max(0 , target_level)

	SSnano.update_uis(src)
	..()

/obj/machinery/pulsar/proc/get_thrust_cost()
	if(tank?.air_contents.specific_mass())
		return round((1/tank.air_contents.specific_mass()) * 2) //Goes from 4 with 100% plasma up to 40+ when diluting with too much oxygen
	return 100

/obj/machinery/pulsar/proc/get_produced_power() //Simply based on linear distance from the pulsar
	for(var/obj/O in get_turf(ship))
		if(O.type in subtypesof(/obj/effect/pulsar_beam))
			var/power = 150
			check_pulsar_lights(power)
			return power
	var/power = max(0, round(((GLOB.maps_data.pulsar_size * ROOT(2,2)) - 2 * ROOT(2, abs(linked.x - ship.x) ** 2 + abs(linked.y - ship.y) ** 2)) * 100/(GLOB.maps_data.pulsar_size * ROOT(2,2))))
	check_pulsar_lights(power)
	return power

/obj/machinery/pulsar/proc/check_pulsar_lights(power)
	if(get_light_lvl(power) != last_light_lvl)
		last_light_lvl = get_light_lvl(power)
		// SEND_SIGNAL(src, COMSIG_PULSAR_LIGHTS, last_light_lvl)

/obj/machinery/pulsar/proc/get_light_lvl(power)
	return round(power / 20)

/obj/machinery/pulsar/proc/get_required_shielding()
	for(var/obj/O in get_turf(ship))
		if(O.type in subtypesof(/obj/effect/pulsar_beam))
			return 60
	return max(30, 30 + (round(((GLOB.maps_data.pulsar_size * ROOT(2,2)) - 2 * ROOT(2, abs(linked.x - ship.x) ** 2 + abs(linked.y - ship.y) ** 2)) * 100/(GLOB.maps_data.pulsar_size * ROOT(2,2))) / 5))

/obj/machinery/pulsar/proc/get_effective_power_porduced() //Formula comes with deminishing returns but it's rising way past 100, returns precentages
	return get_produced_power() * (100 - shield_power) / 100

/obj/machinery/pulsar/proc/onShipMoved()
	SSnano.update_uis(src)
	ship.decay_timer = max(10, 100 - get_produced_power()) / 100 * ORBIT_DECAY_TIMER

/obj/machinery/pulsar/proc/scan_for_fuel()
	tank = locate(/obj/structure/pulsar_fuel_tank) in get_area(src)
	tank?.connected_console = src
	SSnano.update_uis(src)

/obj/machinery/pulsar/explosion_act(severity)
	return

/obj/machinery/pulsar/proc/set_block_events(state_bool = TRUE){
	if(state_bool){
		ship.block_events = TRUE
		ship.try_overcharge(FALSE)
		ship.stop_rad_storm()
		return
	}
	ship.block_events = FALSE
	ship.try_move(0) //Recalc if the pulsar is in a beam
}

/obj/machinery/power/pulsar_power_bridge //Only holds ref to the console and its area, used to get power from it, or disconnect the ship.
	name = "pulsar power bridge"
	icon = 'icons/obj/pulsar_power_bridge.dmi'
	icon_state = "bridge"
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE
	pixel_x = -10
	circuit = /obj/item/electronics/circuitboard/pulsar_power_bridge
	layer = ABOVE_MOB_LAYER
	var/disconnect_time = -RECONNECT_CD
	var/portal_active = FALSE
	var/obj/machinery/pulsar/pulsar_console
	var/area/console_area
	var/obj/effect/map_effect/simple_portal/portal

/obj/machinery/power/pulsar_power_bridge/Initialize(mapload, d)
	. = ..()
	connect_to_network()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/pulsar_power_bridge/LateInitialize()
	. = ..()
	pulsar_console = locate() in world //I can get away with it once, right?
	if(pulsar_console)
		pulsar_console.set_block_events(FALSE)
		console_area = get_area(pulsar_console) //Area stored so reconnections are cheaper.

	portal = locate() in get_area(src)

/obj/machinery/power/pulsar_power_bridge/Process()
	if(powernet && pulsar_console)
		add_avail(PULSAR_100_POWER * pulsar_console.get_effective_power_porduced() / 100)
	update_icon()

/obj/machinery/power/pulsar_power_bridge/power_change()
	..()
	SSnano.update_uis(src)

/obj/machinery/power/pulsar_power_bridge/attack_hand(mob/user)
	. = ..()
	nano_ui_interact(user)

/obj/machinery/power/pulsar_power_bridge/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	. = ..()
	if(stat & (BROKEN|NOPOWER))
		return
	if(user.stat || user.restrained())
		return

	var/list/data = ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "pulsar_power_bridge.tmpl", name, 550, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/power/pulsar_power_bridge/ui_data()
	var/list/data = list()
	data["pulsar_connected"] = FALSE
	data["portal_active"] = portal_active
	data["reconnect_not_ready"] = world.time > disconnect_time + RECONNECT_CD ? FALSE : TRUE
	if(pulsar_console)
		data["pulsar_connected"] = TRUE
		data["power_percentage"] = pulsar_console.get_effective_power_porduced()
		data["power_produced"] = (PULSAR_100_POWER / 1000000) * pulsar_console.get_effective_power_porduced() / 100

	return data

/obj/machinery/power/pulsar_power_bridge/Topic(href, href_list)
	if(href_list["disconnect"])
		pulsar_console?.set_block_events(TRUE)
		pulsar_console = null
		portal.try_deactivate()
		portal_active = FALSE
		disconnect_time = world.time
	else if(href_list["reconnect"])
		if(world.time > disconnect_time + RECONNECT_CD)
			pulsar_console = locate() in console_area
			pulsar_console?.set_block_events(FALSE)
			portal.try_activate()
			portal_active = TRUE

	SSnano.update_uis(src)

/obj/machinery/power/pulsar_power_bridge/Destroy()
	pulsar_console?.set_block_events(TRUE)
	pulsar_console = null
	new /obj/item/electronics/circuitboard/pulsar_power_bridge(get_turf(src))
	. = ..()

/obj/machinery/power/pulsar_power_bridge/update_icon()
	if(!pulsar_console)
		icon_state = "bridge"
	else
		var/state = CLAMP(round(pulsar_console.get_effective_power_porduced() / 10), 1, 6)
		icon_state = "bridge_on[state]"


/obj/structure/pulsar_fuel_tank
	name = "pulsar fuel tank"
	desc = "A massive fuel tank refialable by smaller gas tanks."
	icon = 'icons/obj/pulsar_machinery.dmi'
	icon_state = "pulsar_tank"
	anchored = TRUE

	var/obj/machinery/pulsar/connected_console //Used to handle proper qdels, couldn't find a signal for it
	var/datum/gas_mixture/air_contents
	var/volume = 700

/obj/structure/pulsar_fuel_tank/Initialize()
	. = ..()
	air_contents = new /datum/gas_mixture(volume)
	air_contents.temperature = T20C


/obj/structure/pulsar_fuel_tank/Destroy()
	. = ..()
	if(air_contents)
		QDEL_NULL(air_contents)
	connected_console.tank = null
	SSnano.update_uis(connected_console)

/obj/structure/pulsar_fuel_tank/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tank))
		var/obj/item/tank/tank = W
		air_contents.merge(tank.return_air())
		tank.remove_air(tank.volume)
		to_chat(user, SPAN_NOTICE("You pump the contents of [tank] into [src]"))
		playsound(src, 'sound/effects/spray.ogg', 50, 1, -3)

		if(round(air_contents.get_total_moles()) > 100)
			icon_state = "pulsar_tank_burst"
			visible_message(SPAN_DANGER("[src] looks like it's about to explode!"))
		else
			icon_state = "pulsar_tank"

		if(round(air_contents.get_total_moles()) >= 125)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			visible_message(SPAN_DANGER("[src] explodes violently and all of the gas starts pouring out!"))
			playsound(src, 'sound/effects/smoke.ogg', 100, 1, -3)
			T.assume_air(air_contents)
			qdel(src)
	else
		to_chat(user, SPAN_NOTICE("[src] can only be refiled with portable fuel tanks"))

/obj/structure/pulsar_fuel_tank/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("[src] can only be refiled with portable fuel tanks"))
	. = ..()

/obj/structure/pulsar_fuel_tank/examine(mob/user, distance, infix, suffix)
	. = ..()
	to_chat(user, "Fuel: [round(air_contents.get_total_moles())]/100")
	if(round(air_contents.get_total_moles()) >= 100)
		to_chat(user, SPAN_DANGER("It looks like its about to burst!"))

/obj/structure/pulsar_fuel_tank/filled/Initialize()
	. = ..()
	air_contents.adjust_gas("plasma", 3 * ONE_ATMOSPHERE * volume/(R_IDEAL_GAS_EQUATION*T20C))
