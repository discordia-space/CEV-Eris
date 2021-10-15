/atom/movable/IceHolder/invisibility = INVISIBILITY_MAXIMUM
CYBERAVATAR_INITIALIZATION(/atom/movable/IceHolder, CYBERSPACE_MAIN_COLOR)
CYBERAVATAR_CUSTOM_PREFAB(/atom/movable/IceHolder, /datum/CyberSpaceAvatar/ice)
/datum/CyberSpaceAvatar/ice/Subroutines = TRUE

/datum/CyberSpaceAvatar
	var/datum/subroutine_manager/Subroutines
	New()
		. = ..()
		if(Subroutines)
			CollectSubroutines()

	proc/CollectSubroutines()
		if(!istype(Subroutines))
			Subroutines = new

/datum/CyberSpaceAvatar/ice/Subroutines = TRUE

/datum/CyberSpaceAvatar/BumpedByAvatar(datum/CyberSpaceAvatar/avatar)
	. = ..()
	RaiseSubroutines(Subroutines.Bumped, SUBROUTINE_BUMPED, avatar)

/datum/CyberSpaceAvatar/AnotherAvatarFound(datum/CyberSpaceAvatar/avatar)
	. = ..()
	RaiseSubroutines(Subroutines.Spotted, SUBROUTINE_SPOTTED, avatar)
