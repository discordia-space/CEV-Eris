/obj/item/weapon/book/bible
	name = "Cyberchristian prayer book"
	desc = "Contains holy litany and chants."
	icon = 'icons/obj/library.dmi'
	icon_state = "bible"
	var/list/rituals = list(/datum/ritual/cruciform/relief, /datum/ritual/cruciform/soul_hunger, /datum/ritual/cruciform/entreaty)

/obj/item/weapon/book/attack_self(mob/living/carbon/human/H)
	interact(H)

/obj/item/weapon/book/bible/interact(mob/living/carbon/human/H)
	var/data = null
	for(var/RT in rituals)
		var/datum/ritual/R = new RT
		data +=  "<a href='byond://?src=\ref[src];[R.name]=1'>[R.phrase]</a><br>"
	H << browse(data, "window=bible")

/obj/item/weapon/book/bible/Topic(href, href_list)
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	for(var/RT in rituals)
		var/datum/ritual/R = RT
		if(href_list[R.name])
			H.say(R.get_say_phrase())
			break
	return TRUE
