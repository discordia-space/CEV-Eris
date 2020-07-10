/datum/category_item/underwear/top
	underwear_name = "bra"
	underwear_type = /obj/item/underwear/top
	underwear_gender = FEMALE

/datum/category_item/underwear/top/none
	name = "None"
	always_last = TRUE
	underwear_type = null
	underwear_gender = MALE

/datum/category_item/underwear/top/none/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/top/bra_red
	name = "Bra, red"
	icon_state = "f1"

/datum/category_item/underwear/top/bra_white
	is_default = TRUE
	name = "Bra, white"
	icon_state = "f2"

/datum/category_item/underwear/top/bra_white/is_default(var/gender)
	return gender == FEMALE

/datum/category_item/underwear/top/bra_yellow
	name = "Bra, yellow"
	icon_state = "f3"

/datum/category_item/underwear/top/bra_blue
	name = "Bra, blue"
	icon_state = "f4"

/datum/category_item/underwear/top/bra_black
	name = "Bra, black"
	icon_state = "f5"

/datum/category_item/underwear/top/sports_bra_white
	name = "Sports bra, white"
	icon_state = "f8"

/datum/category_item/underwear/top
	underwear_name = "bra"
	underwear_type = /obj/item/underwear/top
	underwear_gender = FEMALE

/datum/category_item/underwear/top/none/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/top/bra
	is_default = TRUE
	name = "Bra"
	icon_state = "bra"
	has_color = TRUE

/datum/category_item/underwear/top/bra/is_default(var/gender)
	return gender == FEMALE

/datum/category_item/underwear/top/sports_bra
	name = "Sports bra"
	icon_state = "sports_bra"
	has_color = TRUE

/datum/category_item/underwear/top/sports_bra_alt
	name = "Sports bra, alt"
	icon_state = "sports_bra_alt"
	has_color = TRUE

/datum/category_item/underwear/top/lacy_bra
	name = "Lacy bra"
	icon_state = "lacy_bra"

/datum/category_item/underwear/top/lacy_bra_alt
	name = "Lacy bra, alt"
	icon_state = "lacy_bra_alt"
	has_color = TRUE

/datum/category_item/underwear/top/lacy_bra_alt_stripe
	name = "Lacy bra, alt, stripe"
	icon_state = "lacy_bra_alt_stripe"

/datum/category_item/underwear/top/halterneck_bra
	name = "Halterneck bra"
	icon_state = "halterneck_bra"
	has_color = TRUE

/datum/category_item/underwear/top/tubetop
	name = "Tube Top"
	icon_state = "tubetop"
	has_color = TRUE

/datum/category_item/underwear/top/fishnet_base
	name = "Fishnet top"
	icon_state = "fishnet_body"

/datum/category_item/underwear/top/fishnet_sleeves
	name = "Fishnet with sleeves"
	icon_state = "fishnet_sleeves"

/datum/category_item/underwear/top/fishnet_gloves
	name = "Fishnet with gloves"
	icon_state = "fishnet_gloves"

/datum/category_item/underwear/top/striped_bra
	name = "Striped Bra"
	icon_state = "striped_bra"
	has_color = TRUE