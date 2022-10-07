/obj/item/gun/projectile/automatic/motherfucker
	name = "HM Motherfucker .35 \"Punch Hole\""
	desc = "A 6 barrel, pump action carbine. Shakes like the devil, but will turn anything in a 90º radius in front of you in swiss cheese."
	icon = 'icons/obj/guns/projectile/motherfucker.dmi'
	icon_state = "motherfucker"
	item_state = "motherfucker"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_DANGEROUS
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CAL_PISTOL
	load_method = SINGLE_CASING
	handle_casings = EJECT_CASINGS
	max_shells = 54
	damage_multiplier = 1
	penetration_multiplier = 0.3 // and good AP
	proj_step_multiplier = 0.8 // faster than non-shotgun bullets, slower than non-shotgun bullets with an accelerator
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 19, MATERIAL_PLASTIC = 10, MATERIAL_WOOD = 16)
	price_tag = 300
	init_recoil = LMG_RECOIL(1)
	burst_delay = 0
	burst = 6
	init_offset = 14 //awful accuracy
	init_firemodes = list(
		list(mode_name="6-round bursts", burst=6, fire_delay=null, move_delay=7, icon="burst"),
		)
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	var/recentpumpmsg = 0
	var/pumped = FALSE
	gun_parts = list(/obj/item/part/gun/frame/motherfucker = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/shotgun = 1, /obj/item/part/gun/barrel/pistol = 1)

/obj/item/part/gun/frame/motherfucker
	name = "Motherfucker frame"
	desc = "The Motherfucker. You just know someone is about to have a bad day."
	icon_state = "frame_motherfucker"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 10, MATERIAL_WOOD = 10, MATERIAL_PLASTIC = 10)
	resultvars = list(/obj/item/gun/projectile/automatic/motherfucker)
	gripvars = list(/obj/item/part/gun/grip/wood)
	mechanismvar = /obj/item/part/gun/mechanism/shotgun // its effectively a shotgun
	barrelvars = list(/obj/item/part/gun/barrel/pistol)

/obj/item/gun/projectile/automatic/motherfucker/attack_self(mob/living/user)
	if(world.time >= recentpumpmsg + 10)
		recentpumpmsg = world.time
		playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)
		pumped = TRUE

/obj/item/gun/projectile/automatic/motherfucker/special_check(mob/user)
	if(!pumped)
		to_chat(user, SPAN_WARNING("You can't fire [src] without pumping it "))
		return FALSE
	return ..()

/obj/item/gun/projectile/automatic/motherfucker/handle_post_fire(mob/user)
	..()
	pumped = FALSE