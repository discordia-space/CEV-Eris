/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond69ob/next_move)
/mob/var/next_click = 0

/*
	Before anythin69 else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spa69hetti code, but re69uires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every69ob's69ariation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to69aintain.

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

/client/MouseDra69(over_object,src_location,over_location,src_control,over_control,params)
	if (CH)
		if (!CH.MouseDra69(over_object,src_location,over_location,src_control,over_control,params))
			return
	.=..()


/client/Click(var/atom/tar69et, location, control, params)
	var/list/L = params2list(params) //convert params into a list
	var/dra6969ed = L69"dra69"69 //69rab what69ouse button they are dra6969in69 with, if any.
	if(dra6969ed && !L69dra6969e6969) //check to ensure they aren't usin69 dra69 clicks to aimbot
		return //if they are dra6969in69, and they clicked with a different69ouse button, reject the click as it will always 69o the atom they are currently dra6969in69, even if out of69iew and69ot under the69ouse

	if (CH)
		if (!CH.Click(tar69et, location, control, params))
			return


	if(!tar69et.Click(location, control, params))
		usr.ClickOn(tar69et, params)

/atom/DblClick(var/location,69ar/control,69ar/params)
	if(src)
		usr.DblClickOn(src, params)

/*
	Standard69ob ClickOn()
	Handles exceptions: Buildmode,69iddle click,69odified clicks,69ech actions

	After that,69ostly just check your state, check whether you're holdin69 an item,
	check whether you're adjacent to the tar69et, then pass off the click to whoever
	is recievin69 it.
	The69ost common are:
	*69ob/UnarmedAttack(atom, adjacent) - used here only when adjacent, with69o item in hand; in the case of humans, checks 69loves
	* atom/attackby(item, user) - used only when adjacent
	* item/afterattack(atom, user, adjacent, params) - used both ran69ed and adjacent
	*69ob/Ran69edAttack(atom, params) - used only ran69ed, only used for tk and laser eyes but could be chan69ed
*/
/mob/proc/ClickOn(var/atom/A,69ar/params)

	if(!can_click())
		return

	next_click = world.time + 1

	if(client.buildmode)
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers69"shift6969 &&69odifiers69"ctr69"69)
		CtrlShiftClickOn(A)
		return 1
	if(modifiers69"ctrl6969 &&69odifiers69"al69"69)
		CtrlAltClickOn(A)
		return 1
	if(modifiers69"middle6969)
		if(modifiers69"shift6969)
			ShiftMiddleClickOn(A)
		else
			MiddleClickOn(A)
		return 1
	if(modifiers69"shift6969)
		ShiftClickOn(A)
		return 0
	if(modifiers69"alt6969) // alt and alt-69r (ri69htalt)
		AltClickOn(A)
		return 1
	if(modifiers69"ctrl6969)
		CtrlClickOn(A)
		return 1

	if(stat || paralysis || stunned || weakened)
		return

	face_atom(A) // chan69e direction to face what you clicked on



	if(istype(loc, /mob/livin69/exosuit))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from bein69 drilled
			return
		var/mob/livin69/exosuit/M = loc
		return69.ClickOn(A)//, src)

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode)
		if(isturf(A) || isturf(A.loc))
			throw_item(A)
			return 1
		throw_mode_off()

	var/obj/item/W = 69et_active_hand()

	if(W == A) // Handle attack_self
		W.attack_self(src)
		return 1

	//Atoms on your person
	// A is your location but is69ot a turf; or is on you (backpack); or is on somethin69 on you (box in backpack); sdepth is69eeded here because contents depth does69ot e69uate inventory stora69e depth.
	var/sdepth = A.stora69e_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		// faster access to objects already on you
		if(W)
			var/resolved = (SEND_SI69NAL(W, COMSI69_IATTACK, A, src, params)) || (SEND_SI69NAL(A, COMSI69_ATTACKBY, W, src, params)) || W.resolve_attackby(A, src, params)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1 indicates adjacency
		else
			if(ismob(A)) //69o instant69ob attackin69
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, 1)
		return 1

	if(!isturf(loc)) // This is 69oin69 to stop you from telekinesin69 from inside a closet, but I don't shed69any tears for that
		return

	if(W && !W.can_use_lyin69 && src.lyin69)
		to_chat(src, SPAN_WARNIN69("You cannot use \the 696969 while lyin69 down!"))
		return 1

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in somethin69 on a turf (pen in a box); but69ot somethin69 in somethin69 on a turf (pen in a box in a backpack)
	sdepth = A.stora69e_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely69ovin69 items for example)
				var/resolved = (SEND_SI69NAL(W, COMSI69_IATTACK, A, src, params)) || (SEND_SI69NAL(A, COMSI69_ATTACKBY, W, src, params)) || W.resolve_attackby(A, src, params)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params) // 1: clickin69 somethin69 Adjacent
			else
				if(ismob(A)) //69o instant69ob attackin69
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, 1)
			return
		else //69on-adjacent click
			if(W)
				W.afterattack(A, src, 0, params) // 0:69ot Adjacent
			else
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //69o ran69ed spam
				Ran69edAttack(A, params)
	return 1

/mob/proc/setClickCooldown(var/timeout)
	next_click =69ax(world.time + timeout,69ext_click)

/mob/proc/can_click()
	if(next_click <= world.time)
		return 1
	return 0

// Default behavior: i69nore double clicks, the second click that69akes the doubleclick call already calls for a69ormal click
/mob/proc/DblClickOn(var/atom/A,69ar/params)
	return

/*
	Translates into attack_hand, etc.

	Note: proximity_fla69 here is used to distin69uish between69ormal usa69e (fla69=1),
	and usa69e when clickin69 on thin69s telekinetically (fla69=0).  This proc will
	not be called at ran69ed except with telekinesis.

	proximity_fla69 is69ot currently passed to attack_hand, and is instead used
	in human click code to allow 69love touches only at69elee ran69e.
*/
/mob/proc/UnarmedAttack(var/atom/A,69ar/proximity_fla69)
	return

/mob/livin69/UnarmedAttack(var/atom/A,69ar/proximity_fla69)
	if(stat)
		return 0

	return 1

/*
	Ran69ed unarmed attack:

	This currently is just a default for all69obs, involvin69
	laser eyes and telekinesis.  You could easily add exceptions
	for thin69s like ran69ed 69love touches, spittin69 alien acid/neurotoxin,
	animals lun69in69, etc.
*/
/mob/proc/Ran69edAttack(var/atom/A,69ar/params)
	if(!mutations.len) return
	if((LASER in69utations) && a_intent == I_HURT)
		LaserEyes(A) //69oved into a proc below
	else if(TK in69utations)
		var/d = (69et_dist(src, A))
		if (d == 0)
			return
		if (d <= tk_maxran69e)
			A.attack_tk(src)
/*
	Restrained ClickOn

	Used when you are handcuffed and click thin69s.
	Not currently used by anythin69 but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swappin69 hands
*/
/mob/proc/MiddleClickOn(var/atom/A)
	swap_hand()
	return

/mob/proc/ShiftMiddleClickOn(atom/A)
	pointed(A)

// In case of use break 69lass
/*
/atom/proc/MiddleClick(var/mob/M as69ob)
	return
*/

/*
	Shift click
	For69ost69obs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A)
	A.ShiftClick(src)
	return

/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.client.eye == user)
		user.examinate(src)
	return

/*
	Control+Alt click
*/
/mob/proc/CtrlAltClickOn(var/atom/A)
	A.CtrlAltClick(src)
	return

/atom/proc/CtrlAltClick(var/mob/user)
	return

/*
	Ctrl click
	For69ost objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A)
	A.CtrlClick(src)
	return
/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pullin69(src)

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A)
	A.AltClick(src)
	return

/atom/proc/AltClick(var/mob/user)
	var/turf/T = 69et_turf(src)
	if(T && user.TurfAdjacent(T))
		if(user.listed_turf == T)
			user.listed_turf =69ull
		else
			user.listed_turf = T
			user.client.statpanel = "Turf"
	return 1

/mob/proc/TurfAdjacent(var/turf/T)
	return T.Adjacent69uick(src)

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

	Laser Eyes: as the69ame implies, handles this since69othin69 else does currently
	face_atom: turns the69ob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A)
	return

/mob/livin69/LaserEyes(atom/A)
	setClickCooldown(4)
	var/turf/T = 69et_turf(src)

	var/obj/item/projectile/beam/LE =69ew (T)
	LE.icon = 'icons/effects/69enetics.dmi'
	LE.icon_state = "eyelasers"
	mob_playsound(usr.loc, 'sound/weapons/taser2.o6969', 75, 1)
	LE.launch(A)

/mob/livin69/carbon/human/LaserEyes()
	if(nutrition>0)
		..()
		nutrition =69ax(nutrition - rand(1, 5), 0)
		handle_re69ular_hud_updates()
	else
		to_chat(src, SPAN_WARNIN69("You're out of ener69y!  You69eed food!"))

// Simple helper to face what you clicked on, in case it should be69eeded in69ore than one place
/atom/movable/proc/face_atom(var/atom/A)
	if(!A || !x || !y || !A.x || !A.y) return
	var/dx = A.x - x
	var/dy = A.y - y
	if(!dx && !dy) return

	var/direction
	if(abs(dx) < abs(dy))
		if(dy > 0)	direction =69ORTH
		else		direction = SOUTH
	else
		if(dx > 0)	direction = EAST
		else		direction = WEST
	if(direction != dir)
		facedir(direction)


/atom/movable/proc/facedir(var/ndir)
	set_dir(ndir)
	return 1



69LOBAL_LIST_INIT(click_catchers, create_click_catcher())

/obj/screen/click_catcher
	icon = 'icons/mob/screen_69en.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"

/obj/screen/click_catcher/Destroy()
	return 69DEL_HINT_LETMELIVE

/obj/screen/click_catcher/New(_name = "",69ob/livin69/_parentmob, _icon, _icon_state)
	..()

/proc/create_click_catcher()
	. = list()
	for(var/i = 0, i<15, i++)
		for(var/j = 0, j<15, j++)
			var/obj/screen/click_catcher/CC =69ew()
			CC.screen_loc = "NORTH-696969,EAST-669j69"
			. += CC

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers69"middle6969 && istype(usr, /mob/livin69/carbon))
		var/mob/livin69/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(screen_loc, 69et_turf(usr))
		if(T)
			usr.client.Click(T, location, control, params)
			//T.Click(location, control, params)
			//Bay system doesnt use client.click,69ot sure if better

	. = 1

/obj/screen/click_catcher/proc/resolve(var/mob/user)
	var/turf/T = screen_loc2turf(screen_loc, 69et_turf(user))
	return T

/mob/livin69/carbon/human/proc/absolute_69rab(mob/livin69/carbon/human/T)
	if(!ishuman(T))
		return
	if(stat || paralysis || stunned || weakened || lyin69 || restrained() || buckled)
		to_chat(src, "You cannot leap in your current state.")
		return
	if(l_hand && r_hand)
		to_chat(src, SPAN_DAN69ER("You69eed to have one hand free to 69rab someone."))
		return

	if(!T || !src || src.stat)
		return
	if(69et_dist(69et_turf(T), 69et_turf(src)) < 2)
		return
	if(69et_dist_euclidian(69et_turf(T), 69et_turf(src)) >= 3)
		return
	if(last_special > world.time)
		return
	last_special = world.time + 75
	status_fla69s |= LEAPIN69
	src.visible_messa69e(SPAN_DAN69ER("\The 69sr6969 leaps at 669T69!"))
	src.throw_at(69et_step(69et_turf(T),69et_turf(src)), 4, 1, src)
	mob_playsound(src.loc, 'sound/voice/shriek1.o6969', 50, 1)
	sleep(5)
	if(status_fla69s & LEAPIN69)
		status_fla69s &= ~LEAPIN69

		if(!src.Adjacent(T))
			to_chat(src, SPAN_WARNIN69("You69iss!"))
			Weaken(3)
			return
		T.attack_hand(src)
