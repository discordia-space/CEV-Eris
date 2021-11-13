/datum/computer_file/cyberdeck_program
	var/QPCost = 1
	proc
		TryInstallTo(mob/observer/cyber_entity/cyberspace_eye/myEye)
			. = myEye?.owner?.QuantumPoints >= QPCost

		OnInstalledToRunner(mob/observer/cyber_entity/cyberspace_eye/myEye)
			
