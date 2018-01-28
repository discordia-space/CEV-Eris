/obj/item/weapon/tool/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon_state = "cutters"
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	throw_speed = 2
	throw_range = 9
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	attack_verb = list("pinched", "nipped")
	sharp = TRUE
	edge = TRUE

/obj/item/weapon/tool/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"
	..()

/obj/item/weapon/tool/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message(
			"\The [usr] cuts \the [C]'s restraints with \the [src]!",
			"You cut \the [C]'s restraints with \the [src]!",
			"You hear cable being cut."
		)
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()
