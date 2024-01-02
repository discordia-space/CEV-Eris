/obj/item/implant/cyberinterface
	name = "cyberinterface"
	icon = 'icons/obj/neuralink.dmi'
	icon_state = "common"
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
	rarity_value = 300
	spawn_tags = SPAWN_ODDITY

/obj/item/implant/cyberinterface/proc/installSticksForJob(datum/job/jobz)
	for(var/path in jobz.cyberSticks)
		var/obj/item/cyberstick/stick = new path(NULLSPACE)
		installStick(stick, null, 0, FALSE)

/obj/item/implant/cyberinterface/can_install(mob/living/carbon/human/target, obj/item/organ/external/E)
	if(!istype(target))
		return FALSE
	var/obj/item/organ/internal/vital/brain/cyberBrain = locate(/obj/item/organ/internal/vital/brain) in target
	var/obj/item/implant/cyberinterface/opponent = locate() in E.implants
	if(opponent)
		return FALSE
	if(cyberBrain && cyberBrain.parent != E)
		return FALSE
	return TRUE

/obj/item/implant/cyberinterface/on_install(mob/living/carbon/human/target, obj/item/organ/external/E)
	E.update_cyberdeck_hud(src)

/obj/item/implant/cyberinterface/on_uninstall()
	for(var/obj/item/cyberstick/stick in slots)
		if(stick)
			stick.holdingSlot = null
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
		var/obj/thing = slots[i]
		if(!QDELETED(thing))
			continue
		return i
	return 0

/obj/item/implant/cyberinterface/proc/getFilledSlots()
	var/list/filledSlots = list()
	for(var/i = 1, i <= length(slots), i++)
		var/obj/thing = slots[i]
		if(!QDELETED(thing))
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

/// subtypes

/obj/item/implant/cyberinterface/basic
	name = "basic cyberinterface"
	desc = "A very basic model of cyberinterface. Has only 1 measly slot"
	icon_state = "cheap"
	slots = list(
		null
	)

/obj/item/implant/cyberinterface/contractor
	name = "contractor cyberinterface"
	desc = "A blackmarket cyberinterface, has 3 slots."
	icon_state = "league10"
	slots = list(
		null,
		null,
		null
	)

/obj/item/implant/cyberinterface/carrion
	name = "electro-organic interface"
	desc = "A spider of carrion design, acts as a interface between the host's brain and the cyberdecks. Has 3 slots."
	icon_state = "carrion"
	slots = list(
		null,
		null,
		null
	)
	spawn_blacklisted = TRUE

/obj/item/implant/cyberinterface/ironhammer
	name = "ironhammer combat interface"
	desc = "A cyberinterface of IH design. Has 2 slots."
	icon_state = "pmc"
	slots = list(
		null,
		null
	)
	spawn_blacklisted = TRUE

/obj/item/implant/cyberinterface/league
	name = "techmomancer's league tribesman interface"
	desc = "A cyberinterface of technomancer design for all members of the league. Has 3 slots."
	icon_state = "league1"
	slots = list(
		null,
		null,
		null
	)

/obj/item/implant/cyberinterface/league/leader
	name = "technomancer's league tribesleader interface"
	desc = "A cyberinterface of technomancer design for tribeleaders. Has 5 slots."
	icon_state = "league4"
	slots = list(
		null,
		null,
		null,
		null,
		null
	)
	spawn_blacklisted = TRUE

/obj/item/implant/cyberinterface/moebius
	name = "moebius brain-intranet interface"
	desc = "A round cyberinterface. Has 2 slots"
	icon_state = "moebius"
	slots = list(
		null,
		null
	)
	spawn_blacklisted = TRUE


/obj/item/implant/cyberinterface/asters
	name = "Aster's guild interface"
	desc = "A cyberinterface of Aster's guild. For the richest among the masses."
	icon_state = "guild"
	slots = list(
		null,
		null,
		null,
		null
	)
	spawn_blacklisted = TRUE






