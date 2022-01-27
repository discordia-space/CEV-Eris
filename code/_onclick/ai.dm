/*
	AI ClickOn()

	Note currently ai restrained() returns 0 in all cases,
	therefore restrained code has been removed

	The AI can double click to69ove the camera (this was already true but is cleaner),
	or double click a69ob to track them.

	Note that AI have69o69eed for the adjacency proc, and so this proc is a lot cleaner.
*/
/mob/livin69/silicon/ai/can_click()
	if (stat || control_disabled)
		return FALSE
	return ..()

/mob/livin69/silicon/ai/DblClickOn(var/atom/A, params)
	if(client.buildmode) // comes after object.Click to allow buildmode 69ui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	if(ismob(A))
		ai_actual_track(A)
	else
		A.move_camera_by_click()


/mob/livin69/silicon/ai/ClickOn(var/atom/A, params)
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


	if(multitool_mode && isobj(A))
		var/obj/O = A
		var/datum/extension/multitool/MT = 69et_extension(O, /datum/extension/multitool)
		if(MT)
			MT.interact(aiMulti, src)
			return

	if(aiCamera.in_camera_mode)
		if(!69et_turf(A))
			return
		aiCamera.camera_mode_off()
		aiCamera.captureima69e(A, usr)
		return

	/*
		AI restrained() currently does69othin69
	if(restrained())
		RestrainedClickOn(A)
	else
	*/
	A.add_hiddenprint(src)
	A.attack_ai(src)

/*
	AI has69o69eed for the UnarmedAttack() and Ran69edAttack() procs,
	because the AI code is69ot 69eneric;	attack_ai() is used instead.
	The below is only really for safety, or you can alter the way
	it functions and re-insert it above.
*/
/mob/livin69/silicon/ai/UnarmedAttack(atom/A)
	A.attack_ai(src)
/mob/livin69/silicon/ai/Ran69edAttack(atom/A)
	A.attack_ai(src)

/atom/proc/attack_ai(mob/user)
	return

/*
	Since the AI handles shift, ctrl, and alt-click differently
	than anythin69 else in the 69ame, atoms have separate procs
	for AI shift, ctrl, and alt clickin69.
*/

/mob/livin69/silicon/ai/ShiftClickOn(var/atom/A)
	if(A.AIShiftClick(src))
		return
	..()

/mob/livin69/silicon/ai/CtrlClickOn(var/atom/A)
	if(A.AICtrlClick(src))
		return
	..()

/mob/livin69/silicon/ai/AltClickOn(var/atom/A)
	if(A.AIAltClick(src))
		return
	..()

/mob/livin69/silicon/ai/MiddleClickOn(var/atom/A)
	if(A.AIMiddleClick(src))
		return
	..()

/*
	The followin69 criminally helpful code is just the previous code cleaned up;
	I have69o idea why it was in atoms.dm instead of respective files.
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
	Topic(src, list("command"="enable", "value"="69!enable6969"))
	return 1

/atom/proc/AIAltClick(var/mob/user)
	return AltClick(user)

/obj/machinery/door/airlock/AIAltClick(var/mob/user) // Electrifies doors.
	if(!electrified_until)
		// permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "1"))
	else
		// disable/6 is69ot in Topic; disable/5 disables both temporary and permanent shock
		Topic(src, list("command"="electrify_permanently", "activate" = "0"))
	return 1

/obj/machinery/turretid/AIAltClick(var/mob/user) //to6969les lethal on turrets
	Topic(src, list("command"="lethal", "value"="69!letha6969"))
	return 1

/atom/proc/AIMiddleClick(var/mob/livin69/silicon/user)
	return 0

/obj/machinery/door/airlock/AIMiddleClick(var/mob/user) // To6969les door bolt li69hts.

	if(..())
		return

	if(!src.li69hts)
		Topic(src, list("command"="li69hts", "activate" = "1"))
	else
		Topic(src, list("command"="li69hts", "activate" = "0"))
	return 1

//
// Override Adjacent69uick for AltClickin69
//

/mob/livin69/silicon/ai/TurfAdjacent(var/turf/T)
	return (cameranet && cameranet.checkTurfVis(T))

//
//	On Ctrl-Click will turn on if off otherwise will switch between Filterin69 and Panic Siphon
//
/obj/machinery/alarm/AICtrlClick(var/mob/user)
	if(mode == AALARM_MODE_OFF)
		Topic(src, list("command"="mode", "mode" = AALARM_MODE_SCRUBBIN69))
	else
		Topic(src, list("command"="mode", "mode" = AALARM_MODE_OFF))
	return 1

//
//	On Alt-Click will cycle throu69h69odes
//
/obj/machinery/alarm/AIAltClick(var/mob/user)
	if(mode == AALARM_MODE_LAST)
		Topic(src, list("command"="mode", "mode" = AALARM_MODE_FIRST))
	else
		Topic(src, list("command"="mode", "mode" =69ode+1))
	return 1

//
//	On Ctrl-Click will turn on if off otherwise will switch between Filterin69 and Panic Siphon
//
/obj/machinery/firealarm/AICtrlClick(var/mob/user)
	var/area/A = 69et_area(src)
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
//	On Ctrl-Click will turn on or off 69as coolin69 system
//
/obj/machinery/atmospherics/unary/freezer/AICtrlClick(var/mob/user)
	Topic(src, list("to6969leStatus"="1"))
	return 1

//
//	On Ctrl-Click will turn on or off telecomms69achinery
//	ENABLE WHEN TCOMS UI WILL BE UPDATED TO69ANOUI
/*
/obj/machinery/telecomms/AICtrlClick(var/mob/user)
	Topic(src, list("input"="to6969le"))
	return 1
*/

//69OL feature, clickin69 on turf can too69le doors
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