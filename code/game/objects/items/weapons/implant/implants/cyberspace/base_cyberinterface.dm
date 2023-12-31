/obj/item/implant/cyberinterface
	name = "cyberinterface"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant_health"
	volumeClass = ITEM_SIZE_TINY
	matter = list(MATERIAL_STEEL = 1, MATERIAL_GLASS = 1)
	external = FALSE
	cruciform_resist = FALSE
	vscanner_hidden = FALSE	//Does this implant show up on the body scanner
	/// defines how many slots we have,  put in a typepath to have a implant initialize with some cybersticks
	var/list/slots = list(
		null,
		null,
		null
	)

/obj/item/implant/cyberinterface/can_install(mob/living/carbon/human/target, obj/item/organ/external/E)
	if(!locate(/obj/item/organ/internal/brain) in E)
		return FALSE
	if(locate(/obj/item/implant/cyberinterface) in E)
		return FALSE
	if(!istype(target))
		return FALSE
	return TRUE

/obj/item/implant/cyberinterface/on_install(mob/living/carbon/human/target, obj/item/organ/external/E)
	E.update_cyberdeck_hud(src)

/obj/item/implant/cyberinterface/on_uninstall()
	part.update_cyberdeck_hud(null)


/obj/item/implant/cyberinterface/Initialize()
	. = ..()
	for(var/i = 1, i < length(slots), i++)
		var/slotPath = slots[i]
		if(!ispath(slotPath))
			return
		var/atom/newStick = new slotPath(src)
		slots[i] = newStick
		newStick.onInstall(wearer)

/obj/item/implant/cyberinterface/proc/getEmptySlot()
	for(var/i = 1, i < length(slots), i++)
		if(!QDELETED(slots[i]))
			continue
		return i
	return 0

/obj/item/implant/cyberinterface/proc/getFilledSlots()
	var/list/filledSlots = list()
	for(var/i = 1, i < length(slots), i++)
		if(!QDELETED(slots[i]))
			filledSlots.Add(i)
	return filledSlots

/obj/item/implant/cyberinterface/proc/installStick(obj/item/cyberstick/stick, mob/living/carbon/human/user, targetSlot = 1, force = FALSE)
	if(targetSlot == 0)
		var/slotPos = getEmptySlot()
		if(!slotPos)
			to_chat(user, SPAN_NOTICE("\The [src] has no slots for this implant!"))
			return
		targetSlot = slotPos
	if(slots[targetSlot] && force)
		var/atom/existingStick = slots[targetSlot]
		existingStick.forcemove(get_turf(src))
		existingStick.onUninstall(wearer)
		user?.drop_from_inventory(stick)
		stick.forceMove(src)
		stick.onInstall(wearer)
		slots[targetSlot] = stick
		if(user)
			to_chat(user, SPAN_NOTICE("You switch \the [existingStick] inside of [src] with \the [stick]"))
			user.put_in_active_hand(existingStick)
	else
		if(user)
			to_chat(user, SPAN_NOTICE("You install \the [stick] into [src]'s slot number [targetSlot]"))
			user.drop_from_inventory(stick)
		stick.forceMove(src)
		slots[targetSlot] = stick
		stick.onInstall(wearer)
	part.update_cyberdeck_hud(src)

/obj/item/implant/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cyberstick))
		installStick(I, user, 0, FALSE)
		return
	if(I.has_quality(QUALITY_SCREW_DRIVING))
		var/chosenModule = input(user, "Choose cyberdeck to remove", "Cybermessin", null) as anything in getFilledSlots()
		if(chosenModule)
			var/atom/movable/stick = slots[chosenModule]
			slots[chosenModule] = null
			stick.onUninstall(wearer)
			stick.forceMove(get_turf(user))
			user.put_in_active_hand(stick)
			part.update_cyberdeck_hud(src)
		return
	..()

/obj/item/implant/cyberinterface/get_data()
	return "CYBERINTERFACE - Filled Slots : [length(getFilledSlots)]"

