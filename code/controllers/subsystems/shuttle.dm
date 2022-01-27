SUBSYSTEM_DEF(shuttle)
	name = "Shuttle"
	wait = 2 SECONDS
	priority = SS_PRIORITY_SHUTTLE
	init_order = INIT_ORDER_SHUTTLE                // Should be initialized after all69aploading is over and atoms are initialized, to ensure that landmarks have been initialized.

	var/list/shuttles = list()                     //69aps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles = list()             // simple list of shuttles, for processing
	var/list/registered_shuttle_landmarks = list()
	var/last_landmark_registration_time

	var/tmp/list/working_shuttles

/datum/controller/subsystem/shuttle/Initialize()
	last_landmark_registration_time = world.time
	initialize_shuttles()
	. = ..()

/datum/controller/subsystem/shuttle/fire(resumed = FALSE)
	if (!resumed)
		working_shuttles = process_shuttles.Copy()

	while (working_shuttles.len)
		var/datum/shuttle/autodock/shuttle = working_shuttles69working_shuttles.len69
		working_shuttles.len--
		if(shuttle.process_state)
			shuttle.Process()

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/shuttle/proc/register_landmark(shuttle_landmark_tag, obj/effect/shuttle_landmark/shuttle_landmark)
	if(istype(shuttle_landmark, /obj/effect/shuttle_landmark/automatic))
		var/obj/effect/overmap/O =69ap_sectors69"69shuttle_landmark.z69"69
		O.add_landmark(shuttle_landmark)
		last_landmark_registration_time = world.time
		return

	if (registered_shuttle_landmarks69shuttle_landmark_tag69)
		CRASH("Attempted to register shuttle landmark with tag 69shuttle_landmark_tag69, but it is already registered!")

	if (istype(shuttle_landmark))
		registered_shuttle_landmarks69shuttle_landmark_tag69 = shuttle_landmark
		last_landmark_registration_time = world.time




/datum/controller/subsystem/shuttle/proc/get_landmark(shuttle_landmark_tag)
	return registered_shuttle_landmarks69shuttle_landmark_tag69

/datum/controller/subsystem/shuttle/proc/initialize_shuttles()
	for(var/shuttle_type in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = shuttle_type
		if (!initial(shuttle.defer_initialisation))
			initialise_shuttle(shuttle_type)

/datum/controller/subsystem/shuttle/proc/initialise_shuttle(shuttle_type)
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)
		shuttle = new shuttle()

/datum/controller/subsystem/shuttle/stat_entry()
	..("S:69shuttles.len69, L:69registered_shuttle_landmarks.len69")


/datum/controller/subsystem/shuttle/proc/get_shuttle(var/needle)
	for (var/S in shuttles)
		if (S == needle)
			return shuttles69S69

	return null