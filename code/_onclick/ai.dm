/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to move the camera (this was already true but is cleaner),
	or double click a mob to track them.

	Note that AI have no need for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/living/silicon/ai/can_click()
	if (stat || control_disabled)
		return FALSE
	return ..()

/mob/living/silicon/ai/DblClickOn(var/atom/A, params)
	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/living/silicon/ai/ClickOn(var/atom/A, params)
	if(!can_click())
		return
	next_click = world.time + 1

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return


	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return


	if(multitool_mode && isobj(A))
		var/obj/O = A
		var/datum/extension/multitool/MT = get_extension(O, /datum/extension/multitool)
		if(MT)
			MT.interact(aiMulti, src)
			return

	if(aiCamera.in_camera_mode)
		if(!get_turf(A))
			return
		aiCamera.camera_mode_off()
		aiCamera.captureimage(A, usr)
		return

	/*
		AI restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
	else
	*/
	A.add_hiddenprint(src)
	A.attack_ai(src)

/*
	AI has no need for the UnarmedAttack() and RangedAttack() procs,
	because the AI code is not generic;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/living/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)
/mob/living/silicon/ai/RangedAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user as mob)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anything else in the game, atoms have separate procs
	for AI shift, ctrl, and alt clicking.
*/

/mob/living/silicon/ai/ShiftClickOn(var/atom/A)
	if(A.AIShiftClick(src))
		return
	..()

/mob/living/silicon/ai/CtrlClickOn(var/atom/A)
	if(A.AICtrlClick(src))
		return
	..()

/mob/living/silicon/ai/AltClickOn(var/atom/A)
	if(A.AIAltClick(src))
		return
	..()

/mob/living/silicon/ai/MiddleClickOn(var/atom/A)
	if(A.AIMiddleClick(src))
		return
	..()

/*
	The following criminally helpful code is just the previous code cleaned up;
	I have no idea why it was in atoms.dm instead of respective files.
*/

/atom/proc/AICtrlShiftClick()
	return

/atom/proc/AIShiftClick(var/mob/user)
	user.examinate(src)

/obj/machinery/door/airlock/AIShiftClick(var/mob/user)  // Opens and closes doors!
	if(density)
		Topic(src, list("command"="open", "activate" = "1"))
	else
		Topic(src, list("command"="open", "activate" = "0"))
	return 1

/atom/proc/AICtrlClick(var/mob/user)
	return

/obj/machinery/door/airlock/AICtrlClick(var/mob/user) // Bolts doors
	if(locked)
		Topic(src, list("command"="bolts", "activate" = "0"))
	else
		Topic(src, list("command"="bolts", "activate" = "1"))
	return 1

/obj/machinery/power/apc/AICtrlClick(var/mob/user) // turns off/on APCs.
	if(failure_timer)
		failure_timer = 0
		to_chat(user, "APC system restarted.")
		return 1
	Topic(src, list("breaker"="1"))
	return 1

/obj/machinery/turretid/AICtrlClick(var/mob/user) //turns off/on Turrets
	Topic(src, list("command"="enable", "value"="[!enabled]"))
	return 1

/atom/proc/AIAltClick(var/mob/user)
	return AltClick(user)

/obj/machinery/door/airlock/AIAltClick(var/mob/user) // Electrifies doors.
	if(!electrified_until)
		// permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "1"))
	else
		// disable/6 is not in Topic; disable/5 disables both temporary and permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "0"))
	return 1

/obj/machinery/turretid/AIAltClick(var/mob/user) //toggles lethal on turrets
	Topic(src, list("command"="lethal", "value"="[!lethal]"))
	return 1

/atom/proc/AIMiddleClick(var/mob/living/silicon/user)
	return 0

/obj/machinery/door/airlock/AIMiddleClick(var/mob/user) // Toggles door bolt lights.

	if(..())
		return

	if(!src.lights)
		Topic(src, list("command"="lights", "activate" = "1"))
	else
		Topic(src, list("command"="lights", "activate" = "0"))
	return 1

//
// Override AdjacentQuick for AltClicking
//

/mob/living/silicon/ai/TurfAdjacent(var/turf/T)
	return (cameranet && cameranet.checkTurfVis(T))

//
//	On Ctrl-Click will turn on if off otherwise will switch between Filtering and Panic Siphon
//
/obj/machinery/alarm/AICtrlClick(var/mob/user)
	if(mode == AALARM_MODE_OFF)
		Topic(src, list("command"="mode", "mode" = AALARM_MODE_SCRUBBING))
	else
		Topic(src, list("command"="mode", "mode" = AALARM_MODE_OFF))
	return 1

//
//	On Alt-Click will cycle through modes
//
/obj/machinery/alarm/AIAltClick(var/mob/user)
	if(mode == AALARM_MODE_LAST)
		Topic(src, list("command"="mode", "mode" = AALARM_MODE_FIRST))
	else
		Topic(src, list("command"="mode", "mode" = mode+1))
	return 1

//
//	On Ctrl-Click will turn on if off otherwise will switch between Filtering and Panic Siphon
//
/obj/machinery/firealarm/AICtrlClick(var/mob/user)
	var/area/A = get_area(src)
	if(A.fire)
		Topic(src, list("status"="reset"))
	else
		Topic(src, list("status"="alarm"))
	return 1

//
//	On Ctrl-Click will turn on or off SMES input
//
/obj/machinery/power/smes/AICtrlClick(var/mob/user)
	Topic(src, list("cmode"="1"))
	return 1

//
//	On Alt-Click will turn on or off SMES output
//
/obj/machinery/power/smes/AIAltClick(var/mob/user)
	Topic(src, list("online"="1"))
	return 1

//
//	On Ctrl-Click will turn on or off gas cooling system
//
/obj/machinery/atmospherics/unary/freezer/AICtrlClick(var/mob/user)
	Topic(src, list("toggleStatus"="1"))
	return 1

//
//	On Ctrl-Click will turn on or off telecomms machinery
//	ENABLE WHEN TCOMS UI WILL BE UPDATED TO NANOUI
/*
/obj/machinery/telecomms/AICtrlClick(var/mob/user)
	Topic(src, list("input"="toggle"))
	return 1
*/

//QOL feature, clicking on turf can toogle doors
/turf/AICtrlClick(var/mob/user)
	var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
	if(AL)
		AL.AICtrlClick(user)
		return
	var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
	if(FD)
		FD.AICtrlClick(user)
		return
	return ..()

/turf/AIAltClick(var/mob/user)
	var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
	if(AL)
		AL.AIAltClick(user)
		return
	var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
	if(FD)
		FD.AIAltClick(user)
		return
	return ..()

/turf/AIShiftClick(var/mob/user)
	var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
	if(AL)
		AL.AIShiftClick(user)
		return
	var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
	if(FD)
		FD.AIShiftClick(user)
		return
	return ..()