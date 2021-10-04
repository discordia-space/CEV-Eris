GLOBAL_LIST_EMPTY(CyberSpaceWaypoints)

/atom/movable/CyberspaceWaypoint
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

/atom/movable/CyberspaceWaypoint/EnterPoint/New(loc, mob/observer/cyberspace_eye/Eye)
	. = ..()
	WhiteList.Add(Eye)

/mob/observer/cyberspace_eye
	var/atom/movable/CyberspaceWaypoint/EnterPoint/EnterPoint = TRUE

/mob/observer/cyberspace_eye/Connected(obj/item/computer_hardware/deck/D)
	. = ..()
	if(EnterPoint)
		if(!istype(EnterPoint))
			EnterPoint = new(get_turf(D), src)
		EnterPoint.FollowAtom(D)

/mob/observer/cyberspace_eye/Disconnected(obj/item/computer_hardware/deck/D)
	if(EnterPoint)
		EnterPoint.FollowAtom(null)
		EnterPoint.relocateTo(owner)
	. = ..()

