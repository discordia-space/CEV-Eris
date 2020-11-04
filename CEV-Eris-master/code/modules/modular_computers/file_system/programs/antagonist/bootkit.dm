/datum/computer_file/program/bootkit
	filename = "bootkit"
	filedesc = "Bootkit Installer"
	program_menu_icon = "unlocked"
	extended_desc = "Grants access to a remote software repository to any PC it runs on. The only way to remove this access is to replace PC's mainboard."
	size = 4
	usage_flags = PROGRAM_ALL
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE

/datum/computer_file/program/bootkit/run_program(mob/living/user)
	if(!..())
		return 0

	// Hack the computer, then force a shutdown
	if(!computer.computer_emagged)
		computer.computer_emagged = TRUE
		computer.shutdown_computer()
	return 0
