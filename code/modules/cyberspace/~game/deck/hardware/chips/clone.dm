/obj/item/deck_hardware/chip/clone
	name = "clone chip"
	desc = "A red chip with black and white technomancers' insignia on it's top."

	SoftName = "Clone Chip"
	ActionDescription = "If able, clone installed program and install clone costing it's QP and memory."

	AdditionalDescription = "The best practice is to back up the backup."

	CanActivated(mob/user)
		. = ..()
		if(istype(loc, /obj/item/computer_hardware/deck))
			var/obj/item/computer_hardware/deck/myDeck = loc
			. = . && myDeck.IsWorking() && myDeck.CheckMemory()

	Activate(mob/user) // TODO: It must install program not copy in grip
		if(istype(loc, /obj/item/computer_hardware/deck))
			var/obj/item/computer_hardware/deck/myDeck = loc
			var/datum/computer_file/cyberdeck_program/programToClone = input(user, "Select program to clone.", "Clone Chip") in (myDeck.memory_buffer.GetNames() + "(CANCEL)")
			
			programToClone = myDeck.memory_buffer.ProgramByName(programToClone)

			var/message = "Action canceled."
			
			if(programToClone != "(CANCEL)" && istype(programToClone))
				var/datum/computer_file/cyberdeck_program/clone = programToClone.clone()
				if(myDeck.InstallProgram(clone))
					. = ..()
					message = "Chip activated succesfull."
				else
					qdel(clone)
					message = "No available memory."
			to_chat(user, SPAN_WARNING(message))
	