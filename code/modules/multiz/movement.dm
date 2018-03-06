/obj/item/weapon/tank/jetpack/verb/moveup()
	set name = "Move Upwards"
	set category = "Object"

	. = 1
	if(!allow_thrust(0.01, usr))
		usr << SPAN_WARNING("\The [src] is disabled.")
		return

	var/turf/above = GetAbove(src)
	if(!istype(above))
		usr << SPAN_NOTICE("There is nothing of interest in this direction.")
		return

	if(!istype(above, /turf/space) && !istype(above, /turf/simulated/open))
		usr << SPAN_WARNING("You bump against \the [above].")
		return

	for(var/atom/A in above)
		if(A.density)
			usr << SPAN_WARNING("\The [A] blocks you.")
			return

	usr.Move(above)
	usr << SPAN_NOTICE("You move upwards.")

/obj/item/weapon/tank/jetpack/verb/movedown()
	set name = "Move Downwards"
	set category = "Object"

	. = 1
	if(!allow_thrust(0.01, usr))
		usr << SPAN_WARNING("\The [src] is disabled.")
		return

	var/turf/below = GetBelow(src)
	if(!istype(below))
		usr << SPAN_NOTICE("There is nothing of interest in this direction.")
		return

	if(!istype(below, /turf/space) && !istype(below, /turf/simulated/open))
		usr << SPAN_WARNING("You bump against \the [below].")
		return

	for(var/atom/A in below)
		if(A.density)
			usr << SPAN_WARNING("\The [A] blocks you.")
			return

	usr.Move(below)
	usr << SPAN_NOTICE("You move downwards.")

//////////////////////////////////////////Thank you bay

/mob/proc/zMove(direction)
	if(eyeobj)//for AI
		return eyeobj.zMove(direction)

	if(!can_ztravel())
		src << SPAN_WARNING("You lack means of travel in that direction.")
		return

	var/turf/start = loc
	if(!istype(start))
		src << SPAN_NOTICE("You are unable to move from here.")
		return 0

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(!destination)
		src << SPAN_NOTICE("There is nothing of interest in this direction.")
		return 0

	if(!start.CanZPass(src, direction))
		src << SPAN_WARNING("\The [start] is in the way.</span>")
		return 0

	if(!destination.CanZPass(src, direction))
		src << SPAN_WARNING("You bump against \the [destination].")
		return 0

	var/area/area = get_area(src)
	if(direction == UP && area.has_gravity() && !can_overcome_gravity())
		src << SPAN_WARNING("Gravity stops you from moving upward.")
		return 0

	for(var/atom/A in destination)
		if(!A.CanMoveOnto(src, start, 1.5, direction))
			src << SPAN_WARNING("\The [A] blocks you.")
			return 0

/*	if(direction == UP && area.has_gravity() && can_fall(FALSE, destination) NOT FOR NOW)
		to_chat(src, "<span class='warning'>You see nothing to hold on to.</span>")
		return 0*/

	forceMove(destination)
	return 1


/atom/proc/CanMoveOnto(atom/movable/mover, turf/target, height=1.5, direction = 0)
	//Purpose: Determines if the object can move through this
	//Uses regular limitations plus whatever we think is an exception for the purpose of
	//moving up and down z levles
	return CanPass(mover, target, height, 0) || (direction == DOWN)

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/carbon/human/can_overcome_gravity()
/*	//First do species check
	Not for now, again. First is implementig CLIBMBABLE things and structures, and then this shit below
	if(species && species.can_overcome_gravity(src))//also NO ANY CLIMBING SPECIES, so this is deadcode and we need to clear it out in future
		return 1
	else
		for(var/atom/a in src.loc)
			if(a.atom_flags & ATOM_FLAG_CLIMBABLE)
				return 1

		//Last check, list of items that could plausibly be used to climb but aren't climbable themselves
		var/list/objects_to_stand_on = list(
				/obj/item/weapon/stool,
				/obj/structure/bed,
			)
		for(var/type in objects_to_stand_on)
			if(locate(type) in src.loc)
				return 1*/
	return 0//for this moment peolpe can overcome it only with jetpacks!

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		src << SPAN_NOTICE("There is nothing of interest in this direction.")

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		src << SPAN_NOTICE("There is nothing of interest in this direction.")

/mob/proc/can_ztravel()
	return FALSE

/mob/observer/can_ztravel()
	return TRUE

/mob/living/silicon/ai/can_ztravel()
	return TRUE

/mob/living/carbon/human/can_ztravel()
	if(incapacitated())
		return 0

/* TODO : REPLACE ALLOW_SPMV() PROC WITH SOMETHING VALID if(Allow_Spacemove())
		return 1*/

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in trange(1,src))
			if(T.density)
				return 1

/mob/living/silicon/robot/can_ztravel()
	if(incapacitated() || is_dead())
		return 0

/*if(Allow_Spacemove()) //Checks for active jetpack
		return 1*/

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots" near dence things
		if(T.density)
			return 1

//////////////////////////////////////////////////

/mob/observer/ghost/verb/moveup()
	set name = "Move Upwards"
	set category = null
	zMove(UP)

/mob/observer/ghost/verb/movedown()
	set name = "Move Downwards"
	set category = null
	zMove(DOWN)
