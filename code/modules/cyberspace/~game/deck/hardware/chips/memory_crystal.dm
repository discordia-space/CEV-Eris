/obj/item/deck_hardware/chip/memory_crystal
	name = "memory plank with crystall"
	desc = "The small plank with big silicon crystall on it and 4 smaller that connected to big by orange lines."

	SoftName = "T381 Memory Crystal"
	ActionDescription = "Extends memory buffer by (memory of this chip x 2) for 20 minutes. Can be activated not in run."

	AdditionalDescription = "Sometimes you need extra SPACE in your grip, cowboy."

	Memory = 16

	NeedToBeInCyberSpace = FALSE

	Activate(mob/user)
		var/obj/item/computer_hardware/deck/myDeck = loc
		. = Memory * 2
		myDeck.TemporaryExtendGrip(., 20 MINUTES)
		return ..() && .

