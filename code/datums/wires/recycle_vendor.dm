// TODO: Refactor wires, this is horrible -- KIROV

#define WIRE_THROW		0x1
#define WIRE_SPEAKER	0x2
#define WIRE_SHOCK		0x4
#define WIRE_ID_SCAN	0x8

var/const/VENDING_WIRE_SPEAKER = 2

/datum/wires/recycle_vendor
	holder_type = /obj/machinery/recycle_vendor
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(VENDING_WIRE_THROW, "Safety"),
		new /datum/wire_description(VENDING_WIRE_SPEAKER, "Speaker"),
		new /datum/wire_description(VENDING_WIRE_ELECTRIFY, "Shock"),
		new /datum/wire_description(VENDING_WIRE_IDSCAN, "ID scanner"))

/datum/wires/recycle_vendor/CanUse(mob/living/L)
	var/obj/machinery/recycle_vendor/V = holder
	if(BITTEST(V.wire_flags, WIRE_SHOCK) && V.shock(L, 100))
		return FALSE
	if(V.panel_open)
		return TRUE

/datum/wires/recycle_vendor/GetInteractWindow(mob/living/user)
	var/obj/machinery/recycle_vendor/V = holder
	. += ..(user)
	. += "<BR>The orange light is [BITTEST(V.wire_flags, WIRE_SHOCK) ? "off" : "on"].<BR>"
	. += "The red light is [BITTEST(V.wire_flags, WIRE_THROW) ? "off" : "blinking"].<BR>"
	. += "The green light is [BITTEST(V.wire_flags, WIRE_SPEAKER) ? "on" : "off"].<BR>"
	. += "The [BITTEST(V.wire_flags, WIRE_ID_SCAN) ? "purple" : "yellow"] light is on.<BR>"

/datum/wires/recycle_vendor/UpdatePulsed(index)
	var/obj/machinery/recycle_vendor/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			BITFLIP(V.wire_flags, WIRE_THROW)
		if(VENDING_WIRE_SPEAKER)
			BITFLIP(V.wire_flags, WIRE_SPEAKER)
		if(VENDING_WIRE_ELECTRIFY)
			BITSET(V.wire_flags, WIRE_SHOCK)

/datum/wires/recycle_vendor/UpdateCut(index, mended)
	var/obj/machinery/recycle_vendor/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			mended ? (BITRESET(V.wire_flags, WIRE_THROW))	: (BITSET(V.wire_flags, WIRE_THROW))
		if(VENDING_WIRE_SPEAKER)
			mended ? (BITRESET(V.wire_flags, WIRE_SPEAKER))	: (BITSET(V.wire_flags, WIRE_SPEAKER))
		if(VENDING_WIRE_ELECTRIFY)
			mended ? (BITRESET(V.wire_flags, WIRE_SHOCK))	: (BITSET(V.wire_flags, WIRE_SHOCK))
		if(VENDING_WIRE_IDSCAN)
			mended ? (BITRESET(V.wire_flags, WIRE_ID_SCAN))	: (BITSET(V.wire_flags, WIRE_ID_SCAN))
