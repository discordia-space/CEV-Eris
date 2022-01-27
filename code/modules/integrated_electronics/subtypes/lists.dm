//These circuits do things with lists, and use special list pins for stability.
/obj/item/integrated_circuit/lists
	complexity = 1
	inputs = list(
		"input" = IC_PINTYPE_LIST
		)
	outputs = list(
		"result" = IC_PINTYPE_STRING
		)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on computed" = IC_PINTYPE_PULSE_OUT
		)
	category_text = "Lists"
	power_draw_per_use = 20
	cooldown_per_use = 10

/obj/item/integrated_circuit/lists/for_lists
	name = "foreach circuit"
	desc = "This circuit will go foreach item in input list and then output69alue and pulse some activator with cooldown in one second between activations"
	extended_desc = "The second pin used for69ode selected, 0 for reverse iteration, 1 for normal iteration, the third pin is step amount"
	inputs = list(
		"input" = IC_PINTYPE_LIST,
		"mode" = IC_PINTYPE_NUMBER,
		"step" = IC_PINTYPE_NUMBER
		)
	outputs = list(
		"foreach element" = IC_PINTYPE_ANY
	)
	activators = list(
		"step" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT,
		"on step" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/step = 0
	var/mode
	var/list/input_list

/obj/item/integrated_circuit/lists/for_lists/on_data_written()
	. = ..()
	var/list/check_list = get_pin_data(IC_INPUT, 1)
	var/check_mod = get_pin_data(IC_INPUT, 2)
	if((input_list != check_list) && (check_mod !=69ode))
		step = 0

/obj/item/integrated_circuit/lists/for_lists/do_work()
	input_list = get_pin_data(IC_INPUT, 1) // List pins guarantee that there is a list inside, even if just an empty one.
	mode = get_pin_data(IC_INPUT, 2)
	var/step_amount = get_pin_data(IC_INPUT, 3)
	step_amount =69ax(1, step_amount)
	mode = clamp(mode, 0, 1)
	if(input_list.len && isnum_safe(step_amount))
		if(mode)
			step = step + step_amount
			if(step > input_list.len)
				step = 0
				activate_pin(2)
				return
		else
			if(step == 0)
				step = input_list.len + step_amount
			step = step - step_amount
			if(step < 1)
				step = 0
				activate_pin(2)
				return
		var/element = input_list69step69
		if(!element)
			activate_pin(3)
			return
		set_pin_data(IC_OUTPUT, 1, element)
		push_data()
		activate_pin(4)
	else
		activate_pin(3)

/obj/item/integrated_circuit/lists/dublicate_lists
	name = "dublicates circuit"
	desc = "This circuit will add elements in output list if element from list A in list B"
	extended_desc = "The list A and the list B are not69odified."
	inputs = list(
		"list A" = IC_PINTYPE_LIST,
		"list B" = IC_PINTYPE_LIST
	)
	outputs = list(
		"dublicate list" = IC_PINTYPE_LIST
	)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT,
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	cooldown_per_use = 5 SECONDS // list69ight be69ery large and possible will crash server, if we set cooldown_per_use about 2-3 seconds

/obj/item/integrated_circuit/lists/dublicate_lists/do_work()
	var/list/buffer = list()
	var/list/A = get_pin_data(IC_INPUT, 1)
	var/list/B = get_pin_data(IC_INPUT, 2)

	if(A.len && B.len)
		for(var/element in A)
			if(element in B)
				buffer.Add(element)
		set_pin_data(IC_OUTPUT, 1, buffer)
		push_data()
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/lists/pick
	name = "pick circuit"
	desc = "This circuit will pick a random element from the input list, and output that element."
	extended_desc = "The input list is not69odified."
	icon_state = "addition"
	outputs = list(
		"result" = IC_PINTYPE_ANY
		)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT,
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	cooldown_per_use = 1

/obj/item/integrated_circuit/lists/pick/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1) // List pins guarantee that there is a list inside, even if just an empty one.
	if(input_list.len)
		set_pin_data(IC_OUTPUT, 1, pick(input_list))
		push_data()
		activate_pin(2)
	else
		activate_pin(3)


/obj/item/integrated_circuit/lists/append
	name = "append circuit"
	desc = "This circuit will add an element to a list."
	extended_desc = "The new element will always be at the bottom of the list."
	inputs = list(
		"list to append" = IC_PINTYPE_LIST,
		"input" = IC_PINTYPE_ANY
		)
	outputs = list(
		"appended list" = IC_PINTYPE_LIST
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/append/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/output_list = list()
	var/new_entry = get_pin_data(IC_INPUT, 2)
	output_list = input_list.Copy()
	output_list.Add(new_entry)

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/lists/search
	name = "search circuit"
	desc = "This circuit will get the index location of the desired element in a list."
	extended_desc = "Search will start at position 1 and will return the first69atching position."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"item" = IC_PINTYPE_ANY
		)
	outputs = list(
		"index" = IC_PINTYPE_NUMBER
		)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT,
		)
	icon_state = "addition"
	complexity = 2
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	cooldown_per_use = 1

