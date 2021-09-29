// Comrade Bear
/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."

	icon_state = "brownbear"
	icon_gib = "brownbear_gib"

	health = 75
	maxHealth = 75

	melee_damage_lower = 10
	melee_damage_upper = 10

	atmospheric_requirements = list(
		MIN_OXY_INDEX = 5,
		MAX_PLASMA_INDEX = 10,
		BODY_TEMP_MIN_INDEX = 100
	)
	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	known_commands = list("stay", "stop", "attack", "follow")

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if(!.)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(M.a_intent == I_HURT)
		src.emote("roars in rage!")
