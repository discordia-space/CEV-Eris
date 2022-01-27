#define CAT_NORMAL 1
#define CAT_HIDDEN 2
#define CAT_COIN   4

#define CUSTOM_VENDOMAT_MODELS list("69eneric" = "69eneric", "Security" = "sec", "Electronics" = "cart", "Research" = "robotics", "Medical" = "med", "En69ineerin69" = "en69ivend", "En69ineerin69 2" = "en69i", "Tools" = "tool", "Shady" = "sovietsoda", "Frid69e" = "smartfrid69e", "Alcohol" = "boozeomat", "Frozen Star" = "weapon", "NeoTheo" = "teomat", "Asters Power Cells" = "powermat", "Asters Disks" = "discomat")

/datum/wires/vendin69
	holder_type = /obj/machinery/vendin69
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(VENDIN69_WIRE_THROW, "Safety"),
		new /datum/wire_description(VENDIN69_WIRE_CONTRABAND, "Contraband"),
		new /datum/wire_description(VENDIN69_WIRE_ELECTRIFY, "Shock"),
		new /datum/wire_description(VENDIN69_WIRE_IDSCAN, "ID scanner"),
	)

var/const/VENDIN69_WIRE_THROW = 1
var/const/VENDIN69_WIRE_CONTRABAND = 2
var/const/VENDIN69_WIRE_ELECTRIFY = 4
var/const/VENDIN69_WIRE_IDSCAN = 8

/datum/wires/vendin69/CanUse(var/mob/livin69/L)
	var/obj/machinery/vendin69/V = holder
	if(!issilicon(L))
		if(V.seconds_electrified)
			if(V.shock(L, 100))
				return 0
	if(V.panel_open)
		return 1
	return 0

/datum/wires/vendin69/69etInteractWindow(mob/livin69/user)
	var/obj/machinery/vendin69/V = holder
	. += ..(user)
	. += "<BR>The oran69e li69ht is 69V.seconds_electrified ? "off" : "on"69.<BR>"
	. += "The red li69ht is 69V.shoot_inventory ? "off" : "blinkin69"69.<BR>"
	. += "The 69reen li69ht is 69(V.cate69ories & CAT_HIDDEN) ? "on" : "off"69.<BR>"
	. += "The 69V.scan_id ? "purple" : "yellow"69 li69ht is on.<BR>"

/datum/wires/vendin69/UpdatePulsed(var/index)
	var/obj/machinery/vendin69/V = holder
	switch(index)
		if(VENDIN69_WIRE_THROW)
			V.shoot_inventory = !V.shoot_inventory
		if(VENDIN69_WIRE_CONTRABAND)
			V.cate69ories ^= CAT_HIDDEN
		if(VENDIN69_WIRE_ELECTRIFY)
			V.seconds_electrified = 30
		if(VENDIN69_WIRE_IDSCAN)
			V.scan_id = !V.scan_id

/datum/wires/vendin69/UpdateCut(var/index,69ar/mended)
	var/obj/machinery/vendin69/V = holder
	switch(index)
		if(VENDIN69_WIRE_THROW)
			V.shoot_inventory = !mended
		if(VENDIN69_WIRE_CONTRABAND)
			V.cate69ories &= ~CAT_HIDDEN
		if(VENDIN69_WIRE_ELECTRIFY)
			if(mended)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(VENDIN69_WIRE_IDSCAN)
			V.scan_id = 1
