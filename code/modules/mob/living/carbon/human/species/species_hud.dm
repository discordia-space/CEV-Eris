/datum/hud_data

	var/list/equip_slots = list() // Checked by mob_can_equip().
	var/list/ProcessHUD = list(
		"health","nutrition","body temperature","pressure","toxin","oxygen","fire","internal","sanity","neural system accumulation","energy",
		"throw","resist","drop","look up","rest", "wield", "block",//"jump",
		"move intent","intent","damage zone","craft menu","look down","language menu","examine",
		"equip","swap hand","left arm bionics","right arm bionics","toggle inventory", "toggle_cyberdeck",
		"cyberdeck1","cyberdeck2","cyberdeck3","cyberdeck4","cyberdeck5","cyberdeck6"
	)
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

	var/list/gear = list(
		"Uniform" =   slot_w_uniform,
		"Suit" =   slot_wear_suit,
		"Mask" =         slot_wear_mask,
		"Gloves" =       slot_gloves,
		"Glasses" =         slot_glasses,
		"Left Ear" =        slot_l_ear,
		"Right Ear" =        slot_r_ear,
		"Hat" =         slot_head,
		"Shoes" =        slot_shoes,
		"Suit Storage" = slot_s_store,
		"Back" =         slot_back,
		"ID" =           slot_wear_id,
		"Left Pocket" =     slot_l_store,
		"Right Pocket" =     slot_r_store,
		"Belt" =         slot_belt,
		"Left Hand" =       slot_l_hand,
		"Right Hand" =       slot_r_hand
		)

/datum/hud_data/New()
	..()
	for(var/slot in gear)
		equip_slots |= gear[slot]

	if(has_hands)
//		equip_slots |= slot_l_hand
//		equip_slots |= slot_r_hand
		equip_slots |= slot_handcuffed

	if(slot_back in equip_slots)
		equip_slots |= slot_in_backpack

	if(slot_w_uniform in equip_slots)
		equip_slots |= slot_accessory_buffer

	equip_slots |= slot_legcuffed


/datum/hud_data/monkey

	gear = list(
		"Left Hand" =       slot_l_hand,
		"Right Hand" =       slot_r_hand,
		"Hat" =          slot_head,
		"Mask" =         slot_wear_mask,
		"Back" =         slot_back
		)
