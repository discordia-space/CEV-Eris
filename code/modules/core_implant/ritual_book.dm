/obj/item/weapon/book/ritual
	name = "Rituals book"
	desc = "Contains rituals."
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	var/list/rituals = list()

/obj/item/weapon/book/ritual/attack_self(mob/living/carbon/human/H)
	playsound(src.loc, pick('sound/items/BOOK_Turn_Page_1.ogg',\
		'sound/items/BOOK_Turn_Page_2.ogg',\
		'sound/items/BOOK_Turn_Page_3.ogg',\
		'sound/items/BOOK_Turn_Page_4.ogg',\
		), rand(40,80), 1)
	interact(H)

/obj/item/weapon/book/ritual/interact(mob/living/carbon/human/H)
	var/data = null
	for(var/RT in rituals)
		var/datum/ritual/R = new RT
		if(!R.phrase || R.phrase == "")
			continue
		data += ritual(R)
	H << browse(data, "window=[src.name]")

/obj/item/weapon/book/ritual/proc/href(var/datum/ritual/R)
	var/rtype = replacetext("[R.type]","/","")
	return "byond://?src=\ref[src];[rtype]=1"

/obj/item/weapon/book/ritual/proc/ritual(var/datum/ritual/R)
	var/data = ""

	data += "<div style='margin-bottom:10px;'>"
	data += "<b>[capitalize(R.name)]</b><br>"
	data += "<a href='[href(R)]'>[R.get_display_phrase()]</a><br>"
	data += "<i>[R.desc]</i></div>"
	return data

/obj/item/weapon/book/ritual/Topic(href, href_list)
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	for(var/RT in rituals)
		var/rtype = replacetext("[RT]","/","")
		if(href_list[rtype])
			var/datum/ritual/R = new RT
			H.say(R.get_say_phrase())
			break
	return TRUE