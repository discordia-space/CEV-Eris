/datum/unit_test/integrated_circuits/additon_1
	name = "Arithmetic Circuits: Addition - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/addition
	inputs_to_give = list(25, 75)
	expected_outputs = list(100)

/datum/unit_test/integrated_circuits/additon_2
	name = "Arithmetic Circuits: Addition - Multiple"
	circuit_type = /obj/item/integrated_circuit/arithmetic/addition
	inputs_to_give = list(7, 5, 3, 26, 974, -51, 77, 0)
	expected_outputs = list(1041)



/datum/unit_test/integrated_circuits/subtraction_1
	name = "Arithmetic Circuits: Subtraction - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/subtraction
	inputs_to_give = list(20, 15)
	expected_outputs = list(5)

/datum/unit_test/integrated_circuits/subtraction_2
	name = "Arithmetic Circuits: Subtraction - Multiple"
	circuit_type = /obj/item/integrated_circuit/arithmetic/subtraction
	inputs_to_give = list(5, 50, 30)
	expected_outputs = list(-75)



/datum/unit_test/integrated_circuits/multiplication_1
	name = "Arithmetic Circuits: Multiplication - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/multiplication
	inputs_to_give = list(5, 20)
	expected_outputs = list(100)

/datum/unit_test/integrated_circuits/multiplication_2
	name = "Arithmetic Circuits: Multiplication - Multiple"
	circuit_type = /obj/item/integrated_circuit/arithmetic/multiplication
	inputs_to_give = list(2, 10, 20)
	expected_outputs = list(400)

/datum/unit_test/integrated_circuits/multiplication_3
	name = "Arithmetic Circuits: Multiplication - Decimal"
	circuit_type = /obj/item/integrated_circuit/arithmetic/multiplication
	inputs_to_give = list(100, 0.5)
	expected_outputs = list(50)


/datum/unit_test/integrated_circuits/division_1
	name = "Arithmetic Circuits: Division - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/division
	inputs_to_give = list(100, 5)
	expected_outputs = list(20)

/datum/unit_test/integrated_circuits/division_2
	name = "Arithmetic Circuits: Division - Multiple"
	circuit_type = /obj/item/integrated_circuit/arithmetic/division
	inputs_to_give = list(500, 100, 10)
	expected_outputs = list(0.5)

/datum/unit_test/integrated_circuits/division_3
	name = "Arithmetic Circuits: Division - Decimal"
	circuit_type = /obj/item/integrated_circuit/arithmetic/division
	inputs_to_give = list(100, 0.5)
	expected_outputs = list(200)



/datum/unit_test/integrated_circuits/exponent_1
	name = "Arithmetic Circuits: Exponent - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/exponent
	inputs_to_give = list(20, 2)
	expected_outputs = list(400)

/datum/unit_test/integrated_circuits/exponent_2
	name = "Arithmetic Circuits: Exponent - Powers"
	circuit_type = /obj/item/integrated_circuit/arithmetic/exponent
	inputs_to_give = list(5, 4)
	expected_outputs = list(625)



/datum/unit_test/integrated_circuits/sign_1
	name = "Arithmetic Circuits: Sign - Positive"
	circuit_type = /obj/item/integrated_circuit/arithmetic/sign
	inputs_to_give = list(5)
	expected_outputs = list(1)

/datum/unit_test/integrated_circuits/sign_2
	name = "Arithmetic Circuits: Sign - Negative"
	circuit_type = /obj/item/integrated_circuit/arithmetic/sign
	inputs_to_give = list(-500)
	expected_outputs = list(-1)

/datum/unit_test/integrated_circuits/sign_3
	name = "Arithmetic Circuits: Sign - Zero"
	circuit_type = /obj/item/integrated_circuit/arithmetic/sign
	inputs_to_give = list(0)
	expected_outputs = list(0)



/datum/unit_test/integrated_circuits/round_1
	name = "Arithmetic Circuits: Round - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/round
	inputs_to_give = list(4.25)
	expected_outputs = list(4)

/datum/unit_test/integrated_circuits/round_2
	name = "Arithmetic Circuits: Round - Floor"
	circuit_type = /obj/item/integrated_circuit/arithmetic/round
	inputs_to_give = list(8.95)
	expected_outputs = list(8)

/datum/unit_test/integrated_circuits/round_3
	name = "Arithmetic Circuits: Round - Round to X"
	circuit_type = /obj/item/integrated_circuit/arithmetic/round
	inputs_to_give = list(45.68, 0.1)
	expected_outputs = list(45.7)



/datum/unit_test/integrated_circuits/absolute_1
	name = "Arithmetic Circuits: Absolute - Positive"
	circuit_type = /obj/item/integrated_circuit/arithmetic/absolute
	inputs_to_give = list(50)
	expected_outputs = list(50)

/datum/unit_test/integrated_circuits/absolute_2
	name = "Arithmetic Circuits: Absolute - Negative"
	circuit_type = /obj/item/integrated_circuit/arithmetic/absolute
	inputs_to_give = list(-20)
	expected_outputs = list(20)

/datum/unit_test/integrated_circuits/absolute_3
	name = "Arithmetic Circuits: Absolute - Zero"
	circuit_type = /obj/item/integrated_circuit/arithmetic/absolute
	inputs_to_give = list(0)
	expected_outputs = list(0)



/datum/unit_test/integrated_circuits/average_1
	name = "Arithmetic Circuits: Average - Basic"
	circuit_type = /obj/item/integrated_circuit/arithmetic/average
	inputs_to_give = list(8, 20, 14, 6)
	expected_outputs = list(12)

/datum/unit_test/integrated_circuits/average_2
	name = "Arithmetic Circuits: Average - Negatives"
	circuit_type = /obj/item/integrated_circuit/arithmetic/average
	inputs_to_give = list(30, -5, 8, -50, 4)
	expected_outputs = list(-2.6)



/datum/unit_test/integrated_circuits/square_root_1
	name = "Arithmetic Circuits: Square Root"
	circuit_type = /obj/item/integrated_circuit/arithmetic/square_root
	inputs_to_give = list(64)
	expected_outputs = list(8)



/datum/unit_test/integrated_circuits/modulo_1
	name = "Arithmetic Circuits: Modulo - 1"
	circuit_type = /obj/item/integrated_circuit/arithmetic/modulo
	inputs_to_give = list(8, 5)
	expected_outputs = list(3)

/datum/unit_test/integrated_circuits/modulo_2
	name = "Arithmetic Circuits: Modulo - 2"
	circuit_type = /obj/item/integrated_circuit/arithmetic/modulo
	inputs_to_give = list(20, 5)
	expected_outputs = list(0)