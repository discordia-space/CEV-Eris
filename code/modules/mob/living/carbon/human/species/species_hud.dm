/datum/hud_data

	var/list/equip_slots = list() // Checked by mob_can_equip().
	var/list/ProcessHUD = list("health","nutrition","bodytemp","pressure","toxin","oxygen","fire", "throw","pull",
	"resist","drop","m_intent","equip","intent","help","harm","grab","disarm","damage zone", "internal", "damageoverlay","swap hand",
	"toggle gun mode","allow movement","allow item use","allow radio use")
	var/icon              // If set, overrides ui_style.
	//var/has_a_intent = 1  // Set to draw intent box.
	//var/has_m_intent = 1  // Set to draw move intent box.
	//var/has_warnings = 1  // Set to draw environment warnings.
	//var/has_pressure = 1  // Draw the pressure indicator.
	//var/has_nutrition = 1 // Draw the nutrition indicator.
	//var/has_bodytemp = 1  // Draw the bodytemp indicator.
	var/has_hands = 1     // Set to draw hands.
	//var/has_drop = 1      // Set to draw drop button.
	//var/has_throw = 1     // Set to draw throw button.
	//var/has_resist = 1    // Set to draw resist button.
	var/has_internals = 1 // Set to draw the internals toggle button.

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/gear = list(
		"i_clothing" =   slot_w_uniform,
		"o_clothing" =   slot_wear_suit,
		"mask" =         slot_wear_mask,
		"gloves" =       slot_gloves,
		"eyes" =         slot_glasses,
		"l_ear" =        slot_l_ear,
		"r_ear" =        slot_r_ear,
		"head" =         slot_head,
		"shoes" =        slot_shoes,
		"suit storage" = slot_s_store,
		"back" =         slot_back,
		"id" =           slot_wear_id,
		"storage1" =     slot_l_store,
		"storage2" =     slot_r_store,
		"belt" =         slot_belt,
		"l_hand" =       slot_l_hand,
		"r_hand" =       slot_r_hand
		)

/datum/hud_data/New()
	..()
	for(var/slot in gear)
		equip_slots |= gear[slot]

	if(has_hands)
		equip_slots |= slot_l_hand
		equip_slots |= slot_r_hand
		equip_slots |= slot_handcuffed

	if(slot_back in equip_slots)
		equip_slots |= slot_in_backpack

	if(slot_w_uniform in equip_slots)
		equip_slots |= slot_tie

	equip_slots |= slot_legcuffed

/datum/hud_data/diona
	has_internals = 0
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_shoes,     "name" = "Suit",         "slot" = slot_wear_suit, "state" = "suit",   "toggle" = 1),
		"l_ear" =        list("loc" = ui_gloves,    "name" = "Ear",          "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_oclothing, "name" = "Hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt,      "state" = "belt")
		)

/datum/hud_data/monkey
	gear = list(
		"mask" =         list("loc" = ui_shoes,     "name" = "Mask", "slot" = slot_wear_mask, "state" = "mask",  "toggle" = 1),
		"back" =         list("loc" = ui_sstore1,   "name" = "Back", "slot" = slot_back,      "state" = "back")
		)