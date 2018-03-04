/obj/item/weapon/tool/wirecutters
	name = "wirecutters"
	desc = "Cuts wires and other objects with it."
	icon_state = "cutters"
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	worksound = WORKSOUND_WIRECUTTING
	throw_speed = 2
	throw_range = 9
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	attack_verb = list("pinched", "nipped")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_WIRE_CUTTING = 3, QUALITY_RETRACTING = 1, QUALITY_BONE_SETTING = 1)

/obj/item/weapon/tool/wirecutters/armature
	name = "armature cutter"
	desc = "Bigger brother of wirecutter. Can't do much in terms of emergency surgery, but dose its main job better."
	icon_state = "arm-cutter"
	force = WEAPON_FORCE_NORMAL
	tool_qualities = list(QUALITY_WIRE_CUTTING = 4)

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
