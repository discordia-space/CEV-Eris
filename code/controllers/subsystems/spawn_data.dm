SUBSYSTEM_DEF(spawn_data)
	name = "Spawn Data"
	init_order = INIT_ORDER_SPAWN_DATA
	flags = SS_NO_FIRE
	var/list/lowkeyrandom_tags = list()
	var/list/all_spawn_by_tag = list()
	var/list/all_accompanying_obj_by_path = list()

/datum/controller/subsystem/spawn_data/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.

/datum/controller/subsystem/spawn_data/Initialize(timeofday)
	generate_data()
	. = ..()

/datum/controller/subsystem/spawn_data/stat_entry(msg)
	if (!Debug2)
		return // Only show up in stat panel if debugging is enabled.
	return ..()
