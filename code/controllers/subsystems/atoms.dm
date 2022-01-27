#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	var/init_state = INITIALIZATION_INSSATOMS
	var/old_init_state

	var/list/late_loaders
	var/list/created_atoms

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	init_state = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(init_state == INITIALIZATION_INSSATOMS)
		return

	init_state = INITIALIZATION_INNEW_MAPLOAD

	LAZYINITLIST(late_loaders)

	var/count
	var/list/mapload_arg = list(TRUE)
	if(atoms)
		created_atoms = list()
		count = atoms.len
		for(var/I in atoms)
			var/atom/A = I
			if(!A.initialized)
				if(InitAtom(I,69apload_arg))
					atoms -= I
				CHECK_TICK
	else
		count = 0
		for(var/atom/A in world)
			if(!A.initialized)
				InitAtom(A,69apload_arg)
				++count
				CHECK_TICK

	if(!Master.current_runlevel)//So it only does it at roundstart
		report_progress("Initialized 69count69 atom\s")


	init_state = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/I in late_loaders)
			var/atom/A = I
			A.LateInitialize(arglist(mapload_arg))
		if(!Master.current_runlevel)//So it only does it at roundstart
			report_progress("Late initialized 69late_loaders.len69 atom\s")
		late_loaders.Cut()

	if(atoms)
		. = created_atoms + atoms
		created_atoms = null

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls69the_type69 |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		BadInitializeCalls69the_type69 |= BAD_INIT_SLEPT

	var/qdeleted = FALSE

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments69169)	//mapload
					late_loaders += A
				else
					A.LateInitialize(arglist(arguments))
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			else
				BadInitializeCalls69the_type69 |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!A.initialized)
		BadInitializeCalls69the_type69 |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/stat_entry(msg)
	..("Bad Initialize Calls:69BadInitializeCalls.len69")

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_init_state = init_state
	init_state = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	init_state = old_init_state

/datum/controller/subsystem/atoms/Recover()
	init_state = SSatoms.init_state
	if(init_state == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_init_state = SSatoms.old_init_state
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : 69path69 \n"
		var/fails = BadInitializeCalls69path69
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "data/logs/initialize.log")

ADMIN_VERB_ADD(/client/proc/cmd_display_init_log, R_DEBUG, null)
/client/proc/cmd_display_init_log()
	set category = "Debug"
	set name = "Display Initialize() Log"
	set desc = "Displays a list of things that didn't handle Initialize() properly."

	if(!LAZYLEN(SSatoms.BadInitializeCalls))
		to_chat(usr, SPAN_NOTICE("BadInit list is empty."))
	else
		usr << browse(replacetext(SSatoms.InitLog(), "\n", "<br>"), "window=initlog")

#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT
