/datum/interface/ghost_Eris
	mobtype = /mob/observer/ghost
	styleName = "ErisStyle"

/datum/interface/ghost_Eris/postBuildUI()
	for(var/HUD_element/button/E in _elements)
		E.setIconAdditionColor(HUD_ICON_UNDERLAY, HUD_UNDERLAY_BACKGROUND, _observer.prefs.UI_style_color)
	..()

/datum/interface/ghost_Eris/buildUI()
	// #####	CREATING LAYOUTS    #####
	//var/HUD_element/layout/horizontal/actionPanel = newUIElement("actionPanel", /HUD_element/layout/horizontal)
	var/HUD_element/layout/vertical/navigationPanel = newUIElement("navigationPanel", /HUD_element/layout/vertical)

	// #####	CREATING LIST THAT WILL CONTAIN ELEMENTS FOR EASY ACCESS    #####
	//var/list/HUD_element/actions = list()
	var/list/HUD_element/navigation = list()

	// #####	CREATING UI ELEMENTS AND ASSIGNING THEM APPROPRIATE LISTS    #####
	navigation += newUIElement("Move downwards", /HUD_element/button/thin, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi', icon_state = "down"))
	navigation += newUIElement("Move upwards", /HUD_element/button/thin, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi', icon_state = "up"))

	// #####	ADDING CLICK PROCS TO BUTTONS    #####
	getElementByID("Move upwards").setClickProc(TYPE_VERB_REF(/mob/observer/ghost,moveup), _observer.mob)
	getElementByID("Move downwards").setClickProc(TYPE_VERB_REF(/mob/observer/ghost,movedown), _observer.mob)

	// #####	ALIGNING ELEMENTS USING LAYOUTS    #####
	//actionPanel.alignElements(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_NO_ALIGNMENT, actions, 0)
	navigationPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT, navigation, 0)

	// #####	ALIGNING LAYOUTS TO SCREEN    #####
	//panels is aligned to screen because they have no parent
	//actionPanel.setAlignment(HUD_CENTER_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	navigationPanel.setAlignment(HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)

	postBuildUI()
