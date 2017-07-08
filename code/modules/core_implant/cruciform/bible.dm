/obj/item/weapon/book/ritual/cruciform
	name = "Cyberchristian prayer book"
	desc = "Contains holy litany and chants."
	icon_state = "bible"

/obj/item/weapon/book/ritual/cruciform/New()
	rituals = cruciform_base_rituals + cruciform_priest_rituals


/obj/item/weapon/book/ritual/cruciform/ritual(var/datum/ritual/R)
	var/data = ""
	data += "<div style='margin-bottom:10px;'>"
	data += "<b>[capitalize(R.name)]</b><br>"
	data += "<a href='[href(R)]'>[R.get_display_phrase()]</a><br>"
	data += "<i>[R.desc]</i></div>"
	return data


/obj/item/weapon/book/ritual/cruciform/inquisitor
	name = "Inquisitor prayer book"
	desc = "Contains holy litany and chants of inquisitor."
	icon_state = "bible"

/obj/item/weapon/book/ritual/cruciform/inquisitor/New()
	rituals = inquisitor_rituals
