/obj/item/weapon/book/bible
	name = "Cyberchristian prayer book"
	desc = "Contains holy litany and chants."
	icon = 'icons/obj/library.dmi'
	icon_state = "bible"
	var/list/rituals = list(/datum/ritual/relief, /datum/ritual/soul_hunger, /datum/ritual/entreaty)

/obj/item/weapon/book/attack_self(mob/living/carbon/human/H)
	interact(H)

/obj/item/weapon/book/bible/interact(mob/living/carbon/human/H)
	var/data = null
	for(var/datum/ritual/R in rituals)
		data +=  "<a href='byond://?src=\ref[src];[R.name]=1'>[R.phrase]</a><br>"
	H << browse(data, "window=bible")

/obj/item/weapon/book/bible/Topic(href, href_list)
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	for(var/datum/ritual/R in rituals)
		if(href_list[R.name])
			H.say(R.phrase + "!")
			break
	return 1
