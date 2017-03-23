var/list/christians = list()

/obj/item/weapon/implant/cruciform
	name = "cruciform"
	w_class = 2
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	var/dna = null
	var/power = 50
	var/max_power = 50
	var/success_modifier = 1
	var/active = FALSE
	var/list/allowed_rituals = list(/datum/ritual/relief, /datum/ritual/soul_hunger, /datum/ritual/entreaty)

/obj/item/weapon/implant/cruciform/proc/use_power(var/value)
	power = max(0, power - value)

/obj/item/weapon/implant/cruciform/proc/restore_power(var/value)
	power = min(max_power, power + value)

/obj/item/weapon/implant/cruciform/install(/mob/living/carbon/human/H)
	..(H, "chest")
	src.dna = H.dna
	processing_objects.Add(src)
	christians.Add(H)

/obj/item/weapon/implant/cruciform/process()
	if((!implanted && !wearer) || !active)
		return
	restore_power(0.5)

/obj/item/weapon/implant/cruciform/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/implant/cruciform/hear_talk(mob/living/carbon/human/H, message)
	if(!active)
		return

	if(wearer != H)
		return

	message = replace_characters(message, list("." = ""))
	for(/datum/ritual/R in allowed_rituals)
		if(R.phrase = message)
			if(R.power > src.power)
				H << "<span class='danger'></span>"
				return
			R.perform(H, src)
			return


/obj/item/weapon/implant/cruciform/priest
	power = 100
	max_power = 100
	success_modifier = 3
