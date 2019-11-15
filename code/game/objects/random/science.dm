/obj/random/science
	name = "random scientific item"
	icon_state = "box-green"

/obj/random/science/item_to_spawn()
	return pickweight(list(
	/obj/item/device/science_tool = 8,
	/obj/item/device/scanner/reagent = 6,
	/obj/item/weapon/computer_hardware/scanner/reagent = 3,
	/obj/item/weapon/reagent_containers/dropper = 2,
	/obj/item/weapon/reagent_containers/glass/beaker/vial = 3,
	/obj/item/weapon/reagent_containers/glass/beaker/vial/random = 2,
	/obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin = 2,
	/obj/item/weapon/reagent_containers/glass/beaker/vial/nanites = 2,
	/obj/item/weapon/stock_parts/scanning_module/adv = 3,
	/obj/item/weapon/stock_parts/manipulator/nano = 3,
	/obj/item/weapon/stock_parts/matter_bin/adv = 2,
	/obj/item/weapon/stock_parts/micro_laser/high = 2,
	/obj/item/weapon/computer_hardware/hard_drive/portable/research_points = 5,
	/obj/item/weapon/computer_hardware/hard_drive/portable/research_points/rare = 1,
	/obj/item/weapon/rig/hazmat = 2,
	/obj/item/weapon/rig/hazmat/equipped = 1
	))

/obj/random/science/low_chance
	name = "low chance random scientific item"
	icon_state = "box-green-low"
	spawn_nothing_percentage = 80

