/obj/item/storage/pouch/holster
	name = "pistol holster"
	desc = "Can hold a handgun in."
	icon_state = "pistol_holster"
	item_state = "pistol_holster"
	rarity_value = 60
	price_tag = 200
	storage_slots = 1
	description_info = "Holsters like these can be quickly used with the \'H\' hotkey.\
	The hotkey prioritizes holsters that are put in back, suit slot or belt slot above the ones in your pockets."
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL
	spawn_tags = SPAWN_TAG_HOLSTER

	var/sound_in = 'sound/effects/holsterin.ogg'
	var/sound_out = 'sound/effects/holsterout.ogg'

	can_hold = list(
		/obj/item/gun/projectile/selfload,
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/avasarala,
		/obj/item/gun/projectile/giskard,
		/obj/item/gun/projectile/gyropistol,
		/obj/item/gun/projectile/handmade_pistol,
		/obj/item/gun/projectile/flare_gun,
		/obj/item/gun/projectile/lamia,
		/obj/item/gun/projectile/mk58,
		/obj/item/gun/projectile/olivaw,
		/obj/item/gun/projectile/mandella,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/chameleon,
		/obj/item/gun/energy/captain,
		/obj/item/gun/energy/stunrevolver,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/projectile/automatic/molly,
		/obj/item/gun/projectile/paco,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn, //short enough to fit in
		/obj/item/gun/launcher/syringe,
		/obj/item/gun/energy/plasma/brigador,
		/obj/item/gun/projectile/shotgun/pump/sawn,
		/obj/item/gun/projectile/boltgun/obrez,
		/obj/item/gun/energy/retro/sawn,
		/obj/item/gun/projectile/automatic/luty,
		/obj/item/gun/projectile/revolver/hornet,
		/obj/item/gun/projectile/pistol/type_62,
		/obj/item/gun/projectile/pistol/type_90,
		/obj/item/gun/projectile/shotgun/type_21
		)

	sliding_behavior = TRUE

/obj/item/storage/pouch/holster/baton
	name = "baton sheath"
	desc = "Can hold a baton and most weapon shafts."
	icon_state = "baton_holster"
	item_state = "baton_holster"
	rarity_value = 50

	storage_slots = 1
	max_w_class = ITEM_SIZE_BULKY

	can_hold = list(
		/obj/item/melee,
		/obj/item/tool/crowbar,
		/obj/item/tool/hammer/,
		/obj/item/tool/hatchet
		)


/obj/item/storage/pouch/holster/belt
	name = "belt holster"
	desc = "Can hold two handguns in. Quick on the draw!"
	icon_state = "belt_holster"
	item_state = "belt_holster"
	rarity_value = 40

	slot_flags = SLOT_BELT | SLOT_DENYPOCKET
	price_tag = 240
	matter = list(MATERIAL_BIOMATTER = 5)

	sound_in = 'sound/effects/holsterin.ogg'
	sound_out = 'sound/effects/holsterout.ogg'

	max_w_class = ITEM_SIZE_HUGE

	storage_slots = 2

/obj/item/storage/pouch/holster/belt/knife
	name = "throwing knife pouch"
	desc = "You can continently store and quickly access all your throwing knives from this pouch."
	icon_state = "knife"
	item_state = "knife"
	rarity_value = 69
	price_tag = 100

	storage_slots = 4

	can_hold = list(
		/obj/item/stack/thrown/throwing_knife
		)

//Sheath
/obj/item/storage/pouch/holster/belt/sheath
	name = "sheath"
	desc = "A sturdy brown leather sheath with a gold trim, made to house a variety of swords."
	icon = 'icons/obj/sheath.dmi'
	icon_state = "sheath_0"
	item_state = "sheath_0"

	price_tag = 120

	storage_slots = 1

	sound_in = 'sound/effects/sheathin.ogg'
	sound_out = 'sound/effects/sheathout.ogg'

	can_hold = list(
		/obj/item/tool/sword/nt,
		/obj/item/tool/sword/nt_sword,
		/obj/item/tool/sword/saber,
		/obj/item/tool/sword/katana,
		/obj/item/tool/sword/katana/nano,
		/obj/item/tool/sword,
		/obj/item/toy/katana,
		/obj/item/tool/sword/improvised
		)
	cant_hold = list(
		/obj/item/tool/knife/dagger/nt,
		/obj/item/tool/sword/nt/halberd,
		/obj/item/tool/sword/nt/spear
		)

