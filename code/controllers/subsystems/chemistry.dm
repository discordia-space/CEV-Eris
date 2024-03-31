SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	wait = 2 SECONDS

	var/list/active_holders = list()
	var/list/chemical_reactions
	var/list/chemical_reagents

/datum/controller/subsystem/chemistry/Initialize(start_timeofday)
	chemical_reactions = GLOB.chemical_reactions_list
	chemical_reagents = GLOB.chemical_reagents_list
	return ..()

/datum/controller/subsystem/chemistry/fire()
	for(var/thing in active_holders)
		var/datum/reagents/holder = thing
		if(!holder.process_reactions())
			active_holders -= holder
		CHECK_TICK

/datum/controller/subsystem/chemistry/proc/chem_mark_for_update(datum/reagents/holder)
	if(holder in active_holders)
		return

	//Process once, right away. If we still need to continue then add to the active_holders list and continue later
	if(holder.process_reactions())
		active_holders += holder

/datum/controller/subsystem/chemistry/stat_entry(msg)
	msg += "[LAZYLEN(active_holders)] reagent holder\s"
	return ..()

/datum/controller/subsystem/chemistry/proc/get_random_chem(var/only_if_unique = FALSE, temperature = T20C)
/*	for(var/type in typesof(/datum/reagent/random))
		if(only_if_unique && random_chem_prototypes[type])
			continue
		if(get_prototype(type, temperature)) //returns truthy if it's valid for the given temperature
			return type*/
	var/datum/reagent/random_type = pick(typesof(/datum/reagent))
	var/datum/reagent/random_r = new random_type(src)
	return random_r.id