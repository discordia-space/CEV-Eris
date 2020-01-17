/obj/item/device/spy_sensor
	name = "spying sensor"
	icon_state = "motion0" //placeholder
	var/active = FALSE
	var/datum/mind/owner
	var/list/obj/item/device/spy_sensor/group
	var/timer

/obj/item/device/spy_sensor/Destroy()
	group = null
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
	to_chat(user, "You claim \the [src].")

/obj/item/device/spy_sensor/verb/activate()
	set name = "Activate"
	set category = "Object"
	set src in oview(1)
	if(usr.incapacitated() || !Adjacent(usr) || !isturf(loc))
		return
	if(locate(/obj/item/device/spy_sensor) in orange(src,1))
		to_chat(usr, SPAN_WARNING("Another sensor in proximity prevents activation."))
		return
	active = TRUE
	start()

/obj/item/device/spy_sensor/proc/start()
	var/list/local_sensors = list()
	for(var/obj/item/device/spy_sensor/S in get_area(src))
		if(S.owner != owner || !S.active || S.timer)
			continue
		local_sensors += S
	if(local_sensors.len >= 3)
		timer = addtimer(CALLBACK(src, .proc/finish), 10 MINUTES)
		for(var/obj/item/device/spy_sensor/S in local_sensors)
			S.timer = timer
			S.group = local_sensors

/obj/item/device/spy_sensor/proc/reset()
	if(!timer)
		return
	if(group.len > 3)
		group -= src
		return
	deltimer(timer)
	for(var/obj/item/device/spy_sensor/S in group)
		S.timer = null
		S.group = null
	start()

/obj/item/device/spy_sensor/proc/finish()
	for(var/datum/antag_contract/recon/C in GLOB.all_antag_contracts)
		if(C.completed)
			continue
		C.check(src)
	for(var/obj/item/device/spy_sensor/S in group)
		S.self_destruct()

/obj/item/device/spy_sensor/proc/self_destruct()
	empulse(src, 0, 2)
	qdel(src)
