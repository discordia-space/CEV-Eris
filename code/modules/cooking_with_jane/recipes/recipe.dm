
//Example Recipes
/datum/cooking_with_jane/recipe/steak_stove

	//Name of the recipe. If not defined, it will just use the name of the product_type
	name="Stove-Top cooked Steak"

	//The recipe will be cooked on a pan
	cooking_container = PAN

	//The product of the recipe will be a steak.
	product_type = /obj/item/reagent_containers/food/snacks/meatsteak

	//The product will have it's initial reagents wiped, prior to the recipe adding in reagents of its own.
	replace_reagents = FALSE

	step_builder = list(

		//Butter your pan by adding a slice of butter, and then melting it. Adding the butter unlocks the option to melt it on the stove.
		CWJ_BEGIN_OPTION_CHAIN,
		//base - the lowest amount of quality following this step can award.
		//reagent_skip - Exclude the added item's reagents from being included the product
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/butterslice, base=10),

		//Melt the butter into the pan by cooking it on a stove set to Low for 10 seconds
		list(CWJ_USE_STOVE_OPTIONAL, J_LO, 10 SECONDS),
		CWJ_END_OPTION_CHAIN,

		//A steak is needed to start the meal.
		//qmod- Half of the food quality of the parent will be considered.
		//exclude_reagents- Blattedin and Carpotoxin will be filtered out of the steak. EXCEPT THIS IS ERIS, WE EMBRACE THE ROACH, and has thus been removed from every
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		//Add some mushrooms to give it some zest. Only one kind is allowed!
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_PRODUCE_OPTIONAL, "mushroom", qmod=0.4),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "plumphelmet", qmod=0.4),
		CWJ_END_EXCLUSIVE_OPTIONS,

		//Beat that meat to increase its quality
		list(CWJ_USE_TOOL_OPTIONAL, QUALITY_HAMMERING, 15),

		//You can add up to 3 units of honey to increase the quality. Any more will negatively impact it.
		//base- for CWJ_ADD_REAGENT, the amount that this step will award if followed perfectly.
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 3, base=3),

		//You can add capaicin or wine, but not both
		//prod_desc- A description appended to the resulting product.
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT_OPTIONAL, "capsaicin", 5, base=6, prod_desc="The steak was Spiced with chili powder."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "wine", 5, remain_percent=0.1 ,base=6, prod_desc="The steak was sauteed in wine"),
		CWJ_END_EXCLUSIVE_OPTIONS,

		//Cook on a stove, at medium temperature, for 30 seconds
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

//**Meat and Seafood**//
//Missing: cubancarp, friedchicken, tonkatsu, enchiladas, monkeysdelight, fishandchips, katsudon, fishfingers,
/datum/cooking_with_jane/recipe/donkpocket //Special interactions in recipes_microwave.dm, not sure if this is going to function as expected
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/donkpocket

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_REAGENT, "thermite", 1) //So it cooks inhand, totally.
	)

/datum/cooking_with_jane/recipe/cooked_cutlet
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/cutlet
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/rawcutlet, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/cooked_meatball
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/meatball
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/rawmeatball, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_LO, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/cooked_patty
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/patty
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/patty_raw, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_GRILL, J_LO, 10 SECONDS)
	)

