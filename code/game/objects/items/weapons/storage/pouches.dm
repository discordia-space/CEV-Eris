/obj/item/storage/pouch
	name = "pouch"
	desc = "Can hold various things."
	icon = 'icons/inventory/pockets/icon.dmi'
	//icon_state = "pouch" //TODO
	//item_state = "pouch" //TODO

	volumeClass = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT //Pouches can be worn on belt
	storage_slots = 1
	max_volumeClass = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_SMALL_STORAGE
	matter = list(MATERIAL_BIOMATTER = 12)
	attack_verb = list("pouched")
	spawn_blacklisted = FALSE
	rarity_value = 10
	spawn_tags = SPAWN_TAG_POUCH
	price_tag = 120
	bad_type = /obj/item/storage/pouch

	var/sliding_behavior = FALSE

/obj/item/storage/pouch/verb/toggle_slide()
	set name = "Toggle Slide"
	set desc = "Toggle the behavior of last item in [src] \"sliding\" into your hand."
	set category = "Object"

	sliding_behavior = !sliding_behavior
	to_chat(usr, SPAN_NOTICE("Items will now [sliding_behavior ? "" : "not"] slide out of [src]"))

/obj/item/storage/pouch/attack_hand(mob/living/carbon/human/user)
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

/obj/item/storage/pouch/small_generic
	name = "small generic pouch"
	desc = "Can hold anything in it, but only about once."
	icon_state = "small_generic"
	item_state = "small_generic"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 3)
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_SMALL_STORAGE * 0.5
	max_volumeClass = ITEM_SIZE_SMALL
	rarity_value = 10
	price_tag = 100

/obj/item/storage/pouch/medium_generic
	name = "medium generic pouch"
	desc = "Can hold anything in it, but only about twice."
	icon_state = "medium_generic"
	item_state = "medium_generic"
	matter = list(MATERIAL_BIOMATTER = 24, MATERIAL_STEEL = 6 )
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_SMALL_STORAGE
	max_volumeClass = ITEM_SIZE_NORMAL
	rarity_value = 20
	price_tag = 255

/obj/item/storage/pouch/large_generic
	name = "large generic pouch"
	desc = "A mini satchel. Can hold a fair bit, but it won't fit in your pocket"
	icon_state = "large_generic"
	item_state = "large_generic"
	matter = list(MATERIAL_BIOMATTER = 39, MATERIAL_STEEL = 9 )
	volumeClass = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT | SLOT_DENYPOCKET
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_NORMAL_STORAGE
	max_volumeClass = ITEM_SIZE_NORMAL
	rarity_value = 100
	price_tag = 410

/obj/item/storage/pouch/medical_supply
	name = "medical supply pouch"
	desc = "A small pouch for holding medical supplies."
	icon_state = "medical_supply"
	item_state = "medical_supply"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 33

	storage_slots = null 
	max_storage_space = DEFAULT_SMALL_STORAGE //Medkits typically hold 5 items in them, this is pocket medkit
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/device/scanner/health,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/stack/nanopaste
		)

/obj/item/storage/pouch/engineering_tools
	name = "engineering tools pouch"
	desc = "A pouch for holding engineering tools. Looks like there are pockets in it for 4 tools."
	icon_state = "engineering_tool"
	item_state = "engineering_tool"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 20

	storage_slots = 4 
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/tool,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/device/radio/headset,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/tool/minihoe,
		/obj/item/tool/hatchet,
		/obj/item/device/scanner/plant,
		/obj/item/extinguisher/mini,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses,
		/obj/item/flame/lighter,
		/obj/item/cell/small,
		/obj/item/cell/medium,
		/obj/item/gun/projectile/flare_gun,
		/obj/item/stack/nanopaste
		)

/obj/item/storage/pouch/engineering_supply
	name = "engineering supply pouch"
	desc = "A pouch for holding various engineering scanners, power cells and equipment."
	icon_state = "engineering_supply"
	item_state = "engineering_supply"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 33

	storage_slots = null
	max_storage_space = DEFAULT_NORMAL_STORAGE * 0.8 //Not as big as a large pouch, even though hyper-specialized
	volumeClass = ITEM_SIZE_NORMAL
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/cell,
		/obj/item/electronics/circuitboard,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/device/t_scanner,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/engineering,
		/obj/item/device/robotanalyzer,
		/obj/item/device/scanner/plant,
		/obj/item/stack/rods,
		/obj/item/extinguisher/mini,
		/obj/item/gun/projectile/flare_gun
		)

