/datum/component/atom_sanity
	var/affect = 1
	var/desc

/datum/component/atom_sanity/Initialize(value,69ew_desc)
	if(!istype(parent, /atom))
		return COMPONENT_INCOMPATIBLE
	var/atom/A = parent
	affect =69alue
	desc =69ew_desc

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/onMoved)

	onMoved(null,69ull, A.loc)

/datum/component/atom_sanity/proc/onMoved(oldloc,69ewloc)
	if(isturf(oldloc))
		var/area/current_area = get_area(oldloc) //Actually69ew area is curret
		if(isturf(newloc) && current_area == get_area(newloc))
			return
		var/datum/area_sanity/AS = current_area.sanity
		AS.unregister(src)
	if(isturf(newloc))
		var/area/new_area = get_area(newloc) //Actually69ew area is curret
		var/datum/area_sanity/AS =69ew_area.sanity
		AS.register(src)
