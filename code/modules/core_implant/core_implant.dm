/obj/item/weapon/implant/core_implant
	name = "core implant"
	icon = 'icons/obj/device.dmi'
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL=2, TECH_BIO=7, TECH_DATA=5)
	external = TRUE
	var/implant_type = /obj/item/weapon/implant/core_implant
	var/active = FALSE
	var/activated = FALSE			//true, if cruciform was activated once

	var/address = null
	var/power = 0
	var/max_power = 0
	var/power_regen = 0.5
	var/success_modifier = 1
	var/list/rituals = list()

	var/list/modules = list()
	var/list/upgrades = list()

/obj/item/weapon/implant/core_implant/Destroy()
	STOP_PROCESSING(SSobj, src)
	deactivate()
	. = ..()

/obj/item/weapon/implant/core_implant/New()
	START_PROCESSING(SSobj, src)
	add_hearing()
	..()

/obj/item/weapon/implant/core_implant/install(var/mob/M)
	if(ishuman(M))
		..(M)

/obj/item/weapon/implant/core_implant/uninstall()
	if(active)
		hard_eject()
		deactivate()
	..()

/obj/item/weapon/implant/core_implant/activate()
	if(!wearer || active)
		return
	active = TRUE
	activated = TRUE
	add_ritual_verbs()

/obj/item/weapon/implant/core_implant/deactivate()
	if(!active)
		return
	remove_hearing()
	active = FALSE
	remove_ritual_verbs()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/implant/core_implant/proc/add_ritual_verbs()
	if(!wearer || !active)
		return

	for(var/r in rituals)
		if(ispath(r,/datum/ritual/mind))
			var/datum/ritual/mind/m = r
			wearer.verbs |= initial(m.activator_verb)

/obj/item/weapon/implant/core_implant/proc/remove_ritual_verbs()
	if(!wearer || !active)
		return

	for(var/r in rituals)
		if(ispath(r,/datum/ritual/mind))
			var/datum/ritual/mind/m = r
			wearer.verbs.Remove(initial(m.activator_verb))

/obj/item/weapon/implant/core_implant/malfunction()
	hard_eject()

/obj/item/weapon/implant/core_implant/proc/hard_eject()
	return

/obj/item/weapon/implant/core_implant/proc/update_address()
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

/obj/item/weapon/implant/core_implant/hear_talk(mob/living/carbon/human/H, message)
	if(wearer != H)
		return

	remove_module(get_module(CORE_GROUP_RITUAL))

	for(var/RT in rituals)
		var/datum/ritual/R = new RT
		if(R.compare(message))
			if(R.power > src.power)
				H << SPAN_DANGER("Not enough energy for the [R.name].")
				return
			if(!R.is_allowed(src))
				H << SPAN_DANGER("You are not allowed to perform [R.name].")
				return
			R.activate(H, src, R.get_targets(message))
			return


/obj/item/weapon/implant/core_implant/proc/use_power(var/value)
	power = max(0, power - value)

/obj/item/weapon/implant/core_implant/proc/restore_power(var/value)
	power = min(max_power, power + value)

/obj/item/weapon/implant/core_implant/Process()
	if(!active)
		return
	if((!wearer || loc != wearer) && active)
		remove_hearing()
		active = FALSE
		STOP_PROCESSING(SSobj, src)
	restore_power(power_regen)

/obj/item/weapon/implant/core_implant/proc/get_module(var/m_type)
	if(!ispath(m_type))
		return
	for(var/datum/core_module/CM in modules)
		if(istype(CM,m_type))
			return CM
	process_modules()

/obj/item/weapon/implant/core_implant/proc/add_module(var/datum/core_module/CM)
	if(!istype(src,CM.implant_type))
		return FALSE
	CM.set_up()
	CM.implant = src
	CM.install_time = world.time
	CM.preinstall()
	modules.Add(CM)
	CM.install()
	return TRUE

/obj/item/weapon/implant/core_implant/proc/remove_module(var/datum/core_module/CM)
	if(istype(CM) && CM.implant == src)
		CM.uninstall()
		modules.Remove(CM)
		CM.implant = null

/obj/item/weapon/implant/core_implant/proc/remove_modules(var/m_type)
	if(!ispath(m_type))
		return
	for(var/datum/core_module/CM in modules)
		if(istype(CM,m_type))
			remove_module(CM)


/obj/item/weapon/implant/core_implant/proc/process_modules()
	for(var/datum/core_module/CM in modules)
		if(CM.time > 0 && CM.install_time + CM.time <= world.time)
			CM.uninstall()


