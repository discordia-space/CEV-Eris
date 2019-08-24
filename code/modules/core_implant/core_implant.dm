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
	var/list/known_rituals = list() //A list of names of rituals which are recorded in this cruciform
	//These are used to retrieve the actual ritual datums from the global all_rituals list

	var/list/modules = list()
	var/list/upgrades = list()

	var/list/access = list()	// Core implant can grant access levels to its user

/obj/item/weapon/implant/core_implant/Destroy()
	STOP_PROCESSING(SSobj, src)
	deactivate()
	. = ..()

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
	update_rituals()
	START_PROCESSING(SSobj, src)
	add_hearing()

/obj/item/weapon/implant/core_implant/deactivate()
	if(!active)
		return
	remove_hearing()
	active = FALSE
	remove_ritual_verbs()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/implant/core_implant/proc/update_rituals()
	known_rituals = list()
	for(var/datum/core_module/rituals/M in modules)
		if(istype(src,M.implant_type))
			for(var/R in M.module_rituals)
				known_rituals |= R

/obj/item/weapon/implant/core_implant/proc/add_ritual_verbs()
	if(!wearer || !active)
		return

	for(var/r in known_rituals)
		if(ispath(r,/datum/ritual/mind))
			var/datum/ritual/mind/m = r
			wearer.verbs |= initial(m.activator_verb)

/obj/item/weapon/implant/core_implant/proc/remove_ritual_verbs()
	if(!wearer || !active)
		return

	for(var/r in known_rituals)
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

/obj/item/weapon/implant/core_implant/GetAccess()
	if(!activated) // A brand new implant can't be used as an access card, but one pulled from a corpse can.
		return list()

	var/list/L = access.Copy()
	for(var/m in modules)
		var/datum/core_module/M = m
		L |= M.GetAccess()
	return L

/obj/item/weapon/implant/core_implant/hear_talk(mob/living/carbon/human/H, message, verb, datum/language/speaking, speech_volume)
	for(var/datum/core_module/group_ritual/GR in src.modules)
		GR.hear(H, message)

	if(wearer != H)
		return

	for(var/RT in known_rituals)
		var/datum/ritual/R = GLOB.all_rituals[RT]
		if(R.compare(message))
			if(R.power > src.power)
				to_chat(H, SPAN_DANGER("Not enough energy for the [R.name]."))
				return
			if(!R.is_allowed(src))
				to_chat(H, SPAN_DANGER("You are not allowed to perform [R.name]."))
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

	if(!CM.can_install(src))
		return FALSE

	if(CM.unique)
		for(var/datum/core_module/EM in modules)
			if(EM.type == CM.type)
				return FALSE

	CM.implant = src
	CM.set_up()
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
		qdel(CM)

/obj/item/weapon/implant/core_implant/proc/remove_modules(var/m_type)
	if(!ispath(m_type))
		return
	for(var/datum/core_module/CM in modules)
		if(istype(CM,m_type))
			remove_module(CM)

/obj/item/weapon/implant/core_implant/proc/install_default_modules_by_job(datum/job/J)
	for(var/module_type in J.core_upgrades)
		add_module(new module_type)

/obj/item/weapon/implant/core_implant/proc/process_modules()
	for(var/datum/core_module/CM in modules)
		if(CM.time > 0 && CM.install_time + CM.time <= world.time)
			CM.uninstall()

/obj/item/weapon/implant/core_implant/proc/get_rituals()
	return known_rituals
