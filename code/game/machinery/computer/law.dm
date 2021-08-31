//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/electronics/circuitboard/aiupload
	var/mob/living/silicon/ai/current
	var/opened = 0


	verb/AccessInternals()
		set category = "Object"
		set name = "Access Computer's Internals"
		set src in oview(1)
		if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || issilicon(usr))
			return

		opened = !opened
		if(opened)
			to_chat(usr, SPAN_NOTICE("The access panel is now open."))
		else
			to_chat(usr, SPAN_NOTICE("The access panel is now closed."))
		return


	attackby(obj/item/O as obj, mob/user as mob)
		if (user.z > 6)
			to_chat(user, "<span class='danger'>Unable to establish a connection:</span> You're too far away from the station!")
			return
		if(istype(O, /obj/item/electronics/ai_module))
			var/obj/item/electronics/ai_module/M = O
			M.install(src)
		else
			..()


	attack_hand(var/mob/user as mob)
		if(..())
			return



		src.current = select_active_ai(user)

		if (!src.current)
			to_chat(usr, "No active AIs detected.")
		else
			to_chat(usr, "[src.current.name] selected for law changes.")
		return

	attack_ghost(user as mob)
		return 1


/obj/machinery/computer/borgupload
	name = "cyborg upload console"
	desc = "Used to upload laws to Cyborgs."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/electronics/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


	attackby(obj/item/electronics/ai_module/module as obj, mob/user as mob)
		if(istype(module, /obj/item/electronics/ai_module))
			module.install(src)
		else
			return ..()


	attack_hand(var/mob/user as mob)
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

	attack_ghost(user as mob)
		return 1
