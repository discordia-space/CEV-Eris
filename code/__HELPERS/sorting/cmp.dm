/proc/cmp_name_or_type_asc(atom/a, atom/b)
	return sorttext(istype(b) || ("name" in b.vars) ? b.name : b.type, istype(a) || ("name" in a.vars) ? a.name : a.type)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_numeric_asc(a,b)
	return a - b

GLOBAL_VAR_INIT(cmp_field, "name")
/proc/cmp_records_asc(datum/data/record/a, datum/data/record/b)
	return sorttext(b.fields[GLOB.cmp_field], a.fields[GLOB.cmp_field])

/proc/cmp_records_dsc(datum/data/record/a, datum/data/record/b)
	return sorttext(a.fields[GLOB.cmp_field], b.fields[GLOB.cmp_field])

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	var/a_init_order = ispath(a) ? initial(a.init_order) : a.init_order
	var/b_init_order = ispath(b) ? initial(b.init_order) : b.init_order

	return b_init_order - a_init_order	//uses initial() so it can be used on types

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

/proc/cmp_text_asc(a,b)
	return sorttext(b, a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a, b)

/proc/cmp_qdel_item_time(datum/qdel_item/A, datum/qdel_item/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.qdels - A.qdels

/proc/cmp_crew_sensor_modifier(crew_sensor_modifier/a, crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_smeslist_rcon_tag(list/A, list/B)
	return sorttext(A["RCON_tag"], B["RCON_tag"])