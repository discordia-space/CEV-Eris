/obj/item/device/lighting
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	volumeClass = ITEM_SIZE_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/on = FALSE
	var/brightness_on = 5 //luminosity when on
	var/turn_on_sound

/obj/item/device/lighting/attack_self(var/mob/living/user)
	turn_on(user)

/obj/item/device/lighting/proc/turn_on(var/mob/living/user)
	if(user && !isturf(user.loc))
		//To prevent some lighting anomalities.
		to_chat(user, "You cannot turn the light on while in this [user.loc].")
		return FALSE
	set_light(brightness_on)
	if(turn_on_sound)
		playsound(src.loc, turn_on_sound, 75, 1)
	on = TRUE
	update_icon()
	return TRUE
