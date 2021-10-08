/obj/item/gun/projectile/revolver/handmade
	name = "handmade revolver"
	desc = "Handmade revolver, made from gun parts. and some duct tap, will it even hold up?"
	icon = 'icons/obj/guns/projectile/handmade_revolver.dmi'
	icon_state = "handmade_revolver"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	max_shells = 5
	matter = list(MATERIAL_PLASTIC = 10, MATERIAL_STEEL = 15)
	price_tag = 250 //one of the cheapest revolvers here
	damage_multiplier = 1.3
	recoil_buildup = 7
	spawn_blacklisted = TRUE

/obj/item/gun/projectile/revolver/handmade/attackby(obj/item/W, mob/user)
	if(QUALITY_SCREW_DRIVING in W.tool_qualities)
		to_chat(user, SPAN_NOTICE("You begin to rechamber \the [src]."))
		if(loaded.len == 0 && W.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			if(caliber == CAL_MAGNUM)
				caliber = CAL_PISTOL
				to_chat(user, SPAN_WARNING("You successfully rechamber \the [src] to .35 Caliber."))
			else if(caliber == CAL_PISTOL)
				caliber = CAL_CLRIFLE
				to_chat(user, SPAN_WARNING("You successfully rechamber \the [src] to .25 Caseless."))
			else if(caliber == CAL_CLRIFLE)
				caliber = CAL_MAGNUM
				to_chat(user, SPAN_WARNING("You successfully rechamber \the [src] to .40 Magnum."))
		else 
			to_chat(user, SPAN_WARNING("You cannot rechamber a loaded firearm!"))
			return
	..()
