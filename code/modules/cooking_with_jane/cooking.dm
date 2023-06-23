

/*
COOKING WITH JANE - A comprehensive cooking rework.

The recipe datum outlines a list of steps from getting a piece of food from point A to point B.
Recipes have steps that are held in a modular linked list, holding required steps, and optional ones to increase the total quality of the food.
Following a recipe incorrectly (IE, adding too much of an item, having the burner too hot, etc.) Will decrease the quality of the food.area

Recipes have clear start and end points. They start with a particular item and end with a particular item.

That said, a start item can follow multiple recipes until they eventually diverge as different steps are followed.

In the case two recipes have identical steps, the user should be prompted on what their intended result should be. (Donuts vs Bagels)

Recipes are loaded at startup. Food items reference it by the recipe_tracker datum

By following the steps correctly, good food can be made.

Food quality is calculated based on the steps taken.

*/

/datum/cooking_with_jane/recipe
	var/unique_id
	var/name				//Name for the cooking guide. Auto-populates if not set.
	var/description			//Description for the cooking guide. Auto-populates if not set.
	var/recipe_guide		//Step by step recipe guide. I hate it.
	var/recipe_icon			//Icon for the cooking guide. Auto-populates if not set.
	var/recipe_icon_state	//Icon state for the cooking guide. Auto-populates if not set.

	//The Cooking container the recipe is performed in.
	var/cooking_container = null

	var/product_type //Type path for the product created by the recipe. An item of this type should ALSO have a recipe_tracker Datum.
	var/product_name
	var/product_count = 1 //how much of a thing is made per case of the recipe being followed.

	//Special variables that must be defined INSTEAD of product_type in order to create reagents instead of an object.
	var/reagent_id
	var/reagent_amount
	var/reagent_name
	var/reagent_desc

	var/icon_image_file

	var/quality_description //A decorator description tacked onto items when the recipe is completed. Used in future recipes. "The Bread looks Handmade."

	var/exclusive_option_mode = FALSE //triggers whether two steps in a process are exclusive- IE: you can do one or the other, but not both.

	var/list/active_exclusive_option_list = list() //Only needed during the creation process for tracking a given exclusive option dictionary.

	var/option_chain_mode = 0 //triggers whether two steps in a process are exclusive- IE: you can do one or the other, but not both.

	var/active_exclusive_option_chain //Only needed during the creation process for tracking items in an option chain.

	var/replace_reagents = FALSE //Determines if we entirely replace the contents of the food product with the slurry that goes into it.

	var/appear_in_default_catalog = TRUE //Everything appears in the catalog by default
	/*
		The Step Builder is iterated through to create new steps in the recipe dynamically.
		_OPTIONAL steps are linked to the previously made REQUIRED step
		CWJ_BEGIN steps must eventually terminate in a matching CWJ_END step
	*/
	var/list/step_builder = null

	var/datum/cooking_with_jane/recipe_step/first_step //The first step in the linked list that will result in the final recipe

	var/datum/cooking_with_jane/recipe_step/last_required_step //Reference to the last required step in the cooking process.

	var/datum/cooking_with_jane/recipe_step/last_created_step //Reference to the last step made, regardless of if it was required or not.

/datum/cooking_with_jane/recipe/New()

	if(reagent_id && !reagent_amount)
		CRASH("/datum/cooking_with_jane/recipe/New: Reagent creating recipe must have reagent_amount defined! Recipe path=[src.type].")

	build_steps()

	if(ispath(product_type))
		var/obj/item/product_info = new product_type()
		product_name = product_info.name
		if(!name)
			name = product_info.name

		if(!description)
			description = product_info.desc

		QDEL_NULL(product_info) //We don't need this anymore.

	if(reagent_id)
		var/datum/reagent/test_reagent = GLOB.chemical_reagents_list[reagent_id]
		if(test_reagent)
			if(!name)
				name = test_reagent.name
			if(!description)
				description = test_reagent.description

			reagent_name = test_reagent.name
			reagent_desc = test_reagent.description

	if(!name)
		name = "NO NAME!"

	unique_id = sequential_id("recipe")

