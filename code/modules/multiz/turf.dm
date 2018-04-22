/*
see multiz/movement.dm for some info.
*/
/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/simulated/open/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

/turf/space/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1
/////////////////////////////////////

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = "black"
	density = 0
	plane = OPENSPACE_PLANE
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/open = FALSE
	var/turf/below
	var/list/underlay_references
	var/global/overlay_map = list()

/turf/simulated/open/LateInitialize()
	. = ..()
	below = GetBelow(src)
	ASSERT(HasBelow(z))
	update_icon()

/turf/simulated/open/is_plating()
	return TRUE

/turf/simulated/open/is_space()
	var/turf/below = GetBelow(src)
	return !below || below.is_space()

/turf/simulated/open/Entered(var/atom/movable/mover)
	. = ..()
	if(open)
		fallThrough(mover)

/turf/simulated/open/proc/updateFallability()
	var/wasOpen = open
	open = isOpen()
	if(open && open != wasOpen)
		for(var/atom/A in src)
			fallThrough(A)

/turf/simulated/open/proc/isOpen()
	. = FALSE
	// only fall down in defined areas (read: areas with artificial gravitiy)
	if(!istype(below)) //make sure that there is actually something below
		below = GetBelow(src)
		if(!below)
			return

	if(locate(/obj/structure/catwalk) in src)
		return

	if(locate(/obj/structure/multiz/stairs) in src)
		return

	for(var/atom/A in below)
		if(A.can_prevent_fall())
			return

	return TRUE

/turf/simulated/open/proc/fallThrough(var/atom/movable/mover)
	if(!mover.can_fall())
		return

	// No gravit, No fall.
	if(!has_gravity(src))
		return

	// See if something prevents us from falling.
	var/soft = FALSE
	for(var/atom/A in below)
		// Dont break here, since we still need to be sure that it isnt blocked
		if(istype(A, /obj/structure/multiz/stairs))
			soft = TRUE

	// We've made sure we can move, now.
	mover.forceMove(below)

	if(ishuman(mover) && mover.gender == MALE && prob(5))
		playsound(src, 'sound/hallucinations/scream.ogg', 100)

	if(!soft)
		if(!isliving(mover))
			if(istype(below, /turf/simulated/open))
				mover.visible_message(
					"\The [mover] falls from the deck above through \the [below]!",
					"You hear a whoosh of displaced air."
				)
			else
				mover.visible_message(
					"\The [mover] falls from the deck above and slams into \the [below]!",
					"You hear something slam into the deck."
				)
		else
			var/mob/M = mover
			if(istype(below, /turf/simulated/open))
				below.visible_message(
					"\The [mover] falls from the deck above through \the [below]!",
					"You hear a soft whoosh.[M.stat ? "" : ".. and some screaming."]"
				)
			else
				M.visible_message(
					"\The [mover] falls from the deck above and slams into \the [below]!",
					"You land on \the [below].", "You hear a soft whoosh and a crunch"
				)

			// Handle people getting hurt, it's funny!
			if (ishuman(mover))
				var/mob/living/carbon/human/H = mover
				var/damage = 5
				for(var/organ in list(BP_CHEST, BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG))
					H.apply_damage(rand(0, damage), BRUTE, organ)

				H.Weaken(4)
				H.updatehealth()

		var/fall_damage = mover.get_fall_damage()
		for(var/mob/living/M in below)
			if(M == mover)
				continue
			M.Weaken(10)
			if(fall_damage >= FALL_GIB_DAMAGE)
				M.gib()
			else
				for(var/organ in list(BP_HEAD, BP_CHEST, BP_R_ARM, BP_L_ARM))
					M.apply_damage(rand(0, fall_damage), BRUTE, organ)

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

// Straight copy from space.
/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			user << SPAN_NOTICE("Constructing support lattice ...")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			user << SPAN_WARNING("The plating is going to need some support.")
