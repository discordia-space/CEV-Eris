/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTIC = 1)

	secured = FALSE
	wires = WIRE_PULSE

	var/timing = FALSE
	var/time = 10


/obj/item/device/assembly/timer/activate()
	if(!..()) //Cooldown check
		return

	timing = !timing
	update_icon()


/obj/item/device/assembly/timer/toggle_secure()
	secured = !secured
	if(secured)
		START_PROCESSING(SSobj, src)
	else
		timing = 0
		STOP_PROCESSING(SSobj, src)
	update_icon()
	return secured


/obj/item/device/assembly/timer/proc/timer_end()
	if(!secured)
		return
	pulse(0)
	if(!holder)
		visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()


/obj/item/device/assembly/timer/Process()
	if(timing && (time > 0))
		time--
	if(timing && time <= 0)
		timing = 0
		timer_end()
		time = 10


/obj/item/device/assembly/timer/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(timing)
		overlays += "timer_timing"
		attached_overlays += "timer_timing"
	if(holder)
		holder.update_icon()

/obj/item/device/assembly/timer/ui_status(mob/user)
	if(is_secured(user))
		return ..()

	return UI_CLOSE

/obj/item/device/assembly/timer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Timer", name)
		ui.open()

/obj/item/device/assembly/timer/ui_data(mob/user)
	var/list/data = list(
		"isTiming" = timing,
	)

	data["minutes"] = round((time - data["seconds"]) / 60)
	data["seconds"] = round(time % 60)

	return data

/obj/item/device/assembly/timer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("time")
			timing = !timing
			. = TRUE
		if("adjust")
			if(params["value"])
				var/value = text2num(params["value"])
				time = clamp(time + value, 0, 600)
				. = TRUE

