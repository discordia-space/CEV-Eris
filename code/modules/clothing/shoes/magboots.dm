/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the69ehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = WEAPON_FORCE_WEAK
	overslot = 1
	action_button_name = "Toggle69agboots"
	siemens_coefficient = 0 // DAMN BOI
	//This armor only applies to legs
	style = STYLE_NEG_LOW
	spawn_blacklisted = TRUE
	var/magpulse = FALSE
	var/mag_slow = 3
	var/icon_base = "magboots"

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	var/obj/item/clothing/shoes/shoes = overslot_contents
	slowdown = shoes?69ax(SHOES_SLOWDOWN, shoes.slowdown): SHOES_SLOWDOWN	//So you can't put on69agboots to69ake you walk faster.
	if (magpulse)
		slowdown +=69ag_slow

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~NOSLIP
		magpulse = FALSE
		set_slowdown()
		force = WEAPON_FORCE_WEAK
		if(icon_base) icon_state = "69icon_base690"
		to_chat(user, "You disable the69ag-pulse traction system.")
	else
		item_flags |= NOSLIP
		magpulse = TRUE
		set_slowdown()
		force = WEAPON_FORCE_PAINFUL
		if(icon_base) icon_state = "69icon_base691"
		to_chat(user, "You enable the69ag-pulse traction system.")
	user.update_inv_shoes()	//so our69ob-overlays update
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if(item_flags & NOSLIP)
		state = "enabled"
	to_chat(user, "Its69ag-pulse traction system appears to be 69state69.")


/*
	Used by69ercenaries
*/
/obj/item/clothing/shoes/magboots/merc
	name = "military69agboots"
	desc = "Sturdy hiking boots with powerful69agnetic soles. Useful in or out of a69essel."
	icon_state = "mercboots"
	item_flags = NOSLIP|DRAG_AND_DROP_UNEQUIP
	species_restricted = null
	force = WEAPON_FORCE_PAINFUL
	overslot = FALSE
	magpulse = FALSE
	mag_slow = 0
	icon_base = null
	can_hold_knife = TRUE
