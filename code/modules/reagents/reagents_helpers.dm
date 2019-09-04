/proc/get_reagent_name_by_id(var/id)
	if(!chemical_reagents_list.len)
		return "REAGENTS NOT INITIALISED"
	var/datum/reagent/D = chemical_reagents_list[id]
	if(D)
		return D.name

	return "REAGENT NOT FOUND"