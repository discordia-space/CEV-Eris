/*
/// Only permits mob to buckle
#define BUCKLE_MOB_ONLY 1<<0
	/// Forces the buckled to lie if its a mob
	#define BUCKLE_FORCE_LIE 1<<1
	/// Forces the buckled to stand if its a mob
	#define BUCKLE_FORCE_STAND 1<<2
	/// Forces the dir of the buckled if its a mob
	#define BUCKLE_FORCE_DIR 1<<3
	/// Relays any move attempts of the buckled if its a mob to the owner
	#define BUCKLE_MOVE_RELAY 1<<4
	/// Wheter the component should handle the layer
	#define BUCKLE_HANDLE_LAYER 1<<5
	/// Wheter the buckled atom gets pixel shifted
	#define BUCKLE_PIXEL_SHIFT 1<<6
	/// Only permitted to be done if the target is restrained
	#define BUCKLE_REQUIRE_RESTRAINTED 1<<7
	/// Doesn't permit buckling if the size of the buckler is the smaller than that of the buckled
	#define BUCKLE_REQUIRE_BIGGER_BUCKLER 1<<8
	/// Wheter we require the target is not buckle to something else.
	#define BUCKLE_REQUIRE_NOT_BUCKLED 1<<9
	// For breakng whenever we fall z-levels
	#define BUCKLE_BREAK_ON_FALL 1<<10
	/// For letting the owner handle all unbuckling behavior
	#define BUCKLE_CUSTOM_UNBUCKLE 1<<11
	/// For letting the owner handle all buckling behavior
	#define BUCKLE_COSTUM_BUCKLE 1<<12
	/// For calling a proc on the owner after buckling/unbuckling
	#define BUCKLE_SEND_UPDATES 1<<13
*/


/// Indexes for the visual handling list
#define I_PIXEL_X 1
#define I_PIXEL_Y 2
#define I_LAYER 3

/// Doesn't have handling for atoms buckling stuff. Add it yourself if you need it. This is mostly just a saner way to handle atom buckling - SPCR 2023
/datum/component/buckling
	var/atom/owner
	var/atom/movable/buckled
	var/buckleFlags = BUCKLE_FORCE_LIE | BUCKLE_MOB_ONLY | BUCKLE_REQUIRE_NOT_BUCKLED
	/// Proc to call on owner when movement attempts are detected, will pass the mob as its first argument and direction as second
	var/moveProc
	/// Proc to call on owner after buckling/unbuckling, will pass the buckled/unbuckled mob as an argument
	var/updateProc
	var/list/visualHandling
	/* List format to be followed
	var/list/visualHandling = list(
		NORTH = list(0,0,0),
		SOUTH = list(0,0,0),
		EAST = list(0,0,0),
		WEST = list(0,0,0)
	)
	*/
	dupe_mode = COMPONENT_DUPE_HIGHLANDER
	can_transfer = FALSE

