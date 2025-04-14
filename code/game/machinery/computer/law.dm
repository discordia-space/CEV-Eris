//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/electronics/circuitboard/aiupload
	var/mob/living/silicon/ai/current
	var/opened = 0

/obj/machinery/computer/aiupload/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_silicon("\A [name] was created at [loc_name(src)].")
		message_admins("\A [name] was created at [ADMIN_VERBOSEJMP(src)].")


/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)
	if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || issilicon(usr))
		return

	opened = !opened
	if(opened)
		to_chat(usr, span_notice("The access panel is now open."))
	else
		to_chat(usr, span_notice("The access panel is now closed."))
	return


/obj/machinery/computer/aiupload/attackby(obj/item/O as obj, mob/user as mob)
	if (user.z > 6)
		to_chat(user, "[span_danger("Unable to establish a connection:")] You're too far away from the station!")
		return
	if(istype(O, /obj/item/electronics/ai_module))
		var/obj/item/electronics/ai_module/M = O
		M.install(src)
	else
		..()


/obj/machinery/computer/aiupload/attack_hand(var/mob/user as mob)
	if(..())
		return



	src.current = select_active_ai(user)

	if (!src.current)
		to_chat(usr, "No active AIs detected.")
	else
		to_chat(usr, "[src.current.name] selected for law changes.")
	return

/obj/machinery/computer/aiupload/attack_ghost(user as mob)
	return 1


/obj/machinery/computer/borgupload
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/electronics/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null

/obj/machinery/computer/borgupload/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_silicon("\A [name] was created at [loc_name(src)].")
		message_admins("\A [name] was created at [ADMIN_VERBOSEJMP(src)].")

/obj/machinery/computer/borgupload/attackby(obj/item/electronics/ai_module/module as obj, mob/user as mob)
	if(istype(module, /obj/item/electronics/ai_module))
		module.install(src)
	else
		return ..()


/obj/machinery/computer/borgupload/attack_hand(var/mob/user as mob)
	if(src.stat & NOPOWER)
		to_chat(usr, "The upload computer has no power!")
		return
	if(src.stat & BROKEN)
		to_chat(usr, "The upload computer is broken!")
		return

	src.current = freeborg()

	if (!src.current)
		to_chat(usr, "No free cyborgs detected.")
	else
		to_chat(usr, "[src.current.name] selected for law changes.")
	return

/obj/machinery/computer/borgupload/attack_ghost(user as mob)
	return 1
