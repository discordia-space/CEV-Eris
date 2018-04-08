/obj/random/material
	name = "random building material"
	icon_state = "material-grey"

/obj/random/material/item_to_spawn()
	return pick(/obj/item/stack/material/steel{amount = 20},\
				/obj/item/stack/material/glass{amount = 20},\
				/obj/item/stack/material/plastic{amount = 20},\
				/obj/item/stack/material/wood{amount = 20},\
				/obj/item/stack/material/cardboard{amount = 20},\
				/obj/item/stack/rods{amount = 30},\
				/obj/item/stack/material/plasteel{amount = 10})

/obj/random/material/low_chance
	name = "low chance random building material"
	icon_state = "material-grey-low"
	spawn_nothing_percentage = 60

/obj/random/material_resources
	name = "random resource material"
	icon_state = "material-green"

/obj/random/material_resources/item_to_spawn()
	return pick(prob(5);/obj/item/stack/material/steel{amount = 20},\
				prob(4);/obj/item/stack/material/glass{amount = 20},\
				prob(4);/obj/item/stack/material/iron{amount = 20},\
				prob(1);/obj/item/stack/material/diamond{amount = 3},\
				prob(3);/obj/item/stack/material/plasma{amount = 10},\
				prob(2);/obj/item/stack/material/gold{amount = 5},\
				prob(1);/obj/item/stack/material/uranium{amount = 3},\
				prob(2);/obj/item/stack/material/silver{amount = 5})

/obj/random/material_resources/low_chance
	name = "low chance random resource material"
	icon_state = "material-green-low"
	spawn_nothing_percentage = 60

/obj/random/material_rare
	name = "random rare material"
	icon_state = "material-orange"

/obj/random/material_rare/item_to_spawn()
	return pick(prob(1);/obj/item/stack/material/diamond{amount = 5},\
				prob(2);/obj/item/stack/material/gold{amount = 20},\
				prob(1);/obj/item/stack/material/uranium{amount = 10},\
				prob(2);/obj/item/stack/material/silver{amount = 20})

/obj/random/material_rare/low_chance
	name = "low chance random rare material"
	icon_state = "material-orange-low"
	spawn_nothing_percentage = 60