/datum/component/buckling/Initialize(buckleFlags, moveProc, visualHandling, ...)
	. = ..()
	if(!istype(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	src.moveProc = moveProc
	if(buckleFlags)
		src.buckleFlags = buckleFlags
	if(visualHandling)
		src.visualHandling = visualHandling
	// Relaying and moving the buckled
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(onOwnerMove))
	// Falling
	if(buckleFlags & BUCKLE_BREAK_ON_FALL)
		RegisterSignal(owner, COMSIG_MOVABLE_FALLED, PROC_REF(onOwnerFall))
	// Buckling stuff
	if(!(buckleFlags & BUCKLE_CUSTOM_BUCKLE))
		RegisterSignal(owner, COMSIG_DRAGDROP, PROC_REF(onOwnerDragDrop))
	// Unbuckling stuff
	if(!(buckleFlags & BUCKLE_CUSTOM_UNBUCKLE))
		RegisterSignal(owner, COMSIG_CLICKED, PROC_REF(onOwnerClicked))


/datum/component/buckling/proc/unbuckle()
	var/reference = buckled
	if(!QDELETED(buckled))
		UnregisterSignal(buckled, list(COMSIG_BUCKLE_QUERY, COMSIG_MOB_TRY_MOVE))
		if(buckleFlags & BUCKLE_PIXEL_SHIFT)
			animate(buckled, 0.2 SECONDS, pixel_x = initial(buckled.pixel_x), pixel_y = initial(buckled.pixel_y))
		if(buckleFlags & BUCKLE_HANDLE_LAYER)
			buckled.layer = initial(buckled.layer)
		if(ismob(buckled))
			var/mob/living/buckledMob = buckled
			buckledMob.update_lying_buckled_and_verb_status()
			buckledMob.update_floating()
	buckled = null
	if(buckleFlags & BUCKLE_SEND_UPDATES && !QDELETED(buckled))
		INVOKE_ASYNC(owner, updateProc, reference)

/datum/component/buckling/proc/buckle(atom/movable/target, mob/user)
	if(buckleFlags & BUCKLE_REQUIRE_NOT_BUCKLED)
		var/list/bucklers = list()
		SEND_SIGNAL(target, COMSIG_BUCKLE_QUERY, bucklers)
		if(length(bucklers))
			if(user)
				to_chat(user, SPAN_NOTICE("\The [target] is already buckled onto something else!"))
			return
	if(buckleFlags & BUCKLE_MOB_ONLY)
		var/mob/toBuckle = target
		if(!istype(toBuckle))
			return
		if(toBuckle.a_intent == I_HURT && !toBuckle.incapacitated(INCAPACITATION_CANT_ACT) && toBuckle != user)
			to_chat(target,  SPAN_NOTICE("You resist the buckling attempt from \the [target]"))
			if(ishuman(target))
				var/mob/living/carbon/human/targ = target
				targ.adjustEnergy(-10)
			if(user)
				to_chat(user, SPAN_NOTICE("\The [toBuckle] is resisting buckling attempts!"))
				var/mob/living/carbon/human/userMan = user
				userMan.adjustEnergy(-15)

		if((buckleFlags & BUCKLE_REQUIRE_RESTRAINTED) && !toBuckle.incapacitated(INCAPACITATION_RESTRAINED))
			if(user)
				to_chat(user, SPAN_NOTICE("\The [toBuckle] has to be restrained first!"))
			return
		if((buckleFlags & BUCKLE_REQUIRE_BIGGER_BUCKLER) && toBuckle.mob_size > user.mob_size)
			if(user)
				to_chat(user, SPAN_NOTICE("\The [toBuckle] is too big for you to buckle!"))
			return
		if(!(toBuckle.Adjacent(owner)))
			if(user)
				to_chat(user, SPAN_NOTICE("\The [toBuckle] has to be near \the [owner] to buckle!"))
			return
		if(toBuckle.grabbedBy)
			var/obj/item/grab/grabby = toBuckle.grabbedBy
			if(grabby.assailant != user)
				to_chat(user, SPAN_NOTICE("\The [toBuckle] is grabbed by [grabby.assailant]!"))
				return
			else
				// delete our own grab
				QDEL_NULL(grabby)
		toBuckle.forceMove(get_turf(owner))
		if(user)
			to_chat(user, SPAN_NOTICE("You buckle \the [toBuckle] to the [owner]!"))
		buckled = target
		RegisterSignal(toBuckle, COMSIG_BUCKLE_QUERY, PROC_REF(onBuckleQuery))
		if(buckleFlags & BUCKLE_MOVE_RELAY)
			RegisterSignal(buckled, COMSIG_MOB_TRY_MOVE, PROC_REF(onBuckledMoveTry))
		if(buckleFlags & BUCKLE_FORCE_DIR)
			buckled.dir = owner.dir
		// force stand and force lie are handled in mob status updates since its where they're relevant
		if(buckleFlags & BUCKLE_PIXEL_SHIFT)
			animate(buckled, 0.2 SECONDS, pixel_x = visualHandling["[buckled.dir]"][I_PIXEL_X], pixel_y = visualHandling["[buckled.dir]"][I_PIXEL_Y])
		if(buckleFlags & BUCKLE_HANDLE_LAYER)
			buckled.layer = visualHandling["[buckled.dir]"][I_LAYER]
		toBuckle.facing_dir = null
		INVOKE_ASYNC(toBuckle, "update_lying_buckled_and_verb_status")
		INVOKE_ASYNC(toBuckle, "update_floating")
		if(buckleFlags & BUCKLE_SEND_UPDATES)
			INVOKE_ASYNC(owner, updateProc, buckled)

/datum/component/buckling/proc/onBuckleQuery(atom/sender, list/reference)
	SIGNAL_HANDLER
	reference.Add(src)

/datum/component/buckling/proc/onOwnerMove(atom/movable/mover, atom/oldLocation, atom/newLocation, atom/initiator)
	SIGNAL_HANDLER
	if(buckled)
		if(buckleFlags & BUCKLE_FORCE_DIR)
			buckled.dir = owner.dir
		if(buckleFlags & BUCKLE_PIXEL_SHIFT)
			animate(buckled, 0.2 SECONDS, pixel_x = visualHandling["[buckled.dir]"][I_PIXEL_X], pixel_y = visualHandling["[buckled.dir]"][I_PIXEL_Y])
		if(buckleFlags & BUCKLE_HANDLE_LAYER)
			buckled.layer = visualHandling["[buckled.dir]"][I_LAYER]
		INVOKE_ASYNC(buckled, "forceMove", newLocation, null, null, src )

/datum/component/buckling/proc/onOwnerFall(atom/movable/fallen, softLanding)
	SIGNAL_HANDLER
	if(softLanding)
		return
	var/turf/above = GetAbove(fallen)
	fallen.fall_impact(above, get_turf(fallen))
	if(!QDELETED(fallen))
		INVOKE_ASYNC(src, PROC_REF(unbuckle))
		step(fallen, pick(NORTH,SOUTH,EAST,WEST))


/datum/component/buckling/proc/onOwnerDragDrop(atom/draggedOverAtom, atom/draggedIntoAtom, mob/living/user, src_location, over_location, src_control, over_control, params)
	SIGNAL_HANDLER
	if(!istype(user) || !draggedIntoAtom)
		return
	if(user.incapacitated(INCAPACITATION_CANT_ACT))
		return
	if(!user.Adjacent(owner) || !draggedIntoAtom.Adjacent(owner))
		return
	if(buckled)
		to_chat(user, SPAN_NOTICE("\The [owner] is already buckling \the [buckled]. You need to unbuckle it first to buckle \the [draggedIntoAtom]"))
		return
	INVOKE_ASYNC(src, PROC_REF(buckle), draggedIntoAtom, user)

/datum/component/buckling/proc/onOwnerClicked(atom/clicked, mob/living/clicker, params)
	SIGNAL_HANDLER
	if(!istype(clicker))
		return
	if(!clicker.Adjacent(owner))
		return
	if(clicker.incapacitated(INCAPACITATION_CANT_ACT))
		return
	if(!buckled)
		to_chat(clicker, SPAN_NOTICE("There is nothing to unbuckle on \the [owner]!"))
		return
	if(clicker == buckled)
		to_chat(clicker, SPAN_NOTICE("You unbuckle yourself from \the [owner]"))
	else
		to_chat(clicker, SPAN_NOTICE("You unbuckle \the [buckled] from \the [owner]!"))
	INVOKE_ASYNC(src, PROC_REF(unbuckle))

// By default we cancel any movement and let the buckled handle it if it has a move proc(wheelchairs)
/datum/component/buckling/proc/onBuckledMoveTry(atom/movable/mover, direction)
	SIGNAL_HANDLER
	. = COMSIG_CANCEL_MOVE
	if(buckleFlags & BUCKLE_MOVE_RELAY)
		return call(owner, moveProc)(mover, direction)

/datum/component/buckling/Destroy(force, silent)
	if(buckled)
		unbuckle()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DRAGDROP, COMSIG_CLICKED))
	owner = null
	if(visualHandling)
		del(visualHandling)
	. = ..()
