//RANDOM SCRAP PILE GENERATOR
/obj/random/scrap
	name = "Random trash"
	icon_state = "junk-red"
	desc = "This is a random trash."

/obj/random/scrap/dense_even
	name = "Random dense even trash"

/obj/random/scrap/dense_even/item_to_spawn()
		return pick(list(
						/obj/structure/scrap/large,
						/obj/structure/scrap/medical/large,
						/obj/structure/scrap/vehicle/large,
						/obj/structure/scrap/food/large,
						/obj/structure/scrap/guns/large,
						/obj/structure/scrap/cloth/large,
						/obj/structure/scrap/poor/structure,
						/obj/structure/scrap/science/large
					))

/obj/random/scrap/dense_weighted/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70





/obj/random/scrap/dense_weighted
	name = "Random dense weighted trash"

/obj/random/scrap/dense_weighted/item_to_spawn()
		return pickweight(list(
						/obj/structure/scrap/poor/large = 70,
						/obj/structure/scrap/poor/structure = 70,
						/obj/structure/scrap/large = 20,
						/obj/structure/scrap/medical/large = 14,
						/obj/structure/scrap/science/large = 14,
						/obj/structure/scrap/vehicle/large = 20,
						/obj/structure/scrap/cloth/large = 26,
						/obj/structure/scrap/food/large = 40,
						/obj/structure/scrap/guns/large = 3
					))

/obj/random/scrap/dense_weighted/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70





/obj/random/scrap/sparse_even
	name = "Random sparse even trash"

/obj/random/scrap/sparse_even/item_to_spawn()
		return pick(list(
					/obj/structure/scrap,
					/obj/structure/scrap/medical,
					/obj/structure/scrap/vehicle,
					/obj/structure/scrap/food,
					/obj/structure/scrap/science,
					/obj/structure/scrap/guns,
					/obj/structure/scrap/cloth
					))

/obj/random/scrap/sparse_even/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70





/obj/random/scrap/sparse_weighted
	name = "Random sparse weighted trash"

/obj/random/scrap/sparse_weighted/item_to_spawn()
		return pickweight(list(
						/obj/structure/scrap/poor = 100,
						/obj/structure/scrap = 18,
						/obj/structure/scrap/medical = 12,
						/obj/structure/scrap/science = 12,
						/obj/structure/scrap/vehicle = 18,
						/obj/structure/scrap/cloth = 24,
						/obj/structure/scrap/food = 36,
						/obj/structure/scrap/guns = 3
					))

/obj/random/scrap/sparse_weighted/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70




/obj/random/scrap/moderate_weighted
	name = "Random moderate weighted trash"

/obj/random/scrap/moderate_weighted/item_to_spawn()
		return pickweight(list(
						/obj/random/scrap/sparse_weighted = 2,
						/obj/random/scrap/dense_weighted = 1
					))

/obj/random/scrap/moderate_weighted/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70
