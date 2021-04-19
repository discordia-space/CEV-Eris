/datum/computer_file/cyberdeck_program
	filetype = "CSP"
	size = 16
	var/InstallCost = 1
	var/Clonable = TRUE
	var/Deletable = TRUE
	clone(rename = FALSE, force = 0) // If you don't want to check clonability then set force to 1 when you call clone, maybe can used by ices that clone enemy program and use it 
		if(Clonable || force)
			. = ..()