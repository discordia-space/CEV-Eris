//A cooking step that involves adding a reagent to the food.
/datum/cooking_with_jane/recipe_step/use_grill
	class=CWJ_USE_GRILL
	auto_complete_enabled = TRUE
	var/time
	var/heat

//reagent_id: The id of the required reagent to be added, E.G. 'salt'.
//amount: The amount of the required reagent that needs to be added.
//base_quality_award: The quality awarded by following this step.
//our_recipe: The parent recipe object,
/datum/cooking_with_jane/recipe_step/use_grill/New(var/set_heat, var/set_time, var/datum/cooking_with_jane/recipe/our_recipe)



	time = set_time
	heat = set_heat

	desc = "Cook on a grill set to [heat] for [ticks_to_text(time)]."

	..(our_recipe)


/datum/cooking_with_jane/recipe_step/use_grill/check_conditions_met(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)

	if(!istype(used_item, /obj/machinery/cooking_with_jane/grill))
		return CWJ_CHECK_INVALID

	return CWJ_CHECK_VALID

//Reagents are calculated prior to object creation
/datum/cooking_with_jane/recipe_step/use_grill/calculate_quality(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = tracker.holder_ref.resolve()

	var/obj/machinery/cooking_with_jane/grill/our_grill = used_item


	var/bad_cooking = 0
	for (var/key in container.grill_data)
		if (heat != key)
			bad_cooking += container.grill_data[key]

	bad_cooking = round(bad_cooking/(5 SECONDS))

	var/good_cooking = round(time/(3 SECONDS)) - bad_cooking + our_grill.quality_mod

	return clamp_quality(good_cooking)


/datum/cooking_with_jane/recipe_step/use_grill/follow_step(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	return CWJ_SUCCESS

/datum/cooking_with_jane/recipe_step/use_grill/is_complete(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)

	var/obj/item/reagent_containers/cooking_with_jane/cooking_container/container = tracker.holder_ref.resolve()

	if(container.grill_data[heat] >= time)
		#ifdef CWJ_DEBUG
		log_debug("use_grill/is_complete() Returned True; comparing [heat]: [container.grill_data[heat]] to [time]")
		#endif
		return TRUE

	#ifdef CWJ_DEBUG
	log_debug("use_grill/is_complete() Returned False; comparing [heat]: [container.grill_data[heat]] to [time]")
	#endif
	return FALSE

