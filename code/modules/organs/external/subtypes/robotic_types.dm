//Charachter setup prostheses

/obj/item/organ/external/robotic/bishop
	name = "Bishop"
	desc = "Prosthesis with white polymer casing with blue holo-displays."
	force_icon = 'icons/mob/human_races/cyberlimbs/bishop.dmi'
	model = "bishop"

/obj/item/organ/external/robotic/hesphaistos
	name = "Hesphaistos"
	desc = "Prosthesis with militaristic black and green casing with gold stripes."
	force_icon = 'icons/mob/human_races/cyberlimbs/hesphaistos.dmi'
	model = "hesphaistos"

/obj/item/organ/external/robotic/zenghu
	name = "Zeng-Hu"
	desc = "Prosthesis with rubbery fleshtone covering with visible seams."
	force_icon = 'icons/mob/human_races/cyberlimbs/zenghu.dmi'
	model = "zenghu"

/obj/item/organ/external/robotic/xion
	name = "Xion"
	desc = "Prosthesis with minimalist black and red casing."
	force_icon = 'icons/mob/human_races/cyberlimbs/xion.dmi'
	model = "xion"

//In game prostheses
/obj/item/organ/external/robotic/moebius
	name = "Moebius"
	desc = "Reinforced prosthesis designed for space exploration and light combat."
	model = "xion"
	armor = list(melee = 35, bullet = 35, energy = 35, bomb = 35, bio = 0, rad = 100)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 2, MATERIAL_PLASTEEL = 1)
	max_damage = 60
	min_broken_damage = 40

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

/obj/item/organ/external/robotic/excelsior
	name = "Excelsior"
	desc = "Plasma reinforced prothsesis designed for heavy combat."
	model = "xion"
	armor = list(melee = 50, bullet = 50, energy = 50, bomb = 50, bio = 0, rad = 100)
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 1, MATERIAL_PLASMA = 0.5) //Plasma needed as a material that excelsiors can't teleport in
	max_damage = 65
	min_broken_damage = 45

/obj/item/organ/external/robotic/excelsior/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/excelsior/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/excelsior/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/excelsior/r_leg
	default_description = /datum/organ_description/leg/right

/obj/item/organ/external/robotic/one_star
	name = "One star"
	desc = "Advanced, extremly resileant and mobile prosthetic. Inscribed with \"Made in\" followed by giberish, must have been lost to time."
	model = "xion"
	armor = list(melee = 65, bullet = 65, energy = 65, bomb = 65, bio = 0, rad = 100)
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 4, MATERIAL_GOLD = 2)
	max_damage = 70
	min_broken_damage = 45

/obj/item/organ/external/robotic/one_star/l_arm
	default_description = /datum/organ_description/arm/left

/obj/item/organ/external/robotic/one_star/r_arm
	default_description = /datum/organ_description/arm/right

/obj/item/organ/external/robotic/one_star/l_leg
	default_description = /datum/organ_description/leg/left

/obj/item/organ/external/robotic/one_star/r_leg
	default_description = /datum/organ_description/leg/right
