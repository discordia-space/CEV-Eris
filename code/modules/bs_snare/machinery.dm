/obj/machinery/bssilk_hub
	name = "bluespace snare hub"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "tele0"
	w_class = ITEM_SIZE_GARGANTUAN
	density = FALSE
	anchored = TRUE
	interact_offline = 1

	var/silk_id = ""

	var/console_id = ""
	var/obj/machinery/computer/bssilk_control/connected_console

	//animations
	var/animation_icon = 'icons/effects/bs_snare.dmi'
	var/back_animation = "silc_teleport_back"
	var/onhub_animation = "silc_get_hub"

/obj/machinery/bssilk_hub/attackby(obj/item/I,69ob/user)
	sync_with_parts()
	if(QUALITY_PULSING in I.tool_qualities)
		switch(alert("What you want to configure console ID or snare ID?", "BS Snare Hub ID system", "Snare", "Console"))
			if("Snare")
				var/input_id = input("Enter new BS Snare ID", "Snare ID", silk_id)
				silk_id = input_id
				sync_with_parts()
				return silk_id
			if("Console")
				var/input_c_id = input("Enter new BS Snare ID", "Snare ID", console_id)
				console_id = input_c_id
				connected_console = null
				sync_with_parts()
				return console_id

/obj/machinery/bssilk_hub/proc/sync_with_parts()
	for(var/obj/machinery/computer/bssilk_control/CON in GLOB.computer_list)
		if(!CON.connected_hub && CON.hub_id && CON.hub_id == console_id)
			connected_console = CON
			CON.connected_hub = src
		else
			connected_console = null
	. += connected_console

/*
/obj/machinery/bssilk_hub/Process()
	..()
	sync_with_parts()
*/

/obj/machinery/bssilk_hub/proc/get_linked_mob()
	sync_with_parts()
	var/list/mobs = list()
	for(var/mob/living/carbon/human/M in world)
		var/obj/item/clothing/U =69.w_uniform
		if(U && length(U.accessories))
			for(var/obj/item/clothing/accessory/bs_silk/silk in U.accessories)
				if(M && silk.silk_id && silk.silk_id == silk_id)
					teleport_back(M)
					mobs +=69
	if(length(mobs) == 0)
		playsound(src.loc, 'sound/machines/buzz-sigh.ogg')
		playsound(src.loc, 'sound/voice/bfreeze.ogg', 50, 1)
		audible_message(SPAN_WARNING("The 69src.name69 buzzes and state \'SNARE EITHER DISABLED OR NOT AVAILABLE, TRY TO PROBE IT AGAIN, IF YOU ARE SURE THAT THE SNARE IN A GOOD CONDITION OR CONNECTED TO USER.\'"),
						SPAN_WARNING("The 69src.name69 buzzes and state something."),
						hearing_distance = 5
						)
	return69obs

/obj/machinery/bssilk_hub/proc/teleport_back(mob/target)
	to_chat(target, SPAN_WARNING("You feel like something pull you in bluespace."))
	//Creat animation and69ove 69ob into it and69ob will not walking. Camera will follow animation.
	var/obj/effect/temporary/A = new(get_turf(target), 24.5, animation_icon, back_animation)
	target.dir = 2
	target.forceMove(A)
	bluespace_entropy(3, get_turf(A))
	sleep(23)
	target.forceMove(src)
	bluespace_entropy(3, get_turf(src))
	target.dir = 2
	new /obj/effect/temporary(get_turf(src), 26.5, animation_icon, onhub_animation)
	sleep(24)
	target.forceMove(loc)
	bluespace_entropy(3, get_turf(loc))

/obj/machinery/bssilk_hub/Destroy()
	. = ..()
	if(connected_console) connected_console.connected_hub = null
	connected_console = null

/obj/machinery/computer/bssilk_control
	name = "bluespace snare control"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	circuit = /obj/item/electronics/circuitboard/bssilk_cons

	icon_keyboard = "rd_key"
	icon_screen = "telesci"

	var/hub_id = ""
	var/obj/machinery/bssilk_hub/connected_hub

/obj/machinery/computer/bssilk_control/Destroy()
	. = ..()
	if(connected_hub) connected_hub.connected_console = null
	connected_hub = null

/obj/machinery/computer/bssilk_control/attack_hand(mob/user)
	if(connected_hub) connected_hub.sync_with_parts()
	ui_interact(user)

/obj/machinery/computer/bssilk_control/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = 1)
	var/list/data = ui_data()

	if(!connected_hub)
		data69"fail_connect"69 = TRUE
	else
		data69"hub_id"69 = hub_id
		data69"snare_id"69 = connected_hub.silk_id

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bs_snare_controller.tmpl", "BS Snare Control", 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/bssilk_control/proc/find_hub()
	for(var/obj/machinery/bssilk_hub/HUB in GLOB.machines)
		if(!HUB.connected_console && HUB.console_id && HUB.console_id == hub_id)
			connected_hub = HUB
			HUB.connected_console = src
		else
			connected_hub = null
	. += connected_hub

/obj/machinery/computer/bssilk_control/OnTopic(mob/user, list/href_list, state)
	. = ..()

	if(href_list69"resync"69)
		connected_hub.sync_with_parts()

	if(href_list69"get_snaring"69)
		connected_hub.get_linked_mob()

	if(href_list69"set_id"69)
		var/new_id = input("Enter HUB id.", "HUB ID", hub_id)
		hub_id = new_id
		if(connected_hub) connected_hub.sync_with_parts()
		connected_hub = null
		find_hub()

	return TOPIC_REFRESH