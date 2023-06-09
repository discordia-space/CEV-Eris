
/datum/component/jamming
	var/atom/movable/owner
	var/atom/movable/highest_container
	var/active = FALSE
	var/radius = 20
	var/power = 1
	// Z levels to bo above or below
	var/z_transfer = 0
	//reduction in range based on z-level diff
	var/z_reduction = 0
	dupe_mode = COMPONENT_DUPE_UNIQUE
	can_transfer = FALSE

/// To do , add a human signal handler
/datum/component/jamming/Initialize()
	. = ..()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	highest_container = owner.getContainingMovable()
	RegisterSignal(owner, COMSIG_ATOM_CONTAINERED, PROC_REF(OnContainered))
	RegisterSignal(highest_container, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(OnLevelChange))

/datum/component/jamming/proc/getAffectedLevels(targetLevel)
	var/minimumLevel = targetLevel
	var/maximumLevel = targetLevel
	while(HasBelow(minimumLevel) && minimumLevel > targetLevel - z_transfer)
		minimumLevel--
	while(HasAbove(maximumLevel) && maximumLevel < targetLevel + z_transfer)
		maximumLevel++
	return list(minimumLevel, maximumLevel)

/datum/component/jamming/proc/OnLevelChange(atom/source, oldLevel, newLevel)
	SIGNAL_HANDLER
	if(!active)
		return
	var/list/affectedLevels = getAffectedLevels(oldLevel)
	for(var/i = affectedLevels[1], i <= affectedLevels[2]; i++)
		SSjamming.active_jammers[i] -= src
	affectedLevels = getAffectedLevels(newLevel)
	for(var/i = affectedLevels[1], i <= affectedLevels[2]; i++)
		SSjamming.active_jammers[i] += src


/datum/component/jamming/proc/OnContainered(atom/sender, atom/movable/container)
	SIGNAL_HANDLER
	if(highest_container == container)
		return
	UnregisterSignal(highest_container, COMSIG_MOVABLE_Z_CHANGED)
	highest_container = container
	RegisterSignal(highest_container, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(OnLevelChange))


/datum/component/jamming/Destroy()
	if(active)
		var/list/affectedLevels = getAffectedLevels(highest_container.z)
		for(var/i = affectedLevels[1], i <= affectedLevels[2]; i++)
			SSjamming.active_jammers[i] -= src
	owner = null
	highest_container = null
	..()

/datum/component/jamming/proc/Toggle()
	var/list/affectedLevels = getAffectedLevels(highest_container.z)
	if(active)
		for(var/i = affectedLevels[1], i <= affectedLevels[2]; i++)
			SSjamming.active_jammers[i] -= src
	else
		for(var/i = affectedLevels[1], i <= affectedLevels[2]; i++)
			SSjamming.active_jammers[i] += src
	active = !active

