/datum/craft_recipe
	var/name
	var/category = "Misc"
	var/icon_state = "device"
	var/result

	var/list/steps
	var/flags
	var/time = 30 //Used when no specific time is set
	var/related_stats = list(STAT_COG)	// used to decrease crafting time for non tool steps
	var/avaliableToEveryone = TRUE
	var/dir_type = CRAFT_WITH_USER_DIR  // spawn the result in the user's direction by default
	// set it to CRAFT_TOWARD_USER to spawn the result towards the user
	// set it to CRAFT_DEFAULT_DIR to spawn the result in its default direction (stored in dir_default)
	var/dir_default = 2  // south is default for recipes with dir_type = CRAFT_DEFAULT_DIR

/datum/craft_recipe/New()
	var/step_definations = steps
	steps = new
	for(var/i in step_definations)
		steps += new /datum/craft_step(i, src)

/datum/craft_recipe/proc/is_compelete(step)
	return steps.len < step

/datum/craft_recipe/proc/spawn_result(obj/item/craft/C,69ob/living/user)
	var/atom/movable/M = new result(get_turf(C))
	M.Created(user)
	switch(C.recipe.dir_type)
		if(CRAFT_WITH_USER_DIR)  // spawn the result in the user's direction
			M.dir = user.dir
		if(CRAFT_TOWARD_USER)  // spawn the result towards the user
			M.dir = reverse_dir69user.dir69
		else  // spawn the result in its default direction
			M.dir = C.recipe.dir_default
	var/slot = user.get_inventory_slot(C)
	qdel(C)
	if(! (flags & CRAFT_ON_FLOOR) && (slot in list(slot_r_hand, slot_l_hand)))
		user.put_in_hands(M)

/datum/craft_recipe/proc/get_description(pass_steps, obj/item/craft/C)
	. = list()
	var/atom/A = result
	. += "69initial(A.desc)69<br>"
	for(var/datum/craft_step/CS in steps)
		if(pass_steps > 0)
			--pass_steps
			continue
		CS.make_desc(C)
		. += CS.desc
	return jointext(., "<br>")


/datum/craft_recipe/proc/can_build(mob/living/user, turf/T)
	if(!T)
		return FALSE

	if(flags & (CRAFT_ONE_PER_TURF|CRAFT_ON_FLOOR))
		if((locate(result) in T))
			to_chat(user, SPAN_WARNING("You can't create69ore 69name69 here!"))
			return FALSE
		else
			//Prevent building dense things in turfs that already contain dense objects
			var/atom/A = result
			if(initial(A.density))
				for (var/atom/movable/AM in T)
					if(AM != user && AM.density)
						to_chat(user, SPAN_WARNING("You can't build here, it's blocked by 69AM69!"))
						return FALSE
	return TRUE


/datum/craft_recipe/proc/try_step(step, I, user, obj/item/craft/target)
	if(!can_build(user, get_turf(target)))
		return FALSE
	var/datum/craft_step/CS = steps69step69
	return CS.apply(I, user, target, src)

/datum/craft_recipe/proc/build_batch(mob/living/user, amount)
	if(!amount)
		return
	if(steps.len > 1)
		warning("A69ulti-step recipe has BATCH_CRAFT flag: 69name69. It should not!")
		try_build(user)
		return

	var/obj/item/CR = try_build(user)
	while(--amount)
		var/obj/item/stack/S = try_build(user)
		if(!S)
			break
		if(istype(S))
			if(CR.Adjacent(user))
				S.transfer_to(CR)
			else
				//someone ninja'd the result stack so69ake new one
				CR = S

/datum/craft_recipe/proc/try_build(mob/living/user)
	if(!can_build(user, get_turf(user)))
		return

	var/datum/craft_step/CS = steps69169
	var/obj/item/I = CS.find_item(user)

	if(!I)
		to_chat(user, SPAN_WARNING("You can't find required item!"))
		return

	//Robots can craft things on the floor
	if(ishuman(user) && !I.is_held())
		to_chat(user, SPAN_WARNING("You should hold 69I69 in hands for doing that!"))
		return
	var/apply_type = CS.apply(I, user, null, src)
	if(!apply_type)
		return

	var/obj/item/CR
	if(steps.len <= 1)
		CR = new result(null)
		switch(dir_type)
			if(CRAFT_WITH_USER_DIR)  // spawn the result in the user's direction
				CR.dir = user.dir
			if(CRAFT_TOWARD_USER)  // spawn the result towards the user
				CR.dir = reverse_dir69user.dir69
			else  // spawn the result in its default direction
				CR.dir = dir_default
		CR.Created(user)
	else
		CR = new /obj/item/craft (null, src)
		var/obj/item/craft/CO = CR
		if(apply_type == IS_READY)
			CO.step++
		else if(apply_type == IN_PROGRESS)
			CS.craft_items69CO69 = CS.req_amount - 1
		CO.update()
	if(flags & CRAFT_ON_FLOOR)
		CR.forceMove(user.loc,69OVED_DROP)
	else
		user.put_in_hands(CR)
	return CR

