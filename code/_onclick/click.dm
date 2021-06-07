/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
//This is mainly modified by click code, to modify click delays elsewhere, use next_move and setClickCooldown()
/mob/var/next_click = 0

/**
 * Before anything else, defer these calls to a per-mobtype handler.  This allows us to
 * remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.
 *
 * Alternately, you could hardcode every mob's variation in a flat [/mob/proc/ClickOn] proc; however,
 * that's a lot of code duplication and is hard to maintain.
 *
 * Note that this proc can be overridden, and is in the case of screen objects.
 */
/atom/Click(location,control,params)
	if((flags_1 & INITIALIZED_1) || initialized)
		SEND_SIGNAL(src, COMSIG_CLICK, location, control, params, usr)
		usr.ClickOn(src, params)

/atom/DblClick(location,control,params)
	if((flags_1 & INITIALIZED_1) || initialized)
		usr.DblClickOn(src,params)

/atom/MouseWheel(delta_x,delta_y,location,control,params)
	if((flags_1 & INITIALIZED_1) || initialized)
		usr.MouseWheelOn(src, delta_x, delta_y, params)

/**
 * Standard mob ClickOn()
 * Handles exceptions: Buildmode, middle click, modified clicks, mech actions
 *
 * After that, mostly just check your state, check whether you're holding an item,
 * check whether you're adjacent to the target, then pass off the click to whoever
 * is receiving it.
 * The most common are:
 * * [mob/proc/UnarmedAttack] (atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
 * * [atom/proc/attackby] (item,user) - used only when adjacent
 * * [obj/item/proc/afterattack] (atom,user,adjacent,params) - used both ranged and adjacent
 * * [mob/proc/RangedAttack] (atom,modifiers) - used only ranged, only used for tk and laser eyes but could be changed
 */
/mob/proc/ClickOn( atom/A, params )
	if(!can_click())
		return
	next_click = world.time + 1

	// if(check_click_intercept(params,A))
	// 	return

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	if(transforming)
		return

	if(SEND_SIGNAL(src, COMSIG_MOB_CLICKON, A, params) & COMSIG_MOB_CANCEL_CLICKON)
		return
	var/list/modifiers = params2list(params)
	// if(LAZYACCESS(modifiers, "right"))
	// 	if(RightClickOn(A))
	// 		return
	if(LAZYACCESS(modifiers, "shift"))
		if(LAZYACCESS(modifiers, "middle"))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, "ctrl"))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, "middle"))
		MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, "alt")) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(LAZYACCESS(modifiers, "ctrl"))
		CtrlClickOn(A)
		return

	if(incapacitated((INCAPACITATION_STUNNED|INCAPACITATION_UNCONSCIOUS|INCAPACITATION_BUCKLED_PARTIALLY|INCAPACITATION_BUCKLED_FULLY)))
		return

	face_atom(A)

	if(next_move > world.time) // in the year 2000...
		return

	if(!LAZYACCESS(modifiers, "catcher") && A.IsObscured())
		return

	if(restrained()) //HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		setClickCooldown(10)   //Doing shit in cuffs shall be vey slow
		UnarmedAttack(A, FALSE, modifiers)
		return

	if(in_throw_mode)
		setClickCooldown(10)
		throw_item(A)
		return

	var/obj/item/W = get_active_hand()

	if(W == A)
		W.attack_self(src, modifiers)
		// update_inv_hands()
		return

	//These are always reachable.
	//User itself, current loc, and user inventory
	if(A in DirectAccess())
		if(W)
			W.melee_attack_chain(src, A, params)
		else
			if(ismob(A))
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, FALSE, modifiers)
		return

	//Can't reach anything else in lockers or other weirdness
	if(!loc.AllowClick())
		return

	//Standard reach turf to turf or reaching inside storage
	if(CanReach(A,W))
		if(W)
			W.melee_attack_chain(src, A, params)
		else
			if(ismob(A))
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A,1,modifiers)
	else
		if(W)
			W.afterattack(A,src,0,params)
		else
			RangedAttack(A,modifiers)

/// Is the atom obscured by a PREVENT_CLICK_UNDER_1 object above it
/atom/proc/IsObscured()
	SHOULD_BE_PURE(TRUE)
	if(!isturf(loc)) //This only makes sense for things directly on turfs for now
		return FALSE
	var/turf/T = get_turf_pixel(src)
	if(!T)
		return FALSE
	for(var/atom/movable/AM in T)
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1 && AM.density && AM.layer > layer)
			return TRUE
	return FALSE

/turf/IsObscured()
	for(var/item in src)
		var/atom/movable/AM = item
		if(AM.flags_1 & PREVENT_CLICK_UNDER_1)
			return TRUE
	return FALSE

/**
 * A backwards depth-limited breadth-first-search to see if the target is
 * logically "in" anything adjacent to us.
 */
