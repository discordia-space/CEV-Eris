///SCI TELEPAD///
/obj/machinery/telepad
	name = "telepad"
	desc = "A bluespace telepad used for teleporting objects to and from a location."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	anchored = 1
	use_power = 1
	idle_power_usage = 200
	active_power_usage = 5000
	circuit = /obj/item/weapon/circuitboard/telesci_pad
	var/efficiency

/obj/machinery/telepad/New()
	..()
	component_parts = list(
	new /obj/item/weapon/circuitboard/telesci_pad,
	new /obj/item/bluespace_crystal/artificial,
	new /obj/item/bluespace_crystal/artificial,
	new /obj/item/weapon/stock_parts/capacitor,
	new /obj/item/weapon/stock_parts/console_screen
	)
	RefreshParts()

/obj/machinery/telepad/RefreshParts()
	var/E
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		E += C.rating
	efficiency = E

/obj/machinery/telepad/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction(I, user))
		return
	if(default_part_replacement(I, user))
		return
	if(panel_open)
		if(istype(I, /obj/item/weapon/tool/multitool))
			var/obj/item/weapon/tool/multitool/M = I
			M.buffer_object = src
			to_chat(user, "<span class='caution'>You save the data in the [I.name]'s buffer.</span>")
			return

	else
		if(istype(I, /obj/item/weapon/tool/multitool))
			to_chat(user, "<span class='caution'>You should open [src]'s maintenance panel first.</span>")
			return

/obj/machinery/telepad/update_icon()
	switch (panel_open)
		if (1)
			icon_state = "pad-idle-o"
		if (0)
			icon_state = "pad-idle"