/obj/item/storage/pouch/holster/belt/sheath/improvised
	name = "makeshift sheath"
	desc = "A sturdy metal sheath with a rough finish. There's killing to do, draw your junkblade."
	icon_state = "sheath_scrapsword"
	price_tag = 50
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1)
	can_hold = list(/obj/item/tool/sword/improvised)

//Accessory holsters
/obj/item/clothing/accessory/holster
	name = "concealed carry holster"
	desc = "An inconspicious holster that can be attached to your uniform, right under your armpit. Can fit a handgun... And maybe something else, too."
	icon_state = "holster"
	slot = "utility"
	matter = list(MATERIAL_BIOMATTER = 5)
	price_tag = 160
	var/max_w_class = ITEM_SIZE_NORMAL
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_HOLSTER
	var/storage_slots = 1

	var/sound_in = 'sound/effects/holsterin.ogg'
	var/sound_out = 'sound/effects/holsterout.ogg'

	var/obj/item/storage/internal/holster
	var/list/can_hold = list(
		/obj/item/gun/projectile/selfload,
		/obj/item/gun/projectile/colt,
		/obj/item/gun/projectile/avasarala,
		/obj/item/gun/projectile/giskard,
		/obj/item/gun/projectile/gyropistol,
		/obj/item/gun/projectile/handmade_pistol,
		/obj/item/gun/projectile/flare_gun,
		/obj/item/gun/projectile/lamia,
		/obj/item/gun/projectile/mk58,
		/obj/item/gun/projectile/olivaw,
		/obj/item/gun/projectile/mandella,
		/obj/item/gun/projectile/pistol,
		/obj/item/gun/projectile/shotgun/type_21,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/chameleon,
		/obj/item/gun/energy/captain,
		/obj/item/gun/energy/stunrevolver,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/projectile/automatic/molly,
		/obj/item/gun/projectile/paco,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn, //short enough to fit in
		/obj/item/gun/launcher/syringe,
		/obj/item/gun/energy/plasma/brigador,
		/obj/item/gun/projectile/shotgun/pump/sawn,
		/obj/item/gun/projectile/boltgun/obrez,
		/obj/item/gun/energy/retro/sawn,
		/obj/item/gun/projectile/automatic/luty,
		/obj/item/gun/projectile/revolver/hornet,
		/obj/item/reagent_containers/food/snacks/mushroompizzaslice,
		/obj/item/reagent_containers/food/snacks/meatpizzaslice,
		/obj/item/reagent_containers/food/snacks/vegetablepizzaslice,
		/obj/item/bananapeel
		)

/obj/item/clothing/accessory/holster/knife
	name = "throwing knife rig"
	desc = "A rig for professionals at knife throwing."
	price_tag = 100
	storage_slots = 2

	can_hold = list(
		/obj/item/stack/thrown/throwing_knife
		)

/obj/item/clothing/accessory/holster/scabbard
	name = "scabbard"
	desc = "A sturdy brown leather scabbard with a gold trim, made to house a variety of swords. Needs to be attached to your uniform to be properly held in place."
	icon_state = "sheath"
	overlay_state = "sword"
	slot = "utility"
	max_w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/tool/sword)
	price_tag = 300
	sound_in = 'sound/effects/sheathin.ogg'
	sound_out = 'sound/effects/sheathout.ogg'

/obj/item/clothing/accessory/holster/scabbard/improvised
	name = "makeshift scabbard"
	desc = "A sturdy metal scabbard with a rough finish. There's killing to do, draw your junkblade!"
	icon_state = "sheath_scrapsword"
	overlay_state = "msword"
	price_tag = 50
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 1)
	can_hold = list(/obj/item/tool/sword/improvised)

/obj/item/clothing/accessory/holster/scabbard/ring
	name = "ring sheath"
	desc = "A crudely constructed metal ring that hangs off your waist, useful for holding hammers, baseball bats and hatchets."
	icon_state = "ring_sheath"
	overlay_state = "ring_sheath"
	max_w_class = ITEM_SIZE_BULKY
	can_hold = list(
		/obj/item/tool/hammer,
		/obj/item/tool/hatchet
		)
	price_tag = 20

/obj/item/clothing/accessory/holster/proc/handle_attack_hand(mob/user as mob)
	return holster.handle_attack_hand(user)

/obj/item/clothing/accessory/holster/proc/handle_mousedrop(var/mob/user, var/atom/over_object)
	return holster.handle_mousedrop(user, over_object)

/obj/item/clothing/accessory/holster/MouseDrop(obj/over_object)
	if(holster.handle_mousedrop(usr, over_object))
		return TRUE
	return ..()

