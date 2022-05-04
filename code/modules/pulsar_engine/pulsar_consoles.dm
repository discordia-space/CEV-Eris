/obj/machinery/pulsar
	name = "pulsar starmap"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	var/obj/effect/pulsar/linked
	var/obj/effect/pulsar_ship/ship
	var/obj/structure/pulsar_fuel_tank/tank
	var/map_active

/obj/machinery/pulsar/New(loc, ...)
	. = ..()
	linked = GLOB.maps_data.pulsar_star
	ship = locate(/obj/effect/pulsar_ship) in world
	if(ship)
		RegisterSignal(ship, COMSIG_MOVABLE_MOVED, .proc/onShipMoved)

/obj/machinery/pulsar/relaymove(var/mob/user, direction)
	if(map_active && linked)
		linked.relaymove(user,direction)
		return 1

/obj/machinery/pulsar/Process()
	SSnano.update_uis(src)

/obj/machinery/pulsar/power_change()
	..()
	SSnano.update_uis(src)


/obj/machinery/pulsar/check_eye(var/mob/user as mob)
	if (isAI(user))
		user.unset_machine()
		if (map_active)
			user.reset_view(user.eyeobj)
		return 0
	if (!map_active || (get_dist(user, src) > 1) || user.blinded || !linked )
		user.unset_machine()
		map_active = 0
		return -1
	return 0

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
	ui_interact(user)

/obj/machinery/pulsar/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "pulsar.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/pulsar/ui_data()
	var/list/data = list()
	data["power_produced"] = get_produced_power()
	data["ship_fuel"] = round(tank?.air_contents.get_total_moles())
	data["no_tank"] = !tank
	data["thrust_cost"] = get_thrust_cost()

	return data

/obj/machinery/pulsar/Topic(href, href_list, datum/topic_state/state)
	if(href_list["move"])
		if(tank)
			var/thrust_cost = get_thrust_cost()
			if(tank.air_contents.get_total_moles() >= thrust_cost)
				tank.air_contents.remove(thrust_cost)
				var/newdir = text2num(href_list["move"])
				ship.try_move(newdir, TRUE)
	else if(href_list["scan_fuel"])
		tank = locate(/obj/structure/pulsar_fuel_tank) in range(5) //Should scan the shuttle area not range, but shuttle isn't mapped
		SSnano.update_uis(src)
	..()

/obj/machinery/pulsar/proc/get_thrust_cost()
	if(tank?.air_contents.specific_mass())
		return round((1/tank.air_contents.specific_mass()) * 2) //Goes from 4 with 100% plasma up to 40+ when diluting with too much oxygen
	return 100

/obj/machinery/pulsar/proc/get_produced_power()
	return max(0, round((GLOB.maps_data.pulsar_size - 2 * ROOT(2, abs(linked.x - ship.x) ** 2 + abs(linked.y - ship.y) ** 2)) * 100/GLOB.maps_data.pulsar_size))

/obj/machinery/pulsar/proc/onShipMoved()
	SSnano.update_uis(src)

/obj/structure/pulsar_fuel_tank
	name = "pulsar fuel tank"
	desc = "A massive fuel tank refialable by smaller gas tanks."
	icon = 'icons/atmos/tank.dmi' //All sprites are placeholders
	icon_state = "plasma_map"
	anchored = TRUE

	var/datum/gas_mixture/air_contents
	var/volume = 700

/obj/structure/pulsar_fuel_tank/Initialize()
	. = ..()
	air_contents = new /datum/gas_mixture(volume)
	air_contents.temperature = T20C
	air_contents.adjust_gas("plasma", 3 * ONE_ATMOSPHERE * volume/(R_IDEAL_GAS_EQUATION*T20C))


/obj/structure/pulsar_fuel_tank/Destroy()
	. = ..()
	if(air_contents)
		QDEL_NULL(air_contents)

/obj/structure/pulsar_fuel_tank/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tank))
		var/obj/item/tank/tank = W
		air_contents.merge(tank.return_air())
		tank.remove_air(tank.volume)
		to_chat(user, SPAN_NOTICE("You pump the contents of [tank] into [src]"))
		if(round(air_contents.get_total_moles()) >= 125)
			var/turf/simulated/T = get_turf(src)
			if(!T)
				return
			visible_message(SPAN_DANGER("[src] explodes violently and all of the gas starts pouring out!"))
			T.assume_air(air_contents)
			playsound(T, 'sound/effects/spray.ogg', 10, 1, -3)
			qdel(src)
	else
		to_chat(user, SPAN_NOTICE("You need to use portable fuel tanks to refil [src]"))

/obj/structure/pulsar_fuel_tank/examine(mob/user, distance, infix, suffix)
	. = ..()
	to_chat(user, "Fuel: [round(air_contents.get_total_moles())]/100")
	if(round(air_contents.get_total_moles()) >= 100)
		to_chat(user, SPAN_DANGER("It looks like its about to burst!"))