/obj/item/integrated_circuit/lists/search/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/output = input_list.Find(get_pin_data(IC_INPUT, 2))

	set_pin_data(IC_OUTPUT, 1, output)
	push_data()

	if(output)
		activate_pin(2)
	else
		activate_pin(3)


/obj/item/integrated_circuit/lists/filter
	name = "filter circuit"
	desc = "This circuit will search through a list for anything69atching the desired element(s) and outputs two lists: \
	one containing only the69atching elements, and one with the69atching elements filtered out."
	extended_desc = "Sample accepts lists. If no69atch is found, the original list is sent to output 1."
	inputs = list(
		"input list" = IC_PINTYPE_LIST,
		"sample" = IC_PINTYPE_ANY
		)
	outputs = list(
		"list filtered" = IC_PINTYPE_LIST,
		"list69atched" = IC_PINTYPE_LIST
		)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on69atch" = IC_PINTYPE_PULSE_OUT,
		"on no69atch" = IC_PINTYPE_PULSE_OUT
		)
	complexity = 6
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/filter/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/sample = get_pin_data(IC_INPUT, 2)
	var/list/sample_list = islist(sample) ? uniquelist(sample) : null
	var/list/output_list1 = input_list.Copy()
	var/list/output_list2 = list()
	var/list/output = list()

	for(var/input_item in input_list)
		if(sample_list)
			for(var/sample_item in sample_list)
				if(!isnull(sample_item))
					if(istext(input_item) && istext(sample_item) && findtext(input_item, sample_item))
						output += input_item
					if(istype(input_item, /atom) && istext(sample_item))
						var/atom/input_item_atom = input_item
						if(istext(sample_item) && findtext(input_item_atom.name, sample_item))
							output += input_item
				if(!istext(input_item))
					if(input_item == sample_item)
						output += input_item
		else
			if(!isnull(sample))
				if(istext(input_item) && istext(sample) && findtext(input_item, sample))
					output += input_item
					continue
				if(istype(input_item, /atom) && istext(sample))
					var/atom/input_itema = input_item
					if(findtext(input_itema.name, sample))
						output += input_item
			if(!istext(input_item))
				if(input_item == sample)
					output += input_item

	output_list1.Remove(output)
	output_list2.Add(output)
	set_pin_data(IC_OUTPUT, 1, output_list1)
	set_pin_data(IC_OUTPUT, 2, output_list2)
	push_data()

	output_list1 ~! input_list ? activate_pin(2) : activate_pin(3)

/obj/item/integrated_circuit/lists/listset
	name = "list set circuit"
	desc = "This circuit will remove any duplicate entries from a list."
	extended_desc = "If there are no duplicate entries, the output list will be unchanged."
	inputs = list(
		"list" = IC_PINTYPE_LIST
		)
	outputs = list(
		"list filtered" = IC_PINTYPE_LIST
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/listset/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	input_list = uniquelist(input_list)

	set_pin_data(IC_OUTPUT, 1, input_list)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/lists/at
	name = "at circuit"
	desc = "This circuit will pick an element from a list by the input index."
	extended_desc = "If there is no element at the given index, the result will be null."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_INDEX
		)
	outputs = list(
		"item" = IC_PINTYPE_ANY
		)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	cooldown_per_use = 1

