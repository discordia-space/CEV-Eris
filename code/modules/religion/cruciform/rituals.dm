/datum/ritual/
	var/name
	var/phrase
	var/power
	var/chance
	var/success_message = "Ritual successed."
	var/fail_message = "Ritual failed."

/datum/ritual/proc/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C, var/success)
	if(success)
		C.use_power(src.power)
		H << "<span class='notice'>[success_message]</span>"
	else
		C.use_power(src.power/2)
		H << "<span class='danger'>[fail_message]</span>"


/datum/ritual/relief
	name = "relief"
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	power = 50
	chance = 33

/datum/ritual/relief/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C)
	var/success = prob(chance * C.success_modifier)
	if(success)
		H.add_chemical_effect(CE_PAINKILLER, 10)
	..(H, C, success)


/datum/ritual/soul_hunger
	name = "soul_hunger"
	phrase = "Panem nostrum cotidianum da nobis hodie"
	power = 50
	chance = 33

/datum/ritual/soul_hunger/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C)
	var/success = prob(chance * C.success_modifier)
	if(success)
		H.nutrition += 100
		H.adjustToxLoss(5)
	..(H, C, success)


/datum/ritual/entreaty
	name = "entreaty"
	phrase = "Deus meus ut quid dereliquisti me?"
	power = 50
	chance = 60

/datum/ritual/entreaty/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C)
	var/success = prob(chance * C.success_modifier)
	if(success)
		for(mob/living/carbon/human/target in christians)
			if(target == H)
				continue
			if(locate(/obj/item/weapon/cruciform/priest, target) || prob(20))
				target << "<span class='danger'>[H], faithful cruciform follower, cries for salvation!</span>"
	..(H, C, success)


/datum/ritual/epiphany
	phrase = "In nomine Patris et Filii et Spiritus sancti"

/datum/ritual/banish
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"

