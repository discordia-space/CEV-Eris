/mob/observer/cyberspace_eye
	var/datum/MemoryStack/InstalledPrograms = new
	proc
		RemoveQP(value)
			if(istype(owner))
				owner.SetQP(value)

		TryInstallProgram(datum/computer_file/cyberdeck_program/CP)
			. = CP.TryInstallTo(src)

		InstallProgram(datum/computer_file/cyberdeck_program/CP)
			if(TryInstallProgram(CP))
				. = InstalledPrograms.InstallProgram(CP, CP.holder)
				if(.)
					CP.OnInstalledToRunner(src)
					owner.QuantumPoints -= CP.QPCost
