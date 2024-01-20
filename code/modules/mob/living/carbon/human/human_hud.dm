/mob/living/carbon/human/check_HUD()
	var/mob/living/carbon/human/H = src
	if(!H.client)//no client, no HUD
		return

//	var/datum/hud/human/HUDdatum = GLOB.HUDdatums[H.defaultHUD]
	var/recreate_flag = FALSE

	if(!check_HUDdatum())//check client prefs
		log_debug("[H] try check a HUD, but HUDdatums not have \"[H.client.prefs.UI_style]!\"")
		to_chat(H, "Some problem hase accure, use default HUD type")
		H.defaultHUD = "ErisStyle"
		recreate_flag = TRUE
	else if (H.client.prefs.UI_style != H.defaultHUD)
		H.defaultHUD = H.client.prefs.UI_style
		recreate_flag = TRUE

	if(recreate_flag)
		H.reset_HUD()


	H.show_HUD()
	H.minimalize_HUD()

	if(!recreate_flag && !check_HUD_style())//Check HUD colour
		H.recolor_HUD(H.client.prefs.UI_style_color, H.client.prefs.UI_style_alpha)

	return recreate_flag

/mob/living/carbon/human/check_HUD_style()
	var/mob/living/carbon/human/H = src


	for (var/obj/screen/inventory/HUDinv in H.HUDinventory)

		if (HUDinv.color != H.client.prefs.UI_style_color || HUDinv.alpha != H.client.prefs.UI_style_alpha)
			return FALSE

	for (var/p in HUDneed)
		var/obj/screen/HUDelm = HUDneed[p]
		if (HUDelm.color != H.client.prefs.UI_style_color || HUDelm.alpha != H.client.prefs.UI_style_alpha)
			return FALSE
	return TRUE

/mob/living/carbon/human/check_HUDdatum()//correct a datum?
	var/mob/living/carbon/human/H = src

	if (H.client.prefs.UI_style && !(H.client.prefs.UI_style == ""))
		if(GLOB.HUDdatums.Find(H.client.prefs.UI_style))
			return TRUE

	return FALSE

/mob/living/carbon/human/minimalize_HUD()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums[H.defaultHUD]
	if (H.client.prefs.UI_compact_style && HUDdatum.MinStyleFlag)
		for (var/p in H.HUDneed)
			var/obj/screen/HUD = H.HUDneed[p]
			HUD.underlays.Cut()
			if(HUDdatum.HUDneed[p]["minloc"])
				HUD.screen_loc = HUDdatum.HUDneed[p]["minloc"]

		for (var/p in H.HUDtech)
			var/obj/screen/HUD = H.HUDtech[p]
			if(HUDdatum.HUDoverlays[p]["minloc"])
				HUD.screen_loc = HUDdatum.HUDoverlays[p]["minloc"]

		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			HUDinv.underlays.Cut()
			for (var/p in H.species.hud.gear)
				if(H.species.hud.gear[p] == HUDinv.slot_id)
					if(HUDdatum.slot_data[p]["minloc"])
						HUDinv.screen_loc = HUDdatum.slot_data[p]["minloc"]
					break
		for (var/obj/screen/frippery/HUDfri in H.HUDfrippery)
			H.client.screen -= HUDfri
	else

		for (var/p in H.HUDneed)
			var/obj/screen/HUD = H.HUDneed[p]
			HUD.underlays.Cut()
			if (HUDdatum.HUDneed[p]["background"])
				HUD.underlays += HUDdatum.IconUnderlays[HUDdatum.HUDneed[p]["background"]]
			HUD.screen_loc = HUDdatum.HUDneed[p]["loc"]

		for (var/p in H.HUDtech)
			var/obj/screen/HUD = H.HUDtech[p]
			HUD.screen_loc = HUDdatum.HUDoverlays[p]["loc"]

		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			for (var/p in H.species.hud.gear)
				if(H.species.hud.gear[p] == HUDinv.slot_id)
					HUDinv.underlays.Cut()
					if (HUDdatum.slot_data[p]["background"])//(HUDdatum.slot_data[HUDinv.slot_id]["background"])
						HUDinv.underlays += HUDdatum.IconUnderlays[HUDdatum.slot_data[p]["background"]]
					HUDinv.screen_loc = HUDdatum.slot_data[p]["loc"]
					break
		for (var/obj/screen/frippery/HUDfri in H.HUDfrippery)
			H.client.screen += HUDfri
	//update_equip_icon_position()
	for(var/obj/item/I in get_equipped_items(1))
		var/slotID = get_inventory_slot(I)
		I.screen_loc = find_inv_position(slotID)

	var/obj/item/I = get_active_hand()
	if(I)
		I.update_hud_actions()
