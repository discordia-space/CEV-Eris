/datum/craft_recipe/wall_girders
	name = "wall girders"
	result = /obj/structure/girder
	steps = list(
		list(/obj/item/stack/material/steel, 5, time = 50)
	)
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF

/datum/craft_recipe/metal_rod
	name = "metal rod"
	result = /obj/item/stack/rods
	steps = list(
		list(/obj/item/stack/material/steel, 1)
	)

/datum/craft_recipe/box
	name = "box"
	result = /obj/item/weapon/storage/box
	steps = list(
		list(/obj/item/stack/material/cardboard, 1)
	)


/datum/craft_recipe/plastic_bag
	name = "plastic bag"
	result = /obj/item/weapon/storage/bag/plasticbag
	steps = list(
		list(/obj/item/stack/material/plastic, 1)
	)

/datum/craft_recipe/blood_pack
	name = "blood pack"
	result = /obj/item/weapon/reagent_containers/blood/empty
	steps = list(
		list(/obj/item/stack/material/plastic, 1)
	)

/datum/craft_recipe/ashtray
	name = "ashtray"
	result = /obj/item/weapon/material/ashtray
	steps = list(
		list(/obj/item/stack/material/steel, 1)
	)

/datum/craft_recipe/beehive_assembly
	name = "beehive assembly"
	result = /obj/item/beehive_assembly
	steps = list(
		list(/obj/item/stack/material/wood, 10)
	)

/datum/craft_recipe/beehive_frame
	name = "beehive frame"
	result = /obj/item/honey_frame
	steps = list(
		list(/obj/item/stack/material/wood, 1)
	)

/datum/craft_recipe/canister
	name = "canister"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(/obj/item/stack/material/steel, 10)
	)

/datum/craft_recipe/cannon_frame
	name = "cannon frame"
	result = /obj/item/weapon/cannonframe
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(/obj/item/stack/material/steel, 10)
	)



/datum/craft_recipe/folder
	name = "grey folder"
	result = /obj/item/weapon/folder
	steps = list(
		list(/obj/item/stack/material/cardboard, 1)
	)

/datum/craft_recipe/folder/blue
	name = "blue folder"
	result = /obj/item/weapon/folder/blue

/datum/craft_recipe/folder/red
	name = "red folder"
	result = /obj/item/weapon/folder/red

/datum/craft_recipe/folder/white
	name = "white folder"
	result = /obj/item/weapon/folder/white

/datum/craft_recipe/folder/yellow
	name = "yellow folder"
	result = /obj/item/weapon/folder/yellow




