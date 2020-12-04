/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = WEAPON_FORCE_WEAK
	overslot = 1
	action_button_name = "Toggle Magboots"
	siemens_coefficient = 0 // DAMN BOI
	//This armor only applies to legs
	style = STYLE_NEG_LOW
	spawn_blacklisted = TRUE
	var/magpulse = 0
	var/mag_slow = 3
	var/icon_base = "magboots"

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
	var/obj/item/clothing/shoes/shoes = overslot_contents
	slowdown = shoes? max(SHOES_SLOWDOWN, shoes.slowdown): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown += mag_slow

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		set_slowdown()
		force = WEAPON_FORCE_WEAK
		if(icon_base) icon_state = "[icon_base]0"
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		item_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		force = WEAPON_FORCE_PAINFUL
		if(icon_base) icon_state = "[icon_base]1"
		to_chat(user, "You enable the mag-pulse traction system.")
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if(item_flags & NOSLIP)
		state = "enabled"
	to_chat(user, "Its mag-pulse traction system appears to be [state].")


/*
	Used by mercenaries
*/
/obj/item/clothing/shoes/magboots/merc
	name = "military magboots"
	desc = "Sturdy hiking boots with powerful magnetic soles. Useful in or out of a vessel."
	icon_state = "mercboots"
	item_flags = NOSLIP|DRAG_AND_DROP_UNEQUIP
	species_restricted = null
	force = WEAPON_FORCE_PAINFUL
	overslot = FALSE
	magpulse = TRUE
	mag_slow = 0
	icon_base = null
	can_hold_knife = TRUE
	action_button_name = null
