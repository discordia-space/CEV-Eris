/mob/living/simple_animal/hostile/roach
	name = "space roach"
	desc = "A monstrous cockroach the size of a grown cat. These huge mutants can be everywhere where humans are, on ships, planets and stations."
	icon_state = "roach"
	icon_living = "roach"
	icon_dead = "roach_dead"
	speak_chance = 0
	turns_per_move = 3
	response_help = "pets the"
	response_disarm = "pushes aside"
	response_harm = "stamps on"
	speed = 4
	maxHealth = 10
	health = 10

	mob_size = MOB_SMALL
	density = 0 //Swarming roaches! They also more robust that way.

	harm_intent_damage = 3
	melee_damage_lower = 1
	melee_damage_upper = 4
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	faction = "roach"


/mob/living/simple_animal/hostile/roach/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"charges at [.]")

/mob/living/simple_animal/hostile/roach/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(5))
			L.Weaken(3)
			L.visible_message(SPAN_DANGER("\the [src] knocks down \the [L]!"))
