//A cooking step that involves adding a reagent to the food.
/datum/cooking_with_jane/recipe_step/use_oven
	class=CWJ_USE_OVEN
	auto_complete_enabled = TRUE
	var/time
	var/heat

//set_heat: The temperature the oven must bake at.
//set_time: How long something must be baked in the overn
//our_recipe: The parent recipe object
/datum/cooking_with_jane/recipe_step/use_oven/New(var/set_heat, var/set_time, var/datum/cooking_with_jane/recipe/our_recipe)



	time = set_time
	heat = set_heat

	desc = "Cook in an oven set to [heat] for [ticks_to_text(time)]."

	..(our_recipe)


/datum/cooking_with_jane/recipe_step/use_oven/check_conditions_met(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)

	if(!istype(used_item, /obj/machinery/cooking_with_jane/oven))
		return CWJ_CHECK_INVALID

	return CWJ_CHECK_VALID

//Reagents are calculated prior to object creation
/datum/cooking_with_jane/recipe_step/use_oven/calculate_quality(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = tracker.holder_ref.resolve()

	var/obj/machinery/cooking_with_jane/oven/our_oven = used_item


	var/bad_cooking = 0
	for (var/key in container.oven_data)
		if (heat != key)
			bad_cooking += container.oven_data[key]

	bad_cooking = round(bad_cooking/(5 SECONDS))

	var/good_cooking = round(time/(3 SECONDS)) - bad_cooking + our_oven.quality_mod

	return clamp_quality(good_cooking)


/datum/cooking_with_jane/recipe_step/use_oven/follow_step(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	return CWJ_SUCCESS

/datum/cooking_with_jane/recipe_step/use_oven/is_complete(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)

	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = tracker.holder_ref.resolve()

	if(container.oven_data[heat] >= time)
		#ifdef CWJ_DEBUG
		log_debug("use_oven/is_complete() Returned True; comparing [heat]: [container.oven_data[heat]] to [time]")
		#endif
		return TRUE

	#ifdef CWJ_DEBUG
	log_debug("use_oven/is_complete() Returned False; comparing [heat]: [container.oven_data[heat]] to [time]")
	#endif
	return FALSE
