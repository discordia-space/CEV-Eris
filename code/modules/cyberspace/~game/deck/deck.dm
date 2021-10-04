/obj/item/computer_hardware/deck
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

	var/link_streight = 0 // Default power over tracing by ices or on ices can be increased by programs/hardware


/*
	var/datum/MemoryStack/memory_buffer = new // Grip of programs, icebreakers and etc. Installed programs handling in cyberspace eye
	var/initial_memory_buffer = 64
	var/MemoryForInstalledPrograms = 64
*/
	var/hardware_slots = 4
	var/chip_slots = 4 // Slots for chips, to extend or buy better deck or get hardware extending them.
	var/list/hardware = list()

	var/mob/observer/cyberspace_eye/projected_mind = /mob/observer/cyberspace_eye/runner

	var/obj/item/mind_cable/cable

	Initialize()
		. = ..()
		if(ispath(projected_mind))
			projected_mind = new projected_mind()
			projected_mind.owner = src
/*
		if(istype(memory_buffer))
			memory_buffer.Memory = initial_memory_buffer
*/
	proc/CancelCyberspaceConnection()
		update_power_usage()
		if(istype(projected_mind))
			projected_mind.Disconnected(src)
			projected_mind.PutInAnotherMob(get_user())
			projected_mind.relocateTo(src)
			projected_mind.destroy_HUD()

	disabled()
		. = ..()
		CancelCyberspaceConnection()

	proc/SetCable(obj/item/mind_cable/_cable) //returns new location if set successful, else return null
		if(cable != _cable && istype(cable))
			cable.DisconnectFromDeck()
		if(istype(_cable))
			cable = _cable
			return cable.ConnectToDeck(src)

	proc/SetUpProjectedMind()
		//projected_mind.InstalledPrograms.Memory = MemoryForInstalledPrograms
		if(cable?.owner?.UIStyle)
			projected_mind.defaultHUD = cable.owner.UIStyle
		projected_mind.reset_HUD()

	proc/PlaceProjectedMind()
		return projected_mind.Connected(src)

	attackby(obj/item/W, mob/living/user)
		. = ..()
		if(!.)
			var/obj/item/deck_hardware/H = W
			if(istype(W, /obj/item/mind_cable) && do_after(user, 1 SECONDS, src))
				. = SetCable(W)
			else if(istype(W, /obj/item/deck_hardware) && do_after(user, 1 SECONDS, src))
				. = H.TryInstallTo(src)
				if(.)
					H.relocateTo(src)
					H.Installed(src)
			if(.)
				playsound(get_turf(src), 'sound/weapons/guns/interact/pistol_magin.ogg', 75, 1)
			SetUpProjectedMind()

/obj/item/computer_hardware/deck/proc
	IsWorking()
		return projected_mind.loc != src
	GetFreeChipSlots()
		for(var/obj/item/deck_hardware/chip/C in hardware)
			. -= C.chip_slot_costing
		. += chip_slots // for example: - 2 + 4 = 2

	IsHardwareSuits(hardware_size = 1)
		for(var/obj/item/deck_hardware/H in hardware)
			. += H.hardware_size
		. = (hardware_slots - .) >= hardware_size

	update_power_usage()
		if(!connection)
			power_usage = power_usage_idle
		else
			power_usage = power_usage_using

	get_user()
		if(istype(cable) && istype(cable.owner))
			var/obj/item/organ/internal/data_jack/data_jack = cable.owner
			return data_jack.owner

	DisconnectCable()
		cable = null

	BeginCyberspaceConnection()
		update_power_usage()
		var/mob/living/carbon/human/owner = get_user()
		if(istype(owner) && owner.stat == CONSCIOUS && owner.mind)
			SetUpProjectedMind()
			PlaceProjectedMind()
			return owner.PutInAnotherMob(projected_mind)
	
	AddLinkStreight(count)
		link_streight += count

