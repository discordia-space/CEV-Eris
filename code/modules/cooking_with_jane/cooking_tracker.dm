//Datum held by objects that is the core component in a recipe.
//You use other items on an items with this datum to advance its recipe.
//Kept intentionally bare-bones because MANY of these objects are going to be made.
/datum/cooking_with_jane/recipe_tracker
	var/datum/weakref/holder_ref //The parent object holding the recipe tracker.
	var/step_flags //A collection of the classes of steps the recipe can take next.
	//This variable is a little complicated.
	//It specifically references recipe_pointer objects each pointing to a different point in a different recipe.
	var/list/active_recipe_pointers = list()
	var/completion_lockout = FALSE //Freakin' cheaters...
	var/list/completed_list = list()//List of recipes marked as complete.
	var/recipe_started = FALSE 	//Tells if steps have been taken for this recipe

/datum/cooking_with_jane/recipe_tracker/New(var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container)

	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_tracker/New")
	#endif
	holder_ref = WEAKREF(container)
	src.generate_pointers()
	src.populate_step_flags()

//Call when a method is done incorrectly that provides a flat debuff to the whole meal.
/datum/cooking_with_jane/recipe_tracker/proc/apply_flat_penalty(var/penalty)
	if(active_recipe_pointers.len == 0)
		return

	for (var/datum/cooking_with_jane/recipe_pointer/pointer in active_recipe_pointers)
		pointer.tracked_quality -= penalty

//Generate recipe_pointer objects based on the global list
/datum/cooking_with_jane/recipe_tracker/proc/generate_pointers()

	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_tracker/proc/generate_pointers")
	#endif
	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = holder_ref.resolve()

	#ifdef CWJ_DEBUG
	log_debug("Loading all references to [container] of type [container.type] using [container.appliancetype]")
	#endif
	//iterate through dictionary matching on holder type
	if(GLOB.cwj_recipe_dictionary[container.appliancetype])
		for (var/key in GLOB.cwj_recipe_dictionary[container.appliancetype])
			#ifdef CWJ_DEBUG
			log_debug("Loading [container.appliancetype] , [key] into pointer.")
			#endif
			active_recipe_pointers += new /datum/cooking_with_jane/recipe_pointer(container.appliancetype, key, src)

//Generate next steps
/datum/cooking_with_jane/recipe_tracker/proc/get_step_options()

	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_tracker/proc/get_step_options")
	#endif
	var/list/options = list()
	for (var/datum/cooking_with_jane/recipe_pointer/pointer in active_recipe_pointers)
		options += pointer.get_possible_steps()

	#ifdef CWJ_DEBUG
	log_debug("/datum/cooking_with_jane/recipe_tracker/proc/get_step_options returned [options.len] options")
	#endif
	return options


/datum/cooking_with_jane/recipe_tracker/proc/populate_step_flags()
	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_tracker/proc/populate_step_flags")
	#endif
	step_flags = 0
	for (var/datum/cooking_with_jane/recipe_pointer/pointer in active_recipe_pointers)
		var/flag_group = pointer.get_step_flags()
		#ifdef CWJ_DEBUG
		log_debug("Flag group returned with [flag_group]")
		#endif
		step_flags |= flag_group

//Check if a recipe tracker has recipes loaded.
/datum/cooking_with_jane/recipe_tracker/proc/has_recipes()
	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_tracker/proc/has_recipes")
	#endif
	return active_recipe_pointers.len

//Wrapper function for analyzing process_item internally.
/datum/cooking_with_jane/recipe_tracker/proc/process_item_wrap(var/obj/used_object, var/mob/user)

	#ifdef CWJ_DEBUG
	log_debug("/datum/cooking_with_jane/recipe_tracker/proc/process_item_wrap called!")
	#endif

	var/response = process_item(used_object, user)

	if(response == CWJ_SUCCESS || response == CWJ_COMPLETE || response == CWJ_PARTIAL_SUCCESS)
		if(!recipe_started)
			recipe_started = TRUE
	return response

