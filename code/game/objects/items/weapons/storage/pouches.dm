/obj/item/weapon/storage/pouch
	name = "pouch"
	desc = "Can hold various things."
	icon = 'icons/inventory/pockets/icon.dmi'
	icon_state = "pouch"
	item_state = "pouch"

	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT //Pouches can be worn on belt
	storage_slots = 1
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_SMALL_STORAGE
	matter = list(MATERIAL_BIOMATTER = 12)
	attack_verb = list("pouched")
	spawn_blacklisted = FALSE
	rarity_value = 10
	spawn_tags = SPAWN_TAG_POUCH
	bad_type = /obj/item/weapon/storage/pouch

	var/sliding_behavior = FALSE

/obj/item/weapon/storage/pouch/verb/toggle_slide()
	set name = "Toggle Slide"
	set desc = "Toggle the behavior of last item in [src] \"sliding\" into your hand."
	set category = "Object"

	sliding_behavior = !sliding_behavior
	to_chat(usr, SPAN_NOTICE("Items will now [sliding_behavior ? "" : "not"] slide out of [src]"))

/obj/item/weapon/storage/pouch/attack_hand(mob/living/carbon/human/user)
	if(sliding_behavior && contents.len && (src in user))
		var/obj/item/I = contents[contents.len]
		if(istype(I))
			hide_from(usr)
			var/turf/T = get_turf(user)
			remove_from_storage(I, T)
			usr.put_in_hands(I)
			add_fingerprint(user)
	else
		..()

/obj/item/weapon/storage/pouch/small_generic
	name = "small generic pouch"
	desc = "Can hold anything in it, but only about once."
	icon_state = "small_generic"
	item_state = "small_generic"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 3)
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_SMALL_STORAGE * 0.5
	max_w_class = ITEM_SIZE_SMALL
	rarity_value = 10

/obj/item/weapon/storage/pouch/medium_generic
	name = "medium generic pouch"
	desc = "Can hold anything in it, but only about twice."
	icon_state = "medium_generic"
	item_state = "medium_generic"
	matter = list(MATERIAL_BIOMATTER = 24, MATERIAL_STEEL = 6 )
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_SMALL_STORAGE
	max_w_class = ITEM_SIZE_NORMAL
	rarity_value = 20

/obj/item/weapon/storage/pouch/large_generic
	name = "large generic pouch"
	desc = "A mini satchel. Can hold a fair bit, but it won't fit in your pocket"
	icon_state = "large_generic"
	item_state = "large_generic"
	matter = list(MATERIAL_BIOMATTER = 39, MATERIAL_STEEL = 9 )
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT | SLOT_DENYPOCKET
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_NORMAL_STORAGE
	max_w_class = ITEM_SIZE_NORMAL
	rarity_value = 100

/obj/item/weapon/storage/pouch/medical_supply
	name = "medical supply pouch"
	desc = "Can hold medical equipment. But only about three pieces of it."
	icon_state = "medical_supply"
	item_state = "medical_supply"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 33

	storage_slots = 3
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/device/scanner/health,
		/obj/item/weapon/dnainjector,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/clothing/glasses/hud/health,
		)

/obj/item/weapon/storage/pouch/engineering_tools
	name = "engineering tools pouch"
	desc = "Can hold small engineering tools. But only about three pieces of them."
	icon_state = "engineering_tool"
	item_state = "engineering_tool"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 20

	storage_slots = 3
	max_w_class = ITEM_SIZE_SMALL

	can_hold = list(
		/obj/item/weapon/tool,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/device/radio/headset,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/weapon/tool/minihoe,
		/obj/item/weapon/tool/hatchet,
		/obj/item/device/scanner/plant,
		/obj/item/weapon/extinguisher/mini,
		/obj/item/weapon/hand_labeler,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/cell/small,
		/obj/item/weapon/cell/medium
		)

/obj/item/weapon/storage/pouch/engineering_supply
	name = "engineering supply pouch"
	desc = "Can hold engineering equipment. But only about two pieces of it."
	icon_state = "engineering_supply"
	item_state = "engineering_supply"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 33

	storage_slots = 2
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/weapon/cell,
		/obj/item/weapon/electronics/circuitboard,
		/obj/item/weapon/tool,
		/obj/item/stack/material,
		/obj/item/weapon/material,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/device/scanner/plant,
		/obj/item/weapon/extinguisher/mini
		)

