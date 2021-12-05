/datum/computer_file/program/tax
	filename = "taxquickly"
	filedesc = "TaxQuickly 2565"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software."
	size = 0 // it is cloud based
	requires_ntnet = 0
	available_on_ntnet = 1
	usage_flags = PROGRAM_PDA
	nanomodule_path = /datum/nano_module/program/tax
	var/authenticated = FALSE

/datum/nano_module/program/tax
	name = "TaxQuickly 2565"
	var/error = FALSE
	var/stored_login = ""















