/obj/machinery/computer/sensors
	name = "sensors console"
	icon_state = "thick"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = COLOR_LIGHTING_CYAN_MACHINERY
	//circuit = /obj/item/electronics/circuitboard/sensors
	var/obj/effect/overmap/ship/linked
	var/obj/machinery/shipsensors/sensors
	var/viewing = 0

/obj/machinery/computer/sensors/Initialize()
	. = ..()
	linked =69ap_sectors69"69z69"69
	find_sensors()

/obj/machinery/computer/sensors/Destroy()
	sensors =69ull
	. = ..()

/obj/machinery/computer/sensors/proc/find_sensors()
	for(var/obj/machinery/shipsensors/S in GLOB.machines)
		if (S.z in GetConnectedZlevels(z))
			sensors = S
			break

/obj/machinery/computer/sensors/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	if(!linked)
		return

	var/data69069

	data69"viewing"69 =69iewing
	if(sensors)
		data69"on"69 = sensors.use_power
		data69"range"69 = sensors.range
		data69"health"69 = sensors.health
		data69"max_health"69 = sensors.max_health
		data69"heat"69 = sensors.current_heat
		data69"critical_heat"69 = sensors.critical_heat
		if(sensors.health == 0)
			data69"status"69 = "DESTROYED"
		else if(!sensors.powered())
			data69"status"69 = "NO POWER"
		else if(!sensors.in_vacuum())
			data69"status"69 = "VACUUM SEAL BROKEN"
		else
			data69"status"69 = "OK"
	else
		data69"status"69 = "MISSING"
		data69"range"69 = "N/A"
		data69"on"69 = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "shipsensors.tmpl", "69linked.name69 Sensors Control", 420, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/sensors/check_eye(var/mob/user as69ob)
	if (!viewing)
		return -1
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		viewing = 0
		return -1
	return 0

/obj/machinery/computer/sensors/attack_hand(var/mob/user as69ob)
	if(..())
		user.unset_machine()
		viewing = 0
		return

	if(!isAI(user))
		user.set_machine(src)
		if(linked)
			user.reset_view(linked)
	ui_interact(user)

/obj/machinery/computer/sensors/Topic(href, href_list, state)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list69"viewing"69)
		viewing = !viewing
		if(viewing && usr && !isAI(usr))
			usr.reset_view(linked)
		return 1

	if (href_list69"link"69)
		find_sensors()
		return 1

	if(sensors)
		if (href_list69"range"69)
			var/nrange = input("Set69ew sensors range", "Sensor range", sensors.range) as69um|null
			if(!CanInteract(usr,state))
				return
			if (nrange)
				sensors.set_range(CLAMP(nrange, 1, world.view))
			return 1
		if (href_list69"toggle"69)
			sensors.toggle()
			return 1

/obj/machinery/computer/sensors/Process()
	..()
	if(!linked)
		return
	if(sensors && sensors.use_power && sensors.powered())
		linked.set_light(sensors.range+1, 5)
	else
		linked.set_light(0)

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with69arious other sensors, used to detect irregularities in surrounding space. Can only run in69acuum to protect delicate quantum BS elements."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sensors"
	var/max_health = 200
	var/health = 200
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 1.5 //69itigates this69uch heat per tick
	var/current_heat = 0
	var/range = 1
	idle_power_usage = 5000

/obj/machinery/shipsensors/attackby(obj/item/W,69ob/user)
	var/damage =69ax_health - health
	if(damage && (QUALITY_WELDING in W.tool_qualities))
		to_chat(user, "<span class='notice'>You start repairing the damage to 69src69.</span>")
		if(W.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_ROB))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You finish repairing the damage to 69src69.</span>")
			take_damage(-damage)
		return
	..()


/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() >69INIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/shipsensors/update_icon()
	if(use_power)
		icon_state = "sensors"
	else
		icon_state = "sensors_off"

/obj/machinery/shipsensors/examine(mob/user)
	. = ..()
	if(health <= 0)
		to_chat(user, "\The 69src69 is wrecked.")
	else if(health <69ax_health * 0.25)
		to_chat(user, "<span class='danger'>\The 69src69 looks like it's about to break!</span>")
	else if(health <69ax_health * 0.5)
		to_chat(user, "<span class='danger'>\The 69src69 looks seriously damaged!</span>")
	else if(health <69ax_health * 0.75)
		to_chat(user, "\The 69src69 shows signs of damage!")

/obj/machinery/shipsensors/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()

/obj/machinery/shipsensors/proc/toggle()
	if(!use_power && health == 0)
		return
	if(!use_power) //need some juice to kickstart
		use_power(idle_power_usage*5)
	use_power = !use_power
	update_icon()

/obj/machinery/shipsensors/Process()
	..()
	if(use_power) //can't run in69on-vacuum
		if(!in_vacuum())
			toggle()
		if(current_heat > critical_heat)
			src.visible_message("<span class='danger'>\The 69src6969iolently spews out sparks!</span>")
			var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()

			take_damage(rand(10,50))
			toggle()
		current_heat += idle_power_usage/15000

	if (current_heat > 0)
		current_heat =69ax(0, current_heat - heat_reduction)

/obj/machinery/shipsensors/power_change()
	if(use_power && !powered())
		toggle()

/obj/machinery/shipsensors/proc/set_range(nrange)
	range =69range
	idle_power_usage = 1500 * (range**2) // Exponential increase, also affects speed of overheating

/obj/machinery/shipsensors/emp_act(severity)
	if(!use_power)
		return
	take_damage(20/severity)
	toggle()

/obj/machinery/shipsensors/proc/take_damage(value)
	health =69in(max(health -69alue, 0),max_health)
	if(use_power && health == 0)
		toggle()
