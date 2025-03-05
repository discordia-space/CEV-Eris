// Decorative structures which serve no purpose other than adding flavor
// to the game world will be added here. Built on top of Possum's code.

/obj/structure/salvageable/decorative
	name = "decorative object"
	desc = "This structure seems have no other use than looking pretty. You may be able to salvage something from this."
	icon = 'icons/obj/salvageable.dmi'
	icon_state = "machine0"
	density = TRUE
	anchored = TRUE
	bad_type = /obj/structure/salvageable/decorative
	spawn_frequency = 0
	spawn_tags = SPAWN_TAG_SALVAGEABLE
	salvageable_parts = list()

/obj/structure/salvageable/decorative/attackby(obj/item/I, mob/user)
	if(I.get_tool_type(usr, list(QUALITY_PRYING, QUALITY_BOLT_TURNING), src))
		to_chat(user, SPAN_NOTICE("You start salvage anything useful from \the [src]."))
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_PRYING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			dismantle()
			qdel(src)
			return
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_BOLT_TURNING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
			dismantle()
			qdel(src)
			return

/obj/structure/salvageable/decorative/rails
	name = "rails"
	desc = "Traintracks that have been long abandonned. Could be salvageable."
	icon = 'icons/obj/structures/rails/f13rails.dmi'
	icon_state = "rails"
	density = FALSE
	salvageable_parts = list(
				/obj/item/stack/material/steel{amount = 10} = 100,
	)

/obj/structure/salvageable/decorative/rails/r
	icon_state = "rails-r"

/obj/structure/salvageable/decorative/rails/l
	icon_state = "rails-l"

/obj/structure/salvageable/decorative/rails/b1
	icon_state = "rails-b1"

/obj/structure/salvageable/decorative/rails/b2
	icon_state = "rails-b2"

