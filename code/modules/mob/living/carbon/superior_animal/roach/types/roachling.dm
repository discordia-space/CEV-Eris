/mob/living/carbon/superior_animal/roach/roachling
	name = "Roachling"
	desc = "A tiny cockroach. It never stays still for long."
	icon_state = "roachling"

	turns_per_move = 3
	maxHealth = 10
	health = 10
	move_to_delay = 3

	melee_damage_lower = 1
	melee_damage_upper = 3
	spawn_blacklisted = TRUE

	mob_size = MOB_SMALL * 0.8 // 8

	meat_amount = 1

	probability_egg_laying = 0
	var/amount_grown = 0
	var/big_boss = FALSE

/mob/living/carbon/superior_animal/roach/roachling/Life()
	.=..()
	if(!stat)
		amount_grown += rand(0,2) // Roachling growing up

		if(amount_grown >= 100) // Old enough to turn into an adult
			var/spawn_type
			if (fed > 0) // If roachling has eaten a corpse
				if (big_boss == TRUE && prob(fed)) // has eaten a fuhrer roach and has eaten a bunch otherwise
					spawn_type = /mob/living/carbon/superior_animal/roach/kaiser// or got lucky
				else
					spawn_type = /mob/living/carbon/superior_animal/roach/fuhrer
			else
				spawn_type = /obj/spawner/mob/roaches

			if (ispath(spawn_type, /obj/spawner))
				new spawn_type(src.loc, src, list("friends" = src.friends.Copy()))
			else if(ispath(spawn_type, /mob))
				var/mob/living/carbon/superior_animal/roach/roach = new spawn_type(src.loc, src)
				roach.friends += src.friends
			qdel(src)
