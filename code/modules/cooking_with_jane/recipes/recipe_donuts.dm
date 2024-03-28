/datum/cooking_with_jane/recipe/medialuna //This is 100% a donut but with extra layers
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/medialuna
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 20 SECONDS),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 1)
	)

/datum/cooking_with_jane/recipe/donut
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/donut
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 1, base=1),
		list(CWJ_USE_OVEN, J_LO, 10 SECONDS)
	)

/datum/cooking_with_jane/recipe/jellydonut
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/donut/jelly
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_REAGENT, "berryjuice", 5),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 1, base=1),
		list(CWJ_USE_OVEN, J_LO, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/slime_jellydonut
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/donut/slimejelly
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_REAGENT, "slimejelly", 5),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 1, base=1),
		list(CWJ_USE_OVEN, J_LO, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/cinnamonroll
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/cinnamonroll
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cinnamonpowder", 5),
		list(CWJ_ADD_REAGENT, "sugar", 10),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "egg", 3),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 1, base=1),
		list(CWJ_USE_OVEN, J_LO, 20 SECONDS)
	)
