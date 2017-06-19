/obj/item/weapon/implant/external/core_implant
	name = "core implant"
	icon = 'icons/obj/device.dmi'
	w_class = 2
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	var/power = 0
	var/max_power = 0
	var/success_modifier = 1
	var/active = FALSE
	var/activated = FALSE			//true, if cruciform was activated once
	var/address = null				//string, used as id for targeted rituals

	var/rituals = list()

/obj/item/weapon/implant/external/core_implant/Destroy()
	processing_objects.Remove(src)
	deactivate()
	..()


/obj/item/weapon/implant/external/core_implant/install(var/mob/M)
	if(ishuman(M))
		..(M)

/obj/item/weapon/implant/external/core_implant/uninstall()
	deactivate()
	..()


/obj/item/weapon/implant/external/core_implant/activate()
	if(!wearer || active)
		return
	active = TRUE
	activated = TRUE
	processing_objects |= src
	add_hearing()

/obj/item/weapon/implant/external/core_implant/deactivate()
	if(!active)
		return
	remove_hearing()
	active = FALSE
	processing_objects.Remove(src)


/obj/item/weapon/implant/external/core_implant/malfunction()
	hard_eject()

/obj/item/weapon/implant/external/core_implant/proc/hard_eject()
	return

/obj/item/weapon/implant/external/core_implant/proc/update_address()
	if(!loc)
		address = null
		return

	if(wearer)
		address = wearer.real_name
		return

	var/area/A = get_area(src)
	if(istype(loc, /obj/machinery/neotheology))
		address = "[loc.name] in [strip_improper(A.name)]"
		return

	address = null

/obj/item/weapon/implant/external/core_implant/hear_talk(mob/living/carbon/human/H, message)
	if(wearer != H)
		return

	for(var/RT in rituals)
		var/datum/ritual/R = new RT
		if(R.compare(message))
			if(R.power > src.power)
				H << "<span class='danger'>Not enough energy for the [R.name].</span>"
				return
			if(!R.is_allowed(src))
				H << "<span class='danger'>You are not allowed to perform [R.name].</span>"
				return
			R.activate(H, src, R.get_targets(message))


/obj/item/weapon/implant/external/core_implant/proc/use_power(var/value)
	power = max(0, power - value)

/obj/item/weapon/implant/external/core_implant/proc/restore_power(var/value)
	power = min(max_power, power + value)

/obj/item/weapon/implant/external/core_implant/process()
	if(!active)
		return
	if((!wearer || loc != wearer) && active)
		remove_hearing()
		active = FALSE
		processing_objects.Remove(src)
	restore_power(0.5)

