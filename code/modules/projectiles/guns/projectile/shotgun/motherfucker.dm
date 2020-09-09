/obj/item/weapon/gun/projectile/shotgun/pump/motherfucker
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
	handle_casings = CYCLE_CASINGS
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
	init_firemodes = list(
		list(mode_name="fire all barrels at once", burst=6, icon="burst"),
		)

	/obj/item/weapon/gun/projectile/shotgun/pump/motherfucker/pump(mob/M as mob)
		..()
		var/turf/newloc = get_turf(src)
		if(chambered)//We have a shell in the chamber
			chambered.forceMove(newloc) //Eject casing
			chambered = null

		if(loaded.len)
			var/I = 0
			while (I < 6) //to load 6 bullets
				var/obj/item/ammo_casing/AC = loaded[1] //load next casing
				loaded -= AC  //Remove casing from loaded list.
				chambered += AC
				I ++