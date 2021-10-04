/mob/observer/cyberspace_eye/runner/verb/CancelConnection()
	set category = CYBERSPACE_VERBS_CATEGORY
	set name = "Return to body" // snap back to reality

	ReturnToBody()

/mob/observer/cyberspace_eye/runner/verb/TeleportToWaypoint()
	set category = CYBERSPACE_VERBS_CATEGORY
	set name = "Teleport To Waypoint"

	var/list/available = GetUserReadableAvailableWaypoints()
	available.Insert(1, "(CANCEL)")

	var/Selected = input("Select available waypoint") in available
	if(available.Find(Selected))
		var/atom/destination = available[Selected]
		if(istype(destination))
			dropInto(destination)

/mob/observer/cyberspace_eye/runner/proc/GetUserReadableAvailableWaypoints()
	. = list()
	for(var/atom/movable/CyberspaceWaypoint/i in GLOB.CyberSpaceWaypoints)
		if(i.AvailableFor(src))
			.[i.name] = i
