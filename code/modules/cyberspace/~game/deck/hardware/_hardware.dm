/obj/item/weapon/deck_hardware
	name = "unknown hardware"
	desc = "This is a core type of cyberdeck hardware, you shouldn't see this."
	var/SoftName = "Unknown"
	var/ActionDescription = "Do nothing (If you encountered this in-game then ask devs)."
	var/Integrity = 10
	var/hardware_size = 1
	var/broken = FALSE
	proc
		TryInstallTo(obj/item/weapon/computer_hardware/_deck) // Return TRUE if successful, if TRUE returned this will automaticaly moved in deck
		Installed(obj/item/weapon/computer_hardware/_deck)
		Uninstalled(obj/item/weapon/computer_hardware/_deck)
		Activate(mob/user)
		// Do not call CanActivated here, Activate should be raw proc of activation, if you want to check something and it is avoidable then override CanActivated
		CanActivated(mob/user)
			. = CheckIntegrity()
		CheckIntegrity()
			if(Integrity > 0)
				. = TRUE
			else
				Broken()
		
		SetIntegrity(value)
			if(Integrity != value)
				. = TRUE
				Integrity = max(0, value)
			CheckIntegrity()

		Broken()
			do_sparks(3, 0, get_turf(src))
			broken = TRUE

	var/Memory = 0
	var/LinkStreight = 0

	Installed(obj/item/weapon/computer_hardware/deck/_deck)
		. = ..()
		if(. && CheckIntegrity())
			_deck.memory += Memory
			_deck.link_streight += LinkStreight

	Uninstalled(obj/item/weapon/computer_hardware/deck/_deck)
		. = ..()
		if(!broken)
			_deck.memory -= Memory
			_deck.link_streight -= LinkStreight
	Broken()
		. = ..()
		if(istype(loc, /obj/item/weapon/computer_hardware/deck))
			var/obj/item/weapon/computer_hardware/deck/_deck = loc
			_deck.memory -= Memory
			_deck.link_streight -= LinkStreight