/atom/movable/proc/CanReach(atom/ultimate_target, obj/item/tool, view_only = FALSE)
	var/list/direct_access = DirectAccess()
	var/depth = 1 + (view_only ? 2 : 3)

	var/list/closed = list()
	var/list/checking = list(ultimate_target)
	while (checking.len && depth > 0)
		var/list/next = list()
		--depth

		for(var/atom/target in checking)  // will filter out nulls
			if(closed[target] || isarea(target))  // avoid infinity situations
				continue
			closed[target] = TRUE
			if(isturf(target) || isturf(target.loc) || (target in direct_access) || (ismovable(target) && target.flags_1 & IS_ONTOP_1)) //Directly accessible atoms
				if(Adjacent(target)) // || (tool && CheckToolReach(src, target, tool.reach))) //Adjacent or reaching attacks
					return TRUE

			if (!target.loc)
				continue

			//Storage and things with reachable internal atoms need add to next here. Or return COMPONENT_ALLOW_REACH.
			// if(SEND_SIGNAL(target.loc, COMSIG_ATOM_CANREACH, next) & COMPONENT_ALLOW_REACH)
			// 	next += target.loc

		checking = next
	return FALSE

/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess(atom/target)
	return ..() + contents

/mob/living/DirectAccess(atom/target)
	return ..() + GetAllContents()

/atom/proc/AllowClick()
	return FALSE

/turf/AllowClick()
	return TRUE

/// Default behavior: ignore double clicks (the second click that makes the doubleclick call already calls for a normal click)
/mob/proc/DblClickOn(atom/A, params)
	return

/mob/proc/setClickCooldown(var/timeout)
	next_click = max(world.time + timeout, next_click)

/mob/proc/can_click()
	if(next_click <= world.time)
		return 1
	return 0

/**
 * Translates into [atom/proc/attack_hand], etc.
 *
 * Note: proximity_flag here is used to distinguish between normal usage (flag=1),
 * and usage when clicking on things telekinetically (flag=0).  This proc will
 * not be called at ranged except with telekinesis.
 *
 * proximity_flag is not currently passed to attack_hand, and is instead used
 * in human click code to allow glove touches only at melee range.
 *
 * modifiers is a lazy list of click modifiers this attack had,
 * used for figuring out different properties of the click, mostly right vs left and such.
 */
/mob/proc/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	if(ismob(A))
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	return

/**
 * Ranged unarmed attack:
 *
 * This currently is just a default for all mobs, involving
 * laser eyes and telekinesis.  You could easily add exceptions
 * for things like ranged glove touches, spitting alien acid/neurotoxin,
 * animals lunging, etc.
 */
/mob/proc/RangedAttack(atom/A, modifiers)
	// if(SEND_SIGNAL(src, COMSIG_MOB_ATTACK_RANGED, A, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
	// 	return TRUE

	if(!mutations.len)
		return
	if((LASER in mutations) && a_intent == I_HURT)
		LaserEyes(A) // moved into a proc below
	else if(TK in mutations)
		var/d = (get_dist(src, A))
		if (d == 0)
			return
		if (d <= tk_maxrange)
			A.attack_tk(src)

/**
 * Middle click
 * Mainly used for swapping hands
 */
/mob/proc/MiddleClickOn(atom/A, params)
	. = SEND_SIGNAL(src, COMSIG_MOB_MIDDLECLICKON, A, params)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	swap_hand()

/**
 * Shift click
 * For most mobs, examine.
 * This is overridden in ai.dm
 */
/mob/proc/ShiftClickOn(atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(mob/user)
	var/flags = SEND_SIGNAL(src, COMSIG_CLICK_SHIFT, user)
	if(user.client && (user.client.eye == user || user.client.eye == user.loc || flags & COMPONENT_ALLOW_EXAMINATE))
		user.examinate(src)
	return

/**
 * Ctrl click
 * For most objects, pull
 */
/mob/proc/CtrlClickOn(atom/A)
	A.CtrlClick(src)
	return

/atom/proc/CtrlClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user)
	SEND_SIGNAL(user, COMSIG_MOB_CTRL_CLICKED, src)
	var/mob/living/ML = user
	if(istype(ML))
		ML.pulled(src)

/mob/living/CtrlClick(mob/user)
	if(!isliving(user) || !Adjacent(user) || user.incapacitated())
		return ..()

	if(world.time < user.next_move)
		return FALSE
	// cqc
	// var/mob/living/user_living = user
	// if(user_living.apply_martial_art(src, null, is_grab=TRUE) == MARTIAL_ATTACK_SUCCESS)
	// 	user_living.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	// 	return TRUE

	return ..()

