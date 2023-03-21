
/datum/component/jamming
	var/atom/movable/owner
	var/active = TRUE
	var/radius = 20
	var/power = 1
	dupe_mode = COMPONENT_DUPE_UNIQUE
	can_transfer = FALSE

/datum/component/jamming/Initialize()
	. = ..()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent
	SSjamming.active_jammers[owner.z] += src

/datum/component/jamming/ClearFromParent()
	owner = null
	..()

/datum/component/jamming/Destroy()
	owner = null
	..()

/datum/component/jamming/proc/Toggle()
	if(active)
		SSjamming.active_jammers[owner.z] -= src
	else
		SSjamming.active_jammers[owner.z] += src
	active = !active

