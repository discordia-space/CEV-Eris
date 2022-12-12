/mob/living/carbon/superior_animal/roach/tank
	name = "Panzer Roach"
	desc = "A monstrous, dog-sized cockroach. This one looks more robust than others."
	icon_state = "panzer"
	meat_amount = 4
	turns_per_move = 2
	maxHealth = 45
	health = 45
	move_to_delay = 6
	mob_size = MOB_SMALL * 1.5 // 15
	density = TRUE
	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer
	rarity_value = 22.5

	attacktext = list("slammed into", "pounded into", "crushed")

	melee_damage_lower = 7 // Slow, but big punch
	melee_damage_upper = 16
	armor_divisor = ARMOR_PEN_DEEP
	wound_mult = WOUNDING_NORMAL

	// Armor related variables
	armor = list(
		melee = 15,
		bullet = 25,
		energy = 10,
		bomb = 20,
		bio = 25,
		rad = 50
	)

// Panzers won't slip over on water or soap.
/mob/living/carbon/superior_animal/roach/tank/slip(var/slipped_on,stun_duration=8)
	return FALSE
