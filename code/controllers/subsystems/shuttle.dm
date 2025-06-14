SUBSYSTEM_DEF(shuttle)
	name = "Shuttle"
	wait = 2 SECONDS
	priority = SS_PRIORITY_SHUTTLE
	init_order = INIT_ORDER_SHUTTLE                // Should be initialized after all maploading is over and atoms are initialized, to ensure that landmarks have been initialized.

	var/list/shuttles = list()                     // maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles = list()             // simple list of shuttles, for processing
	var/list/registered_shuttle_landmarks = list()
	var/last_landmark_registration_time
	var/list/destination_landmarks = list()
	var/tmp/list/working_shuttles

/datum/controller/subsystem/shuttle/Initialize()
	last_landmark_registration_time = world.time
	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if(!initial(shuttle.defer_initialisation))
			initialise_shuttle(shuttle_type)
	. = ..()

/datum/controller/subsystem/shuttle/fire(resumed = FALSE)
	if(!resumed)
		working_shuttles = process_shuttles.Copy()

	while(working_shuttles.len)
		var/datum/shuttle/autodock/shuttle = working_shuttles[working_shuttles.len]
		working_shuttles.len--
		if(shuttle.process_state)
			shuttle.Process()

		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/shuttle/proc/register_landmark(obj/effect/shuttle_landmark/shuttle_landmark)
	if(shuttle_landmark in registered_shuttle_landmarks)
		CRASH("Attempted to register shuttle landmark with tag [shuttle_landmark.landmark_tag], but it is already registered!")

	last_landmark_registration_time = world.time
	registered_shuttle_landmarks += shuttle_landmark


/datum/controller/subsystem/shuttle/proc/initialise_shuttle(shuttle_type)
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)
		shuttle = new shuttle()

/datum/controller/subsystem/shuttle/stat_entry(msg)
	msg += "S:[LAZYLEN(shuttles)], L:[LAZYLEN(registered_shuttle_landmarks)]"

/datum/controller/subsystem/shuttle/proc/get_shuttle(var/needle)
	for(var/S in shuttles)
		if(S == needle)
			return shuttles[S]

	return null