/*	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)*/
//	H.regenerate_icons()
	return


/mob/living/carbon/human/update_hud()
	if(client)
		check_HUD()
		client.screen |= contents
		//if(hud_used)
			//hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar
	return


/mob/living/carbon/human/create_HUD()
	. = ..()
	recolor_HUD(src.client.prefs.UI_style_color, src.client.prefs.UI_style_alpha)
	return

/mob/living/carbon/human/create_HUDinventory()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums[H.defaultHUD]

	for (var/gear_slot in species.hud.gear)
		if (!HUDdatum.slot_data.Find(gear_slot))
			log_debug("[usr] try take inventory data for [gear_slot], but HUDdatum not have it!")
			to_chat(src, "Sorry, but something wrong witch creating a inventory slots, we recomendend chance a HUD type or call admins")
			return
		else
			var/HUDtype
			if(HUDdatum.slot_data[gear_slot]["type"])
				HUDtype = HUDdatum.slot_data[gear_slot]["type"]
			else
				HUDtype = /obj/screen/inventory

			var/obj/screen/inventory/inv_box = new HUDtype(gear_slot,\
			species.hud.gear[gear_slot],\
			HUDdatum.icon, HUDdatum.slot_data[gear_slot]["state"], H)

			if(HUDdatum.slot_data[gear_slot]["hideflag"])
				inv_box.hideflag = HUDdatum.slot_data[gear_slot]["hideflag"]

			H.HUDinventory += inv_box
	return

/mob/living/carbon/human/create_HUDneed()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums[H.defaultHUD]

	for(var/HUDname in species.hud.ProcessHUD)
		if (!(HUDdatum.HUDneed.Find(HUDname)))
			log_debug("[usr] try create a [HUDname], but it no have in HUDdatum [HUDdatum.name]")
		else
			var/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
			var/obj/screen/HUD = new HUDtype(HUDname, H,\
			HUDdatum.HUDneed[HUDname]["icon"] ? HUDdatum.HUDneed[HUDname]["icon"] : HUDdatum.icon,\
			HUDdatum.HUDneed[HUDname]["icon_state"] ? HUDdatum.HUDneed[HUDname]["icon_state"] : null)

			if(HUDdatum.HUDneed[HUDname]["hideflag"])
				HUD.hideflag = HUDdatum.HUDneed[HUDname]["hideflag"]
			H.HUDneed[HUD.name] += HUD
			if (HUD.process_flag)
				H.HUDprocess += HUD
			if(length(HUDdatum.HUDneed[HUDname]["customvars"]))
				var/list/customVariables = HUDdatum.HUDneed[HUDname]["customvars"]
				for(var/variable in customVariables)
					HUD.vars[variable] = customVariables[variable]
			HUD.update_icon()
	return

/mob/living/carbon/human/create_HUDfrippery()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums[H.defaultHUD]


	for (var/list/whistle in HUDdatum.HUDfrippery)
		var/obj/screen/frippery/F = new (whistle["icon_state"],whistle["loc"],H)
		F.icon = HUDdatum.icon
		if(whistle["hideflag"])
			F.hideflag = whistle["hideflag"]
		H.HUDfrippery += F
	return

/mob/living/carbon/human/create_HUDtech()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums[H.defaultHUD]

	//(damage,flash,pain... other)
	for (var/techobject in HUDdatum.HUDoverlays)
		var/HUDtype = HUDdatum.HUDoverlays[techobject]["type"]

		var/obj/screen/HUD = new HUDtype(techobject,H,\
		 HUDdatum.HUDoverlays[techobject]["icon"] ? HUDdatum.HUDoverlays[techobject]["icon"] : null,\
		 HUDdatum.HUDoverlays[techobject]["icon_state"] ? HUDdatum.HUDoverlays[techobject]["icon_state"] : null)
		HUD.layer = FLASH_LAYER

		H.HUDtech[HUD.name] += HUD
		if (HUD.process_flag)
			H.HUDprocess += HUD
	return



/mob/living/carbon/human/dead_HUD()
	for (var/i=1,i<=HUDneed.len,i++)
		var/obj/screen/H = HUDneed[HUDneed[i]]
		H.DEADelize()
	return
