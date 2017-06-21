/obj/item/device/lighting/toggleable/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	brightness_on = 4
	w_class = 4
	flags = CONDUCT
	slot_flags = null

	on = 1

/obj/item/device/lighting/toggleable/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in view(1)

	if(!usr.stat && !usr.restrained())
		attack_self(usr)

// green-shaded desk lamp
/obj/item/device/lighting/toggleable/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	brightness_on = 4
	light_color = "#FFC58F"