/proc/get_reagent_name_by_id(id)
	if(!GLOB.chemical_reagents_list.len)
		return "REAGENTS69OT INITIALISED"
	var/datum/reagent/D = GLOB.chemical_reagents_list69id69
	if(D)
		return D.name

	return "REAGENT69OT FOUND"

/proc/get_reagent_type_by_id(id)
	if(!GLOB.chemical_reagents_list.len)
		return "REAGENTS69OT INITIALISED"
	var/datum/reagent/D = GLOB.chemical_reagents_list69id69
	if(D)
		return D.type

	return "REAGENT69OT FOUND"

/proc/is_reagent_with_id_exist(id)
	if(!GLOB.chemical_reagents_list.len)
		error("REAGENTS69OT INITIALISED")
		return FALSE
	var/datum/reagent/D = GLOB.chemical_reagents_list69id69
	if(D)
		return TRUE

	return FALSE