/mob/living/carbon/superior_animal/attack_ui(slot_id)
	return

/mob/living/carbon/superior_animal/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src, damage, attacktext, environment_smash) && loc && attack_sound)
		if (attack_sound && prob(attack_sound_chance))
			playsound(loc, attack_sound, attack_sound_volume, 1)