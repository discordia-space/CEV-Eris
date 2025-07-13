/datum/wires/robot
	holder_type = /mob/living/silicon/robot
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(BORG_WIRE_LAWCHECK, "LawSync"),
		new /datum/wire_description(BORG_WIRE_MAIN_POWER, "Power",),
		new /datum/wire_description(BORG_WIRE_LOCKED_DOWN, "Failsafe"),
		new /datum/wire_description(BORG_WIRE_AI_CONTROL, "Remote access"),
		new /datum/wire_description(BORG_WIRE_CAMERA,  "Camera")
	)

var/const/BORG_WIRE_LAWCHECK = 1
var/const/BORG_WIRE_MAIN_POWER = 2 // The power wires do nothing whyyyyyyyyyyyyy
var/const/BORG_WIRE_LOCKED_DOWN = 4
var/const/BORG_WIRE_AI_CONTROL = 8
var/const/BORG_WIRE_CAMERA = 16

/datum/wires/robot/GetInteractWindow(mob/living/user)

	. = ..(user)
	var/mob/living/silicon/robot/R = holder
	. += text("<br>\n[(R.lawupdate ? "The LawSync light is on." : "The LawSync light is off.")]")
	. += text("<br>\n[(R.connected_ai ? "The AI link light is on." : "The AI link light is off.")]")
	. += text("<br>\n[((!isnull(R.camera) && R.camera.status == 1) ? "The Camera light is on." : "The Camera light is off.")]")
	. += text("<br>\n[(R.lockcharge ? "The lockdown light is on." : "The lockdown light is off.")]")
	return .

/datum/wires/robot/UpdateCut(index, mended)

	var/mob/living/silicon/robot/R = holder
	switch(index)
		if(BORG_WIRE_LAWCHECK) //Cut the law wire, and the borg will no longer receive law updates from its AI
			if(!mended)
				if (R.lawupdate == 1)
					to_chat(R, "LawSync protocol engaged.")
					R.show_laws()
					log_silicon("[key_name(usr)] enabled [key_name(R)]'s lawsync via wire")
			else
				if (R.lawupdate == 0 && !R.HasTrait(CYBORG_TRAIT_EMAGGED))
					R.lawupdate = 1
					log_silicon("[key_name(usr)] disabled [key_name(R)]'s lawsync via wire")


		if (BORG_WIRE_AI_CONTROL) //Cut the AI wire to reset AI control
			if(!mended)
				R.disconnect_from_ai()
				log_silicon("[key_name(usr)] cut AI wire on [key_name(R)][R.connected_ai ? " and disconnected from [key_name(R.connected_ai)]": ""]")

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && !R.scrambledcodes)
				R.camera.status = mended
				log_silicon("[key_name(usr)] toggled [key_name(R)]'s camera to [R.camera.status ? "on" : "off"] via pulse")

		if(BORG_WIRE_LAWCHECK)	//Forces a law update if the borg is set to receive them. Since an update would happen when the borg checks its laws anyway, not much use, but eh
			if (R.lawupdate)
				R.lawsync()
				log_silicon("[key_name(usr)] forcibly synced [key_name(R)]'s laws via pulse")

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!mended)
			log_silicon("[key_name(usr)] [!R.lockcharge ? "locked down" : "released"] [key_name(R)] via pulse")

/datum/wires/robot/UpdatePulsed(index)
	var/mob/living/silicon/robot/R = holder
	switch(index)
		if (BORG_WIRE_AI_CONTROL) //pulse the AI wire to make the borg reselect an AI
			if(!R.HasTrait(CYBORG_TRAIT_EMAGGED))
				var/mob/living/silicon/ai/new_ai = select_active_ai(R)
				log_silicon("[key_name(usr)] pulsed AI wire on [key_name(R)][R.connected_ai ? " and disconnected from [key_name(R.connected_ai)]": ""], they are now connected to [key_name(new_ai)]")
				R.connect_to_ai(new_ai)

		if (BORG_WIRE_CAMERA)
			if(!isnull(R.camera) && R.camera.can_use() && !R.scrambledcodes)
				R.visible_message("[R]'s camera lense focuses loudly.")
				to_chat(R, "Your camera lense focuses loudly.")
				log_silicon("[key_name(usr)] pulsed [key_name(R)]'s camera via wire")

		if(BORG_WIRE_LOCKED_DOWN)
			R.SetLockdown(!R.lockcharge) // Toggle
			log_silicon("[key_name(usr)] [!R.lockcharge ? "locked down" : "released"] [key_name(R)] via wire")


/datum/wires/robot/CanUse(mob/living/L)
	var/mob/living/silicon/robot/R = holder
	if(R.wiresexposed)
		return 1
	return 0

/datum/wires/robot/proc/IsCameraCut()
	return wires_status & BORG_WIRE_CAMERA

/datum/wires/robot/proc/LockedCut()
	return wires_status & BORG_WIRE_LOCKED_DOWN
