// Helpers for saving/loading integrated circuits.


// Saves type,69odified name and69odified inputs (if any) to a list
// The list is converted to JSON down the line.
//"Special" is not69erified at any point except for by the circuit itself.
/obj/item/integrated_circuit/proc/save()
	var/list/component_params = list()
	var/init_name = initial(name)

	// Save initial name used for differentiating assemblies
	component_params69"type"69 = init_name

	// Save the69odified name.
	if(init_name != displayed_name)
		component_params69"name"69 = displayed_name

	// Saving input69alues
	if(length(inputs))
		var/list/saved_inputs = list()

		for(var/index in 1 to inputs.len)
			var/datum/integrated_io/input = inputs69index69

			// Don't waste space saving the default69alues
			if(input.data == inputs_default69"69index69"69)
				continue
			if(input.data == initial(input.data))
				continue

			var/input_data = input.data

			if(istext(input_data))
				input_data = html_encode(html_decode(input.data))

			var/list/input_value = list(index, FALSE, input_data)
			// Index, Type,69alue
			// FALSE is default type used for num/text/list/null
			// TODO: support for special input types, such as internal refs and69aybe typepaths

			if(islist(input.data) || isnum_safe(input.data) || istext(input.data) || isnull(input.data))
				saved_inputs.Add(list(input_value))

		if(saved_inputs.len)
			component_params69"inputs"69 = saved_inputs

	var/special = save_special()
	if(!isnull(special))
		component_params69"special"69 = special

	return component_params

/obj/item/integrated_circuit/proc/save_special()
	return

//69erifies a list of component parameters
// Returns null on success, error name on failure
/obj/item/integrated_circuit/proc/verify_save(list/component_params)
	var/init_name = initial(name)
	//69alidate name
	if(component_params69"name"69)
		sanitizeName(component_params69"name"69, allow_numbers = TRUE,69ax_length = IC_MAX_NAME_LEN)
	//69alidate input69alues
	if(component_params69"inputs"69)
		var/list/loaded_inputs = component_params69"inputs"69
		if(!islist(loaded_inputs))
			return "Malformed input69alues list at 69init_name69."

		var/inputs_amt = length(inputs)

		// Too69any inputs? Inputs for input-less component? This is not good.
		if(!inputs_amt || inputs_amt < length(loaded_inputs))
			return "Input69alues list out of bounds at 69init_name69."

		for(var/list/input in loaded_inputs)
			if(input.len != 3)
				return "Malformed input data at 69init_name69."

			var/input_id = input69169
			var/input_type = input69269
			//var/input_value = input69369

			// No special type support yet.
			if(input_type)
				return "Unidentified input type at 69init_name69!"
			// TODO: support for special input types, such as typepaths and internal refs

			// Input ID is a list index,69ake sure it's sane.
			if(!isnum_safe(input_id) || input_id % 1 || input_id > inputs_amt || input_id < 1)
				return "Invalid input index at 69init_name69."


// Loads component parameters from a list
// Doesn't69erify any of the parameters it loads, this is the job of69erify_save()
/obj/item/integrated_circuit/proc/load(list/component_params)
	// Load name
	if(component_params69"name"69)
		displayed_name = component_params69"name"69

	// Load input69alues
	if(component_params69"inputs"69)
		var/list/loaded_inputs = component_params69"inputs"69

		for(var/list/input in loaded_inputs)
			var/index = input69169
			//var/input_type = input69269
			var/input_value = input69369

			var/datum/integrated_io/pin = inputs69index69
			// The pins themselves69alidate the data.
			pin.write_data_to_pin(input_value)
			// TODO: support for special input types, such as internal refs and69aybe typepaths

	if(!isnull(component_params69"special"69))
		load_special(component_params69"special"69)

/obj/item/integrated_circuit/proc/load_special(special_data)
	return

// Saves type and69odified name (if any) to a list
// The list is converted to JSON down the line.
/obj/item/device/electronic_assembly/proc/save()
	var/list/assembly_params = list()

	// Save initial name used for differentiating assemblies
	assembly_params69"type"69 = initial(name)

	// Save69odified name
	if(initial(name) != name)
		assembly_params69"name"69 = name

	// Save69odified description
	if(initial(desc) != desc)
		assembly_params69"desc"69 = desc
	return assembly_params


