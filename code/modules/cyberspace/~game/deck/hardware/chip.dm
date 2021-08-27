/obj/item/deck_hardware/chip
	name = "chip"
	desc = "A strange chip."

	Integrity = 1

	hardware_size = 0

	Cooldown = 0
	var/chip_slot_costing = 1

	TryInstallTo(obj/item/computer_hardware/deck/_deck)
		. = ..() && _deck?.GetFreeChipSlots() > chip_slot_costing // No overrides cuz hardware_size = 0
			
	Activate(mob/user)
		SetIntegrity(Integrity - 1)
		return TRUE
	
	CanActivated(mob/user)
		return ..() && (alert(user, "Are you sure you want activate [SoftName]", "[SoftName]", "Yes", "No") == "Yes")