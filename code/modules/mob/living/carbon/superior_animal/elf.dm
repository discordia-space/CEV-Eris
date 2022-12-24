/mob/living/carbon/superior_animal/elf
	name = "fueltide elf"
	desc = "Jingle bells, fuel smells,\
			<br>Vagas gonna burn,\
			<br>Sentinels of maint tunnels,\
			<br>Arsonistic elves!"
	icon_state = "elf"
	turns_per_move = 4
	maxHealth = 25
	health = 25
	density = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 20
	faction = "event"
	spawn_tags = SPAWN_ELF


/mob/living/carbon/superior_animal/elf/bullet_act(obj/item/projectile/P, def_zone)
	if(QDELETED(src))
		return
	if(prob(25))
		death()
	else
		. = ..()


/mob/living/carbon/superior_animal/elf/fire_act()
	if(!QDELETED(src) && prob(15))
		death()


/mob/living/carbon/superior_animal/elf/skill_to_evade_traps()
	return 100


/mob/living/carbon/superior_animal/elf/gib()
	if(!QDELETED(src))
		death()


/mob/living/carbon/superior_animal/elf/death()
	if(prob(20))
		playsound(loc, 'sound/sanity/gnomed.mp3', 100, 1)
	walk(src, 0)
	target_mob = null
	new /obj/effect/decal/cleanable/liquid_fuel(loc, 50, 1)
	explosion(get_turf(src), -1, -1, 2, 4)
	qdel(src)


/mob/living/carbon/superior_animal/elf/ex_act()
	return
