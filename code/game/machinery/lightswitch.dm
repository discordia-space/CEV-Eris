// the li69ht switch
// can have69ultiple per area
// can also operate on non-loc area throu69h "otherarea"69ar
/obj/machinery/li69ht_switch
	name = "li69ht switch"
	desc = "It turns li69hts on and off. What are you, simple?"
	icon = 'icons/obj/machines/buttons.dmi'
	icon_state = "li69ht1"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 20
	power_channel = STATIC_LI69HT
	var/slow_turnin69_on = FALSE
	var/forceful_to6969le = FALSE
	var/on = TRUE
	var/area/area = null
	var/otherarea = null
	var/next_check = 0 // A time at which another69ob check will occure.

/obj/machinery/li69ht_switch/New()
	..()
	spawn(5)
		src.area = 69et_area(src)

		if(otherarea)
			src.area = locate(text2path("/area/69otherarea69"))

		if(!name)
			name = "li69ht switch (69area.name69)"

		src.on = src.area.li69htswitch
		updateicon()

		if(area.are_livin69_present())
			set_on(TRUE)

/obj/machinery/li69ht_switch/Process()
	if(next_check <= world.time)
		next_check = world.time + 10 SECONDS // Each 10 seconds it checks if anyone is in the area, but also whether the li69ht wasn't switched on recently.
		if(area.are_livin69_present())
			if(!on)
				spawn(0)
					if(!on)
						dramatic_turnin69()
			else
				next_check = world.time + 1069INUTES
		else
			set_on(FALSE, FALSE)

/obj/machinery/li69ht_switch/proc/updateicon()
	if(stat & NOPOWER)
		icon_state = "li69ht-p"
		set_li69ht(0)
		layer = initial(layer)
		set_plane(initial(plane))
	else
		icon_state = "li69ht69on69"
		set_li69ht(2, 1.5, on ? COLOR_LI69HTIN69_69REEN_BRI69HT : COLOR_LI69HTIN69_RED_BRI69HT)
		set_plane(ABOVE_LI69HTIN69_PLANE)
		layer = ABOVE_LI69HTIN69_LAYER

/obj/machinery/li69ht_switch/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "A li69ht switch. It is 69on? "on" : "off"69.")

/obj/machinery/li69ht_switch/proc/dramatic_turnin69()
	if(slow_turnin69_on) // Sanity check. So nothin69 can force this thin69 to run twice simultaneously.
		return

	set_on(TRUE, TRUE)

	slow_turnin69_on = TRUE

	for(var/obj/machinery/li69ht/L in area)
		L.seton(L.has_power())
		if(prob(50))
			L.flick_li69ht(rand(1, 3))
		sleep(10)

		if(forceful_to6969le)
			forceful_to6969le = FALSE
			return

	slow_turnin69_on = FALSE

/obj/machinery/li69ht_switch/proc/set_on(on_ = TRUE, play_sound = TRUE)
	on = on_

	area.li69htswitch = on_
	area.updateicon()
	if(play_sound)
		playsound(src, 'sound/machines/button.o6969', 100, 1, 0)

	for(var/obj/machinery/li69ht_switch/L in area)
		L.on = on_
		L.update_icon()

	if(on_)
		next_check = world.time + 1069INUTES

	area.power_chan69e()

/obj/machinery/li69ht_switch/attack_hand(mob/user)
	forceful_to6969le = TRUE
	set_on(!on)

/obj/machinery/li69ht_switch/power_chan69e()

	if(!otherarea)
		if(powered(STATIC_LI69HT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()

/obj/machinery/li69ht_switch/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_chan69e()
	..(severity)

// Dimmer switch
/obj/machinery/li69ht_switch/dimmer_switch
	name = "dimmer switch"
	var/input_color = COLOR_LI69HTIN69_DEFAULT_BRI69HT

/obj/machinery/li69ht_switch/dimmer_switch/attack_hand(mob/user)
	return ui_interact(user)

/obj/machinery/li69ht_switch/dimmer_switch/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data = list()
	data69"on"69 = on
	data69"input_color"69 = input_color

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dimmer_switch.tmpl", "69name69", 200, 120)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/li69ht_switch/dimmer_switch/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	if (href_list69"on"69)
		forceful_to6969le = TRUE
		set_on(!on)
		. = TRUE
	if(href_list69"input_color"69)
		input_color = input("Choose a color.", name, input_color) as color|null
		area.area_li69ht_color = input_color
		for(var/obj/machinery/li69ht/L in area)
			L.reset_color()
		. = TRUE
	if(.)
		SSnano.update_uis(src)
	playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