//Core function that checks if a object meets all the requirements for certain recipe actions.
/datum/cooking_with_jane/recipe_tracker/proc/process_item(var/obj/used_object, var/mob/user)
	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_tracker/proc/process_item")
	#endif
	if(completion_lockout)
		#ifdef CWJ_DEBUG
		log_debug("/datum/cooking_with_jane/recipe_tracker/proc/process_item held in lockout!")
		#endif
		return CWJ_LOCKOUT
	var/list/valid_steps = list()
	var/list/valid_unique_id_list = list()
	var/use_class

	//Decide what action is being taken with the item, if any.
	for (var/datum/cooking_with_jane/recipe_pointer/pointer in active_recipe_pointers)
		var/option_list = list()
		option_list += pointer.get_possible_steps()
		for (var/datum/cooking_with_jane/recipe_step/step in option_list)
			var/class_string = get_class_string(step.class)
			var/is_valid = step.check_conditions_met(used_object, src)
			#ifdef CWJ_DEBUG
			log_debug("recipe_tracker/proc/process_item: Check conditions met returned [is_valid]")
			#endif
			if(is_valid == CWJ_CHECK_VALID)
				if(!valid_steps["[class_string]"])
					valid_steps["[class_string]"] = list()
				valid_steps["[class_string]"]+= step

				if(!valid_unique_id_list["[class_string]"])
					valid_unique_id_list["[class_string]"] = list()
				valid_unique_id_list["[class_string]"] += step.unique_id

				if(!use_class)
					use_class = class_string
	if(valid_steps.len == 0)
		#ifdef CWJ_DEBUG
		log_debug("/recipe_tracker/proc/process_item returned no steps!")
		#endif
		return CWJ_NO_STEPS

	if(valid_steps.len > 1)
		completion_lockout = TRUE
		if(user)
			var/list/choice = input(user, "There's two things you can do with this item!", "Choose One:") in valid_steps
			completion_lockout = FALSE
			if(!choice)
				#ifdef CWJ_DEBUG
				log_debug("/recipe_tracker/proc/process_item returned choice cancel!")
				#endif
				return CWJ_CHOICE_CANCEL
			use_class = choice
		else
			use_class = 1
	#ifdef CWJ_DEBUG
	log_debug("Use class determined: [use_class]")
	#endif

	valid_steps = valid_steps[use_class]
	valid_unique_id_list = valid_unique_id_list[use_class]

	var/has_traversed = FALSE
	//traverse and cull pointers
	for (var/datum/cooking_with_jane/recipe_pointer/pointer in active_recipe_pointers)
		var/used_id = FALSE
		var/list/option_list = pointer.get_possible_steps()
		for (var/datum/cooking_with_jane/recipe_step/step in option_list)
			if(!(step.unique_id in valid_unique_id_list))
				continue
			else
				used_id = TRUE
				if(step.is_complete(used_object, src))
					has_traversed = TRUE
					pointer.traverse(step.unique_id, used_object)
					break
		if (!used_id)
			active_recipe_pointers.Remove(pointer)
			qdel(pointer)


	//attempt_complete_recursive(used_object, use_class) No, never again...

	//Choose to keep baking or finish now.
	if(completed_list.len && (completed_list.len != active_recipe_pointers.len))

		var/recipe_string = null
		for(var/datum/cooking_with_jane/recipe_pointer/pointer in completed_list)
			if(!recipe_string)
				recipe_string = "\a [pointer.current_recipe.name]"
			else
				recipe_string += ", or \a [pointer.current_recipe.name]"
		if(user)
			if(alert(user, "If you finish cooking now, you will create [recipe_string]. However, you feel there are possibilities beyond even this. Continue cooking anyways?",,"Yes","No") == "Yes")
				//Cull finished recipe items
				for (var/datum/cooking_with_jane/recipe_pointer/pointer in completed_list)
					active_recipe_pointers.Remove(pointer)
					qdel(pointer)
				completed_list = list()

	//Check if we completed our recipe
	var/datum/cooking_with_jane/recipe_pointer/chosen_pointer = null
	if(completed_list.len >= 1)
		#ifdef CWJ_DEBUG
		log_debug("/recipe_tracker/proc/process_item YO WE ACTUALLY HAVE A COMPLETED A RECIPE!")
		#endif
		chosen_pointer = completed_list[1]
		if(user)
			if(completed_list.len > 1)
				completion_lockout = TRUE
				var/choice = input(user, "There's two things you complete at this juncture!", "Choose One:") in completed_list
				completion_lockout = FALSE
				if(choice)
					chosen_pointer = completed_list[choice]

	//Call a proc that follows one of the steps in question, so we have all the nice to_chat calls.
	var/datum/cooking_with_jane/recipe_step/sample_step = valid_steps[1]
	#ifdef CWJ_DEBUG
	log_debug("/recipe_tracker/proc/process_item: Calling follow_step")
	#endif
	sample_step.follow_step(used_object, src)

	if(chosen_pointer)
		chosen_pointer.current_recipe.create_product(chosen_pointer)
		return CWJ_COMPLETE
	populate_step_flags()

	if(has_traversed)
		#ifdef CWJ_DEBUG
		log_debug("/recipe_tracker/proc/process_item returned success!")
		#endif
		return CWJ_SUCCESS

	#ifdef CWJ_DEBUG
	log_debug("/recipe_tracker/proc/process_item returned partial success!")
	#endif
	return CWJ_PARTIAL_SUCCESS

