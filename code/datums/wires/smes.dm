/datum/wires/smes
	holder_type = /obj/machinery/power/smes/buildable
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(SMES_WIRE_RCON, "Remote access"),
		new /datum/wire_description(SMES_WIRE_INPUT, "Input"),
		new /datum/wire_description(SMES_WIRE_OUTPUT, "Output"),
		new /datum/wire_description(SMES_WIRE_69ROUNDIN69, "69roundin69"),
		new /datum/wire_description(SMES_WIRE_FAILSAFES, "Failsafe")
	)

var/const/SMES_WIRE_RCON = 1		// Remote control (AI and consoles), cut to disable
var/const/SMES_WIRE_INPUT = 2		// Input wire, cut to disable input, pulse to disable for 60s
var/const/SMES_WIRE_OUTPUT = 4		// Output wire, cut to disable output, pulse to disable for 60s
var/const/SMES_WIRE_69ROUNDIN69 = 8	// Cut to quickly dischar69e causin69 sparks, pulse to only create few sparks
var/const/SMES_WIRE_FAILSAFES = 16	// Cut to disable failsafes,69end to reenable


/datum/wires/smes/CanUse(var/mob/livin69/L)
	var/obj/machinery/power/smes/buildable/S = holder
	if(S.open_hatch)
		return 1
	return 0


/datum/wires/smes/69etInteractWindow(mob/livin69/user)
	var/obj/machinery/power/smes/buildable/S = holder
	. += ..(user)
	. += "The 69reen li69ht is 69(S.input_cut || S.input_pulsed || S.output_cut || S.output_pulsed) ? "off" : "on"69<br>"
	. += "The red li69ht is 69(S.safeties_enabled || S.69roundin69) ? "off" : "blinkin69"69<br>"
	. += "The blue li69ht is 69S.RCon ? "on" : "off"69"


/datum/wires/smes/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(index)
		if(SMES_WIRE_RCON)
			S.RCon =69ended
		if(SMES_WIRE_INPUT)
			S.input_cut = !mended
		if(SMES_WIRE_OUTPUT)
			S.output_cut = !mended
		if(SMES_WIRE_69ROUNDIN69)
			S.69roundin69 =69ended
		if(SMES_WIRE_FAILSAFES)
			S.safeties_enabled =69ended


/datum/wires/smes/UpdatePulsed(var/index)
	var/obj/machinery/power/smes/buildable/S = holder
	switch(index)
		if(SMES_WIRE_RCON)
			if(S.RCon)
				S.RCon = 0
				spawn(10)
					S.RCon = 1
		if(SMES_WIRE_INPUT)
			S.to6969le_input()
		if(SMES_WIRE_OUTPUT)
			S.to6969le_output()
		if(SMES_WIRE_69ROUNDIN69)
			S.69roundin69 = 0
		if(SMES_WIRE_FAILSAFES)
			if(S.safeties_enabled)
				S.safeties_enabled = 0
				spawn(10)
					S.safeties_enabled = 1