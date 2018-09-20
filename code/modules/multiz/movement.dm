#define Z_MOVE_PHASE			1 	//Used by ghosts, AI eye and mobs with incorp move
#define Z_MOVE_JETPACK_NOGRAV	2	//Fast, safe and minimal fuel use
#define Z_MOVE_JETPACK_GRAVITY	3	//Flying to resist gravity. Moderately fast, consumes a fair bit of fuel
#define Z_MOVE_CLIMB_GRAVITY   	4 	//Can be used by any mob, but only under specific circumstances which are usually untrue. If it is doable its quite slow
#define Z_MOVE_CLIMB_NOGRAV 	5 	//Shimmying up a wall in zero G. Kind of slow but safe
#define Z_MOVE_CLIMB_MAG		6	//Walking up a wall with magboots in zero G. Fast and safe
#define Z_MOVE_JUMP_GRAVITY		7	//Attempting to leap up to another floor. Requires superhuman abilities
#define Z_MOVE_JUMP_NOGRAV		8	//A graceful leap in zero G. Fast but very unreliable, you will slip around.


var/list/z_movement_methods = list(
1 = list()

)

//This proc does all the checks and handling of a specific Zmove method
//It requires a mob, obviously, and a method - one of the defines listed above
//If check_only is true, then this proc will only check to see if its possible but not send any actions
//If feedback is true, the mob will do visible messages describing what they're attempting to do
/proc/zmove_method(var/mob/M, var/method = 0, var/turf/start = null, var/turf/destination = null, var/direction =  var/check_only = FALSE, var/feedback = TRUE)
	if (!istype(M) || !method)
		return FALSE


	var/turf/start = get_turf(src)
	var/area/area = get_area(src)

	switch (method)
		if (Z_MOVE_PHASE)
			if (istype(M, /mob/observer))
				return TRUE
			if (M.incorporeal_move)
				return TRUE

		if (Z_MOVE_JETPACK_NOGRAV)
			if (area.has_gravity())
				return FALSE

			var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)
			if (thrust.allow_thrust(JETPACK_MOVE_COST*5, src))
				return TRUE //Do animation here
			else if (feedback)
				//It failed, lets tell the user why
				if (!thrust.on)



		if (Z_MOVE_JETPACK_GRAVITY)
			var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)
			if (thrust.allow_thrust(JETPACK_MOVE_COST*40, src))
				return TRUE //Do animation here

		if (Z_MOVE_CLIMB_NOGRAV)
			if (area.has_gravity())
				return FALSE


		if (Z_MOVE_CLIMB_GRAVITY)
		if (Z_MOVE_CLIMB_MAG)
		if (Z_MOVE_JUMP_NOGRAV)
		if (Z_MOVE_JUMP_GRAVITY)

	return FALSE


/atom/movable
	/** Used to check wether or not an atom is being handled by SSfalling. */
	var/tmp/multiz_falling = 0

/**
 * Verb for the mob to move up a z-level if possible.
 */
/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	if(zMove(UP))
		to_chat(usr, "<span class='notice'>You move upwards.</span>")

/**
 * Verb for the mob to move down a z-level if possible.
 */
/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	if(zMove(DOWN))
		to_chat(usr, "<span class='notice'>You move down.</span>")

/**
 * Used to check if a mob can move up or down a Z-level and to then actually do the move.
 *
 * @param	direction The direction in which we're moving. Expects defines UP or DOWN.
 *
 * @return	TRUE if the mob has been successfully moved a Z-level.
 *			FALSE otherwise.
 */
