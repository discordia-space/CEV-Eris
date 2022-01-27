/*
	Cybor69 ClickOn()

	Cybor69s have69o ran69e restriction on attack_robot(), because it is basically an AI click.
	However, they do have a ran69e restriction on item use, so they cannot do without the
	adjacency code.
*/

/mob/livin69/silicon/robot/ClickOn(var/atom/A,69ar/params)
	if(!can_click())
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode 69ui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers69"shift"69 &&69odifiers69"ctrl"69)
		CtrlShiftClickOn(A)
		return
	if(modifiers69"middle6969)
		MiddleClickOn(A)
		return
	if(modifiers69"shift6969)
		ShiftClickOn(A)
		return
	if(modifiers69"alt6969) // alt and alt-69r (ri69htalt)
		AltClickOn(A)
		return
	if(modifiers69"ctrl6969)
		CtrlClickOn(A)
		return

	if(stat || lockchar69e || weakened || stunned || paralysis)
		return



	face_atom(A) // chan69e direction to face what you clicked on

	if(aiCamera.in_camera_mode)
		if(!69et_turf(A))
			return
		aiCamera.camera_mode_off()
		if(is_component_functionin69("camera"))
			aiCamera.captureima69e(A, usr)
		else
			to_chat(src, "<span class='userdan69er'>Your camera isn't functional.</span>")
		return

	/*
	cybor69 restrained() currently does69othin69
	if(restrained())
		RestrainedClickOn(A)
		return
	*/

	var/obj/item/W = 69et_active_hand()

	// Cybor69s have69o ran69e-checkin69 unless there is item use
	if(!W)
		A.add_hiddenprint(src)
		A.attack_robot(src)
		return


	if(W == A)

		W.attack_self(src)
		return

	//Handlin69 usin69 69rippers
	if (istype(W, /obj/item/69ripper))
		var/obj/item/69ripper/69 = W
		//If the 69ripper contains somethin69, then we will use its contents to attack
		if (69.wrapped && (69.wrapped.loc == 69))
			69ripperClickOn(A, params, 69)
			return


	// cybor69s are prohibited from usin69 stora69e items so we can I think safely remove (A.loc in contents)
	if(A == loc || (A in loc) || (A in contents))
		//69o adjacency checks

		var/resolved = A.attackby(W, src, params)
		if(!resolved && A && W)
			W.afterattack(A, src, 1, params)
		return

	if(!isturf(loc))
		return

	// cybor69s are prohibited from usin69 stora69e items so we can I think safely remove (A.loc && isturf(A.loc.loc))
	var/sdepth = A.stora69e_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if (W)
				var/resolved = (SEND_SI69NAL(W, COMSI69_IATTACK, A, src, params)) || (SEND_SI69NAL(A, COMSI69_ATTACKBY, W, src, params)) || W.resolve_attackby(A, src, params)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params)
			else
				if(ismob(A))
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, 1)
			return
		else
			if (W)
				W.afterattack(A, src, 0, params)
			else
				Ran69edAttack(A, params)
	return


/*
	69ripper Handlin69
	This is used when a 69ripper is used on anythin69. It does all the handlin69 for it
*/
/mob/livin69/silicon/robot/proc/69ripperClickOn(var/atom/A,69ar/params,69ar/obj/item/69ripper/69)

	var/obj/item/W = 69.wrapped
	if (!69rippersafety(69))return


	69.force_holder = W.force
	W.force = 0
	// cybor69s are prohibited from usin69 stora69e items so we can I think safely remove (A.loc in contents)
	if(A == loc || (A in loc) || (A in contents))
		//69o adjacency checks

		var/resolved = A.attackby(W,src,params)
		if (!69rippersafety(69))return
		if(!resolved && A && W)
			W.afterattack(A,src,1,params)
		if (!69rippersafety(69))return
		W.force = 69.force_holder
		return
	if(!isturf(loc))
		W.force = 69.force_holder
		return

	// cybor69s are prohibited from usin69 stora69e items so we can I think safely remove (A.loc && isturf(A.loc.loc))
	if(isturf(A) || isturf(A.loc))
		if(A.Adjacent(src)) // see adjacent.dm
			var/resolved = A.attackby(W, src, params)
			if (!69rippersafety(69))return
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params)
			if (!69rippersafety(69))return
			W.force = 69.force_holder
			return
		//No69on-adjacent clicks. Can't fire 69uns
	W.force = 69.force_holder
	return


//Middle click cycles throu69h selected69odules.
/mob/livin69/silicon/robot/MiddleClickOn(var/atom/A)
	cycle_modules()
	return

//69ive cybor69s hotkey clicks without breakin69 existin69 uses of hotkey clicks
// for69on-doors/apcs
/mob/livin69/silicon/robot/CtrlShiftClickOn(var/atom/A)
	if(ai_access)
		return A.Bor69CtrlShiftClick(src)
	..()

/mob/livin69/silicon/robot/ShiftClickOn(var/atom/A)
	if(ai_access)
		return A.Bor69ShiftClick(src)
	..()

/mob/livin69/silicon/robot/CtrlClickOn(var/atom/A)
	if(ai_access)
		return A.Bor69CtrlClick(src)
	..()

/mob/livin69/silicon/robot/AltClickOn(var/atom/A)
	if(ai_access)
		return A.Bor69AltClick(src)
	..()

/atom/proc/Bor69CtrlShiftClick(var/mob/livin69/silicon/robot/user) //forward to human click if69ot overriden
	CtrlShiftClick(user)

/obj/machinery/door/airlock/Bor69CtrlShiftClick(var/mob/livin69/silicon/robot/user)
	AICtrlShiftClick(user)

/atom/proc/Bor69ShiftClick(var/mob/livin69/silicon/robot/user) //forward to human click if69ot overriden
	ShiftClick(user)

/obj/machinery/door/airlock/Bor69ShiftClick(var/mob/livin69/silicon/robot/user)  // Opens and closes doors! Forwards to AI code.
	AIShiftClick(user)

/atom/proc/Bor69CtrlClick(var/mob/livin69/silicon/robot/user) //forward to human click if69ot overriden
	CtrlClick(user)

/obj/machinery/door/airlock/Bor69CtrlClick(var/mob/livin69/silicon/robot/user) // Bolts doors. Forwards to AI code.
	AICtrlClick(user)

/obj/machinery/power/apc/Bor69CtrlClick(var/mob/livin69/silicon/robot/user) // turns off/on APCs. Forwards to AI code.
	AICtrlClick(user)

/obj/machinery/turretid/Bor69CtrlClick(var/mob/livin69/silicon/robot/user) //turret control on/off. Forwards to AI code.
	AICtrlClick(user)

/atom/proc/Bor69AltClick(var/mob/livin69/silicon/robot/user)
	AltClick(user)
	return

/obj/machinery/door/airlock/Bor69AltClick(var/mob/livin69/silicon/robot/user) // Eletrifies doors. Forwards to AI code.
	AIAltClick(user)

/obj/machinery/turretid/Bor69AltClick(var/mob/livin69/silicon/robot/user) //turret lethal on/off. Forwards to AI code.
	AIAltClick(user)

/*
	As with AI, these are69ot used in click code,
	because the code for robots is specific,69ot 69eneric.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	chan69e attack_robot() above to the proper function
*/
/mob/livin69/silicon/robot/UnarmedAttack(atom/A)
	A.attack_robot(src)
/mob/livin69/silicon/robot/Ran69edAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user)
	attack_ai(user)
	return

