// hazard suit,69aint69ersion. Replaces old excavation suit.
/obj/item/clothing/head/space/void/hazardhelmet
	name = "hazard helmet"
	desc = "An orange helmet with a wide69isor that still somehow hides your face. Integrated heads-up display seems to be broken."
	icon_state = "hev_orange_helmet"
	item_state = "hev_orange_helmet"
	matter = list(MATERIAL_GLASS = 5,69ATERIAL_STEEL = 5)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
		melee = 30,
		bullet = 25,
		energy = 40,
		bomb = 50,
		bio = 100,
		rad = 100
	)
	siemens_coefficient = 0

/obj/item/clothing/suit/space/void/hazardsuit
	name = "hazard69oidsuit"
	desc = "A sleek orange69oidsuit capable of protecting its user against69ost hostile environment conditions.69orphine not included!"
	icon_state = "hev_orange"
	item_state = "hev_orange"
	origin_tech = list(TECH_MATERIAL = 1, TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTEEL = 10,69ATERIAL_PLASTIC = 10,69ATERIAL_STEEL = 10)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(
		melee = 30,
		bullet = 25,
		energy = 40,
		bomb = 50,
		bio = 100,
		rad = 100
	)
	siemens_coefficient = 0 // It would be funny get electrocuted to death in a suit that supposed to protect against shocks
	helmet = /obj/item/clothing/head/space/void/hazardhelmet


// hazard suit,69oebius69ersion.
/obj/item/clothing/head/space/void/hazardhelmet/moebius
	name = "moebius hazard helmet"
	desc = "A69oebius branded69iolet69oidsuit helmet with a large69isor that hides your face. Integrated heads-up display not included."
	icon_state = "hev_violet_helmet"
	item_state = "hev_violet_helmet"
	spawn_blacklisted = TRUE

/obj/item/clothing/suit/space/void/hazardsuit/moebius
	name = "moebius hazard69oidsuit"
	desc = "A69oebius branded69iolet69oidsuit that is capable of protecting its user against69ost hostile environment conditions, including anomalous particles. Integrated self-diagnostics system not included!"
	icon_state = "hev_violet"
	item_state = "hev_violet"
	spawn_blacklisted = TRUE
	helmet = /obj/item/clothing/head/space/void/hazardhelmet/moebius
