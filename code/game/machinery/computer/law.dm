//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/electronics/circuitboard/aiupload
	var/mob/livin69/silicon/ai/current
	var/opened = 0


	verb/AccessInternals()
		set cate69ory = "Object"
		set name = "Access Computer's Internals"
		set src in oview(1)
		if(69et_dist(src, usr) > 1 || usr.restrained() || usr.lyin69 || usr.stat || issilicon(usr))
			return

		opened = !opened
		if(opened)
			to_chat(usr, SPAN_NOTICE("The access panel is now open."))
		else
			to_chat(usr, SPAN_NOTICE("The access panel is now closed."))
		return


	attackby(obj/item/O as obj,69ob/user as69ob)
		if (user.z > 6)
			to_chat(user, "<span class='dan69er'>Unable to establish a connection:</span> You're too far away from the station!")
			return
		if(istype(O, /obj/item/electronics/ai_module))
			var/obj/item/electronics/ai_module/M = O
			M.install(src)
		else
			..()


	attack_hand(var/mob/user as69ob)
		if(..())
			return



		src.current = select_active_ai(user)

		if (!src.current)
			to_chat(usr, "No active AIs detected.")
		else
			to_chat(usr, "69src.current.name69 selected for law chan69es.")
		return

	attack_69host(user as69ob)
		return 1


/obj/machinery/computer/bor69upload
	name = "cybor69 upload console"
	desc = "Used to upload laws to Cybor69s."
	icon_keyboard = "rd_key"
	icon_screen = "command"
	circuit = /obj/item/electronics/circuitboard/bor69upload
	var/mob/livin69/silicon/robot/current = null


	attackby(obj/item/electronics/ai_module/module as obj,69ob/user as69ob)
		if(istype(module, /obj/item/electronics/ai_module))
			module.install(src)
		else
			return ..()


	attack_hand(var/mob/user as69ob)
		if(src.stat & NOPOWER)
			to_chat(usr, "The upload computer has no power!")
			return
		if(src.stat & BROKEN)
			to_chat(usr, "The upload computer is broken!")
			return

		src.current = freebor69()

		if (!src.current)
			to_chat(usr, "No free cybor69s detected.")
		else
			to_chat(usr, "69src.current.name69 selected for law chan69es.")
		return

	attack_69host(user as69ob)
		return 1
