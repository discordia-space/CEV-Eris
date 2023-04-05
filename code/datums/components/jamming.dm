
/datum/component/jamming
	var/atom/movable/owner
	var/atom/movable/highest_container
	var/active = FALSE
	var/radius = 20
	var/power = 1
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

/datum/component/jamming/proc/OnLevelChange(source, oldLevel, newLevel)
	if(active)
		SSjamming.active_jammers[oldLevel] -= src
		SSjamming.active_jammers[newLevel] += src

/datum/component/jamming/proc/OnContainered(atom/sender, atom/movable/container)
	SIGNAL_HANDLER
	if(highest_container == container)
		return
	UnregisterSignal(highest_container, COMSIG_MOVABLE_Z_CHANGED)
	highest_container = container
	RegisterSignal(highest_container, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(OnLevelChange))


/datum/component/jamming/Destroy()
	if(active)
		SSjamming.active_jammers[owner.z] -= src
	owner = null
	..()

/datum/component/jamming/proc/Toggle()
	var/turf/level = get_turf(owner)
	if(active)
		SSjamming.active_jammers[level.z] -= src
	else
		SSjamming.active_jammers[level.z] += src
	active = !active

