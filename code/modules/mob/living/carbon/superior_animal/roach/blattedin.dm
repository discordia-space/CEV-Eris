/datum/reagent/toxin/blattedin
	name = "Blattedin"
	id = "blattedin"
	description = "A powerful toxin produced by those omnipresent roaches."
	taste_description = "chicken"
	reagent_state = LIQUID
	color = "#0F4800"
	strength = 0.15
	var/heal_strength = 5
	metabolism = REM * 0.1

	heating_point = T0C + 260
	heating_products = list("carbon", "protein")

/datum/reagent/toxin/blattedin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(istype(M, /mob/living/carbon/superior_animal/roach))
		var/mob/living/carbon/superior_animal/roach/bug = M
		bug.heal_organ_damage(heal_strength*removed)
	else
		. = ..()

/datum/reagent/toxin/blattedin/on_mob_add(mob/living/L)
	..()
	if(istype(L, /mob/living/carbon/superior_animal/roach))
		var/mob/living/carbon/superior_animal/roach/bug = L
		if(bug.stat == DEAD)
			if(bug.blattedin_revives_left && prob(70))//Roaches sometimes can come back to life from healing vapors
				bug.visible_message("<b>\The [bug.name]</b> twitches as it comes back to life!")
				blattedin_revive(bug)

/datum/reagent/toxin/blattedin/proc/blattedin_revive(mob/living/carbon/superior_animal/roach/bug)
	bug.blattedin_revives_left--
	bug.rejuvenate()
