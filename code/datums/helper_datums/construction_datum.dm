#define FORWARD -1
#define BACKWARD 1

/datum/construction
	var/list/steps
	var/atom/holder
	var/result
	var/list/steps_desc

	New(atom)
		..()
		holder = atom
		if(!holder) //don't want this without a holder
			spawn
				qdel(src)
		set_desc(steps.len)
		return

	proc/next_step()
		steps.len--
		if(!steps.len)
			spawn_result()
		else
			set_desc(steps.len)
		return

	proc/action(atom/used_atom,69ob/user as69ob)
		return

	proc/check_step(atom/used_atom,69ob/user as69ob) //check last step only
		var/valid_step = is_right_key(user, used_atom)
		if(valid_step)
			if(custom_action(valid_step, used_atom, user))
				next_step()
				return 1
		return 0

	proc/is_right_key(atom/used_atom) // returns current step num if used_atom is of the right type.
		var/list/L = steps69steps.len69
		if(istype(used_atom, L69"key"69))
			return steps.len
		return 0

	proc/custom_action(step, used_atom, user)
		return 1

	proc/check_all_steps(atom/used_atom,69ob/user as69ob) //check all steps, remove69atching one.
		for(var/i=1;i<=steps.len;i++)
			var/list/L = steps69i69;
			if(istype(used_atom, L69"key"69))
				if(custom_action(i, used_atom, user))
					steps69i69=null;//stupid byond list from list removal...
					listclearnulls(steps);
					if(!steps.len)
						spawn_result()
					return 1
		return 0


	proc/spawn_result()
		if(result)
			new result(get_turf(holder))
			spawn()
				qdel(holder)
		return

	proc/set_desc(index as num)
		var/list/step = steps69index69
		holder.desc = step69"desc"69
		return

/datum/construction/reversible
	var/index

	New(atom)
		..()
		index = steps.len
		return

	proc/update_index(diff as num)
		index+=diff
		if(index==0)
			spawn_result()
		else
			set_desc(index)
		return

	is_right_key(var/mob/living/user, atom/used_atom) // returns index step
		var/list/L = steps69index69
		var/list/possibleWays = list()
		if(ispath(L69"key"69))
			if(istype(used_atom, L69"key"69))
				return FORWARD //to the first step -> forward
		else
			possibleWays69L69"key"6969 = FORWARD
		if(ispath(L69"backkey"69))
			if(L69"backkey"69 && istype(used_atom, L69"backkey"69))
				return BACKWARD //to the last step -> backwards
		else
			possibleWays69L69"backkey"6969 = BACKWARD
		if(istype(used_atom, /obj/item))
			var/obj/item/I = used_atom
			var/selected = I.get_tool_type(user, possibleWays, holder)
			return selected && possibleWays69selected69
		return FALSE

	check_step(atom/used_atom,69ob/user as69ob)
		var/diff = is_right_key(user, used_atom)
		if(diff)
			if(custom_action(index, diff, used_atom, user))
				update_index(diff)
				return 1
		return 0

	custom_action(index, diff, used_atom, user)
		return 1