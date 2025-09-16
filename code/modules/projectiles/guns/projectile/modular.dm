#define MODULAR_VERBS list(/obj/item/gun/projectile/automatic/modular/proc/quick_fold)


/obj/item/gun/projectile/automatic/modular // Parent type
	name = "\"Kalashnikov\"" // Names are also used by vendors. When making a specific gun, make sure it contains the right name.
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
	magazine_type = null // Default magazine, only relevant for spawned AKs, not crafted or printed ones

	damage_multiplier = 1 // Mechanism + Barrel can modify
	penetration_multiplier = 0 // Mechanism + Barrel can modify
	spawn_blacklisted = TRUE
	bad_type = /obj/item/gun/projectile/automatic/modular

	// Parts generated when the item spawns. Keep empty for parent objects. Associated value determines quality.
	gun_parts = list()

	// Determines what parts the modular gun accepts and required. 0 means required, -1 means optional. Order matters.
	var/list/required_parts = list(/obj/item/part/gun/modular/mechanism/autorifle = 0, /obj/item/part/gun/modular/barrel = 0, /obj/item/part/gun/modular/grip = 0, /obj/item/part/gun/modular/stock = -1)
	var/list/good_calibers = list()

	init_offset = 15 // Removed by grip, this is present just in case you don't want one for style reasons

	gun_tags = list() // We add modular to this first step within initialize()
	var/spriteTags = PARTMOD_STRIPPED // Tags to attach to sprites
	var/spriteTagBans = PARTMOD_STRIPPED // To be removed when V3 comes
	var/statusTags = PARTMOD_STRIPPED
	var/grip_type = ""

	var/itemstring // Saved due to set_item_state being drycalled. Not worth to rework imo, but it is a good way to waste time if someone has some spare.

	init_firemodes = list( // Determined by mechanism
		SEMI_AUTO_300,
		)

	serial_type = "Excelsior"

	max_upgrades = 6

	var/list/scope_damage_adds = list()
	var/datum/gunoverrides/overridedatum

/obj/item/gun/projectile/automatic/modular/Initialize()

	gun_tags += GUN_MODULAR
	for(var/partPath in gun_parts)
		if(ispath(partPath))
			var/obj/item/part/gun/modular/new_part = new partPath(quality = gun_parts[partPath])
			if(!new_part.I.rapid_apply(src))
				visible_message(span_warning("Something seems wrong... Maybe you should ask a professional for help?"))
	overridedatum = new()
	refresh_upgrades()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/modular/set_quality(new_quality = 0, doesReset = TRUE)
	for(var/part_path in required_parts)
		var/obj/item/part/gun/modular/gun_part = locate(part_path) in contents
		if(gun_part)
			gun_part.set_quality(doesReset ? new_quality : min(gun_part.old_quality + new_quality))
	return TRUE

/obj/item/gun/projectile/automatic/modular/proc/get_initial_name()
	return "gun"

/obj/item/gun/projectile/automatic/modular/refresh_upgrades()
	caliber = initial(caliber)
	mag_well = initial(mag_well)
	spriteTags = initial(spriteTags)
	verbs -= MODULAR_VERBS // Removes all modularized verbs
	grip_type = initial(grip_type)
	good_calibers = list() // Won't ever be redefined, mechanism determines this, and when no mechanism is installed, we don't want anything here anyways
	no_internal_mag = initial(no_internal_mag)
	scope_damage_adds = list()
	overridedatum?.reset() // clear first
	..()
	reset_action_buttons()
	overridedatum?.cycle() // then use an assignment sort
	name = get_initial_name()

/obj/item/gun/projectile/automatic/modular/update_icon() // V2
	cut_overlays() // This is where the fun begins

	// Determine base using the current stock status
	var/iconstring = initial(icon_state)
	itemstring = (PARTMOD_FRAME_SPRITE & spriteTags) ? ("_" + iconstring) : ("_" + grip_type)

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

/obj/item/gun/projectile/automatic/modular/set_item_state(state, hands = TRUE, back = TRUE, onsuit = TRUE) // TODO: check why a billion procs call set_item_state with no state provided

	if(!state)
		state = itemstring
	var/wield_state
	if(wielded_item_state)
		wield_state = wielded_item_state
	if(!(hands || back || onsuit))
		hands = back = onsuit = TRUE
	if(hands)//Ok this is a bit hacky. But basically if the gun is wielded, we want to use the wielded icon state over the other one.
		if(wield_state && wielded)//Because most of the time the "normal" icon state is held in one hand. This could be expanded to be less hacky in the future.
			item_state_slots[slot_l_hand_str] = "lefthand"  + wield_state
			item_state_slots[slot_r_hand_str] = "righthand" + wield_state

		else
			item_state_slots[slot_l_hand_str] = "lefthand"  + state
			item_state_slots[slot_r_hand_str] = "righthand" + state
	state = initial(state)

	var/carry_state = inversed_carry
	if(back && !carry_state)
		item_state_slots[slot_back_str]   = "back"		+ state
	if(back && carry_state)
		item_state_slots[slot_back_str]   = "onsuit"	+ state
	if(onsuit && !carry_state)
		item_state_slots[slot_s_store_str]= "onsuit"    + state
	if(onsuit && carry_state)
		item_state_slots[slot_s_store_str]= "back"		+ state

