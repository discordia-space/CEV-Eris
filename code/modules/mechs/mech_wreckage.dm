/obj/structure/exosuit_wreckage
	name = "exosuit wreckage"
	desc = "It69ight have some salvagable69aterials and parts."
	icon =69ECH_WRECKAGE_ICON
	icon_state = "wreck"
	density = TRUE
	anchored = TRUE
	var/material =69ATERIAL_STEEL

/obj/structure/exosuit_wreckage/New(newloc,69ob/living/exosuit/exosuit)
	if(exosuit)
		if(exosuit.name != "exosuit")
			name = "wreckage of \the 69exosuit.name69"

		material = exosuit.material

		for(var/hardpoint in exosuit.hardpoints)
			if(exosuit.hardpoints69hardpoint69 && prob(40))
				var/obj/item/thing = exosuit.hardpoints69hardpoint69
				if(exosuit.remove_system(hardpoint))
					thing.forceMove(src)

		for(var/obj/item/thing in list(exosuit.arms, exosuit.legs, exosuit.head, exosuit.body))
			if(prob(40))
				thing.forceMove(src)

	..()

/obj/structure/exosuit_wreckage/Initialize(newloc)
	. = ..()

	// Add default frame69aterials
	matter = list(
		MATERIAL_STEEL = rand(10, 20),
		MATERIAL_PLASTIC = rand(5, 10)
	)
	// Add reinforcement69aterials
	LAZYAPLUS(matter,69aterial, rand(5, 10))

/obj/structure/exosuit_wreckage/attackby(obj/item/I,69ob/user)
	var/tool_type = I.get_tool_type(user, list(69UALITY_WELDING, 69UALITY_SAWING), src)
	switch(tool_type)
		if(69UALITY_WELDING, 69UALITY_SAWING)
			to_chat(user, SPAN_NOTICE("You start cutting \the 69src69 apart."))
			if(I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL, re69uired_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You dismantle \the 69src69."))
				drop_materials(drop_location())
				for(var/obj/thing in contents)
					thing.forceMove(drop_location())
				69del(src)
			return

		if(ABORT_CHECK)
			return

	if(user.a_intent == I_HELP)
		to_chat(user, SPAN_WARNING("You69eed something to cut \the 69src69 apart."))

	return ..()

/obj/structure/exosuit_wreckage/powerloader/New(newloc,69ob/living/exosuit/exosuit)
	..(newloc, exosuit ?69ew /mob/living/exosuit/premade/powerloader(newloc) : exosuit)

/obj/structure/exosuit_wreckage/random/New(newloc,69ob/living/exosuit/exosuit)
	..(newloc, exosuit ?69ew /mob/living/exosuit/premade/random(newloc) : exosuit)
