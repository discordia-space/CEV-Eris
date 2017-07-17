
/datum/unit_test/integrated_circuits
	name = "circuit template"
	var/circuit_type = null
	var/obj/item/integrated_circuit/IC = null
	var/list/inputs_to_give = list()
	var/list/expected_outputs = list()

// Use this to set up.
/datum/unit_test/integrated_circuits/proc/arrange()
	IC = new circuit_type(get_standard_turf()) // Make the circuit
	IC.cooldown_per_use = 0

// Use this when finished to remove clutter for the next test.
/datum/unit_test/integrated_circuits/proc/clean_up()
	qdel(IC)

// Override this if needing special output (e.g. rounding to avoid floating point fun).
/datum/unit_test/integrated_circuits/proc/assess()
	var/output_wrong = FALSE
	var/i = 1
	for(var/datum/integrated_io/io in IC.outputs)
		if(io.data != expected_outputs[i])
			log_bad("[io.name] did not match expected output of [expected_outputs[i]].  Output was [isnull(io.data) ? "NULL" : io.data].")
			output_wrong = TRUE
		i++
	return output_wrong

// Useful when doing floating point fun.
/datum/unit_test/integrated_circuits/floor/assess()
	var/output_wrong = FALSE
	var/i = 1
	for(var/datum/integrated_io/io in IC.outputs)
		if(round(io.data) != expected_outputs[i])
			log_bad("[io.name] did not match expected output of [expected_outputs[i]].  Output was [isnull(io.data) ? "NULL" : round(io.data)].")
			output_wrong = TRUE
		i++
	return output_wrong

/datum/unit_test/integrated_circuits/start_test()
	var/output_wrong = FALSE
	if(!circuit_type)
		fail("[name] did not supply a circuit_type path.")
		return TRUE
	try
		// Arrange
		arrange()

		var/i = 1
		for(var/input in inputs_to_give)
			var/datum/integrated_io/io = IC.inputs[i]
			io.write_data_to_pin(input)
			i++

		// Act
		IC.do_work()

		output_wrong = assess()

		clean_up()

	catch(var/exception/e)
		log_bad("[name] caught an exception: [e] on [e.file]:[e.line]")
		output_wrong = TRUE

	// Assert
	if(output_wrong)
		fail("[name] failed.")
		return TRUE
	else
		pass("[name] matched all expected outputs.")
		return TRUE