// Interactions

/datum/gunoverrides
	var/list/priorities = list()

/datum/gunoverrides/proc/reset()
	for(var/list/wiped in priorities)
		wiped.Cut()
	priorities.Cut()

/datum/gunoverrides/proc/call_Flag(obj/item/load, user, flag)
	for(var/key in priorities)
		var/list/priority = priorities[key]
		var/done = FALSE
		for(var/datum/guninteraction/tocheck in priority) // highest numbers first.
			if(tocheck.interactionflags & flag)
				switch(flag)
					if(GI_ATTACKSELF)
						if(tocheck.attack_self(user))
							done = TRUE
					if(GI_LOAD)
						if(tocheck.load_ammo(load, user))
							done = TRUE
					if(GI_UNLOAD)
						if(tocheck.unload_ammo(user))
							done = TRUE
					if(GI_SPECIAL)
						if(tocheck.special_check(user))
							done = TRUE
		if(done)
			return TRUE

/datum/gunoverrides/proc/cycle()
	var/list/slate = list()
	for(var/number = 4, number >= 0, number -= 1)
		slate["[number]"] = priorities["[number]"] ? priorities["[number]"] : null
	priorities = slate.Copy()

/obj/item/gun/projectile/automatic/modular/attack_self(mob/user)
	if(!overridedatum.call_Flag(user = user, flag = GI_ATTACKSELF))
		. = ..()

/obj/item/gun/projectile/automatic/modular/load_ammo(obj/item/A, mob/user)
	if(!overridedatum.call_Flag(load = A, user = user, flag = GI_LOAD))
		. = ..()


/obj/item/gun/projectile/automatic/modular/unload_ammo(mob/user, allow_dump)
	if(!overridedatum.call_Flag(user = user, flag = GI_UNLOAD))
		. = ..()

/obj/item/gun/projectile/automatic/modular/special_check(mob/user)
	if(!overridedatum.call_Flag(user = user, flag = GI_SPECIAL))
		. = ..()

/obj/item/gun/projectile/automatic/modular/hand_spin(mob/living/carbon/caller)
	overridedatum.call_Flag(user = caller, flag = GI_SPIN)

/obj/item/gun/projectile/automatic/modular/proc/reset_action_buttons()
	for(var/key in overridedatum.priorities)
		var/list/priority = overridedatum.priorities[key]
		for(var/datum/guninteraction/tocheck in priority) // highest numbers first.
			if(tocheck.action_button_name && tocheck.action_button_proc)
				action_button_name = tocheck.action_button_name
				action_button_proc = tocheck.action_button_proc
				return TRUE // can only have one button
	// if we didn't override them
	action_button_name = initial(action_button_name)
	action_button_proc = initial(action_button_proc)
	qdel(action)

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
		to_chat(user, span_notice("You cannot manipulate \the [src] while it is in a container."))
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
		for(var/obj/item/part/gun/modular/stock/toedit in gun_parts) // only gonna edit one, doing this to find it
			if(PARTMOD_FOLDING_STOCK & statusTags)
				to_chat(user, span_notice("You fold the stock on \the [src]."))
				statusTags -= PARTMOD_FOLDING_STOCK
				toedit.I.weapon_upgrades[GUN_UPGRADE_DEFINE_WCLASS] = 0
			else
				to_chat(user, span_notice("You unfold the stock on \the [src]."))
				statusTags |= PARTMOD_FOLDING_STOCK
				toedit.I.weapon_upgrades[GUN_UPGRADE_DEFINE_WCLASS] = toedit.wclassmod
			break

		refresh_upgrades()

		playsound(loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
		update_icon()

/obj/item/gun/projectile/automatic/modular/attackby(obj/item/I, mob/living/user, params)
	var/tool_type = I.get_tool_type(user, list(serial_type ? QUALITY_HAMMERING : null), src)
	switch(tool_type)
		if(QUALITY_HAMMERING)
			user.visible_message(span_notice("[user] begins scribbling \the [name]'s gun serial number away."), span_notice("You begin removing the serial number from \the [name]."))
			if(I.use_tool(user, src, WORKTIME_SLOW, QUALITY_HAMMERING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				user.visible_message(span_danger("[user] removes \the [name]'s gun serial number."), span_notice("You successfully remove the serial number from \the [name]."))
				serial_type = null
				return FALSE
	load_ammo(I, user)
	update_held_icon()

/obj/item/gun/projectile/automatic/modular/zoom(tileoffset, viewsize, stayzoomed)
	..()
	refresh_upgrades()
	if(zoom)
		var/currentzoom = zoom_factors.Find(active_zoom_factor)
		var/extra_damage
		if(scope_damage_adds[currentzoom])
			extra_damage = scope_damage_adds[currentzoom]
		damage_multiplier += extra_damage

