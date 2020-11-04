GLOBAL_LIST_EMPTY(ui_styles)

/*
/datum/interface/createUsingStyle(var/datum/UI_style/style)

/datum/interface/getElementByID()

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

//	CREATE UI
	flipperty slopes
	radio button
	language button
	notes button
	pop up vote button
	unbuckle UI


TODO: LATER
	add ablity to lock element and drag it, then save it offset difference in prefs
	calculate offsets based on saved in prefs
	scaling UI
	colorize proc for UI element
		
*/

/datum/interface
	var/mobtype = "interfaceless"
	var/styleName = "ErisStyle"

	var/list/HUD_element/_elements = list()		//	list of all ui elements
	var/client/_observer	

	var/list/storageData = list()					

/datum/interface/New(var/client/observer)
	if(!observer || !istype(observer))
		error("Passed incorrect observer to interface.")
		qdel(src)
		return
	_observer = observer

	buildUI()
	validate()
	
	. = ..()

/datum/interface/Destroy()
	hide()
	QDEL_NULL_LIST(_elements)
	. = ..()

/datum/interface/proc/buildUI()
	return TRUE

/datum/interface/proc/postBuildUI()
	for(var/HUD_element/E in _elements)
		E.alpha = _observer.prefs.UI_style_alpha

	// #####	ADDING HIGHLIGTING FOR BUTTONS    #####
	for(var/HUD_element/button/E in _elements)
		var/list/iconData = E.getIconAdditionData(HUD_ICON_UNDERLAY, HUD_UNDERLAY_BACKGROUND)
		iconData["color"] = _observer.prefs.UI_style_color
		iconData["alpha"] = 80
		iconData["is_plain"] = TRUE
		
		E.setHoveredInteraction(TRUE, iconData)
		E.setClickedInteraction(TRUE, iconData, 2)
		

/datum/interface/proc/getElementByID(var/id)
	RETURN_TYPE(/HUD_element)
	for(var/HUD_element/element in _elements)
		if(element.getIdentifier() == id)
			return element
	error("No element found with id \"[id]\".")

/datum/interface/proc/hide(var/id)
	if (!id)
		for(var/HUD_element/element in _elements)
			element.hide()
	else
		var/HUD_element/E = getElementByID(id)
		if(E)
			E.hide()
		else
			error("No element with id \"[id]\" found.")

/datum/interface/proc/show(var/id)
	if(!_observer)
		error("Interface has no observer.")
		return FALSE
	if (!id)
		for(var/HUD_element/element in _elements)
			element.show(_observer)
	else
		var/HUD_element/E = getElementByID(id)
		if(E)
			E.show()
		else
			error("No element with id \"[id]\" found.")
	return TRUE

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

/datum/interface/proc/newUIElement(var/name, var/ui_type, var/iconData, var/x = 0, var/y = 0, var/list/icon_overlays, var/list/icon_underlays, var/data)
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
	if(iconData)
		if(istype(iconData, /list))
			var/list/D = iconData
			if(is_associative(D))
				element.setIconFromDMI(D["icon"],D["icon_state"],D["dir"])
			else
				error("(not associative) IconData have to be associative list containing icon info for loading from DMI or path to resource file.")
		else if(istext(iconData))
			element.setIcon(iconData)
		else
			error("UI element has incorrect IconData.")
		
	element.setPosition(x,y)

	if(icon_overlays)
		element.setIconAdditionsData(HUD_ICON_OVERLAY, icon_overlays)
	if(icon_underlays)
		element.setIconAdditionsData(HUD_ICON_OVERLAY, icon_underlays)
	if(data)
		element.setData(data)

	_elements += element

	return element

/datum/interface/proc/addUIElement(var/HUD_element/element)
	if(!element)
		error("Passed null element")
		return
	_elements += element

//	ENSURING THAT UI IS CREATED PROPERLY
/datum/interface/proc/validate()
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
		error("UI style \"[styleName]\" for mob \"[mobtype]\" is created incorrectly, see errors above.")
		return FALSE
	return TRUE

/datum/interface/proc/toggleDebugMode()
	for(var/HUD_element/E in _elements)
		E.toggleDebugMode()

/hook/startup/proc/generateUIStyles()
	for(var/UI_type in typesof(/datum/interface) - /datum/interface)
		var/datum/interface/UI = UI_type
		if(!GLOB.ui_styles[initial(UI.mobtype)])
			GLOB.ui_styles[initial(UI.mobtype)] = list()
		GLOB.ui_styles[initial(UI.mobtype)] += UI_type
	return TRUE