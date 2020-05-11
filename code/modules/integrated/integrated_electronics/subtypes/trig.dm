//These circuits do not-so-simple math.
/obj/item/integrated_circuit/trig
	complexity = 1
	inputs = list(
		"\<NUM\> A",
		"\<NUM\> B",
		"\<NUM\> C",
		"\<NUM\> D",
		"\<NUM\> E",
		"\<NUM\> F",
		"\<NUM\> G",
		"\<NUM\> H"
		)
	outputs = list("\<NUM\> result")
	activators = list("\<PULSE IN\> compute", "\<PULSE OUT\> on computed")
	category_text = "Trig"
	extended_desc = "Input and output are in degrees."
	autopulse = 1
	power_draw_per_use = 1 // Still cheap math.

/obj/item/integrated_circuit/trig/on_data_written()
	if(autopulse == 1)
		check_then_do_work()

// Sine //

/obj/item/integrated_circuit/trig/sine
	name = "sin circuit"
	desc = "Has nothing to do with evil, unless you consider trigonometry to be evil.  Outputs the sine of A."
	icon_state = "sine"
	inputs = list("\<NUM\> A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/sine/do_work()
	pull_data()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(isnum(A))
		result = sin(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Cosine //

/obj/item/integrated_circuit/trig/cosine
	name = "cos circuit"
	desc = "Outputs the cosine of A."
	icon_state = "cosine"
	inputs = list("\<NUM\> A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cosine/do_work()
	pull_data()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(isnum(A))
		result = cos(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Tangent //

/obj/item/integrated_circuit/trig/tangent
	name = "tan circuit"
	desc = "Outputs the tangent of A.  Guaranteed to not go on a tangent about its existance."
	icon_state = "tangent"
	inputs = list("\<NUM\> A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/tangent/do_work()
	pull_data()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(isnum(A))
		result = TAN(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)

// Cosecant //

/obj/item/integrated_circuit/trig/cosecant
	name = "csc circuit"
	desc = "Outputs the cosecant of A."
	icon_state = "cosecant"
	inputs = list("\<NUM\> A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cosecant/do_work()
	pull_data()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(isnum(A))
		result = CSC(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


// Secant //

/obj/item/integrated_circuit/trig/secant
	name = "sec circuit"
	desc = "Outputs the secant of A.  Has nothing to do with the security department."
	icon_state = "secant"
	inputs = list("\<NUM\> A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/secant/do_work()
	pull_data()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(isnum(A))
		result = SEC(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)


// Cotangent //

/obj/item/integrated_circuit/trig/cotangent
	name = "cot circuit"
	desc = "Outputs the cotangent of A."
	icon_state = "cotangent"
	inputs = list("\<NUM\> A")
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/trig/cotangent/do_work()
	pull_data()
	var/result = null
	var/A = get_pin_data(IC_INPUT, 1)
	if(isnum(A))
		result = COT(A)

	set_pin_data(IC_OUTPUT, 1, result)
	push_data()
	activate_pin(2)