/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "A card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = TRUE
	opened = FALSE
	broken = FALSE
	locked = TRUE
	secure = TRUE
	wall_mounted = 0 //never solid (You can always pass over it)
	health = 200
	spawn_tags = SPAWN_TAG_CLOSET_SECURE
	spawn_blacklisted = TRUE

/obj/structure/closet/secure_closet/req_breakout()
	if(!opened && locked) return TRUE
	return ..() //It's a secure closet, but isn't locked.

/obj/structure/closet/secure_closet/break_open()
	desc += " It appears to be broken."
	broken = TRUE
	locked = FALSE
	..()

/obj/structure/closet/secure_closet/reinforced
	icon = 'icons/obj/closet.dmi'
	icon_state = "hop"
	icon_lock = "reinforced"
