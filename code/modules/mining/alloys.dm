//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/name = "nameless"
	var/ore_input
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/plasteel
	name = "Plasteel"
	metaltag = "plasteel"
	ore_input = 5
	requires = list(
		ORE_PLASMA = 1,
		ORE_CARBON = 2,
		ORE_IRON = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel

/datum/alloy/steel
	name = "Steel"
	metaltag = MATERIAL_STEEL
	ore_input = 2
	requires = list(
		ORE_CARBON = 1,
		ORE_IRON = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	name = "Borosilicate glass"
	metaltag = MATERIAL_PLASMAGLASS
	ore_input = 3
	requires = list(
		ORE_PLASMA = 1,
		ORE_SAND = 2
		)
	product = /obj/item/stack/material/glass/plasmaglass

