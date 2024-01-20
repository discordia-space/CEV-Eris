/obj/item/device/lighting/toggleable/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	brightness_on = 4
	volumeClass = ITEM_SIZE_BULKY
	flags = CONDUCT
	slot_flags = null

	on = TRUE

/obj/item/device/lighting/toggleable/lamp/New()
	..()
	update_icon()

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
	item_state = "lampgreen"
	brightness_on = 4
	light_color = COLOR_LIGHTING_GREEN_BRIGHT
