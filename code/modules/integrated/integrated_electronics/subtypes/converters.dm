//These circuits convert one variable to another.
/obj/item/integrated_circuit/converter
	complexity = 2
	inputs = list("input")
	outputs = list("output")
	activators = list("\<PULSE IN\> convert", "\<PULSE OUT\> on convert")
	category_text = "Converter"
	autopulse = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/converter/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

/obj/item/integrated_circuit/converter/num2text
	name = "number to string"
	desc = "This circuit can convert a number variable into a string."
	icon_state = "num-string"
	inputs = list("\<NUM\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/num2text/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && isnum(incoming))
		result = num2text(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/text2num
	name = "string to number"
	desc = "This circuit can convert a string variable into a number."
	icon_state = "string-num"
	inputs = list("\<TEXT\> input")
	outputs = list("\<NUM\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/text2num/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && istext(incoming))
		result = text2num(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/ref2text
	name = "reference to string"
	desc = "This circuit can convert a reference to something else to a string, specifically the name of that reference."
	icon_state = "ref-string"
	inputs = list("\<REF\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/ref2text/do_work()
	var/result = null
	pull_data()
	var/atom/A = get_pin_data(IC_INPUT, 1)
	if(A && istype(A))
		result = A.name

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/lowercase
	name = "lowercase string converter"
	desc = "this will cause a string to come out in all lowercase."
	icon_state = "lowercase"
	inputs = list("\<TEXT\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/lowercase/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && istext(incoming))
		result = lowertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/uppercase
	name = "uppercase string converter"
	desc = "THIS WILL CAUSE A STRING TO COME OUT IN ALL UPPERCASE."
	icon_state = "uppercase"
	inputs = list("\<TEXT\> input")
	outputs = list("\<TEXT\> output")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/uppercase/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && istext(incoming))
		result = uppertext(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/concatenatior
	name = "concatenatior"
	desc = "This joins many strings or numbers together to get one big string."
	complexity = 4
	inputs = list(
		"\<TEXT/NUM\> A",
		"\<TEXT/NUM\> B",
		"\<TEXT/NUM\> C",
		"\<TEXT/NUM\> D",
		"\<TEXT/NUM\> E",
		"\<TEXT/NUM\> F",
		"\<TEXT/NUM\> G",
		"\<TEXT/NUM\> H"
		)
	outputs = list("\<TEXT\> result")
	activators = list("\<PULSE IN\> concatenate", "\<PULSE OUT\> on concatenated")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/concatenatior/do_work()
	var/result = null
	for(var/datum/integrated_io/input/I in inputs)
		I.pull_data()
		if(istext(I.data))
			result += I.data
		else if(!isnull(I.data) && num2text(I.data))
			result += num2text(I.data)

		if(length(result) >= IC_MAX_STRING_SIZE)
			break

	var/datum/integrated_io/outgoing = outputs[1]
	outgoing.data = copytext(result, 1, IC_MAX_STRING_SIZE)
	outgoing.push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/radians2degrees
	name = "radians to degrees converter"
	desc = "Converts radians to degrees."
	inputs = list("\<NUM\> radian")
	outputs = list("\<NUM\> degrees")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/radians2degrees/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && isnum(incoming))
		result = TODEGREES(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/converter/degrees2radians
	name = "degrees to radians converter"
	desc = "Converts degrees to radians."
	inputs = list("\<NUM\> degrees")
	outputs = list("\<NUM\> radians")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/degrees2radians/do_work()
	var/result = null
	pull_data()
	var/incoming = get_pin_data(IC_INPUT, 1)
	if(incoming && isnum(incoming))
		result = TORADIANS(incoming)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


/obj/item/integrated_circuit/converter/abs_to_rel_coords
	name = "abs to rel coordinate converter"
	desc = "Easily convert absolute coordinates to relative coordinates with this."
	complexity = 4
	inputs = list("\<NUM\> X1", "\<NUM\> Y1", "\<NUM\> X2", "\<NUM\> Y2")
	outputs = list("\<NUM\> X", "\<NUM\> Y")
	activators = list("\<PULSE IN\> compute rel coordinates", "\<PULSE OUT\> on convert")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/converter/abs_to_rel_coords/do_work()
	var/x1 = get_pin_data(IC_INPUT, 1)
	var/y1 = get_pin_data(IC_INPUT, 2)

	var/x2 = get_pin_data(IC_INPUT, 3)
	var/y2 = get_pin_data(IC_INPUT, 4)

	if(x1 && y1 && x2 && y2)
		set_pin_data(IC_OUTPUT, 1, x1 - x2)
		set_pin_data(IC_OUTPUT, 2, y1 - y2)

	push_data()
	activate_pin(2)