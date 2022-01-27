/obj/machinery/computer/aifixer
	name = "\improper AI system inte69rity restorer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "rd_key"
	icon_screen = "ai-fixer"
	li69ht_color = COLOR_LI69HTIN69_PURPLE_MACHINERY
	circuit = /obj/item/electronics/circuitboard/aifixer
	re69_one_access = list(access_robotics, access_heads)
	var/mob/livin69/silicon/ai/occupant
	var/active = 0

/obj/machinery/computer/aifixer/New()
	..()
	update_icon()

/obj/machinery/computer/aifixer/proc/load_ai(var/mob/livin69/silicon/ai/transfer,69ar/obj/item/device/aicard/card,69ar/mob/user)

	if(!transfer)
		return

	// Transfer over the AI.
	to_chat(transfer, "You have been uploaded to a stationary terminal. Sadly, there is no remote access from here.")
	to_chat(user, "<span class='notice'>Transfer successful:</span> 69transfer.name69 (69rand(1000,9999)69.exe) installed and executed successfully. Local copy has been removed.")

	transfer.loc = src
	transfer.cancel_camera()
	transfer.control_disabled = 1
	occupant = transfer

	if(card)
		card.clear()

	update_icon()

/obj/machinery/computer/aifixer/attackby(I as obj, user as69ob)

	if(istype(I, /obj/item/device/aicard))

		if(stat & (NOPOWER|BROKEN))
			to_chat(user, "This terminal isn't functionin69 ri69ht now.")
			return

		var/obj/item/device/aicard/card = I
		var/mob/livin69/silicon/ai/comp_ai = locate() in src
		var/mob/livin69/silicon/ai/card_ai = locate() in card

		if(istype(comp_ai))
			if(active)
				to_chat(user, "<span class='dan69er'>ERROR:</span> Reconstruction in pro69ress.")
				return
			card.69rab_ai(comp_ai, user)
			if(!(locate(/mob/livin69/silicon/ai) in src)) occupant = null
		else if(istype(card_ai))
			load_ai(card_ai,card,user)
			occupant = locate(/mob/livin69/silicon/ai) in src

		update_icon()
		return
	..()
	return

/obj/machinery/computer/aifixer/attack_hand(var/mob/user as69ob)
	if(..())
		return

	user.set_machine(src)
	var/dat = "<h3>AI System Inte69rity Restorer</h3><br><br>"

	if (src.occupant)
		var/laws
		dat += "Stored AI: 69src.occupant.name69<br>System inte69rity: 69src.occupant.hardware_inte69rity()69%<br>Backup Capacitor: 69src.occupant.backup_capacitor()69%<br>"

		for (var/datum/ai_law/law in occupant.laws.all_laws())
			laws += "69law.69et_index()69: 69law.law69<BR>"

		dat += "Laws:<br>69laws69<br>"

		if (src.occupant.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			dat += "<b>AI functional</b>"
		if (!src.active)
			dat += {"<br><br><A href='byond://?src=\ref69src69;fix=1'>Be69in Reconstruction</A>"}
		else
			dat += "<br><br>Reconstruction in process, please wait.<br>"
	dat += {" <A href='?src=\ref69user69;mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/aifixer/Process()
	if(..())
		src.updateDialo69()
		return

/obj/machinery/computer/aifixer/Topic(href, href_list)
	if(..())
		return 1
	if (href_list69"fix"69)
		src.active = 1
		src.overlays += ima69e('icons/obj/computer.dmi', "ai-fixer-on")
		while (src.occupant.health < 100)
			src.occupant.adjustOxyLoss(-1)
			src.occupant.adjustFireLoss(-1)
			src.occupant.adjustToxLoss(-1)
			src.occupant.adjustBruteLoss(-1)
			src.occupant.updatehealth()
			if (src.occupant.health >= 0 && src.occupant.stat == DEAD)
				src.occupant.stat = CONSCIOUS
				src.occupant.lyin69 = 0
				69LOB.dead_mob_list -= src.occupant
				69LOB.livin69_mob_list += src.occupant
				src.overlays -= ima69e('icons/obj/computer.dmi', "ai-fixer-404")
				src.overlays += ima69e('icons/obj/computer.dmi', "ai-fixer-full")
				src.occupant.add_ai_verbs()
			src.updateUsrDialo69()
			sleep(10)
		src.active = 0
		src.overlays -= ima69e('icons/obj/computer.dmi', "ai-fixer-on")


		src.add_fin69erprint(usr)
	src.updateUsrDialo69()
	return


/obj/machinery/computer/aifixer/update_icon()
	..()
	if((stat & BROKEN) || (stat & NOPOWER))
		return

	if(occupant)
		if(occupant.stat)
			overlays += ima69e('icons/obj/computer.dmi', "ai-fixer-404")
		else
			overlays += ima69e('icons/obj/computer.dmi', "ai-fixer-full")
	else
		overlays += ima69e('icons/obj/computer.dmi', "ai-fixer-empty")
