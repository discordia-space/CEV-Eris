/datum/subroutine
	var/Locked = 0 //time when it will unlocked
	var/TimeLockedFor = 1 MINUTE
	proc
		Lock(time = world.time + TimeLockedFor)
			Locked = time
		IsLocked()
			. = Locked >= world.time
			to_world("IsLocked: [.]")
		TryTrigger(datum/CyberSpaceAvatar/triggerer, wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK)
			. = !IsLocked()
			to_world("TryTrigger: [.]")
		Trigger(datum/CyberSpaceAvatar/triggerer, wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK)
			Lock()
/datum/subroutine_manager
	var/list/Bumped = list()
	var/list/FailedBreaking = list()
	var/list/Spotted = list()
	var/list/EnemyIceAttack = list()

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

/proc/TriggerSubroutines(
	list/routines,
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,
	datum/CyberSpaceAvatar/triggerer
	)
	for(var/datum/subroutine/S in routines)
		if(S.TryTrigger())
			S.Trigger(triggerer, wayOfTrigger)
