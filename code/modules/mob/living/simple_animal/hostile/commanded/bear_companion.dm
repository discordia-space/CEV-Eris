/mob/living/simple_animal/hostile/commanded/bear
	name = "bear"
	desc = "A large brown bear."

	icon_state = "brownbear"
	icon_gib = "brownbear_gib"

	health = 75
	maxHealth = 75

	melee_damage_lower = 10
	melee_damage_upper = 10

	min_oxy = 5
	max_co2 = 5
	max_tox = 2 //We tuff bear

	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	known_commands = list("stay", "stop", "attack", "follow")

/mob/living/simple_animal/hostile/commanded/bear/hit_with_weapon(obj/item/O,69ob/living/user,69ar/effective_force,69ar/hit_zone)
	. = ..()
	if(!.)
		src.emote("roars in rage!")

/mob/living/simple_animal/hostile/commanded/bear/attack_hand(mob/living/carbon/human/M as69ob)
	..()
	if(M.a_intent == I_HURT)
		src.emote("roars in rage!")