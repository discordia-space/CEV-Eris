//Regular syndicate space suit
/obj/item/clothing/head/space/syndicate
	name = "red space helmet"
	icon_state = "syndicate"
	item_state = "syndi_helm"	//not sure why this isn't working, will try to fix before merge, but looks like a deep issue
	desc = "A clasic crimson helmet sporting clean lines and durable plating."
	light_overlay = "helmet_light_syndi_soft"
	armor = list(
		ARMOR_BLUNT = 12,
		ARMOR_BULLET = 15,
		ARMOR_ENERGY = 15,
		ARMOR_BOMB =150,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)
	siemens_coefficient = 0.4
	spawn_blacklisted = TRUE
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/ceramic
	)

/obj/item/clothing/suit/space/syndicate
	name = "red space suit"
	icon_state = "syndicate"
	item_state = "space_suit_syndicate"
	desc = "A clasic crimson spacesuit sporting clean lines and durable plating."
	volumeClass = ITEM_SIZE_NORMAL
	armor = list(
		ARMOR_BLUNT = 12,
		ARMOR_BULLET = 15,
		ARMOR_ENERGY = 15,
		ARMOR_BOMB =150,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)
	siemens_coefficient = 0.4
	can_breach = FALSE
	supporting_limbs = list()
	spawn_blacklisted = TRUE
	accompanying_object = /obj/item/clothing/head/space/syndicate
	slowdown = LIGHT_SLOWDOWN
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/sideguards/steel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/ceramic
	)

///////////////////////Black Market//////////////////////////////

/obj/item/clothing/head/space/syndicate/uplink
	name = "tan space helmet"
	icon_state = "syndicate_tan"
	item_state = "syndi_helm_tan"
	desc = "A knockoff tan helmet sporting clean lines and durable plating."
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/clothing/suit/space/syndicate/uplink
	name = "tan space suit"
	icon_state = "syndicate_tan"
	item_state = "space_suit_syndicate_tan"
	desc = "A knockoff tan spacesuit sporting clean lines and durable plating."
	accompanying_object = /obj/item/clothing/head/space/syndicate/uplink
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/nt17
	)

