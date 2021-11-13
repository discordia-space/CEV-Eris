/obj/item/deck_hardware
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

	var/obj/item/computer_hardware/deck/myDeck

	var/Memory = 0
	var/LinkStreight = 0

	proc
		TryInstallTo(obj/item/computer_hardware/deck/_deck) // Return TRUE if successful, if TRUE returned this will automaticaly moved in deck. You shouldn't move it forced.
			. = _deck?.IsHardwareSuits(hardware_size)
		Installed(obj/item/computer_hardware/deck/_deck)
			myDeck = _deck
			myDeck.hardware |= src

		Uninstalled(obj/item/computer_hardware/deck/_deck)
		Activate(mob/user)
			next_activation = max(world.time + Cooldown, next_activation)
		// Do not call CanActivated here, Activate should be raw proc of activation, if you want to check something and it is avoidable then override CanActivated
		CanActivated(mob/user)
			. = istype(loc, /obj/item/computer_hardware/deck) && CheckIntegrity() && (next_activation <= world.time)
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

		AddEffects(obj/item/computer_hardware/deck/_deck)
//			_deck.AddMemory(Memory)
//			_deck.AddLinkStreight(LinkStreight)
		RemoveEffects(obj/item/computer_hardware/deck/_deck)
//			_deck.AddMemory(-Memory)
//			_deck.AddLinkStreight(-LinkStreight)

	Installed(obj/item/computer_hardware/deck/_deck)
		. = ..()
		if(. && CheckIntegrity())
			AddEffects(_deck)

	Uninstalled(obj/item/computer_hardware/deck/_deck)
		. = ..()
		if(!broken)
			AddEffects(_deck)
	Broken()
		. = ..()
		if(istype(myDeck))
			RemoveEffects(loc)
