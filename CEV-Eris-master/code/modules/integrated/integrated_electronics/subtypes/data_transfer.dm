/obj/item/integrated_circuit/transfer
	category_text = "Data Transfer"
	autopulse = 1
	power_draw_per_use = 2

/obj/item/integrated_circuit/transfer/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

/obj/item/integrated_circuit/transfer/splitter
	name = "splitter"
	desc = "Splits incoming data into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	inputs = list("data to split")
	outputs = list("A","B")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/transfer/splitter/medium
	name = "four splitter"
	icon_state = "splitter4"
	complexity = 5
	outputs = list("A","B","C","D")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/transfer/splitter/large
	name = "eight splitter"
	icon_state = "splitter8"
	w_class = ITEM_SIZE_SMALL
	complexity = 9
	outputs = list("A","B","C","D","E","F","G","H")
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 8

/obj/item/integrated_circuit/transfer/splitter/do_work()
	var/datum/integrated_io/I = inputs[1]
	for(var/datum/integrated_io/output/O in outputs)
		O.data = I.data

/obj/item/integrated_circuit/transfer/activator_splitter
	name = "activator splitter"
	desc = "Splits incoming activation pulses into all of the output pins."
	icon_state = "splitter"
	complexity = 3
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B"
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 2

/obj/item/integrated_circuit/transfer/activator_splitter/do_work()
	for(var/datum/integrated_io/activate/A in outputs)
		if(A == activators[1])
			continue
		if(A.linked.len)
			for(var/datum/integrated_io/activate/target in A.linked)
				target.holder.check_then_do_work()

/obj/item/integrated_circuit/transfer/activator_splitter/medium
	name = "four activator splitter"
	icon_state = "splitter4"
	complexity = 5
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B",
		"outgoing pulse C",
		"outgoing pulse D"
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/transfer/activator_splitter/large
	name = "eight activator splitter"
	icon_state = "splitter4"
	w_class = ITEM_SIZE_SMALL
	complexity = 9
	activators = list(
		"incoming pulse",
		"outgoing pulse A",
		"outgoing pulse B",
		"outgoing pulse C",
		"outgoing pulse D",
		"outgoing pulse E",
		"outgoing pulse F",
		"outgoing pulse G",
		"outgoing pulse H"
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 8


/obj/item/integrated_circuit/transfer/multiplexer
	name = "two multiplexer"
	desc = "This is what those in the business tend to refer to as a 'mux' or data selector. It moves data from one of the selected inputs to the output."
	extended_desc = "The first input pin is used to select which of the other input pins which has its data moved to the output. If the input selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "mux2"
	inputs = list("input selection")
	outputs = list("output")
	activators = list("select")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4
	var/number_of_inputs = 2

/obj/item/integrated_circuit/transfer/multiplexer/New()
	for(var/i = 1 to number_of_inputs)
		inputs += "input [i]"
	complexity = number_of_inputs
	..()
	desc += " It has [number_of_inputs] input pins."
	extended_desc += " This multiplexer has a range from 1 to [inputs.len - 1]."

/obj/item/integrated_circuit/transfer/multiplexer/do_work()
	var/input_index = get_pin_data(IC_INPUT, 1)
	var/output = null

	if(isnum(input_index) && (input_index >= 1 && input_index < inputs.len))
		output = get_pin_data(IC_INPUT, input_index + 1)
	set_pin_data(IC_OUTPUT, 1, output)

/obj/item/integrated_circuit/transfer/multiplexer/medium
	name = "four multiplexer"
	number_of_inputs = 4
	icon_state = "mux4"

/obj/item/integrated_circuit/transfer/multiplexer/large
	name = "eight multiplexer"
	number_of_inputs = 8
	w_class = ITEM_SIZE_SMALL
	icon_state = "mux8"

/obj/item/integrated_circuit/transfer/multiplexer/huge
	name = "sixteen multiplexer"
	icon_state = "mux16"
	w_class = ITEM_SIZE_SMALL
	number_of_inputs = 16

/obj/item/integrated_circuit/transfer/demultiplexer
	name = "two demultiplexer"
	desc = "This is what those in the business tend to refer to as a 'demux'. It moves data from the input to one of the selected outputs."
	extended_desc = "The first input pin is used to select which of the output pins is given the data from the second input pin. If the output selection is outside the valid range then no output is given."
	complexity = 2
	icon_state = "dmux2"
	inputs = list("output selection","input")
	outputs = list()
	activators = list("select")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4
	var/number_of_outputs = 2

/obj/item/integrated_circuit/transfer/demultiplexer/New()
	for(var/i = 1 to number_of_outputs)
		outputs += "output [i]"
	complexity = number_of_outputs

	..()
	desc += " It has [number_of_outputs] output pins."
	extended_desc += " This demultiplexer has a range from 1 to [outputs.len]."

/obj/item/integrated_circuit/transfer/demultiplexer/do_work()
	var/output_index = get_pin_data(IC_INPUT, 1)
	var/output = get_pin_data(IC_INPUT, 2)

	for(var/i = 1 to outputs.len)
		set_pin_data(IC_OUTPUT, i, i == output_index ? output : null)

/obj/item/integrated_circuit/transfer/demultiplexer/medium
	name = "four demultiplexer"
	icon_state = "dmux4"
	number_of_outputs = 4

/obj/item/integrated_circuit/transfer/demultiplexer/large
	name = "eight demultiplexer"
	icon_state = "dmux8"
	w_class = ITEM_SIZE_SMALL
	number_of_outputs = 8

/obj/item/integrated_circuit/transfer/demultiplexer/huge
	name = "sixteen demultiplexer"
	icon_state = "dmux16"
	w_class = ITEM_SIZE_SMALL
	number_of_outputs = 16