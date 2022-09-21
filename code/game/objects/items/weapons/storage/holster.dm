/obj/item/storage/pouch/holster
	name = "pistol holster"
	desc = "Can hold a handgun in."
	icon_state = "pistol_holster"
	item_state = "pistol_holster"
	rarity_value = 60
	price_tag = 200
	storage_slots = 1
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
		/obj/item/gun/projectile/automatic/luty
		)

	sliding_behavior = TRUE

/obj/item/storage/pouch/holster/baton
	name = "baton sheath"
	desc = "Can hold a baton, or indeed most weapon shafts."
	icon_state = "baton_holster"
	item_state = "baton_holster"
	rarity_value = 50

	storage_slots = 1
	max_w_class = ITEM_SIZE_BULKY

	can_hold = list(
		/obj/item/melee,
		/obj/item/tool/crowbar
		)

	sliding_behavior = TRUE

/obj/item/storage/pouch/holster/belt
	name = "belt holster"
	desc = "Can hold two handguns in. Quick on the draw!"
	icon_state = "belt_holster"
	item_state = "belt_holster"
	rarity_value = 40

	slot_flags = SLOT_BELT
	price_tag = 240
	matter = list(MATERIAL_BIOMATTER = 5)

	sound_in = 'sound/effects/holsterin.ogg'
	sound_out = 'sound/effects/holsterout.ogg'

	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_HUGE

	storage_slots = 2

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

//For the holster hotkey
/obj/item/storage/pouch/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!isliving(usr))
		return
	if(usr.stat)
		return

	if(istype(usr.get_active_hand(),/obj))
		attackby(usr.get_active_hand(), usr)
	else
		attack_hand(usr)//and that's it


/obj/item/storage/pouch/holster/attack_hand()
	if(contents.len)
		var/obj/item/I = contents[contents.len]
		if(istype(I))
			if(usr.a_intent == I_HURT)
				usr.visible_message(
					SPAN_DANGER("[usr] draws \the [I], ready to fight!"),
						SPAN_WARNING("You draw \the [I], ready to fight!")
					)
			else
				usr.visible_message(
					SPAN_NOTICE("[usr] draws \the [I], pointing it at the ground."),
					SPAN_NOTICE("You draw \the [I], pointing it at the ground.")
					)
			add_fingerprint(usr)
			playsound(usr, "[src.sound_out]", 75, 0)
			update_icon()
			w_class = initial(w_class)
			name = "[initial(name)]"
	..()

/obj/item/storage/pouch/holster/attackby(obj/item/I, mob/user)
	add_fingerprint(usr)
	w_class = max(w_class, src.w_class)
	name = "occupied [initial(name)]"
	playsound(usr, "[src.sound_in]", 75, 0)
	update_icon()
	..()

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
	var/icon_to_set
	for(var/obj/item/SW in contents)
		icon_to_set = SW.icon_state
	icon_state = "sheath_[contents.len ? icon_to_set :"0"]"
	item_state = "sheath_[contents.len ? icon_to_set :"0"]"
	..()

/obj/item/storage/pouch/holster/belt/sheath/improvised/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		add_overlay(image('icons/inventory/accessory/icon.dmi', "sheath_scrapsword_layer"))