//69erifies a list of assembly parameters
// Returns null on success, error name on failure
/obj/item/device/electronic_assembly/proc/verify_save(list/assembly_params)
	//69alidate name and desc
	if(assembly_params69"name"69)
		if(sanitizeName(assembly_params69"name"69, allow_numbers = TRUE,69ax_length = IC_MAX_NAME_LEN) != assembly_params69"name"69)
			return "Bad assembly name."
	if(assembly_params69"desc"69)
		if(sanitize(assembly_params69"desc"69) != assembly_params69"desc"69)
			return "Bad assembly description."

// Loads assembly parameters from a list
// Doesn't69erify any of the parameters it loads, this is the job of69erify_save()
/obj/item/device/electronic_assembly/proc/load(list/assembly_params)
	// Load69odified name, if any.
	if(assembly_params69"name"69)
		name = assembly_params69"name"69

	// Load69odified description, if any.
	if(assembly_params69"desc"69)
		desc = assembly_params69"desc"69

	update_icon()



// Attempts to save an assembly into a save file format.
// Returns null if assembly is not complete enough to be saved.
/datum/controller/subsystem/processing/circuit/proc/save_electronic_assembly(obj/item/device/electronic_assembly/assembly)
	// No components? Don't even try to save it.
	if(!length(assembly.assembly_components))
		return


	var/list/blocks = list()

	// Block 1. Assembly.
	blocks69"assembly"69 = assembly.save()
	// (implant assemblies are not yet supported)


	// Block 2. Components.
	var/list/components = list()
	for(var/c in assembly.assembly_components)
		var/obj/item/integrated_circuit/component = c
		components.Add(list(component.save()))
	blocks69"components"69 = components


	// Block 3. Wires.
	var/list/wires = list()
	var/list/saved_wires = list()

	for(var/c in assembly.assembly_components)
		var/obj/item/integrated_circuit/component = c
		var/list/all_pins = component.inputs + component.outputs + component.activators

		for(var/p in all_pins)
			var/datum/integrated_io/pin = p
			var/list/params = pin.get_pin_parameters()
			var/text_params = params.Join()

			for(var/p2 in pin.linked)
				var/datum/integrated_io/pin2 = p2
				var/list/params2 = pin2.get_pin_parameters()
				var/text_params2 = params2.Join()

				// Check if we already saved an opposite69ersion of this wire
				// (do not save the same wire twice)
				if((text_params2 + "=" + text_params) in saved_wires)
					continue

				// If not, add a wire "hash" for future checks and save it
				saved_wires.Add(text_params + "=" + text_params2)
				wires.Add(list(list(params, params2)))

	if(wires.len)
		blocks69"wires"69 = wires

	return json_encode(blocks)



