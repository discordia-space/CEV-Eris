/*
=========================================================
CWJ STEP_BUILDER COMMANDS:

All steps in the step builder have the following format:
list(<CWJ_STEP_CLASS><_OPTIONAL>, <REQUIRED_ARGS>, <CUSTOM_ARGS>=value)

<CWJ_STEP_CLASS>
	The name any one of the recipe step types, custom or otherwise.
	Valid options are:
		CWJ_ADD_ITEM
			Add an item to the recipe. The object is inserted in the container.
			The product inherits the item's quality and reagents if able.
			<REQUIRED_ARGS>:
				type_path - the type path of the item being added.
			Example: list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice)

		CWJ_ADD_REAGENT
			Add a reagent to the recipe. The resulting reagent is stored in the container's reagent datum.
			The product inherits the reagents added if able. It's possible to sneak poison into food this way.
			<REQUIRED_ARGS>:
				reagent_id - the id of the reagent being added
				amount - The amount of units the ingredient requires
			Example: list(CWJ_ADD_REAGENT, "salt", 5)

		CWJ_ADD_PRODUCE
			Add a grown item to the recipe. The item is inserted in the container.
			The product inherits reagents if able, and its quality scales with the plant's potency.
			<REQUIRED_ARGS>:
				plantname - the NAME of the SEED DATUM of the plant being added.
			Example: list(CWJ_ADD_PRODUCE, "banana")

		CWJ_USE_TOOL
			Uses a tool on the item. Going far and beyond the quality of the tool increases the quality of the product.
			<REQUIRED_ARGS>:
				tool_quality - the id of the reagent being added
				difficulty - The minimum tool quality of the reagent
			Example: list(CWJ_USE_TOOL, QUALITY_CUTTING, 5)

		CWJ_USE_ITEM
			Uses an item on the recipe. The object is not consumed.
			<REQUIRED_ARGS>:
				type_path - the type path of the item being added.
			Example: list(CWJ_USE_ITEM, /obj/item/material/kitchen/rollingpin) #Use a rolling pin on the container

		CWJ_USE_STOVE
			Cook the cooking container on a stove. Keep it on too long, it burns.
			<REQUIRED_ARGS>:
				temperature - the required temperature to cook the food at.
					(Temperatures are macro'd by: J_LO, J_MED, J_HI)
				time - the amount of time, in seconds, to keep the food on the stove.
			Example: list(CWJ_USE_STOVE, J_LO, 40) #Cook on a stove set to "Low" for 40 seconds.

		CWJ_USE_GRILL
			Cook the cooking container on a grill. Keep it on too long, it burns. Eats wood to cook. Wood fire is superior.
			<REQUIRED_ARGS>:
				temperature - the required temperature to cook the food at.
					(Temperatures are macro'd by: J_LO, J_MED, J_HI)
				time - the amount of time, in seconds, to keep the food on the stove.
			Example: list(CWJ_USE_GRILL, J_LO, 40) #Cook on a stove set to "Low" for 40 seconds.

<_OPTIONAL>
	The tag _OPTIONAL can be tacked onto any command to make it an optional step not required to finish the recipe.
	Example: list(CWJ_ADD_ITEM_OPTIONAL, /obj/item/reagent_containers/food/snacks/breadslice)

<REQUIRED_ARGS>
	The required arguments for a specific class of step to function. They are not labeled and must be in order.
	See above for which classes of step have which required arguments.

<CUSTOM_ARGS>
	All custom arguments are declared in the format key=value. They are used to quickly modify a given step in a recipe.

	Example: list(CWJ_ADD_ITEM, /obj/item/reagent_containers/food/snacks/breadslice, desc="a custom description")

	Valid options are:
		desc
			Adds a custom description to the recipe step, when read from a cooking book.
			Example: desc="a custom description"

		base
			Defines the base quality for a recipe step. This will become the LOWEST quality following a step can award.
			For some step classes, this will simply be the default awarded.
			If not defined, there is no minimum quality a step can add.
			Example: base=4

		max
			Defines the maximum quality for a recipe step. This will become the HIGHEST quality following a step can award.
			If not defined, there is no maximum quality a step can add.
			Example: max=10

		prod_desc
			Adds a custom description to the result of the recipe step. This will be read off on the item product.
			Example: prod_desc="A Slice of Bread is in the sandwich."

		exact
			CWJ_ADD_ITEM or CWJ_USE_ITEM ONLY:
			Determines if the steps require an exact type path, or if a child will satisfy the requirements.
			of the type path is also preferable.
			Example: exact=TRUE

		qmod
			CWJ_ADD_ITEM, CWJ_USE_TOOL ONLY:
			modifier to adjust the inherited_quality_modifier on an add_item recipe step.
			Example: qmod=0.5 //only 50% of the added item's quality will be inherited.

		remain_percent
			CWJ_ADD_REAGENT ONLY:
			Determines the percentage of a reagent that remains in the cooking of an item.
			IE- if you cook a steak with wine, you can make it so the wine doesn't wind up in the resulting food.
			Example: remain_percent=0.1 //Only 10% of the units expected to be added will apply to the resulting food injection.

		reagent_skip
			CWJ_ADD_ITEM, CWJ_ADD_PRODUCE ONLY:
			Outright excludes all reagents from the added item/produce from showing up in the product.
			Example: reagent_skip=TRUE

		exclude_reagents
			CWJ_ADD_ITEM, CWJ_ADD_PRODUCE ONLY:
			Excludes the presence of a reagent in an item from the resulting meal.
			Example: exclude_reagents=list("carpotoxin", "blattedin") //Removes the presence of Carpotoxin or blattedin from the item.

=========================================================
*/
