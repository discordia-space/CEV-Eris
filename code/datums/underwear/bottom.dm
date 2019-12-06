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
	icon_state = "briefs"
	underwear_name = "briefs"
	has_color = TRUE

/datum/category_item/underwear/bottom/briefs_white/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/bottom/panties_noback
	name = "Panties, noback"
	underwear_name = "panties_noback"
	icon_state = "panties_noback"
	has_color = TRUE

/datum/category_item/underwear/bottom/panties
	name = "Panties"
	underwear_name = "panties"
	icon_state = "panties"
	has_color = TRUE

/datum/category_item/underwear/bottom/pantiesalt
	name = "Panties, Alt"
	underwear_name = "panties_alt"
	icon_state = "panties_alt"
	has_color = TRUE

/datum/category_item/underwear/bottom/boxers
	name = "boxers"
	underwear_name = "boxers"
	icon_state = "boxers"
	has_color = TRUE

/datum/category_item/underwear/bottom/boxers_green_and_blue
	name = "boxers, green and blue"
	underwear_name = "boxers_green_and_blue"
	icon_state = "boxers_green_and_blue"
	has_color = TRUE

/datum/category_item/underwear/bottom/boxers_loveheart
	name = "boxers, loveheart"
	underwear_name = "boxers_loveheart"
	icon_state = "boxers_loveaheart"
	has_color = TRUE

/datum/category_item/underwear/bottom/panties/is_default(var/gender)
	return gender == FEMALE