#define MODULAR_VERBS list(/obj/item/gun/projectile/automatic/modular/proc/quick_fold)

/obj/item/gun/projectile/automatic/modular // Parent type
	name = "\"Kalashnikov\""
	desc = "Weapon of the oppressed, oppressors, and extremists of all flavours. \
		 This is a copy of an ancient semi-automatic rifle. If it won't fire, percussive maintenance should get it working again. \
		 It is known for its easy maintenance, and low price."
	icon = 'icons/obj/guns/projectile/modular/ak.dmi'
	icon_state = "frame"
	item_state = "" // I do not believe this affects anything
	w_class = ITEM_SIZE_BULKY // Stock increases it by 1
	force = WEAPON_FORCE_PAINFUL
	caliber = null // Determined by barrel
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1) // Parts can give better tech
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = null // Long and drum magazines are determined by mechanism
	magazine_type = /obj/item/ammo_magazine/lrifle // Default magazine, only relevant for spawned AKs, not crafted or printed ones
	matter = list() // Gunparts are be stored within the gun as extra material
	price_tag = 0 // Debug item

	damage_multiplier = 1 // Mechanism + Barrel can modify
	penetration_multiplier = 0 // Mechanism + Barrel can modify
	spawn_blacklisted = TRUE
	bad_type = /obj/item/gun/projectile/automatic/modular

	// Will be regenerated on init
	gun_parts = list()

	// Determines what parts the modular gun accepts and required. 0 means required, -1 means optional. Order matters.
	var/list/required_parts = list(/obj/item/part/gun/modular/mechanism/autorifle = 0, /obj/item/part/gun/modular/barrel = 0, /obj/item/part/gun/modular/grip = 0, /obj/item/part/gun/modular/stock = -1)
	var/list/good_calibers = list()

	init_offset = 15 // Removed by grip, this is present just in case you don't want one for style reasons

	gun_tags = list() // We add modular to this first step within initialize()
	var/spriteTags = PARTMOD_STRIPPED // Tags to attach to sprites
	var/statusTags = PARTMOD_STRIPPED
	var/grip_type = ""

	init_firemodes = list( // Determined by mechanism
		SEMI_AUTO_300,
		)

	serial_type = "Excelsior"

	var/stock = STOCK_MISSING
	max_upgrades = 6

/obj/item/gun/projectile/automatic/modular/Initialize()

	gun_tags += GUN_MODULAR
	for(var/partPath in gun_parts)
		if(ispath(partPath))
			var/obj/item/part/gun/modular/new_part = new partPath
			if(!new_part.I.rapid_apply(src))
				visible_message(SPAN_WARNING("Something seems wrong... Maybe you should ask a professional for help?"))
	refresh_upgrades()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/modular/proc/get_initial_name()
	return "gun"

/obj/item/gun/projectile/automatic/modular/refresh_upgrades()
	caliber = initial(caliber)
	mag_well = initial(mag_well)
	spriteTags = initial(spriteTags)
	verbs -= MODULAR_VERBS // Removes all modularized verbs
	grip_type = initial(grip_type)
	good_calibers = list() // Won't ever be redefined, mechanism determines this, and when no mechanism is installed, we don't want anything here anyways
	..()
	name = get_initial_name()

/obj/item/gun/projectile/automatic/modular/update_icon() // V2
	..()
	cut_overlays() // This is where the fun begins

	// Determine base using the current stock status
	var/iconstring = initial(icon_state)
	var/itemstring = (PARTMOD_FRAME_SPRITE & spriteTags) ? ("_" + iconstring) : ("_" + grip_type)

	// Define "-" tags
	var/dashTag = ""
	if((PARTMOD_FOLDING_STOCK & spriteTags) && (PARTMOD_FOLDING_STOCK & statusTags))
		dashTag += "-st"
	if((PARTMOD_SLIDE & spriteTags) && !ammo_magazine)
		dashTag += "-e"

	// Add dashTag to iconstring
	iconstring += dashTag

	for(var/part_path in required_parts)
		var/obj/item/part/gun/modular/gun_part = locate(part_path) in contents
		if(gun_part && gun_part.part_overlay) // Safety check

			if(gun_part.needs_grip_type) // Will be replaced with a more modular system once V3 comes
				overlays += gun_part.part_overlay + "_" + grip_type + dashTag
			else
				overlays += gun_part.part_overlay + dashTag // Add the part's overlay, with respect to tags

			if(gun_part.part_itemstring && !(PARTMOD_FRAME_SPRITE & spriteTags)) // Part also wants to modify itemstring, and is allowed to
				itemstring = "_" + gun_part.part_overlay + itemstring // Add their overlay name

	if (ammo_magazine) // Warning! If a sprite is missing from the DMI despite being possible to insert ingame, it might have unforeseen consequences (no magazine showing up)
		itemstring += "_full"
		overlays += "mag_[ammo_magazine.mag_well][caliber]" + dashTag

	if(wielded)
		itemstring += "_doble" // Traditions are to be followed

	// Finally, we add the dashTag to the itemstring
	itemstring += dashTag

	icon_state = iconstring
	wielded_item_state = itemstring // Hacky solution to a hacky system. Reere forgive us. V3 will fix this.
	set_item_state(itemstring)

// Interactions

/obj/item/gun/projectile/automatic/modular/can_interact(mob/user)
	if((!ishuman(user) && (loc != user)) || user.stat || user.restrained())
		return 1
	if(istype(loc, /obj/item/storage))
		return 2
	return 0


/obj/item/gun/projectile/automatic/modular/CtrlShiftClick(mob/user)
	. = ..()

	var/able = can_interact(user)

	if(able == 1)
		return

	if(able == 2)
		to_chat(user, SPAN_NOTICE("You cannot manipulate \the [src] while it is in a container."))
		return

	// If we have a folding stock installed, attempt to fold
	if(PARTMOD_FOLDING_STOCK & spriteTags)
		fold()

/obj/item/gun/projectile/automatic/modular/proc/quick_fold(mob/user)
	set name = "Fold or Unfold Stock"
	set category = "Object"
	set src in view(1)

	if(can_interact(user) == 1)
		return

	fold(user)

/obj/item/gun/projectile/automatic/modular/proc/fold(user)

	if(PARTMOD_FOLDING_STOCK & spriteTags)
		if(PARTMOD_FOLDING_STOCK & statusTags)
			to_chat(user, SPAN_NOTICE("You fold the stock on \the [src]."))
			statusTags -= PARTMOD_FOLDING_STOCK
			w_class = initial(w_class)
		else
			to_chat(user, SPAN_NOTICE("You unfold the stock on \the [src]."))
			statusTags |= PARTMOD_FOLDING_STOCK
			w_class = initial(w_class) + 1

		refresh_upgrades()
		playsound(loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
		update_icon()
