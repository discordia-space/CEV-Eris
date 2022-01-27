/obj/item/clothing/accessory/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	slot = "utility"
	matter = list(MATERIAL_BIOMATTER = 5)
	price_tag = 200
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_HOLSTER
	var/obj/item/holstered

/obj/item/clothing/accessory/holster/proc/holster(obj/item/I,69ob/living/user)
	if(holstered && istype(user))
		to_chat(user, SPAN_WARNING("There is already \a 69holstered69 holstered here!"))
		return

	if (!(I.slot_flags & SLOT_HOLSTER))
		to_chat(user, SPAN_WARNING("69I69 won't fit in 69src69!"))
		return

	holstered = I
	user.drop_from_inventory(holstered)
	holstered.loc = src
	holstered.add_fingerprint(user)
	w_class =69ax(w_class, holstered.w_class)
	user.visible_message(SPAN_NOTICE("69user69 holsters \the 69holstered69."), SPAN_NOTICE("You holster \the 69holstered69."))
	name = "occupied 69initial(name)69"

/obj/item/clothing/accessory/holster/proc/clear_holster()
	holstered = null
	name = initial(name)

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as69ob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj))
		to_chat(user, SPAN_WARNING("You need an empty hand to draw \the 69holstered69!"))
	else
		if(user.a_intent == I_HURT)
			usr.visible_message(
				SPAN_DANGER("69user69 draws \the 69holstered69, ready to shoot!"),
				SPAN_WARNING("You draw \the 69holstered69, ready to shoot!")
				)
		else
			user.visible_message(
				SPAN_NOTICE("69user69 draws \the 69holstered69, pointing it at the ground."),
				SPAN_NOTICE("You draw \the 69holstered69, pointing it at the ground.")
				)
		if(!user.put_in_active_hand(holstered))// If your primary hand is full, draw with your offhand
			user.put_in_inactive_hand(holstered)// Prevents guns from getting deleted with hotkeys.
		holstered.add_fingerprint(user)
		w_class = initial(w_class)
		clear_holster()

/obj/item/clothing/accessory/holster/attack_hand(mob/user as69ob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj,69ob/user as69ob)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	..(user)
	if (holstered)
		to_chat(user, "A 69holstered69 is holstered here.")
	else
		to_chat(user, "It is empty.")

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S,69ob/user as69ob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as69ob)
	has_suit.verbs -= /obj/item/clothing/accessory/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/accessory/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return

	//can't we just use src here?
	var/obj/item/clothing/accessory/holster/H = null
	if (istype(src, /obj/item/clothing/accessory/holster))
		H = src
	else if (istype(src, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = src
		if (S.accessories.len)
			H = locate() in S.accessories

	if (!H)
		to_chat(usr, SPAN_WARNING("Something is69ery wrong."))

	if(!H.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, SPAN_WARNING("You need your gun equiped to holster it."))
			return
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/accessory/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry."
	icon_state = "holster"

/obj/item/clothing/accessory/holster/waist
	name = "waist holster"
	desc = "A handgun holster.69ade of expensive leather."
	icon_state = "holster"
	overlay_state = "holster_low"

/obj/item/clothing/accessory/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_hip"