/datum/cooking_with_jane/recipe/chickensteak
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/chickensteak

	replace_reagents = FALSE

	step_builder = list(
		CWJ_BEGIN_OPTION_CHAIN,
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_USE_STOVE_OPTIONAL, J_LO, 10 SECONDS),
		CWJ_END_OPTION_CHAIN,
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chickenbreast, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_PRODUCE_OPTIONAL, "mushroom", qmod=0.4),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "plumphelmet", qmod=0.4),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 3, base=3),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT_OPTIONAL, "capsaicin", 5, base=6, prod_desc="The chicken was Spiced with chili powder."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "lemonjuice", 5, remain_percent=0.1 ,base=3, prod_desc="The chicken was sauteed in lemon juice"),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/porkchops
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/porkchops

	replace_reagents = FALSE

	step_builder = list(
		CWJ_BEGIN_OPTION_CHAIN,
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_USE_STOVE_OPTIONAL, J_LO, 10 SECONDS),
		CWJ_END_OPTION_CHAIN,
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/pork, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_PRODUCE_OPTIONAL, "mushroom", qmod=0.4),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "plumphelmet", qmod=0.4),
		CWJ_END_EXCLUSIVE_OPTIONS,
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT_OPTIONAL, "capsaicin", 5, base=6, prod_desc="The pork was Spiced with chili powder."),
	//	list(CWJ_ADD_REAGENT_OPTIONAL, "pineapplejuice", 5, remain_percent=0.1, base=5, prod_desc="The pork was rosted in pineapple juice."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 5, remain_percent=0.1 ,base=3, prod_desc="The pork was glazed with honey"),
	//	list(CWJ_ADD_REAGENT_OPTIONAL, "bbqsauce", 3, remain_percent=0.5 ,base=8, prod_desc="The pork was layered with BBQ sauce"),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/roastchicken
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/roastchicken
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/chicken, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/stuffing, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/tofurkey //Not quite meat but cooked similar to roast chicken
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/tofurkey
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/stuffing, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/boiled_egg
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/boiledegg
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_REAGENT, "water", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/friedegg_basic
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/friedegg
	step_builder = list(

		CWJ_BEGIN_OPTION_CHAIN,
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_USE_STOVE_OPTIONAL, J_LO, 10 SECONDS),
		CWJ_END_OPTION_CHAIN,

		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_USE_STOVE, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/bacon
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/bacon
	step_builder = list(
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/rawbacon, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 1, base=1),
		list(CWJ_USE_OVEN, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/baconegg
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/baconeggs
	step_builder = list(
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/friedegg, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_USE_OVEN, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/benedict
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/benedict
	step_builder = list(
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_REAGENT, "egg", 3),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 3, base=3),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledegg, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/omelette
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/omelette
	step_builder = list(
		list(CWJ_ADD_REAGENT, "cornoil", 2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 3, base=3),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 10 SECONDS)
	)

/datum/cooking_with_jane/recipe/taco
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/taco
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tortilla),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_PRODUCE, "corn"),
		list(CWJ_ADD_PRODUCE, "cabbage"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cutlet),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/hotdog
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/hotdog
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sausage, qmod=0.5),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/sausage
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/sausage
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/rawmeatball),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/rawbacon),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_USE_GRILL, J_MED, 10 SECONDS)
	)

/datum/cooking_with_jane/recipe/wingfangchu
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/wingfangchu
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/xenomeat, qmod=0.5),
		list(CWJ_ADD_REAGENT, "soysauce", 5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

/datum/cooking_with_jane/recipe/sashimi
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/sashimi
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/carp, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/carp, qmod=0.5),
		list(CWJ_ADD_REAGENT, "soysauce", 5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

/datum/cooking_with_jane/recipe/chawanmushi
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/chawanmushi
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_ADD_REAGENT, "water", 5),
		list(CWJ_ADD_REAGENT, "soysauce", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/kabob
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/kabob
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/stack/rods = 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_USE_GRILL, J_MED, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/tofukabob
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/tofukabob
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/stack/rods = 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_USE_GRILL, J_MED, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/humankabob
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/kabob
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/stack/rods = 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/human, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/human, qmod=0.5),
		list(CWJ_USE_GRILL, J_MED, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/nigiri
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/nigiri
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledrice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/carp, qmod=0.5),
	)

/datum/cooking_with_jane/recipe/makiroll
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/makiroll
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "ambrosia", qmod=0.2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledrice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/carp, qmod=0.5),
		list(CWJ_ADD_REAGENT, "soysauce", 5),
	)

/datum/cooking_with_jane/recipe/maki
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/maki
	product_count = 4
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/makiroll, qmod=0.5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

