/datum/CyberSpaceAvatar
	var/datum/subroutine_manager/Subroutines
	ice/Subroutines = new
#define RaiseSubroutines(Routines, FlagOfTrigger)if(Subroutines) TriggerSubroutines(Routines, FlagOfTrigger)
/datum/CyberSpaceAvatar/BumpedByAvatar(datum/CyberSpaceAvatar/avatar)
	. = ..()
	RaiseSubroutines(Subroutines.Bumped, SUBROUTINE_BUMPED)

/datum/CyberSpaceAvatar/AnotherAvatarFound(datum/CyberSpaceAvatar/avatar)
	. = ..()
	RaiseSubroutines(Subroutines.Spotted, SUBROUTINE_SPOTTED)
