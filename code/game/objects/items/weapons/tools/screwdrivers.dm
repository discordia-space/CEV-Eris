/obj/item/weapon/tool/screwdriver
	name = "screwdriver"
	desc = "You can use this to open panels and such things."
	icon_state = "screwdriver"
	flags = CONDUCT
	worksound = WORKSOUND_SCREW_DRIVING
	slot_flags = SLOT_BELT | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	throw_speed = 3
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("stabbed")
	tool_qualities = list(QUALITY_SCREW_DRIVING = 3)

/obj/item/weapon/tool/screwdriver/electric
	name = "electric screwdriver"
	desc = "Screwdriver powered by S class cell."
	icon_state = "e-screwdriver"
	worksound = WORKSOUND_DRIVER_TOOL
	tool_qualities = list(QUALITY_SCREW_DRIVING = 4, QUALITY_DRILLING = 1)

/obj/item/weapon/tool/screwdriver/combi_driver
	name = "combi driver"
	desc = "Drive screws, drive bolts, drill bones, you can do everything with it."
	icon_state = "combi_driver"
	worksound = WORKSOUND_DRIVER_TOOL
	tool_qualities = list(QUALITY_SCREW_DRIVING = 5, QUALITY_BOLT_TURNING = 5, QUALITY_DRILLING = 2)

/obj/item/weapon/tool/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.targeted_organ != O_EYES && user.targeted_organ != BP_HEAD)
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)
