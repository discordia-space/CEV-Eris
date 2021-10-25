GLOBAL_LIST_EMPTY(CyberSpaceWaypoints)
CYBERAVATAR_INITIALIZATION(/atom/movable/CyberspaceWaypoint, CYBERSPACE_MAIN_COLOR)
/atom/movable/CyberspaceWaypoint
	density = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM
	var/list/WhiteList = list()
	var/atom/FollowingAtom
	New()
		. = ..()
		GLOB.CyberSpaceWaypoints.Add(src)
	Destroy()
		. = ..()
		GLOB.CyberSpaceWaypoints.Remove(src)

/atom/movable/CyberspaceWaypoint/proc/AvailableFor(mob/observer/cyberspace_eye/user)
	return (user in WhiteList) || !length(WhiteList)

/atom/movable/CyberspaceWaypoint/proc/FollowAtom(atom/A)
	if(istype(FollowingAtom))
		GLOB.moved_event.unregister(FollowingAtom, src, /atom/movable/CyberspaceWaypoint/proc/Follow)
	if(FollowingAtom != A && istype(A))
		Follow(A, breakTimers = FALSE)
	FollowingAtom = A

/atom/movable/CyberspaceWaypoint/proc/Follow(atom/A, old_loc, _, breakTimers = FALSE)
	dropInto(A)
	if(!breakTimers)
		GLOB.moved_event.register(A, src, /atom/movable/CyberspaceWaypoint/proc/Follow)
