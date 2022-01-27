/datum/craft_step
	var/reqed_type
	var/reqed_quality
	var/reqed_quality_level = 0//For tools,69inimum threshold of a quality
	var/building = FALSE //Prevents spamming one recipe requirement to finish the entire recipe
	var/reqed_material
	var/req_amount = 0



	var/time = 15

	var/desc = ""
	var/start_msg = ""
	var/end_msg = ""
	var/tool_name
	var/list/craft_items = list()


/datum/craft_step/New(list/params, datum/craft_recipe/parent)
	var/max_params = 2
	if(ispath(params))
		reqed_type = params
	else if(istext(params))
		reqed_quality = params
		reqed_quality_level = 1 //A69inimum69alue, will be set higher in a second
	else if(islist(params))
		var/validator = params69169
		if(ispath(validator))
			reqed_type =69alidator
			req_amount = 1
		else if(istext(validator))
			if(validator == CRAFT_MATERIAL)
				reqed_material = params69369
				max_params = 3
			else
				reqed_quality =69alidator

		if(isnum(params69269)) //amount
			if(reqed_quality)
				reqed_quality_level = params69269
			else
				req_amount = params69269

		if("time" in params)
			time = params69"time"69
		else if(params.len >69ax_params)
			time = params69max_params+169
		else if(parent)
			time = parent.time

	if(reqed_type)
		var/obj/item/I = reqed_type
		tool_name = initial(I.name)
		if(!ispath(reqed_type,/obj/item/stack) && !req_amount)
			req_amount = 1

	else if(reqed_quality)
		tool_name = "tool with 69reqed_quality69 quality of 69reqed_quality_level69"

	else if(reqed_material)
		var/material/M = get_material_by_name("69reqed_material69")
		tool_name = "units of 69M.display_name69"
	make_desc()

/datum/craft_step/proc/make_desc(obj/item/craft/C)
	var/amt = req_amount
	if(C && reqed_type && req_amount > 1)
		if(!(C in craft_items))
			craft_items69C69 = req_amount
		amt = craft_items69C69

	switch(amt)
		if(0)
			desc = "Apply 69tool_name69"
			start_msg = "%USER% starts use %ITEM% on %TARGET%"
			end_msg = "%USER% applied %ITEM% to %TARGET%"
		if(1)
			if(reqed_material)
				desc = "Attach 69amt69 69tool_name69 <img style='margin-bottom:-8px' src= 69sanitizeFileName("69material_stack_type(reqed_material)69.png")69 height=24 width=24>"
			else
				desc = "Attach 69tool_name69 <img style='margin-bottom:-8px' src= 69sanitizeFileName("69reqed_type69.png")69 height=24 width=24>"
			start_msg = "%USER% starts attaching %ITEM% to %TARGET%"
			end_msg = "%USER% attached %ITEM% to %TARGET%"
		else
			desc = "Attach 69amt69 69tool_name69 <img style='margin-bottom:-8px' src= 69reqed_type ? sanitizeFileName("69reqed_type69.png") : sanitizeFileName("69material_stack_type(reqed_material)69.png")69 height=24 width=24>"
			start_msg = "%USER% starts attaching %ITEM% to %TARGET%"
			end_msg = "%USER% attached %ITEM% to %TARGET%"

/datum/craft_step/proc/announce_action(var/msg,69ob/living/user, obj/item/tool, atom/target)
	msg = replacetext(msg,"%USER%","69user69")
	msg = replacetext(msg,"%ITEM%","\improper 69tool69")
	msg = replacetext(msg,"%TARGET%","\improper 69target69")
	user.visible_message(
		msg
	)

