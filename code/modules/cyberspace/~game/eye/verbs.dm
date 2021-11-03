/mob/observer/cyberspace_eye/runner/verb/CancelConnection()
	set category = CYBERSPACE_VERBS_CATEGORY
	set name = "MOVE: Return to body" // snap back to reality

	ReturnToBody()

/mob/observer/cyberspace_eye/runner/verb/TeleportToWaypoint()
	set category = CYBERSPACE_VERBS_CATEGORY
	set name = "MOVE: Waypoint"

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

/mob/observer/cyberspace_eye/verb/PickAvatarIcon()
	set category = CYBERSPACE_VERBS_CATEGORY
	set name = "PICK: Avatar Icon"

	var/list/available = icon_states(icon)
	available.Insert(1, "(CANCEL)")

	var/Selected = input("Select available waypoint") in available
	if(Selected != "(CANCEL)" && (Selected in available))
		SetIconState(Selected)

/mob/observer/cyberspace_eye/verb/InteractWithEncriptionKeys()
	set category = CYBERSPACE_VERBS_CATEGORY
	set name = "INTERACT: Encription Keys"

	var/list/available = AccessCodes
	available.Insert(1, "(CANCEL)")
	available.Insert(1, "(ADD)")
	var/Selected = input("Select code to remove") in available
	if(Selected != "(CANCEL)")
		if(Selected == "(ADD)")
			Selected = input("Access code to add.", "Code Interaction", "1:1:1=0000-0000")
			if(length(Selected))
				AccessCodes.Add(Selected)
		else
			AccessCodes.Remove(Selected)
