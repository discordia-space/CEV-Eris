/datum/category_item/underwear/bottom
	underwear_gender = PLURAL
	underwear_name = "underwear"
	underwear_type = /obj/item/underwear/bottom

/datum/category_item/underwear/bottom/none
	name = "None"
	always_last = TRUE
	underwear_type = null

/datum/category_item/underwear/bottom/briefs
	name = "Briefs, white"
	icon_state = "m1"
	underwear_name = "briefs"

/datum/category_item/underwear/bottom/briefs_white/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/bottom/briefs_grey
	name = "Briefs, grey"
	underwear_name = "briefs"
	icon_state = "m2"

/datum/category_item/underwear/bottom/briefs_green
	name = "Briefs, green"
	underwear_name = "briefs"
	icon_state = "m3"

/datum/category_item/underwear/bottom/briefs_blue
	name = "Briefs, blue"
	underwear_name = "briefs"
	icon_state = "m4"

/datum/category_item/underwear/bottom/briefs_black
	name = "Briefs, black"
	underwear_name = "briefs"
	icon_state = "m5"

/datum/category_item/underwear/bottom/panties_noback
	name = "Panties, noback"
	underwear_name = "panties"
	icon_state = "m6"
	has_color = TRUE

/datum/category_item/underwear/bottom/panties_noback/is_default(var/gender)
	return gender == FEMALE