//**Cereals and Grains**//
//missing: poppyprezel
/datum/cooking_with_jane/recipe/bread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/bread
	recipe_guide = "Put dough in an oven, bake for 30 seconds on medium."
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/meatbread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/meatbread
	recipe_guide = "Put dough in an oven, bake for 30 seconds on medium."
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/xenomeatbread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread
	recipe_guide = "Put dough in an oven, bake for 30 seconds on medium."
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/xenomeat),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/xenomeat),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/tofubread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/tofubread
	recipe_guide = "Put dough in an oven, bake for 30 seconds on medium."
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/creamcheesebread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/creamcheesebread
	recipe_guide = "Put dough in an oven, bake for 30 seconds on medium."
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/bananabread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/bananabread

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_ADD_REAGENT, "milk", 2),
		list(CWJ_ADD_REAGENT, "sugar", 15),
		list(CWJ_ADD_PRODUCE, "banana", 1),
		list(CWJ_USE_OVEN, J_MED, 40 SECONDS)
	)
/datum/cooking_with_jane/recipe/baguette
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/baguette
	step_builder = list(
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/dough, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/cracker
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/cracker
	step_builder = list(
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/bun
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/bun
	product_count = 3
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1),
		list(CWJ_USE_OVEN, J_HI, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/flatbread
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/flatbread
	product_count = 3
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1),
		list(CWJ_USE_OVEN, J_HI, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/twobread
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/twobread
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "wine", 5)
	)

/datum/cooking_with_jane/recipe/pancakes
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/pancakes
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sugar", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 3, base=3),
		list(CWJ_ADD_REAGENT, "milk", 5, base=1),
		list(CWJ_ADD_REAGENT, "flour", 5, base=1),
		list(CWJ_USE_OVEN, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/waffles
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/waffles
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sugar", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 3, base=3),
		list(CWJ_ADD_REAGENT, "milk", 5, base=1),
		list(CWJ_ADD_REAGENT, "flour", 5, base=1),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15),
		list(CWJ_USE_OVEN, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/rofflewaffles
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/rofflewaffles
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/waffles, qmod=0.5),
		list(CWJ_ADD_REAGENT, "psilocybin", 5),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT_OPTIONAL, "pwine", 5, base=6, remain_percent=0.1, prod_desc="The fancy wine soaks up into the fluffy waffles."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "space_drugs", 5, base=6, remain_percent=0.5, prod_desc="The space drugs soak into the waffles."),
	//	list(CWJ_ADD_REAGENT_OPTIONAL, "lean", 5, base=6, remain_percent=0.5, prod_desc="Normally not for breakfast."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "mindbreaker", 5, base=6, remain_percent=0.1, prod_desc="Not for waking up to."),
	//	list(CWJ_ADD_REAGENT_OPTIONAL, "psi_juice", 5, base=6, prod_desc="For when you wake up feeling droggy still."),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_USE_OVEN, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/jelliedtoast
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jelliedtoast/cherry
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cherryjelly", 5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

/datum/cooking_with_jane/recipe/amanitajellytoast
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jelliedtoast/amanita
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/jelly/amanita, qmod=0.5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

/datum/cooking_with_jane/recipe/slimetoast
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jelliedtoast/slime
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "slimejelly", 5),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

/datum/cooking_with_jane/recipe/stuffing
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/food/snacks/stuffing
	product_count = 3
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/bread, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		list(CWJ_ADD_REAGENT, "water", 5),
	)

/datum/cooking_with_jane/recipe/tortilla
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/tortilla
	product_count = 3
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/flatdoughslice),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/flatdoughslice),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/flatdoughslice),
		list(CWJ_USE_OVEN, J_HI, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/muffin
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/muffin
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chocolatebar, qmod=0.5),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/boiledrice
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/boiledrice
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT, "rice", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_HI, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/ricepudding
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/food/snacks/ricepudding
	step_builder = list(
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cream", 10),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledrice, qmod=0.5)
	)

//**Burgers**//
/datum/cooking_with_jane/recipe/burger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/monkeyburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/patty)
	)

/datum/cooking_with_jane/recipe/humanburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/human/burger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/human)
	)

