//Charachter setup prostheses

/obj/item/organ/external/robotic/asters
	name = "Asters \"Movement Lock\""
	desc = "Generic gray prosthesis for everyday use."
	armor = list(ARMOR_BLUNT = 2, ARMOR_BULLET = 2, ARMOR_ENERGY = 2, ARMOR_BOMB =10, ARMOR_BIO =100, ARMOR_RAD =100)
	force_icon = 'icons/mob/human_races/cyberlimbs/asters.dmi'
	model = "asters"
	price_tag = 300
	bad_type = /obj/item/organ/external/robotic/asters

/obj/item/organ/external/robotic/serbian
	name = "\"Serbian Arms\""
	desc = "Battle hardened green and brown prosthesis, rebranded several times."
	armor = list(ARMOR_BLUNT = 2, ARMOR_BULLET = 2, ARMOR_ENERGY = 2, ARMOR_BOMB =10, ARMOR_BIO =100, ARMOR_RAD =100)
	force_icon = 'icons/mob/human_races/cyberlimbs/serbian.dmi'
	model = "serbian"
	price_tag = 600
	bad_type = /obj/item/organ/external/robotic/serbian

//In game prostheses
/obj/item/organ/external/robotic/frozen_star
	name = "\"Frozen Star\""
	desc = "Tactical \"Frozen Star\" blue and gray prosthesis for dangerous environment."
	armor = list(ARMOR_BLUNT = 2, ARMOR_BULLET = 2, ARMOR_ENERGY = 2, ARMOR_BOMB =10, ARMOR_BIO =100, ARMOR_RAD =100)
	force_icon = 'icons/mob/human_races/cyberlimbs/frozen_star.dmi'
	model = "frozen_star"
	price_tag = 450
	bad_type = /obj/item/organ/external/robotic/frozen_star

/obj/item/organ/external/robotic/frozen_star/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/frozen_star/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/frozen_star/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/frozen_star/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/technomancer
	name = "Technomancer \"Homebrew\""
	desc = "Technomancer \"branded\" \"functional\" prosthesis."
	armor = list(ARMOR_BLUNT = 2, ARMOR_BULLET = 2, ARMOR_ENERGY = 2, ARMOR_BOMB =10, ARMOR_BIO =100, ARMOR_RAD =100)
	force_icon = 'icons/mob/human_races/cyberlimbs/technomancer.dmi'
	model = "technomancer"
	price_tag = 700
	bad_type = /obj/item/organ/external/robotic/technomancer

/obj/item/organ/external/robotic/technomancer/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/technomancer/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/technomancer/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/technomancer/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/technomancer/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/robotic/technomancer/torso
	default_description = /datum/organ_description/chest

/obj/item/organ/external/robotic/technomancer/head
	default_description = /datum/organ_description/head

/obj/item/organ/external/robotic/moebius
	name = "\"Moebius\""
	desc = "Streamlined, sleek, and sterile."
	armor = list(ARMOR_BLUNT = 2, ARMOR_BULLET = 2, ARMOR_ENERGY = 2, ARMOR_BOMB =10, ARMOR_BIO =100, ARMOR_RAD =100)
	force_icon = 'icons/mob/human_races/cyberlimbs/moebius.dmi'
	model = "moebius"
	price_tag = 250
	bad_type = /obj/item/organ/external/robotic/moebius

/obj/item/organ/external/robotic/moebius/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/moebius/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/moebius/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/moebius/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/moebius/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/robotic/moebius/torso
	default_description = /datum/organ_description/chest

/obj/item/organ/external/robotic/moebius/head
	default_description = /datum/organ_description/head

/obj/item/organ/external/robotic/moebius/reinforced
	name = "\"Moebius\" R++"
	desc = "Reinforced purple and white prosthesis designed for space exploration and light combat."
	armor = list(ARMOR_BLUNT = 3, ARMOR_BULLET = 3, ARMOR_ENERGY = 3, ARMOR_BOMB =20, ARMOR_BIO =100, ARMOR_RAD =100)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1)
	max_damage = 60
	min_broken_damage = 40
	price_tag = 300
	bad_type = /obj/item/organ/external/robotic/moebius/reinforced

/obj/item/organ/external/robotic/moebius/reinforced/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/moebius/reinforced/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/moebius/reinforced/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/moebius/reinforced/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/moebius/reinforced/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/robotic/moebius/reinforced/torso
	default_description = /datum/organ_description/chest

/obj/item/organ/external/robotic/moebius/reinforced/head
	default_description = /datum/organ_description/head

/obj/item/organ/external/robotic/excelsior
	name = "Excelsior"
	desc = "Plasma reinforced black prosthesis designed for heavy combat."
	force_icon = 'icons/mob/human_races/cyberlimbs/excelsior.dmi'
	model = "excelsior"
	armor = list(ARMOR_BLUNT = 5, ARMOR_BULLET = 5, ARMOR_ENERGY = 5, ARMOR_BOMB =35, ARMOR_BIO =100, ARMOR_RAD =100)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 1, MATERIAL_PLASMA = 0.5) //Plasma needed as a material that excelsiors can't teleport in
	max_damage = 65
	min_broken_damage = 45
	price_tag = 600
	spawn_blacklisted = TRUE
	bad_type = /obj/item/organ/external/robotic/excelsior

/obj/item/organ/external/robotic/excelsior/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/excelsior/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/excelsior/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/excelsior/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/excelsior/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/robotic/excelsior/chest
	default_description = /datum/organ_description/chest

/obj/item/organ/external/robotic/excelsior/head
	default_description = /datum/organ_description/head

/obj/item/organ/external/robotic/one_star
	name = "One star"
	desc = "Advanced, extremely resilient and mobile prosthetic. Inscribed with \"Made in\" followed by gibberish, must have been lost to time."
	force_icon = 'icons/mob/human_races/cyberlimbs/one_star.dmi'
	model = "one_star"
	armor = list(ARMOR_BLUNT = 10, ARMOR_BULLET = 10, ARMOR_ENERGY = 10, ARMOR_BOMB =50, ARMOR_BIO =100, ARMOR_RAD =100)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 4, MATERIAL_GOLD = 2)
	max_damage = 70
	min_broken_damage = 45
	spawn_blacklisted = TRUE
	rarity_value = 10
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_PROSTHETIC_OS
	bad_type = /obj/item/organ/external/robotic/one_star
	price_tag = 900

/obj/item/organ/external/robotic/one_star/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/one_star/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/one_star/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/one_star/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/makeshift
	name = "Makeshift"
	desc = "Rust, rods, and bolts. A barely functional prosthetic made of whatever could be scavenged from maintenance."
	force_icon = 'icons/mob/human_races/cyberlimbs/ghetto.dmi'
	armor = list(ARMOR_BLUNT = 2, ARMOR_BULLET = 2, ARMOR_ENERGY = 2, ARMOR_BOMB =-5, ARMOR_BIO =100, ARMOR_RAD =100)
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 1)
	min_broken_damage = 30
	min_malfunction_damage = 15
	bad_type = /obj/item/organ/external/robotic/makeshift

/obj/item/organ/external/robotic/makeshift/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/makeshift/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/makeshift/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/makeshift/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/makeshift/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/robotic/makeshift/chest
	default_description = /datum/organ_description/chest
