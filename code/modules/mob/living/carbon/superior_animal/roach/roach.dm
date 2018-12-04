/mob/living/carbon/superior_animal/roach
	name = "Kampfer Roach"
	desc = "A monstrous, dog-sized cockroach. These huge mutants can be everywhere where humans are, on ships, planets and stations."

	icon_state = "roach"

	mob_size = MOB_SMALL

	density = 0 //Swarming roaches! They also more robust that way.

	attack_sound = 'sound/voice/insect_battle_bite.ogg'
	emote_see = list("chirps loudly.", "cleans its whiskers with forelegs.")
	turns_per_move = 3
	turns_since_move = 0

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/roachmeat
	meat_amount = 3

	maxHealth = 15
	health = 15

	var/blattedin_revives_left = 1 // how many times blattedin can get us back to life (as num for adminbus fun).

	melee_damage_lower = 1
	melee_damage_upper = 4

	min_breath_required_type = 3
	min_air_pressure = 15 //below this, brute damage is dealt

	faction = "roach"
	pass_flags = PASSTABLE
	acceptableTargetDistance = 3 //consider all targets within this range equally


//When roaches die near a leader, the leader may call for reinforcements
/mob/living/carbon/superior_animal/roach/death()
	.=..()
	if (.)
		for (var/mob/living/carbon/superior_animal/roach/fuhrer/F in range(src,10))
			F.distress_call()
