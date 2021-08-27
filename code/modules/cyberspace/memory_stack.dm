/datum/MemoryStack
	var/list/Content = list()
	var/Memory = 0 // 0 mean that stack have unlimited Memory
	proc
		GetNames()
			. = list()
			for(var/datum/computer_file/i in Content)
				. += i.filename
		ProgramByName(_name)
			for(var/datum/computer_file/i in Content)
				if(i.filename == _name)
					return i

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
			// 	Content.Remove(Content[length(Content)])
			// 	. = Memory >= GetBusyMemory()
			do
				. = Memory >= GetBusyMemory()
				if(!.)
					var/lenOfContent = length(Content)
					Content.Cut(lenOfContent, lenOfContent + 1)
			while(!(. && length(Content)))

		GetBusyMemory()
			for(var/datum/computer_file/program in Content)
				. += program.size

		GetFreeMemory()
			. = Memory - GetBusyMemory()

		able_to_install_program(datum/computer_file/P)
			. = P.size <= GetFreeMemory()

		InstallProgram(datum/computer_file/P, obj/item/computer_hardware/hard_drive/removeFromHolder = FALSE)
			. = CheckMemory() && able_to_install_program(P)
			if(.)
				Content += P
				if(istype(removeFromHolder))
					removeFromHolder.remove_file(P)

		RemoveProgram(datum/computer_file/P, obj/item/computer_hardware/hard_drive/MoveTo)
			Content.Remove(P)
			CheckMemory()
			if(istype(MoveTo))
				MoveTo.store_file(P)