/mob/living/carbon/human/CtrlClick(mob/user)

	if(!ishuman(user) ||!Adjacent(user) || user.incapacitated())
		return ..()

	if(world.time < user.next_move)
		return FALSE
	// tk grabbies
	// var/mob/living/carbon/human/human_user = user
	// if(human_user.dna.species.grab(human_user, src, human_user.mind.martial_art))
	// 	human_user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	// 	return TRUE

	return ..()

/**
 * Alt click
 * Unused except for AI
 */
/mob/proc/AltClickOn(atom/A)
	. = SEND_SIGNAL(src, COMSIG_MOB_ALTCLICKON, A)
	if(. & COMSIG_MOB_CANCEL_CLICKON)
		return
	A.AltClick(src)

/atom/proc/AltClick(mob/user)
	if(SEND_SIGNAL(src, COMSIG_CLICK_ALT, user) & COMPONENT_CANCEL_CLICK_ALT)
		return
	var/turf/T = get_turf(src)
	if(T && (isturf(loc) || isturf(src)) && user.TurfAdjacent(T))
		user.listed_turf = T
		user.client << output("[url_encode(json_encode(T.name))];", "statbrowser:create_listedturf")

/mob/proc/TurfAdjacent(turf/T)
	return T.Adjacent(src)

/mob/living/UnarmedAttack(var/atom/A, var/proximity_flag)
	if(stat)
		return 0

	return 1

/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	pointed(A)

/*
	Control+Alt click
*/
/mob/proc/CtrlAltClickOn(var/atom/A)
	A.CtrlAltClick(src)
	return

/atom/proc/CtrlAltClick(var/mob/user)
	return
/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(var/atom/A)
	A.CtrlShiftClick(src)
	return

/atom/proc/CtrlShiftClick(var/mob/user)
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
/atom/movable/proc/face_atom(var/atom/A)
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


/atom/movable/proc/facedir(var/ndir)
	set_dir(ndir)
	return 1



//debug
/obj/screen/proc/scale_to(x1,y1)
	if(!y1)
		y1 = x1
	var/matrix/M = new
	M.Scale(x1,y1)
	transform = M

/obj/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	screen_loc = "CENTER"

#define MAX_SAFE_BYOND_ICON_SCALE_TILES (MAX_SAFE_BYOND_ICON_SCALE_PX / world.icon_size)
#define MAX_SAFE_BYOND_ICON_SCALE_PX (33 * 32) //Not using world.icon_size on purpose.

/obj/screen/click_catcher/proc/UpdateGreed(view_size_x = 15, view_size_y = 15)
	var/icon/newicon = icon('icons/mob/screen_gen.dmi', "click_catcher")
	var/ox = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_x)
	var/oy = min(MAX_SAFE_BYOND_ICON_SCALE_TILES, view_size_y)
	var/px = view_size_x * world.icon_size
	var/py = view_size_y * world.icon_size
	var/sx = min(MAX_SAFE_BYOND_ICON_SCALE_PX, px)
	var/sy = min(MAX_SAFE_BYOND_ICON_SCALE_PX, py)
	newicon.Scale(sx, sy)
	icon = newicon
	screen_loc = "CENTER-[(ox-1)*0.5],CENTER-[(oy-1)*0.5]"
	var/matrix/M = new
	M.Scale(px/sx, py/sy)
	transform = M

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, "middle") && iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(LAZYACCESS(modifiers, "screen-loc"), get_turf(usr.client ? usr.client.eye : usr))
		params += "&catcher=1"
		if(T)
			T.Click(location, control, params)
	. = 1
/// USED BY CRINGE /datum/click_handler
/obj/screen/click_catcher/proc/resolve(mob/user)
	var/turf/T = screen_loc2turf(screen_loc, get_turf(user))
	return T

/// MouseWheelOn
/mob/proc/MouseWheelOn(atom/A, delta_x, delta_y, params)
	SEND_SIGNAL(src, COMSIG_MOUSE_SCROLL_ON, A, delta_x, delta_y, params)


/mob/living/carbon/human/proc/absolute_grab(mob/living/carbon/human/T)
	if(!ishuman(T))
		return
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return
	if(l_hand && r_hand)
		to_chat(src, SPAN_DANGER("You need to have one hand free to grab someone."))
		return

	if(!T || !src || src.stat)
		return
	if(get_dist(get_turf(T), get_turf(src)) < 2)
		return
	if(get_dist_euclidian(get_turf(T), get_turf(src)) >= 3)
		return
	if(last_special > world.time)
		return
	last_special = world.time + 75
	status_flags |= LEAPING
	src.visible_message(SPAN_DANGER("\The [src] leaps at [T]!"))
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	mob_playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)
	sleep(5)
	if(status_flags & LEAPING)
		status_flags &= ~LEAPING

		if(!src.Adjacent(T))
			to_chat(src, SPAN_WARNING("You miss!"))
			Weaken(3)
			return
		T.attack_hand(src)
