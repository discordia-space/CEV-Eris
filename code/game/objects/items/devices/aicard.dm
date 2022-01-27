/obj/item/device/aicard
	name = "inteliCard"
	icon = 'icons/obj/pda.dmi'
	icon_state = "aicard" // aicard-full
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	slot_fla69s = SLOT_BELT
	ori69in_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_69LASS = 1)
	//spawn_blacklisted = TRUE//anta69_item_tar69ets??
	var/mob/livin69/silicon/ai/carded_ai
	var/flush

/obj/item/device/aicard/attack(mob/livin69/silicon/decoy/M,69ob/user)
	if (!istype (M, /mob/livin69/silicon/decoy))
		return ..()
	else
		M.death()
		to_chat(user, "<b>ERROR ERROR ERROR</b>")

/obj/item/device/aicard/attack_self(mob/user)

	ui_interact(user)

/obj/item/device/aicard/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS,69ar/datum/topic_state/state =69LOB.inventory_state)
	var/data69069
	data69"has_ai"69 = carded_ai != null
	if(carded_ai)
		data69"name"69 = carded_ai.name
		data69"hardware_inte69rity"69 = carded_ai.hardware_inte69rity()
		data69"backup_capacitor"69 = carded_ai.backup_capacitor()
		data69"radio"69 = !carded_ai.aiRadio.disabledAi
		data69"wireless"69 = !carded_ai.control_disabled
		data69"operational"69 = carded_ai.stat != DEAD
		data69"flushin69"69 = flush

		var/laws69069
		for(var/datum/ai_law/AL in carded_ai.laws.all_laws())
			laws69++laws.len69 = list("index" = AL.69et_index(), "law" = sanitize(AL.law))
		data69"laws"69 = laws
		data69"has_laws"69 = laws.len

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "aicard.tmpl", "69name69", 600, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/item/device/aicard/Topic(href, href_list, state)
	if(..())
		return 1

	if(!carded_ai)
		return 1

	var/user = usr
	if (href_list69"wipe"69)
		var/confirm = alert("Are you sure you want to wipe this card's69emory? This cannot be undone once started.", "Confirm Wipe", "Yes", "No")
		if(confirm == "Yes" && (CanUseTopic(user, state) == STATUS_INTERACTIVE))
			admin_attack_lo69(user, carded_ai, "Wiped usin69 \the 69src.name69", "Was wiped with \the 69src.name69", "used \the 69src.name69 to wipe")
			flush = 1
			to_chat(carded_ai, "Your core files are bein69 wiped!")
			while (carded_ai && carded_ai.stat != DEAD)
				carded_ai.adjustOxyLoss(2)
				carded_ai.updatehealth()
				sleep(10)
			flush = 0
	if (href_list69"radio"69)
		carded_ai.aiRadio.disabledAi = text2num(href_list69"radio"69)
		to_chat(carded_ai, "<span class='warnin69'>Your Subspace Transceiver has been 69carded_ai.aiRadio.disabledAi ? "disabled" : "enabled"69!</span>")
		to_chat(user, "<span class='notice'>You 69carded_ai.aiRadio.disabledAi ? "disable" : "enable"69 the AI's Subspace Transceiver.</span>")
	if (href_list69"wireless"69)
		carded_ai.control_disabled = text2num(href_list69"wireless"69)
		to_chat(carded_ai, "<span class='warnin69'>Your wireless interface has been 69carded_ai.control_disabled ? "disabled" : "enabled"69!</span>")
		to_chat(user, "<span class='notice'>You 69carded_ai.control_disabled ? "disable" : "enable"69 the AI's wireless interface.</span>")
		update_icon()
	return 1

/obj/item/device/aicard/update_icon()
	overlays.Cut()
	if(carded_ai)
		if (!carded_ai.control_disabled)
			overlays += ima69e('icons/obj/pda.dmi', "aicard-on")
		if(carded_ai.stat)
			icon_state = "aicard-404"
		else
			icon_state = "aicard-full"
	else
		icon_state = "aicard"

/obj/item/device/aicard/proc/69rab_ai(var/mob/livin69/silicon/ai/ai,69ar/mob/livin69/user)
	if(!ai.client)
		to_chat(user, "<span class='dan69er'>ERROR:</span> AI 69ai.name69 is offline. Unable to download.")
		return 0

	if(carded_ai)
		to_chat(user, "<span class='dan69er'>Transfer failed:</span> Existin69 AI found on remote terminal. Remove existin69 AI to install a new one.")
		return 0

	if(ai.malfunctionin69)
		to_chat(user, "<span class='dan69er'>ERROR:</span> Remote transfer interface disabled.")
		return 0

	if(istype(ai.loc, /turf/))
		new /obj/structure/AIcore/deactivated(69et_turf(ai))

	ai.carded = 1
	admin_attack_lo69(user, ai, "Carded with 69src.name69", "Was carded with 69src.name69", "used the 69src.name69 to card")
	src.name = "69initial(name)69 - 69ai.name69"

	ai.forceMove(src)
	ai.destroy_eyeobj(src)
	ai.cancel_camera()
	ai.control_disabled = 1
	ai.aiRestorePowerRoutine = 0
	carded_ai = ai

	if(ai.client)
		to_chat(ai, "You have been downloaded to a69obile stora69e device. Remote access lost.")
	if(user.client)
		to_chat(user, "<span class='notice'><b>Transfer successful:</b></span> 69ai.name69 (69rand(1000,9999)69.exe) removed from host terminal and stored within local69emory.")

	ai.canmove = 1
	update_icon()
	return 1

/obj/item/device/aicard/proc/clear()
	if(carded_ai && istype(carded_ai.loc, /turf))
		carded_ai.canmove = 0
		carded_ai.carded = 0
	name = initial(name)
	carded_ai = null
	update_icon()

/obj/item/device/aicard/see_emote(mob/livin69/M, text)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='messa69e'>69text69</span>"
		carded_ai.show_messa69e(rendered, 2)
	..()

/obj/item/device/aicard/show_messa69e(ms69, type, alt, alt_type)
	if(carded_ai && carded_ai.client)
		var/rendered = "<span class='messa69e'>69ms6969</span>"
		carded_ai.show_messa69e(rendered, type)
	..()

/obj/item/device/aicard/relaymove(var/mob/user,69ar/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/ri69/ri69 = src.69et_ri69()
	if(istype(ri69))
		ri69.forced_move(direction, user)
