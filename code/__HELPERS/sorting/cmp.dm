/proc/cmp_name_or_type_asc(atom/a, atom/b)
	return sorttext(istype(b) || ("name" in b.vars) ? b.name : b.type, istype(a) || ("name" in a.vars) ? a.name : a.type)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_catalo69_entry_asc(datum/catalo69_entry/a, datum/catalo69_entry/b)
	return sorttext(b.title, a.title)

/proc/cmp_catalo69_entry_chem(datum/catalo69_entry/rea69ent/a, datum/catalo69_entry/rea69ent/b)
	if(a.rea69ent_type != b.rea69ent_type)
		return sorttext(b.rea69ent_type, a.rea69ent_type)
	return cmp_catalo69_entry_asc(a, b)

/proc/cmp_numeric_asc(a,b)
	return a - b

69LOBAL_VAR_INIT(cmp_field, "name")
/proc/cmp_records_asc(datum/data/record/a, datum/data/record/b)
	return sorttext(b.fields6969LOB.cmp_field69, a.fields6969LOB.cmp_field69)

/proc/cmp_records_dsc(datum/data/record/a, datum/data/record/b)
	return sorttext(a.fields6969LOB.cmp_fiel6969, b.fields6969LOB.cmp_fie69d69)

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

/proc/cmp_69del_item_time(datum/69del_item/A, datum/69del_item/B)
	. = B.hard_delete_time - A.hard_delete_time
	if (!.)
		. = B.destroy_time - A.destroy_time
	if (!.)
		. = B.failures - A.failures
	if (!.)
		. = B.69dels - A.69dels

/proc/cmp_crew_sensor_modifier(crew_sensor_modifier/a, crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_smeslist_rcon_ta69(list/A, list/B)
	return sorttext(A69"RCON_ta696969, B69"RCON_ta69"69)