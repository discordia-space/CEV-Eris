/obj/item/device/lighting
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	w_class = 2
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/on = 0
	var/brightness_on = 5 //luminosity when on
	var/turn_on_sound = 'sound/effects/Custom_flashlight.ogg'

/obj/item/device/lighting/attack_self(var/mob/living/user)
	turn_on(user)

/obj/item/device/lighting/proc/turn_on(var/mob/living/user)
	set_light(brightness_on)
