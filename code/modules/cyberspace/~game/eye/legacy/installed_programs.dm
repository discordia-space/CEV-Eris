/mob/observer/cyber_entity/cyberspace_eye
	var/datum/MemoryStack/InstalledPrograms = new
	proc
		RemoveQP(value)
			if(istype(owner))
				owner.CostQP(value)

		TryInstallProgram(datum/computer_file/cyberdeck_program/CP)
			return CP.TryInstallTo(src)

		InstallProgram(datum/computer_file/cyberdeck_program/CP)
			. = InstalledPrograms.InstallProgram(CP, CP.holder)
			if(.)
				CP.OnInstalledToRunner(src)
				owner.QuantumPoints -= CP.QPCost
