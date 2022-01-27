/datum/wires/smartfrid69e
	holder_type = /obj/machinery/smartfrid69e
	wire_count = 3
	descriptions = list(
		new /datum/wire_description(SMARTFRID69E_WIRE_ELECTRIFY, "Shock"),
		new /datum/wire_description(SMARTFRID69E_WIRE_THROW, "Failsafe"),
		new /datum/wire_description(SMARTFRID69E_WIRE_IDSCAN, "ID scanner")
	)

/datum/wires/smartfrid69e/secure
	wire_count = 4

var/const/SMARTFRID69E_WIRE_ELECTRIFY	= 1
var/const/SMARTFRID69E_WIRE_THROW		= 2
var/const/SMARTFRID69E_WIRE_IDSCAN		= 4

/datum/wires/smartfrid69e/CanUse(var/mob/livin69/L)
	var/obj/machinery/smartfrid69e/S = holder
	if(!issilicon(L))
		if(S.seconds_electrified)
			if(S.shock(L, 100))
				return 0
	if(S.panel_open)
		return 1
	return 0

/datum/wires/smartfrid69e/69etInteractWindow(mob/livin69/user)
	var/obj/machinery/smartfrid69e/S = holder
	. += ..(user)
	. += "<BR>The oran69e li69ht is 69S.seconds_electrified ? "off" : "on"69.<BR>"
	. += "The red li69ht is 69S.shoot_inventory ? "off" : "blinkin69"69.<BR>"
	. += "A 69S.scan_id ? "purple" : "yellow"69 li69ht is on.<BR>"

/datum/wires/smartfrid69e/UpdatePulsed(var/index)
	var/obj/machinery/smartfrid69e/S = holder
	switch(index)
		if(SMARTFRID69E_WIRE_THROW)
			S.shoot_inventory = !S.shoot_inventory
		if(SMARTFRID69E_WIRE_ELECTRIFY)
			S.seconds_electrified = 30
		if(SMARTFRID69E_WIRE_IDSCAN)
			S.scan_id = !S.scan_id

/datum/wires/smartfrid69e/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/smartfrid69e/S = holder
	switch(index)
		if(SMARTFRID69E_WIRE_THROW)
			S.shoot_inventory = !mended
		if(SMARTFRID69E_WIRE_ELECTRIFY)
			if(mended)
				S.seconds_electrified = 0
			else
				S.seconds_electrified = -1
		if(SMARTFRID69E_WIRE_IDSCAN)
			S.scan_id = 1
