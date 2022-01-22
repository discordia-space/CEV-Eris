// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "light1"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	power_channel = STATIC_LIGHT
	var/slow_turning_on = FALSE
	var/forceful_toggle = FALSE
	var/on = TRUE
	var/area/area = null
	var/otherarea = null
	var/next_check = 0 // A time at which another mob check will occure.

/obj/machinery/light_switch/New()
	..()
	spawn(5)
		src.area = get_area(src)

		if(otherarea)
			src.area = locate(text2path("/area/[otherarea]"))

		if(!name)
			name = "light switch ([area.name])"

		src.on = src.area.lightswitch
		updateicon()

		if(area.are_living_present())
			set_on(TRUE)

/obj/machinery/light_switch/Process()
	if(next_check <= world.time)
		next_check = world.time + 10 SECONDS // Each 10 seconds it checks if anyone is in the area, but also whether the light wasn't switched on recently.
		if(area.are_living_present())
			if(!on)
				spawn(0)
					if(!on)
						dramatic_turning()
			else
				next_check = world.time + 10 MINUTES
		else
			set_on(FALSE, FALSE)

/obj/machinery/light_switch/proc/updateicon()
	if(stat & NOPOWER)
		icon_state = "light-p"
		set_light(0)
		layer = initial(layer)
		set_plane(initial(plane))
	else
		icon_state = "light[on]"
		set_light(2, 1.5, on ? COLOR_LIGHTING_GREEN_BRIGHT : COLOR_LIGHTING_RED_BRIGHT)
		set_plane(ABOVE_LIGHTING_PLANE)
		layer = ABOVE_LIGHTING_LAYER

/obj/machinery/light_switch/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A light switch. It is [on? "on" : "off"].")

/obj/machinery/light_switch/proc/dramatic_turning()
	if(slow_turning_on) // Sanity check. So nothing can force this thing to run twice simultaneously.
		return

	set_on(TRUE, TRUE)

	slow_turning_on = TRUE

	for(var/obj/machinery/light/L in area)
		L.seton(L.has_power())
		if(prob(50))
			L.flick_light(rand(1, 3))
		sleep(10)

		if(forceful_toggle)
			forceful_toggle = FALSE
			return

	slow_turning_on = FALSE

/obj/machinery/light_switch/proc/set_on(on_ = TRUE, play_sound = TRUE)
	on = on_

	area.lightswitch = on_
	area.updateicon()
	if(play_sound)
		playsound(src, 'sound/machines/button.ogg', 100, 1, 0)

	for(var/obj/machinery/light_switch/L in area)
		L.on = on_
		L.update_icon()

	if(on_)
		next_check = world.time + 10 MINUTES

	area.power_change()

/obj/machinery/light_switch/attack_hand(mob/user)
	forceful_toggle = TRUE
	set_on(!on)

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(STATIC_LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()

/obj/machinery/light_switch/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_change()
	..(severity)

// Dimmer switch
/obj/machinery/light_switch/dimmer_switch
	name = "dimmer switch"
	var/input_color = COLOR_LIGHTING_DEFAULT_BRIGHT

/obj/machinery/light_switch/dimmer_switch/attack_hand(mob/user)
	return nano_ui_interact(user)

/obj/machinery/light_switch/dimmer_switch/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/data = list()
	data["on"] = on
	data["input_color"] = input_color

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dimmer_switch.tmpl", "[name]", 200, 120)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/light_switch/dimmer_switch/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	if (href_list["on"])
		forceful_toggle = TRUE
		set_on(!on)
		. = TRUE
	if(href_list["input_color"])
		input_color = input("Choose a color.", name, input_color) as color|null
		area.area_light_color = input_color
		for(var/obj/machinery/light/L in area)
			L.reset_color()
		. = TRUE
	if(.)
		SSnano.update_uis(src)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
