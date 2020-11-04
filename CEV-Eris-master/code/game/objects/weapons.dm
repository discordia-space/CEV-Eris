/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"
	bad_type = /obj/item/weapon

/obj/item/weapon/Bump(mob/M)
	spawn(0)
		..()
	return
