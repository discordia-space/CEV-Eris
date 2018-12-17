GLOBAL_LIST_EMPTY(ui_styles)

/*
/datum/interface/create_using_style(var/datum/UI_style/style)

/datum/interface/new_UI_element(var/plane = "noplane")

/datum/interface/get_element_by_id()

/datum/interface/get_element_by_type()

/datum/interface/get_elements_by_plane(var/plane)

/datum/interface/hide(var/plane)

/datum/interface/show(var/plane)

/datum/interface/validate()

/datum/interface/update()

/datum/interface/move_on_top(var/plane)

/datum/interface/move_to_bottom(var/plane)



###########################################
/mob/proc/create_UI()
	used in:
		/datum/mind/proc/transfer_to(mob/living/new_character)
		/datum/admins/proc/cmd_ghost_drag(var/mob/observer/ghost/frommob, var/mob/living/tomob)
		/mob/living/Login()

/mob/proc/destroy_UI()
	used in:
		/mob/Logout()
		/mob/proc/ghostize(var/can_reenter_corpse = 1)

*/

//TODO:
//	CREATE BASIC ELEMENTS (OVERLAY, ACTIVABLE BUTTON)
//	REWRITE AND FILL DATA IN STYLES
//	CREATE UI

//	MAKE PLANES
//	complete other procs
//	move UI to client
//	icon is not required for batteries in data holder etc
// 	get style from pref

/datum/interface
	var/chosenStyle
	var/list/planes = list()						//	list of planes that used group elements and to determinate in which order to draw elements
	var/list/HUD_element/ui/_elements = list()		//	list of ui elements
	var/client/observer						

/datum/interface/New(var/client/observer, var/datum/UI_style/style)
	if(!observer || !istype(observer))
		log_debug("Error: Passed incorrect observer to interface.")
		qdel(src)
		return
	src.observer = observer
	if(style)
		if(!create_using_style(style))
			qdel(src)
			return
	. = ..()

/datum/interface/Destroy()
	hide()
	QDEL_NULL_LIST(_elements)
	//QDEL_NULL_LIST(planes)
	. = ..()

/datum/interface/proc/create_using_style(var/datum/UI_style/style)
	if(!style)
		log_debug("Error: No style.")
		return FALSE
	if(!style.UI_data || !style.UI_data.len)
		log_debug("Error: UI style data is empty.")
		return FALSE

	chosenStyle = style.styleName
	for (var/UI_elementData/data in style.UI_data)
		new_UI_element(data.name, data.ui_type, data.icon_state, data.x, data.y, data.plane, data.icon_overlays, data.data)
	return TRUE

/datum/interface/proc/new_UI_element(var/name, var/ui_type, var/icon/icon_state, var/x = 0, var/y = 0, var/plane = "noplane", var/icon/icon_overlays, var/data)
	if(!name || !ui_type || !icon_state)
		log_debug("Error: interface element will not be created, incorrect data for either name, type or icon_state.")
		return FALSE
	var/HUD_element/ui/element = new ui_type(name)
	element.setName(name)
	element.setIcon(icon_state)
	element.setPosition(x,y)
	if(!planes[plane])
		planes[plane] = list()
		planes[plane] += element
	else
		planes[plane] += element
	element.setIconOverlay(icon_overlays)
	element.setData(data)

	_elements += element

/datum/interface/proc/get_element_by_id()

/datum/interface/proc/get_element_by_type()

/datum/interface/proc/get_elements_by_plane(var/plane)

//TODO: rework planes
//TODO: show/hide planes
/datum/interface/proc/hide(var/plane)
	for(var/list/HUD_element/ui/element in _elements)
		element.hide()

/datum/interface/proc/show(var/plane)
	if(!observer)
		log_debug("Error: Interface has no observer.")
		return FALSE
	if (!plane)
		for(var/list/HUD_element/ui/element in _elements)
			element.show(observer)
	return TRUE

/datum/interface/proc/validate()

/datum/interface/proc/update()

/datum/interface/proc/move_on_top(var/plane)

/datum/interface/proc/move_to_bottom(var/plane)


