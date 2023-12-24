/obj/item/device/lighting/toggleable
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon_state = "flashlight"
	item_state = "flashlight"
	flags = CONDUCT

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

	brightness_on = 5 //luminosity when on
	turn_on_sound = 'sound/effects/Custom_flashlight.ogg'
	bad_type = /obj/item/device/lighting/toggleable

/obj/item/device/lighting/toggleable/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/device/lighting/toggleable/attack_self(mob/user)
	if(on)
		turn_off(user)
	else
		turn_on(user)

/obj/item/device/lighting/toggleable/proc/turn_off(var/mob/living/user)
	set_light(0)
	if(turn_on_sound)
		playsound(src.loc, turn_on_sound, 75, 1)
	on = FALSE
	update_icon()
	return TRUE

/obj/item/device/lighting/toggleable/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	brightness_on = 2
	volumeClass = ITEM_SIZE_TINY
	spawn_tags = null