/*/datum/cooking_with_jane/recipe/brainburger //Currently nonfunctional as base body parts do not have food_quality\
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/brainburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/organ/internal/vital/brain)
	)

/datum/cooking_with_jane/recipe/roburger //Currently nonfunctional as base body parts do not have food_quality
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/roburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/robot_parts/head)
	)
*/
/datum/cooking_with_jane/recipe/xenoburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/xenoburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/xenomeat)
	)

/datum/cooking_with_jane/recipe/fishburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/fishburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/carp)
	)

/datum/cooking_with_jane/recipe/tofuburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/tofuburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5), //Adding non-vegan optional to a vegan style dish is hysterical
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5), //Double down
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu)
	)

/*/datum/cooking_with_jane/recipe/clownburger //Currently nonfunctional as clothing do not have food_quality
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/clownburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/clothing/mask/gas/clown_hat)
	)

/datum/cooking_with_jane/recipe/mimeburger //Currently nonfunctional as clothing do not have food_quality
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/mimeburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/clothing/head/beret)
	)
*/
/datum/cooking_with_jane/recipe/bigbiteburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/bigbiteburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/monkeyburger, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/patty, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/patty, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/patty, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledegg, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/superbiteburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/superbiteburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bigbiteburger, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/patty, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledegg, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/jellyburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jellyburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cherryjelly", 5)
	)

/datum/cooking_with_jane/recipe/amanitajellyburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jellyburger/amanita

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/jelly/amanita, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/slimeburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jellyburger/slime

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT, "slimejelly", 5)
	)

//**Sandwiches**//
/datum/cooking_with_jane/recipe/sandwich_basic
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/sandwich
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "cabbage"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cutlet, qmod=0.5, desc="Add any kind of cooked cutlet."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/slimesandwich
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jellysandwich/slime
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "slimejelly", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/cherrysandwich
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jellysandwich/cherry
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cherryjelly", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/amanitajellysandwich
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jellysandwich/amanita
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/jelly/amanita, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/blt
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/blt
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bacon, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "cabbage"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cutlet, qmod=0.5, desc="Add any kind of cooked cutlet."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5)
	)

/datum/cooking_with_jane/recipe/grilledcheese
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/grilledcheese
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, qmod=0.5),
		list(CWJ_USE_GRILL, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/toastedsandwich
	cooking_container = GRILL
	product_type = /obj/item/reagent_containers/food/snacks/toastedsandwich
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sandwich, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_GRILL, J_LO, 15 SECONDS)
	)

//**Erisian Cuisine**//
//Left out due to never having existed previously: Spider burgers, Kraftwerk, Benzin
/datum/cooking_with_jane/recipe/boiled_roach_egg
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/roach_egg
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/roach_egg, qmod=0.5),
		list(CWJ_ADD_REAGENT, "water", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/kampferburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/kampferburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/kampfer)
	)

/datum/cooking_with_jane/recipe/seucheburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/seucheburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche)
	)

/datum/cooking_with_jane/recipe/panzerburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/panzerburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer)
	)

/datum/cooking_with_jane/recipe/jagerburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/jagerburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/jager)
	)

/datum/cooking_with_jane/recipe/bigroachburger //Difference: Requires boiled roach egg
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/bigroachburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/roach_egg),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/kampfer),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/seuche),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/panzer),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/jager)
	)

/datum/cooking_with_jane/recipe/fuhrerburger //Difference: Requires boiled roach egg
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/fuhrerburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/roach_egg),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/fuhrer)
	)

/datum/cooking_with_jane/recipe/kaiserburger //Difference: Requires boiled roach egg
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/kaiserburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/roach_egg),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/roachmeat/kaiser)
	)

/datum/cooking_with_jane/recipe/wormburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/wormburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/moecube/worm)
	)

/datum/cooking_with_jane/recipe/geneburger
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/geneburger

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/bun, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "ketchup", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/moecube)
	)