//	Holder data type that contains parameters for creating ui element
/UI_elementData/
	//	name of the UI element, used as unique identifier for element. There cant be two elements on the screen with the same identifier
	var/name
	//	type of the UI element, determinates what type of /HUD_element/ui to create
	var/ui_type
	//	name of icon that taken from DMI file to create icon (note that name of DMI file are taken from UI_style datum)
	var/icon_state
	//	position of the element on the screen
	var/x
	var/y
	//	plane name that element will be assigned to
	var/plane
	//	icon overlays that are put on top of ui element icon (things like inventory icons)
	var/icon_overlays
	//	misc data that can be used by /HUD_element/ui
	var/data

//	Creates holder datatype for ui element, first 3 arguments are mandatory
/UI_elementData/New(var/name, var/ui_type, var/icon/icon_state, var/x = 0, var/y = 0, var/plane, var/icon/icon_overlays, var/data)
	if(!name || !type)
		log_debug("Error: \"UI_elementData\" will not be created, incorrect data for either name or type.")
	if(name && !istext(name))
		log_debug("Error: name var is not a string.")
	if(type && !ispath(ui_type))
		log_debug("Error: type var is not a path.")
	if(x == 0 && y == 0)
		log_debug("Warning: created ui element with no set position.")
	src.name = name
	src.ui_type = ui_type
	src.icon_state = icon_state
	src.x = x
	src.y = y
	src.plane = plane
	src.icon_overlays = icon_overlays
	src.data = data

//	UI_style is a datum that initialized at roundstart and stored in global var for easy access
//	Contains data that used by /datum/interface to build interface

/datum/UI_style
	var/mobtype
	var/styleName

	var/list/UI_elementData/UI_data = list()
	var/list/storageData = list()

/hook/startup/proc/generate_UI_styles()
	for(var/UI_type in typesof(/datum/UI_style)-/datum/UI_style)
		var/datum/UI_style/UI = new UI_type()
		GLOB.ui_styles[UI.mobtype] += UI
	return TRUE

/datum/UI_style/AI_Eris
	mobtype = /mob/living/silicon/ai
	styleName = "Eris"

/datum/UI_style/AI_Eris/New()
			 ///UI_elementData/New(var/name, var/ui_type, var/icon/icon_state, var/x = 0, var/y = 0, var/plane, var/icon/icon_overlays, var/data)
	UI_data += new /UI_elementData("AI Core", /HUD_element/ui/button, icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"button_thin"), 20, 20, "actionPanel", icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"core"))
	UI_data += new /UI_elementData("Email", /HUD_element/ui/button, icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"button_thin"), 30, 30, "actionPanel", icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"email"))

/*
/mob/living/silicon/ai/update_hud()
	check_HUD()
	return

/mob/living/silicon/ai/check_HUD()
	var/mob/living/silicon/ai/A = src
	if(!A.client)
		return

//	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]
	var/recreate_flag = FALSE

	if(!check_HUDdatum())
		A.defaultHUD = "BorgStyle"
		recreate_flag = TRUE

	if (recreate_flag)
		A.destroy_HUD()
		A.create_HUD()

	A.show_HUD()
	return recreate_flag

/mob/living/silicon/ai/check_HUDdatum()//correct a datum?
	var/mob/living/silicon/ai/A = src

	if (A.defaultHUD == "BorgStyle") //���� � ������� ���� �������� �����\��� ����
		if(global.HUDdatums.Find(A.defaultHUD))//���� ���������� ����� ��� ����
			return TRUE
	return FALSE

/mob/living/silicon/ai/create_HUD()
//	var/mob/living/silicon/ai/H = src
//	var/datum/hud/cyborg/HUDdatum = global.HUDdatums[H.defaultHUD]

	create_HUDneed()
	create_HUDinventory()
	create_HUDfrippery()
	create_HUDtech()
	show_HUD()
	return

/mob/living/silicon/ai/create_HUDinventory()
/*
	var/mob/living/silicon/ai/H = src
	var/datum/hud/cyborg/HUDdatum = global.HUDdatums[H.defaultHUD]
	for (var/HUDname in HUDdatum.slot_data)
		var/HUDtype
		HUDtype = HUDdatum.slot_data[HUDname]["type"]
//		var/obj/screen/inventory/inv_box = new HUDtype(HUDname, HUDdatum.slot_data[HUDname]["loc"],HUDdatum.icon,HUDdatum.slot_data[HUDname]["icon"] ? HUDdatum.icon,HUDdatum.slot_data[HUDname]["icon"] : ,HUDdatum.icon,HUDdatum.slot_data[HUDname]["icon_state"],H, HUDdatum.slot_data.Find(HUDname))

		var/obj/screen/silicon/inv_box = new HUDtype(HUDname, HUDdatum.slot_data[HUDname]["loc"], \
		HUDdatum.slot_data[HUDname]["icon"] ? HUDdatum.slot_data[HUDname]["icon"] : HUDdatum.icon, \
		HUDdatum.slot_data[HUDname]["icon_state"] ? HUDdatum.slot_data[HUDname]["icon_state"] : null,\
		H, HUDdatum.slot_data.Find(HUDname))

		H.HUDinventory += inv_box
		*/
	return

