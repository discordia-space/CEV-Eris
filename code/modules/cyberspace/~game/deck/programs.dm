/obj/item/computer_hardware/deck/proc
	AddMemory(count)
		. = memory_buffer.ExtendStack(count)
	TemporaryExtendGrip(count = 16, time = 10 MINUTES)
		AddMemory(count)
		addtimer(CALLBACK(memory_buffer, /datum/MemoryStack/proc/CutStack, count), time)

	CheckMemory()
		. = memory_buffer.CheckMemory()

	GetBusyMemory()
		. = memory_buffer.GetBusyMemory()
	GetFreeMemory()
		. = memory_buffer.GetFreeMemory()

	able_to_install_program(datum/computer_file/cyberdeck_program/P)
		. = memory_buffer.able_to_install_program(P)

	InstallProgram(datum/computer_file/cyberdeck_program/P)
		. = memory_buffer.InstallProgram(P, holder2?.hard_drive)
		SetUpProjectedMind()

	RemoveProgram(datum/computer_file/cyberdeck_program/P, obj/item/computer_hardware/hard_drive/MoveTo)
		if(!MoveTo && istype(holder2))
			MoveTo = holder2.hard_drive
		if(!P.undeletable)
			. = memory_buffer.RemoveProgram(P, MoveTo)