//Build out the recipe steps for a recipe, based on the step_builder list
/datum/cooking_with_jane/recipe/proc/build_steps()
	if(!step_builder)
		CRASH("/datum/cooking_with_jane/recipe/build_steps: Recipe has no step builder defined! Recipe path=[src.type].")

	if(!cooking_container)
		CRASH("/datum/cooking_with_jane/recipe/build_steps: Recipe has no cooking container defined! Recipe path=[src.type].")

	//Create a base step
	create_step_base()

	for (var/step in step_builder)
		if(islist(step))
			var/list/step_list = step
			var/reason = ""
			switch(step_list[1])
				if(CWJ_ADD_ITEM)
					if(step_list.len < 2)
						reason="Bad argument Length for CWJ_ADD_ITEM"
					else if(!ispath(step_list[2]))
						reason="Bad argument type for CWJ_ADD_ITEM at arg 2"
					else
						create_step_add_item(step_list[2], FALSE)
				if(CWJ_ADD_ITEM_OPTIONAL)
					if(step_list.len < 2)
						reason="Bad argument Length for CWJ_ADD_ITEM_OPTIONAL"
					else if(!ispath(step_list[2]))
						reason="Bad argument type for CWJ_ADD_ITEM_OPTIONAL at arg 2"
					else
						create_step_add_item(step_list[2], TRUE)
				if(CWJ_ADD_REAGENT)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_ADD_REAGENT"
					else if(!is_reagent_with_id_exist(step_list[2]))
						reason="Bad reagent type for CWJ_ADD_REAGENT at arg 2"
					else
						create_step_add_reagent(step_list[2], step_list[3], FALSE)
				if(CWJ_ADD_REAGENT_OPTIONAL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_ADD_REAGENT_OPTIONAL"
					else if(!is_reagent_with_id_exist(step_list[2]))
						reason="Bad reagent type for CWJ_ADD_REAGENT_OPTIONAL at arg 2"
					else
						create_step_add_reagent(step_list[2], step_list[3], TRUE)
				if(CWJ_USE_ITEM)
					if(step_list.len < 2)
						reason="Bad argument Length for CWJ_USE_ITEM"
					else if(!ispath(step_list[2]))
						reason="Bad argument type for CWJ_USE_ITEM at arg 2"
					else
						create_step_use_item(step_list[2], FALSE)
				if(CWJ_USE_ITEM_OPTIONAL)
					if(step_list.len < 2)
						reason="Bad argument Length for CWJ_USE_ITEM_OPTIONAL"
					else if(!ispath(step_list[2]))
						reason="Bad argument type for CWJ_USE_ITEM_OPTIONAL at arg 2"
					else
						create_step_use_item(step_list[2], TRUE)
				if(CWJ_ADD_PRODUCE)
					if(step_list.len < 2)
						reason="Bad argument Length for CWJ_ADD_PRODUCE"
					else
						create_step_add_produce(step_list[2], FALSE)
				if(CWJ_ADD_PRODUCE_OPTIONAL)
					if(step_list.len < 2)
						reason="Bad argument Length for CWJ_ADD_PRODUCE_OPTIONAL"
					else
						create_step_add_produce(step_list[2], TRUE)
				if(CWJ_USE_TOOL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_TOOL"
					else
						create_step_use_tool(step_list[2], step_list[3], FALSE)
				if(CWJ_USE_TOOL_OPTIONAL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_TOOL_OPTIONAL"
					else
						create_step_use_tool(step_list[2], step_list[3], TRUE)
				if(CWJ_USE_STOVE)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_STOVE"
					switch(step_list[2])
						if(J_LO)
							if(step_list[3] > CWJ_BURN_TIME_LOW)
								reason="Time too large for Low setting on CWJ_USE_STOVE; Food will automatically burn."

						if(J_MED)
							if(step_list[3] > CWJ_BURN_TIME_MEDIUM)
								reason="Time too large for Medium setting on CWJ_USE_STOVE; Food will automatically burn."

						if(J_HI)
							if(step_list[3] > CWJ_BURN_TIME_HIGH)
								reason="Time too large for High setting on CWJ_USE_STOVE; Food will automatically burn."

						else
							reason="Unrecognized temperature for CWJ_USE_STOVE"

					if(!reason)
						create_step_use_stove(step_list[2], step_list[3], FALSE)
				if(CWJ_USE_STOVE_OPTIONAL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_STOVE_OPTIONAL"
					switch(step_list[2])
						if(J_LO)
							if(step_list[3] > CWJ_BURN_TIME_LOW)
								reason="Time too large for Low setting on CWJ_USE_STOVE_OPTIONAL; Food will automatically burn."

						if(J_MED)
							if(step_list[3] > CWJ_BURN_TIME_MEDIUM)
								reason="Time too large for Medium setting on CWJ_USE_STOVE_OPTIONAL; Food will automatically burn."

						if(J_HI)
							if(step_list[3] > CWJ_BURN_TIME_HIGH)
								reason="Time too large for High setting on CWJ_USE_STOVE_OPTIONAL; Food will automatically burn."
						else
							reason="Unrecognized temperature for CWJ_USE_STOVE_OPTIONAL"
					if(!reason)
						create_step_use_stove(step_list[2], step_list[3], TRUE)

				if(CWJ_USE_GRILL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_GRILL"
					switch(step_list[2])
						if(J_LO)
							if(step_list[3] > CWJ_BURN_TIME_LOW)
								reason="Time too large for Low setting on CWJ_USE_GRILL; Food will automatically burn."

						if(J_MED)
							if(step_list[3] > CWJ_BURN_TIME_MEDIUM)
								reason="Time too large for Medium setting on CWJ_USE_GRILL; Food will automatically burn."

						if(J_HI)
							if(step_list[3] > CWJ_BURN_TIME_HIGH)
								reason="Time too large for High setting on CWJ_USE_GRILL; Food will automatically burn."

						else
							reason="Unrecognized temperature for CWJ_USE_GRILL"

					if(!reason)
						create_step_use_grill(step_list[2], step_list[3], FALSE)

				if(CWJ_USE_GRILL_OPTIONAL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_GRILL_OPTIONAL"
					switch(step_list[2])
						if(J_LO)
							if(step_list[3] > CWJ_BURN_TIME_LOW)
								reason="Time too large for Low setting on CWJ_USE_GRILL_OPTIONAL; Food will automatically burn."

						if(J_MED)
							if(step_list[3] > CWJ_BURN_TIME_MEDIUM)
								reason="Time too large for Medium setting on CWJ_USE_GRILL_OPTIONAL; Food will automatically burn."

						if(J_HI)
							if(step_list[3] > CWJ_BURN_TIME_HIGH)
								reason="Time too large for High setting on CWJ_USE_GRILL_OPTIONAL; Food will automatically burn."
						else
							reason="Unrecognized temperature for CWJ_USE_GRILL_OPTIONAL"
					if(!reason)
						create_step_use_grill(step_list[2], step_list[3], TRUE)
				if(CWJ_USE_OVEN)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_OVEN"
					switch(step_list[2])
						if(J_LO)
							if(step_list[3] > CWJ_BURN_TIME_LOW)
								reason="Time too large for Low setting on CWJ_USE_OVEN; Food will automatically burn."

						if(J_MED)
							if(step_list[3] > CWJ_BURN_TIME_MEDIUM)
								reason="Time too large for Medium setting on CWJ_USE_OVEN; Food will automatically burn."

						if(J_HI)
							if(step_list[3] > CWJ_BURN_TIME_HIGH)
								reason="Time too large for High setting on CWJ_USE_OVEN; Food will automatically burn."

						else
							reason="Unrecognized temperature for CWJ_USE_OVEN"

					if(!reason)
						create_step_use_oven(step_list[2], step_list[3], FALSE)
				if(CWJ_USE_OVEN_OPTIONAL)
					if(step_list.len < 3)
						reason="Bad argument Length for CWJ_USE_OVEN_OPTIONAL"
					switch(step_list[2])
						if(J_LO)
							if(step_list[3] > CWJ_BURN_TIME_LOW)
								reason="Time too large for Low setting on CWJ_USE_OVEN_OPTIONAL; Food will automatically burn."

						if(J_MED)
							if(step_list[3] > CWJ_BURN_TIME_MEDIUM)
								reason="Time too large for Medium setting on CWJ_USE_OVEN_OPTIONAL; Food will automatically burn."

						if(J_HI)
							if(step_list[3] > CWJ_BURN_TIME_HIGH)
								reason="Time too large for High setting on CWJ_USE_OVEN_OPTIONAL; Food will automatically burn."
						else
							reason="Unrecognized temperature for CWJ_USE_OVEN_OPTIONAL"
					if(!reason)
						create_step_use_oven(step_list[2], step_list[3], TRUE)

			//Named Arguments modify the recipe in fixed ways
			if("desc" in step_list)
				set_step_desc(step_list["desc"])

			if("base" in step_list)
				set_step_base_quality(step_list["base"])

			if("max" in step_list)
				set_step_max_quality(step_list["max"])

			if("prod_desc" in step_list)
				set_step_custom_result_desc(step_list["prod_desc"])

			if("qmod" in step_list)
				if(!set_inherited_quality_modifier(step_list["qmod"]))
					reason="qmod / inherited_quality_modifier declared on non add-item recipe step."

			if("remain_percent" in step_list)
				if(step_list["remain_percent"] > 1 || step_list["remain_percent"] < 0)
					reason="remain_percent must be between 1 and 0."
				else if(!set_remain_percent_modifier(step_list["remain_percent"]))
					reason="remain_percent / declared on non add-reagent recipe step."

			if("exact" in step_list)
				if(!set_exact_type_required(step_list["exact"]))
					reason="exact / exact type match declared on non add-item / use-item recipe step."

			if("reagent_skip" in step_list)
				if(!set_reagent_skip(step_list["reagent_skip"]))
					reason="reagent_skip / reagent_skip declared on non add-item / add-reagent recipe step."

			if("exclude_reagents" in step_list)
				for(var/id in step_list["exclude_reagents"])
					if(!is_reagent_with_id_exist(id))
						reason="exclude_reagents list has nonexistant reagent id [id]"

				if(!set_exclude_reagents(step_list["exclude_reagents"]))
					reason="exclude_reagents declared on non add-item / add-reagent recipe step."

			if(reason)
				CRASH("[src.type]/New: CWJ Step Builder failed. Reason: [reason]")

			propagate_step_description()
		else
			switch(step)
				if(CWJ_BEGIN_EXCLUSIVE_OPTIONS)
					begin_exclusive_options()
				if(CWJ_END_EXCLUSIVE_OPTIONS)
					end_exclusive_options()
				if(CWJ_BEGIN_OPTION_CHAIN)
					begin_option_chain()
				if(CWJ_END_OPTION_CHAIN)
					end_option_chain()

	if(exclusive_option_mode)
		CRASH("/datum/cooking_with_jane/recipe/New: Exclusive option active at end of recipe creation process. Recipe name=[name].")

	if(option_chain_mode)
		CRASH("/datum/cooking_with_jane/recipe/New: Option Chain active at end of recipe creation process. Recipe name=[name].")

	if(last_created_step.flags & CWJ_IS_OPTIONAL)
		CRASH("/datum/cooking_with_jane/recipe/New: Last option in builder is optional. It must be a required step! Recipe name=[name].")

//Adds to the recipe description for every step of the recipe
/datum/cooking_with_jane/recipe/proc/propagate_step_description()
	var/qualifier = "> "
	if(last_created_step.flags & CWJ_IS_OPTIONAL)
		qualifier = ">> (Optional) "
	if(last_created_step.flags & CWJ_IS_OPTION_CHAIN)
		qualifier = ">> (Option Chain) "
	if(last_created_step.flags & CWJ_IS_EXCLUSIVE)
		qualifier = ">> (Exclusive Option) "
	recipe_guide +="<br>[qualifier][last_created_step.desc]"

//-----------------------------------------------------------------------------------
//Commands for interacting with the recipe tracker
//-----------------------------------------------------------------------------------
//Add base step command. All other steps stem from this. Don't call twice!
/datum/cooking_with_jane/recipe/proc/create_step_base()
	var/datum/cooking_with_jane/recipe_step/start/step = new /datum/cooking_with_jane/recipe_step/start(cooking_container)
	last_required_step = step
	last_created_step = step
	first_step = step

//-----------------------------------------------------------------------------------
//Add reagent step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_add_reagent(var/reagent_id, var/amount, var/optional)
	var/datum/cooking_with_jane/recipe_step/add_reagent/step = new (reagent_id, amount, src)
	return src.add_step(step, optional)

//-----------------------------------------------------------------------------------
//Add item step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_add_item(var/item_type, var/optional)
	var/datum/cooking_with_jane/recipe_step/add_item/step = new (item_type, src)
	return src.add_step(step, optional)
//-----------------------------------------------------------------------------------
//Use item step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_use_item(var/item_type, var/optional)
	var/datum/cooking_with_jane/recipe_step/use_item/step = new (item_type, src)
	return src.add_step(step, optional)

//-----------------------------------------------------------------------------------
//Use item step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_add_produce(var/produce, var/optional)
	var/datum/cooking_with_jane/recipe_step/add_produce/step = new /datum/cooking_with_jane/recipe_step/add_produce(produce, src)
	return src.add_step(step, optional)
//-----------------------------------------------------------------------------------
//Use Tool step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_use_tool(var/type, var/quality, var/optional)
	var/datum/cooking_with_jane/recipe_step/use_tool/step = new (type, quality, src)
	return src.add_step(step, optional)

//-----------------------------------------------------------------------------------
//Use Stove step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_use_stove(var/heat, var/time, var/optional)
	var/datum/cooking_with_jane/recipe_step/use_stove/step = new (heat, time, src)
	return src.add_step(step, optional)
//-----------------------------------------------------------------------------------
//Use Grill step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_use_grill(var/heat, var/time, var/optional)
	var/datum/cooking_with_jane/recipe_step/use_grill/step = new (heat, time, src)
	return src.add_step(step, optional)
//-----------------------------------------------------------------------------------
//Use Stove step shortcut commands
/datum/cooking_with_jane/recipe/proc/create_step_use_oven(var/heat, var/time, var/optional)
	var/datum/cooking_with_jane/recipe_step/use_oven/step = new (heat, time, src)
	return src.add_step(step, optional)
//-----------------------------------------------------------------------------------
//Customize the last step created
/datum/cooking_with_jane/recipe/proc/set_step_desc(var/new_description)
	last_created_step.desc = new_description

/datum/cooking_with_jane/recipe/proc/set_step_max_quality(var/quality)
	last_created_step.flags |= CWJ_BASE_QUALITY_ENABLED
	last_created_step.max_quality_award = quality

/datum/cooking_with_jane/recipe/proc/set_step_base_quality(var/quality)
	last_created_step.flags |= CWJ_MAX_QUALITY_ENABLED
	last_created_step.base_quality_award = quality

/datum/cooking_with_jane/recipe/proc/set_step_custom_result_desc(var/new_description)
	last_created_step.custom_result_desc = new_description


/datum/cooking_with_jane/recipe/proc/set_exact_type_required(var/boolean)
	if((last_created_step.class == CWJ_ADD_ITEM) || (last_created_step.class == CWJ_USE_ITEM))
		last_created_step?:exact_path = boolean
		return TRUE
	else
		return FALSE

/datum/cooking_with_jane/recipe/proc/set_reagent_skip(var/boolean)
	if((last_created_step.class == CWJ_ADD_ITEM) || (last_created_step.class == CWJ_ADD_PRODUCE))
		last_created_step?:reagent_skip = boolean
		return TRUE
	else
		return FALSE

/datum/cooking_with_jane/recipe/proc/set_exclude_reagents(var/list/exclude_list)
	if((last_created_step.class == CWJ_ADD_ITEM) || (last_created_step.class == CWJ_ADD_PRODUCE))
		last_created_step?:exclude_reagents = exclude_list
		return TRUE
	else
		return FALSE

/datum/cooking_with_jane/recipe/proc/set_inherited_quality_modifier(var/modifier)
	if(last_created_step.class == CWJ_ADD_ITEM || last_created_step.class == CWJ_USE_TOOL || last_created_step.class == CWJ_ADD_PRODUCE)
		last_created_step?:inherited_quality_modifier = modifier
		return TRUE
	else
		return FALSE

/datum/cooking_with_jane/recipe/proc/set_remain_percent_modifier(var/modifier)
	if(last_created_step.class == CWJ_ADD_REAGENT)
		last_created_step?:remain_percent = modifier
		return TRUE
	else
		return FALSE

//-----------------------------------------------------------------------------------
//Setup for two options being exclusive to eachother.
//Performs a lot of internal checking to make sure that it doesn't break everything.
//If begin_exclusive_options is called, end_exclusive_options must eventually be called in order to close out and proceed to the next required step.

/datum/cooking_with_jane/recipe/proc/begin_exclusive_options()
	if(exclusive_option_mode)
		#ifdef CWJ_DEBUG
		log_debug("/datum/cooking_with_jane/recipe/proc/begin_exclusive_options: Exclusive option already active.")
		log_debug("Recipe name=[name].")
		#endif
		return
	else if(!first_step)
		CRASH("/datum/cooking_with_jane/recipe/proc/begin_exclusive_options: Exclusive list cannot be active before the first required step is defined. Recipe name=[src.type].")
	exclusive_option_mode = TRUE
	active_exclusive_option_list = list()

/datum/cooking_with_jane/recipe/proc/end_exclusive_options()
	if(!exclusive_option_mode)
		#ifdef CWJ_DEBUG
		log_debug("/datum/cooking_with_jane/recipe/proc/end_exclusive_options: Exclusive option already inactive.")
		log_debug("Recipe name=[name].")
		#endif
		return
	else if(active_exclusive_option_list.len == 0)
		CRASH("/datum/cooking_with_jane/recipe/proc/end_exclusive_options: Exclusive option list ended with no values added. Recipe name=[src.type].")
	else if(option_chain_mode)
		CRASH("/datum/cooking_with_jane/recipe/proc/end_exclusive_options: Exclusive option cannot end while option chain is active. Recipe name=[src.type].")

	exclusive_option_mode = FALSE

	//Flatten exclusive options into the global list for easy referencing later.
	//initiate the exclusive option list
	for (var/datum/cooking_with_jane/recipe_step/exclusive_option in active_exclusive_option_list)
		if (!GLOB.cwj_optional_step_exclusion_dictionary["[exclusive_option.unique_id]"])
			GLOB.cwj_optional_step_exclusion_dictionary["[exclusive_option.unique_id]"] = list()
	//populate the exclusive option list
	for (var/datum/cooking_with_jane/recipe_step/exclusive_option in active_exclusive_option_list)
		for (var/datum/cooking_with_jane/recipe_step/excluder in active_exclusive_option_list["[exclusive_option]"])
			if (exclusive_option.unique_id != excluder.unique_id)
				GLOB.cwj_optional_step_exclusion_dictionary["[exclusive_option.unique_id]"] = excluder.unique_id

	active_exclusive_option_list = null

//-----------------------------------------------------------------------------------
//Setup for a chain of optional steps to be added that order themselves sequentially.
//Optional steps with branching paths is NOT supported.
//If begin_option_chain is called, end_option_chain must eventually be called in order to close out and proceed to the next required step.
/datum/cooking_with_jane/recipe/proc/begin_option_chain()
	if(option_chain_mode)
		#ifdef CWJ_DEBUG
		log_debug("/datum/cooking_with_jane/recipe/proc/begin_option_chain: Option Chain already active.")
		log_debug("Recipe name=[name].")
		#endif
		return
	if(!first_step)
		CRASH("/datum/cooking_with_jane/recipe/proc/begin_option_chain: Option Chain cannot be active before first required step is defined. Recipe name=[name].")
	option_chain_mode =1

/datum/cooking_with_jane/recipe/proc/end_option_chain()
	if(!option_chain_mode)
		#ifdef CWJ_DEBUG
		log_debug("/datum/cooking_with_jane/recipe/proc/end_option_chain: Option Chain already inactive.")
		log_debug("Recipe name=[name].")
		#endif
		return
	last_created_step.next_step = last_required_step
	option_chain_mode = 0


//-----------------------------------------------------------------------------------
//Function that dynamically adds a step into a given recipe matrix.
/datum/cooking_with_jane/recipe/proc/add_step(var/datum/cooking_with_jane/recipe_step/step, var/optional)

	//Required steps can't have exclusive options.
	//If a given recipe needs to split into two branching required steps, it should be split into two different recipes.
	if(!optional && exclusive_option_mode)
		CRASH("/datum/cooking_with_jane/recipe/proc/add_step: Required step added while exclusive option mode is on. Recipe name=[name].")

	if(!optional && option_chain_mode)
		CRASH("/datum/cooking_with_jane/recipe/proc/add_step: Required step added while option chain mode is on. Recipe name=[name].")

	if(optional)
		switch(option_chain_mode)
			//When the chain needs to be initialized
			if(1)
				last_required_step.optional_step_list += step
				option_chain_mode = 2
				step.flags |= CWJ_IS_OPTION_CHAIN
			//When the chain has already started.
			if(2)
				last_created_step.next_step = step
				step.flags |= CWJ_IS_OPTION_CHAIN
			else
				last_required_step.optional_step_list += step
				//Set the next step to loop back to the step it branched from.
				step.next_step = last_required_step
	else
		last_required_step.next_step = step


	//populate the previous step for optional backwards pathing.
	if(option_chain_mode)
		step.previous_step = last_created_step
	else
		step.previous_step = last_required_step

	//Update flags
	if(!optional)
		last_required_step.flags &= ~CWJ_IS_LAST_STEP
		step.flags |= CWJ_IS_LAST_STEP
	else
		step.flags |= CWJ_IS_OPTIONAL
		if(exclusive_option_mode)
			step.flags |= CWJ_IS_EXCLUSIVE
		if(option_chain_mode)
			step.flags |= CWJ_IS_OPTION_CHAIN

	if(!optional)
		last_required_step = step

	last_created_step = step

	//Handle exclusive options
	if(exclusive_option_mode)
		active_exclusive_option_list[step] = list()
		for (var/datum/cooking_with_jane/recipe_step/ex_step in active_exclusive_option_list)
			if(ex_step == step.unique_id || step.in_option_chain(ex_step))
				continue
			active_exclusive_option_list[ex_step] += step
	return step

//-----------------------------------------------------------------------------------
//default function for creating a product
/datum/cooking_with_jane/recipe/proc/create_product(var/datum/cooking_with_jane/recipe_pointer/pointer)
	var/datum/cooking_with_jane/recipe_tracker/parent = pointer.parent_ref.resolve()
	var/obj/item/container = parent.holder_ref.resolve()
	if(container)
		//Build up a list of reagents that went into this.
		var/datum/reagents/slurry = new /datum/reagents(max=1000000, A=container)

		//Filter out reagents based on settings
		if(GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_REAGENT]"])
			for(var/id in pointer.steps_taken)
				if(!GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_REAGENT]"][id])
					continue
				var/datum/cooking_with_jane/recipe_step/add_reagent/active_step = GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_REAGENT]"][id]
				var/amount_to_remove = active_step.required_reagent_amount * (1 - active_step.remain_percent)
				if(!amount_to_remove)
					continue
				#ifdef CWJ_DEBUG
				log_debug("/recipe/proc/create_product: Removing [amount_to_remove] units of id [active_step.required_reagent_id] from [container]")
				#endif
				container.reagents.remove_reagent(active_step.required_reagent_id, amount_to_remove, safety = 1)

		if(product_type) //Make a regular item
			if(container.reagents.total_volume)
				#ifdef CWJ_DEBUG
				log_debug("/recipe/proc/create_product: Transferring container reagents of [container.reagents.total_volume] to slurry of current volume [slurry.total_volume] max volume [slurry.maximum_volume]")
				#endif
				container.reagents.trans_to_holder(slurry, amount=container.reagents.total_volume)

			//Do reagent filtering on added items and produce
			var/list/exclude_list = list()
			for(var/obj/item/added_item in container.contents)
				var/can_add = TRUE
				var/list/exclude_specific_reagents = list()
				#ifdef CWJ_DEBUG
				log_debug("/recipe/proc/create_product: Analyzing reagents of [added_item].")
				#endif
				for(var/id in pointer.steps_taken)
					#ifdef CWJ_DEBUG
					log_debug("/recipe/proc/create_product: Comparing step id [id] for [added_item].")
					#endif
					if(id in exclude_list) //Only consider a step for removal one time.
						#ifdef CWJ_DEBUG
						log_debug("/recipe/proc/create_product: id in exclude list; skipping.")
						#endif
						continue
					if(GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_ITEM]"] && GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_ITEM]"][id])
						var/datum/cooking_with_jane/recipe_step/add_item/active_step = GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_ITEM]"][id]
						exclude_specific_reagents = active_step.exclude_reagents
						if(active_step.reagent_skip)
							#ifdef CWJ_DEBUG
							log_debug("/recipe/proc/create_product: Reagent skip detected. Ignoring reagents from [added_item].")
							#endif
							can_add = FALSE
							exclude_list += id
							break
					else if(GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_PRODUCE]"] && GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_PRODUCE]"][id])
						var/datum/cooking_with_jane/recipe_step/add_produce/active_step = GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_PRODUCE]"][id]
						exclude_specific_reagents = active_step.exclude_reagents
						if(active_step.reagent_skip)
							#ifdef CWJ_DEBUG
							log_debug("/recipe/proc/create_product: Reagent skip detected. Ignoring reagents from [added_item].")
							#endif
							can_add = FALSE
							exclude_list += id
							break
				if(can_add)
					if(exclude_specific_reagents.len)
						for(var/id in exclude_specific_reagents)
							#ifdef CWJ_DEBUG
							log_debug("/recipe/proc/create_product: Removing [added_item.reagents.get_reagent_amount(id)] units of id [id] from [added_item]")
							#endif
							added_item.reagents.remove_reagent(id, added_item.reagents.get_reagent_amount(id), safety=TRUE)
					#ifdef CWJ_DEBUG
					log_debug("/recipe/proc/create_product: Adding [added_item.reagents.total_volume] units from [added_item] to slurry")
					#endif
					added_item.reagents.trans_to_holder(slurry, amount=added_item.reagents.total_volume)

			//Purge the contents of the container we no longer need it
			QDEL_LIST(container.contents)
			container.contents = list()

			var/reagent_quality = calculate_reagent_quality(pointer)


			//Produce Item descriptions based on the steps taken
			var/cooking_description_modifier = ""
			for(var/id in pointer.steps_taken)
				if(pointer.steps_taken[id] != "skip")
					cooking_description_modifier += "[pointer.steps_taken[id]]\n"

			for(var/i = 0; i < product_count; i++)
				var/obj/item/new_item = new product_type(container)
				#ifdef CWJ_DEBUG
				log_debug("/recipe/proc/create_product: Item created with reagents of [new_item.reagents.total_volume]")
				#endif
				if(replace_reagents)
					//Clearing out reagents in data. If initialize hasn't been called, we also null that out here.
					#ifdef CWJ_DEBUG
					log_debug("/recipe/proc/create_product: Clearing out reagents from the [new_item]")
					#endif
					new_item.reagents.clear_reagents()
				#ifdef CWJ_DEBUG
				log_debug("/recipe/proc/create_product: Transferring slurry of [slurry.total_volume] to [new_item] of total volume [new_item.reagents.total_volume]")
				#endif
				slurry.trans_to_holder(new_item.reagents, amount=slurry.total_volume, copy=1)

				new_item?:food_quality = pointer.tracked_quality + reagent_quality
				new_item?:cooking_description_modifier = cooking_description_modifier
				//TODO: Consider making an item's base components show up in the reagents of the product.
		else
			//Purge the contents of the container we no longer need it
			QDEL_LIST(container.contents)
			container.contents = list()

		container.reagents.clear_reagents()

		if(reagent_id) //Make a reagent
			//quality handling
			var/total_quality = pointer.tracked_quality + calculate_reagent_quality(pointer)

			//Create our Reagent
			container.reagents.add_reagent(reagent_id, reagent_amount, data=list("FOOD_QUALITY" = total_quality))

		qdel(slurry)

