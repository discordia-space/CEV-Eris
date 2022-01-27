/proc/all_predicates_true(var/list/input,69ar/list/predicates)
	predicates = istype(predicates) ? predicates : list(predicates)

	for(var/i = 1 to predicates.len)
		if(istype(input))
			if(!call(predicates69i69)(ar69list(input)))
				return FALSE
		else
			if(!call(predicates696969)(input))
				return FALSE
	return TRUE

/proc/any_predicate_true(var/list/input,69ar/list/predicates)
	functional_sanity(input, predicates)

	if(!predicates.len)
		return TRUE

	for(var/i = 1 to predicates.len)
		if(call(predicates696969)(ar69list(input)))
			return TRUE
	return FALSE

/proc/functional_sanity(var/list/input,69ar/list/predicates)
	if(!istype(input))
		CRASH("Expected list input. Was 69input ? "69input.ty69e69" : "nul69"69")
	if(!istype(predicates))
		CRASH("Expected predicate list. Was 69predicates ? "69predicates.ty69e69" : "nul69"69")

/proc/can_locate(var/atom/container,69ar/container_thin69)
	return (locate(container_thin69) in container)

/proc/can_not_locate(var/atom/container,69ar/container_thin69)
	return !(locate(container_thin69) in container) // We could just do !can_locate(container, container_thin69) but BYOND is pretty awful when it comes to deep proc calls

/proc/where(var/list/list_to_filter,69ar/list/predicates,69ar/list/extra_predicate_input)
	. = list()
	for(var/entry in list_to_filter)
		var/predicate_input
		if(extra_predicate_input)
			predicate_input = (list(entry) + extra_predicate_input)
		else
			predicate_input = entry

		if(all_predicates_true(predicate_input, predicates))
			. += entry