/obj/item/implant/cyberinterface
	name = "cyberinterface"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant_health"
	volumeClass = ITEM_SIZE_TINY
	matter = list(MATERIAL_STEEL = 1, MATERIAL_GLASS = 1)
	external = FALSE
	cruciform_resist = FALSE
	scanner_hidden = FALSE	//Does this implant show up on the body scanner
	/// defines how many slots we have,  put in a typepath to have a implant initialize with some cybersticks
	var/list/slots = list(
		null,
		null,
		null
	)

/obj/item/implant/cyberinterface/proc/installSticksForJob(datum/job/jobz)
	for(var/path in jobz.cyberSticks)
		var/obj/item/cyberstick/stick = new path(NULLSPACE)
		message_admins("installing stick [stick]")
		installStick(stick, null, 0, FALSE)

/obj/item/implant/cyberinterface/can_install(mob/living/carbon/human/target, obj/item/organ/external/E)
	if(!istype(target))
		return FALSE
	var/obj/item/organ/internal/vital/brain/cyberBrain = locate(/obj/item/organ/internal/vital/brain) in target
	if(cyberBrain && cyberBrain.parent != E)
		return FALSE
	return TRUE

/obj/item/implant/cyberinterface/on_install(mob/living/carbon/human/target, obj/item/organ/external/E)
	E.update_cyberdeck_hud(src)

/obj/item/implant/cyberinterface/on_uninstall()
	part.update_cyberdeck_hud(null)


/obj/item/implant/cyberinterface/Initialize()
	. = ..()
	for(var/i = 1, i <= length(slots), i++)
		var/slotPath = slots[i]
		if(!ispath(slotPath))
			return
		var/obj/item/cyberstick/newStick = new slotPath(src)
		slots[i] = newStick
		newStick.onInstall(wearer)
	if(part)
		part.update_cyberdeck_hud(src)

/obj/item/implant/cyberinterface/proc/getEmptySlot()
	for(var/i = 1, i <= length(slots), i++)
		if(!QDELETED(slots[i]))
			continue
		return i
	return 0

/obj/item/implant/cyberinterface/proc/getFilledSlots()
	var/list/filledSlots = list()
	for(var/i = 1, i <= length(slots), i++)
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
		var/obj/item/cyberstick/existingStick = slots[targetSlot]
		existingStick.forceMove(get_turf(src))
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

/obj/item/implant/cyberinterface/proc/removeStick(targetSlot, mob/living/carbon/human/user)
	var/obj/item/cyberstick/stick = slots[targetSlot]
	slots[targetSlot] = null
	if(stick)
		stick.onUninstall(wearer)
		if(user)
			stick.forceMove(get_turf(user))
			user.put_in_active_hand(stick)
		else
			stick.forceMove(get_turf(src))
		stick.holdingSlot.update_icon()
		stick.holdingSlot = null

/obj/item/implant/cyberinterface/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cyberstick))
		installStick(I, user, 0, FALSE)
		return
	if(I && I.has_quality(QUALITY_SCREW_DRIVING))
		var/chosenModule = input(user, "Choose cyberdeck to remove", "Cybermessin", null) as anything in getFilledSlots()
		if(chosenModule)
			removeStick(chosenModule, user)
		return
	..()

/obj/item/implant/cyberinterface/get_data()
	return "CYBERINTERFACE - Filled Slots : [length(getFilledSlots())]"