//
//	On Ctrl-Click will turn on if off otherwise will switch between Filterin69 and Panic Siphon
//
/obj/machinery/alarm/Bor69CtrlClick(var/mob/livin69/silicon/robot/user)
	AICtrlClick(user)

//
//	On Alt-Click will cycle throu69h69odes
//
/obj/machinery/alarm/Bor69AltClick(var/mob/livin69/silicon/robot/user)
	AIAltClick(user)

//
//	On Ctrl-Click will turn on if off otherwise will switch between Filterin69 and Panic Siphon
//
/obj/machinery/firealarm/Bor69CtrlClick(var/mob/livin69/silicon/robot/user)
	AICtrlClick(user)

//
//	On Ctrl-Click will turn on or off SMES input
//
/obj/machinery/power/smes/Bor69CtrlClick(var/mob/livin69/silicon/robot/user)
	AICtrlClick(user)

//
//	On Alt-Click will turn on or off SMES output
//
/obj/machinery/power/smes/Bor69AltClick(var/mob/livin69/silicon/robot/user)
	AIAltClick(user)

//
//	On Ctrl-Click will turn on or off 69as coolin69 system
//
/obj/machinery/atmospherics/unary/freezer/Bor69CtrlClick(var/mob/livin69/silicon/robot/user)
	AICtrlClick(user)

//
//	On Ctrl-Click will turn on or off telecomms69achinery
//	ENABLE WHEN TCOMS UI WILL BE UPDATED TO69ANOUI
/*
/obj/machinery/telecomms/Bor69CtrlClick(var/mob/livin69/silicon/robot/user)
	AICtrlClick(user)
*/

//69OL feature, clickin69 on turf can too69le doors
/turf/Bor69CtrlClick(var/mob/livin69/silicon/robot/user)
	AICtrlClick(user)

/turf/Bor69AltClick(var/mob/livin69/silicon/robot/user)
	AIAltClick(user)

/turf/Bor69ShiftClick(var/mob/livin69/silicon/robot/user)
	AIShiftClick(user)