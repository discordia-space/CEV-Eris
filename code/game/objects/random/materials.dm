/obj/random/material
	name = "random building material"
	icon_state = "material-grey"

//This stuff can't be easily converted to pickweight because of these amount fields
/obj/random/material/item_to_spawn()
	return pick(/obj/item/stack/material/steel/random,\
				/obj/item/stack/material/glass/random,\
				/obj/item/stack/material/plastic/random,\
				/obj/item/stack/material/wood/random,\
				/obj/item/stack/material/cardboard/random,\
				/obj/item/stack/rods/random,\
				/obj/item/stack/material/plasteel/random)

/obj/random/material/low_chance
	name = "low chance random building material"
	icon_state = "material-grey-low"
	spawn_nothing_percentage = 60

/obj/random/material_resources
	name = "random resource material"
	icon_state = "material-green"

/obj/random/material_resources/item_to_spawn()
	return pickweight(list(/obj/item/stack/material/steel/random = 5,\
				/obj/item/stack/material/glass/random = 4,\
				/obj/item/stack/material/glass/plasmaglass/random = 3,\
				/obj/item/stack/material/iron/random = 2,\
				/obj/item/stack/material/diamond/random = 1,\
				/obj/item/stack/material/plasma/random = 3,\
				/obj/item/stack/material/gold/random = 2,\
				/obj/item/stack/material/uranium/random = 1,\
				/obj/item/stack/material/silver/random = 2))

/obj/random/material_resources/low_chance
	name = "low chance random resource material"
	icon_state = "material-green-low"
	spawn_nothing_percentage = 60

/obj/random/material_rare
	name = "random rare material"
	icon_state = "material-orange"

/obj/random/material_rare/item_to_spawn()
	return pickweight(list(/obj/item/stack/material/diamond/random = 1,\
				/obj/item/stack/material/gold/random = 2,\
				/obj/item/stack/material/uranium/random = 1,\
				/obj/item/stack/material/silver/random = 2,\
				/obj/item/stack/material/glass/plasmaglass/random = 2))

/obj/random/material_rare/low_chance
	name = "low chance random rare material"
	icon_state = "material-orange-low"
	spawn_nothing_percentage = 60

/obj/random/material_ore
	name = "random ore"
	icon_state = "material-black"


/obj/random/material_ore/item_to_spawn()
	return pickweight(list(/obj/item/weapon/ore/coal = 4,\
				/obj/item/weapon/ore/glass = 5,\
				/obj/item/weapon/ore/gold = 3,\
				/obj/item/weapon/ore/hydrogen = 2,\
				/obj/item/weapon/ore/iron = 4,\
				/obj/item/weapon/ore/osmium = 2,\
				/obj/item/weapon/ore/plasma = 3,\
				/obj/item/weapon/ore/silver = 2,\
				/obj/item/weapon/ore/uranium = 1,\
				/obj/item/weapon/ore/diamond = 1))

/obj/random/material_ore/low_chance
	name = "low chance random ore"
	icon_state = "material-black-low"
	spawn_nothing_percentage = 60
