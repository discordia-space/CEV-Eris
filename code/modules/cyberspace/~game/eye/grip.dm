/mob/observer/cyberspace_eye
	var/grip_size = 5
	var/list/grip = list()
	proc
		AddToGrip(value)
			if(grip_size > 0 && istype(value, /datum/computer_file/cyberdeck_program))
				var/datum/computer_file/cyberdeck_program/CP = value