//Sleep... My precious, monsterous child....
/*
/datum/cooking_with_jane/recipe_tracker/proc/attempt_complete_recursive(
		var/obj/used_object,
		var/use_class,
		var/depth = 1,
		var/list/considered_steps = null)
	var/list/ourlist = null
	if(depth == 1)
		ourlist = active_recipe_pointers.Copy()
	else
		ourlist = considered_steps.Copy()
		log_debug("/recipe_tracker/proc/attempt_complete_recursive entered second recursion!")

	for (var/datum/cooking_with_jane/recipe_pointer/pointer in ourlist)
		var/option_list = list()
		option_list += pointer.get_possible_steps()
		var/has_valid_step = FALSE
		var/had_traversal = FALSE
		for (var/datum/cooking_with_jane/recipe_step/step in option_list)
			if(step.class != use_class)
				continue

			if(depth !=1 && !step.auto_complete_enabled)
				continue

			if(step.check_conditions_met(used_object, src) == CWJ_CHECK_VALID)
				has_valid_step = TRUE
			else
				continue

			if(step.is_complete(src))
				pointer.traverse(step.unique_id, used_object)
				had_traversal = TRUE
				break ///The first valid step is the only one we traverse, in the instance of multiple valid cases.

		if(depth == 1 && !has_valid_step)
			active_recipe_pointers.Remove(pointer)
			ourlist.Remove(pointer)
		else if(!had_traversal)
			ourlist.Remove(pointer)

	if(ourlist.len != 0 && depth !=5)
		attempt_complete_recursive(used_object, use_class, depth=++depth, considered_steps = ourlist)
*/
//===================================================================================


//Points to a specific step in a recipe while considering the optional paths that recipe can take.
/datum/cooking_with_jane/recipe_pointer
	var/datum/cooking_with_jane/recipe/current_recipe //The recipe being followed here.
	var/datum/cooking_with_jane/recipe_step/current_step //The current step in the recipe we are following.

	var/datum/weakref/parent_ref

	var/tracked_quality = 0 //The current level of quality within that recipe.

	var/list/steps_taken = list() //built over the course of following a recipe, tracks what has been done to the object. Format is unique_id:result

/datum/cooking_with_jane/recipe_pointer/New(start_type, recipe_id, var/datum/cooking_with_jane/recipe_tracker/parent)

	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_pointer/pointer/New([start_type], [recipe_id], parent)")
	#endif

	parent_ref = WEAKREF(parent)

	#ifdef CWJ_DEBUG
	if(!GLOB.cwj_recipe_dictionary[start_type][recipe_id])
		log_debug("Recipe [start_type]-[recipe_id] not found by tracker!")
	#endif

	current_recipe = GLOB.cwj_recipe_dictionary[start_type][recipe_id]

	#ifdef CWJ_DEBUG
	if(!current_recipe)
		log_debug("Recipe [start_type]-[recipe_id] initialized as null!")
	#endif

	current_step = current_recipe.first_step

	#ifdef CWJ_DEBUG
	steps_taken["[current_step.unique_id]"]="Started with a [start_type]"
	#endif

//A list returning the next possible steps in a given recipe
/datum/cooking_with_jane/recipe_pointer/proc/get_possible_steps()

	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_pointer/proc/get_possible_steps")
	if(!current_step)
		log_debug("Recipe pointer in [current_recipe] has no current_step assigned?")

	if(!current_step.next_step)
		log_debug("Recipe pointer in [current_recipe] has no next step.")
	#endif

	//Build a list of all possible steps while accounting for exclusive step relations.
	//Could be optimized, but keeps the amount of variables in the pointer low.
	var/list/return_list = list(current_step.next_step)
	for(var/datum/cooking_with_jane/recipe_step/step in current_step.optional_step_list)

		if(steps_taken["[step.unique_id]"])
			//Traverse an option chain if one is present.
			if(step.flags & CWJ_IS_OPTION_CHAIN)
				var/datum/cooking_with_jane/recipe_step/option_chain_step = step.next_step
				while(option_chain_step.unique_id != current_step.unique_id)
					if(!steps_taken["[option_chain_step.unique_id]"])
						return_list += option_chain_step
						break
					option_chain_step = option_chain_step.next_step
			continue

		//Reference the global exclusion list to see if we can add this
		var/exclude_step = FALSE
		if(step.flags & CWJ_IS_EXCLUSIVE)
			for (var/id in GLOB.cwj_optional_step_exclusion_dictionary["[step.unique_id]"])
				//Reference the global exclusion list to see if any of the taken steps
				//Have the current step marked as exclusive.
				if(steps_taken["[id]"])
					exclude_step = TRUE
					break


		if(!exclude_step)
			return_list += step
		#ifdef CWJ_DEBUG
		else
			log_debug("Ignoring step [step.unique_id] due to exclusion.")
		#endif


	#ifdef CWJ_DEBUG
	log_debug("/datum/cooking_with_jane/recipe_pointer/proc/get_possible_steps returned list of length [return_list.len]")
	#endif
	return return_list

