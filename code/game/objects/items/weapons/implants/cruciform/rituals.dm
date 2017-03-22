/datum/ritual/
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
	phrase = "Et si ambulavero in medio umbrae mortis non timebo mala"
	power = 50
	chance = 30

/datum/ritual/relief/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C)
	var/success = prob(chance)
	if(success)
		H.add_chemical_effect(CE_PAINKILLER, 10)
	..(H, C, success)


/datum/ritual/soul_hunger
	phrase = "Panem nostrum cotidianum da nobis hodie"
	power = 50
	chance = 30

/datum/ritual/soul_hunger/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C)
	var/success = prob(chance)
	if(success)
		H.nutrition += 100
		H.adjustToxLoss(5)
	..(H, C, success)


/datum/ritual/entreaty
	phrase = "Deus meus ut quid dereliquisti me?"
	power = 50
	chance = 60

/datum/ritual/entreaty/perform(mob/living/carbon/human/H, /obj/item/weapon/implant/cruciform/C)
	var/message = "[H] cries for help!"
	var/success = prob(chance)
	if(success)
		for(mob/living/carbon/human/H in christians)
			if(H == priest || prob(20))
				H << "<span class='danger'>[H], faithful cruciform follower, cries for salvation!</span>"
	..(H, C, success)


/datum/ritual/epiphany
	phrase = "In nomine Patris et Filii et Spiritus sancti"

/datum/ritual/banish
	phrase = "Et ne inducas nos in tentationem, sed libera nos a malo"

