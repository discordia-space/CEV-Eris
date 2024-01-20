/obj/item/gun/projectile/shotgun/slidebarrel
	name = "HM SG \"Ponyets\""
	desc = "Made out of trash, but rather special in its design."
	icon = 'icons/obj/guns/projectile/slideshotgun.dmi'
	icon_state = "slideshotgun"
	item_state = "slideshotgun"
	max_shells = 1
	caliber = CAL_SHOTGUN
	load_method = SINGLE_CASING
	handle_casings = HOLD_CASINGS
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	can_dual = TRUE
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_STEEL = 10, MATERIAL_WOOD = 5)
	volumeClass = ITEM_SIZE_NORMAL
	damage_multiplier = 0.7
	init_recoil = CARBINE_RECOIL(3.5)
	price_tag = 250 //cheap as they get
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	gun_parts = list(/obj/item/part/gun/frame/ponyets = 1, /obj/item/part/gun/modular/grip/wood = 1, /obj/item/part/gun/modular/mechanism/shotgun/steel = 1, /obj/item/part/gun/modular/barrel/shotgun/steel = 1)

/obj/item/part/gun/frame/ponyets
	name = "Ponyets frame"
	desc = "A Ponyets. One shot, better make it count. And try not to blow your fingers off."
	icon_state = "frame_ponyets"
	matter = list(MATERIAL_STEEL = 5)
	resultvars = list(/obj/item/gun/projectile/shotgun/slidebarrel)
	gripvars = list(/obj/item/part/gun/modular/grip/wood)
	mechanismvar = /obj/item/part/gun/modular/mechanism/shotgun/steel
	barrelvars = list(/obj/item/part/gun/modular/barrel/shotgun/steel, /obj/item/part/gun/modular/barrel/antim)

/obj/item/gun/projectile/shotgun/slidebarrel/load_ammo(obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if((load_method & SINGLE_CASING) && caliber == C.caliber && loaded.len)
			var/turf/newloc = get_turf(src)
			playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)
			if(chambered)//We have a shell in the chamber
				chambered.forceMove(newloc) //Eject casing
				chambered = null
			var/obj/item/ammo_casing/AC = loaded[1]
			loaded -= AC
			chambered = AC
	..()
