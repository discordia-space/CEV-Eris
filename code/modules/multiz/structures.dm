//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/multiz
	name = "ladder"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	icon = 'icons/obj/stairs.dmi'
	var/istop = TRUE
	var/obj/structure/multiz/target

/obj/structure/multiz/New()
	. = ..()
	for(var/obj/structure/multiz/M in loc)
		if(M != src)
			spawn(1)
				world.log << "##MAP_ERROR: Multiple [initial(name)] at ([x],[y],[z])"
				qdel(src)
			return .

/obj/structure/multiz/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/multiz/proc/find_target()
	return

/obj/structure/multiz/Initialize()
	. = ..()
	find_target()

/obj/structure/multiz/attack_tk(mob/user)
	return

/obj/structure/multiz/attack_ghost(mob/user)
	. = ..()
	user.Move(get_turf(target))

/obj/structure/multiz/attack_ai(mob/living/silicon/ai/user)
	var/turf/T = get_turf(target)
	T.move_camera_by_click()

/obj/structure/multiz/attackby(obj/item/C, mob/user)
	. = ..()
	attack_hand(user)
	return



////LADDER////

/obj/structure/multiz/ladder
	name = "ladder"
	desc = "A ladder.  You can climb it up and down."
	icon_state = "ladderdown"

/obj/structure/multiz/ladder/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/ladder) in targetTurf

/obj/structure/multiz/ladder/up
	icon_state = "ladderup"
	istop = FALSE

/obj/structure/multiz/ladder/Destroy()
	if(target && istop)
		qdel(target)
	return ..()

/obj/structure/multiz/ladder/attack_hand(var/mob/M)
	if(!target || !istype(target.loc, /turf))
		M << SPAN_NOTICE("\The [src] is incomplete and can't be climbed.")
		return

	var/turf/T = target.loc
	for(var/atom/A in T)
		if(A.density)
			M << SPAN_NOTICE("\A [A] is blocking \the [src].")
			return

	M.visible_message(
		"<span class='notice'>\A [M] climbs [istop ? "down" : "up"] \a [src]!</span>",
		"You climb [istop ? "down" : "up"] \the [src]!",
		"You hear the grunting and clanging of a metal ladder being used."
	)
	T.visible_message(
		"<span class='warning'>Someone climbs [istop ? "down" : "up"] \a [src]!</span>",
		"You hear the grunting and clanging of a metal ladder being used."
	)

	if(do_after(M, 10, src))
		M.Move(T)



////STAIRS////

/obj/structure/multiz/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon_state = "rampup"
	layer = 2.4

/obj/structure/multiz/stairs/enter
	icon_state = "ramptop"

/obj/structure/multiz/stairs/enter/bottom
	icon_state = "rampbottom"
	istop = FALSE

/obj/structure/multiz/stairs/active
	density = TRUE

/obj/structure/multiz/stairs/active/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/stairs/enter) in targetTurf

/obj/structure/multiz/stairs/active/Bumped(var/atom/movable/AM)
	if(isnull(AM))
		return

	if(!target)
		return

	var/obj/structure/multiz/stairs/enter/ES = locate(/obj/structure/multiz/stairs/enter) in get_turf(AM)

	if(!ES && !istop)
		return

	AM.forceMove(get_turf(target))

	if(ismob(AM) && (ES && ES.istop == istop))
		var/list/moveWithMob = list()
		var/mob/M = AM
		if(M.pulling)
			moveWithMob += M.pulling
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			for(var/obj/item/weapon/grab/G in list(H.r_hand, H.l_hand))
				moveWithMob += G.affecting
		if(moveWithMob.len)
			var/turf/pull_target = istop ? GetBelow(ES) : GetAbove(ES)
			if(!pull_target)
				pull_target = get_turf(M)
			for(var/Elem in moveWithMob)
				var/atom/movable/A = Elem
				A.forceMove(pull_target)

/obj/structure/multiz/stairs/active/attack_robot(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)

/obj/structure/multiz/stairs/active/attack_hand(mob/user)
	. = ..()
	Bumped(user)

/obj/structure/multiz/stairs/active/bottom
	icon_state = "rampdark"
	istop = FALSE
