/datum/component/computer_hardware
	dupe_mode = COMPONENT_DUPE_UNIQUE
	can_transfer = FALSE
	var/obj/item/modular_computer/linked_computer = null
	var/hardware_size = MODCOMP_SIZE_SMALL
	var/hardware_power_usage = MODCOMP_POWER_USAGE_SMALL
	var/powered = FALSE


/datum/component/computer_hardware/Initialize()
	. = ..()
	linked_computer

/datum/component/computer_hardware/RemoveComponent()
	..()

/datum/component/computer_hardware/proc/CanPower()
	SIGNAL_HANDLER
