/superior_animal/roach
	faction = "roach"

/superior_animal/roach/Life()
	. = ..()

/superior_animal/roach/findTarget()
	. = ..()
	if(.)
		visible_emote("charges at [.]!")
		playsound(src, 'sound/voice/insect_battle_screeching.ogg', 30, 1, -3)


/superior_animal/roach/prepareAttackOnTarget()
	. = ..()

	var/mob/living/M = .
	if(istype(M))
		if(prob(5))
			M.Weaken(3)
			M.visible_message(SPAN_DANGER("\the [src] knocks down \the [M]!"))

	return .

/superior_animal/roach/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	if(melee_damage_upper == 0 && isliving(A))
		custom_emote(1, "[friendly] [A]!")
		return

	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src, damage, attacktext, environment_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)
