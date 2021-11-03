/datum/CyberSpaceAvatar/runner
//	icon_file = 'icons/obj/cyberspace/cyberspace.dmi'

CYBERAVATAR_INITIALIZATION(/mob/observer/cyberspace_eye, CYBERSPACE_MAIN_COLOR)
CYBERAVATAR_CUSTOM_TYPE(/mob/observer/cyberspace_eye, /datum/CyberSpaceAvatar/runner)
/mob/observer/cyberspace_eye //slow move of it down
	invisibility = INVISIBILITY_MAXIMUM
	alpha = 200
	icon = 'icons/obj/cyberspace/runner.dmi'
	icon_state = "Default"
	movement_handlers = list(/datum/movement_handler/mob/incorporeal/cyberspace)
	_SeeCyberSpace = TRUE

	var/obj/item/computer_hardware/deck/owner
	var/maxHP = 100
	var/HP
	var/Might = 5
	Login()
		. = ..()
		client?.show_popup_menus = FALSE
	Logout()
		if(client)
			client.show_popup_menus = initial(client.show_popup_menus)
		. = ..()

/mob/observer/cyberspace_eye/proc/ReturnToBody()
	if(istype(owner))
		to_chat(src, SPAN_WARNING("You feel like your mind is decaying, you feel the void ... <br><br>\
		But after, you feel your memory coming back piece by piece as a mind, you see your old deeds, you feel shame ..."))
		owner.CancelCyberspaceConnection()
		Disconnected()
		. = TRUE
	else
		to_chat(src, SPAN_WARNING("You can't feel your shell."))

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
	if(client)
		client.show_popup_menus = initial(client.show_popup_menus)
