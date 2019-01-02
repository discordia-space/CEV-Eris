GLOBAL_LIST_EMPTY(ui_styles)

/*
/datum/interface/createUsingStyle(var/datum/UI_style/style)

/datum/interface/getElementByID()

/datum/interface/getElementsByPlaneID(var/id)

/datum/interface/hide(var/id)

/datum/interface/show(var/id)

/datum/interface/validate()

/datum/interface/update()

/datum/interface/moveOnTop(var/id)

/datum/interface/moveToBottom(var/id)


###########################################
/client/proc/create_UI(var/mob_type)
	used in:
		/datum/mind/proc/transfer_to(mob/living/new_character)
		/datum/admins/proc/cmd_ghost_drag(var/mob/observer/ghost/frommob, var/mob/living/tomob)
		/mob/Login()

/client/proc/destroy_UI()
	used in:
		/mob/Logout()
		/mob/proc/ghostize(var/can_reenter_corpse = 1)

*/

//TODO:
/*
//		Improve elements
//		3 overlays layers under/filling/over
//	rename planes to layouts
//	Improve layouts
		override alignElements with padding(all sides)
		every element has its own padding that are used in _recalculateAlignmentOffset()
		TODO: LATER
			add ablity to lock element and drag it, then save it offset difference in prefs
			calculate offsets based on saved in prefs
			scaling UI
			debug mode

//	CREATE UI
//	CREATE BASIC ELEMENTS (OVERLAY, ACTIVABLE BUTTON)
	overlays 
		that based on flat icon is scaled
	buttons
		filling is highlighted when hovered/clicked

//	REWRITE AND FILL DATA IN STYLES
*/

//	TEST PLANES
//	complete other procs

/datum/interface
	var/chosenStyle
	var/list/HUD_element/_elements = list()		//	list of all ui elements
	var/client/observer						

/datum/interface/New(var/client/observer, var/datum/UI_style/style)
	if(!observer || !istype(observer))
		error("Passed incorrect observer to interface.")
		qdel(src)
		return
	src.observer = observer
	if(style)
		if(!createUsingStyle(style))
			qdel(src)
			return
	. = ..()

/datum/interface/Destroy()
	hide()
	QDEL_NULL_LIST(_elements)
	. = ..()

/datum/interface/proc/createUsingStyle(var/datum/UI_style/style)
	if(!style)
		error("No style.")
		return FALSE
	if(!style._elements || !style._elements.len)
		
		error("UI style elements data is empty.")
		return FALSE

	chosenStyle = style.styleName
	for (var/HUD_element/data in style._elements)
		src._elements += DuplicateObject(data, TRUE)
	return TRUE

/datum/interface/proc/getElementByID(var/id)
	for(var/list/HUD_element/element in _elements)
		if(element.getIdentifier() == id)
			return element
	error("No element found with id \"[id]\".")

/datum/interface/proc/hide(var/id)
	if (!id)
		for(var/list/HUD_element/element in _elements)
			element.hide()
	else
		var/HUD_element/E = getElementByID(id)
		if(E)
			E.hide()
		else
			error("No element with id \"[id]\" found.")

/datum/interface/proc/show(var/id)
	if(!observer)
		error("Interface has no observer.")
		return FALSE
	if (!id)
		for(var/list/HUD_element/element in _elements)
			element.show(observer)
	else
		var/HUD_element/E = getElementByID(id)
		if(E)
			E.show()
		else
			error("No element with id \"[id]\" found.")
	return TRUE

/datum/interface/proc/validate()
	//TODO: THIS
/datum/interface/proc/update()
	//TODO: THIS

/datum/interface/proc/moveOnTop(var/id)
	var/HUD_element/E = getElementByID(id)
	if(istype(E, /HUD_element))
		if(E.getElements())
			for(var/HUD_element/element in E.getElements())
				E.moveChildOnTop(element.getIdentifier())
				_elements.Remove(element)
				_elements.Insert(1,element)
		else
			_elements.Remove(E)
			_elements.Insert(1,E)
	else
		error("moveOnTop(): No element with id \"[id]\" found.")

