/obj/item/integrated_circuit/logic
	name = "logic gate"
	desc = "This tiny chip will decide for you!"
	extended_desc = "Logic circuits will treat a null, 0, and a \"\" string69alue as FALSE and anything else as TRUE."
	complexity = 3
	outputs = list("result")
	activators = list("\<PULSE IN\> compare")
	category_text = "Logic"
	autopulse = 1
	power_draw_per_use = 1

/obj/item/integrated_circuit/logic/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

/obj/item/integrated_circuit/logic/do_work()
	push_data()

/obj/item/integrated_circuit/logic/binary
	inputs = list("\<ANY\> A","\<ANY\> B")
	activators = list("\<PULSE IN\> compare", "\<PULSE OUT\> on true result", "\<PULSE OUT\> on false result")

/obj/item/integrated_circuit/logic/binary/do_work()
	pull_data()
	var/datum/integrated_io/A = inputs69169
	var/datum/integrated_io/B = inputs69269
	var/datum/integrated_io/O = outputs69169
	O.data = do_compare(A, B) ? TRUE : FALSE

	if(get_pin_data(IC_OUTPUT, 1))
		activate_pin(2)
	else
		activate_pin(3)
	..()

/obj/item/integrated_circuit/logic/binary/proc/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return FALSE

/obj/item/integrated_circuit/logic/unary
	inputs = list("\<ANY\> A")
	activators = list("\<PULSE IN\> compare", "\<PULSE OUT\> on compare")

/obj/item/integrated_circuit/logic/unary/do_work()
	pull_data()
	var/datum/integrated_io/A = inputs69169
	var/datum/integrated_io/O = outputs69169
	O.data = do_check(A) ? TRUE : FALSE
	..()
	activate_pin(2)

/obj/item/integrated_circuit/logic/unary/proc/do_check(var/datum/integrated_io/A)
	return FALSE

/obj/item/integrated_circuit/logic/binary/equals
	name = "equal gate"
	desc = "This gate compares two69alues, and outputs the number one if both are the same."
	icon_state = "equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/equals/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data == B.data

/obj/item/integrated_circuit/logic/binary/not_equals
	name = "not equal gate"
	desc = "This gate compares two69alues, and outputs the number one if both are different."
	icon_state = "not_equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/not_equals/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data != B.data

/obj/item/integrated_circuit/logic/binary/and
	name = "and gate"
	desc = "This gate will output 'one' if both inputs evaluate to true."
	icon_state = "and"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/and/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data && B.data

/obj/item/integrated_circuit/logic/binary/or
	name = "or gate"
	desc = "This gate will output 'one' if one of the inputs evaluate to true."
	icon_state = "or"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/or/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data || B.data

/obj/item/integrated_circuit/logic/binary/less_than
	name = "less than gate"
	desc = "This will output 'one' if the first input is less than the second input."
	icon_state = "less_than"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/less_than/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data < B.data

/obj/item/integrated_circuit/logic/binary/less_than_or_equal
	name = "less than or equal gate"
	desc = "This will output 'one' if the first input is less than, or equal to the second input."
	icon_state = "less_than_or_equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/less_than_or_equal/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data <= B.data

/obj/item/integrated_circuit/logic/binary/greater_than
	name = "greater than gate"
	desc = "This will output 'one' if the first input is greater than the second input."
	icon_state = "greater_than"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/greater_than/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data > B.data

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal
	name = "greater_than or equal gate"
	desc = "This will output 'one' if the first input is greater than, or equal to the second input."
	icon_state = "greater_than_or_equal"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/logic/binary/greater_than_or_equal/do_compare(var/datum/integrated_io/A,69ar/datum/integrated_io/B)
	return A.data >= B.data

/obj/item/integrated_circuit/logic/unary/not
	name = "not gate"
	desc = "This gate inverts what's fed into it."
	icon_state = "not"
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	activators = list("\<PULSE IN\> invert", "\<PULSE OUT\> on inverted")

/obj/item/integrated_circuit/logic/unary/not/do_check(var/datum/integrated_io/A)
	return !A.data
