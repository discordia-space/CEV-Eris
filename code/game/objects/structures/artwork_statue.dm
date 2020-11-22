/obj/structure/artwork_statue
	name = "Weird Statue"
	desc = "An object of art, depicting a scene."
	icon = 'icons/obj/structures/artwork_statue.dmi'
	icon_state = "artwork_statue_1"
	density = TRUE
	spawn_frequency = 0

/obj/structure/artwork_statue/Initialize()
	. = ..()
	name = get_weapon_name(capitalize = TRUE)
	desc = get_statue_description()
	icon_state = "artwork_statue_[rand(1,6)]"

	var/sanity_value = 2 + rand(0,2)
	AddComponent(/datum/component/atom_sanity, sanity_value, "")

/obj/structure/artwork_statue/attackby(obj/item/I, mob/living/user)
	if(I.has_quality(QUALITY_BOLT_TURNING))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, STAT_MEC))
			user.visible_message(SPAN_WARNING("[user] has [anchored ? "un" : ""]secured \the [src]."), SPAN_NOTICE("You [anchored ? "un" : ""]secure \the [src]."))
			set_anchored(!anchored)
		return
	. = ..()
