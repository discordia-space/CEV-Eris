/obj/item/weapon/deck_hardware/chip/memory_crystal
	name = "memory plank with crystall"
	desc = "The small plank with silicon crystall on it."

	SoftName = "T381 Memory Crystal"
	ActionDescription = "Memory buffer extends by 1 for 20 minutes. Can be activated not in run."

	Memory = 1

	Activate(mob/user)
		if(alert(user, "Are you sure you want activate [SoftName]", "[SoftName]", "Yes","No") == "Yes")
		if(istype(loc, /obj/item/weapon/computer_hardware/deck))
			var/obj/item/weapon/computer_hardware/deck/myDeck = loc
			