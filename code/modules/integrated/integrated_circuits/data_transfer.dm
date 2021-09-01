/datum/unit_test/integrated_circuits/splitter
	name = "Data Transfer Circuits: Splitter"
	circuit_type = /obj/item/integrated_circuit/transfer/splitter
	inputs_to_give = list("Test")
	expected_outputs = list("Test", "Test")

/datum/unit_test/integrated_circuits/splitter4
	name = "Data Transfer Circuits: Splitter 4"
	circuit_type = /obj/item/integrated_circuit/transfer/splitter/medium
	inputs_to_give = list("Test")
	expected_outputs = list("Test", "Test", "Test", "Test")

/datum/unit_test/integrated_circuits/splitter8
	name = "Data Transfer Circuits: Splitter 8"
	circuit_type = /obj/item/integrated_circuit/transfer/splitter/large
	inputs_to_give = list("Test")
	expected_outputs = list("Test", "Test", "Test", "Test", "Test", "Test", "Test", "Test")