/datum/interface/proc/moveToBottom(var/id)
	var/HUD_element/E = getElementByID(id)
	if(istype(E, /HUD_element))
		if(E.getElements())
			for(var/HUD_element/element in E.getElements())
				E.moveChildToBottom(element.getIdentifier())
				_elements.Remove(element)
				_elements.Add(element)
		else
			_elements.Remove(E)
			_elements.Add(E)
	else
		error("moveToBottom(): No element with id \"[id]\" found.")

//	UI_style is a datum that initialized at roundstart and stored in global var for easy access
//	Contains data that used by /datum/interface to build interface
//
//	To properly align UI to the screen YOU HAVE TO align planes or elements to either main screen or already aligned planes or elements to main screen
//	STRONGLY KEEP THAT IN MIND otherwise UI will fucked up when client.view var is changed
/datum/UI_style
	var/mobtype
	var/styleName

	var/list/HUD_element/_elements = list()

	var/list/storageData = list()

/datum/UI_style/proc/newUIElement(var/name, var/ui_type, var/icon/icon_state, var/x = 0, var/y = 0, var/list/icon_overlays, var/data)
	if(!name || !ui_type)
		error("interface element will not be created, incorrect data for either name or type")
		return FALSE
	if(name && !istext(name))
		error("name var is not a string.")
		return FALSE
	if(ui_type && !ispath(ui_type))
		error("type var is not a path.")
		return FALSE

	var/HUD_element/element = new ui_type(name)
	element.setName(name)
	if(icon_state)
		element.setIcon(icon_state)
	element.setPosition(x,y)

	if(icon_overlays)
		element.setIconOverlays(icon_overlays)
	if(data)
		element.setData(data)

	_elements += element

	return element

//	ENSURING THAT STYLE IS CREATED PROPERLY
/datum/UI_style/proc/validate()
	var/failed = FALSE
	if(!mobtype)
		error("UI style has no assigned mob type.")
		failed = TRUE
	if(!styleName)
		error("UI style has no name.")
		failed = TRUE
	if(!_elements || !_elements.len)
		error("UI style has no elements.")
		failed = TRUE
	for(var/HUD_element/E in _elements)
		if(E.getParent())
			continue
		else
			if(E.getAlignmentHorizontal() == HUD_NO_ALIGNMENT && E.getAlignmentVertical() == HUD_NO_ALIGNMENT)
				error("YOU DONE GOOFED, i told you that elements without parent should have aligment to screen. Look /datum/UI_style/ docs and /HUD_element/proc/setAlignment(var/horizontal, var/vertical).")
				failed = TRUE
	if(failed)
		error("UI style are created incorrected, see errors above.")
		return FALSE
	return TRUE



/hook/startup/proc/generateUIStyles()
	for(var/UI_type in typesof(/datum/UI_style)-/datum/UI_style)
		var/datum/UI_style/UI = new UI_type()
		if(!GLOB.ui_styles[UI.mobtype])
			GLOB.ui_styles[UI.mobtype] = list()
		GLOB.ui_styles[UI.mobtype] += UI
		//I wont forbid incorectly created UI's to populate list (maybe for testing reasons), but they will have to be fixed anyway
		UI.validate()
	return TRUE

/datum/UI_style/AI_Eris
	mobtype = /mob/living/silicon/ai
	styleName = "ErisStyle"

/datum/UI_style/AI_Eris/New()
	//newUIElement(var/name, var/ui_type, var/icon/icon_state, var/x = 0, var/y = 0, var/list/icon_overlays, var/data)
	var/HUD_element/layout/actionPanel = newUIElement("actionPanel", /HUD_element/layout)
	
	var/list/HUD_element/actions = list()
	actions += newUIElement("AI Core", /HUD_element/button/thin, null, 0, 0, list("filling" = icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"core")))
	actions += newUIElement("Email", /HUD_element/button/thin, null, 32, 0, list("filling" = icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"email")))

	actionPanel.alignElements(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_NO_ALIGNMENT, actions)
	//panel is aligned to screen because it has no parent
	actionPanel.setAlignment(HUD_CENTER_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)


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