/mob/proc/zMove(direction, var/method = 0)
	// In the case of an active eyeobj, move that instead.
	if (eyeobj)
		return eyeobj.zMove(direction)

	if (istype(src.loc,/obj/mecha))
		return FALSE

	// Check if we can actually travel a Z-level.
	if (!can_ztravel(direction))
		to_chat(src, "<span class='warning'>You lack means of travel in that direction.</span>")
		return FALSE

	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)

	if(!destination)
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")
		return FALSE

	var/turf/start = get_turf(src)
	if(!start.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>\The [start] under you is in the way.</span>")
		return FALSE



	var/area/area = get_area(src)

	// If we want to move up,but the current area has gravity. Invoke CanAvoidGravity()
	// to check if this move is possible.
	if(direction == UP && area.has_gravity() && !CanAvoidGravity())
		to_chat(src, "<span class='warning'>Gravity stops you from moving upward.</span>")
		return FALSE

	if(!destination.CanZPass(src, direction))
		to_chat(src, "<span class='warning'>You bump against \the [destination] above your head.</span>")
		return FALSE

	// Check for blocking atoms at the destination.
	for (var/atom/A in destination)
		if (!A.CanPass(src, start, 1.5, 0))
			to_chat(src, "<span class='warning'>\The [A] blocks you.</span>")
			return FALSE

	// Actually move.
	Move(destination)
	return TRUE

/mob/living/zMove(direction)
	if (is_ventcrawling)
		var/obj/machinery/atmospherics/pipe/zpipe/P = loc
		if (istype(P) && P.can_z_crawl(src, direction))
			return P.handle_z_crawl(src, direction)

	return ..()

/mob/observer/eye/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		setLoc(destination)
	else
		to_chat(owner, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/observer/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/mob/living/carbon/human/bst/zMove(direction)
	var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
	if(destination)
		forceMove(destination)
	else
		to_chat(src, "<span class='notice'>There is nothing of interest in this direction.</span>")

/**
 * An initial check for Z-level travel. Called relatively early in mob/proc/zMove.
 *
 * Useful for overwriting and special conditions for STOPPING z-level transit.
 *
 * @return	TRUE if the mob can move a Z-level of its own volition.
 *			FALSE otherwise.
 */
/mob/proc/can_ztravel(var/direction)
	return FALSE

/mob/observer/can_ztravel(var/direction)
	return TRUE
abstra
/mob/living/carbon/human/can_ztravel(var/direction)
	if(incapacitated())
		return FALSE

	if(Allow_Spacemove())
		return TRUE

	for(var/turf/simulated/T in trange(1,src))
		if(T.density)
			if(Check_Shoegrip(FALSE))
				return TRUE

/mob/living/carbon/human/proc/climb(var/direction, var/turf/source, var/climb_bonus)
	var/turf/destination
	if(direction == UP)
		destination = GetAbove(source)
	else
		destination = GetBelow(source)

	if(!destination)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		return

	if(destination.density)
		to_chat(src, "<span class='notice'>There is something obstructing your destination!</span>")
		return

	for(var/obj/O in destination)
		if(O.density)
			to_chat(src, "<span class='notice'>There is something obstructing your destination!</span>")
			return

	visible_message("<span class='notice'>The [src] begins to climb [(direction == UP) ? "upwards" : "downwards"].</span>",
		"<span class='notice'>You begin to climb [(direction == UP) ? "upwards" : "downwards"].</span>")
	var/climb_chance = 50
	var/climb_speed = 45 SECONDS
	var/will_succeed = FALSE
	var/turf/stack_turf = get_turf(src) //turf upon which obejcts must be stacked upon to gain vantage
	var/speed_bonus = 0
	if(direction == DOWN)
		stack_turf = destination

	for(var/obj/O in stack_turf)
		if(O.w_class >= 4.0 || O.anchored) //if an object is anchored it's stable footing
			climb_chance = min(100, climb_chance + O.w_class) //large items increase your reach
			speed_bonus = min(15, speed_bonus + 1)
		else
			climb_chance = max(0, climb_chance - O.w_class) //small items destabilize your footing
			speed_bonus = max(0, speed_bonus - 1)
	if(climb_bonus)
		climb_chance = min(100, climb_chance + climb_bonus)


	if(prob(climb_chance))
		will_succeed = TRUE

	if(do_after(src, climb_speed, extra_checks  = CALLBACK(src, .proc/climb_check, will_succeed, climb_chance, climb_speed, direction, destination)))
		if(will_succeed)
			visible_message("<span class='noticed'>\The [src] climbs [(direction == UP) ? "upwards" : "downwards"].</span>",
				"<span class='noticed'>You climb [(direction == UP) ? "upwards" : "downwards"].</span>")
			forceMove(destination)
			return
		else
			visible_message("<span class='warning'>\The [src] slips and falls as they climb [(direction == UP) ? "upwards" : "downwards"]!</span>",
				"<span class='danger'>You slip and fall as you climb [(direction == UP) ? "upwards" : "downwards"]!</span>")
			if(direction == DOWN)
				Move(destination)
			fall_impact(1, damage_mod = min(1, max(0.2, ((100-climb_chance)/100) - 0.2)))

/mob/living/carbon/human/proc/climb_check(var/success, var/climb_chance, var/speed, var/direction, var/turf/destination) //purely for immersion and variety
	if((last_special < world.time) && !success) //if you will succeed you can't fail
		last_special = world.time + speed/10
		if(prob(100 - climb_chance)) //The worse you are the sooner you'll fail.
			visible_message("<span class='warning'>\The [src] slips and falls as they climb [(direction == UP) ? "upwards" : "downwards"]!</span>",
				"<span class='danger'>You slip and fall as you climb [(direction == UP) ? "upwards" : "downwards"]!</span>")
			if(direction == DOWN)
				Move(destination)
			fall_impact(1, damage_mod = min(1, max(0.2, ((100-climb_chance)/100) - 0.2)))
			return 0
	return 1

/mob/living/silicon/robot/can_ztravel(var/direction)
	if(incapacitated() || is_dead())
		return FALSE

	if(Allow_Spacemove()) //Checks for active jetpack
		return TRUE

	for(var/turf/simulated/T in trange(1,src)) //Robots get "magboots"
		if(T.density)
			return TRUE

/**
 * Used to determine whether or not a given mob can override gravity when
 * attempting to Z-move UP.
 *
 * Returns FALSE in standard mob cases. Exists for carbon/human and other child overrides.
 *
 * @return	TRUE if the mob can Z-move up despite gravity.
 *			FALSE otherwise.
 */
/mob/proc/CanAvoidGravity()
	return FALSE

// Humans and borgs have jetpacks which allows them to override gravity! Or rather,
// they can have them. So we override and check.
/mob/living/carbon/human/CanAvoidGravity()
	if (!restrained())
		var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && !lying && thrust.allow_thrust(0.01, src))
			return TRUE

	return ..()

/mob/living/silicon/robot/CanAvoidGravity()
	var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

	if (thrust && thrust.allow_thrust(0.02, src))
		return TRUE

	return ..()

/**
 * An overridable proc used by SSfalling to determine whether or not an atom
 * should continue falling to the next level, or stop processing and be caught
 * in midair, effectively. One of the ways to make things never fall is to make
 * this return FALSE.
 *
 * If the mob has fallen and is stopped amidst a fall by this, fall_impact is
 * invoked with the second argument being TRUE. As opposed to the default value, FALSE.
 *
 * @param	below The turf that the mob is expected to end up at.
 * @param	dest The tile we're presuming the mob to be at for this check. Default
 * value is src.loc, (src. is important there!) but this is used for magboot lookahead
 * checks it turf/simulated/open/Enter().
 *
 * @return	TRUE if the atom can continue falling in its present situation.
 *			FALSE if it should stop falling and not invoke fall_through or fall_impact
 * this cycle.
 */
/atom/movable/proc/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	if (!istype(dest) || !dest.is_hole)
		return FALSE

	// Anchored things don't fall.
	if(anchored)
		return FALSE

	// The var/climbers API is implemented here.
	if (LAZYLEN(dest.climbers) && (src in dest.climbers))
		return FALSE

	// True otherwise.
	return TRUE

/obj/effect/can_fall()
	return FALSE

/obj/effect/decal/cleanable/can_fall()
	return TRUE

/obj/item/pipe/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	. = ..()

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up in below))
		return FALSE

