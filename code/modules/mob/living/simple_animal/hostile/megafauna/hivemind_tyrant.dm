/mob/living/simple_animal/hostile/megafauna/hivemind_tyrant
	name = "Hivemind Tyrant"
	desc = "Hivemind's will, manifested in flesh and metal."

	faction = "hive"

	icon = 'icons/mob/64x64.dmi'
	icon_state = "hivemind_tyrant"
	icon_living = "hivemind_tyrant"
	icon_dead = "hivemind_tyrant"
	pixel_x = -16

	health = 2500
	maxHealth = 2500

	melee_damage_lower = 10
	melee_damage_upper = 20

	boss_attack_types = list(/datum/boss_attack/devour)