// Checks assembly save and calculates some of the parameters.
// Returns assembly (type: list) if the save is69alid.
// Returns error code (type: text) if loading has failed.
// The following parameters area calculated during69alidation and added to the returned save list:
// "requires_upgrades", "unsupported_circuit", "cost", "complexity", "max_complexity", "used_space", "max_space"
/datum/controller/subsystem/processing/circuit/proc/validate_electronic_assembly(program)
	var/list/blocks = json_decode(program)
	if(!blocks)
		return

	var/error


	// Block 1. Assembly.
	var/list/assembly_params = blocks69"assembly"69

	if(!islist(assembly_params) || !length(assembly_params))
		return "Invalid assembly data."	// No assembly, damaged assembly or empty assembly

	//69alidate type, get a temporary component
	var/assembly_path = all_assemblies69assembly_params69"type"6969
	var/obj/item/I = cached_assemblies69assembly_path69
	var/obj/item/device/electronic_assembly/assembly = I
	if(istype(I, /obj/item/implant/integrated_circuit))
		var/obj/item/implant/integrated_circuit/implant = I
		assembly = implant.IC
	if(!assembly)
		return "Invalid assembly type."

	// Check assembly save data for errors
	error = assembly.verify_save(assembly_params)
	if(error)
		return error


	// Read space & complexity limits and start keeping track of them
	blocks69"complexity"69 = 0
	blocks69"max_complexity"69 = assembly.max_complexity
	blocks69"used_space"69 = 0
	blocks69"max_space"69 = assembly.max_components

	// Start keeping track of total69etal cost
	blocks69"cost"69 = assembly.matter.Copy()


	// Block 2. Components.
	if(!islist(blocks69"components"69) || !length(blocks69"components"69))
		return "Invalid components list."	// No components or damaged components list

	var/list/assembly_components = list()
	for(var/C in blocks69"components"69)
		var/list/component_params = C

		if(!islist(component_params) || !length(component_params))
			return "Invalid component data."

		//69alidate type, get a temporary component
		var/component_path = all_components69component_params69"type"6969
		var/obj/item/integrated_circuit/component = cached_components69component_path69
		if(!component)
			return "Invalid component type."

		// Add temporary component to assembly_components list, to be used later when69erifying the wires
		assembly_components.Add(component)

		// Check component save data for errors
		error = component.verify_save(component_params)
		if(error)
			return error

		// Update estimated assembly complexity, taken space and69aterial cost
		blocks69"complexity"69 += component.complexity
		blocks69"used_space"69 += component.size
		for(var/material in component.matter)
			blocks69"cost"6969material69 += component.matter69material69

		// Check if the assembly requires printer upgrades
		if(!(component.spawn_flags & IC_SPAWN_DEFAULT))
			blocks69"requires_upgrades"69 = TRUE

		// Check if the assembly supports the circucit
		if(component.action_flags && ((component.action_flags & assembly.allowed_circuit_action_flags) != component.action_flags))
			blocks69"unsupported_circuit"69 = TRUE


	// Check complexity and space limitations
	if(blocks69"used_space"69 > blocks69"max_space"69)
		return "Used space overflow."
	if(blocks69"complexity"69 > blocks69"max_complexity"69)
		return "Complexity overflow."


	// Block 3. Wires.
	if(blocks69"wires"69)
		if(!islist(blocks69"wires"69))
			return "Invalid wiring list."	// Damaged wires list

		for(var/w in blocks69"wires"69)
			var/list/wire = w

			if(!islist(wire) || wire.len != 2)
				return "Invalid wire data."

			var/datum/integrated_io/IO = assembly.get_pin_ref_list(wire69169, assembly_components)
			var/datum/integrated_io/IO2 = assembly.get_pin_ref_list(wire69269, assembly_components)
			if(!IO || !IO2)
				return "Invalid wire data."

			if(initial(IO.io_type) != initial(IO2.io_type))
				return "Wire type69ismatch."

	return blocks


// Loads assembly (in form of list) into an object and returns it.
// No sanity checks are performed, save file is expected to be69alidated by69alidate_electronic_assembly
/datum/controller/subsystem/processing/circuit/proc/load_electronic_assembly(loc, list/blocks)

	// Block 1. Assembly.
	var/list/assembly_params = blocks69"assembly"69
	var/assembly_path = all_assemblies69assembly_params69"type"6969
	var/obj/item/I = new assembly_path(null)
	var/obj/item/device/electronic_assembly/assembly = I
	if(istype(I, /obj/item/implant/integrated_circuit))
		var/obj/item/implant/integrated_circuit/implant = I
		assembly = implant.IC
	assembly.load(assembly_params)



	// Block 2. Components.
	for(var/component_params in blocks69"components"69)
		var/obj/item/integrated_circuit/component_path = all_components69component_params69"type"6969
		var/obj/item/integrated_circuit/component = new component_path(assembly)
		assembly.add_component(component)
		component.load(component_params)


	// Block 3. Wires.
	if(blocks69"wires"69)
		for(var/w in blocks69"wires"69)
			var/list/wire = w
			var/datum/integrated_io/IO = assembly.get_pin_ref_list(wire69169)
			var/datum/integrated_io/IO2 = assembly.get_pin_ref_list(wire69269)
			IO.connect_pin(IO2)

	I.forceMove(loc)
	return assembly
