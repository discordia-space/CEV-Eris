/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle. They're large enough to be worn over other footwear."
	name = "magboots"
	icon_state = "magboots0"
	species_restricted = null
	force = 3
	overshoes = 1
	var/magpulse = 0
	var/mag_slow = 3
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/carbon/human/wearer = null	//For shoe procs
	armor = list(melee = 40, bullet = 30, laser = 30,energy = 25, bomb = 50, bio = 100, rad = 70)
	//This armor only applies to legs

/obj/item/clothing/shoes/magboots/proc/set_slowdown()
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
		user << "You disable the mag-pulse traction system."
	else
		item_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		force = WEAPON_FORCE_PAINFULL
		if(icon_base) icon_state = "[icon_base]1"
		user << "You enable the mag-pulse traction system."
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()


//We want to allow the user to equip magboots even if they're already wearing shoes
//As long as those shoes are not themselves magboots or similar overshoe-shoes
/obj/item/clothing/shoes/magboots/mob_can_equip(mob/user, slot, disable_warning = 0)
	if (slot == slot_shoes)
		var/mob/living/carbon/human/H = user

		if(H.shoes)
			if (istype(H.shoes, /obj/item/clothing/shoes))
				var/obj/item/clothing/shoes/S = H.shoes
				if(S.overshoes)
					if (!disable_warning)
						user << "You are unable to wear \the [src] as \the [H.shoes] are in the way."
					return 0
		return 1


	else
		return ..()

//When the magboots are used on worn boots, this indicates that we want to wear them.
/obj/item/clothing/shoes/magboots/pre_attack(atom/a, mob/user)
	if (istype(a, /obj/item))
		var/obj/item/i = a
		//Ensure that the thing you clicked on is a pair of shoes which are currently being worn
		if (i.get_equip_slot() == slot_shoes)
			//Start the equipping process. This will run through mob_can_equip and pre_equip
			user.equip_to_slot_if_possible(src,slot_shoes)
			return 1

/obj/item/clothing/shoes/magboots/dropped()
	..()
	remove()

/obj/item/clothing/shoes/magboots/equipped()
	..()
	if (is_held())
		remove() //If the magboots are taken into hands, release the shoes
	else if (is_worn())
		wearer = loc

//This proc handles sucking up the old shoes before we equip the magboots.
/obj/item/clothing/shoes/magboots/pre_equip(mob/M, slot)
	if (slot == slot_shoes)
		var/mob/living/carbon/human/H = M

		if(H.shoes)
			shoes = H.shoes
			H.drop_from_inventory(shoes)	//Remove the old shoes so you can put on the magboots.
			shoes.forceMove(src) //Old shoes are sucked up inside the magboots, they'll be released when the magboots are removed
	return 0



//This proc releases any contained shoes back onto the wearer, then nulls all the relevant values.
//It is called when the magboots are dropped from the mob, or taken to any non-worn slot (ie, the hands)
/obj/item/clothing/shoes/magboots/proc/remove()
	var/mob/living/carbon/human/H = wearer
	if(shoes)
		if(!H.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.forceMove(get_turf(src))
		shoes = null
	wearer = null

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..(user)
	var/state = "disabled"
	if(item_flags & NOSLIP)
		state = "enabled"
	user << "Its mag-pulse traction system appears to be [state]."