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
	var/obj/structure/multiz/targeted_by

/obj/structure/multiz/New()
	. = ..()
	for(var/obj/structure/multiz/M in loc)
		if(M != src)
			spawn(1)
				log_world("##MAP_ERROR: Multiple [initial(name)] at ([x],[y],[z])")
				qdel(src)
			return .

/obj/structure/multiz/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/multiz/proc/find_target()
	if(target)
		target.targeted_by = src

/obj/structure/multiz/Initialize()
	. = ..()
	find_target()

/obj/structure/multiz/Destroy()
	if(target)
		target.targeted_by = null
		target = null

	if(targeted_by)
		targeted_by.target = null
		targeted_by = null

	return ..()


/obj/structure/multiz/attack_tk(mob/user)
	return

/obj/structure/multiz/attack_ghost(mob/user)
	. = ..()
	if(target)
		user.Move(get_turf(target))

/obj/structure/multiz/attack_ai(mob/living/silicon/user)
	if(target)
		if (isAI(user))
			var/turf/T = get_turf(target)
			T.move_camera_by_click()
		else if (Adjacent(src, user))
			attack_hand(user)





////LADDER////

/obj/structure/multiz/ladder
	name = "ladder"
	desc = "A ladder.  You can climb it up and down."
	icon_state = "ladderdown"
	var/climb_delay = 30

/obj/structure/multiz/ladder/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/ladder) in targetTurf
	..()

/obj/structure/multiz/ladder/up
	//Ladders which go up use a tall 32x64 sprite, in a seperate dmi
	icon = 'icons/obj/structures/ladder_tall.dmi'
	pixel_y = 16
	icon_state = "ladderup"
	istop = FALSE

/obj/structure/multiz/ladder/up/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/multiz/ladder/up/LateInitialize()
	..()
	//Special initialize behaviour for upward ladders to stop artefacts from mobs going behind them but drawing infront of them)

	//Normally a ladder will hug the back wall of a tile and mobs will go over it

	//If the tile to the north is acessible, change our behaviour to hug the south of a tile and draw over all mobs
	var/turf/T = get_step(src, NORTH)
	if (turf_clear(T))
		pixel_y = -4
		layer = ABOVE_MOB_LAYER

/obj/structure/multiz/ladder/Destroy()
	if(target && istop)
		qdel(target)
	return ..()

/obj/structure/multiz/ladder/attack_generic(var/mob/M)
	attack_hand(M)

/obj/structure/multiz/ladder/attack_hand(var/mob/M)
	if (isrobot(M) && !isdrone(M))
		var/mob/living/silicon/robot/R = M
		climb(M, (climb_delay*6)/R.speed_factor) //Robots are not built for climbing, they should go around where possible
		//I'd rather make them unable to use ladders at all, but eris' labyrinthine maintenance necessitates it
	else
		climb(M, climb_delay)


/obj/structure/multiz/ladder/proc/climb(var/mob/M, var/delay)
	if(!target || !istype(target.loc, /turf))
		to_chat(M, SPAN_NOTICE("\The [src] is incomplete and can't be climbed."))
		return

	var/turf/T = target.loc
	var/mob/tempMob
	for(var/atom/A in T)
		if(!A.CanPass(M))
			to_chat(M, SPAN_NOTICE("\A [A] is blocking \the [src]."))
			return
		else if (A.density && istype(A, /mob))
			tempMob = A
			continue

	if (tempMob)
		to_chat(M, SPAN_NOTICE("\A [tempMob] is blocking \the [src], making it harder to climb."))
		delay = delay * 1.5

	//Robots are a quarter ton of steel and most of them lack legs or arms of any appreciable sorts.
	//Even being able to climb ladders at all is a violation of newton'slaws. It shall at least be slow and communicated as such
	if (isrobot(M) && !isdrone(M))
		M.visible_message(
			"<span class='notice'>\A [M] starts slowly climbing [istop ? "down" : "up"] \a [src]!</span>",
			"<span class='danger'>You begin the slow, laborious process of dragging your hulking frame [istop ? "down" : "up"] \the [src]</span>",
			"<span class='danger'>You hear the tortured sound of strained metal.</span>"
		)
		T.visible_message(
			"<span class='danger'>[M] gradually drags itself [istop ? "down" : "up"] \a [src]!</span>",
			"<span class='danger'>You hear the tortured sound of strained metal.</span>"
		)
		playsound(src, 'sound/machines/airlock_creaking.ogg', 100, 1, 5,5)

	else
		M.visible_message(
			"<span class='notice'>\A [M] climbs [istop ? "down" : "up"] \a [src]!</span>",
			"You climb [istop ? "down" : "up"] \the [src]!",
			"You hear the grunting and clanging of a metal ladder being used."
		)
		T.visible_message(
			"<span class='warning'>Someone climbs [istop ? "down" : "up"] \a [src]!</span>",
			"You hear the grunting and clanging of a metal ladder being used."
		)
		playsound(src, pick(climb_sound), 100, 1, 5,5)

		delay = max(delay * M.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66) 


	if(do_after(M, delay, src))
		M.forceMove(T)
		try_resolve_mob_pulling(M, src)

////STAIRS////

/obj/structure/multiz/stairs
	name = "stairs"
	desc = "Stairs leading to another deck. Not too useful if the gravity goes out."
	icon_state = "ramptop"
	layer = 2.4

/obj/structure/multiz/stairs/enter
	icon_state = "ramptop"

/obj/structure/multiz/stairs/enter/bottom
	istop = FALSE

/obj/structure/multiz/stairs/active
	density = TRUE
	icon_state = "rampdown"

/obj/structure/multiz/stairs/active/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover)) // if mover is not null, e.g. mob
		return FALSE
	return TRUE // if mover is null (air movement)

/obj/structure/multiz/stairs/active/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/stairs/enter) in targetTurf
	..()

/obj/structure/multiz/stairs/active/Bumped(var/atom/movable/AM)
	if(isnull(AM))
		return

	if(!target)
		if(ismob(AM))
			to_chat(AM, SPAN_WARNING("There are no stairs above."))
		log_debug("[src.type] at [src.x], [src.y], [src.z] have non-existant target")
		target = null
		return

	var/obj/structure/multiz/stairs/enter/ES = locate(/obj/structure/multiz/stairs/enter) in get_turf(AM)

	if(!ES && !istop)
		return

	AM.forceMove(get_turf(target))
	try_resolve_mob_pulling(AM, ES)

/obj/structure/multiz/stairs/attackby(obj/item/C, mob/user)
	. = ..()
	attack_hand(user)
	return

/obj/structure/multiz/stairs/active/attack_ai(mob/living/silicon/ai/user)
	. = ..()
	if(!target)
		to_chat(user, SPAN_WARNING("There are no stairs above."))
		log_debug("[src.type] at [src.x], [src.y], [src.z] have non-existant target")

/obj/structure/multiz/stairs/active/attack_robot(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)

/obj/structure/multiz/stairs/active/attack_hand(mob/user)
	. = ..()
	Bumped(user)

/obj/structure/multiz/stairs/active/bottom
	icon_state = "rampup"
	istop = FALSE

