/obj/screen/movable/cyberspace_eye
	name = "cyberspace hud"
	icon = 'icons/obj/cyberspace/hud/common.dmi'
	icon_state = "base"

/obj/screen/movable/cyberspace_eye/Click(location, control, params)
	return istype(parentmob)

/obj/screen/movable/cyberspace_eye/exit
	name = "Jack Out"
	icon_state = "jack_out"

/obj/screen/movable/cyberspace_eye/exit/Click()
	. = ..()
	if(.)
		var/mob/observer/cyberspace_eye/avatar = parentmob
		if(istype(avatar))
			avatar.ReturnToBody()

/obj/screen/movable/cyberspace_eye/QuantumPointsCounter
	name = "QP Counter"
	icon_state = "counter"

/obj/screen/movable/cyberspace_eye/QuantumPointsCounter/on_update_icon()
	var/mob/observer/cyberspace_eye/avatar = parentmob
	if(istype(avatar))
		var/obj/item/weapon/computer_hardware/deck/myDeck = avatar.owner
		if(istype(myDeck))
			maptext = "[myDeck.QuantumPoints] QP"

/obj/screen/movable/cyberspace_eye/hardware
	name = "Chip"
	icon_state = "base"

	var/obj/item/weapon/deck_hardware/myObject

	Click(location, control, params)
		. = ..()
		if(istype(myObject))
			myObject.Activate()
	on_update_icon()
		. = ..()
		if(istype(myObject))
			overlays |= image(myObject.icon, null, myObject.icon_state)

	proc
		SetObject(obj/item/weapon/deck_hardware/H)
			if(istype(myObject) && myObject != H)
				overlays -= myObject

			myObject = H
			update_icon()

/obj/screen/movable/cyberspace_eye/hardware
	name = "Program To Install"
	icon_state = "base"

	var/obj/item/weapon/deck_hardware/myObject

	Click(location, control, params)
		. = ..()
		if(istype(myObject))
			myObject.Activate()
	on_update_icon()
		. = ..()
		if(istype(myObject))
			overlays |= image(myObject.icon, null, myObject.icon_state)

	proc
		SetObject(obj/item/weapon/deck_hardware/H)
			if(istype(myObject) && myObject != H)
				overlays -= myObject

			myObject = H
			update_icon()

