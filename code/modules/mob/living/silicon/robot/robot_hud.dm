/mob/living/silicon/robot/update_hud()
	check_HUD()
	return

/mob/living/silicon/robot/check_HUD()
	var/mob/living/silicon/robot/H = src
	if(!H.client)
		return

//	var/datum/hud/human/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	var/recreate_flag = FALSE

	if(!check_HUDdatum())
		H.defaultHUD = "BorgStyle"
		recreate_flag = TRUE

	if (recreate_flag)
		H.destroy_HUD()
		H.create_HUD()

	H.show_HUD()
	return recreate_flag


/mob/living/silicon/robot/check_HUDdatum()//correct a datum?
	var/mob/living/silicon/robot/H = src

	if (H.defaultHUD == "BorgStyle") //���� � ������� ���� �������� �����\��� ����
		if(GLOB.HUDdatums.Find(H.defaultHUD))//���� ���������� ����� ��� ����
			return TRUE
	return FALSE

/mob/living/silicon/robot/create_HUDinventory()
	var/mob/living/silicon/robot/H = src
	var/datum/hud/cyborg/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	for (var/HUDname in HUDdatum.slot_data)
		var/HUDtype
		HUDtype = HUDdatum.slot_data69HUDname6969"type"69
//		var/obj/screen/inventory/inv_box =69ew HUDtype(HUDname, HUDdatum.slot_data69HUDname6969"loc"69,HUDdatum.icon,HUDdatum.slot_data69HUDname6969"icon"69 ? HUDdatum.icon,HUDdatum.slot_data69HUDname6969"icon"69 : ,HUDdatum.icon,HUDdatum.slot_data69HUDname6969"icon_state"69,H, HUDdatum.slot_data.Find(HUDname))

		var/obj/screen/silicon/inv_box =69ew HUDtype(HUDname, HUDdatum.slot_data69HUDname6969"loc"69, \
		HUDdatum.slot_data69HUDname6969"icon"69 ? HUDdatum.slot_data69HUDname6969"icon"69 : HUDdatum.icon, \
		HUDdatum.slot_data69HUDname6969"icon_state"69 ? HUDdatum.slot_data69HUDname6969"icon_state"69 :69ull,\
		H, HUDdatum.slot_data.Find(HUDname))

		H.HUDinventory += inv_box
	return



/mob/living/silicon/robot/create_HUDneed()
	var/mob/living/silicon/robot/H = src
	var/datum/hud/cyborg/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	for (var/HUDname in HUDdatum.HUDneed)
		var/HUDtype = HUDdatum.HUDneed69HUDname6969"type"69
//		var/obj/screen/HUD =69ew HUDtype(HUDname, HUDdatum.HUDneed69HUDname6969"loc"69, H)

		var/obj/screen/HUD =69ew HUDtype(HUDname, H,\
		HUDdatum.HUDneed69HUDname6969"icon"69 ? HUDdatum.HUDneed69HUDname6969"icon"69 : HUDdatum.icon,\
		HUDdatum.HUDneed69HUDname6969"icon_state"69 ? HUDdatum.HUDneed69HUDname6969"icon_state"69 :69ull)

		HUD.screen_loc = HUDdatum.HUDneed69HUDname6969"loc"69
//		if(HUDdatum.HUDneed69HUDname6969"icon"69)//������ �� �������� icon
//			HUD.icon = HUDdatum.HUDneed69HUDname6969"icon"69
//		else
//			HUD.icon = HUDdatum.icon
//		if(HUDdatum.HUDneed69HUDname6969"icon_state"69)//������ �� �������� icon_state
//			HUD.icon_state = HUDdatum.HUDneed69HUDname6969"icon_state"69
		H.HUDneed69HUD.name69 += HUD//��������� � ������ �����
		if (HUD.process_flag)//���� ��� ����� ����������
			H.HUDprocess += HUD//������� � �������������� ������
	return



/mob/living/silicon/robot/create_HUDfrippery()
	var/mob/living/silicon/robot/H = src
	var/datum/hud/cyborg/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	//��������� �������� ���� (���������)
	for (var/list/whistle in HUDdatum.HUDfrippery)
		var/obj/screen/frippery/F =69ew (whistle69"icon_state"69,whistle69"loc"69, whistle69"dir"69,H)
		F.icon = HUDdatum.icon
		H.HUDfrippery += F
	return



/mob/living/silicon/robot/create_HUDtech()
	var/mob/living/silicon/robot/H = src
	var/datum/hud/cyborg/HUDdatum = GLOB.HUDdatums69H.defaultHUD69
	//��������� ����������� ��������(damage,flash,pain... �������)
	for (var/techobject in HUDdatum.HUDoverlays)
		var/HUDtype = HUDdatum.HUDoverlays69techobject6969"type"69
		var/obj/screen/HUD =69ew HUDtype(_name = techobject, _parentmob = H)// _screen_loc = HUDdatum.HUDoverlays69techobject6969"loc"69
		if(HUDdatum.HUDoverlays69techobject6969"icon"69)//������ �� �������� icon
			HUD.icon = HUDdatum.HUDoverlays69techobject6969"icon"69
		else
			HUD.icon = HUDdatum.icon
		if(HUDdatum.HUDoverlays69techobject6969"icon_state"69)//������ �� �������� icon_state
			HUD.icon_state = HUDdatum.HUDoverlays69techobject6969"icon_state"69
		H.HUDtech69HUD.name69 += HUD//��������� � ������ �����
		if (HUD.process_flag)//���� ��� ����� ����������
			H.HUDprocess += HUD//������� � �������������� ������
	return








/mob/living/silicon/robot/proc/toggle_show_robot_modules()
	if(!isrobot(src))
		return

	var/mob/living/silicon/robot/r = src

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/mob/living/silicon/robot/proc/update_robot_modules_display()
	if(!isrobot(src))
		return

	var/mob/living/silicon/robot/r = src

	if(r.shown_robot_modules)
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, SPAN_DANGER("No69odule selected"))
			return

		if(!r.module.modules)
			to_chat(usr, SPAN_DANGER("Selected69odule has69o69odules to select"))
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+69display_rows69:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag69odule to the list of69odules has to be here. This is because a borg can
		//be emagged before they actually select a69odule. - or some situation can cause them to get a69ew69odule
		// - or some situation69ight cause them to get de-emagged or something.
		if(r.emagged)
			if(!(r.module.emag in r.module.modules))
				r.module.modules.Add(r.module.emag)
		else
			if(r.module.emag in r.module.modules)
				r.module.modules.Remove(r.module.emag)

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is69ot currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER69x69:16,SOUTH+69y69:7"
				else
					A.screen_loc = "CENTER+69x69:16,SOUTH+69y69:7"
				A.layer = 20

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is69ot currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background