//Get the classes of all applicable next-steps for a recipe in a bitmask.
/datum/cooking_with_jane/recipe_pointer/proc/get_step_flags()
	#ifdef CWJ_DEBUG
	log_debug("Called /datum/cooking_with_jane/recipe_pointer/proc/get_step_flags")
	if(!current_step)
		log_debug("Recipe pointer in [current_recipe] has no current_step assigned?")
	else if(!current_step.next_step)
		log_debug("Recipe pointer in [current_recipe] has no next step.")
	#endif

	//Build a list of all possible steps while accounting for exclusive step relations.
	//Could be optimized, but keeps the amount of variables in the pointer low.
	var/return_flags = current_step.next_step.class
	for(var/datum/cooking_with_jane/recipe_step/step in current_step.optional_step_list)

		if(steps_taken["[step.unique_id]"])
			//Traverse an option chain if one is present.
			if(step.flags & CWJ_IS_OPTION_CHAIN)
				var/datum/cooking_with_jane/recipe_step/option_chain_step = step.next_step
				while(option_chain_step.unique_id != current_step.unique_id)
					if(!steps_taken["[option_chain_step.unique_id]"])
						return_flags |= option_chain_step.class
						break
					option_chain_step = option_chain_step.next_step
			continue

		//Reference the global exclusion list to see if we can add this
		var/exclude_step = FALSE
		if(step.flags & CWJ_IS_EXCLUSIVE)
			for (var/id in GLOB.cwj_optional_step_exclusion_dictionary["[step.unique_id]"])
				//Reference the global exclusion list to see if any of the taken steps
				//Have the current step marked as exclusive.
				if(steps_taken["[id]"])
					exclude_step = TRUE
					break
		if(!exclude_step)
			return_flags |= step.class
	return return_flags

/datum/cooking_with_jane/recipe_pointer/proc/has_option_by_id(var/id)
	if(!GLOB.cwj_step_dictionary["[id]"])
		return FALSE
	var/datum/cooking_with_jane/recipe_step/active_step = GLOB.cwj_step_dictionary["[id]"]
	var/list/possible_steps = get_possible_steps()
	if(active_step in possible_steps)
		return TRUE
	return FALSE

/datum/cooking_with_jane/recipe_pointer/proc/traverse(var/id, var/obj/used_obj)
	#ifdef CWJ_DEBUG
	log_debug("/recipe_pointer/traverse: Traversing pointer from [current_step.unique_id] to [id].")
	#endif
	if(!GLOB.cwj_step_dictionary["[id]"])
		return FALSE
	var/datum/cooking_with_jane/recipe_tracker/tracker = parent_ref.resolve()
	var/datum/cooking_with_jane/recipe_step/active_step = GLOB.cwj_step_dictionary["[id]"]

	var/is_valid_step =  FALSE
	var/list/possible_steps = get_possible_steps()
	for(var/datum/cooking_with_jane/recipe_step/possible_step in possible_steps)
		if(active_step.unique_id == possible_step.unique_id)
			is_valid_step = TRUE
			break

	if(!is_valid_step)
		#ifdef CWJ_DEBUG
		log_debug("/recipe_pointer/traverse: step [id] is not valid for recipe [current_recipe.unique_id]")
		#endif
		return FALSE

	var/step_quality = active_step.calculate_quality(used_obj, tracker)
	tracked_quality += step_quality
	steps_taken["[id]"] = active_step.get_step_result_text(used_obj, step_quality)
	if(!(active_step.flags & CWJ_IS_OPTIONAL))
		current_step = active_step

	//The recipe has been completed.
	if(!current_step.next_step && current_step.unique_id == id)

		tracker.completed_list +=  src
		return TRUE

	return FALSE
