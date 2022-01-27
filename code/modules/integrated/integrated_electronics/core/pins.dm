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
	var/obj/item/integrated_circuit/holder = null
	var/weakref/data = null // This is a weakref, to reduce typecasts.  Note that oftentimes numbers and text69ay also occupy this.
	var/list/linked = list()
	var/io_type = DATA_CHANNEL

/datum/integrated_io/New(var/newloc,69ar/name,69ar/data)
	..()
	src.name = name
	src.data = data
	holder = newloc
	if(!istype(holder))
		message_admins("ERROR: An integrated_io (69src.name69) spawned without a69alid holder!  This is a bug.")

/datum/integrated_io/Destroy()
	disconnect()
	data = null
	holder = null
	. = ..()

/datum/integrated_io/nano_host()
	return holder.nano_host()


/datum/integrated_io/proc/data_as_type(var/as_type)
	if(!isweakref(data))
		return
	var/weakref/w = data
	var/output = w.resolve()
	return istype(output, as_type) ? output : null

/datum/integrated_io/proc/display_data()
	if(isnull(data))
		return "(null)" // Empty data69eans nothing to show.
	if(istext(data))
		return "(\"69data69\")" // Wraps the 'string' in escaped quotes, so that people know it's a 'string'.
	if(isweakref(data))
		var/weakref/w = data
		var/atom/A = w.resolve()
		//return A ? "(69A.name69 \69Ref\69)" : "(null)" // For refs, we want just the name displayed.
		return A ? "(\ref69A69 \69Ref\69)" : "(null)"
	return "(69data69)" // Nothing special needed for numbers or other stuff.

/datum/integrated_io/activate/display_data()
	return "(\69pulse\69)"

/datum/integrated_io/proc/display_pin_type()
	return IC_FORMAT_ANY

/datum/integrated_io/activate/display_pin_type()
	return IC_FORMAT_PULSE

/datum/integrated_io/proc/scramble()
	if(isnull(data))
		return
	if(isnum(data))
		write_data_to_pin(rand(-10000, 10000))
	if(istext(data))
		write_data_to_pin("ERROR")
	push_data()

/datum/integrated_io/activate/scramble()
	push_data()

/datum/integrated_io/proc/write_data_to_pin(var/new_data)
	if(isnull(new_data) || isnum(new_data) || istext(new_data) || isweakref(new_data)) // Anything else is a type we don't want.
		data = new_data
		holder.on_data_written()

/datum/integrated_io/proc/push_data()
	for(var/datum/integrated_io/io in linked)
		io.write_data_to_pin(data)

/datum/integrated_io/activate/push_data()
	for(var/datum/integrated_io/io in linked)
		io.holder.check_then_do_work()

/datum/integrated_io/proc/pull_data()
	for(var/datum/integrated_io/io in linked)
		write_data_to_pin(io.data)

/datum/integrated_io/proc/get_linked_to_desc()
	if(linked.len)
		return "the 69english_list(linked)69"
	return "nothing"

/datum/integrated_io/proc/disconnect()
	//First we iterate over everything we are linked to.
	for(var/datum/integrated_io/their_io in linked)
		//While doing that, we iterate them as well, and disconnect ourselves from them.
		for(var/datum/integrated_io/their_linked_io in their_io.linked)
			if(their_linked_io == src)
				their_io.linked.Remove(src)
			else
				continue
		//Now that we're removed from them, we gotta remove them from us.
		src.linked.Remove(their_io)

/datum/integrated_io/input
	name = "input pin"

/datum/integrated_io/output
	name = "output pin"

/datum/integrated_io/activate
	name = "activation pin"
	io_type = PULSE_CHANNEL

/datum/integrated_io/list
	name = "list pin"

/datum/integrated_io/list/write_data_to_pin(var/new_data)
	if(islist(new_data))
		data = new_data
		holder.on_data_written()

/datum/integrated_io/list/display_pin_type()
	return IC_FORMAT_LIST