//**Pastas**//
/datum/cooking_with_jane/recipe/raw_spaghetti
	cooking_container = CUTTING_BOARD
	product_type = /obj/item/reagent_containers/food/snacks/spaghetti
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "flour", 1, base=1),
		list(CWJ_USE_TOOL, QUALITY_CUTTING, 15)
	)

/datum/cooking_with_jane/recipe/boiledspaghetti
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/boiledspaghetti
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/spaghetti, qmod=0.5),
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/pastatomato
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/pastatomato
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledspaghetti, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.4),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.4),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/meatballspaghetti
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/meatballspaghetti
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledspaghetti, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato", qmod=0.4),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/spesslaw
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/spesslaw
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledspaghetti, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato", qmod=0.4),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

//**Pizzas**//
/datum/cooking_with_jane/recipe/pizzamargherita
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "water", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "flour", 5),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.2),
		list(CWJ_USE_OVEN, J_MED, 35 SECONDS)
	)

/datum/cooking_with_jane/recipe/meatpizza
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "water", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "flour", 5),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.2),
		list(CWJ_USE_OVEN, J_MED, 35 SECONDS)
	)

/datum/cooking_with_jane/recipe/mushroompizza
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "water", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "flour", 5),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_USE_OVEN, J_MED, 35 SECONDS)
	)

/datum/cooking_with_jane/recipe/vegetablepizza
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "water", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "flour", 5),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "eggplant", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "cabbage", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "carrot", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_USE_OVEN, J_MED, 35 SECONDS)
	)

//**Pies**//
/datum/cooking_with_jane/recipe/meatpie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/meatpie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/tofupie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/tofupie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/xemeatpie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/xemeatpie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/xenomeat, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/pie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/pie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "banana", qmod=0.2),
		list(CWJ_ADD_REAGENT, "sugar", 5, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/cherrypie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/cherrypie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "cherry", qmod=0.2),
		list(CWJ_ADD_REAGENT, "sugar", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/berryclafoutis
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/berryclafoutis
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "berries", qmod=0.2),
		list(CWJ_ADD_REAGENT, "sugar", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/amanita_pie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/amanita_pie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_REAGENT, "amatoxin", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/plump_pie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/plump_pie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "plumphelmet", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/pumpkinpie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/pumpkinpie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "pumpkin", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/applepie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/applepie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "apple", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

//**Salads**//
/datum/cooking_with_jane/recipe/tossedsalad
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/food/snacks/tossedsalad
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "cabbage", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "cabbage", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "carrot", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "apple", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/stuffing, base=10),
		list(CWJ_ADD_PRODUCE, "tomato", qmod=0.2),
	)

/datum/cooking_with_jane/recipe/aesirsalad
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/food/snacks/aesirsalad
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "ambrosiadeus", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/stuffing, base=10),
		list(CWJ_ADD_PRODUCE, "goldapple", qmod=0.2),
	)

/datum/cooking_with_jane/recipe/validsalad
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/food/snacks/validsalad
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "ambrosia", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "ambrosia", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "ambrosia", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/stuffing, base=5),
		list(CWJ_ADD_PRODUCE, "potato", qmod=0.2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
	)
