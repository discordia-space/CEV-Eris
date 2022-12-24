//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/name = "nameless"
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/plasteel
	name = "Plasteel"
	metaltag = "plasteel"
	requires = list(
		"plasma" = 1,
		"carbon" = 2,
		"hematite" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel

/datum/alloy/steel
	name = "Steel"
	metaltag = MATERIAL_STEEL
	requires = list(
		"carbon" = 1,
		"hematite" = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	name = "Borosilicate glass"
	metaltag = MATERIAL_PLASMAGLASS
	requires = list(
		"plasma" = 1,
		"sand" = 2
		)
	product = /obj/item/stack/material/glass/plasmaglass

