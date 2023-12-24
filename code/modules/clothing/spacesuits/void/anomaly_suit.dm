// hazard suit, maint version. Replaces old excavation suit.
/obj/item/clothing/head/space/void/hazardhelmet
	name = "hazard helmet"
	desc = "An orange helmet with a wide visor that still somehow hides your face. Integrated heads-up display seems to be broken."
	icon_state = "hev_orange_helmet"
	item_state = "hev_orange_helmet"
	matter = list(MATERIAL_GLASS = 5, MATERIAL_STEEL = 5)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 7,
		ARMOR_ENERGY = 10,
		ARMOR_BOMB =50,
		ARMOR_BIO =100,
		ARMOR_RAD =100
	)
	siemens_coefficient = 0

/obj/item/clothing/suit/space/void/hazardsuit
	name = "hazard voidsuit"
	desc = "A sleek orange voidsuit capable of protecting its user against most hostile environment conditions. Morphine not included!"
	icon_state = "hev_orange"
	item_state = "hev_orange"
	origin_tech = list(TECH_MATERIAL = 1, TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 10, MATERIAL_STEEL = 10)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
		ARMOR_BLUNT = 7,
		ARMOR_BULLET = 10,
		ARMOR_ENERGY = 10,
		ARMOR_BOMB =50,
		ARMOR_BIO =100,
		ARMOR_RAD =100
	)
	siemens_coefficient = 0 // It would be funny get electrocuted to death in a suit that supposed to protect against shocks
	helmet = /obj/item/clothing/head/space/void/hazardhelmet


// hazard suit, moebius version.
/obj/item/clothing/head/space/void/hazardhelmet/moebius
	name = "moebius hazard helmet"
	desc = "A moebius branded violet voidsuit helmet with a large visor that hides your face. Integrated heads-up display not included."
	icon_state = "hev_violet_helmet"
	item_state = "hev_violet_helmet"
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/void/hazardsuit/moebius
	name = "moebius hazard voidsuit"
	desc = "A moebius branded violet voidsuit that is capable of protecting its user against most hostile environment conditions, including anomalous particles. Integrated self-diagnostics system not included!"
	icon_state = "hev_violet"
	item_state = "hev_violet"
	spawn_blacklisted = TRUE
	helmet = /obj/item/clothing/head/space/void/hazardhelmet/moebius
