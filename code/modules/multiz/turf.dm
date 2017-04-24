/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = "black"
	density = 0
	plane = OPENSPACE_PLANE
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/turf/below
	var/list/underlay_references
	var/global/overlay_map = list()

/turf/simulated/open/initialize()
	..()
	below = GetBelow(src)
	ASSERT(HasBelow(z))

/turf/simulated/open/is_plating()
	return TRUE

/turf/simulated/open/is_space()
	var/turf/below = GetBelow(src)
	return !below || below.is_space()

/turf/simulated/open/Entered(var/atom/movable/mover)
	. = ..()

	if(!mover.can_fall())
		return

	// only fall down in defined areas (read: areas with artificial gravitiy)
	if(!istype(below)) //make sure that there is actually something below
		below = GetBelow(src)
		if(!below)
			return

	// No gravit, No fall.
	if(!has_gravity(src))
		return

	if(locate(/obj/structure/catwalk) in src)
		return

	if(locate(/obj/structure/multiz/stairs) in src)
		return

	// See if something prevents us from falling.
	var/soft = FALSE
	for(var/atom/A in below)
		if(A.can_prevent_fall())
			return

		// Dont break here, since we still need to be sure that it isnt blocked
		if(istype(A, /obj/structure/multiz/stairs))
			soft = TRUE

	// We've made sure we can move, now.
	mover.forceMove(below)

	if(mover.fall_sound)
		playsound(mover, mover.fall_sound, 100)

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
			if (istype(mover, /mob/living/carbon/human))
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
			user << "<span class='notice'>Constructing support lattice ...</span>"
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
			user << "<span class='warning'>The plating is going to need some support.</span>"
