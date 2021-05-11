/datum/computer_file/cyberdeck_program
	filetype = "CSP"
	size = 16

	unsendable = FALSE

	var/QPCost = 1
	var/Deletable = TRUE
	proc
		InstallToRunner(mob/observer/cyberspace_eye/myEye)
			myEye.QuantumPoints -= QPCost