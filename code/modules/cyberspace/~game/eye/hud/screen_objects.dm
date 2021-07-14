/obj/screen/movable/cyberspace_eye
	name = "cyberspace hud"
	icon = 'icons/obj/cyberspace/hud/common.dmi'
	var/StateOfBase = "base"
	var/tmp/image/CachedBase
	layer = ABOVE_HUD_LAYER + 1
	maptext_x = 6
	maptext_y = 12
	var/maptext_style = "font-family: 'Small Fonts'"

	on_update_icon()
		. = ..()
		if(istext(StateOfBase) || istype(CachedBase))
			var/image/old_image = CachedBase
			if(StateOfBase && !(istype(CachedBase) && CachedBase.icon_state == StateOfBase))
				CachedBase = image(icon,,StateOfBase)
			if(old_image != CachedBase)
				underlays -= old_image
				qdel(old_image)
			underlays |= CachedBase

/obj/screen/movable/cyberspace_eye/Click(location, control, params)

/obj/screen/movable/cyberspace_eye/exit
	name = "Jack Out"
	maptext = "<font style=\"font-family: 'Small Fonts'\">EXIT</font>"

/obj/screen/movable/cyberspace_eye/exit/Click()
	. = ..()
	if(parentmob)
		var/mob/observer/cyberspace_eye/avatar = parentmob
		if(istype(avatar))
			avatar.ReturnToBody()

/obj/screen/movable/cyberspace_eye/hardware
	name = "Hardware"
	var/obj/item/weapon/deck_hardware/myObject
	var/tmp/image/cachedObjectImage = new

	Click(location, control, params)
		. = ..()
		if(istype(myObject))
			myObject.Activate(usr)
		update_icon()

	on_update_icon()
		. = ..()
		if(!istype(cachedObjectImage))
			cachedObjectImage = new
		if(istype(myObject))
			cachedObjectImage.SyncWithAtom(myObject)
			/*
			cachedObjectImage.icon = myObject.icon
			cachedObjectImage.icon_state = myObject.icon_state
			cachedObjectImage.overlays = myObject.overlays
			*/
		else
			cachedObjectImage.icon = null
			cachedObjectImage.icon_state = null
			cachedObjectImage.overlays = null
		overlays |= cachedObjectImage

	proc/SetObject(obj/item/weapon/deck_hardware/H)
		myObject = H
		update_icon()

/obj/screen/movable/cyberspace_eye/program
	name = "Program To Install"

	var/datum/computer_file/cyberdeck_program/myObject

	Click(location, control, params)
		. = ..()
		if(istype(myObject))
			var/mob/observer/cyberspace_eye/avatar = parentmob
			if(istype(avatar) && avatar.TryInstallProgram(myObject))
				avatar.InstallProgram(myObject)
			
	on_update_icon()
		. = ..()
		if(istype(myObject))
			overlays |= image(myObject.icon, null, myObject.state)

	proc
		SetObject(datum/computer_file/cyberdeck_program/H) //TODO, add icons to /datum/computer_file/
			if(istype(myObject) && myObject != H)
				overlays -= myObject

			myObject = H
			update_icon()

/obj/screen/movable/cyberspace_eye/counter
	StateOfBase = "counter"
	maptext_x = 8
	maptext_y = 2

/obj/screen/movable/cyberspace_eye/counter/QuantumPointsCounter
	name = "QP Counter"
	icon_state = "qp"
	maptext = "0"

/obj/screen/movable/cyberspace_eye/counter/QuantumPointsCounter/on_update_icon()
	. = ..()
	var/mob/observer/cyberspace_eye/avatar = parentmob
	if(istype(avatar) && istype(avatar.owner))
		var/obj/item/weapon/computer_hardware/deck/myDeck = avatar.owner
		maptext = "<font style=\"[maptext_style]\">[myDeck.QuantumPoints]</font>"

/obj/screen/movable/cyberspace_eye/counter/size
	name = "Memory"
	icon_state = "mem"
	var/datum/MemoryStack/stack
	maptext = "0/0"

/obj/screen/movable/cyberspace_eye/counter/size/on_update_icon()
	. = ..()
	var/mob/observer/cyberspace_eye/avatar = parentmob
	if(istype(avatar) && istype(avatar.owner))
		var/obj/item/weapon/computer_hardware/deck/D = avatar.owner
		maptext = "<font style=\"[maptext_style]\">[D.GetBusyMemory()]/[D.memory_buffer.Memory]</font>"