/obj/item/weapon/storage/pouch/ammo
	name = "ammo pouch"
	desc = "Can hold ammo magazines and bullets, not the boxes though."
	icon_state = "ammo"
	item_state = "ammo"
	matter = list(MATERIAL_BIOMATTER = 39, MATERIAL_STEEL = 3 )
	rarity_value = 33

	storage_slots = 3
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing
		)

/obj/item/weapon/storage/pouch/tubular
	name = "tubular pouch"
	desc = "Can hold five cylindrical and small items, including but not limiting to flares, glowsticks, syringes and even hatton tubes or rockets."
	icon_state = "flare"
	item_state = "flare"
	matter = list(MATERIAL_BIOMATTER = 14, MATERIAL_STEEL = 1 )
	rarity_value = 14

	storage_slots = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/device/lighting/glowstick,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/glass/beaker/vial,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/pen,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/hatton_magazine,
		/obj/item/ammo_casing/rocket,
		/obj/item/ammo_casing/grenade
		)

/obj/item/weapon/storage/pouch/tubular/vial
	name = "vial pouch"
	desc = "Can hold about five vials. Rebranding!"

/obj/item/weapon/storage/pouch/tubular/update_icon()
	..()
	overlays.Cut()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "flare_[contents.len]")

/obj/item/weapon/storage/pouch/pistol_holster
	name = "pistol holster"
	desc = "Can hold a handgun in."
	icon_state = "pistol_holster"
	item_state = "pistol_holster"
	rarity_value = 33

	storage_slots = 1
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/weapon/gun/projectile/clarissa,
		/obj/item/weapon/gun/projectile/colt,
		/obj/item/weapon/gun/projectile/avasarala,
		/obj/item/weapon/gun/projectile/giskard,
		/obj/item/weapon/gun/projectile/gyropistol,
		/obj/item/weapon/gun/projectile/handmade_pistol,
		/obj/item/weapon/gun/projectile/lamia,
		/obj/item/weapon/gun/projectile/mk58,
		/obj/item/weapon/gun/projectile/olivaw,
		/obj/item/weapon/gun/projectile/mandella,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/weapon/gun/energy/chameleon,
		//obj/item/weapon/gun/energy/captain, //too unwieldy, use belt/suit slot or other storage
		/obj/item/weapon/gun/energy/stunrevolver,
		/obj/item/weapon/gun/projectile/revolver,
		/obj/item/weapon/gun/projectile/automatic/molly,
		/obj/item/weapon/gun/projectile/paco,
		/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn, //short enough to fit in
		/obj/item/weapon/gun/launcher/syringe,
		/obj/item/weapon/gun/energy/plasma/brigador
		)

	sliding_behavior = TRUE

/obj/item/weapon/storage/pouch/pistol_holster/update_icon()
	..()
	overlays.Cut()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "pistol_layer")

/obj/item/weapon/storage/pouch/baton_holster
	name = "baton sheath"
	desc = "Can hold a baton, or indeed most weapon shafts."
	icon_state = "baton_holster"
	item_state = "baton_holster"
	rarity_value = 33

	storage_slots = 1
	max_w_class = ITEM_SIZE_BULKY

	can_hold = list(
		/obj/item/weapon/melee,
		/obj/item/weapon/tool/crowbar
		)

	sliding_behavior = TRUE

/obj/item/weapon/storage/pouch/baton_holster/update_icon()
	..()
	overlays.Cut()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "baton_layer")

/obj/item/weapon/storage/pouch/holding
	name = "pouch of holding"
	desc = "If your pockets are not large enough to store all your belongings, you may want to use this high-tech pouch that opens into a localized pocket of bluespace (pun intended)."
	icon_state = "holdingpouch"
	item_state = "holdingpouch"
	storage_slots = 7
	max_w_class = ITEM_SIZE_BULKY
	max_storage_space = DEFAULT_HUGE_STORAGE
	matter = list(MATERIAL_STEEL = 4, MATERIAL_GOLD = 5, MATERIAL_DIAMOND = 2, MATERIAL_URANIUM = 2)
	origin_tech = list(TECH_BLUESPACE = 4)
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/pouch/holding/New()
	..()
	bluespace_entropy(3, get_turf(src))
