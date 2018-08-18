/mob/living/superior_animal/roach/support
	name = "Seuche Roach"
	desc = "A monstrous, dog-sized cockroach. This one smells like hell and secretes strange vapors."
	icon_state = "seuche"
	meat_amount = 3
	turns_per_move = 4
	maxHealth = 20
	health = 20

	melee_damage_upper = 3


/mob/living/superior_animal/roach/support/New()
	..()
	create_reagents(100)

/mob/living/superior_animal/roach/support/proc/gas_attack()
	if(!reagents.has_reagent("blattedin", 20) || stat != CONSCIOUS)
		return FALSE
	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/chem/S = new
	S.attach(location)
	S.set_up(src.reagents, src.reagents.total_volume, 0, location)
	src.visible_message(SPAN_DANGER("\the [src] secrete strange vapors!"))
	spawn(0)
		S.start()
	reagents.clear_reagents()
	return TRUE

/mob/living/superior_animal/roach/support/Life()
	..()
	if(stat != CONSCIOUS)
		return
	reagents.add_reagent("blattedin", 1)
	if(prob(7))
		gas_attack()

/mob/living/superior_animal/roach/support/FindTarget()
	. = ..()
	if(. && gas_attack())
		visible_emote("charges at [.] in clouds of poison!")