/obj/item/storage/pouch/engineering_material
	name = "engineering material pouch"
	desc = "A pouch for holding sheets, rods and cable coils."
	icon_state = "engineering_material"
	item_state = "engineering_material"
	matter = list(MATERIAL_BIOMATTER = 9, MATERIAL_STEEL = 1 )
	rarity_value = 33

	storage_slots = null
	max_storage_space = DEFAULT_NORMAL_STORAGE * 0.6 //Enough space for 3 stacks
	volumeClass = ITEM_SIZE_NORMAL
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/stack/material,
		/obj/item/material,
		/obj/item/stack/cable_coil,
		/obj/item/stack/rods
		)

/obj/item/storage/pouch/ammo
	name = "ammo pouch"
	desc = "Can hold ammo magazines and bullets, not the boxes though."
	icon_state = "ammo"
	item_state = "ammo"
	matter = list(MATERIAL_BIOMATTER = 19, MATERIAL_STEEL = 1 )
	rarity_value = 33
	price_tag = 200

	storage_slots = 6
	volumeClass = ITEM_SIZE_NORMAL
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/cell/small,
		/obj/item/cell/medium
		)

	cant_hold = list(
		/obj/item/ammo_magazine/ammobox,
		/obj/item/ammo_magazine/srifle/drum,
		/obj/item/ammo_magazine/lrifle/drum,
		/obj/item/ammo_magazine/lrifle/pk,
		/obj/item/ammo_magazine/maxim
		)

/obj/item/storage/pouch/tubular
	name = "tubular pouch"
	desc = "Can hold five cylindrical and small items, including but not limiting to flares, glowsticks, syringes and even hatton tubes or rockets."
	icon_state = "flare"
	item_state = "flare"
	matter = list(MATERIAL_BIOMATTER = 14, MATERIAL_STEEL = 1 )
	rarity_value = 14
	price_tag = 140

	storage_slots = 5
	volumeClass = ITEM_SIZE_NORMAL
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/device/lighting/glowstick,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/hypospray,
		/obj/item/pen,
		/obj/item/storage/pill_bottle,
		/obj/item/hatton_magazine,
		/obj/item/ammo_casing/rocket,
		/obj/item/ammo_casing/grenade,
		/obj/item/cell/small,
		/obj/item/cell/medium
		)

/obj/item/storage/pouch/tubular/vial
	name = "vial pouch"
	desc = "Can hold about ten vials. Rebranding!"

	storage_slots = 10

	can_hold = list(
		/obj/item/device/lighting/glowstick,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker/vial,
		/obj/item/reagent_containers/hypospray,
		/obj/item/pen,
		/obj/item/cell/small,
		/obj/item/storage/pill_bottle
		)

/obj/item/storage/pouch/tubular/update_icon()
	..()
	cut_overlays()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "flare_[contents.len]")

/obj/item/storage/pouch/holding
	name = "pouch of holding"
	desc = "If your pockets are not large enough to store all your belongings, you may want to use this high-tech pouch that opens into a localized pocket of bluespace (pun intended)."
	icon_state = "holdingpouch"
	item_state = "holdingpouch"
	storage_slots = 7
	max_volumeClass = ITEM_SIZE_BULKY
	max_storage_space = DEFAULT_HUGE_STORAGE
	matter = list(MATERIAL_STEEL = 4, MATERIAL_GOLD = 5, MATERIAL_DIAMOND = 2, MATERIAL_URANIUM = 2)
	origin_tech = list(TECH_BLUESPACE = 4)
	spawn_blacklisted = TRUE

/obj/item/storage/pouch/holding/New()
	..()
	bluespace_entropy(3, get_turf(src))

/obj/item/storage/pouch/gun_part
	name = "part pouch"
	desc = "A pouch for holding all sorts of small parts, upgrades and components."
	icon_state = "part_pouch"
	item_state = "part_pouch"
	rarity_value = 33

	storage_slots = null
	max_storage_space = DEFAULT_NORMAL_STORAGE * 0.8 //Actually smaller than previous but illusion of space with continuous holding space
	max_volumeClass = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/part,
		/obj/item/stock_parts,
		/obj/item/electronics,
		/obj/item/tool_upgrade //Now holds tool upgrades!
		)
