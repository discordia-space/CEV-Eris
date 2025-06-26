/obj/machinery/computer/aifixer
	name = "\improper AI system integrity restorer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "rd_key"
	icon_screen = "ai-fixer"
	light_color = COLOR_LIGHTING_PURPLE_MACHINERY
	circuit = /obj/item/electronics/circuitboard/aifixer
	req_one_access = list(access_robotics, access_heads)
	var/mob/living/silicon/ai/occupant
	var/active = 0

/obj/machinery/computer/aifixer/New()
	..()
	update_icon()

/obj/machinery/computer/aifixer/proc/load_ai(mob/living/silicon/ai/transfer, obj/item/device/aicard/card, mob/user)
	if(!transfer)
		return

	// Transfer over the AI.
	to_chat(transfer, "You have been uploaded to a stationary terminal. Sadly, there is no remote access from here.")
	to_chat(user, "<span class='notice'>Transfer successful:</span> [transfer.name] ([rand(1000,9999)].exe) installed and executed successfully. Local copy has been removed.")
	transfer.loc = src
	transfer.cancel_camera()
	transfer.control_disabled = 1
	occupant = transfer
	if(card)
		card.clear()
	update_icon()

/obj/machinery/computer/aifixer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/device/aicard))
		if(stat & (NOPOWER|BROKEN))
			to_chat(user, "This terminal isn't functioning right now.")
			return

		var/obj/item/device/aicard/card = I
		var/mob/living/silicon/ai/comp_ai = locate() in src
		var/mob/living/silicon/ai/card_ai = locate() in card

		if(istype(comp_ai))
			if(active)
				to_chat(user, "<span class='danger'>ERROR:</span> Reconstruction in progress.")
				return
			card.grab_ai(comp_ai, user)
			if(!(locate(/mob/living/silicon/ai) in src)) occupant = null
		else if(istype(card_ai))
			load_ai(card_ai,card,user)
			occupant = locate(/mob/living/silicon/ai) in src

		update_icon()
		return
	..()

/obj/machinery/computer/aifixer/attack_hand(mob/user)
	if(..())
		return

	user.set_machine(src)
	var/dat = "<h3>AI System Integrity Restorer</h3><br><br>"
	if(occupant)
		var/laws
		dat += "Stored AI: [occupant.name]<br>System integrity: [occupant.hardware_integrity()]%<br>Backup Capacitor: [occupant.backup_capacitor()]%<br>"
		for(var/datum/ai_law/law in occupant.laws.all_laws())
			laws += "[law.get_index()]: [law.law]<BR>"

		dat += "Laws:<br>[laws]<br>"
		if(occupant.stat == 2)
			dat += "<b>AI nonfunctional</b>"
		else
			dat += "<b>AI functional</b>"
		if(!active)
			dat += {"<br><br><a href='byond://?src=\ref[src];fix=1'>Begin Reconstruction</A>"}
		else
			dat += "<br><br>Reconstruction in process, please wait.<br>"
	dat += {" <a href='byond://?src=\ref[user];mach_close=computer'>Close</A>"}
	user << browse(HTML_SKELETON(dat), "window=computer;size=400x500")
	onclose(user, "computer")

/obj/machinery/computer/aifixer/Process()
	if(..())
		updateDialog()

/obj/machinery/computer/aifixer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["fix"])
		active = 1
		overlays += image('icons/obj/computer.dmi', "ai-fixer-on")
		while(occupant.health < 100)
			occupant.adjustOxyLoss(-1)
			occupant.adjustFireLoss(-1)
			occupant.adjustToxLoss(-1)
			occupant.adjustBruteLoss(-1)
			occupant.updatehealth()
			if(occupant.health >= 0 && occupant.stat == DEAD)
				occupant.stat = CONSCIOUS
				occupant.lying = 0
				GLOB.dead_mob_list -= occupant
				GLOB.living_mob_list += occupant
				overlays -= image('icons/obj/computer.dmi', "ai-fixer-404")
				overlays += image('icons/obj/computer.dmi', "ai-fixer-full")
				occupant.add_ai_verbs()
			updateUsrDialog()
			sleep(10)
		active = 0
		overlays -= image('icons/obj/computer.dmi', "ai-fixer-on")
		add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/computer/aifixer/update_icon()
	..()
	if((stat & BROKEN) || (stat & NOPOWER))
		return

	if(occupant)
		if(occupant.stat)
			overlays += image('icons/obj/computer.dmi', "ai-fixer-404")
		else
			overlays += image('icons/obj/computer.dmi', "ai-fixer-full")
	else
		overlays += image('icons/obj/computer.dmi', "ai-fixer-empty")
