/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/client/MouseDown(object,location,control,params)

	if (CH)
		if (!CH.MouseDown(object,location,control,params))
			return
	.=..()

/client/MouseUp(object,location,control,params)
	if (CH)
		if (!CH.MouseUp(object,location,control,params))
			return
	.=..()

/client/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	if (CH)
		if (!CH.MouseDrag(over_object,src_location,over_location,src_control,over_control,params))
			return
	.=..()


/client/Click(atom/target, location, control, params)
	var/list/L = params2list(params) //convert params into a list
	var/dragged = L["drag"] //grab what mouse button they are dragging with, if any.
	if(dragged && !L[dragged]) //check to ensure they aren't using drag clicks to aimbot
		return //if they are dragging, and they clicked with a different mouse button, reject the click as it will always go the atom they are currently dragging, even if out of view and not under the mouse

	if (CH)
		if (!CH.Click(target, location, control, params))
			return


	if(!target.Click(location, control, params))
		usr.ClickOn(target, params)

/atom/DblClick(location, control, params)
	if(src)
		usr.DblClickOn(src, params)

/*
	Standard mob ClickOn()
	Handles exceptions: Buildmode, middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom, adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item, user) - used only when adjacent
	* item/afterattack(atom, user, adjacent, params) - used both ranged and adjacent
	* mob/RangedAttack(atom, params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(atom/A, params)

	if(!can_click())
		return

	next_click = world.time + 1

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return 1
	if(modifiers["ctrl"] && modifiers["alt"])
		CtrlAltClickOn(A)
		return 1
	if(modifiers["middle"])
		if(modifiers["shift"])
			ShiftMiddleClickOn(A)
		else
			MiddleClickOn(A)
		return 1
	if(modifiers["shift"])
		SEND_SIGNAL(src, COMSIG_SHIFTCLICK, A)
		ShiftClickOn(A)
		return 0
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		SEND_SIGNAL(src, COMSIG_ALTCLICK, A)
		AltClickOn(A)
		return 1
	if(modifiers["ctrl"])
		SEND_SIGNAL(src, COMSIG_CTRLCLICK, A)
		CtrlClickOn(A)
		return 1

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A) // change direction to face what you clicked on



	if(istype(loc, /mob/living/exosuit))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from being drilled
			return
		var/mob/living/exosuit/M = loc
		return M.ClickOn(A)//, src)

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode)
		if(isturf(A) || isturf(A.loc))
			throw_item(A)
			return 1
		throw_mode_off()

	var/obj/item/W = get_active_hand()

	if(W == A) // Handle attack_self
		W.attack_self(src)
		return 1

	//Atoms on your person
	// A is your location but is not a turf; or is on you (backpack); or is on something on you (box in backpack); sdepth is needed here because contents depth does not equate inventory storage depth.
	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		// faster access to objects already on you
		if(W)
			var/resolved = (SEND_SIGNAL(W, COMSIG_IATTACK, A, src, params)) || (SEND_SIGNAL(A, COMSIG_ATTACKBY, W, src, params)) || W.resolve_attackby(A, src, params)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1 indicates adjacency
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, 1)
		return 1

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	if(W && !W.can_use_lying && src.lying)
		to_chat(src, SPAN_WARNING("You cannot use \the [W] while lying down!"))
		return 1

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in something on a turf (pen in a box); but not something in something on a turf (pen in a box in a backpack)
	sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = (SEND_SIGNAL(W, COMSIG_IATTACK, A, src, params)) || (SEND_SIGNAL(A, COMSIG_ATTACKBY, W, src, params)) || W.resolve_attackby(A, src, params)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params) // 1: clicking something Adjacent
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, 1)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A, src, 0, params) // 0: not Adjacent
			else
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN) // no ranged spam
				RangedAttack(A, params)
	return 1

/mob/proc/setClickCooldown(timeout)
	next_click = max(world.time + timeout, next_click)

/mob/proc/can_click()
	if(next_click <= world.time)
		return 1
	return 0

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/proc/DblClickOn(atom/A, params)
	return

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(atom/A, proximity_flag)
	return

/mob/living/UnarmedAttack(atom/A, proximity_flag)
	if(stat)
		return 0

	return 1

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(atom/A, params)
	if(!active_mutations.len)
		return
//	if((LASER in mutations) && a_intent == I_HURT)
//		LaserEyes(A) // moved into a proc below
	if(get_active_mutation(src, MUTATION_TELEKINESIS) && get_dist(src, A) <= tk_maxrange)
		A.attack_tk(src)

/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(atom/A)
	swap_hand()
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	pointed(A)

// In case of use break glass
/*
/atom/proc/MiddleClick(mob/M as mob)
	return
*/

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	if(user.client && user.client.eye == user)
		user.examinate(src)
	return

/*
	Control+Alt click
*/
/mob/proc/CtrlAltClickOn(atom/A)
	A.CtrlAltClick(src)
	return

/atom/proc/CtrlAltClick(mob/user)
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(mob/user)
	return

/atom/movable/CtrlClick(mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(mob/user)
	var/turf/T = get_turf(src)
	if(T && user.TurfAdjacent(T))
		user.listed_turf = T
		user.client.statpanel = "Turf"
	return 1

/mob/proc/TurfAdjacent(turf/T)
	return T.AdjacentQuick(src)

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(mob/user)
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A)
	return

/mob/living/LaserEyes(atom/A)
	setClickCooldown(4)
	var/turf/T = get_turf(src)

	var/obj/item/projectile/beam/LE = new (T)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	mob_playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)
	LE.launch(A)

/mob/living/carbon/human/LaserEyes()
	if(nutrition>0)
		..()
		nutrition = max(nutrition - rand(1, 5), 0)
		handle_regular_hud_updates()
	else
		to_chat(src, SPAN_WARNING("You're out of energy!  You need food!"))

// Simple helper to face what you clicked on, in case it should be needed in more than one place
/atom/movable/proc/face_atom(atom/A)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction = NORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction != dir)
		facedir(direction)


/atom/movable/proc/facedir(ndir)
	set_dir(ndir)
	return 1



GLOBAL_LIST_INIT(click_catchers, create_click_catcher())

/obj/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"

/obj/screen/click_catcher/Destroy()
	return QDEL_HINT_LETMELIVE

/obj/screen/click_catcher/New(_name = "", mob/living/_parentmob, _icon, _icon_state)
	..()

/proc/create_click_catcher()
	. = list()
	for(var/i = 0, i<15, i++)
		for(var/j = 0, j<15, j++)
			var/obj/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(screen_loc, get_turf(usr))
		if(T)
			usr.client.Click(T, location, control, params)
			//T.Click(location, control, params)
			//Bay system doesnt use client.click, not sure if better

	. = 1

/obj/screen/click_catcher/proc/resolve(mob/user)
	var/turf/T = screen_loc2turf(screen_loc, get_turf(user))
	return T
