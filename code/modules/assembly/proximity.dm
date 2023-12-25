/obj/item/device/assembly/prox_sensor
	name = "proximity sensor"
	desc = "Used for scanning and alerting when someone enters a certain proximity."
	icon_state = "prox"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)
	flags = PROXMOVE
	wires = WIRE_PULSE

	secured = FALSE

	var/scanning = FALSE
	var/range = 2
	var/timing = FALSE
	var/time = 10


/obj/item/device/assembly/prox_sensor/activate()
	if(!..()) //Cooldown check
		return
	timing = !timing
	update_icon()


/obj/item/device/assembly/prox_sensor/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		scanning = 0
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/prox_sensor/HasProximity(atom/movable/AM as mob|obj)
	if(!istype(AM))
		log_debug("DEBUG: HasProximity called with [AM] on [src] ([usr]).")
		return
	if(istype(AM, /obj/effect/beam))
		return
	if(AM.move_speed < 12)
		sense()


/obj/item/device/assembly/prox_sensor/proc/sense()
	var/turf/mainloc = get_turf(src)

	if((!holder && !secured) || !scanning || cooldown > 0)
		return
	pulse(0)
	if(!holder)
		mainloc.visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()


/obj/item/device/assembly/prox_sensor/Process()
	if(scanning)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(range,mainloc))
			if (A.move_speed < 12)
				sense()

	if(timing && (time >= 0))
		time--
	if(timing && time <= 0)
		timing = 0
		toggle_scan()
		time = 10


/obj/item/device/assembly/prox_sensor/dropped()
	spawn(0)
		sense()


/obj/item/device/assembly/prox_sensor/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "prox_timing"
		attached_overlays += "prox_timing"
	if(scanning)
		overlays += "prox_scanning"
		attached_overlays += "prox_scanning"
	if(holder)
		holder.update_icon()
	if(holder && istype(holder.loc,/obj/item/grenade/chem_grenade))
		var/obj/item/grenade/chem_grenade/grenade = holder.loc
		grenade.primed(scanning)


/obj/item/device/assembly/prox_sensor/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0, initiator = src)
	. = ..()
	sense()


/obj/item/device/assembly/prox_sensor/ui_status(mob/user)
	if(is_secured(user))
		return ..()

	return UI_CLOSE


/obj/item/device/assembly/prox_sensor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ProximitySensor", name)
		ui.open()


/obj/item/device/assembly/prox_sensor/ui_data(mob/user)
	var/list/data = list(
		"isScanning" = scanning,
		"isTiming" = timing,
		"range" = range
	)

	data["minutes"] = round((time - data["seconds"]) / 60)
	data["seconds"] = round(time % 60)

	return data


/obj/item/device/assembly/prox_sensor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("sense")
			toggle_scan()
			. = TRUE
		if("time")
			toggle_time()
			. = TRUE
		if("adjust")
			if(params["range"])
				var/value = text2num(params["range"])
				range = clamp(range + value, 1, 5)
				. = TRUE
			else if(params["time"])
				var/value = text2num(params["time"])
				time = clamp(time + value, 0, 600)
				. = TRUE


/obj/item/device/assembly/prox_sensor/proc/toggle_scan()
	if(!secured)
		return FALSE

	scanning = !scanning
	update_icon()
	sense()


/obj/item/device/assembly/prox_sensor/proc/toggle_time()
	if(!secured)
		return FALSE

	timing = !timing
	update_icon()
