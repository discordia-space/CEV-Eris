/mob/living/carbon/superior_animal/roach/support
	name = "Seuche Roach"
	desc = "A monstrous, dog-sized cockroach. This one smells like hell and secretes strange vapors."
	icon_state = "seuche"
	turns_per_move = 6
	maxHealth = 20
	health = 20
	melee_damage_lower = 2
	melee_damage_upper = 4
	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche
	meat_amount = 3
	rarity_value = 11.25
	var/datum/reagents/gas_sac //Stores gas. Can't use the default reagents since that is now bloodstream

	// Armor related variables
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 0,
		bomb = 0,
		bio = 75,
		rad = 50
	)

/mob/living/carbon/superior_animal/roach/support/New()
	.=..()
	gas_sac = new /datum/reagents(100, src)

/mob/living/carbon/superior_animal/roach/support/Destroy()
	QDEL_NULL(gas_sac)
	overseer?.removeHealer(src)
	return ..()

/mob/living/carbon/superior_animal/roach/support/proc/gas_attack()
	if(!gas_sac.has_reagent("blattedin", 20) || stat != CONSCIOUS)
		return

	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/chem/roach/S = new()

	S.attach(location)
	S.set_up(gas_sac, gas_sac.total_volume, 0, location)
	src.visible_message(SPAN_DANGER("\the [src] secretes strange vapors!"))

	spawn(0)
		S.start()

	gas_sac.clear_reagents()
	return TRUE

/mob/living/carbon/superior_animal/roach/support/Life()
	. = ..()
	if(stat != CONSCIOUS)
		return

	if(stat != AI_inactive)
		return

	gas_sac.add_reagent("blattedin", 1)

	if(!target_mob)
		return

	if(prob(7) && !(/obj/effect/effect/smoke/chem/roach in loc)) // don't stack it passively
		gas_attack()

/mob/living/carbon/superior_animal/roach/support/findTarget()
	. = ..()
	if(. && !((/obj/effect/effect/smoke/chem/roach in get_turf(.)) && (/obj/effect/effect/smoke/chem/roach in loc)) && gas_attack())// if you aren't clouding your/their area, attempt to gas
		visible_emote("charges at [.] in clouds of poison!")

/mob/living/carbon/superior_animal/roach/support/joinOvermind(datum/overmind/roachmind/jointhis)
	jointhis.addHealer(src) // Seuche is Healer
	overseer = jointhis

/mob/living/carbon/superior_animal/roach/support/leaveOvermind()
	overseer?.removeHealer(src) // Healer Seuche
	overseer?.casualties.Remove(src)
	overseer = null
