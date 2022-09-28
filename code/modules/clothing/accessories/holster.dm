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
	var/sound_in = 'sound/effects/holsterin.ogg'
	var/sound_out = 'sound/effects/holsterout.ogg'
	var/list/can_hold

/obj/item/clothing/accessory/holster/proc/holster(obj/item/I, mob/living/user)
	if(holstered && istype(user))
		to_chat(user, SPAN_WARNING("There is already \a [holstered] holstered here!"))
		return

	if (LAZYLEN(can_hold))
		if(!is_type_in_list(I, can_hold))
			to_chat(user, SPAN_WARNING("\The [I] won\'t fit in \the [src]!"))
			return

	else if (!(I.slot_flags & SLOT_HOLSTER))
		to_chat(user, SPAN_WARNING("[I] won't fit in [src]!"))
		return

	holstered = I
	user.drop_from_inventory(holstered)
	holstered.loc = src
	holstered.add_fingerprint(user)
	w_class = max(w_class, holstered.w_class)
	user.visible_message(SPAN_NOTICE("[user] holsters \the [holstered]."), SPAN_NOTICE("You holster \the [holstered]."))
	name = "occupied [initial(name)]"
	playsound(user, "[sound_in]", 75, 0)
	update_icon()

/obj/item/clothing/accessory/holster/proc/clear_holster()
	holstered = null
	name = initial(name)

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj))
		to_chat(user, SPAN_WARNING("You need an empty hand to draw \the [holstered]!"))
	else
		if(user.a_intent == I_HURT)
			usr.visible_message(
				SPAN_DANGER("[user] draws \the [holstered], ready to fight!"),
				SPAN_WARNING("You draw \the [holstered], ready to fight!")
				)
		else
			user.visible_message(
				SPAN_NOTICE("[user] draws \the [holstered], pointing it at the ground."),
				SPAN_NOTICE("You draw \the [holstered], pointing it at the ground.")
				)
		if(!user.put_in_active_hand(holstered))// If your primary hand is full, draw with your offhand
			user.put_in_inactive_hand(holstered)// Prevents guns from getting deleted with hotkeys.
		holstered.add_fingerprint(user)
		playsound(user, "[sound_out]", 75, 0)
		update_icon()
		w_class = initial(w_class)
		clear_holster()

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	..(user)
	if (holstered)
		to_chat(user, "\A [holstered] is holstered here.")
	else
		to_chat(user, "It is empty.")

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as mob)
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
		to_chat(usr, SPAN_WARNING("Something is very wrong."))

	if(!H.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, SPAN_WARNING("You need your weapon equipped to holster it."))
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
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	overlay_state = "holster_low"

/obj/item/clothing/accessory/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_hip"

//Sword holsters//

/obj/item/clothing/accessory/holster/saber
	name = "scabbard"
	desc = "A sturdy brown leather scabbard with a gold trim, made to house a variety of swords."
	icon_state = "sheath"
	overlay_state = "sword"
	slot = "utility"
	can_hold = list(/obj/item/tool/sword)
	price_tag = 200
	sound_in = 'sound/effects/sheathin.ogg'
	sound_out = 'sound/effects/sheathout.ogg'

/obj/item/clothing/accessory/holster/saber/update_icon()
	var/icon_to_set
	for(var/obj/item/SW in contents)
		icon_to_set = SW.icon_state
	..()
	cut_overlays()
	if(contents.len)
		add_overlay(image('icons/inventory/accessory/icon.dmi', "sheath_[contents.len ? icon_to_set :"0"]"))

/obj/item/clothing/accessory/holster/saber/improvised
	name = "makeshift scabbard"
	desc = "A sturdy metal scabbard with a rough finish. There's killing to do, draw your junkblade."
	icon_state = "sheath_scrapsword"
	overlay_state = "msword"
	price_tag = 50
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1)
	can_hold = list(/obj/item/tool/sword/improvised)

/obj/item/clothing/accessory/holster/saber/improvised/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		add_overlay(image('icons/inventory/accessory/icon.dmi', "sheath_scrapsword_layer"))
