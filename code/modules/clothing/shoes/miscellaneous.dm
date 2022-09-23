//No-slip module for shoes
/obj/item/noslipmodule
	name = "no slip sole"
	desc = "Attach it to your shoe."
	icon = 'icons/inventory/feet/icon.dmi'
	icon_state = "no_slip_sole"

/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "brown"
	permeability_coefficient = 0.05
	item_flags = NOSLIP | SILENT
	origin_tech = list(TECH_COVERT = 3)
	siemens_coefficient = 0 // DAMN BOI
	spawn_blacklisted = TRUE

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	species_restricted = null
	body_parts_covered = 0
	siemens_coefficient = 0

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	body_parts_covered = LEGS
	siemens_coefficient = 0
	spawn_blacklisted = TRUE

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN + 0.4
	force = NONE
	//	armor = list(melee = 100, bullet = 100, energy = 100, bomb = 100, bio = 100, rad = 100)
	species_restricted = null
	var/footstep = 1	//used for squeeks whilst walking

/obj/item/clothing/shoes/clown_shoes/handle_movement(turf/walking, running)
	if(running)
		if(footstep >= 2)
			footstep = 0
			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
		else
			footstep++
	else
		playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	item_state = "cult"
	force = WEAPON_FORCE_WEAK
	spawn_blacklisted = TRUE
	siemens_coefficient = 0.7

	cold_protection = LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "boots"
	spawn_blacklisted = TRUE

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "slippers"
	force = 0
	species_restricted = null
	w_class = ITEM_SIZE_SMALL
	spawn_blacklisted = TRUE

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "slippers_worn"
	force = 0
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	item_flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	species_restricted = null
	style = STYLE_NEG_HIGH

/obj/item/clothing/shoes/leather
	name = "leather shoes"
	desc = "A sturdy pair of leather shoes."
	icon_state = "leather"
	style = STYLE_HIGH

/obj/item/clothing/shoes/jamrock
	name = "lizardskin shoes"
	desc = "Awesome watchtower heels from green leather."
	icon_state = "lizardskin_shoes"
	item_state = "lizardskin_shoes"
	style = STYLE_HIGH

/obj/item/clothing/shoes/aerostatic
	name = "aerostatic shoes"
	desc = "A pair of running shoes. That stated, despite not making you go faster, they do look nice."
	icon_state = "aerostatic_shoes"
	item_state = "aerostatic_shoes"
	style = STYLE_HIGH

/obj/item/clothing/shoes/redboot
	name = "red boots"
	desc = "A pair of stylish red boots."
	icon_state = "redboots"
	item_state = "redboots"
	style = STYLE_HIGH
	price_tag = 300

/obj/item/clothing/shoes/jackboots/longboot
	name = "long boots"
	desc = "A pair of stylish vertically long boots."
	icon_state = "longboots"
	item_state = "longboots"
	style = STYLE_HIGH
	price_tag = 400

/obj/item/clothing/shoes/jackboots/duty
	name = "duty jackboots"
	desc = "A pair of slightly modified standard-issue jackboots. Not exactly more combat-ish, but may look better."
	icon_state = "duty"
	item_state = "duty"

/obj/item/clothing/shoes/jackboots/duty/long
	name = "long duty jackboots"
	desc = "A pair of slightly modified standard-issue jackboots. These reach up even higher."
	icon_state = "duty_long"
	item_state = "duty_long"

/obj/item/clothing/shoes/sneakerspurple
	name = "purple sneakers"
	desc = "A stylish, expensive pair of purple sneakers."
	icon_state = "sneakerspurple"
	item_state = "sneakerspurple"

/obj/item/clothing/shoes/sneakersblue
	name = "blue sneakers"
	desc = "A stylish, expensive pair of blue sneakers."
	icon_state = "sneakersblue"
	item_state = "sneakersblue"

/obj/item/clothing/shoes/sneakersred
	name = "red sneakers"
	desc = "A stylish, expensive pair of red sneakers."
	icon_state = "sneakersred"
	item_state = "sneakersred"

/obj/item/clothing/shoes/spurs
	name = "spurs"
	desc = "A pair of leather boots with spurs. The way they jingle and jangle is quite enticing."
	icon_state = "spurs"
	item_state = "spurs"
