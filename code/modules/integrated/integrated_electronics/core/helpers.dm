/obj/item/integrated_circuit/proc/setup_io(var/list/io_list, var/io_type)
	var/list/io_list_copy = io_list.Copy()
	io_list.Cut()
	for(var/io_entry in io_list_copy)
		io_list.Add(new io_type(src, io_entry, io_list_copy[io_entry]))

/obj/item/integrated_circuit/proc/set_pin_data(var/pin_type, var/pin_number, var/new_data)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.write_data_to_pin(new_data)

/obj/item/integrated_circuit/proc/get_pin_data(var/pin_type, var/pin_number)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.get_data()

/obj/item/integrated_circuit/proc/get_pin_data_as_type(var/pin_type, var/pin_number, var/as_type)
	var/datum/integrated_io/pin = get_pin_ref(pin_type, pin_number)
	return pin.data_as_type(as_type)

/obj/item/integrated_circuit/proc/activate_pin(var/pin_number)
	var/datum/integrated_io/activate/A = activators[pin_number]
	A.push_data()

/datum/integrated_io/proc/get_data()
	if(isnull(data))
		return
	if(isweakref(data))
		return data.resolve()
	return data

/obj/item/integrated_circuit/proc/get_pin_ref(var/pin_type, var/pin_number)
	switch(pin_type)
		if(IC_INPUT)
			if(pin_number > inputs.len)
				return null
			return inputs[pin_number]
		if(IC_OUTPUT)
			if(pin_number > outputs.len)
				return null
			return outputs[pin_number]
		if(IC_ACTIVATOR)
			if(pin_number > activators.len)
				return null
			return activators[pin_number]
	return null
