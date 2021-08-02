/decls/subroutine/proc/Trigger(wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK, datum/CyberSpaceAvatar/triggerer)
/datum/subroutine_manager
	var/list/Bumped = list()
	var/list/FailedBreaking = list()
	var/list/Spotted = list()

/datum/subroutine_manager/proc/AddSubroutine(path, list/L)
	if(!islist(L))
		L = list()
	var/decls/subroutine/routine = decls_repository.get_decl(path)
	if(routine)
		L.Add(routine)


/proc/TriggerSubroutines(
	list/routines,
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,
	datum/CyberSpaceAvatar/triggerer
	)
	for(var/path in routines)
		if(ispath(path, /decls/subroutine))
			var/decls/subroutine/routine = decls_repository.get_decl(path)
			routine.Trigger(wayOfTrigger, triggerer)
