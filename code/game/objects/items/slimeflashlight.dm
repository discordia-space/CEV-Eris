/obj/item/device/slimelight
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	volumeClass = ITEM_SIZE_TINY
	spawn_blacklisted = TRUE

/obj/item/device/slimelight/New()
	..()
	set_light(6)

/obj/item/device/slimelight/update_icon()
	return

/obj/item/device/slimelight/attack_self(mob/user)
	return //Bio-luminescence does not toggle.