/obj/item/clothing/accessory/holster/attackby(obj/item/I, mob/user)
	holster.attackby(I, user)
	playsound(user, "[src.sound_in]", 30, 0)

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(loc == has_suit)
		if(holster.contents.len)
			var/obj/item/I = holster.contents[holster.contents.len]
			if(istype(I))
				user.put_in_active_hand(I)
				playsound(user, "[src.sound_out]", 30, 0)
		else
			holster.open(user)
	else ..()

/obj/item/clothing/accessory/holster/New()
	..()
	holster = new /obj/item/storage/internal(src)
	holster.storage_slots = storage_slots
	holster.can_hold = can_hold
	holster.max_w_class = max_w_class
	holster.master_item = src

/obj/item/clothing/accessory/holster/Destroy()
	QDEL_NULL(holster)
	. = ..()

/obj/item/clothing/accessory/holster/attackby(obj/item/I, mob/user)
	holster.attackby(I, user)

//For the holster hotkey
//This verb is universal to any subtype of pouch/holster.
/obj/item/storage/pouch/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src = usr.contents
	if(!ishuman(usr))
		return
	if(usr.stat)
		return

	var/mob/living/carbon/human/H = usr

	//List of priorities for holster hotkey. Back, suit store, belt, left pocket, right pocket.
	//Back is for future holsters, if anyone decides to add those.
	var/list/holster_priority = list(
	H.back,
	H.s_store,
	H.belt,
	H.l_store,
	H.r_store,
	)

	var/holster_handled = FALSE
	for(var/obj/item/storage/pouch/holster/holster in holster_priority)
		if(H.get_active_hand())
			if(holster.contents.len < holster.storage_slots)//putting items in holsters
				holster.attackby(H.get_active_hand(), H)
				holster_handled = TRUE
				break
		else
			if(holster.contents.len)//pulling items out of holsters
				holster.attack_hand(H)
				holster_handled = TRUE
				break
	if(!holster_handled)
		to_chat(H, SPAN_NOTICE(H.get_active_hand() ? "You don't have any occupied holsters." : "All your holsters are occupied."))


/obj/item/storage/pouch/holster/attack_hand(mob/living/carbon/human/H)
	if(contents.len)
		var/obj/item/I = contents[contents.len]
		if(istype(I))
			if(H.a_intent == I_HURT)
				H.visible_message(
					SPAN_DANGER("[H] draws \the [I], ready to fight!"),
						SPAN_WARNING("You draw \the [I], ready to fight!")
					)
			else
				H.visible_message(
					SPAN_NOTICE("[H] draws \the [I], pointing it at the ground."),
					SPAN_NOTICE("You draw \the [I], pointing it at the ground.")
					)
			add_fingerprint(H)
			playsound(H, "[src.sound_out]", 75, 0)
			update_icon()
			name = "[initial(name)]"
	..()

/obj/item/storage/pouch/holster/attackby(obj/item/I, mob/user)
	if(can_be_inserted(I))
		add_fingerprint(user)
		playsound(usr, "[src.sound_in]", 75, 0)
		name = "occupied [initial(name)]"
		return handle_item_insertion(I)

/obj/item/storage/pouch/holster/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "pistol_layer")

/obj/item/storage/pouch/holster/baton/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "baton_layer")

/obj/item/storage/pouch/holster/belt/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "revolver_layer[contents.len]")

/obj/item/storage/pouch/holster/belt/sheath/update_icon()
	..()
	cut_overlays()
	var/icon_to_set
	for(var/obj/item/SW in contents)
		icon_to_set = SW.icon_state
	icon_state = "sheath_[contents.len ? icon_to_set :"0"]"
	item_state = "sheath_[contents.len ? icon_to_set :"0"]"

/obj/item/storage/pouch/holster/belt/knife/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "knife_[contents.len]")

/obj/item/storage/pouch/holster/belt/sheath/improvised/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		add_overlay(image('icons/inventory/accessory/icon.dmi', "sheath_scrapsword_layer"))

/obj/item/clothing/accessory/holster/scabbard/update_icon()
	var/icon_to_set
	for(var/obj/item/SW in contents)
		icon_to_set = SW.icon_state
	..()
	cut_overlays()
	if(contents.len)
		add_overlay(image('icons/inventory/accessory/icon.dmi', "sheath_[contents.len ? icon_to_set :"0"]"))

/obj/item/clothing/accessory/holster/scabbard/improvised/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		add_overlay(image('icons/inventory/accessory/icon.dmi', "sheath_scrapsword_layer"))
