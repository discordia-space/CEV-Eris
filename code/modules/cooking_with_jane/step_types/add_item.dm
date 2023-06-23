//A cooking step that involves adding an item to the food. Is based on Item Type.
//This basically deletes the food used on it.

//ENSURE THE INCOMING ITEM HAS var/quality DEFINED!
/datum/cooking_with_jane/recipe_step/add_item
	class = CWJ_ADD_ITEM

	var/required_item_type //Item required for the recipe step

	var/inherited_quality_modifier = 1 //The modifier we apply multiplicatively to balance quality scaling across recipes.

	var/exact_path = FALSE //Tests if the item has to be the EXACT ITEM PATH, or just a child of the item path.

	var/reagent_skip = FALSE

	var/list/exclude_reagents = list()

//item_type: The type path of the object we are looking for.
//our_recipe: The parent recipe object,
/datum/cooking_with_jane/recipe_step/add_item/New(var/item_type, var/datum/cooking_with_jane/recipe/our_recipe)

	#ifdef CWJ_DEBUG
	if(!ispath(item_type, /obj/item))
		log_debug("/datum/cooking_with_jane/recipe_step/add_item/New(): item [item_type] is not a valid path")
	#endif

	var/obj/item/example_item = new item_type()
	if(example_item)
		desc = "Add \a [example_item] into the recipe."

		required_item_type = item_type
		group_identifier = item_type
		tooltip_image = image(example_item.icon, icon_state=example_item.icon_state)
		QDEL_NULL(example_item)
	#ifdef CWJ_DEBUG
	else
		log_debug("/datum/cooking_with_jane/recipe_step/add_item/New(): item [item_type] couldn't be created.")
	#endif
	..(our_recipe)


/datum/cooking_with_jane/recipe_step/add_item/check_conditions_met(var/obj/added_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	#ifdef CWJ_DEBUG
	log_debug("Called add_item/check_conditions_met for [added_item], checking against item type [required_item_type]. Exact_path = [exact_path]")
	#endif
	if(!istype(added_item, /obj/item))
		return CWJ_CHECK_INVALID
	if(exact_path)
		if(added_item.type == required_item_type)
			return CWJ_CHECK_VALID
	else
		if(istype(added_item, required_item_type))
			return CWJ_CHECK_VALID
	return CWJ_CHECK_INVALID

//The quality of add_item is special, in that it inherits the quality level of its parent and
//passes it along.
//May need "Balancing" with var/inherited_quality_modifier
/datum/cooking_with_jane/recipe_step/add_item/calculate_quality(var/obj/added_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/raw_quality = added_item?:food_quality * inherited_quality_modifier
	return clamp_quality(raw_quality)

/datum/cooking_with_jane/recipe_step/add_item/follow_step(var/obj/added_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	#ifdef CWJ_DEBUG
	log_debug("Called: /datum/cooking_with_jane/recipe_step/add_item/follow_step")
	#endif
	var/obj/item/container = tracker.holder_ref.resolve()
	if(container)
		if(usr.canUnEquip(added_item))
			usr.unEquip(added_item, container)
		else
			added_item.forceMove(container)
	return CWJ_SUCCESS