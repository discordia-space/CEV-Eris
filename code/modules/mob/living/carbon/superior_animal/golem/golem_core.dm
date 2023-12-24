#define GOLEM_CORE_HEAL 25
#define GOLEM_CORE_LIFETIME 3 MINUTES

/obj/item/golem_core
	name = "golem core"
	desc = "A mysterious stone that dimly glows in the dark. Its light seems to be slowly fading."
	gender = PLURAL
	icon = 'icons/mob/golems.dmi'
	icon_state = "golem_core"
	volumeClass = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	origin_tech = list(TECH_BIO = 2)
	matter = list(MATERIAL_BIOMATTER = 5)
	spawn_blacklisted = TRUE

/obj/item/golem_core/New(loc)
	..(loc)
	// Golem cores have a limited lifetime
	addtimer(CALLBACK(src, PROC_REF(crumble)), GOLEM_CORE_LIFETIME)

/obj/item/golem_core/attack(mob/living/M, mob/living/user)
	if(..())
		return TRUE

	// Display start message
	user.visible_message(
		SPAN_NOTICE("\The [user] starts applying \the [src] on [M]."),
		SPAN_NOTICE("You start applying \the [src] on [M].")
	)

	// Should not move when applying the core
	if(!do_mob(user, M, 2 SECOND))
		to_chat(user, SPAN_NOTICE("You must stand still to apply \the [src]."))
		return TRUE
	
	// Heal the target
	M.adjustBruteLoss(-GOLEM_CORE_HEAL)
	M.adjustFireLoss(-GOLEM_CORE_HEAL)

	// Display end message
	user.visible_message(
		SPAN_NOTICE("[user] applied \the [src] on [M]."),
		SPAN_NOTICE("You applied \the [src] on [M], which quickly crumbles into dry dust.")
	)

	// Delete core
	qdel(src)

/obj/item/golem_core/proc/crumble()
	visible_message(SPAN_NOTICE("\The [src] dims down and crumbles into dry dust."))
	qdel(src)  // Delete core

#undef GOLEM_CORE_HEAL
#undef GOLEM_CORE_LIFETIME