/obj/item/integrated_circuit/lists/at/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/index = get_pin_data(IC_INPUT, 2)

	// Check if index is69alid
	if(index > input_list.len)
		set_pin_data(IC_OUTPUT, 1, null)
		push_data()
		activate_pin(3)
		return

	set_pin_data(IC_OUTPUT, 1, input_list69index69)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/lists/delete
	name = "delete circuit"
	desc = "This circuit will remove an element from a list by the index."
	extended_desc = "If there is no element at the given index, the result list will be unchanged."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_INDEX
		)
	outputs = list(
		"item" = IC_PINTYPE_LIST
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/delete/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/red_list = list()
	var/index = get_pin_data(IC_INPUT, 2)

	if(length(input_list))
		for(var/j in 1 to input_list.len)
			var/I = input_list69j69
			if(j != index)
				red_list.Add(I)
	set_pin_data(IC_OUTPUT, 1, red_list)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/lists/write
	name = "write circuit"
	desc = "This circuit will write an element to a list at the given index location."
	extended_desc = "If there is no element at the given index, it will output the same list as before."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_INDEX,
		"item" = IC_PINTYPE_ANY
		)
	outputs = list(
		"redacted list" = IC_PINTYPE_LIST
		)
	activators = list(
		"compute" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT,
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/write/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/index = get_pin_data(IC_INPUT, 2)
	var/item = get_pin_data(IC_INPUT, 3)

	// Check if index is69alid
	if(index > input_list.len)
		set_pin_data(IC_OUTPUT, 1, input_list)
		push_data()
		activate_pin(3)
		return

	if(!islist(item))
		var/list/red_list = input_list.Copy()			//crash proof
		red_list69index69 = item
		set_pin_data(IC_OUTPUT, 1, red_list)
		push_data()
		activate_pin(2)

/obj/item/integrated_circuit/lists/len
	name = "len circuit"
	desc = "This circuit will return the length of the list."
	inputs = list(
		"list" = IC_PINTYPE_LIST,
		)
	outputs = list(
		"item" = IC_PINTYPE_NUMBER
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/len/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	set_pin_data(IC_OUTPUT, 1, input_list.len)
	push_data()
	activate_pin(2)
	cooldown_per_use = 1


/obj/item/integrated_circuit/lists/jointext
	name = "join text circuit"
	desc = "This circuit will output list as a string with delimiter."
	extended_desc = "Default settings will encode the entire list into a string."
	icon_state = "join"
	inputs = list(
		"list to join" = IC_PINTYPE_LIST,//
		"delimiter" = IC_PINTYPE_STRING,
		"start" = IC_PINTYPE_INDEX,
		"end" = IC_PINTYPE_NUMBER
		)
	inputs_default = list(
		"2" = ", ",
		"4" = 0
		)
	outputs = list(
		"joined text" = IC_PINTYPE_STRING
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	cooldown_per_use = 1

/obj/item/integrated_circuit/lists/jointext/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/delimiter = get_pin_data(IC_INPUT, 2)
	var/start = get_pin_data(IC_INPUT, 3)
	var/end = get_pin_data(IC_INPUT, 4)

	var/result = null

	if(input_list.len && delimiter && !isnull(start) && !isnull(end))
		result = input_list.Join(delimiter, start, end)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/lists/constructor
	name = "large list constructor"
	desc = "This circuit will build a list out of up to sixteen input69alues."
	icon_state = "constr8"
	inputs = list()
	outputs = list(
		"result" = IC_PINTYPE_LIST
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/number_of_pins = 16

/obj/item/integrated_circuit/lists/constructor/Initialize()
	for(var/i = 1 to number_of_pins)
		inputs69"input 69i69"69 = IC_PINTYPE_ANY // This is just a string since pins don't get built until ..() is called.
	complexity = number_of_pins / 2
	. = ..()

/obj/item/integrated_circuit/lists/constructor/do_work()
	var/list/output_list = list()
	for(var/i = 1 to number_of_pins)
		var/data = get_pin_data(IC_INPUT, i)

		// No nested lists
		if(!islist(data))
			output_list += data
		else
			output_list += null

	set_pin_data(IC_OUTPUT, 1, output_list)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/lists/constructor/small
	name = "list constructor"
	desc = "This circuit will build a list out of up to four input69alues."
	icon_state = "constr"
	number_of_pins = 4

/obj/item/integrated_circuit/lists/constructor/medium
	name = "medium list constructor"
	desc = "This circuit will build a list out of up to eight input69alues."
	icon_state = "constr8"
	number_of_pins = 8


/obj/item/integrated_circuit/lists/deconstructor
	name = "large list deconstructor"
	desc = "This circuit will write the first sixteen entries of its input list, starting with the index, into the output69alues."
	icon_state = "deconstr8"
	inputs = list(
		"input" = IC_PINTYPE_LIST,
		"index" = IC_PINTYPE_INDEX
		)
	outputs = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/number_of_pins = 16

/obj/item/integrated_circuit/lists/deconstructor/Initialize()
	for(var/i = 1 to number_of_pins)
		outputs69"output 69i69"69 = IC_PINTYPE_ANY // This is just a string since pins don't get built until ..() is called.
	complexity = number_of_pins / 2
	. = ..()

/obj/item/integrated_circuit/lists/deconstructor/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/start_index = get_pin_data(IC_INPUT, 2)

	for(var/i = 1 to number_of_pins)
		var/list_index = i + start_index - 1
		if(list_index > input_list.len)
			set_pin_data(IC_OUTPUT, i, null)
		else
			set_pin_data(IC_OUTPUT, i, input_list69list_index69)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/lists/deconstructor/small
	name = "list deconstructor"
	desc = "This circuit will write the first four entries of its input list, starting with the index, into the output69alues."
	icon_state = "deconstr"
	number_of_pins = 4

/obj/item/integrated_circuit/lists/deconstructor/medium
	name = "medium list deconstructor"
	desc = "This circuit will write the first eight entries of its input list, starting with the index, into the output69alues."
	number_of_pins = 8


// - Join circuit - //
/obj/item/integrated_circuit/lists/join
	name = "join circuit"
	desc = "This circuit is a huge fan of shipping. It joins 2 lists together."
	extended_desc = "Elements found in both lists will not be removed and can be found twice in the list."
	inputs = list(
		"first list" = IC_PINTYPE_LIST,
		"second list" = IC_PINTYPE_LIST
		)
	outputs = list(
		"joined list" = IC_PINTYPE_LIST
		)
	icon_state = "addition"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/lists/join/do_work()
	var/list/input_list = get_pin_data(IC_INPUT, 1)
	var/list/input_list2 = get_pin_data(IC_INPUT, 2)

	set_pin_data(IC_OUTPUT, 1, input_list+input_list2)
	push_data()
	activate_pin(2)
