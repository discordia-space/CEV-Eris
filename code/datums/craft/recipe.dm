/datum/craft_recipe
	var/name
	var/category = "Misc"
	var/icon_state = "device"
	var/result

	var/list/steps
	var/flags = CRAFT_ONE_PER_TURF

/datum/craft_recipe/New()
	var/step_definations = steps
	steps = new
	for(var/i in step_definations)
		steps += new /datum/craft_step(i)


/datum/craft_recipe/proc/is_compelete(step)
	return steps.len < step


/datum/craft_recipe/proc/spawn_result(obj/item/craft/C, mob/living/user)
	var/atom/movable/M = new result(get_turf(C))
	var/slot = user.get_inventory_slot(C)
	qdel(C)
	if(! (flags & CRAFT_ON_FLOOR) && (slot in list(slot_r_hand, slot_l_hand)))
		user.put_in_hands(M)


/datum/craft_recipe/proc/get_description(pass_steps)
	. = list()
	for(var/item in steps)
		if(pass_steps > 0)
			--pass_steps
			continue
		var/datum/craft_step/CS = item
		. += CS.desc
	return jointext(., "<br>")


/datum/craft_recipe/proc/can_build(obj/item/I, mob/living/user)
	if(flags & (CRAFT_ONE_PER_TURF|CRAFT_ON_FLOOR))
		if(locate(result) in get_turf(I))
			user << SPAN_WARNING("You can't create more [name] here!")
			return FALSE
	return TRUE


/datum/craft_recipe/proc/try_step(step, I, user, obj/item/craft/target)
	if(!can_build(I, user))
		return FALSE
	var/datum/craft_step/CS = steps[step]
	return CS.apply(I, user, target)


/datum/craft_recipe/proc/try_build(mob/living/user)
	var/datum/craft_step/CS = steps[1]
	var/obj/item/I = CS.find_item(user)

	if(!I)
		user << SPAN_WARNING("You can't find required item!")
		return

	world << "Found required item"
	//Robots can craft things on the floor
	if(ishuman(user) && !I.is_held() && !user.put_in_hands(I))
		user << SPAN_WARNING("You should hold [I] in hands for doing that!")
		return

	if(!CS.apply(I, user))
		return

	var/obj/item/CR
	if(steps.len <= 1)
		CR = new result(null)
	else
		CR = new /obj/item/craft (null, src)
	if(flags & CRAFT_ON_FLOOR)
		CR.forceMove(user.loc, MOVED_DROP)
	else
		user.put_in_hands(CR)
