/obj/item/weapon/gun/projectile/automatic/motherfucker
	name = "HM Motherfucker .35 \"Punch Hole\""
	desc = "A 6 barrel, pump action carbine, shakes like the devil. but will turn anything in a 90º from you in swiss cheese."
	icon = 'icons/obj/guns/projectile/gladstone.dmi'
	icon_state = "gladstone"
	item_state = "gladstone"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_ROBUST
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CAL_PISTOL
	load_method = SINGLE_CASING
	handle_casings = EJECT_CASINGS
	max_shells = 54
	penetration_multiplier = 1.3 // and good AP
	proj_step_multiplier = 0.8 // faster than non-shotgun bullets, slower than non-shotgun bullets with an accelerator
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 15)
	price_tag = 300
	recoil_buildup = 21 // same as the LMG but 6X since its 6 at once
	one_hand_penalty = 60 //double the LMG.
	burst_delay = 0
	burst = 6
	init_offset = 7 //awful accuracy
	var/recentpumpmsg = 0
	var/pumped = FALSE
	init_firemodes = list(
		list(mode_name="fire all barrels at once", burst=6, icon="burst"),
		)
	
/obj/item/weapon/gun/projectile/automatic/motherfucker/attack_self(mob/living/user as mob)
	if(world.time >= recentpumpmsg + 10)
		recentpumpmsg = world.time
		playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)
		pumped = TRUE
	
/obj/item/weapon/gun/projectile/automatic/motherfucker/special_check(mob/user)
	if(!pumped)
		to_chat(user, SPAN_WARNING("You can't fire [src] without pumping it "))
		return 0
	return ..()

/obj/item/weapon/gun/projectile/automatic/motherfucker/handle_post_fire(mob/user)
	..()
	pumped = FALSE