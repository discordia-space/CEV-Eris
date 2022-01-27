/obj/item/device/integrated_electronics/debugger
	name = "circuit debugger"
	desc = "This small tool allows one working with custom69achinery to directly set data to a specific pin, useful for writing \
	settings to specific circuits, or for debugging purposes.  It can also pulse activation pins."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "debugger"
	flags = CONDUCT
	w_class = ITEM_SIZE_SMALL
	var/data_to_write = null
	var/accepting_refs = FALSE
	matter = list(MATERIAL_STEEL = 1000,69ATERIAL_GLASS = 500,69ATERIAL_PLASTIC = 500)
	var/copy_values = FALSE
	var/copy_id = FALSE
	var/weakref/idlock = null

/obj/item/device/integrated_electronics/debugger/attack_self(mob/user)
	var/type_to_use = input("Please choose a type to use.","69src69 type setting") as null|anything in list("string","number","ref","copy","null","id lock")
	if(!user.IsAdvancedToolUser())
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = FALSE
			copy_values = FALSE
			copy_id = FALSE
			new_data = sanitize(user.get_input("Now type in a string", "69src69 string writing", null,69OB_INPUT_TEXT, src), trim = 0)
			if(istext(new_data) && user.IsAdvancedToolUser())
				data_to_write = new_data
				to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to \"69new_data69\"."))
		if("number")
			accepting_refs = FALSE
			copy_values = FALSE
			copy_id = FALSE
			new_data = input(user, "Now type in a number.","69src69 number writing") as null|num
			if(isnum_safe(new_data) && user.IsAdvancedToolUser())
				data_to_write = new_data
				to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to 69new_data69."))
		if("ref")
			accepting_refs = TRUE
			copy_values = FALSE
			copy_id = FALSE
			to_chat(user, SPAN_NOTICE("You turn \the 69src69's ref scanner on.  Slide it across \
			an object for a ref of that object to save it in69emory."))
		if("copy")
			accepting_refs = FALSE
			copy_values = TRUE
			copy_id = FALSE
			to_chat(user, SPAN_NOTICE("You turn \the 69src69's69alue copier on.  Use it on a pin \
			to save its current69alue in69emory."))
		if("null")
			data_to_write = null
			copy_values = FALSE
			to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to absolutely nothing."))
		if("id lock")
			accepting_refs = FALSE
			copy_values = FALSE
			copy_id = TRUE
			to_chat(user, SPAN_NOTICE("You turn \the 69src69's id card scanner on. Use your own card \
			to store the identity and id-lock an assembly."))

/obj/item/device/integrated_electronics/debugger/afterattack(atom/target,69ob/living/user, proximity)
	. = ..()
	if(accepting_refs && proximity)
		data_to_write = weakref(target)
		visible_message(SPAN_NOTICE("69user69 slides \a 69src69's over \the 69target69."))
		to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to a reference to 69target.name69 \69Ref\69.  The ref scanner is \
		now off."))
		accepting_refs = FALSE

	else if(copy_id && proximity)
		if(istype(target,/obj/item/card/id))
			src.idlock = weakref(target)
			to_chat(user, SPAN_NOTICE("You set \the 69src69's card69emory to 69target.name69.  The id card scanner is \
			now off."))

		else
			to_chat(user, SPAN_NOTICE("You turn the id card scanner is off."))

		copy_id = FALSE
		return

/obj/item/device/integrated_electronics/debugger/proc/write_data(datum/integrated_io/io,69ob/user)
	//If the pin can take data:
	if(io.io_type == DATA_CHANNEL)
		//If the debugger is set to copy, copy the data in the pin onto it
		if(copy_values)
			data_to_write = io.data
			to_chat(user, SPAN_NOTICE("You let the debugger copy the data."))
			copy_values = FALSE
			return

		//Else, write the data to the pin
		io.write_data_to_pin(data_to_write)
		var/data_to_show = data_to_write
		//This is only to convert a weakref into a name for better output
		if(isweakref(data_to_write))
			var/weakref/W = data_to_write
			var/atom/A = W.resolve()
			data_to_show = A.name
		to_chat(user, SPAN_NOTICE("You write '69data_to_write ? data_to_show : "NULL"69' to the '69io69' pin of \the 69io.holder69."))

	//If the pin can only be pulsed
	else if(io.io_type == PULSE_CHANNEL)
		SScircuit_components.queue_component(io.holder, TRUE, io.ord, TRUE) //ignore_power = TRUE
		to_chat(user, SPAN_NOTICE("You pulse \the 69io.holder69's 69io69."))

  io.holder.interact(user) // This is to update the UI.
