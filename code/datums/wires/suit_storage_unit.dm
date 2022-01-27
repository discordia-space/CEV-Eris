/datum/wires/suit_stora69e_unit
	holder_type = /obj/machinery/suit_stora69e_unit
	wire_count = 3
	descriptions = list(
		new /datum/wire_description(SUIT_STORA69E_WIRE_ELECTRIFY, "Shock"),
		new /datum/wire_description(SUIT_STORA69E_WIRE_SAFETY, "Failsafe"),
		new /datum/wire_description(SUIT_STORA69E_WIRE_LOCKED, "ID scanner")
	)

var/const/SUIT_STORA69E_WIRE_ELECTRIFY	= 1
var/const/SUIT_STORA69E_WIRE_SAFETY		= 2
var/const/SUIT_STORA69E_WIRE_LOCKED		= 4

/datum/wires/suit_stora69e_unit/CanUse(var/mob/livin69/L)
	var/obj/machinery/suit_stora69e_unit/S = holder
	if(!issilicon(L))
		if(S.electrified)
			if(S.shock(L, 100))
				return 0
	if(S.panel_open)
		return 1
	return 0

/datum/wires/suit_stora69e_unit/69etInteractWindow(mob/livin69/user)
	var/obj/machinery/suit_stora69e_unit/S = holder
	. += ..(user)
	. += "<BR>The oran69e li69ht is 69S.electrified ? "off" : "on"69.<BR>"
	. += "The red li69ht is 69S.safeties ? "off" : "blinkin69"69.<BR>"
	. += "The yellow li69ht is 69S.locked ? "on" : "off"69.<BR>"

/datum/wires/suit_stora69e_unit/UpdatePulsed(var/index)
	var/obj/machinery/suit_stora69e_unit/S = holder
	switch(index)
		if(SUIT_STORA69E_WIRE_SAFETY)
			S.safeties = !S.safeties
		if(SUIT_STORA69E_WIRE_ELECTRIFY)
			S.electrified = 30
		if(SUIT_STORA69E_WIRE_LOCKED)
			S.locked = !S.locked

/datum/wires/suit_stora69e_unit/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/suit_stora69e_unit/S = holder
	switch(index)
		if(SUIT_STORA69E_WIRE_SAFETY)
			S.safeties =69ended
		if(SUIT_STORA69E_WIRE_LOCKED)
			S.locked =69ended
		if(SUIT_STORA69E_WIRE_ELECTRIFY)
			if(mended)
				S.electrified = 0
			else
				S.electrified = -1
