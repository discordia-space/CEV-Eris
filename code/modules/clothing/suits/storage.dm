/obj/item/clothing/suit/storage
	item_flags = DRAG_AND_DROP_UNEQUIP|EQUIP_SOUNDS
	bad_type = /obj/item/clothing/suit/storage
	spawn_tags = SPAWN_TAG_CLOTHING_SUIT_STORAGE
	var/obj/item/storage/internal/pockets

/obj/item/clothing/suit/storage/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 2	//two slots
	pockets.max_w_class = ITEM_SIZE_SMALL		//fit only pocket sized items
	pockets.max_storage_space = 4

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	. = ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if ((is_worn() || is_held()) && !pockets.handle_attack_hand(user))
		return TRUE
	..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object)
	if(pockets.handle_mousedrop(usr, over_object))
		return TRUE
	..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/clothing/accessory)) // Do not put accessories into pockets
		pockets.attackby(W, user)
	..()

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/storage/toggle
	bad_type = /obj/item/clothing/suit/storage/toggle
	var/icon_open
	var/icon_closed
	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr
		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		if(icon_state == icon_open) //Will check whether icon state is currently set to the "open" or "closed" state and switch it around with a message to the user
			icon_state = icon_closed
			to_chat(usr, "You button up the coat.")
		else if(icon_state == icon_closed)
			icon_state = icon_open
			to_chat(usr, "You unbutton the coat.")
		else //in case some goofy admin switches icon states around without switching the icon_open or icon_closed
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how silly you are.")
			return
		update_wear_icon()	//so our overlays update

//Outerwear with a hoodie, used to put it up or down, like the Ritual Robe, but not a voidsuit. Adopted much from voidsuit.
/obj/item/clothing/suit/storage/toggle/robe
	bad_type = /obj/item/clothing/suit/storage/toggle/robe
	var/obj/item/clothing/head/robe/hood //Deployable Hood, if any.
	var/icon_up
	var/icon_down

/obj/item/clothing/suit/storage/toggle/robe/Initialize()
	if(hood && ispath(hood))
		hood = new hood(src)

/obj/item/clothing/suit/storage/toggle/robe/ui_action_click(mob/living/user, action_name)
	if(..())
		return TRUE
	toggle_hood()

/obj/item/clothing/suit/storage/toggle/robe/clean_blood()
	//So that you dont have to detach the components to clean them, also since you can't detach the helmet
	if(hood) hood.clean_blood()

	return ..()

/obj/item/clothing/suit/storage/toggle/robe/decontaminate()
	if(hood) hood.decontaminate()

	return ..()

/obj/item/clothing/suit/storage/toggle/robe/make_young()
	..()
	if(hood) hood.make_young()

/obj/item/clothing/suit/storage/toggle/robe/equipped(mob/M)
	..()

	if(is_held())
		lower_hood()

	var/mob/living/carbon/human/H = M

	if(!istype(H)) return

	if(H.wear_suit != src)
		return

	if(hood)
		toggle_hood()

/obj/item/clothing/suit/storage/toggle/robe/dropped()
	..()
	lower_hood()

/obj/item/clothing/suit/storage/toggle/robe/proc/lower_hood()
	var/mob/living/carbon/human/H

	if(hood)
		hood.canremove = 1
		H = hood.loc
		if(istype(H))
			if(hood && H.head == hood)
				H.drop_from_inventory(hood)
				hood.forceMove(src)
				icon_state = icon_down
				if(hood.overslot)
					hood.remove_overslot_contents(H)

/obj/item/clothing/suit/storage/toggle/robe/verb/toggle_hood()
	set name = "Toggle Hood"
	set category = "Object"
	set src in usr
		
	if(!isliving(loc))
		return

	if(!hood)
		to_chat(usr, "There is no hood attached.")
		return

	var/mob/living/carbon/human/H = usr

	if(!istype(H)) return
	if(H.stat) return
	if(H.wear_suit != src) return

	if(H.head == hood)
		to_chat(H, SPAN_NOTICE("You lower your hood."))
		hood.canremove = 1
		H.drop_from_inventory(hood)
		hood.forceMove(src)
		icon_state = icon_down
		playsound(src.loc, "rustle", 75, 1)
	else
		if(H.head)
			to_chat(H, SPAN_DANGER("You cannot raise your hood while wearing \the [H.head]."))
			return
		if(H.equip_to_slot_if_possible(hood, slot_head))
			hood.canremove = 0
			to_chat(H, "<span class='info'>You raise your hood, obscuring your face.</span>")
			icon_state = icon_up
			playsound(src.loc, "rustle", 75, 1)

/obj/item/clothing/suit/storage/vest/merc/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEM_SIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/storage/vest/ironhammer/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEM_SIZE_SMALL
	pockets.max_storage_space = 8

//Makeshift chest rig.
/obj/item/clothing/suit/storage/vest/chestrig
	name = "makeshift chest rig"
	desc = "A makeshift chest rig made for carrying some stuff. Can carry four small items. Has little protective value.."
	icon_state = "mchestrig"
	item_state = "mchestrig"
	armor = list(
		melee = 2,
		bullet = 2,
		energy = 2,
		bomb = 5,
		bio = 0,
		rad = 0
	)
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/storage/vest/chestrig/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_w_class = ITEM_SIZE_SMALL
	pockets.max_storage_space = 8

