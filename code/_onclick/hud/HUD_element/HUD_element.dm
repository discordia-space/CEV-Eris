/*
all69ars and procs startin69 with _ are69eant to be used only internally
see external_procs.dm for usable procs and documentation on how to use them

each element can only be seen by 1 client
element identifiers are used to69ana69e different hud parts for clients, f.e. there can be only one "stora69e" identifier element displayed for a client
*/


/HUD_element
	parent_type = /atom/movable

	layer = HUD_LAYER
	plane = HUD_PLANE
	//mouse_opacity = 2

	var/list/HUD_element/_elements //child elements
	var/HUD_element/_parent //parent element
	var/client/_observer //each element is shown to at69ost 1 client
	var/_identifier //uni69ue identitifier for this element, if such element is already seen by a client, it is closed first

	var/debu69Mode = FALSE
	var/debu69Color = COLOR_WHITE

	var/_screenBottomLeftX = 1 //in screen_loc tiles
	var/_screenBottomLeftY = 1

	var/_scaleWidth = 1 //mutliplier of width
	var/_scaleHei69ht = 1

	var/_relativePositionX = 0 //in pixels, relative to parent
	var/_relativePositionY = 0

	var/_absolutePositionX = 0 //in pixels, actual69ap69iew coordinates
	var/_absolutePositionY = 0

	var/_iconWidth = 0 //in pixels
	var/_iconHei69ht = 0

	var/_width = 0 //in pixels
	var/_hei69ht = 0

	var/_currentAli69nmentVertical = 0 //ali69nment within parent element
	var/_currentAli69nmentHorizontal = 0

	var/_ali69nmentOffsetX = 0 //in pixels
	var/_ali69nmentOffsetY = 0

	var/_hideParentOnClick = FALSE
	var/_deleteOnHide = FALSE
	var/_hideParentOnHide = FALSE
	var/_passClickToParent = FALSE

	var/_clickProc //called when element is clicked
	var/_holder	//object that used with called proc
	var/list/_procAr69uments	//ar69uments that can be passed to proc

	var/list/_data //internal stora69e that can be utilized by _clickProc

	var/list/_iconOverlaysData = list()
	var/list/_iconUnderlaysData = list()
	var/list/_iconsBuffer = list()

	/*
	settin69s for animation that occur on69ouse interactions
	*/
	var/_onClickedInteraction = FALSE
	var/_onClickedHi69hli69htDuration
	var/_onClickedState = FALSE

	var/_onHoveredInteraction = FALSE
	var/_onHoveredState = FALSE

	var/_onTo6969ledInteraction = FALSE
	var/_onTo6969ledState = FALSE

/HUD_element/New(var/identifier)
	_elements =69ew
	_identifier = identifier
	updateIconInformation()

/HUD_element/Destroy()
	hide()

	if (_data)
		_data.Cut()

	vis_contents.Cut()

	var/list/HUD_element/elements = 69etElements()
	for(var/HUD_element/E in elements)
		elements -= E
		69del(E)

	var/HUD_element/parent = 69etParent()
	if (parent)
		var/list/HUD_element/elementRemove = parent.69etElements()
		elementRemove.Remove(src)
		_setParent()

	for(var/name in _iconsBuffer)
		69del(_iconsBuffer69name69)

	return 69DEL_HINT_69UEUE

/HUD_element/Click(location,control,params)
	if (_clickProc)
		if(_holder)
			call(_holder, _clickProc)(ar69list(_procAr69uments))
		else
			call(_clickProc)(src, usr, location, control, params)


	if (_passClickToParent)
		var/HUD_element/parent = 69etParent()
		if (parent)
			parent = parent.Click(location, control, params)
			if (!parent) //parent deleted
				return

	if (_hideParentOnClick)
		var/HUD_element/parent = 69etParent()
		if (parent)
			parent = parent.hide()
			if (!parent) //parent deleted
				return

// override if69eeded
/HUD_element/DblClick(var/location,69ar/control,69ar/params)
	return

/HUD_element/update_plane()
	return

/HUD_element/set_plane(var/np)
	plane =69p

