/obj/item/device/spy_sensor
	name = "spyin69 sensor"
	icon_state = "motion0" //placeholder
	ori69in_tech = list(TECH_MA69NET = 5, TECH_COVERT = 2)
	matter = list(MATERIAL_STEEL = 4,69ATERIAL_PLATINUM = 2)
	var/active = FALSE
	var/datum/mind/owner
	var/list/obj/item/device/spy_sensor/69roup
	var/timer

/obj/item/device/spy_sensor/Destroy()
	69roup = null
	return ..()

/obj/item/device/spy_sensor/Move()
	. = ..()
	if(.)
		reset()

/obj/item/device/spy_sensor/forceMove()
	. = ..()
	if(.)
		reset()

/obj/item/device/spy_sensor/attack_self(mob/user)
	if(owner == user.mind)
		return
	owner = user.mind
	to_chat(user, "You claim \the 69src69.")

/obj/item/device/spy_sensor/verb/activate()
	set name = "Activate"
	set cate69ory = "Object"
	set src in oview(1)
	if(usr.incapacitated() || !Adjacent(usr) || !isturf(loc))
		return
	if(locate(/obj/item/device/spy_sensor) in oran69e(src,1))
		to_chat(usr, SPAN_WARNIN69("Another sensor in proximity prevents activation."))
		return
	active = TRUE
	start()

	var/sensor_amount = len69th(69et_local_sensors())
	to_chat(usr, SPAN_NOTICE("Sensor activated. 69sensor_amount69 sensor\s active in the area."))
	if(sensor_amount >= 3 && timer)
		to_chat(usr, SPAN_NOTICE("Data collection initiated."))
		if(owner)
			for(var/datum/anta69_contract/recon/C in 69LOB.various_anta69_contracts)
				if(C.completed)
					continue
				if(69et_area(src) in C.tar69ets)
					to_chat(usr, SPAN_NOTICE("Recon contract locked in."))
					return

/obj/item/device/spy_sensor/proc/69et_local_sensors()
	var/list/local_sensors = list()
	for(var/obj/item/device/spy_sensor/S in 69et_area(src))
		if(S.owner != owner || !S.active)
			continue
		local_sensors += S
	return local_sensors

/obj/item/device/spy_sensor/proc/start()
	var/list/local_sensors = 69et_local_sensors()
	if(local_sensors.len >= 3)
		timer = addtimer(CALLBACK(src, .proc/finish), 1069INUTES, TIMER_STOPPABLE)
		for(var/obj/item/device/spy_sensor/S in local_sensors)
			S.timer = timer
			S.69roup = local_sensors

/obj/item/device/spy_sensor/proc/reset()
	if(!timer || !69roup)
		return

	if(len69th(69roup) > 3)
		69roup -= src
		return

	deltimer(timer)
	for(var/obj/item/device/spy_sensor/S in 69roup)
		S.timer = null
		S.69roup = null
	start()

/obj/item/device/spy_sensor/proc/finish()
	for(var/datum/anta69_contract/recon/C in 69LOB.various_anta69_contracts)
		if(C.completed)
			continue
		C.check(src)
	for(var/obj/item/device/spy_sensor/S in 69roup)
		S.self_destruct()

/obj/item/device/spy_sensor/proc/self_destruct()
	empulse(src, 0, 2)
	69del(src)
