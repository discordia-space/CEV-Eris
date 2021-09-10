// For AI-controlled human-like mobs.
/mob/living/carbon/superior_animal/human
	name = "Random Guy"
	desc = "A random guy, report this if you see this."
	icon = 'icons/mob/animal.dmi'
	icon_state = "russian_melee"
	move_to_delay = 4
	viewRange = 8
	speak_chance = 5
	turns_per_move = 5

	attack_sound = 'sound/weapons/slice.ogg'

/*
	breath_required_type = NONE
	breath_poison_type = NONE
	min_breath_required_type = 0
	min_breath_poison_type = 0

	min_air_pressure = 0
	min_bodytemperature = 0
*/
	can_burrow = FALSE
