//A cooking step that involves using SPECIFICALLY Grown foods
/datum/cooking_with_jane/recipe_step/add_produce
	class=CWJ_ADD_PRODUCE
	var/required_produce_type
	var/base_potency
	var/reagent_skip = FALSE
	var/inherited_quality_modifier = 1

	var/list/exclude_reagents = list()

/datum/cooking_with_jane/recipe_step/add_produce/New(var/produce, var/datum/cooking_with_jane/recipe/our_recipe)
	if(!plant_controller)
		CRASH("/datum/cooking_with_jane/recipe_step/add_produce/New: Plant controller not initialized! Exiting.")
	if(produce && plant_controller && plant_controller.seeds[produce])
		desc = "Add \a [produce] into the recipe."
		required_produce_type = produce
		group_identifier = produce

		//Get tooltip image for plants
		var/datum/seed/seed = plant_controller.seeds[produce]
		var/icon_key = "fruit-[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"
		if(plant_controller.plant_icon_cache[icon_key])
			tooltip_image = plant_controller.plant_icon_cache[icon_key]
		else
			log_debug("[seed] is missing it's icon to add to tooltip_image")
		base_potency = seed.get_trait(TRAIT_POTENCY)
	else
		CRASH("/datum/cooking_with_jane/recipe_step/add_produce/New: Seed [produce] not found. Exiting.")
	..(base_quality_award, our_recipe)

/datum/cooking_with_jane/recipe_step/add_produce/check_conditions_met(var/obj/added_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	#ifdef CWJ_DEBUG
	log_debug("Called add_produce/check_conditions_met for [added_item] against [required_produce_type]")
	#endif

	if(!istype(added_item, /obj/item/reagent_containers/food/snacks/grown))
		return CWJ_CHECK_INVALID

	var/obj/item/reagent_containers/food/snacks/grown/added_produce = added_item

	if(added_produce.seed.kitchen_tag == required_produce_type)
		return CWJ_CHECK_VALID

	return CWJ_CHECK_INVALID

/datum/cooking_with_jane/recipe_step/add_produce/calculate_quality(var/obj/added_item, var/datum/cooking_with_jane/recipe_tracker/tracker)

	var/obj/item/reagent_containers/food/snacks/grown/added_produce = added_item

	var/potency_raw = round(base_quality_award + (added_produce.potency - base_potency) * inherited_quality_modifier)

	return clamp_quality(potency_raw)

/datum/cooking_with_jane/recipe_step/add_produce/follow_step(var/obj/added_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	#ifdef CWJ_DEBUG
	log_debug("Called: /datum/cooking_with_jane/recipe_step/add_produce/follow_step")
	#endif
	var/obj/item/container = tracker.holder_ref.resolve()
	if(container)
		if(usr.canUnEquip(added_item))
			usr.unEquip(added_item, container)
		else
			added_item.forceMove(container)
	return CWJ_SUCCESS
