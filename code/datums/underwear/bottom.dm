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

/datum/category_item/underwear/bottom/boxers_loveheart
	name = "Boxers, Loveheart"
	icon_state = "boxers_loveheart"

/datum/category_item/underwear/bottom/boxers
	name = "Boxers"
	icon_state = "boxers"
	has_color = TRUE

/datum/category_item/underwear/bottom/boxers_green_and_blue
	name = "Boxers, green & blue striped"
	icon_state = "boxers_green_and_blue"

/datum/category_item/underwear/bottom/panties
	name = "Panties"
	icon_state = "panties"
	has_color = TRUE

/datum/category_item/underwear/bottom/panties/is_default(var/gender)
	return gender == FEMALE

/datum/category_item/underwear/bottom/lacy_thong
	name = "Lacy thong"
	icon_state = "lacy_thong"

/datum/category_item/underwear/bottom/lacy_thong_alt
	name = "Lacy thong, alt"
	icon_state = "lacy_thong_alt"
	has_color = TRUE

/datum/category_item/underwear/bottom/panties_alt
	name = "Panties, alt"
	icon_state = "panties_alt"
	has_color = TRUE

/datum/category_item/underwear/bottom/compression_shorts
	name = "Compression shorts"
	icon_state = "compression_shorts"
	has_color = TRUE

/datum/category_item/underwear/bottom/thong
	name = "Thong"
	icon_state = "thong"
	has_color = TRUE

/datum/category_item/underwear/bottom/fishnet_lower
	name = "Fishnets"
	icon_state = "fishnet_lower"

/datum/category_item/underwear/bottom/striped_panties
	name = "Striped Panties"
	icon_state = "striped_panties"
	has_color = TRUE

/datum/category_item/underwear/bottom/longjon
	name = "Long John Bottoms"
	icon_state = "ljonb"
	has_color = TRUE