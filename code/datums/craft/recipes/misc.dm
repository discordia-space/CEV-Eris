/datum/craft_recipe/wall_girders
	name = "wall girders"
	result = /obj/structure/girder
	steps = list(
		list(/obj/item/stack/material/steel, 5, time = WORKTIME_NORMAL)
	)
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF

/datum/craft_recipe/wall_girders/low
	name = "low girders"
	result = /obj/structure/girder/low
	steps = list(
		list(/obj/item/stack/material/steel, 3, time = WORKTIME_FAST)
	)

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



/datum/craft_recipe/bandage
	name = "bandages"
	result = /obj/item/stack/medical/bruise_pack/handmade
	steps = list(
		list(/obj/item/clothing, 1, time = 30)
	)

/datum/craft_recipe/handmade_handtele
	name = "cheap hand-tele"
	result = /obj/item/weapon/hand_tele/handmade
	steps = list(
		list(/obj/item/stack/material/plastic, 6, time = 30),
		list(/obj/item/stack/material/glass, 2, time = 10),
		list(/obj/item/weapon/circuitboard, 1, time = 20),
		list(/obj/item/weapon/stock_parts/subspace/crystal, 1),
		list(/obj/item/weapon/stock_parts/capacitor, 1),
		list(/obj/item/weapon/cell/small, 1),
		list(/obj/item/stack/cable_coil, 5, time = 20)
	)
