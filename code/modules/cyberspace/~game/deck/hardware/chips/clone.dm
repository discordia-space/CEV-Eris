/obj/item/weapon/deck_hardware/chip/clone
	name = "clone chip"
	desc = "A red chip with black and white technomancers' insignia on it's top."

	SoftName = "Clone Chip"
	ActionDescription = "If able, clone installed program and install clone costing it's CP and memory."

	AdditionalDescription = "The best practice is to back up the backup."

	CanActivated(mob/user)
		. = ..()
		if(istype(loc, /obj/item/weapon/computer_hardware/deck))
			var/obj/item/weapon/computer_hardware/deck/myDeck = loc
			. = . && myDeck.CheckMemory()

	Activate(mob/user)
		if(istype(loc, /obj/item/weapon/computer_hardware/deck))
			var/obj/item/weapon/computer_hardware/deck/myDeck = loc
			var/datum/computer_file/cyberdeck_program/programToClone = input(user, "Select program to clone.", "Clone Chip") in (myDeck.programs.Copy() + "(CANCEL)")
			
			var/message = "Action canceled."
			
			if(programToClone != "(CANCEL)")
				if(myDeck.CheckMemory(programToClone.size))
					var/datum/computer_file/cyberdeck_program/clone = programToClone.clone()
					myDeck.programs += clone
					. = ..()
					message = "Chip activated succesfull."
				else
					message = "No available memory."
			to_chat(user, SPAN_WARNING(message))
