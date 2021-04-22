/obj/item/weapon/computer_hardware/deck/proc
	GiveTemporaryMemory(count = 16, time = 10 MINUTES)
		AddMemory(count)
		addtimer(CALLBACK(src, .proc/RemoveMemory, count), time)

	RemoveMemory(count = 16)
		memory -= count
		CheckMemory()

	AddMemory(count = 16)
		memory += count

	CheckMemory()
		. = memory >= GetBusyMemory()
		while(!. && length(memory_buffer) > 0)
			memory_buffer.Remove(memory_buffer[length(memory_buffer) - 1])
			. = memory >= GetBusyMemory()
		projected_mind.UpdateGrip()


	GetBusyMemory()
		for(var/datum/computer_file/cyberdeck_program/program in memory_buffer)
			. += program.size

	GetFreeMemory()
		. = memory - GetBusyMemory()

	able_to_install_program(datum/computer_file/cyberdeck_program/P)
		. = P.size <= GetFreeMemory()

	InstallProgram(datum/computer_file/cyberdeck_program/P)
		if(CheckMemory() && able_to_install_program(P))
			RemoveMemory(P.size)
			memory_buffer += P
			if(istype(holder2))
				var/obj/item/weapon/computer_hardware/hard_drive/hard_drive	= holder2.hard_drive
				hard_drive.remove_file(P)

	RemoveProgram(datum/computer_file/cyberdeck_program/P, obj/item/weapon/computer_hardware/hard_drive/MoveTo = holder2)
		if(P.Deletable)
			memory_buffer.Remove(P)
			CheckMemory()
			if(istype(holder2))
				var/obj/item/weapon/computer_hardware/hard_drive/hard_drive	= holder2.hard_drive
				hard_drive.store_file(P)
