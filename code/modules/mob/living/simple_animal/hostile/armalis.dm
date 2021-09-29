/mob/living/simple_animal/armalis
	name = "Vox Armalis"
	desc = "In truth, this scares you."

	icon = 'icons/mob/armalis.dmi'
	icon_state = "armalis_naked"

	health = 125
	maxHealth = 125
	resistance = 5

	response_help   = "pats"
	response_disarm = "pushes"
	response_harm   = "hits"

	attacktext = "reaped"
	attack_sound = 'sound/effects/bamf.ogg'
	melee_damage_lower = 15
	melee_damage_upper = 20
	atmospheric_requirements = list(
		MIN_OXY_INDEX = 0,
		MAX_PLASMA_INDEX = 0,
		MAX_CO2_INDEX = 0,
		MIN_N2_INDEX = 6
	)

	speed = 2

	a_intent = I_HURT


/mob/living/simple_animal/armalis/armored
	icon_state = "armalis_armored"

	health = 175
	maxHealth = 175
	resistance = 8
	speed = 3
