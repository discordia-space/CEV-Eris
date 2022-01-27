/obj/item/book/ritual/cruciform
	name = "NeoTheology ritual book"
	desc = "Contains holy litany and religious prayers."
	icon_state = "bible"
	price_tag = 300

/*
/obj/item/book/ritual/cruciform/ritual(var/datum/ritual/R)
	var/data = ""
	data += "<div style='margin-bottom:10px;'>"
	data += "<b>69capitalize(R.name)69</b><br>"
	data += "<a href='69href(R)69'>69R.get_display_phrase()69</a><br>"
	data += "<i>69R.desc69</i></div>"
	return data
*/

/*/obj/item/book/ritual/cruciform/inquisitor
	name = "Inquisitor ritual book"
	desc = "Contains holy litany and prayers only for the Inquisitor."
	icon_state = "biblep"*/

/obj/item/book/ritual/cruciform/priest
	name = "clergy ritual book"
	desc = "Contains holy litany and prayers only for the Clergy."
	icon_state = "biblep"
	price_tag = 500
