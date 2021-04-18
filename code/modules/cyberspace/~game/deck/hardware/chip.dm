/obj/item/weapon/deck_hardware/chip
	name = "chip"
	desc = "A strange chip."

	Integrity = 1

	hardware_size = 0
	var/chip_slot_costing = 1

	// TryInstallTo(obj/item/weapon/computer_hardware/_deck)
	// Installed(obj/item/weapon/computer_hardware/_deck)
	Activate(mob/user)
		SetIntegrity(Integrity - 1)
		return TRUE