//**Soups**// Possibly replaced by Handyman's Soup project, which'll be based on cauldron soup kitchen aesthetic
/datum/cooking_with_jane/recipe/tomatosoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/tomatosoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_REAGENT_OPTIONAL, "cream", 5, base=3, prod_desc="The soup turns a lighter red and thickens with the cream."),
		list(CWJ_ADD_REAGENT_OPTIONAL, "honey", 5 ,base=5, prod_desc="The thickens as the honey mixes in."),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/meatballsoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/meatballsoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meatball, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "carrot"),
		list(CWJ_ADD_PRODUCE, "potato"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/vegetablesoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/vegetablesoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "carrot"),
		list(CWJ_ADD_PRODUCE, "potato"),
		list(CWJ_ADD_PRODUCE, "eggplant"),
		list(CWJ_ADD_PRODUCE, "cabbage"),
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/nettlesoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/nettlesoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "potato"),
		list(CWJ_ADD_PRODUCE, "nettle"),
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/wishsoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/wishsoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 20),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/coldchili
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/coldchili
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "icechili"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/hotchili
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/coldchili
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "chili"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/bearchili
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/bearchili
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "chili"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat/bearmeat, qmod=0.5),
		list(CWJ_USE_STOVE, J_LO, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/stew
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/stew
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "carrot"),
		list(CWJ_ADD_PRODUCE, "potato"),
		list(CWJ_ADD_PRODUCE, "mushroom"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/milosoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/milosoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/soydope, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/soydope, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/beetsoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/beetsoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_PRODUCE, "whitebeet"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "potato"),
		list(CWJ_ADD_PRODUCE, "cabbage"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cream", 5, base=1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "blackpepper", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/mushroomsoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/mushroomsoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_REAGENT, "cream", 5),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "sodiumchloride", 1),
		list(CWJ_ADD_REAGENT, "blackpepper", 1),
		list(CWJ_ADD_PRODUCE, "mushroom", qmod=0.2),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_PRODUCE_OPTIONAL, "mushroom", qmod=0.4),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "plumphelmet", qmod=0.4),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/mysterysoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/mysterysoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/badrecipe, qmod=0.5),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/tofu, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_USE_STOVE, J_MED, 20 SECONDS)
	)

/datum/cooking_with_jane/recipe/bloodsoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/bloodsoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "blood", 30),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/slimesoup
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/slimesoup
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT, "slimejelly", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/beefcurry
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/beefcurry

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_USE_STOVE, J_LO, 10 SECONDS),
		list(CWJ_ADD_REAGENT, "flour", 5),
		list(CWJ_ADD_REAGENT, "soysauce", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledrice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/meat, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "chili"),
		list(CWJ_ADD_PRODUCE, "carrot"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_USE_STOVE, J_MED, 40 SECONDS)
	)

/datum/cooking_with_jane/recipe/chickencurry
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/chickencurry

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_USE_STOVE, J_LO, 10 SECONDS),
		list(CWJ_ADD_REAGENT, "flour", 5),
		list(CWJ_ADD_REAGENT, "soysauce", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/boiledrice, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chickenbreast, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "chili"),
		list(CWJ_ADD_PRODUCE, "carrot"),
		list(CWJ_ADD_PRODUCE, "tomato"),
		list(CWJ_USE_STOVE, J_MED, 40 SECONDS)
	)

//**Vegetables**//
//missing: soylenviridians, soylentgreen
/datum/cooking_with_jane/recipe/mashpotato
	cooking_container = BOWL
	product_type = /obj/item/reagent_containers/food/snacks/mashpotatoes

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_PRODUCE, "potato", 2),
		list(CWJ_ADD_REAGENT, "milk", 2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_USE_TOOL, QUALITY_HAMMERING, 15)
	)

/datum/cooking_with_jane/recipe/loadedbakedpotato
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/loadedbakedpotato

	replace_reagents = FALSE

	step_builder = list(
		list(CWJ_ADD_PRODUCE, "potato", 1),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/butterslice, base=10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/fries
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/fries
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/rawsticks),
		list(CWJ_ADD_REAGENT, "cornoil", 1),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1),
		list(CWJ_USE_STOVE, J_HI, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/cheesyfries
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/cheesyfries
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/fries),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge),
		list(CWJ_USE_STOVE, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/eggplantparm
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/eggplantparm
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "eggplant"),
		list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/butterslice, base=3),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		CWJ_BEGIN_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_PRODUCE_OPTIONAL, "mushroom", qmod=0.4),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "plumphelmet", qmod=0.4),
		CWJ_END_EXCLUSIVE_OPTIONS,
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_USE_STOVE, J_HI, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/stewedsoymeat
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/stewedsoymeat
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/soydope, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/soydope, qmod=0.5),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "carrot"),
		list(CWJ_ADD_PRODUCE_OPTIONAL, "tomato"),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_HI, 15 SECONDS)
	)

