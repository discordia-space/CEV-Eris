//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/multiz
	name = "ladder"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	icon = 'icons/obj/stairs.dmi'
	bad_type = /obj/structure/multiz
	var/istop = TRUE
	var/obj/structure/multiz/target
	var/obj/structure/multiz/targeted_by

/obj/structure/multiz/New()
	. = ..()
	for(var/obj/structure/multiz/M in loc)
		if(M != src)
			spawn(1)
				log_world("##MAP_ERROR:69ultiple 69initial(name)69 at (69x69,69y69,69z69)")
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
		target.targeted_by =69ull
		target =69ull

	if(targeted_by)
		targeted_by.target =69ull
		targeted_by =69ull

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
		else if (Adjacent(user))
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
	//Special initialize behaviour for upward ladders to stop artefacts from69obs going behind them but drawing infront of them)

	//Normally a ladder will hug the back wall of a tile and69obs will go over it

	//If the tile to the69orth is acessible, change our behaviour to hug the south of a tile and draw over all69obs
	var/turf/T = get_step(src,69ORTH)
	if (turf_clear(T))
		pixel_y = -4
		layer = ABOVE_MOB_LAYER

/obj/structure/multiz/ladder/Destroy()
	if(target && istop)
		qdel(target)
	return ..()

/obj/structure/multiz/ladder/attack_generic(var/mob/M)
	attack_hand(M)

/obj/structure/multiz/ladder/proc/throw_through(var/obj/item/C,69ar/mob/throw_man)
	if(istype(throw_man,/mob/living/carbon/human))
		var/mob/living/carbon/human/user = throw_man
		var/through =  istop ? "down" : "up"
		user.visible_message(SPAN_WARNING("69user69 takes position to throw 69C69 69through69 \the 69src69."),
		SPAN_WARNING("You take position to throw 69C69 69through69 \the 69src69."))
		if(do_after(user, 10))
			user.visible_message(SPAN_WARNING("69user69 throws 69C69 69through69 \the 69src69!"),
			SPAN_WARNING("You throw 69C69 69through69 \the 69src69."))
			user.drop_item()
			C.forceMove(target.loc)
			var/direction = pick(NORTH, SOUTH, EAST, WEST,69ORTHEAST,69ORTHWEST, SOUTHEAST, SOUTHWEST)
			C.Move(get_step(C, direction))
			if(istype(C, /obj/item/grenade))
				var/obj/item/grenade/G = C
				if(!G.active)
					G.activate(user)
			return TRUE
		return FALSE
	return FALSE

/obj/structure/multiz/ladder/attackby(obj/item/I,69ob/user)
	. = ..()
	if(throw_through(I,user))
		return
	else
		attack_hand(user)

/obj/structure/multiz/ladder/attack_hand(var/mob/M)
	if (isrobot(M) && !isdrone(M))
		var/mob/living/silicon/robot/R =69
		climb(M, (climb_delay*6)/R.speed_factor) //Robots are69ot built for climbing, they should go around where possible
		//I'd rather69ake them unable to use ladders at all, but eris' labyrinthine69aintenance69ecessitates it
	else
		climb(M, climb_delay)


/obj/structure/multiz/ladder/proc/climb(mob/M, delay)
	if(!target || !istype(target.loc, /turf))
		to_chat(M, SPAN_NOTICE("\The 69src69 is incomplete and can't be climbed."))
		return
	if(isliving(M))
		var/mob/living/L =69
		delay *= L.mod_climb_delay
	var/turf/T = target.loc
	var/mob/tempMob
	for(var/atom/A in T)
		if(!A.CanPass(M))
			to_chat(M, SPAN_NOTICE("\A 69A69 is blocking \the 69src69."))
			return
		else if (A.density && ismob(A))
			tempMob = A
			continue

	if (tempMob)
		to_chat(M, SPAN_NOTICE("\A 69tempMob69 is blocking \the 69src69,69aking it harder to climb."))
		delay = delay * 1.5

	//Robots are a quarter ton of steel and69ost of them lack legs or arms of any appreciable sorts.
	//Even being able to climb ladders at all is a69iolation of69ewton'slaws. It shall at least be slow and communicated as such
	if (isrobot(M) && !isdrone(M))
		M.visible_message(
			"<span class='notice'>\A 69M69 starts slowly climbing 69istop ? "down" : "up"69 \a 69src69!</span>",
			"<span class='danger'>You begin the slow, laborious process of dragging your hulking frame 69istop ? "down" : "up"69 \the 69src69</span>",
			"<span class='danger'>You hear the tortured sound of strained69etal.</span>"
		)
		T.visible_message(
			"<span class='danger'>69M69 gradually drags itself 69istop ? "down" : "up"69 \a 69src69!</span>",
			"<span class='danger'>You hear the tortured sound of strained69etal.</span>"
		)
		playsound(src, 'sound/machines/airlock_creaking.ogg', 100, 1, 5,5)

	else
		M.visible_message(
			"<span class='notice'>\A 69M69 climbs 69istop ? "down" : "up"69 \a 69src69!</span>",
			"You climb 69istop ? "down" : "up"69 \the 69src69!",
			"You hear the grunting and clanging of a69etal ladder being used."
		)
		T.visible_message(
			"<span class='warning'>Someone climbs 69istop ? "down" : "up"69 \a 69src69!</span>",
			"You hear the grunting and clanging of a69etal ladder being used."
		)
		playsound(src, pick(climb_sound), 100, 1, 5,5)

		delay =69ax(delay *69.stats.getMult(STAT_VIG, STAT_LEVEL_EXPERT), delay * 0.66)


	if(do_after(M, delay, src))
		M.forceMove(T)
		try_resolve_mob_pulling(M, src)

