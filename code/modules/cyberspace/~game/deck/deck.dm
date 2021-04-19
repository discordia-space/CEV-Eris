/obj/item/weapon/computer_hardware/deck
	name = "cyberspace deck"
	desc = "A strange device with port for data jacks."
	
	icon = 'icons/obj/cyberspace/deck.dmi'
	icon_state = "common"
	hardware_size = 1
	power_usage = 100
	origin_tech = list(TECH_BLUESPACE = 2, TECH_DATA = 4)
	price_tag = 100

	var/connection = FALSE
	var/power_usage_idle = 100
	var/power_usage_using = 2 KILOWATTS


	var/memory = 64 // Memory slots for programs, can be extended by hardware
	var/list/programs = list() // Installed programs, icebreakers and etc.

	var/hardware_slots = 8
	var/chip_slots = 4 // Same as memory, to extend or buy better deck or get hardware extending them.
	var/link_streight = 0 // Power over tracing by ices or on ices can be increased by programs/hardware
	var/list/hardware = list()

	var/mob/observer/cyberspace_eye/projected_mind = /mob/observer/cyberspace_eye/runner

	var/obj/item/mind_cable/cable

	Initialize()
		. = ..()
		if(ispath(projected_mind))
			projected_mind = new projected_mind()
			projected_mind.owner = src
	attackby(obj/item/W, mob/living/user)
		. = ..()
		if(!.)
			var/obj/item/weapon/deck_hardware/H = W
			if(istype(W, /obj/item/mind_cable) && do_after(user, 1 SECONDS, src))
				. = SetCable(W)
			else if(istype(W, /obj/item/weapon/deck_hardware))
				. = H.TryInstallTo(src)
				if(.)
					H.relocateTo(src)
					H.Installed(src)
			if(.)
				playsound(get_turf(src), 'sound/weapons/guns/interact/pistol_magin.ogg', 75, 1)

/obj/item/weapon/computer_hardware/deck/proc
	GetFreeChipSlots()
		for(var/obj/item/weapon/deck_hardware/chip/C in hardware)
			. -= C.chip_slot_costing
		. += chip_slots // for example: - 2 + 4 = 2
	IsHardwareSuits(hardware_size = 1)
		for(var/obj/item/weapon/deck_hardware/H in hardware)
			. += H.hardware_size
		. = (hardware_slots - .) >= hardware_size
	CheckMemory(used)
		. = IsProgramSuits(used) >= 0

	IsProgramSuits(used = 16) // Returns delta of memory after applying using, so if this returns more than 0 then memory is enough
		for(var/datum/computer_file/cyberdeck_program/program in programs)
			. += program.size
		. = memory - (. + used)

	update_power_usage()
		if(!connection)
			power_usage = power_usage_idle
		else
			power_usage = power_usage_using
	SetCable(obj/item/mind_cable/_cable) //returns new location if set successful, else return null
		if(cable != _cable && istype(cable))
			cable.DisconnectFromDeck()
		if(istype(_cable))
			cable = _cable
			return cable.ConnectToDeck(src)

	get_user()
		if(istype(cable) && istype(cable.owner))
			var/obj/item/organ/internal/data_jack/data_jack = cable.owner
			return data_jack.owner

	DisconnectCable()
		cable = null

	BeginCyberspaceConnection()
		var/mob/living/carbon/human/owner = get_user()
		if(istype(owner) && owner.stat == CONSCIOUS && owner.mind)
			projected_mind.dropInto(src)
			return owner.PutInAnotherMob(projected_mind)

	CancelCyberspaceConnection()
		if(istype(projected_mind))
			projected_mind.PutInAnotherMob(get_user())
			projected_mind.relocateTo(src)
