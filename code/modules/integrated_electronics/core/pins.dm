/*
	Pins both hold data for circuits, as well69ove data between them.  Some also cause circuits to do their function.  DATA_CHANNEL pins are the data holding/moving kind,
where as PULSE_CHANNEL causes circuits to work() when their pulse hits them.
A69isualization of how pins work is below.  Imagine the below image involves an addition circuit.
When the bottom pin, the activator, receives a pulse, all the numbers on the left (input) get added, and the answer goes on the right side (output).
Inputs      Outputs
A 69269\      /69869 result
B 69169-\|++|/
C 69469-/|++|
D 69169/  ||
        ||
     Activator
*/
/datum/integrated_io
	var/name = "input/output"
	var/obj/item/integrated_circuit/holder
	var/weakref/data  // This is a weakref, to reduce typecasts.  Note that oftentimes numbers and text69ay also occupy this.
	var/list/linked = list()
	var/io_type = DATA_CHANNEL
	var/pin_type			// IC_INPUT, IC_OUTPUT, IC_ACTIVATOR - used in saving assembly wiring
	var/ord

/datum/integrated_io/New(loc, _name, _data, _pin_type,_ord)
	name = _name
	if(!isnull(_data))
		data = _data
	if(_pin_type)
		pin_type = _pin_type
	if(_ord)
		ord = _ord

	holder = loc

	if(!istype(holder))
		message_admins("ERROR: An integrated_io (69name69) spawned without a69alid holder!  This is a bug.")

/datum/integrated_io/Destroy()
	disconnect_all()
	data = null
	holder = null
	return ..()

/datum/integrated_io/proc/data_as_type(as_type)
	if(!isweakref(data))
		return
	var/weakref/w = data
	var/output = w.resolve()
	return istype(output, as_type) ? output : null

/datum/integrated_io/proc/display_data(input)
	if(isnull(input))
		return "(null)" // Empty data69eans nothing to show.

	if(isnum_safe(input))
		return "(69num2text(input)69)"

	if(istext(input))
		return "(\"69input69\")" // Wraps the 'string' in escaped quotes, so that people know it's a 'string'.

	if(islist(input))
		var/list/my_list = input
		var/result = "list\6969my_list.len69\69("
		if(my_list.len)
			result += "<br>"
			var/pos = 0
			for(var/line in69y_list)
				result += "69display_data(line)69"
				pos++
				if(pos !=69y_list.len)
					result += ",<br>"
			result += "<br>"
		result += ")"
		return result

	if(isweakref(input))
		var/weakref/w = input
		var/atom/A = w.resolve()
		return A ? "(69A.name69 \69Ref69)" : "(null)" // For refs, we want just the name displayed.

	return "(69input69)" // Nothing special needed for numbers or other stuff.

/datum/integrated_io/activate/display_data()
	return "(\69pulse\69)"

/datum/integrated_io/proc/display_pin_type()
	return IC_FORMAT_ANY

/datum/integrated_io/activate/display_pin_type()
	return IC_FORMAT_PULSE

/datum/integrated_io/proc/scramble()
	if(isnull(data))
		return
	if(isnum_safe(data))
		write_data_to_pin(rand(-10000, 10000))
	if(istext(data))
		write_data_to_pin("ERROR")
	push_data()

/datum/integrated_io/activate/scramble()
	push_data()

/datum/integrated_io/proc/handle_wire(datum/integrated_io/linked_pin, obj/item/tool, action,69ob/living/user)
	if(istype(tool, /obj/item/device/integrated_electronics/wirer))
		var/obj/item/device/integrated_electronics/wirer/wirer = tool
		if(linked_pin)
			wirer.wire(linked_pin, user)
		else
			wirer.wire(src, user)
		return TRUE

	else if(istype(tool, /obj/item/device/integrated_electronics/debugger))
		var/obj/item/device/integrated_electronics/debugger/debugger = tool
		debugger.write_data(src, user)
		return TRUE

	return FALSE

/datum/integrated_io/proc/write_data_to_pin(new_data)
	if(isnull(new_data) || isnum_safe(new_data) || istext(new_data) || isweakref(new_data))
		data = new_data
		holder.on_data_written()
	else if(islist(new_data))
		var/list/new_list = new_data
		data = new_list.Copy(max(1,new_list.len - IC_MAX_LIST_LENGTH+1),0)
		holder.on_data_written()

/datum/integrated_io/proc/push_data()
	for(var/k in 1 to linked.len)
		var/datum/integrated_io/io = linked69k69
		io.write_data_to_pin(data)

/datum/integrated_io/activate/push_data()
	for(var/k in 1 to linked.len)
		var/datum/integrated_io/io = linked69k69
		SScircuit_components.queue_component(io.holder, TRUE, io.ord)

/datum/integrated_io/proc/pull_data()
	for(var/k in 1 to linked.len)
		var/datum/integrated_io/io = linked69k69
		write_data_to_pin(io.data)

/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		return "the 69english_list(linked)69"
	return "nothing"


/datum/integrated_io/proc/connect_pin(datum/integrated_io/pin)
	pin.linked |= src
	linked |= pin

// Iterates over every linked pin and disconnects them.
/datum/integrated_io/proc/disconnect_all()
	for(var/pin in linked)
		disconnect_pin(pin)

/datum/integrated_io/proc/disconnect_pin(datum/integrated_io/pin)
	pin.linked.Remove(src)
	linked.Remove(pin)


/datum/integrated_io/proc/ask_for_data_type(mob/user,69ar/default,69ar/list/allowed_data_types = list("string","number","null"))
	var/type_to_use = input("Please choose a type to use.","69src69 type setting") as null|anything in allowed_data_types
	if(!holder.check_interactivity(user))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			new_data = sanitize(input(user, "Now type in a string.", "69src69 string writing", istext(default) ? default : null) as null|text, trim = 0)
			if(istext(new_data) && holder.check_interactivity(user) )
				to_chat(user, "<span class='notice'>You input "+new_data+" into the pin.</span>")
				return new_data
		if("number")
			new_data = input("Now type in a number.","69src69 number writing", isnum_safe(default) ? default : null) as null|num
			if(isnum_safe(new_data) && holder.check_interactivity(user) )
				to_chat(user, "<span class='notice'>You input 69new_data69 into the pin.</span>")
				return new_data
		if("null")
			if(holder.check_interactivity(user))
				to_chat(user, "<span class='notice'>You clear the pin's69emory.</span>")
				return new_data

// Basically a null check
/datum/integrated_io/proc/is_valid()
	return !isnull(data)

// This proc asks for the data to write, then writes it.
/datum/integrated_io/proc/ask_for_pin_data(mob/user)
	var/new_data = ask_for_data_type(user)
	write_data_to_pin(new_data)

/datum/integrated_io/activate/ask_for_pin_data(mob/user) // This just pulses the pin.
	holder.investigate_log(" was69anually pulsed by 69key_name(user)69.", INVESTIGATE_CIRCUIT)
	SScircuit_components.queue_component(holder, TRUE, ord, TRUE) //gnore_power = TRUE
	to_chat(user, "<span class='notice'>You pulse \the 69holder69's 69src69 pin.</span>")

/datum/integrated_io/activate
	name = "activation pin"
	io_type = PULSE_CHANNEL

/datum/integrated_io/activate/out // All this does is just69ake the UI say 'out' instead of 'in'
	data = 1
