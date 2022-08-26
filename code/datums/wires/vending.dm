#define CAT_NORMAL 1
#define CAT_HIDDEN 2
#define CAT_COIN   4

#define CUSTOM_VENDOMAT_MODELS list("Generic" = "generic", "Security" = "sec", "Electronics" = "cart", "Research" = "robotics", "Medical" = "med", "Engineering" = "engivend", "Engineering 2" = "engi", "Tools" = "tool", "Shady" = "sovietsoda", "Fridge" = "smartfridge", "Alcohol" = "boozeomat", "Frozen Star" = "weapon", "NeoTheo" = "teomat", "Asters Power Cells" = "powermat", "Asters Disks" = "discomat")

/datum/wires/vending
	holder_type = /obj/machinery/vending
	wire_count = 4
	descriptions = list(
		new /datum/wire_description(VENDING_WIRE_THROW, "Safety"),
		new /datum/wire_description(VENDING_WIRE_CONTRABAND, "Contraband"),
		new /datum/wire_description(VENDING_WIRE_ELECTRIFY, "Shock"),
		new /datum/wire_description(VENDING_WIRE_IDSCAN, "ID scanner"),
	)

var/const/VENDING_WIRE_THROW = 1
var/const/VENDING_WIRE_CONTRABAND = 2
var/const/VENDING_WIRE_ELECTRIFY = 4
var/const/VENDING_WIRE_IDSCAN = 8

/datum/wires/vending/CanUse(var/mob/living/L)
	var/obj/machinery/vending/V = holder
	if(!issilicon(L))
		if(V.seconds_electrified)
			if(V.shock(L, 100))
				return 0
	if(V.panel_open)
		return 1
	return 0

/datum/wires/vending/GetInteractWindow(mob/living/user)
	var/obj/machinery/vending/V = holder
	. += ..(user)
	. += "<BR>The orange light is [V.seconds_electrified ? "off" : "on"].<BR>"
	. += "The red light is [V.shoot_inventory ? "off" : "blinking"].<BR>"
	. += "The green light is [(V.categories & CAT_HIDDEN) ? "on" : "off"].<BR>"
	. += "The [V.scan_id ? "purple" : "yellow"] light is on.<BR>"

/datum/wires/vending/UpdatePulsed(var/index)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			V.shoot_inventory = !V.shoot_inventory
		if(VENDING_WIRE_CONTRABAND)
			V.categories ^= CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			V.seconds_electrified = 30
		if(VENDING_WIRE_IDSCAN)
			V.scan_id = !V.scan_id

/datum/wires/vending/UpdateCut(var/index, var/mended)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_WIRE_THROW)
			V.shoot_inventory = !mended
		if(VENDING_WIRE_CONTRABAND)
			V.categories &= ~CAT_HIDDEN
		if(VENDING_WIRE_ELECTRIFY)
			if(mended)
				V.seconds_electrified = 0
			else
				V.seconds_electrified = -1
		if(VENDING_WIRE_IDSCAN)
			V.scan_id = 1

/*
	The Game (you just lost it):
		Turn the pink light blue and make the suspicious light blink. Both must be true in order to unlock the hidden items.

	Tip:
		The power wire makes sparks when cut, but not when pulsed.
		If you want to reset the hacking game, cut the ground and power, then mend them.

	Robust Tip:
		Cut wires starting from the top until you cut a wire that turns the pink light blue. That is your signal wire.
			If the pink light doesn't change, mend all wires and start from the bottom instead.

	Robuster Tip:
		Level Mec

	Solution:
		Cut power/ground
		Cut signal (pink light turns blue)
		Mend power/ground
		Pulse suspicious (suspicious light blinks)
		Mend signal
*/

var/const/VENDING_INT_WIRE_THROW = 1
var/const/VENDING_INT_WIRE_ELECTRIFY = 2
var/const/VENDING_INT_WIRE_IDSCAN = 4
var/const/VENDING_INT_WIRE_SIGNAL = 8
var/const/VENDING_INT_WIRE_CONTRABAND = 16
var/const/VENDING_INT_WIRE_GROUND = 32
var/const/VENDING_INT_WIRE_POWER = 64

/datum/wires/vending/intermediate
	wire_count = 7
	var/is_powered = TRUE
	var/is_signal_securely_cut = FALSE
	var/is_contraband_securely_pulsed = FALSE
	descriptions = list(
		new /datum/wire_description(VENDING_INT_WIRE_THROW, "Safety"),
		new /datum/wire_description(VENDING_INT_WIRE_ELECTRIFY, "Shock"),
		new /datum/wire_description(VENDING_INT_WIRE_IDSCAN, "Access"),
		new /datum/wire_description(VENDING_INT_WIRE_SIGNAL, "Signal"),
		new /datum/wire_description(VENDING_INT_WIRE_CONTRABAND, "Suspicious"),
		new /datum/wire_description(VENDING_INT_WIRE_GROUND, "Ground"),
		new /datum/wire_description(VENDING_INT_WIRE_POWER, "Power")
	)

/datum/wires/vending/intermediate/GetInteractWindow(mob/living/user)
	. += ..(user)
	. += "The [is_signal_securely_cut ? "blue" : "pink"] light is on.<BR>"
	. += "The suspicious light is [is_contraband_securely_pulsed ? "blinking" : "on"].<BR>"

/datum/wires/vending/intermediate/UpdatePulsed(var/index)
	if(is_powered)
		var/obj/machinery/vending/V = holder
		switch(index)
			if(VENDING_INT_WIRE_THROW)
				V.shoot_inventory = !V.shoot_inventory
			if(VENDING_INT_WIRE_ELECTRIFY)
				V.seconds_electrified = 30
			if(VENDING_INT_WIRE_IDSCAN)
				V.scan_id = !V.scan_id
			if(VENDING_INT_WIRE_CONTRABAND)
				if(is_signal_securely_cut)
					is_contraband_securely_pulsed = TRUE

		// Pulse the wrong wire and you'll have to properly cut the signal wire again
		if(!is_contraband_securely_pulsed)
			is_signal_securely_cut = FALSE

/datum/wires/vending/intermediate/UpdateCut(var/index, var/mended)
	var/obj/machinery/vending/V = holder
	switch(index)
		if(VENDING_INT_WIRE_THROW)
			if(is_powered)
				V.shoot_inventory = !mended
		if(VENDING_INT_WIRE_ELECTRIFY)
			if(is_powered)
				V.seconds_electrified = mended ? 0 : -1
		if(VENDING_INT_WIRE_IDSCAN)
			if(is_powered)
				V.scan_id = 1
		if(VENDING_INT_WIRE_SIGNAL)
			if(mended && is_powered && is_contraband_securely_pulsed)
				V.categories ^= CAT_HIDDEN
			else if(!mended)
				is_signal_securely_cut = is_powered ? FALSE : TRUE
		if(VENDING_INT_WIRE_CONTRABAND)
			if(is_contraband_securely_pulsed)
				is_contraband_securely_pulsed = FALSE
		if(VENDING_INT_WIRE_POWER)
			V.seconds_electrified = mended ? 0 : 30

	is_powered = IsIndexCut(VENDING_INT_WIRE_POWER | VENDING_INT_WIRE_GROUND) ? FALSE : TRUE
