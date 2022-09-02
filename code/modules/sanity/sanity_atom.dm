/datum/component/atom_sanity
	var/affect = 1
	var/desc

/datum/component/atom_sanity/Initialize(value, new_desc)
	if(!istype(parent, /atom))
		return COMPONENT_INCOMPATIBLE
	var/atom/A = parent
	affect = value
	desc = new_desc

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/onMoved)

	onMoved(null, A.loc)

/datum/component/atom_sanity/proc/onMoved(oldloc, newloc)
	if(isturf(oldloc))
		var/area/current_area = get_area(oldloc) //Actually new area is curret
		if(isturf(newloc) && current_area == get_area(newloc))
			return
		var/datum/area_sanity/AS = current_area.sanity
		AS.unregister(src)
	if(isturf(newloc))
		var/area/new_area = get_area(newloc) //Actually new area is curret
		var/datum/area_sanity/AS = new_area.sanity
		AS.register(src)
