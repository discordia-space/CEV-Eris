/datum/category_item/underwear/top
	underwear_name = "bra"
	underwear_type = /obj/item/underwear/top
	underwear_gender = FEMALE

/datum/category_item/underwear/top/none
	name = "None"
	always_last = TRUE
	underwear_type = null
	underwear_gender = MALE

/datum/category_item/underwear/top/bra
	name = "bra, white"
	icon_state = "top_1w"

/datum/category_item/underwear/top/bra/black
	is_default = TRUE
	name = "bra, black"
	icon_state = "top_1b"

/datum/category_item/underwear/top/bra/red
	name = "bra, red"
	icon_state = "top_1r"

/datum/category_item/underwear/top/bra/yellow
	name = "bra, yellow"
	icon_state = "top_1y"

/datum/category_item/underwear/top/bra/cyan
	name = "bra, cyan"
	icon_state = "top_1c"

/datum/category_item/underwear/top/sportbra
	name = "sport bra, white"
	icon_state = "top_2w"

/datum/category_item/underwear/top/sportbra/black
	name = "sport bra, black"
	icon_state = "top_2b"

/datum/category_item/underwear/top/sportbra/red
	name = "sport bra, red"
	icon_state = "top_2r"

/datum/category_item/underwear/top/sportbra/yellow
	name = "sport bra, yellow"
	icon_state = "top_2y"

/datum/category_item/underwear/top/sportbra/cyan
	name = "sport bra, cyan"
	icon_state = "top_2c"

/datum/category_item/underwear/top/hornybra
	name = "perverted bra, white"
	icon_state = "top_3w"

/datum/category_item/underwear/top/hornybra/black
	name = "perverted bra, black"
	icon_state = "top_3b"

/datum/category_item/underwear/top/hornybra/red
	name = "perverted bra, red"
	icon_state = "top_3r"

/datum/category_item/underwear/top/hornybra/yellow
	name = "perverted bra, yellow"
	icon_state = "top_3y"

/datum/category_item/underwear/top/hornybra/cyan
	name = "perverted bra, cyan"
	icon_state = "top_3c"

/datum/category_item/underwear/top/none/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/top/bra/black/is_default(var/gender)
	return gender == FEMALE
