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
	name = "Panties, alt"
	underwear_name = "panties_alt"
	icon_state = "panties_alt"
	has_color = TRUE

/datum/category_item/underwear/bottom/thong
	name = "Thong"
	underwear_name = "Thong"
	icon_state = "thong"
	has_color = TRUE

/datum/category_item/underwear/bottom/lacy_thong_alt
	name = "Thong, lacy"
	underwear_name = "lacy_thong_alt"
	icon_state = "lacy_thong_alt"

/datum/category_item/underwear/bottom/boxers
	name = "Boxers"
	underwear_name = "boxers"
	icon_state = "boxers"
	has_color = TRUE

/datum/category_item/underwear/bottom/boxers_green_and_blue
	name = "Boxers, green and blue"
	underwear_name = "boxers_green_and_blue"
	icon_state = "boxers_green_and_blue"

/datum/category_item/underwear/bottom/boxers_loveheart
	name = "Boxers, loveheart"
	underwear_name = "boxers_loveheart"
	icon_state = "boxers_loveaheart"

/datum/category_item/underwear/bottom/compression_shorts
	name = "Shorts, compression"
	underwear_name = "compression_shorts"
	icon_state = "compression_shorts"
	has_color = TRUE

/datum/category_item/underwear/bottom/expedition_shorts
	name = "Shorts, expedition"
	underwear_name = "expedition_shorts"
	icon_state = "expedition_shorts"

/datum/category_item/underwear/bottom/fleet_shorts
	name = "Shorts, fleet"
	underwear_name = "fleet_shorts"
	icon_state = "fleet_shorts"

/datum/category_item/underwear/bottom/army_shorts
	name = "Shorts, army"
	underwear_name = "army_shorts"
	icon_state = "army_shorts"

/datum/category_item/underwear/bottom/ljonb
	name = "Underwear, long-johns"
	underwear_name = "ljonb"
	icon_state = "ljonb"


/datum/category_item/underwear/bottom/panties/is_default(var/gender)
	return gender == FEMALE