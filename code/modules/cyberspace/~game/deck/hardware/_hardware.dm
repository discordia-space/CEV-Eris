/obj/item/weapon/deck_hardware
	name = "unknown hardware"
	desc = "This is a core type of cyberdeck hardware, you shouldn't see this."

	icon = 'icons/obj/cyberspace/hardware/hardware.dmi'


	var/SoftName = "Unknown" // Title of hardware in decks' hardware manager
	var/ActionDescription // text that will describe what will happen when hardware become active.
	var/AdditionalDescription // Put here any IC comments from creators or previous owners of this. Users maybe will get access to change this.

	var/Integrity = 10
	var/tmp/next_activation //Time of last activation
	var/Cooldown = 1 MINUTE

	var/hardware_size = 1

	var/broken = FALSE

	var/NeedToBeInCyberSpace = TRUE

	var/obj/item/weapon/computer_hardware/deck/myDeck

	proc
		TryInstallTo(obj/item/weapon/computer_hardware/deck/_deck) // Return TRUE if successful, if TRUE returned this will automaticaly moved in deck. You shouldn't move it forced.
			. = _deck?.IsHardwareSuits(hardware_size)
		Installed(obj/item/weapon/computer_hardware/deck/_deck)
			myDeck = _deck
			myDeck.hardware |= src

		Uninstalled(obj/item/weapon/computer_hardware/deck/_deck)
		Activate(mob/user)
			next_activation = max(world.time + Cooldown, next_activation)
		// Do not call CanActivated here, Activate should be raw proc of activation, if you want to check something and it is avoidable then override CanActivated
		CanActivated(mob/user)
			. = istype(loc, /obj/item/weapon/computer_hardware/deck) && CheckIntegrity() && (next_activation <= world.time)
		CheckIntegrity()
			if(!broken)
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
			_deck.AddMemory(Memory)
			_deck.AddLinkStreight(LinkStreight)

	Uninstalled(obj/item/weapon/computer_hardware/deck/_deck)
		. = ..()
		if(!broken)
			_deck.AddMemory(-Memory)
			_deck.link_streight -= LinkStreight
	Broken()
		. = ..()
		if(istype(loc, /obj/item/weapon/computer_hardware/deck))
			var/obj/item/weapon/computer_hardware/deck/_deck = loc
			_deck.AddMemory(-Memory)
			_deck.AddLinkStreight(-LinkStreight)
