/obj/item/weapon/book/bible
	name = "Cyberchristian prayer book"
	desc = "Contains holy litany and chants."
	icon = 'icons/obj/library.dmi'
	icon_state = "bible"

/obj/item/weapon/book/bible/attack_self(mob/living/carbon/human/H)
	interact(H)

/obj/item/weapon/book/bible/interact(mob/living/carbon/human/H)
	var/data = null
	for(var/RT in cruciform_rituals)
		var/datum/ritual/R = new RT
		data += "<div style='margin-bottom:10px;'>"
		data += "<b>[capitalize(R.name)]</b><br>"
		data += "<a href='byond://?src=\ref[src];[R.name]=1'>[R.get_display_phrase()]</a><br>"
		data += "<i>[R.desc]</i></div>"
	H << browse(data, "window=bible")

/obj/item/weapon/book/bible/Topic(href, href_list)
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	for(var/RT in cruciform_rituals)
		var/datum/ritual/R = new RT
		if(href_list[R.name])
			H.say(R.get_say_phrase())
			break
	return TRUE
