/obj/item/gun/projectile/shotgun/slidebarrel
	name = "HM SG \"Ponyets\""
	desc = "Made out of trash, but rather special on its design."
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
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 12)
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	damage_multiplier = 1.2
	penetration_multiplier = 0.2
	init_recoil = CARBINE_RECOIL(3.5)
	style_damage_multiplier = 2
	price_tag = 250 //cheap as they get
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	gun_parts = list(/obj/item/part/gun/frame/ponyets = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/shotgun/steel = 1, /obj/item/part/gun/barrel/shotgun/steel = 1)

/obj/item/part/gun/frame/ponyets
	name = "Ponyets frame"
	desc = "A Ponyets. One shot, better make it count. And try not to blow your fingers off."
	icon_state = "frame_ponyets"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 5, MATERIAL_WOOD = 6)
	resultvars = list(/obj/item/gun/projectile/shotgun/slidebarrel)
	gripvars = list(/obj/item/part/gun/grip/wood)
	mechanismvar = /obj/item/part/gun/mechanism/shotgun/steel
	barrelvars = list(/obj/item/part/gun/barrel/shotgun/steel, /obj/item/part/gun/barrel/antim)

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
