/obj/item/ore
	name = "rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	volumeClass = ITEM_SIZE_SMALL
	rarity_value = 25
	bad_type = /obj/item/ore
	spawn_tags = SPAWN_TAG_ORE
	price_tag = 1
	var/datum/geosample/geologic_data
	var/material

/obj/item/ore/uranium
	name = "pitchblende"
	icon_state = "ore_uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = ORE_URANIUM
	rarity_value = 100
	price_tag = 10

/obj/item/ore/iron
	name = "hematite"
	icon_state = "ore_iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_IRON
	price_tag = 2

/obj/item/ore/coal
	name = "raw carbon"
	icon_state = "ore_coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_CARBON
	price_tag = 2

/obj/item/ore/glass
	name = "sand"
	icon_state = "ore_glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = ORE_SAND
	slot_flags = SLOT_HOLSTER
	rarity_value = 20
	spawn_tags = SPAWN_TAG_ORE_TAG_JUNK
	price_tag = 1

// POCKET SAND!
/obj/item/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, SPAN_DANGER("Some of \the [src] gets in your eyes!"))
		H.eye_blind += 5
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)


/obj/item/ore/plasma
	name = "plasma crystals"
	icon_state = "ore_plasma"
	origin_tech = list(TECH_MATERIAL = 2)
	material = ORE_PLASMA
	rarity_value = 33.33
	price_tag = 5

/obj/item/ore/silver
	name = "native silver ore"
	icon_state = "ore_silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = ORE_SILVER
	rarity_value = 50
	price_tag = 5

/obj/item/ore/gold
	name = "native gold ore"
	icon_state = "ore_gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = ORE_GOLD
	rarity_value = 33.33
	price_tag = 5

/obj/item/ore/diamond
	name = "diamonds"
	icon_state = "ore_diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = ORE_DIAMOND
	rarity_value = 100
	price_tag = 20

/obj/item/ore/osmium
	name = "raw platinum"
	icon_state = "ore_platinum"
	material = ORE_PLATINUM
	rarity_value = 50
	price_tag = 5

/obj/item/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "ore_hydrogen"
	material = ORE_HYDROGEN
	rarity_value = 50
	spawn_blacklisted = TRUE
	price_tag = 5

/obj/item/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"
	material = null
	rarity_value = 10
	spawn_blacklisted = TRUE
	price_tag = 1

/obj/item/ore/Initialize(mapload)
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8
