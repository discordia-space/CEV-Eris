/obj/item/weapon/storage/belt
	name = "belt"
	desc = "Can hold various things."
	icon = 'icons/inventory/belt/icon.dmi'
	icon_state = "utility"
	storage_slots = 7
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_NORMAL_STORAGE
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_BIOMATTER = 4, MATERIAL_PLASTIC = 5)
	attack_verb = list("whipped", "lashed", "disciplined")
	bad_type = /obj/item/weapon/storage/belt
	rarity_value = 10
	spawn_tags = SPAWN_TAG_BELT

	var/show_above_suit = 0

/obj/item/weapon/storage/belt/Initialize()
	. = ..()
	if (!item_state)
		item_state = icon_state

/obj/item/weapon/storage/belt/verb/toggle_layer()
	set name = "Switch Belt Layer"
	set category = "Object"

	if(show_above_suit == -1)
		to_chat(usr, SPAN_NOTICE("\The [src] cannot be worn above your suit!"))
		return
	show_above_suit = !show_above_suit
	update_icon()

/obj/item/weapon/storage/update_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_belt()


/obj/item/weapon/storage/belt/utility
	name = "tool belt"
	desc = "Can hold various tools."
	icon_state = "utility"
	spawn_tags = SPAWN_TAG_BELT_UTILITY
	can_hold = list(
		/obj/item/weapon/tool,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/rcd,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/device/radio,
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
		/obj/item/weapon/cell/medium,
		/obj/item/weapon/grenade/chem_grenade/cleaner,
		/obj/item/weapon/grenade/chem_grenade/antiweed,
		/obj/item/weapon/grenade/chem_grenade/metalfoam
	)
/obj/item/weapon/storage/belt/utility/full
	rarity_value = 50

/obj/item/weapon/storage/belt/utility/full/populate_contents()
	new /obj/item/weapon/tool/screwdriver(src)
	new /obj/item/weapon/tool/wrench(src)
	new /obj/item/weapon/tool/weldingtool(src)
	new /obj/item/weapon/tool/crowbar(src)
	new /obj/item/weapon/tool/wirecutters(src)
	new /obj/item/stack/cable_coil/random(src)

/obj/item/weapon/storage/belt/utility/neotheology
	name = "neotheologian utility belt"
	desc = "Waist-held holy items."
	icon_state = "utility_neotheology"
	rarity_value = 20
	can_hold_extra = list(
		/obj/item/weapon/book/ritual/cruciform,
		/obj/item/weapon/implant/core_implant/cruciform,
		/obj/item/weapon/soap,
		/obj/item/weapon/reagent_containers/spray/cleaner
	)
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/belt/medical
	name = "medical belt"
	desc = "Can hold various medical equipment."
	icon_state = "medicalbelt"
	item_state = "medical"
	can_hold = list(
		/obj/item/bodybag,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/scanner/health,
		/obj/item/device/radio/headset,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/weapon/dnainjector,
		/obj/item/weapon/reagent_containers/blood,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/reagent_containers/glass/beaker,
		/obj/item/weapon/reagent_containers/glass/bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/cell/small,
		/obj/item/weapon/storage/fancy/cigarettes,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/tool/bonesetter,
		/obj/item/weapon/tool/scalpel,
		/obj/item/weapon/tool/scalpel/advanced,
		/obj/item/weapon/tool/scalpel/laser,
		/obj/item/weapon/tool/surgicaldrill,
		/obj/item/weapon/tool/cautery,
		/obj/item/weapon/tool/retractor,
		/obj/item/weapon/tool/saw/circular,
		/obj/item/weapon/tool/hemostat,
		/obj/item/stack/medical,
		/obj/item/stack/nanopaste,
		/obj/item/taperoll/medical
	)
	rarity_value = 15

/obj/item/weapon/storage/belt/medical/emt
	name = "EMT utility belt"
	desc = "A sturdy black webbing belt with attached pouches."
	icon_state = "emsbelt"
	item_state = "emsbelt"
	can_hold_extra = list(
		/obj/item/device/radio/off,
		/obj/item/weapon/inflatable_dispenser,
		/obj/item/weapon/tool/crowbar,
		/obj/item/weapon/extinguisher/mini
	)

/obj/item/weapon/storage/belt/tactical
	name = "tactical belt"
	desc = "Can hold various military and security equipment."
	icon_state = "tactical"
	rarity_value = 20
	can_hold = list(
		/obj/item/weapon/grenade,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/handcuffs,
		/obj/item/weapon/tool/crowbar,
		/obj/item/device/flash,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses,
		/obj/item/ammo_casing,
		/obj/item/ammo_magazine,
		/obj/item/weapon/cell/small,
		/obj/item/weapon/cell/medium,
		/obj/item/weapon/reagent_containers/food/snacks/donut, //meme, but fine
		/obj/item/weapon/flame/lighter,
		/obj/item/device/lighting/toggleable/flashlight,
		/obj/item/modular_computer/pda,
		/obj/item/device/radio/headset,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/weapon/melee,
		/obj/item/weapon/gun/projectile/clarissa,
		/obj/item/weapon/gun/projectile/giskard,
		/obj/item/weapon/gun/energy/gun/martin,
		/obj/item/taperoll
	)

/obj/item/weapon/storage/belt/tactical/ironhammer
	name = "ironhammer tactical belt"
	icon_state = "tactical_ironhammer"
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/belt/tactical/neotheology
	name = "neotheologian tactical belt"
	desc = "Can hold various military and security equipment."
	icon_state = "tactical_neotheology"
	rarity_value = 40
	can_hold_extra = list(
		/obj/item/weapon/book/ritual/cruciform,
		/obj/item/weapon/implant/core_implant/cruciform,
		/obj/item/weapon/tool/knife/neotritual,
		/obj/item/weapon/gun/energy/crossbow
	)
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/belt/champion
	name = "championship belt"
	desc = "Proves to the world that you are the strongest!"
	icon_state = "championbelt"
	item_state = "champion"
	storage_slots = 1
	can_hold = list(
		/obj/item/clothing/mask/luchador
	)
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/belt/holding
	name = "belt of holding"
	desc = "The greatest in pants-supporting bluespace technology."
	icon_state = "holdingbelt"
	item_state = "holdingbelt"
	storage_slots = 14
	max_w_class = ITEM_SIZE_BULKY
	max_storage_space = DEFAULT_HUGE_STORAGE * 1.25
	matter = list(MATERIAL_STEEL = 6, MATERIAL_GOLD = 6, MATERIAL_DIAMOND = 2, MATERIAL_URANIUM = 3)
	origin_tech = list(TECH_BLUESPACE = 4)
	spawn_blacklisted = TRUE

/obj/item/weapon/storage/belt/holding/New()
	..()
	bluespace_entropy(4, get_turf(src))
