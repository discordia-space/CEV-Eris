//A cooking step that involves adding a reagent to the food.
/datum/cooking_with_jane/recipe_step/add_reagent
	class=CWJ_ADD_REAGENT
	auto_complete_enabled = TRUE
	var/expected_total
	var/required_reagent_id
	var/required_reagent_amount
	var/remain_percent = 1 //What percentage of the reagent ends up in the product

//reagent_id: The id of the required reagent to be added, E.G. 'salt'.
//amount: The amount of the required reagent that needs to be added.
//base_quality_award: The quality awarded by following this step.
//our_recipe: The parent recipe object,
/datum/cooking_with_jane/recipe_step/add_reagent/New(var/reagent_id,  var/amount, var/datum/cooking_with_jane/recipe/our_recipe)

	var/datum/reagent/global_reagent = GLOB.chemical_reagents_list[reagent_id]
	if(global_reagent)
		desc = "Add [amount] unit[amount>1 ? "s" : ""] of [global_reagent.name]."

		required_reagent_id = reagent_id
		group_identifier = reagent_id

		required_reagent_amount = amount
	else
		CRASH("/datum/cooking_with_jane/recipe_step/add/reagent/New(): Reagent [reagent_id] not found. Recipe: [our_recipe]")

	..(our_recipe)


/datum/cooking_with_jane/recipe_step/add_reagent/check_conditions_met(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/obj/item/container = tracker.holder_ref.resolve()


	if((container.reagents.total_volume + required_reagent_amount - container.reagents.get_reagent_amount(required_reagent_id)) > container.reagents.maximum_volume)
		return CWJ_CHECK_FULL

	if(!istype(used_item, /obj/item/reagent_containers))
		return CWJ_CHECK_INVALID
	if(!(used_item.reagent_flags & OPENCONTAINER))
		return CWJ_CHECK_INVALID

	var/obj/item/reagent_containers/our_item = used_item
	if(our_item.amount_per_transfer_from_this <= 0)
		return CWJ_CHECK_INVALID
	if(our_item.reagents.total_volume == 0)
		return CWJ_CHECK_INVALID

	return CWJ_CHECK_VALID

//Reagents are calculated in two areas. Here and /datum/cooking_with_jane/recipe/proc/calculate_reagent_quality
/datum/cooking_with_jane/recipe_step/add_reagent/calculate_quality(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/obj/item/container = tracker.holder_ref.resolve()
	var/data = container.reagents.get_data(required_reagent_id)
	var/cooked_quality = 0
	if(data && istype(data, /list) && data["FOOD_QUALITY"])
		cooked_quality = data["FOOD_QUALITY"]
	return cooked_quality


/datum/cooking_with_jane/recipe_step/add_reagent/follow_step(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/obj/item/reagent_containers/our_item = used_item
	var/obj/item/container = tracker.holder_ref.resolve()

	var/trans = our_item.reagents.trans_to_obj(container, our_item.amount_per_transfer_from_this)

	playsound(usr,'sound/effects/Liquid_transfer_mono.ogg',50,1)
	to_chat(usr, SPAN_NOTICE("You transfer [trans] units to \the [container]."))

	return CWJ_SUCCESS

/datum/cooking_with_jane/recipe_step/add_reagent/is_complete(var/obj/used_item, var/datum/cooking_with_jane/recipe_tracker/tracker)
	var/obj/item/reagent_containers/our_item = used_item
	var/obj/item/container = tracker.holder_ref.resolve()
	var/part = our_item.reagents.get_reagent_amount(required_reagent_id) / our_item.reagents.total_volume

	var/incoming_amount = max(0, min(our_item.amount_per_transfer_from_this, our_item.reagents.total_volume, container.reagents.get_free_space()))

	var/incoming_valid_amount = incoming_amount * part

	var/resulting_total = container.reagents.get_reagent_amount(required_reagent_id) + incoming_valid_amount
	if(resulting_total >= required_reagent_amount)
		return TRUE
	return FALSE