//**Cakes**//
/datum/cooking_with_jane/recipe/plaincake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/plaincake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/butterstick, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sugar", 15),
		list(CWJ_ADD_REAGENT, "flour", 15),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "egg", 9),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/carrotcake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/carrotcake
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "carrot", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "carrot", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "carrot", qmod=0.2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/cheesecake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/cheesecake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/cheesewedge, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/orangecake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/orangecake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "orange", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/limecake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/limecake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "lime", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/lemoncake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/lemoncake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "lemon", qmod=0.2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/chocolatecake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/chocolatecake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chocolatebar, qmod=0.5),
		list(CWJ_ADD_REAGENT, "coco", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/applecake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/applecake
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "apple", qmod=0.2),
		list(CWJ_ADD_PRODUCE, "apple", qmod=0.2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 1, base=1),
		list(CWJ_USE_STOVE, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/birthdaycake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/birthdaycake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/clothing/head/cakehat, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/braincake
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/braincake
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/plaincake, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/organ/internal/vital/brain, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/butterstick, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

/datum/cooking_with_jane/recipe/brownies
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/sliceable/brownie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/butterstick, qmod=0.5),
		list(CWJ_ADD_REAGENT, "sugar", 15),
		list(CWJ_ADD_REAGENT, "coco", 10),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "egg", 9),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chocolatebar, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "woodpulp", 5),
		list(CWJ_USE_OVEN, J_MED, 30 SECONDS)
	)

//**Desserts and Sweets**//
//missing: fortunecookie, honey_bun, honey_pudding
//Changes: Now a chemical reaction: candy_corn, mint,
/datum/cooking_with_jane/recipe/chocolateegg
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/chocolateegg
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/egg, qmod=0.5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chocolatebar, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sugar", 5),
		list(CWJ_USE_STOVE, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/candiedapple
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/candiedapple
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "apple", qmod=0.2),
		list(CWJ_ADD_REAGENT, "water", 5),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 1, base=1),
		list(CWJ_USE_STOVE, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/cookie
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/cookie
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_REAGENT_OPTIONAL, "cornoil", 2),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/doughslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/chocolatebar, qmod=0.5),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

/datum/cooking_with_jane/recipe/appletart
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/appletart
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "goldapple", qmod=0.2),
		list(CWJ_ADD_REAGENT, "sugar", 5),
		list(CWJ_ADD_REAGENT, "milk", 5),
		list(CWJ_ADD_REAGENT, "flour", 10),
		list(CWJ_ADD_REAGENT, "egg", 3),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/plumphelmetbiscuit
	cooking_container = OVEN
	product_type = /obj/item/reagent_containers/food/snacks/plumphelmetbiscuit
	step_builder = list(
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/sliceable/flatdough, qmod=0.5),
		list(CWJ_ADD_PRODUCE, "plumphelmet", qmod=0.2),
		list(CWJ_ADD_REAGENT, "water", 5),
		list(CWJ_ADD_REAGENT, "flour", 5),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_USE_OVEN, J_LO, 15 SECONDS)
	)

/datum/cooking_with_jane/recipe/popcorn
	cooking_container = PAN
	product_type = /obj/item/reagent_containers/food/snacks/popcorn
	step_builder = list(
		list(CWJ_ADD_PRODUCE, "corn"),
		list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/butterslice, qmod=0.5),
		list(CWJ_ADD_REAGENT, "cornoil", 2),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_USE_STOVE, J_LO, 5 SECONDS)
	)

//UNSORTED
//missing: spacylibertyduff
/datum/cooking_with_jane/recipe/boiledslimeextract
	cooking_container = POT
	product_type = /obj/item/reagent_containers/food/snacks/boiledslimecore
	step_builder = list(
		list(CWJ_ADD_REAGENT, "water", 10),
		list(CWJ_ADD_REAGENT_OPTIONAL, "sodiumchloride", 1, base=1),
		list(CWJ_ADD_ITEM, /obj/item/slime_extract, qmod=0.5),
		list(CWJ_USE_STOVE, J_HI, 15 SECONDS)
	)
