/obj/item/integrated_circuit/memory
	name = "memory chip"
	desc = "This tiny chip can store one piece of data."
	icon_state = "memory"
	complexity = 1
	inputs = list("input pin 1")
	outputs = list("output pin 1")
	activators = list("set")
	category_text = "Memory"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1

/obj/item/integrated_circuit/memory/examine(mob/user)
	..()
	var/i
	for(i = 1, i <= outputs.len, i++)
		var/datum/integrated_io/O = outputs69i69
		var/data = "nothing"
		if(isweakref(O.data))
			var/datum/d = O.data_as_type(/datum)
			if(d)
				data = "69d69"
		else if(!isnull(O.data))
			data = O.data
		to_chat(user, "\The 69src69 has 69data69 saved to address 69i69.")

/obj/item/integrated_circuit/memory/do_work()
	for(var/i = 1 to inputs.len)
		var/datum/integrated_io/I = inputs69i69
		var/datum/integrated_io/O = outputs69i69
		O.data = I.data

/obj/item/integrated_circuit/memory/medium
	name = "memory circuit"
	desc = "This circuit can store four pieces of data."
	icon_state = "memory4"
	w_class = ITEM_SIZE_SMALL
	complexity = 4
	inputs = list("input pin 1","input pin 2","input pin 3","input pin 4")
	outputs = list("output pin 1","output pin 2","output pin 3","output pin 4")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 2

/obj/item/integrated_circuit/memory/large
	name = "large69emory circuit"
	desc = "This big circuit can hold eight pieces of data."
	icon_state = "memory8"
	w_class = ITEM_SIZE_SMALL
	complexity = 8
	inputs = list(
		"input pin 1",
		"input pin 2",
		"input pin 3",
		"input pin 4",
		"input pin 5",
		"input pin 6",
		"input pin 7",
		"input pin 8")
	outputs = list(
		"output pin 1",
		"output pin 2",
		"output pin 3",
		"output pin 4",
		"output pin 5",
		"output pin 6",
		"output pin 7",
		"output pin 8")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	power_draw_per_use = 4

/obj/item/integrated_circuit/memory/huge
	name = "large69emory stick"
	desc = "This stick of69emory can hold up up to sixteen pieces of data."
	icon_state = "memory16"
	w_class = ITEM_SIZE_NORMAL
	complexity = 16
	inputs = list(
		"input pin 1",
		"input pin 2",
		"input pin 3",
		"input pin 4",
		"input pin 5",
		"input pin 6",
		"input pin 7",
		"input pin 8",
		"input pin 9",
		"input pin 10",
		"input pin 11",
		"input pin 12",
		"input pin 13",
		"input pin 14",
		"input pin 15",
		"input pin 16"
	)
	outputs = list(
		"output pin 1",
		"output pin 2",
		"output pin 3",
		"output pin 4",
		"output pin 5",
		"output pin 6",
		"output pin 7",
		"output pin 8",
		"output pin 9",
		"output pin 10",
		"output pin 11",
		"output pin 12",
		"output pin 13",
		"output pin 14",
		"output pin 15",
		"output pin 16")
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 4)
	power_draw_per_use = 8

/obj/item/integrated_circuit/memory/constant
	name = "constant chip"
	desc = "This tiny chip can store one piece of data, which cannot be overwritten without disassembly."
	icon_state = "memory"
	complexity = 1
	inputs = list()
	outputs = list("output pin")
	activators = list("push data")
	var/accepting_refs = 0
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/memory/constant/do_work()
	var/datum/integrated_io/O = outputs69169
	O.push_data()

/obj/item/integrated_circuit/memory/constant/attack_self(mob/user)
	var/datum/integrated_io/O = outputs69169
	var/type_to_use = input("Please choose a type to use.","69src69 type setting") as69ull|anything in list("string","number","ref", "null")
	if(!CanInteract(user,GLOB.physical_state))
		return

	var/new_data =69ull
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = input("Now type in a string.","69src69 string writing") as69ull|text
			if(istext(new_data) && CanInteract(user,GLOB.physical_state))
				O.data =69ew_data
				to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to 69O.display_data()69."))
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a69umber.","69src6969umber writing") as69ull|num
			if(isnum(new_data) && CanInteract(user,GLOB.physical_state))
				O.data =69ew_data
				to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to 69O.display_data()69."))
		if("ref")
			accepting_refs = 1
			to_chat(user, SPAN_NOTICE("You turn \the 69src69's ref scanner on.  Slide it across \
			an object for a ref of that object to save it in69emory."))
		if("null")
			O.data =69ull
			to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to absolutely69othing."))

/obj/item/integrated_circuit/memory/constant/afterattack(atom/target,69ob/living/user, proximity)
	if(accepting_refs && proximity)
		var/datum/integrated_io/O = outputs69169
		O.data = weakref(target)
		visible_message(SPAN_NOTICE("69user69 slides \a 69src69's over \the 69target69."))
		to_chat(user, SPAN_NOTICE("You set \the 69src69's69emory to a reference to 69O.display_data()69.  The ref scanner is \
		now off."))
		accepting_refs = 0