/obj/item/remains
	name = "remains"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = 0

/obj/item/remains/human
	desc = "They look like human remains. Some poor soul expired here, a million miles from home."

/obj/item/remains/xeno
	desc = "They look like the remains of something... alien. They have a strange aura about them."
	icon_state = "remainsxeno"

/obj/item/remains/robot
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"

/obj/item/remains/mouse
	desc = "Looks like the remains of a small rodent. It doesn't squeak anymore."
	icon = 'icons/mob/mouse.dmi'
	icon_state = "skeleton"

/obj/item/remains/lizard
	desc = "They look like the remains of a small reptile."
	icon_state = "lizard"

/obj/item/remains/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("[src] sinks together into a pile of ash."))
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		new /obj/effect/decal/cleanable/ash(F)
	qdel(src)

/obj/item/remains/robot/attack_hand(mob/user as mob)
	return
