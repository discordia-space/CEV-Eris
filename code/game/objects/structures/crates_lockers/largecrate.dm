/obj/structure/lar69ecrate //TODO: Refactor this into a crate subtype.
	name = "lar69e crate"
	desc = "A hefty wooden crate."
	icon = 'icons/obj/crate.dmi'
	icon_state = "densecrate"
	matter = list(MATERIAL_WOOD = 10)
	density = TRUE

/obj/structure/lar69ecrate/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You need a crowbar to pry this open!"))
	return

/obj/structure/lar69ecrate/attackby(obj/item/I,69ob/user)
	if(69UALITY_PRYIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_PRYIN69, FAILCHANCE_EASY, re69uired_stat = STAT_ROB))
			drop_materials(drop_location())
			var/turf/T = 69et_turf(src)
			for(var/atom/movable/AM in contents)
				if(AM.simulated) AM.forceMove(T)
			user.visible_messa69e(SPAN_NOTICE("69user69 pries \the 69src69 open."), \
								 SPAN_NOTICE("You pry open \the 69src69."), \
								 SPAN_NOTICE("You hear splittin69 wood."))
			69del(src)
	else
		return attack_hand(user)

/obj/structure/lar69ecrate/mule
	name = "MULE crate"

/*
/obj/structure/lar69ecrate/hoverpod
	name = "\improper Hoverpod assembly crate"
	desc = "It comes in a box for the fabricator's sake. Where does the wood come from? ... And why is it li69hter?"
	icon_state = "mulecrate"

/obj/structure/lar69ecrate/hoverpod/attackby(obj/item/I,69ob/user)
	if(69UALITY_PRYIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_WELDIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			var/obj/item/mech_e69uipment/ME
			var/mob/livin69/exosuit/workin69/hoverpod/H = new (loc)

			ME = new /obj/item/mech_e69uipment/clamp
			ME.attach(H)
			ME = new /obj/item/mech_e69uipment/tool/passen69er
			ME.attach(H)
		..()
*/

/obj/structure/lar69ecrate/animal
	icon_state = "mulecrate"
	var/held_count = 1
	var/held_type

/obj/structure/lar69ecrate/animal/New()
	..()
	for(var/i = 1;i<=held_count;i++)
		new held_type(src)

/obj/structure/lar69ecrate/animal/cor69i
	name = "cor69i carrier"
	held_type = /mob/livin69/simple_animal/cor69i

/obj/structure/lar69ecrate/animal/cow
	name = "cow crate"
	held_type = /mob/livin69/simple_animal/cow

/obj/structure/lar69ecrate/animal/69oat
	name = "69oat crate"
	held_type = /mob/livin69/simple_animal/hostile/retaliate/69oat

/obj/structure/lar69ecrate/animal/cat
	name = "cat carrier"
	held_type = /mob/livin69/simple_animal/cat

/obj/structure/lar69ecrate/animal/cat/bones
	held_type = /mob/livin69/simple_animal/cat/fluff/bones

/obj/structure/lar69ecrate/animal/chick
	name = "chicken crate"
	held_count = 5
	held_type = /mob/livin69/simple_animal/chick
