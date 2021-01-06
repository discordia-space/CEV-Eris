/mob/living/carbon/superior_animal/roach/roachling
	name = "Roachling"
	desc = "A tiny cockroach. It never stays still for long."
	icon_state = "roachling"

	turns_per_move = 3
	maxHealth = 10
	health = 10
	move_to_delay = 3.5

	melee_damage_lower = 2
	melee_damage_upper = 5
	spawn_blacklisted = TRUE

	meat_amount = 1

	probability_egg_laying = 0
	var/amount_grown = 0

/mob/living/carbon/superior_animal/roach/roachling/Life()
	.=..()
	if(!stat)
		amount_grown += rand(0,2) // Roachling growing up

		if(amount_grown >= 100) // Old enough to turn into an adult
			var/spawn_type
			if (fed > 0) // If roachling has eaten a corpse
				spawn_type = /mob/living/carbon/superior_animal/roach/fuhrer
			else
				spawn_type = /obj/spawner/mob/roaches
			new spawn_type(src.loc, src)
			qdel(src)
