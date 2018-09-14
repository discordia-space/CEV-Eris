/datum/craft_step
	var/reqed_type
	var/reqed_quality
	var/req_amount = 0

	var/time = 15

	var/desc = ""
	var/start_msg = ""
	var/end_msg = ""


/datum/craft_step/New(var/list/params)
	if(ispath(params))
		reqed_type    = params
	else if(istext(params))
		reqed_quality = params
	else if(islist(params))
		var/validator = params[1]
		if(ispath(validator))
			reqed_type = validator
		else if(istext(validator))
			reqed_quality = validator

		if(isnum(params[2])) //amount
			req_amount = params[2]

		if("time" in params)
			time = params["time"]
		else if(params.len >= 3)
			time = params[3]

	var/tool_name

	if(reqed_type)
		var/obj/item/I = reqed_type
		tool_name = initial(I.name)

	else if(reqed_quality)
		tool_name = "tool with quality of [reqed_quality]"

	switch(req_amount)
		if(0)
			desc = "Apply [tool_name]"
			start_msg = "%USER% starts use %ITEM% on %TARGET%"
			end_msg = "%USER% applied %ITEM% to %TARGET%"
		if(1)
			desc = "Attach [tool_name]"
			start_msg = "%USER% starts attaching %ITEM% to %TARGET%"
			end_msg = "%USER% attached %ITEM% to %TARGET%"
		else
			desc = "Attach [req_amount] [tool_name]"
			start_msg = "%USER% starts attaching %ITEM% to %TARGET%"
			end_msg = "%USER% attached %ITEM% to %TARGET%"


/datum/craft_step/proc/annonce_action(var/msg, mob/living/user, obj/item/tool, atom/target)
	msg = replacetext(msg,"%USER%","[user]")
	msg = replacetext(msg,"%ITEM%","[tool]")
	msg = replacetext(msg,"%TARGET%","[target]")
	user.visible_message(
		msg
	)

/datum/craft_step/proc/apply(obj/item/I, mob/living/user, atom/target = null)
	if(reqed_type)
		if(!istype(I, reqed_type))
			user << "Wrong item!"
			return
		if(req_amount && ispath(reqed_type, /obj/item/stack))
			var/obj/item/stack/S = I
			if(S.amount < req_amount)
				user << "Not enought items in [I]"
				return
		if(target)
			annonce_action(start_msg, user, I, target)
		if(!do_after(user, time, target || user))
			return
	else if(reqed_quality)
		if(!I.get_tool_quality(reqed_quality))
			user << "Wrong item!"
			return
		if(target)
			annonce_action(start_msg, user, I, target)
		if(!I.use_tool(user, target || user, time, reqed_quality))
			return

	if(req_amount)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			if(!S.use(req_amount))
				return FALSE
		else
			qdel(I)

	if(target)
		annonce_action(end_msg, user, I, target)

	return TRUE

/datum/craft_step/proc/find_item(mob/living/user)
	var/list/items = new
	for(var/slot in list(slot_l_hand, slot_r_hand))
		items += user.get_equipped_item(slot)

	var/obj/item/weapon/storage/belt = user.get_equipped_item(slot_belt)
	if(istype(belt))
		items += belt.contents

	if(reqed_type)
		return locate(reqed_type) in items
	else if(reqed_quality)
		var/best_value = 0
		for(var/obj/item/I in items)
			var/value = I.get_tool_quality(reqed_quality)
			if(value > best_value)
				value = best_value
				. = I

