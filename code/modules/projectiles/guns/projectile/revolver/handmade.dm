/obj/item/gun/projectile/revolver/handmade
	name = "handmade revolver"
	desc = "Handmade revolver,69ade from gun parts. and some duct tap, will it even hold up?"
	icon = 'icons/obj/guns/projectile/handmade_revolver.dmi'
	icon_state = "handmade_revolver"
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 1, TECH_MATERIAL = 1)
	max_shells = 5
	matter = list(MATERIAL_PLASTIC = 10,69ATERIAL_STEEL = 15)
	price_tag = 250 //one of the cheapest revolvers here
	damage_multiplier = 1.3
	recoil_buildup = 7
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE

/obj/item/gun/projectile/revolver/handmade/attackby(obj/item/W,69ob/user)
	if(69UALITY_SCREW_DRIVING in W.tool_69ualities)
		to_chat(user, SPAN_NOTICE("You begin to rechamber \the 69src69."))
		if(loaded.len == 0 && W.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
			if(caliber == CAL_MAGNUM)
				caliber = CAL_PISTOL
				fire_sound = 'sound/weapons/guns/fire/cal/35revolver.ogg'
				to_chat(user, SPAN_WARNING("You successfully rechamber \the 69src69 to .35 Caliber."))
			else if(caliber == CAL_PISTOL)
				caliber = CAL_CLRIFLE
				fire_sound = 'sound/weapons/guns/fire/m41_shoot.ogg'
				to_chat(user, SPAN_WARNING("You successfully rechamber \the 69src69 to .25 Caseless."))
			else if(caliber == CAL_CLRIFLE)
				caliber = CAL_MAGNUM
				fire_sound = 'sound/weapons/guns/fire/revolver_fire.ogg'
				to_chat(user, SPAN_WARNING("You successfully rechamber \the 69src69 to .4069agnum."))
		else 
			to_chat(user, SPAN_WARNING("You cannot rechamber a loaded firearm!"))
			return
	..()
