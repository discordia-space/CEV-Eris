//Space santa outfit suit
/obj/item/clothing/head/space/santahat
	name = "Santa's hat"
	desc = "Ho ho ho. Merrry X-mas!"
	icon_state = "santahat"
	item_state = "santahat"
	item_flags = STOPPRESSUREDAMAGE
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

/obj/item/clothing/suit/space/santa
	name = "Santa's suit"
	desc = "Festive!"
	icon_state = "santa"
	item_state = "santa"
	slowdown = 0
	item_flags = STOPPRESSUREDAMAGE
	allowed = list(/obj/item) //for stuffing exta special presents

//Orange emergency space suit
/obj/item/clothing/head/space/emergency
	name = "emergency space helmet"
	icon_state = "emergencyhelm"
	item_state = "syndi_helm_erm"	//currently not working somehow
	desc = "A simple helmet with a built in light, smells like mothballs."
	light_overlay = "helmet_light_syndi_soft"
	flash_protection = FLASH_PROTECTION_MINOR

/obj/item/clothing/suit/space/emergency
	name = "emergency softsuit"
	icon_state = "emergency_suit"
	item_state = "emergency_suit"
	desc = "A thin, ungainly softsuit colored in blaze orange for rescuers to easily locate, looks pretty fragile."
	accompanying_object = /obj/item/clothing/head/space/emergency
	slowdown = HEAVY_SLOWDOWN

//Neotheology spacesuits
/obj/item/clothing/head/space/medicus
	name = "NT Medicus Helmet"
	icon_state = "nt_habithat_visor"
	item_state = "nt_habithat_visor"
	desc = "Protective helmet meant more to safeguard against disease, retrofit to also be spaceworthy."
	style = STYLE_HIGH //Very low defenses, but looks better than a normal spacesuit
	spawn_blacklisted = TRUE
	matter = list(MATERIAL_BIOMATTER = 15, MATERIAL_PLASTIC = 5, MATERIAL_STEEL = 5)

/obj/item/clothing/suit/space/medicus
	name = "NT Medicus Robes"
	icon_state = "nt_habit"
	item_state = "nt_habit"
	desc = "Protective robes meant more to safeguard against disease, retrofit to also be spaceworthy. Has pockets for medical convenience."
	style = STYLE_HIGH //Very low defenses, but looks better than a normal spacesuit
	spawn_blacklisted = TRUE
	slowdown = LIGHT_SLOWDOWN
	matter = list(MATERIAL_BIOMATTER = 25, MATERIAL_PLASTIC = 10, MATERIAL_STEEL = 10)
	item_flags = DRAG_AND_DROP_UNEQUIP|STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT|COVER_PREVENT_MANIPULATION
	extra_allowed = list(
		/obj/item/storage/firstaid,
		/obj/item/device/scanner/health,
		/obj/item/stack/medical,
		/obj/item/roller
	)
	var/obj/item/storage/internal/pockets
	var/max_volumeClass = ITEM_SIZE_NORMAL
	var/list/can_hold = list(
		/obj/item/device/scanner/health,
		/obj/item/clothing/gloves/latex,
		/obj/item/stack/medical,
		/obj/item/storage/pill_bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/blood,
		/obj/item/taperoll/medical,
		/obj/item/bodybag
	)
/obj/item/clothing/suit/space/medicus/New()
	..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 4
	pockets.max_volumeClass = ITEM_SIZE_SMALL
	pockets.max_storage_space = 8

/obj/item/clothing/suit/space/medicus/Destroy()
	QDEL_NULL(pockets)
	. = ..()

/obj/item/clothing/suit/space/medicus/attack_hand(mob/user)
	if ((is_worn() || is_held()) && !pockets.handle_attack_hand(user))
		return TRUE
	..(user)

/obj/item/clothing/suit/space/medicus/MouseDrop(obj/over_object)
	if(pockets.handle_mousedrop(usr, over_object))
		return TRUE
	..(over_object)

/obj/item/clothing/suit/space/medicus/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/clothing/accessory)) // Do not put accessories into pockets
		pockets.attackby(W, user)
	..()
