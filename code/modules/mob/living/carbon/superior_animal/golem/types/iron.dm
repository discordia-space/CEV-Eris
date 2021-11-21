/mob/living/carbon/superior_animal/golem/iron
	name = "OneStar Stalker Mk1"
	desc = "A ruthless patrol borg that defends OneStar facilities. This one has a single minigun, still enough to kill pesky intruders."
	icon_state = "stalker_mk1"
	icon_living = "stalker_mk1"
	pass_flags = PASSTABLE

	mob_size = MOB_MEDIUM

	maxHealth = 200
	health = 200

	//spawn_values
	rarity_value = 37.5
	spawn_frequency = 10
	spawn_tags = SPAWN_TAG_MOB_STALKER
	faction = "onestar"

	deathmessage = "suddenly shuts down, its eye light switching to a dim red."
	attacktext = "bonked"
	attack_sound = 'sound/weapons/smash.ogg'
	speak_emote = list("beeps")
	emote_see = list("beeps repeatedly", "whirrs violently", "flashes its indicator lights", "emits a ping sound")
	speak_chance = 5

	move_to_delay = 6
	turns_per_move = 5
	see_in_dark = 10
	meat_type = null
	meat_amount = 0
	stop_automated_movement_when_pulled = 0

	melee_damage_lower = 12
	melee_damage_upper = 17
	destroy_surroundings = FALSE

	contaminant_immunity = TRUE
	cold_protection = 1
	heat_protection = 1
	breath_required_type = 0
	breath_poison_type = 0
	min_breath_required_type = 0
	min_breath_poison_type = 0
	min_air_pressure = 0 //below this, brute damage is dealt
	max_air_pressure = 10000 //above this, brute damage is dealt
	min_bodytemperature = 0 //below this, burn damage is dealt
	max_bodytemperature = 10000 //above this, burn damage is dealt