/datum/craft_step/proc/apply(obj/item/I,69ob/living/user, obj/item/craft/target, datum/craft_recipe/recipe)
	if(building)
		return
	building = TRUE

	if(reqed_material)
		if(istype(I, /obj/item/stack/material))
			var/obj/item/stack/material/M = I
			if(M.get_default_type() != reqed_material)
				to_chat(user, SPAN_WARNING("Wrong69aterial!"))
				building = FALSE
				return
		else
			to_chat(user, SPAN_WARNING("This isn't a69aterial stack!"))
			building = FALSE
			return

	if(req_amount && istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		if(!S.can_use(req_amount))
			to_chat(user, SPAN_WARNING("Not enough items in 69I69"))
			building = FALSE
			return

	var/new_time = time // for reqed_type or raw69aterials
	if(reqed_type || !reqed_quality)
		if(recipe.related_stats)
			var/mastery_factor =69in(user.stats.getAvgStat(recipe.related_stats)/STAT_LEVEL_PROF, 1) //we will assume that STAT_LEVEL_PROF is highest69alue of69astery
			mastery_factor *= 0.66 //	we want cut no69ore than 2/3 of time
			var/time_reduction_factor =69ax(0, 1 -69astery_factor)
			new_time *= time_reduction_factor

	if(reqed_type)
		if(!istype(I, reqed_type))
			to_chat(user, SPAN_WARNING("Wrong item!"))
			building = FALSE
			return
		if(!is_valid_to_consume(I, user))
			to_chat(user, SPAN_WARNING("That item can't be used for crafting!"))
			building = FALSE
			return

		if(req_amount && istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			if(S.get_amount() < req_amount)
				to_chat(user, SPAN_WARNING("Not enough items in 69I69"))
				building = FALSE
				return

		if(target)
			announce_action(start_msg, user, I, target)

		if(!do_after(user, new_time, target || user))
			building = FALSE
			return

	else if(reqed_quality)
		var/q = I.get_tool_quality(reqed_quality)
		if(!q)
			to_chat(user, SPAN_WARNING("Wrong type of tool. You need a tool with 69reqed_quality69 quality"))
			building = FALSE
			return
		if(target)
			announce_action(start_msg, user, I, target)
		if(!I.use_tool(user, target || user, time, reqed_quality, FAILCHANCE_NORMAL, list(STAT_MEC, STAT_COG)))
			to_chat(user, SPAN_WARNING("Work aborted"))
			building = FALSE
			return

		if(q < reqed_quality_level)
			to_chat(user, SPAN_WARNING("That tool is too crude for the task. You need a tool with 69reqed_quality_level69 69reqed_quality69 quality. This tool only has 69q69 69reqed_quality69"))
			building = FALSE
			return
	else
		if(!do_after(user, new_time, target || user))
			building = FALSE
			return

	if(target)
		if(!recipe.can_build(user, get_turf(target)))
			building = FALSE
			return
	else
		if(!recipe.can_build(user, get_turf(user)))
			building = FALSE
			return

	if(req_amount)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			if(!S.use(req_amount))
				to_chat(user, SPAN_WARNING("Not enough items in 69S69. It has 69S.get_amount()69 units and we need 69req_amount69"))
				building = FALSE
				return FALSE
		else if(reqed_type) //No deleting tools
			if(target)
				if(!(target in craft_items))
					craft_items69target69 = req_amount - 1
				else
					craft_items69target69--

				if(craft_items69target69 >= 1)
					. = IN_PROGRESS

			else if(req_amount > 1)
				. = IN_PROGRESS

			user.drop_from_inventory(I)
			qdel(I)

	if(target)
		announce_action(end_msg, user, I, target)
	building = FALSE

	if(. != IN_PROGRESS)
		if(target)
			target.step++
		return IS_READY

/datum/craft_step/proc/find_item(mob/living/user)
	var/list/items = new
	for(var/slot in list(slot_l_hand, slot_r_hand))
		items += user.get_equipped_item(slot)

	var/obj/item/storage/belt = user.get_equipped_item(slot_belt)
	if(istype(belt))
		items += belt.contents

	//Robots can use their69odule items as tools or69aterials
	//We will do a check later to prevent them from dropping their tools as consumed components
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.module_state_1)
			items += R.module_state_1
		if(R.module_state_2)
			items += R.module_state_2
		if(R.module_state_3)
			items += R.module_state_3

	//We will allow all items in a 3x3 area, centred on the tile infront, to be used as components or69ats
	//Tools69ust be held though
	if(!reqed_quality)
		var/turf/T = get_step(user, user.dir)
		//Use atom/movable to account for the possiblity of recipes requiring live or dead69obs as ingredients
		for (var/atom/movable/A in range(1, T))
			if(!A.anchored)
				items += A

	if(reqed_type)
		//Special handling for items that will be consumed
		for(var/atom/movable/I in items)
			//First we find the item
			if(!istype(I, reqed_type))
				//not the right type
				continue
			//Okay, so we found something that69atches
			if(is_valid_to_consume(I, user))
				return I

	else if(reqed_quality)
		var/best_value = 0
		for(var/obj/item/I in items)
			var/value = I.get_tool_quality(reqed_quality)
			if(value > best_value)
				value = best_value
				. = I

	else if(reqed_material)
		for(var/obj/item/I in items)
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/MA = I
				if(MA.material && (MA.material.name == reqed_material))
					return I

/datum/craft_step/proc/is_valid_to_consume(obj/item/I,69ob/living/user)
	var/holder = I.get_holding_mob()
	//Next we69ust check if we're actually allowed to submit it
	if(!holder)
		//If the item is lying on a turf, it's fine
		return I

	if(holder != user)
		//The item is held by someone else, can't use
		return FALSE

	//If we get here, the item is held by our user
	if(I.loc != user)
		//The item69ust be inside a container on their person, it's fine
		return I

	if(istype(I, /obj/item/stack))
		//Robots are allowed to use stacks, since those will only deplete the amount but not destroy the item
		return I

	//The item is on the user
	if(user.canUnEquip(I))
		//We test if they can remove it, this will return false for robot objects
		return I




	//If we get here, then we found the item but it wasn't69alid to use, sorry!

	return FALSE
