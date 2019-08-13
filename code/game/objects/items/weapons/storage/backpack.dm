
/*
 * Backpack
 */

/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_backpacks.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_backpacks.dmi',
		)
	icon_state = "backpack"
	//most backpacks use the default backpack state for inhand overlays
	item_state_slots = list(
		slot_l_hand_str = "backpack",
		slot_r_hand_str = "backpack",
		)
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = 40
	var/worn_access = FALSE

/obj/item/weapon/storage/backpack/New()
	if (!item_state)
		item_state = icon_state
	..()

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (!worn_check())
		return
	..()

/obj/item/weapon/storage/backpack/attack_hand(mob/user)
	if (!worn_check(no_message = TRUE))
		if(src.loc != user || user.incapacitated())
			return
		if (!user.unEquip(src))
			return
		user.put_in_active_hand(src)
		return
	..()

/obj/item/weapon/storage/backpack/equipped(var/mob/user, var/slot)
	..(user, slot)
	if (use_sound)
		playsound(loc, use_sound, 50, 1, -5)
	if(!worn_access && is_worn()) //currently looking into the backpack
		close(user)


/obj/item/weapon/storage/backpack/open(mob/user)
	if (!worn_check())
		return
	..()


/obj/item/weapon/storage/backpack/proc/worn_check(var/no_message = FALSE)
	if(!worn_access && is_worn())
		var/mob/living/L = loc
		if (istype(L))
			if(!no_message)
				to_chat(L, "<span class='warning'>Oh no! Your arms are not long enough to open [src] while it is on your back!</span>")
		if (!no_message && use_sound)
			playsound(loc, use_sound, 50, 1, -5)
		return FALSE

	return TRUE
/*
 * Backpack Types
 */

/obj/item/weapon/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = 100
	storage_cost = 29
	matter = list(MATERIAL_STEEL = 10, MATERIAL_GOLD = 10, MATERIAL_DIAMOND = 5, MATERIAL_URANIUM = 5)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/storage/backpack/holding))
			to_chat(user, SPAN_WARNING("The Bluespace interfaces of the two devices conflict and malfunction."))
			qdel(W)
			return
		..()

	//Please don't clutter the parent storage item with stupid hacks.
	can_be_inserted(obj/item/W as obj, stop_messages = 0)
		if(istype(W, /obj/item/weapon/storage/backpack/holding))
			return 1
		return ..()

/obj/item/weapon/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 400 // can store a ton of shit!
	item_state_slots = null

/obj/item/weapon/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state_slots = null

//Used by mercs
/obj/item/weapon/storage/backpack/military
	name = "MOLLE pack"
	desc = "Designed for planetary infantry, holds a lot of equipment."
	icon_state = "militarypack"
	item_state_slots = null
	max_storage_space = 50

/obj/item/weapon/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for officers."
	icon_state = "captainpack"
	item_state_slots = null

/obj/item/weapon/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack for the daily grind of station life."
	icon_state = "engiepack"
	item_state_slots = null

/*
 * Satchel Types
 */

/obj/item/weapon/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	max_storage_space = 24
	worn_access = TRUE

/obj/item/weapon/storage/backpack/satchel/withwallet
	New()
		..()
		new /obj/item/weapon/storage/wallet/random( src )

/obj/item/weapon/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"
	max_storage_space = 24
	worn_access = TRUE

/obj/item/weapon/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state_slots = list(
		slot_l_hand_str = "engiepack",
		slot_r_hand_str = "engiepack",
		)
	max_storage_space = 24
	worn_access = TRUE

/obj/item/weapon/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state_slots = list(
		slot_l_hand_str = "medicalpack",
		slot_r_hand_str = "medicalpack",
		)
	max_storage_space = 24
	worn_access = TRUE

/obj/item/weapon/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack",
		)
	max_storage_space = 24
	worn_access = TRUE

/obj/item/weapon/storage/backpack/satchel/cap
	name = "captain's satchel"
	desc = "An exclusive satchel for officers."
	icon_state = "satchel-cap"
	item_state_slots = list(
		slot_l_hand_str = "satchel-cap",
		slot_r_hand_str = "satchel-cap",
		)
	max_storage_space = 24
	worn_access = TRUE