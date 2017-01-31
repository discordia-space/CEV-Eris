//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/multiz
	name = "ladder"
	density = 0
	opacity = 0
	anchored = 1
	icon = 'icons/obj/stairs.dmi'
	var/istop = 1
	var/obj/structure/multiz/target

	New()
		. = ..()
		for(var/obj/structure/multiz/M in loc)
			if(M != src)
				spawn(1)
					world.log << "##MAP_ERROR: Multiple [initial(name)] at ([x],[y],[z])"
					qdel(src)
				return .

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

	proc/find_target()
		return

	initialize()
		find_target()

	attack_tk(mob/user)
		return

	attack_ghost(mob/user)
		. = ..()
		user.Move(get_turf(target))

	attack_ai(mob/living/silicon/ai/user)
		var/turf/T = get_turf(target)
		T.move_camera_by_click()

	attackby(obj/item/C, mob/user)
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
	istop = 0

/obj/structure/multiz/ladder/Destroy()
	if(target && istop)
		qdel(target)
	return ..()

/obj/structure/multiz/ladder/attack_hand(var/mob/M)
	if(!target || !istype(target.loc, /turf))
		M << "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>"
		return

	var/turf/T = target.loc
	for(var/atom/A in T)
		if(A.density)
			M << "<span class='notice'>\A [A] is blocking \the [src].</span>"
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
	istop = 0

/obj/structure/multiz/stairs/active
	density = 1

/obj/structure/multiz/stairs/active/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/stairs/enter) in targetTurf

/obj/structure/multiz/stairs/active/Bumped(var/atom/movable/M)
	if(ismob(M))
		usr.client.moving = 1
		usr.Move(get_turf(target))
		usr.client.moving = 0
	else
		M.Move(get_turf(target))

/obj/structure/multiz/stairs/active/attack_robot(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)

/obj/structure/multiz/stairs/active/attack_hand(mob/user)
	. = ..()
	Bumped(user)

/obj/structure/multiz/stairs/active/bottom
	icon_state = "rampdark"
	istop = 0
	opacity = 1

/obj/structure/multiz/stairs/active/bottom/Bumped(var/atom/movable/M)
	//If on bottom, only let them go up stairs if they've moved to the entry tile first.
	if(!locate(/obj/structure/multiz/stairs/enter) in M.loc)
		return
	return ..()
