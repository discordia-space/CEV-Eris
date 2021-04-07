/datum/CyberSpaceAvatar/eye
	icon_file = 'icons/obj/cyberspace/cyberspace.dmi'

/datum/CyberSpaceAvatar/eye/ai
	icon_state = "ai_observer"

/mob/observer/cyberspace_eye
	alpha = 200
	icon = 'icons/obj/cyberspace/cyberspace.dmi'
	movement_handlers = list(/datum/movement_handler/mob/incorporeal/cyberspace)
	_SeeCyberSpace = TRUE

CYBERAVATAR_INITIALIZATION(/mob/observer/cyberspace_eye, CYBERSPACE_MAIN_COLOR)

/mob/observer/cyberspace_eye/ai
	icon_state = "ai_presence"

/datum/movement_handler/mob/incorporeal/cyberspace/DoMove(direction, mob/mover, is_external)
	var/turf/movedTo = get_step(mover, direction)

	var/list/denseAvatar = GetDenseCyberspaceAvatars(movedTo)

	if(islist(denseAvatar) && length(denseAvatar))
		for(var/datum/CyberSpaceAvatar/CA in denseAvatar)
			CA.BumpedBy(mover.CyberAvatar)
	else
		. = ..()

/proc/GetDenseCyberspaceAvatars(turf/T)
	. = list()
	for(var/atom/A in T)
		if(A.CyberAvatar)
			var/datum/CyberSpaceAvatar/CAtoCheck = A.CyberAvatar
			if(CAtoCheck.density)
				. += CAtoCheck
