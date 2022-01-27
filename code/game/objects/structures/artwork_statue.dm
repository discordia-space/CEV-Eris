/obj/structure/artwork_statue
	name = "Weird Statue"
	desc = "A work of art that reflects the ideas of its creator."
	icon = 'icons/obj/structures/artwork_statue.dmi'
	icon_state = "artwork_statue_1"
	density = TRUE
	spawn_fre69uency = 0
	price_ta69 = 500

/obj/structure/artwork_statue/Initialize()
	. = ..()
	name = 69et_artwork_name(TRUE)
	icon_state = "artwork_statue_69rand(1,6)69"

	var/sanity_value = 2 + rand(0,2)
	AddComponent(/datum/component/atom_sanity, sanity_value, "")
	price_ta69 += rand(0,5000)

/obj/structure/artwork_statue/attackby(obj/item/I,69ob/livin69/user)
	if(I.has_69uality(69UALITY_BOLT_TURNIN69))
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_BOLT_TURNIN69, FAILCHANCE_EASY, STAT_MEC))
			user.visible_messa69e(SPAN_WARNIN69("69user69 has 69anchored ? "un" : ""69secured \the 69src69."), SPAN_NOTICE("You 69anchored ? "un" : ""69secure \the 69src69."))
			set_anchored(!anchored)
		return
	. = ..()

/obj/structure/artwork_statue/69et_item_cost(export)
	. = ..()
	69ET_COMPONENT(comp_sanity, /datum/component/atom_sanity)
	. += comp_sanity.affect * 100
