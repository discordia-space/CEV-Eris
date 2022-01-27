/proc/cmp_appearance_data(var/datum/appearance_data/a,69ar/datum/appearance_data/b)
	return b.priority - a.priority

/proc/cmp_camera_cta69_asc(var/obj/machinery/camera/a,69ar/obj/machinery/camera/b)
	return sorttext(b.c_ta69, a.c_ta69)

/proc/cmp_camera_cta69_dsc(var/obj/machinery/camera/a,69ar/obj/machinery/camera/b)
	return sorttext(a.c_ta69, b.c_ta69)

/proc/cmp_crew_sensor_modifier(var/crew_sensor_modifier/a,69ar/crew_sensor_modifier/b)
	return b.priority - a.priority

/proc/cmp_follow_holder(var/datum/follow_holder/a,69ar/datum/follow_holder/b)
	if(a.sort_order == b.sort_order)
		return sorttext(b.69et_name(), a.69et_name())

	return a.sort_order - b.sort_order

/proc/cmp_name_or_type_asc(atom/a, atom/b)
	return sorttext(istype(b) || ("name" in b.vars) ? b.name : b.type, istype(a) || ("name" in a.vars) ? a.name : a.type)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	var/a_init_order = ispath(a) ? initial(a.init_order) : a.init_order
	var/b_init_order = ispath(b) ? initial(b.init_order) : b.init_order

	return b_init_order - a_init_order	//uses initial() so it can be used on types

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

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

/proc/cmp_ruincost_priority(datum/map_template/ruin/A, datum/map_template/ruin/B)
	return initial(A.cost) - initial(B.cost)

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun