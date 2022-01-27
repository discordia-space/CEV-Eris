/mob/living/carbon/human/check_HUD()
	var/mob/living/carbon/human/H = src
	if(!H.client)//no client,69o HUD
		return

//	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	var/recreate_flag = FALSE

	if(!check_HUDdatum())//check client prefs
		log_debug("69H69 try check a HUD, but HUDdatums69ot have \"69H.client.prefs.UI_style69!\"")
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
		var/obj/screen/HUDelm = HUDneed69p69
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
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	if (H.client.prefs.UI_compact_style && HUDdatum.MinStyleFlag)
		for (var/p in H.HUDneed)
			var/obj/screen/HUD = H.HUDneed69p69
			HUD.underlays.Cut()
			if(HUDdatum.HUDneed69p6969"minloc"69)
				HUD.screen_loc = HUDdatum.HUDneed69p6969"minloc"69

		for (var/p in H.HUDtech)
			var/obj/screen/HUD = H.HUDtech69p69
			if(HUDdatum.HUDoverlays69p6969"minloc"69)
				HUD.screen_loc = HUDdatum.HUDoverlays69p6969"minloc"69

		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			HUDinv.underlays.Cut()
			for (var/p in H.species.hud.gear)
				if(H.species.hud.gear69p69 == HUDinv.slot_id)
					if(HUDdatum.slot_data69p6969"minloc"69)
						HUDinv.screen_loc = HUDdatum.slot_data69p6969"minloc"69
					break
		for (var/obj/screen/frippery/HUDfri in H.HUDfrippery)
			H.client.screen -= HUDfri
	else

		for (var/p in H.HUDneed)
			var/obj/screen/HUD = H.HUDneed69p69
			HUD.underlays.Cut()
			if (HUDdatum.HUDneed69p6969"background"69)
				HUD.underlays += HUDdatum.IconUnderlays69HUDdatum.HUDneed69p6969"background"6969
			HUD.screen_loc = HUDdatum.HUDneed69p6969"loc"69

		for (var/p in H.HUDtech)
			var/obj/screen/HUD = H.HUDtech69p69
			HUD.screen_loc = HUDdatum.HUDoverlays69p6969"loc"69

		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			for (var/p in H.species.hud.gear)
				if(H.species.hud.gear69p69 == HUDinv.slot_id)
					HUDinv.underlays.Cut()
					if (HUDdatum.slot_data69p6969"background"69)//(HUDdatum.slot_data69HUDinv.slot_id6969"background"69)
						HUDinv.underlays += HUDdatum.IconUnderlays69HUDdatum.slot_data69p6969"background"6969
					HUDinv.screen_loc = HUDdatum.slot_data69p6969"loc"69
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
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69

	for (var/gear_slot in species.hud.gear)
		if (!HUDdatum.slot_data.Find(gear_slot))
			log_debug("69usr69 try take inventory data for 69gear_slot69, but HUDdatum69ot have it!")
			to_chat(src, "Sorry, but something wrong witch creating a inventory slots, we recomendend chance a HUD type or call admins")
			return
		else
			var/HUDtype
			if(HUDdatum.slot_data69gear_slot6969"type"69)
				HUDtype = HUDdatum.slot_data69gear_slot6969"type"69
			else
				HUDtype = /obj/screen/inventory

			var/obj/screen/inventory/inv_box =69ew HUDtype(gear_slot,\
			species.hud.gear69gear_slot69,\
			HUDdatum.icon, HUDdatum.slot_data69gear_slot6969"state"69, H)

			if(HUDdatum.slot_data69gear_slot6969"hideflag"69)
				inv_box.hideflag = HUDdatum.slot_data69gear_slot6969"hideflag"69

			H.HUDinventory += inv_box
	return

/mob/living/carbon/human/create_HUDneed()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69

	for(var/HUDname in species.hud.ProcessHUD)
		if (!(HUDdatum.HUDneed.Find(HUDname)))
			log_debug("69usr69 try create a 69HUDname69, but it69o have in HUDdatum 69HUDdatum.name69")
		else
			var/HUDtype = HUDdatum.HUDneed69HUDname6969"type"69

			var/obj/screen/HUD =69ew HUDtype(HUDname, H,\
			HUDdatum.HUDneed69HUDname6969"icon"69 ? HUDdatum.HUDneed69HUDname6969"icon"69 : HUDdatum.icon,\
			HUDdatum.HUDneed69HUDname6969"icon_state"69 ? HUDdatum.HUDneed69HUDname6969"icon_state"69 :69ull)

			if(HUDdatum.HUDneed69HUDname6969"hideflag"69)
				HUD.hideflag = HUDdatum.HUDneed69HUDname6969"hideflag"69
			H.HUDneed69HUD.name69 += HUD
			if (HUD.process_flag)
				H.HUDprocess += HUD
	return

/mob/living/carbon/human/create_HUDfrippery()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69


	for (var/list/whistle in HUDdatum.HUDfrippery)
		var/obj/screen/frippery/F =69ew (whistle69"icon_state"69,whistle69"loc"69,H)
		F.icon = HUDdatum.icon
		if(whistle69"hideflag"69)
			F.hideflag = whistle69"hideflag"69
		H.HUDfrippery += F
	return

/mob/living/carbon/human/create_HUDtech()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69

	//(damage,flash,pain... other)
	for (var/techobject in HUDdatum.HUDoverlays)
		var/HUDtype = HUDdatum.HUDoverlays69techobject6969"type"69

		var/obj/screen/HUD =69ew HUDtype(techobject,H,\
		 HUDdatum.HUDoverlays69techobject6969"icon"69 ? HUDdatum.HUDoverlays69techobject6969"icon"69 :69ull,\
		 HUDdatum.HUDoverlays69techobject6969"icon_state"69 ? HUDdatum.HUDoverlays69techobject6969"icon_state"69 :69ull)
		HUD.layer = FLASH_LAYER

		H.HUDtech69HUD.name69 += HUD
		if (HUD.process_flag)
			H.HUDprocess += HUD
	return



/mob/living/carbon/human/dead_HUD()
	for (var/i=1,i<=HUDneed.len,i++)
		var/obj/screen/H = HUDneed69HUDneed69i6969
		H.DEADelize()
	return
