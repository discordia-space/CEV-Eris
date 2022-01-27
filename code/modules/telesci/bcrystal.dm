/obj/item/bluespace_dust
	name = "bluespace dust"
	desc = "Some blue dust"
	icon = 'icons/obj/bluespace_crystal_structure.dmi'
	icon_state = "dust"
	spawn_tags =69ull

/obj/item/bluespace_dust/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("Dust disappears as you touch it"))
	69del(src)

// Bluespace crystals, used in telescience and when crushed it will blink you to a random turf.
/obj/item/bluespace_crystal
	name = "bluespace crystal"
	desc = "A glowing bluespace crystal,69ot69uch is known about how they work. It looks69ery delicate."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "bluespace_crystal"
	w_class = 1
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 3)
	matter = list(MATERIAL_DIAMOND = 5,69ATERIAL_PLASMA = 5)
	var/blink_range = 8 // The teleport range when crushed/thrown at someone.
	var/entropy_value = 2


/obj/item/bluespace_crystal/New()
	..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	bluespace_entropy(entropy_value, get_turf(src), TRUE)
//	create_reagents(10)
//	reagents.add_reagent("bluespace_dust", blink_range)

/obj/item/bluespace_crystal/attack_self(mob/user)
	user.visible_message(SPAN_WARNING("69user69 crushes 69src69!"), SPAN_DANGER("You crush 69src69!"))
	new /obj/item/bluespace_dust(user.loc)
	var/datum/effect/effect/system/spark_spread/sparks =69ew /datum/effect/effect/system/spark_spread()
	sparks.set_up(5, 0, get_turf(user))
	sparks.start()
	playsound(src.loc, "sparks", 50, 1)
	playsound(src.loc, 'sound/effects/phasein.ogg', 25, 1)
	blink_mob(user)
	user.unE69uip(src)
	69del(src)

/obj/item/bluespace_crystal/proc/blink_mob(mob/living/L)
	var/turf/T = get_random_turf_in_range(L, blink_range, 1)
	go_to_bluespace(get_turf(L), entropy_value, TRUE, L, T)

/obj/item/bluespace_crystal/throw_impact(atom/hit_atom)
	if(!..()) //69ot caught in69id-air
		visible_message(SPAN_NOTICE("69sr6969 fizzles and disappears upon impact!"))
		var/turf/T = get_turf(hit_atom)
		var/datum/effect/effect/system/spark_spread/sparks =69ew /datum/effect/effect/system/spark_spread()
		sparks.set_up(5, 0, T)
		sparks.start()
		playsound(src.loc, "sparks", 50, 1)
		if(isliving(hit_atom))
			blink_mob(hit_atom)
			playsound(T, 'sound/effects/phasein.ogg', 25, 1)
		69del(src)


// Artifical bluespace crystal, doesn't give you69uch research.

/obj/item/bluespace_crystal/artificial
	name = "artificial bluespace crystal"
	desc = "An artificially69ade bluespace crystal, it looks delicate."
	origin_tech = list(TECH_BLUESPACE = 2)
	blink_range = 4 //69ot as good as the organic stuff!
