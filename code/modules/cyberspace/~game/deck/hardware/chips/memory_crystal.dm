/obj/item/weapon/deck_hardware/chip/memory_crystal
	name = "memory plank with crystall"
	desc = "The small plank with big silicon crystall on it and 4 smaller that connected to big by orange lines."

	SoftName = "T381 Memory Crystal"
	ActionDescription = "Extends memory buffer by (memory of this chip x 2) for 20 minutes. Can be activated not in run."

	AdditionalDescription = "Sometimes you need extra SPACE in your grip, cowboy."

	Memory = 16

	Activate(mob/user)
		if((alert(user, "Are you sure you want activate [SoftName]", "[SoftName]", "Yes", "No") == "Yes") && istype(loc, /obj/item/weapon/computer_hardware/deck))
			var/obj/item/weapon/computer_hardware/deck/myDeck = loc
			. = Memory * 2
			myDeck.GiveTemporaryMemory(., 20 MINUTES)
			return ..() && .

