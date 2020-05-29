/obj/structure/exosuit_wreckage
	name = "exosuit wreckage"
	desc = "It might have some salvagable materials and parts."
	icon = MECH_WRECKAGE_ICON
	icon_state = "wreck"
	density = TRUE
	anchored = TRUE
	var/material = MATERIAL_STEEL

/obj/structure/exosuit_wreckage/New(newloc, mob/living/exosuit/exosuit)
	if(exosuit)
		if(exosuit.name != "exosuit")
			name = "wreckage of \the [exosuit.name]"

		material = exosuit.material

		for(var/hardpoint in exosuit.hardpoints)
			if(exosuit.hardpoints[hardpoint] && prob(40))
				var/obj/item/thing = exosuit.hardpoints[hardpoint]
				if(exosuit.remove_system(hardpoint))
					thing.forceMove(src)

		for(var/obj/item/thing in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
			if(prob(40))
				thing.forceMove(src)

	..()

/obj/structure/exosuit_wreckage/Initialize(newloc)
	. = ..()

	// Add default frame materials
	matter = list(
		MATERIAL_STEEL = rand(10, 20),
		MATERIAL_PLASTIC = rand(5, 10)
	)
	// Add reinforcement materials
	LAZYAPLUS(matter, material, rand(5, 10))

/obj/structure/exosuit_wreckage/attackby(obj/item/I, mob/user)
	var/tool_type = I.get_tool_type(user, list(QUALITY_WELDING, QUALITY_SAWING), src)
	switch(tool_type)
		if(QUALITY_WELDING, QUALITY_SAWING)
			to_chat(user, SPAN_NOTICE("You start cutting \the [src] apart."))
			if(I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You dismantle \the [src]."))
				drop_materials(drop_location())
				for(var/obj/thing in contents)
					thing.forceMove(drop_location())
				qdel(src)
			return

		if(ABORT_CHECK)
			return

	if(user.a_intent == I_HELP)
		to_chat(user, SPAN_WARNING("You need something to cut \the [src] apart."))

	return ..()

/obj/structure/exosuit_wreckage/powerloader/New(newloc, mob/living/exosuit/exosuit)
	..(newloc, exosuit ? new /mob/living/exosuit/premade/powerloader(newloc) : exosuit)

/obj/structure/exosuit_wreckage/random/New(newloc, mob/living/exosuit/exosuit)
	..(newloc, exosuit ? new /mob/living/exosuit/premade/random(newloc) : exosuit)
