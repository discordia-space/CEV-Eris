#define GOLEM_URANIUM_HEAL_RANGE 7

/mob/living/carbon/superior_animal/golem/uranium
	name = "uranium golem"
	desc = "A moving pile of rocks with uranium branches growing of it."
	icon_state = "golem_uranium_idle"
	icon_living = "golem_uranium_idle"

	// Health related variables
	maxHealth = GOLEM_HEALTH_MED
	health = GOLEM_HEALTH_MED

	// Movement related variables
	move_to_delay = GOLEM_SPEED_LOW
	turns_per_move = 5

	// Damage related variables
	melee_damage_lower = GOLEM_DMG_FEEBLE
	melee_damage_upper = GOLEM_DMG_FEEBLE

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = GOLEM_ARMOR_MED,
		energy = GOLEM_ARMOR_ULTRA,
		bomb = 0,
		bio = 0,
		rad = 0
	)

	// Loot related variables
	mineral_name = ORE_URANIUM

	kept_distance = 3
	retreat_on_too_close = TRUE

/mob/living/carbon/superior_animal/golem/uranium/New()
	..()
	set_light(3, 3, "#8AD55D")

/mob/living/carbon/superior_animal/golem/uranium/Destroy()
	set_light(0)
	. = ..()

/mob/living/carbon/superior_animal/golem/uranium/handle_ai()
	. = ..()
	if(target_mob)
		for(var/mob/living/carbon/superior_animal/golem/ally in getMobsInRangeChunked(src, GOLEM_URANIUM_HEAL_RANGE, TRUE))
			if((ally != src))
				ally.adjustBruteLoss(-GOLEM_REGENERATION)
				ally.adjustFireLoss(-GOLEM_REGENERATION)
