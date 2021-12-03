/datum/CyberSpaceAvatar
	var/datum/subroutine_manager/Subroutines
	New()
		. = ..()
		if(Subroutines)
			CollectSubroutines()

	proc/CollectSubroutines()
		if(!istype(Subroutines))
			Subroutines = new
			. = Subroutines

/datum/subroutine
	var/Locked = 0 //time when it will unlocked
	var/TimeLocksFor = 1 MINUTE
	proc
		Lock(time = world.time + TimeLocksFor)
			Locked = time
		IsLocked()
			. = (Locked > world.time)
		TryTrigger(datum/CyberSpaceAvatar/triggerer, wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK, datum/CyberSpaceAvatar/host)
			. = !IsLocked()
		Trigger(datum/CyberSpaceAvatar/triggerer, wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK, datum/CyberSpaceAvatar/host)
			Lock()

/datum/subroutine_manager
	var/list/Bumped = list()
	var/list/FailedBreaking = list()
//	var/list/Spotted = list()
	var/list/Attack = list()

	proc
		AddSubroutines(list/prefabs, list/AddTo)
			for(var/S in prefabs)
				AddSubroutine(S, AddTo)

		AddSubroutine(datum/subroutine/pathOrPrefab, list/AddTo)
			if(!islist(AddTo))
				return
			if(ispath(pathOrPrefab, /datum/subroutine))
				pathOrPrefab = new pathOrPrefab()
			if(istype(pathOrPrefab))
				AddTo.Add(pathOrPrefab)
				return pathOrPrefab
		IsAllSubroutinesLocked(list/l)
			. = TRUE
			for(var/datum/subroutine/i in l)
				. = . && i.IsLocked()

/proc/TriggerSubroutines(
	list/routines,
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,
	datum/CyberSpaceAvatar/triggerer,
	datum/CyberSpaceAvatar/host
	)
	for(var/datum/subroutine/S in routines)
		if(S.TryTrigger(triggerer, wayOfTrigger, host))
			S.Trigger(triggerer, wayOfTrigger, host)

/datum/CyberSpaceAvatar/BumpedByAvatar(datum/CyberSpaceAvatar/avatar)
	. = ..()
	if(istype(Subroutines))
		TriggerSubroutines(Subroutines.Bumped, SUBROUTINE_BUMPED, avatar, src)

///datum/CyberSpaceAvatar/AnotherAvatarFound(datum/CyberSpaceAvatar/avatar)
//	. = ..()
//	if(istype(Subroutines))
//		TriggerSubroutines(Subroutines.Spotted, SUBROUTINE_SPOTTED, avatar, src)
//
