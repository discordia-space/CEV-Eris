/datum/wires/shield_69enerator
	holder_type = /obj/machinery/power/shield_69enerator/
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(SHIELD69EN_WIRE_POWER, "Main power"),
		new /datum/wire_description(SHIELD69EN_WIRE_CONTROL, "Physical access"),
		new /datum/wire_description(SHIELD69EN_WIRE_AICONTROL, "Remote access")
	)

var/const/SHIELD69EN_WIRE_POWER = 1			// Cut to disable power input into the 69enerator. Pulse does nothin69.69end to restore.
var/const/SHIELD69EN_WIRE_CONTROL = 4		// Cut to lock69ost shield controls.69end to unlock them. Pulse does nothin69.
var/const/SHIELD69EN_WIRE_AICONTROL = 8		// Cut to disable AI control.69end to restore.
var/const/SHIELD69EN_WIRE_NOTHIN69 = 16		// A blank wire that doesn't have any specific function

/datum/wires/shield_69enerator/CanUse()
	var/obj/machinery/power/shield_69enerator/S = holder
	if(S.panel_open)
		return 1
	return 0

/datum/wires/shield_69enerator/UpdateCut(index,69ended)
	var/obj/machinery/power/shield_69enerator/S = holder
	switch(index)
		if(SHIELD69EN_WIRE_POWER)
			S.input_cut = !mended
		if(SHIELD69EN_WIRE_CONTROL)
			S.mode_chan69es_locked = !mended
		if(SHIELD69EN_WIRE_AICONTROL)
			S.ai_control_disabled = !mended

/datum/wires/shield_69enerator/UpdatePulsed(var/index)
	return