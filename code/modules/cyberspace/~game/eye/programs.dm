/mob/observer/cyberspace_eye
	var/Memory
	var/datum/MemoryStack/InstalledPrograms
	// proc
	// 	CheckMemory()
	// 		. = Memory >= GetBusyMemory()
	// 		while(!. && length(InstalledPrograms) > 0)
	// 			InstalledPrograms.Remove(InstalledPrograms[length(InstalledPrograms) - 1])
	// 			. = Memory >= GetBusyMemory()
	// 		UpdateInstalledPrograms()
	// 	GetBusyMemory()
	// 		for(var/datum/computer_file/cyberdeck_program/program in InstalledPrograms)
	// 			. += program.size

	// 	GetFreeMemory()
	// 		. = Memory - GetBusyMemory()

	// 	able_to_install_program(datum/computer_file/cyberdeck_program/P)
	// 		. = P.size <= GetFreeMemory()

	// 	InstallProgram(datum/computer_file/cyberdeck_program/P)
	// 		if(owner && CheckMemory() && able_to_install_program(P))
	// 			RemoveMemory(P.size)
	// 			InstalledPrograms += P

	// 	UpdateInstalledPrograms()