/mob/living/silicon/ai/create_HUDneed()
	var/HUD_element/ui/ai/alerts/AI_core = new
	AI_core.setName("HUD Storage Close Button")
	AI_core.setData("object", src)
	AI_core.setAlignment(5,3)
	AI_core.setPosition(50,50)
	AI_core.show(client)

/*
	var/mob/living/silicon/ai/H = src
	var/datum/hud/cyborg/HUDdatum = global.HUDdatums[H.defaultHUD]
	for (var/HUDname in HUDdatum.HUDneed)
		var/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
//		var/obj/screen/HUD = new HUDtype(HUDname, HUDdatum.HUDneed[HUDname]["loc"], H)

		var/obj/screen/HUD = new HUDtype(HUDname, H,\
		HUDdatum.HUDneed[HUDname]["icon"] ? HUDdatum.HUDneed[HUDname]["icon"] : HUDdatum.icon,\
		HUDdatum.HUDneed[HUDname]["icon_state"] ? HUDdatum.HUDneed[HUDname]["icon_state"] : null)

		HUD.screen_loc = HUDdatum.HUDneed[HUDname]["loc"]
//		if(HUDdatum.HUDneed[HUDname]["icon"])//������ �� �������� icon
//			HUD.icon = HUDdatum.HUDneed[HUDname]["icon"]
//		else
//			HUD.icon = HUDdatum.icon
//		if(HUDdatum.HUDneed[HUDname]["icon_state"])//������ �� �������� icon_state
//			HUD.icon_state = HUDdatum.HUDneed[HUDname]["icon_state"]
		H.HUDneed[HUD.name] += HUD//��������� � ������ �����
		if (HUD.process_flag)//���� ��� ����� ����������
			H.HUDprocess += HUD//������� � �������������� ������
	return

/mob/living/silicon/ai/create_HUDfrippery()
	var/mob/living/silicon/ai/H = src
	var/datum/hud/cyborg/HUDdatum = global.HUDdatums[H.defaultHUD]
	//��������� �������� ���� (���������)
	for (var/list/whistle in HUDdatum.HUDfrippery)
		var/obj/screen/frippery/perdelka = new (whistle["icon_state"],whistle["loc"], whistle["dir"],H)
		perdelka.icon = HUDdatum.icon
		H.HUDfrippery += perdelka
		*/
	return

/mob/living/silicon/ai/create_HUDtech()
/*
	var/mob/living/silicon/ai/H = src
	var/datum/hud/cyborg/HUDdatum = global.HUDdatums[H.defaultHUD]
	//��������� ����������� ��������(damage,flash,pain... �������)
	for (var/techobject in HUDdatum.HUDoverlays)
		var/HUDtype = HUDdatum.HUDoverlays[techobject]["type"]
		var/obj/screen/HUD = new HUDtype(_name = techobject, _parentmob = H)// _screen_loc = HUDdatum.HUDoverlays[techobject]["loc"]
		if(HUDdatum.HUDoverlays[techobject]["icon"])//������ �� �������� icon
			HUD.icon = HUDdatum.HUDoverlays[techobject]["icon"]
		else
			HUD.icon = HUDdatum.icon
		if(HUDdatum.HUDoverlays[techobject]["icon_state"])//������ �� �������� icon_state
			HUD.icon_state = HUDdatum.HUDoverlays[techobject]["icon_state"]
		H.HUDtech[HUD.name] += HUD//��������� � ������ �����
		if (HUD.process_flag)//���� ��� ����� ����������
			H.HUDprocess += HUD//������� � �������������� ������
			*/
	return
	*/