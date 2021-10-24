/datum/category_item/underwear/bottom
	underwear_gender = PLURAL
	underwear_name = "underwear"
	underwear_type = /obj/item/underwear/bottom

/datum/category_item/underwear/bottom/none
	name = "None"
	always_last = TRUE
	underwear_type = null

/datum/category_item/underwear/bottom/boxers
	name = "boxers, white"
	icon_state = "underwear_m_1w"
	underwear_name = "boxers"

/datum/category_item/underwear/bottom/boxers/black
	is_default = TRUE
	name = "boxers, black"
	icon_state = "underwear_m_1b"

/datum/category_item/underwear/bottom/boxers/red
	name = "boxers, red"
	icon_state = "underwear_m_1r"

/datum/category_item/underwear/bottom/boxers/yellow
	name = "boxers, yellow"
	icon_state = "underwear_m_1y"

/datum/category_item/underwear/bottom/boxers/cyan
	name = "boxers, cyan"
	icon_state = "underwear_m_1c"

/datum/category_item/underwear/bottom/briefs
	name = "briefs, white"
	icon_state = "underwear_m_2w"
	underwear_name = "briefs"

/datum/category_item/underwear/bottom/briefs/black
	name = "briefs, black"
	icon_state = "underwear_m_2b"

/datum/category_item/underwear/bottom/briefs/red
	name = "briefs, red"
	icon_state = "underwear_m_2r"

/datum/category_item/underwear/bottom/briefs/yellow
	name = "briefs, yellow"
	icon_state = "underwear_m_2y"

/datum/category_item/underwear/bottom/briefs/cyan
	name = "briefs, cyan"
	icon_state = "underwear_m_2c"

/datum/category_item/underwear/bottom/briefsnoback
	name = "briefs, no back, white"
	icon_state = "underwear_m_3w"
	underwear_name = "briefs, no back"

/datum/category_item/underwear/bottom/briefsnoback/black
	name = "briefs, no back, black"
	icon_state = "underwear_m_3b"

/datum/category_item/underwear/bottom/briefsnoback/red
	name = "briefs, no back, red"
	icon_state = "underwear_m_3r"

/datum/category_item/underwear/bottom/briefsnoback/yellow
	name = "briefs, no back, yellow"
	icon_state = "underwear_m_3y"

/datum/category_item/underwear/bottom/briefsnoback/cyan
	name = "briefs, no back, cyan"
	icon_state = "underwear_m_3c"

/datum/category_item/underwear/bottom/panties
	name = "panties, white"
	icon_state = "underwear_f_1w"
	underwear_name = "panties"

/datum/category_item/underwear/bottom/panties/black
	is_default = TRUE
	name = "panties, black"
	icon_state = "underwear_f_1b"

/datum/category_item/underwear/bottom/panties/red
	name = "panties, red"
	icon_state = "underwear_f_1r"

/datum/category_item/underwear/bottom/panties/yellow
	name = "panties, yellow"
	icon_state = "underwear_f_1y"

/datum/category_item/underwear/bottom/panties/cyan
	name = "panties, cyan"
	icon_state = "underwear_f_1c"

/datum/category_item/underwear/bottom/sportpanties
	name = "sport panties, white"
	icon_state = "underwear_f_2w"
	underwear_name = "sport panties"

/datum/category_item/underwear/bottom/sportpanties/black
	name = "sport panties, black"
	icon_state = "underwear_f_2b"

/datum/category_item/underwear/bottom/sportpanties/red
	name = "sport panties, red"
	icon_state = "underwear_f_2r"

/datum/category_item/underwear/bottom/sportpanties/yellow
	name = "sport panties, yellow"
	icon_state = "underwear_f_2y"

/datum/category_item/underwear/bottom/sportpanties/cyan
	name = "sport panties, cyan"
	icon_state = "underwear_f_2c"

/datum/category_item/underwear/bottom/hornypanties
	name = "perverted panties, white"
	icon_state = "underwear_f_3w"
	underwear_name = "perverted panties"

/datum/category_item/underwear/bottom/hornypanties/black
	name = "perverted panties, black"
	icon_state = "underwear_f_3b"

/datum/category_item/underwear/bottom/hornypanties/red
	name = "perverted panties, red"
	icon_state = "underwear_f_3r"

/datum/category_item/underwear/bottom/hornypanties/yellow
	name = "perverted panties, yellow"
	icon_state = "underwear_f_3y"

/datum/category_item/underwear/bottom/hornypanties/cyan
	name = "perverted panties, cyan"
	icon_state = "underwear_f_3c"

/datum/category_item/underwear/bottom/boxers/black/is_default(var/gender)
	return gender != FEMALE

/datum/category_item/underwear/bottom/panties/black/is_default(var/gender)
	return gender == FEMALE
