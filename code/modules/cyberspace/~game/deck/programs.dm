/obj/item/weapon/computer_hardware/deck/proc
	TemporaryExtendGrip(count = 16, time = 10 MINUTES)
		memory_buffer.ExtendStack(count)
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

	RemoveProgram(datum/computer_file/cyberdeck_program/P, obj/item/weapon/computer_hardware/hard_drive/MoveTo)
		if(!MoveTo && istype(holder2))
			MoveTo = holder2.hard_drive
		if(P.Deletable)
			. = memory_buffer.RemoveProgram(P, MoveTo)

