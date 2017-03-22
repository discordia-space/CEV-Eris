var/list/christians = list()
// Kind shitty solution, but needed for testing
var/mob/living/carbon/human/priest = null

/obj/item/weapon/implant/cruciform
	name = "cruciform"
	w_class = 2
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	var/dna = null
	var/power = 50
	var/max_power = 50
	var/list/allowed_rituals = list(/datum/ritual/relief, /datum/ritual/soul_hunger, /datum/ritual/banish, /datum/ritual/entreaty)

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
	if(!implanted && !wearer)
		return
	restore_power(1)

/obj/item/weapon/implant/cruciform/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/weapon/implant/cruciform/hear_talk(mob/living/carbon/human/H, message)
	if(wearer != H)
		return

	message = replace_characters(message, list("," = "", "." = ""))
	for(/datum/ritual/R in allowed_rituals)
		if(R.phrase = message)
			R.perform(H, src)
			return


/obj/item/weapon/implant/cruciform/priest
	power = 100
	max_power = 100

/obj/item/weapon/implant/cruciform/priest/install(/mob/living/carbon/human/H)
	priest = H
	..()