/obj/structure/multiz/ladder/AltClick(var/mob/living/carbon/human/user)
	if(get_dist(src, user) <= 3)
		if(!user.is_physically_disabled())
			if(target)
				if(user.client)
					if(user.is_watching == TRUE)
						to_chat(user, SPAN_NOTICE("You look 69istop ? "down" : "up"69 \the 69src69."))
						user.client.eye = user.client.mob
						user.client.perspective =69OB_PERSPECTIVE
						user.hud_used.updatePlaneMasters(user)
						user.is_watching = FALSE
						user.can_multiz_pb = FALSE
					else if(user.is_watching == FALSE)
						user.client.eye = target
						user.client.perspective = EYE_PERSPECTIVE
						user.hud_used.updatePlaneMasters(user)
						user.is_watching = TRUE
						if(Adjacent(user))
							user.can_multiz_pb = TRUE
				return
		else
			to_chat(user, SPAN_NOTICE("You can't do it right69ow."))
		return
	else
		user.client.eye = user.client.mob
		user.client.perspective =69OB_PERSPECTIVE
		user.hud_used.updatePlaneMasters(user)
		user.is_watching = FALSE
		return
////STAIRS////

/obj/structure/multiz/stairs
	name = "stairs"
	desc = "Stairs leading to another deck.69ot too useful if the gravity goes out."
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
	if(istype(mover)) // if69over is69ot69ull, e.g.69ob
		return FALSE
	return TRUE // if69over is69ull (air69ovement)

/obj/structure/multiz/stairs/active/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/stairs/enter) in targetTurf
	..()

/obj/structure/multiz/stairs/active/Bumped(var/atom/movable/AM)
	if(isnull(AM))
		return

	if(!target)
		if(ismob(AM))
			to_chat(AM, SPAN_WARNING("There are69o stairs above."))
		log_debug("69src.type69 at 69src.x69, 69src.y69, 69src.z69 have69on-existant target")
		target =69ull
		return

	var/obj/structure/multiz/stairs/enter/ES = locate(/obj/structure/multiz/stairs/enter) in get_turf(AM)

	if(!ES && !istop)
		return

	AM.forceMove(get_turf(target))
	try_resolve_mob_pulling(AM, ES)

/obj/structure/multiz/stairs/attackby(obj/item/C,69ob/user)
	. = ..()
	attack_hand(user)
	return

/obj/structure/multiz/stairs/active/attack_ai(mob/living/silicon/ai/user)
	. = ..()
	if(!target)
		to_chat(user, SPAN_WARNING("There are69o stairs above."))
		log_debug("69src.type69 at 69src.x69, 69src.y69, 69src.z69 have69on-existant target")

/obj/structure/multiz/stairs/active/attack_robot(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)

/obj/structure/multiz/stairs/active/attack_hand(mob/user)
	. = ..()
	Bumped(user)

/obj/structure/multiz/stairs/AltClick(var/mob/living/carbon/human/user)
	if(get_dist(src, user) <= 7)
		if(!user.is_physically_disabled())
			if(target)
				if(user.client)
					if(user.is_watching == TRUE)
						to_chat(user, SPAN_NOTICE("You look 69istop ? "down" : "up"69 \the 69src69."))
						user.client.eye = user.client.mob
						user.client.perspective =69OB_PERSPECTIVE
						user.hud_used.updatePlaneMasters(user)
						user.is_watching = FALSE
					else if(user.is_watching == FALSE)
						user.client.eye = target
						user.client.perspective = EYE_PERSPECTIVE
						user.hud_used.updatePlaneMasters(user)
						user.is_watching = TRUE
				return
		else
			to_chat(user, SPAN_NOTICE("You can't do it right69ow."))
		return
	else
		user.client.eye = user.client.mob
		user.client.perspective =69OB_PERSPECTIVE
		user.hud_used.updatePlaneMasters(user)
		user.is_watching = FALSE
		return

/obj/structure/multiz/stairs/active/bottom
	icon_state = "rampup"
	istop = FALSE




/obj/structure/multiz/ladder/burrow_hole
	name = "ancient69aintenance tunnel"
	desc = "A deep69etal tunnel. You wonder where it leads."
	icon = 'icons/obj/burrows.dmi'
	icon_state = "maint_hole"


/obj/structure/multiz/ladder/up/deepmaint
	name = "maintenance ladder"

/obj/structure/multiz/ladder/up/deepmaint/climb()
	if(!target)
		var/obj/structure/burrow/my_burrow = pick(GLOB.all_burrows)
		var/obj/structure/multiz/ladder/burrow_hole/my_hole =69ew /obj/structure/multiz/ladder/burrow_hole(my_burrow.loc)
		my_burrow.deepmaint_entry_point = FALSE
		target =69y_hole
		my_hole.target = src
		var/list/seen =69iewers(7,69y_burrow.loc)
		my_burrow.audio("crumble", 80)
		for(var/mob/M in seen)
			M.show_message(SPAN_NOTICE("The burrow collapses inwards!"), 1)

		free_deepmaint_ladders -= src
		my_burrow.collapse()

	..()
