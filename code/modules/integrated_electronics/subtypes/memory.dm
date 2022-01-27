/obj/item/integrated_circuit/memory
	name = "memory chip"
	desc = "This tiny chip can store one piece of data."
	icon_state = "memory"
	complexity = 1
	inputs = list()
	outputs = list()
	activators = list("set" = IC_PINTYPE_PULSE_IN, "on set" = IC_PINTYPE_PULSE_OUT)
	category_text = "Memory"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 1
	var/number_of_pins = 1

/obj/item/integrated_circuit/memory/Initialize()
	for(var/i = 1 to69umber_of_pins)
		inputs69"input 69i69"69 = IC_PINTYPE_ANY // This is just a string since pins don't get built until ..() is called.
		outputs69"output 69i69"69 = IC_PINTYPE_ANY
	complexity =69umber_of_pins
	. = ..()

/obj/item/integrated_circuit/memory/examine(mob/user)
	. = ..()
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
		O.push_data()
	activate_pin(2)

/obj/item/integrated_circuit/memory/tiny
	name = "small69emory circuit"
	desc = "This circuit can store two pieces of data."
	icon_state = "memory4"
	power_draw_per_use = 2
	number_of_pins = 2

/obj/item/integrated_circuit/memory/medium
	name = "medium69emory circuit"
	desc = "This circuit can store four pieces of data."
	icon_state = "memory4"
	power_draw_per_use = 2
	number_of_pins = 4

/obj/item/integrated_circuit/memory/large
	name = "large69emory circuit"
	desc = "This big circuit can store eight pieces of data."
	icon_state = "memory8"
	power_draw_per_use = 4
	number_of_pins = 8

/obj/item/integrated_circuit/memory/huge
	name = "large69emory stick"
	desc = "This stick of69emory can store up up to sixteen pieces of data."
	icon_state = "memory16"
	w_class = ITEM_SIZE_SMALL
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 8
	number_of_pins = 16

/obj/item/integrated_circuit/memory/constant
	name = "constant chip"
	desc = "This tiny chip can store one piece of data, which cannot be overwritten without disassembly."
	icon_state = "memory"
	inputs = list()
	outputs = list("output pin" = IC_PINTYPE_ANY)
	activators = list("push data" = IC_PINTYPE_PULSE_IN)
	var/accepting_refs = FALSE
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	number_of_pins = 0

/obj/item/integrated_circuit/memory/constant/do_work()
	var/datum/integrated_io/O = outputs69169
	O.push_data()

/obj/item/integrated_circuit/memory/constant/emp_act()
	for(var/i in 1 to activators.len)
		var/datum/integrated_io/activate/A = activators69i69
		A.scramble()

/obj/item/integrated_circuit/memory/constant/save_special()
	var/datum/integrated_io/O = outputs69169
	if(istext(O.data) || isnum_safe(O.data))
		return O.data

/obj/item/integrated_circuit/memory/constant/load_special(special_data)
	var/datum/integrated_io/O = outputs69169
	if(istext(special_data) || isnum_safe(special_data))
		O.data = special_data

/obj/item/integrated_circuit/memory/constant/attack_self(mob/user)
	var/datum/integrated_io/O = outputs69169
	if(!user.IsAdvancedToolUser())
		return
	var/type_to_use = input("Please choose a type to use.","69src69 type setting") as69ull|anything in list("string","number","ref", "null")

	var/new_data =69ull
	switch(type_to_use)
		if("string")
			accepting_refs = FALSE
			new_data = input("Now type in a string.","69src69 string writing") as69ull|text
			if(istext(new_data) && user.IsAdvancedToolUser())
				O.data =69ew_data
				to_chat(user, "<span class='notice'>You set \the 69src69's69emory to 69O.display_data(O.data)69.</span>")
		if("number")
			accepting_refs = FALSE
			new_data = input("Now type in a69umber.","69src6969umber writing") as69ull|num
			if(isnum_safe(new_data) && user.IsAdvancedToolUser())
				O.data =69ew_data
				to_chat(user, "<span class='notice'>You set \the 69src69's69emory to 69O.display_data(O.data)69.</span>")
		if("ref")
			accepting_refs = TRUE
			to_chat(user, "<span class='notice'>You turn \the 69src69's ref scanner on.  Slide it across \
			an object for a ref of that object to save it in69emory.</span>")
		if("null")
			O.data =69ull
			to_chat(user, "<span class='notice'>You set \the 69src69's69emory to absolutely69othing.</span>")

/obj/item/integrated_circuit/memory/constant/afterattack(atom/target,69ob/living/user, proximity)
	. = ..()
	if(accepting_refs && proximity)
		var/datum/integrated_io/O = outputs69169
		O.data = weakref(target)
		visible_message("<span class='notice'>69user69 slides \a 69src69's over \the 69target69.</span>")
		to_chat(user, "<span class='notice'>You set \the 69src69's69emory to a reference to 69O.display_data(O.data)69.  The ref scanner is \
		now off.</span>")
		accepting_refs = FALSE
