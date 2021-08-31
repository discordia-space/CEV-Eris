/datum/wires/long_range_scanner
	holder_type = /obj/machinery/power/long_range_scanner/
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(SCANNER_WIRE_POWER, "This wire seems to be carrying a heavy current."),//, STAT_LEVEL_EXPERT), //TODO: Hook in Eris skills here
		new /datum/wire_description(SCANNER_WIRE_CONTROL, "This wire connects to the main control panel."),
		new /datum/wire_description(SCANNER_WIRE_AICONTROL, "This wire connects to automated control systems.")
	)

var/const/SCANNER_WIRE_POWER = 1			// Cut to disable power input into the scanner. Pulse does nothing. Mend to restore.
var/const/SCANNER_WIRE_CONTROL = 4		// Cut to lock most scanner controls. Mend to unlock them. Pulse does nothing.
var/const/SCANNER_WIRE_AICONTROL = 8		// Cut to disable AI control. Mend to restore.
var/const/SCANNER_WIRE_NOTHING = 16		// A blank wire that doesn't have any specific function

/datum/wires/long_range_scanner/CanUse()
	var/obj/machinery/power/long_range_scanner/S = holder
	if(S.panel_open)
		return 1
	return 0

/datum/wires/long_range_scanner/UpdateCut(index, mended)
	var/obj/machinery/power/long_range_scanner/S = holder
	switch(index)
		if(SCANNER_WIRE_POWER)
			S.input_cut = !mended
		if(SCANNER_WIRE_CONTROL)
			S.mode_changes_locked = !mended
		if(SCANNER_WIRE_AICONTROL)
			S.ai_control_disabled = !mended

/datum/wires/long_range_scanner/UpdatePulsed(var/index)
	return