//Extra Reagents in a recipe take away recipe quality for every extra unit added to the concoction.
//Reagents are calculated in two areas. Here and /datum/cooking_with_jane/recipe_step/add_reagent/calculate_quality
/datum/cooking_with_jane/recipe/proc/calculate_reagent_quality(var/datum/cooking_with_jane/recipe_pointer/pointer)
	if(!GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_REAGENT]"])
		return 0
	var/datum/cooking_with_jane/recipe_tracker/parent = pointer.parent_ref.resolve()
	var/obj/item/container = parent.holder_ref.resolve()
	var/total_volume = container.reagents.total_volume

	var/calculated_volume = 0

	var/calculated_quality = 0
	for(var/id in pointer.steps_taken)
		if(!GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_REAGENT]"][id])
			continue
		var/datum/cooking_with_jane/recipe_step/add_reagent/active_step = GLOB.cwj_step_dictionary_ordered["[CWJ_ADD_REAGENT]"][id]
		calculated_volume += active_step.required_reagent_amount

		calculated_quality += active_step.base_quality_award

	return calculated_quality - (total_volume - calculated_volume)



//-----------------------------------------------------------------------------------
/datum/cooking_with_jane/proc/get_class_string(var/code)
	switch(code)
		if(CWJ_ADD_ITEM)
			return "Add Item"
		if(CWJ_USE_ITEM)
			return "Use Item"
		if(CWJ_ADD_REAGENT)
			return "Add Reagent"
		if(CWJ_ADD_PRODUCE)
			return "Add Produce"
		if(CWJ_USE_TOOL)
			return "Use Tool"
		if(CWJ_USE_STOVE)
			return "Use Stove"
		if(CWJ_USE_GRILL)
			return "Use Grill"
		if(CWJ_USE_OVEN)
			return "Use Oven"
		if(CWJ_USE_OTHER)
			return "Custom Action"
		if(CWJ_START)
			return "Placeholder Action"
