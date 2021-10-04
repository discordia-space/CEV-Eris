/datum/CyberSpaceAvatar/runner
	icon_file = 'icons/obj/cyberspace/cyberspace.dmi'

CYBERAVATAR_INITIALIZATION(/mob/observer/cyberspace_eye, CYBERSPACE_MAIN_COLOR)
CYBERAVATAR_CUSTOM_TYPE(/mob/observer/cyberspace_eye/ai, /datum/CyberSpaceAvatar/runner)
/mob/observer/cyberspace_eye //slow move of it down
	alpha = 200
	icon = 'icons/obj/cyberspace/cyberspace.dmi'
	movement_handlers = list(/datum/movement_handler/mob/incorporeal/cyberspace)
	_SeeCyberSpace = TRUE

	var/obj/item/computer_hardware/deck/owner
/mob/observer/cyberspace_eye/proc/ReturnToBody()
	if(istype(owner))
		to_chat(src, SPAN_WARNING("You feel like your mind is decaying, you feel the void ... <br><br>\
		But after, you feel your memory coming back piece by piece as a mind, you see your old deeds, you feel shame ..."))
		owner.CancelCyberspaceConnection()
		Disconnected()
		. = TRUE
	else
		to_chat(src, SPAN_WARNING("You can't feel your shell."))

/mob/observer/cyberspace_eye/MouseDrop_T(atom/dropping, mob/user, src_location, over_location, src_control, over_control, params)
	. = ..()
	var/turf/T = get_turf(dropping)
	if(user == src && get_dist(user, dropping) <= 1 && T.density && do_after(src, 2 SECONDS, src))
		Move(T, get_dir(src, T))

/datum/CyberSpaceAvatar/runner/ai
	icon_state = "ai_observer"

CYBERAVATAR_CUSTOM_TYPE(/mob/observer/cyberspace_eye/ai, /datum/CyberSpaceAvatar/runner/ai)
/mob/observer/cyberspace_eye/ai
	icon_state = "ai_presence"
	ReturnToBody()
		return

/mob/observer/cyberspace_eye/proc/Connected(obj/item/computer_hardware/deck/D)
	return dropInto(D)
/mob/observer/cyberspace_eye/proc/Disconnected(obj/item/computer_hardware/deck/D)