// Only things that stop mechas are atoms that, well, stop them.
// Lattices and stairs get crushed in fall_through.
/obj/mecha/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	// The var/climbers API is implemented here.
	if (LAZYLEN(dest.climbers) && (src in dest.climbers))
		return FALSE

	if (!dest.is_hole)
		return FALSE

	// See if something prevents us from falling.
	for(var/atom/A in below)
		if(!A.CanPass(src, dest))
			return FALSE

	// True otherwise.
	return TRUE

/mob/living/carbon/human/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	// Special condition for jetpack mounted folk!
	if (!restrained())
		var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

		if (thrust && thrust.stabilization_on &&\
			!lying && thrust.allow_thrust(0.01, src))
			return FALSE

	return ..()

/mob/living/carbon/human/bst/can_fall()
	return fall_override ? FALSE : ..()

/mob/eye/can_fall()
	return FALSE

/mob/living/silicon/robot/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	var/obj/item/weapon/tank/jetpack/thrust = GetJetpack(src)

	if (thrust && thrust.stabilization_on && thrust.allow_thrust(0.02, src))
		return FALSE

	return ..()


// Ladders and stairs pulling movement
/obj/structure/multiz/proc/try_resolve_mob_pulling(mob/M, obj/structure/multiz/ES)
	if(istype(M) && (ES && ES.istop == istop))
		var/list/moveWithMob = list()
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

/*


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

/mob/living/zMove(direction)
	if (is_ventcrawling)
		var/obj/machinery/atmospherics/pipe/zpipe/P = loc
		if (istype(P) && P.can_z_crawl(src, direction))
			return P.handle_z_crawl(src, direction)

	return ..()

/atom/proc/CanMoveOnto(atom/movable/mover, turf/target, height=1.5, direction = 0)
	//Purpose: Determines if the object can move through this
	//Uses regular limitations plus whatever we think is an exception for the purpose of
	//moving up and down z levles
	return CanPass(mover, target, height, 0) || (direction == DOWN)

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/carbon/human/can_overcome_gravity()
	if (incorporeal_move)
		return TRUE
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
	set category = "Ghost"
	zMove(UP)

/mob/observer/ghost/verb/movedown()
	set name = "Move Downwards"
	set category = "Ghost"
	zMove(DOWN)


*/