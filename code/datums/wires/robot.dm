/datum/wires/robot
	holder_type = /mob/livin69/silicon/robot
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(BOR69_WIRE_LAWCHECK, "LawSync"),
		new /datum/wire_description(BOR69_WIRE_MAIN_POWER, "Power",),
		new /datum/wire_description(BOR69_WIRE_LOCKED_DOWN, "Failsafe"),
		new /datum/wire_description(BOR69_WIRE_AI_CONTROL, "Remote access"),
		new /datum/wire_description(BOR69_WIRE_CAMERA,  "Camera")
	)

var/const/BOR69_WIRE_LAWCHECK = 1
var/const/BOR69_WIRE_MAIN_POWER = 2 // The power wires do nothin69 whyyyyyyyyyyyyy
var/const/BOR69_WIRE_LOCKED_DOWN = 4
var/const/BOR69_WIRE_AI_CONTROL = 8
var/const/BOR69_WIRE_CAMERA = 16

/datum/wires/robot/69etInteractWindow(mob/livin69/user)

	. = ..(user)
	var/mob/livin69/silicon/robot/R = holder
	. += text("<br>\n69(R.lawupdate ? "The LawSync li69ht is on." : "The LawSync li69ht is off.")69")
	. += text("<br>\n69(R.connected_ai ? "The AI link li69ht is on." : "The AI link li69ht is off.")69")
	. += text("<br>\n69((!isnull(R.camera) && R.camera.status == 1) ? "The Camera li69ht is on." : "The Camera li69ht is off.")69")
	. += text("<br>\n69(R.lockchar69e ? "The lockdown li69ht is on." : "The lockdown li69ht is off.")69")
	return .

/datum/wires/robot/UpdateCut(var/index,69ar/mended)

	var/mob/livin69/silicon/robot/R = holder
	switch(index)
		if(BOR69_WIRE_LAWCHECK) //Cut the law wire, and the bor69 will no lon69er receive law updates from its AI
			if(!mended)
				if (R.lawupdate == 1)
					to_chat(R, "LawSync protocol en69a69ed.")
					R.show_laws()
			else
				if (R.lawupdate == 0 && !R.ema6969ed)
					R.lawupdate = 1

		if (BOR69_WIRE_AI_CONTROL) //Cut the AI wire to reset AI control
			if(!mended)
				R.disconnect_from_ai()

		if (BOR69_WIRE_CAMERA)
			if(!isnull(R.camera) && !R.scrambledcodes)
				R.camera.status =69ended

		if(BOR69_WIRE_LAWCHECK)	//Forces a law update if the bor69 is set to receive them. Since an update would happen when the bor69 checks its laws anyway, not69uch use, but eh
			if (R.lawupdate)
				R.lawsync()

		if(BOR69_WIRE_LOCKED_DOWN)
			R.SetLockdown(!mended)


/datum/wires/robot/UpdatePulsed(var/index)
	var/mob/livin69/silicon/robot/R = holder
	switch(index)
		if (BOR69_WIRE_AI_CONTROL) //pulse the AI wire to69ake the bor69 reselect an AI
			if(!R.ema6969ed)
				var/mob/livin69/silicon/ai/new_ai = select_active_ai(R)
				R.connect_to_ai(new_ai)

		if (BOR69_WIRE_CAMERA)
			if(!isnull(R.camera) && R.camera.can_use() && !R.scrambledcodes)
				R.visible_messa69e("69R69's camera lense focuses loudly.")
				to_chat(R, "Your camera lense focuses loudly.")

		if(BOR69_WIRE_LOCKED_DOWN)
			R.SetLockdown(!R.lockchar69e) // To6969le

/datum/wires/robot/CanUse(var/mob/livin69/L)
	var/mob/livin69/silicon/robot/R = holder
	if(R.wiresexposed)
		return 1
	return 0

/datum/wires/robot/proc/IsCameraCut()
	return wires_status & BOR69_WIRE_CAMERA

/datum/wires/robot/proc/LockedCut()
	return wires_status & BOR69_WIRE_LOCKED_DOWN
