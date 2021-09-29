/mob/living/simple_animal/hostile/retaliate/clown
	name = "clown"
	desc = "A denizen of clown planet"
	icon_state = "clown"
	icon_gib = "clown_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks")
	speak_chance = 1
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	maxHealth = 75
	health = 75
	speed = -1
	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "attacked"
	attack_sound = 'sound/items/bikehorn.ogg'

	atmospheric_requirements = list(
		MIN_OXY_INDEX = 5,
		MAX_OXY_INDEX = 0,
		MIN_PLASMA_INDEX = 0,
		MAX_PLASMA_INDEX = 1,
		MIN_CO2_INDEX = 0,
		MAX_CO2_INDEX = 1,
		MIN_N2_INDEX = 0,
		MAX_N2_INDEX = 0,
		BODY_TEMP_MIN_INDEX = 270,
		BODY_TEMP_MAX_INDEX = 370,
		ATMOS_DAMAGE_INDEX = 12,
		BODY_TEMP_DAMAGE_INDEX = 12
	)
