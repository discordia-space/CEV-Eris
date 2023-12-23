/obj/item/clothing/head/space/void/SCAF
	name = "SCAF helmet"
	desc = "A thick airtight helmet designed for planetside warfare retrofitted with seals to act like normal space suit helmet."
	icon_state = "scaf"
	item_state = "scaf"
	armor = list(
		ARMOR_BLUNT = 45,
		ARMOR_BULLET = 40,
		ARMOR_ENERGY = 10,
		ARMOR_BOMB =150,
		ARMOR_BIO =100,
		ARMOR_RAD =30
	)
	siemens_coefficient = 0.35
	max_heat_protection_temperature = 15000 //Halfway between Space Suit 5000 and Firesuit 30000
	species_restricted = list(SPECIES_HUMAN)
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_green"
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/ceramic,
		/obj/item/armor_component/plate/ceramic
	)

/obj/item/clothing/suit/space/void/SCAF
	name = "SCAF suit"
	desc = "A bulky antique suit of refurbished infantry armour, retrofitted with seals and coatings to make it EVA capable but also reducing mobility."
	icon_state = "scaf"
	item_state = "scaf"
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
	armor = list(
		ARMOR_BLUNT = 45,
		ARMOR_BULLET = 40,
		ARMOR_ENERGY = 14,
		ARMOR_BOMB =150,
		ARMOR_BIO =100,
		ARMOR_RAD =30
	)
	siemens_coefficient = 0.35
	max_heat_protection_temperature = 15000 //Halfway between Space Suit 5000 and Firesuit 30000
	breach_threshold = 10
	resilience = 0.07
	species_restricted = list(SPECIES_HUMAN)
	supporting_limbs = list()
	helmet = /obj/item/clothing/head/space/void/SCAF
	spawn_blacklisted = TRUE
	slowdown = MEDIUM_SLOWDOWN * 1.5
	armorComps = list(
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/kevlar,
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/ceramic,
		/obj/item/armor_component/plate/ceramic,
		/obj/item/armor_component/sideguards/plasteel,
		/obj/item/armor_component/sideguards/plasteel,
		/obj/item/armor_component/sideguards/ceramic
	)


//Voidsuit for contractors
/obj/item/clothing/head/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. This version is additionally reinforced against melee attacks."
	icon_state = "syndiehelm"
	item_state = "syndiehelm"
	armor = list(
		ARMOR_BLUNT = 27,
		ARMOR_BULLET = 30,
		ARMOR_ENERGY = 15,
		ARMOR_BOMB =75,
		ARMOR_BIO =100,
		ARMOR_RAD =75
	)
	siemens_coefficient = 0.35
	species_restricted = list(SPECIES_HUMAN)
	camera_networks = list(NETWORK_MERCENARY)
	light_overlay = "helmet_light_ihs"
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/ceramic
	)

/obj/item/clothing/head/space/void/merc/update_icon()
	..()
	if(on)
		icon_state = "syndiehelm_on"
	else
		icon_state = initial(icon_state)
	return

/obj/item/clothing/suit/space/void/merc
	icon_state = "syndievoidsuit"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Surprisingly flexible. This version is additionally reinforced against melee attacks."
	item_state = "syndie_voidsuit"
	armor = list(
		ARMOR_BLUNT = 27,
		ARMOR_BULLET = 30,
		ARMOR_ENERGY = 13,
		ARMOR_BOMB =75,
		ARMOR_BIO =100,
		ARMOR_RAD =75
	)
	siemens_coefficient = 0.35
	breach_threshold = 8
	resilience = 0.08
	species_restricted = list(SPECIES_HUMAN)
	helmet = /obj/item/clothing/head/space/void/merc
	armorComps = list(
		/obj/item/armor_component/plate/steel,
		/obj/item/armor_component/sideguards/steel,
		/obj/item/armor_component/sideguards/steel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/ceramic
	)

/obj/item/clothing/suit/space/void/merc/equipped
	spawn_blacklisted = TRUE
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
	accompanying_object = null
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/void/merc/boxed
	spawn_blacklisted = TRUE
	tank = /obj/item/tank/emergency_oxygen/double
	spawn_blacklisted = TRUE
