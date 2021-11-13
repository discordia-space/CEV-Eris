/atom/movable/CyberspaceWaypoint/EnterPoint
	icon = 'icons/obj/cyberspace/ices/ihs.dmi'
	icon_state = "gate"

/atom/movable/CyberspaceWaypoint/EnterPoint/New(loc, mob/observer/cyber_entity/cyberspace_eye/Eye)
	. = ..()
	WhiteList.Add(Eye)

/mob/observer/cyber_entity/cyberspace_eye
	var/atom/movable/CyberspaceWaypoint/EnterPoint/EnterPoint = TRUE

/mob/observer/cyber_entity/cyberspace_eye/Connected(obj/item/computer_hardware/deck/D)
	. = ..()
	if(EnterPoint)
		if(!istype(EnterPoint))
			EnterPoint = new(get_turf(D), src)
		EnterPoint.FollowAtom(D)

/mob/observer/cyber_entity/cyberspace_eye/Disconnected(obj/item/computer_hardware/deck/D)
	if(EnterPoint)
		EnterPoint.FollowAtom(null)
		EnterPoint.relocateTo(owner)
	. = ..()

