/datum/MemoryStack
	var/list/Content = list()
	var/Memory = 0 // 0 mean that stack have unlimited Memory
	proc
		TemporaryExtendStack(count = 16, time = 10 MINUTES)
			ExtendStack(count)
			addtimer(CALLBACK(src, .proc/CutStack, count), time)

		CutStack(count = 16)
			Memory -= count
			CheckMemory()

		ExtendStack(count = 16)
			Memory += count

		CheckMemory()
			// . = Memory >= GetBusyMemory()
			// while(!. && length(Content) > 0)
			// 	Content.Remove(Content[length(Content) - 1])
			// 	. = Memory >= GetBusyMemory()
			do
				. = Memory >= GetBusyMemory()
				if(!.)
					Content.Remove(Content[length(Content) - 1])
			while(.)
		GetBusyMemory()
			for(var/datum/computer_file/program in Content)
				. += program.size

		GetFreeMemory()
			. = Memory - GetBusyMemory()

		able_to_install_program(datum/computer_file/P)
			. = P.size <= GetFreeMemory()

		InstallProgram(datum/computer_file/P, obj/item/weapon/computer_hardware/hard_drive/removeFromHolder = FALSE)
			. = CheckMemory() && able_to_install_program(P)
			if(.)
				CutStack(P.size)
				Content += P
				if(istype(removeFromHolder))
					removeFromHolder.remove_file(P)

		RemoveProgram(datum/computer_file/P, obj/item/weapon/computer_hardware/hard_drive/MoveTo)
			Content.Remove(P)
			CheckMemory()
			if(istype(MoveTo))
				MoveTo.store_file(P)
