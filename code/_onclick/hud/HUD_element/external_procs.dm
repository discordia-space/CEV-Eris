/*
add(var/HUD_element/newElement) -> /HUD_element/newElement
- adds child element into parent element, element position is relative to parent

remove(var/HUD_element/element) -> /HUD_element/element
- removes child and usets childs parent

getClickProc() -> /proc/clickProc
setClickProc(var/proc/P) -> src
- sets a proc that will be called when element is clicked, in byond proc Click()

getHideParentOnClick() -> boolean
setHideParentOnClick(var/boolean) -> src
- sets whether element will call hide() on parent after being clicked

getDeleteOnHide() -> boolean
setDeleteOnHide(var/boolean) -> src
- sets whether element will delete itself when hide() is called on this element

getHideParentOnHide() -> boolean
setHideParentOnHide(var/boolean) -> src
- sets whether element will call hide() on parent when hide() is called on this element

getPassClickToParent() -> boolean
setPassClickToParent(var/boolean) -> src
- sets whether element passes Click() events to parent

scaleToSize(var/width, var/height) -> src
- scales element to desired width and height, argument values are in pixels
- null width or height indicate not to change the relevant scaling

getRectangle() -> /list/bounds
- gets bottom-left and top-right corners of a rectangle in which the element and all child elements reside, relative to element itself

setHeight(var/height) -> src
setWidth(var/width) -> src
setDimensions(var/width, var/height) -> src
- sets artificial width/height of an element, relevant only if icon is smaller than set values, argument values are in pixels

getWidth() -> width
getHeight() -> height
- gets the actual width/height of an element, after scaling, return values are in pixels

setIcon(var/icon/I) -> src
- sets element icon

mimicAtomIcon(var/atom/A) -> src
- takes on byond icon related vars from any atom

getIconWidth() -> width
getIconHeight() -> height
- gets icon width/height without scaling, return values are in pixels
- note that all icons in a .dmi share the same width/height
- it is recommended to use separate image files for each non-standard sized image to fully utilize automatic functions from this framework

updateIconInformation() -> src
- if you for some reason have to manually set byond icon vars for an element, call this after you're done to update the element
- automatically called by procs changing icon and in New()

getAlignmentVertical() -> alignmentVertical
getAlignmentHorizontal() -> alignmentHorizontal
setAlignment(var/horizontal, var/vertical) -> src
- sets alignment behavior for element, relative to parent, null arguments indicate not to change the relevant alignment
- look HUD_defines.dm for arguments


getPositionX() -> x
getPositionY() -> y
getPosition() -> list(x,y)
setPosition(var/x, var/y) -> src
- sets position of the element relative to parent, argument values are in pixels, null indicates no change
- values are in pixels, arguments are rounded

getAbsolutePositionX() -> x
getAbsolutePositionY() -> y
- gets element position on client view screen map, values are in pixels

getElements() -> /list/HUD_element
- gets list of child elements

getParent() -> /HUD_element
- gets parent element

setName(var/new_name, var/nameAllElements = FALSE)
- sets byond name var for element, option for recursive naming of all child elements, useful only for debug

getData(var/indexString) -> value
- gets stored data, indexString must be a valid list association index

setData(var/indexString, var/value) -> src
- stores value into element data storage list, indexString must be a valid list association index

getIdentifier() -> identifier
- gets element identifier, each client can have only 1 element shown for each unique identifier
- identifier must be a valid list association index

getObserver() -> /client
- gets client that currently sees the element, element can be seen by only 1 client at a time

show(var/client/C) -> src
- shows element to client

hide() -> src || null
- hides element from client
- returns null if element deleted itself

setIconOverlays(var/icon/iconOverlays)
- sets icon overlays
- overlays must be named list
- accepts only associative list
-	for overlay names see HUD_defines

updateIcon()
- Updates icon using overlays

getIconOverlays() -> _iconOverlays
- gets icon overlays

getChildElementWithID(var/id) -> /HUD_element || null
- return child element with identifier id or null if none

moveChildOnTop(var/id) -> /HUD_element || null
- return moved element with identifier id or null if none

moveChildToBottom(var/id) -> /HUD_element || null
- return moved element with identifier id or null if none

alignElements(var/horizontal, var/vertical, var/list/HUD_element/targets) -> /HUD_element || null
- return src if aligned atleast one objects from targets


*/


/HUD_element/proc/add(var/HUD_element/newElement)
	RETURN_TYPE(/HUD_element)
	newElement = newElement || new
	_connectElement(newElement)

	return newElement

/HUD_element/proc/remove(var/HUD_element/element)
	if(_disconnectElement(element))
		return element

/HUD_element/proc/setClickProc(P, var/holder, var/list/arguments)
	_clickProc = P
	_holder = holder
	_procArguments = arguments
	return src

/HUD_element/proc/getClickProc()
	return _clickProc

/HUD_element/proc/setHideParentOnClick(var/value)
	_hideParentOnClick = value

	return src

/HUD_element/proc/getHideParentOnClick()
	return _hideParentOnClick


/HUD_element/proc/setDeleteOnHide(var/value)
	_deleteOnHide = value

	return src

/HUD_element/proc/getDeleteOnHide()
	return _deleteOnHide


/HUD_element/proc/setHideParentOnHide(var/value)
	_hideParentOnHide = value

	return src

/HUD_element/proc/getHideParentOnHide()
	return _hideParentOnHide


/HUD_element/proc/setPassClickToParent(var/value)
	_passClickToParent = value

	return src

/HUD_element/proc/getPassClickToParent()
	return _passClickToParent


/HUD_element/proc/scaleToSize(var/width, var/height) //in pixels
	var/matrix/M = matrix()
	if (width != null)
		_scaleWidth = width/_iconWidth
		M.Scale(_scaleWidth,1)
		M.Translate((_scaleWidth-1)*_iconWidth/2,0)

	if (height != null)
		_scaleHeight = height/_iconHeight
		M.Scale(1,_scaleHeight)
		M.Translate(0,(_scaleHeight-1)*_iconHeight/2)

	transform = M

	_updatePosition()

	return src

/HUD_element/proc/getRectangle()
	var/result_x1 = 0
	var/result_y1 = 0
	var/result_x2 = getWidth()
	var/result_y2 = getHeight()

	var/list/HUD_element/elements = getElements()
	for(var/HUD_element/E in elements)
		var/list/rectangle = E.getRectangle()

		var/x1 = E.getPositionX() + rectangle[1]
		var/y1 = E.getPositionY() + rectangle[2]

		if (x1 < result_x1)
			result_x1 = x1
		if (y1 < result_y1)
			result_y1 = y1

		var/x2 = x1 + rectangle[3]
		var/y2 = y1 + rectangle[4]

		if (x2 > result_x2)
			result_x2 = x2
		if (y2 > result_y2)
			result_y2 = y2

	var/list/bounds = new(result_x1, result_y1, result_x2, result_y2)

	return bounds

/HUD_element/proc/setDimensions(var/width, var/height)
	if (width != null)
		_width = width
	if (height != null)
		_height = height

	_updatePosition()

	return src

/HUD_element/proc/setWidth(var/width)
	_width = width

	_updatePosition()

	return src

/HUD_element/proc/setHeight(var/height)
	_height = height

	_updatePosition()

	return src

/HUD_element/proc/getWidth()
	return max(getIconWidth(), _width)*_scaleWidth

/HUD_element/proc/getHeight()
	return max(getIconHeight(), _height)*_scaleHeight


/HUD_element/proc/setIcon(var/icon/I)
	icon = I
	updateIconInformation()
	updateIcon()

	return src

/HUD_element/proc/setIconFromDMI(var/filename, var/iconState, var/iconDir)
	icon = filename
	icon_state = iconState
	dir = iconDir
	updateIconInformation()
	updateIcon()

	return src

/HUD_element/proc/getIconWidth()
	return _iconWidth

/HUD_element/proc/getIconHeight()
	return _iconHeight

/HUD_element/proc/mimicAtomIcon(var/atom/A)
	icon = A.icon
	icon_state = A.icon_state
	dir = A.dir
	color = A.color
	alpha = A.alpha
	overlays = A.overlays
	underlays = A.underlays

	updateIconInformation()
	updateIcon()

	return src

/HUD_element/proc/updateIconInformation()
	if (!icon)
		_iconWidth = 0
		_iconHeight = 0

		_updatePosition()

		return src

	var/icon/I = new(fcopy_rsc(icon),icon_state,dir)
	var/newIconWidth = I.Width()
	var/newIconHeight = I.Height()
	if ((newIconWidth == _iconWidth) && (newIconHeight == _iconHeight))
		return src
	_iconWidth = newIconWidth
	_iconHeight = newIconHeight

	_updatePosition()

	return src

/HUD_element/proc/setAlignment(var/horizontal, var/vertical)
	if (horizontal != null)
		_currentAlignmentHorizontal = horizontal

	if (vertical != null)
		_currentAlignmentVertical = vertical

	_updatePosition()

	return src

/HUD_element/proc/getAlignmentVertical()
	return _currentAlignmentVertical

/HUD_element/proc/getAlignmentHorizontal()
	return _currentAlignmentHorizontal


/HUD_element/proc/setPosition(var/x, var/y) //in pixels
	if (x != null)
		_relativePositionX = round(x)

	if (y != null)
		_relativePositionY = round(y)

	_updatePosition()

	return src

/HUD_element/proc/getPositionX()
	return _relativePositionX

/HUD_element/proc/getPositionY()
	return _relativePositionY

/HUD_element/proc/getPosition()
	return list(_relativePositionX,_relativePositionY)

/HUD_element/proc/getAbsolutePositionX()
	return _absolutePositionX

/HUD_element/proc/getAbsolutePositionY()
	return _absolutePositionY

/HUD_element/proc/getAbsolutePosition()
	return list(_absolutePositionX,_absolutePositionY)


/HUD_element/proc/getElements()
	return _elements

/HUD_element/proc/getParent()
	return _parent

/HUD_element/proc/setName(var/new_name, var/nameAllElements = FALSE)
	name = new_name
	if (nameAllElements)
		var/list/HUD_element/elements = getElements()
		for(var/HUD_element/E in elements)
			E.setName(new_name, TRUE)

/HUD_element/proc/getData(var/indexString)
	if (_data)
		return _data[indexString]

/HUD_element/proc/setData(var/indexString, var/value)
	_data = _data || new
	_data[indexString] = value

	return src

/HUD_element/proc/getIdentifier()
	return _identifier

/HUD_element/proc/getObserver()
	return _observer

/HUD_element/proc/show(var/client/C)
	var/client/observer = getObserver()
	if (observer)
		if (observer != C)
			log_to_dd("Error: HUD element already shown to client '[observer]'")
			return

		return src

	_setObserver(C)

	var/identifier = getIdentifier()
	if (identifier)
		var/list/observerHUD = _getObserverHUD()
		var/HUD_element/currentClientElement = observerHUD[identifier]
		if (currentClientElement)
			if (currentClientElement == src)
				return src

			qdel(currentClientElement)

		observerHUD[identifier] = src

	C.screen += src

	var/list/HUD_element/elements = getElements()
	for(var/HUD_element/E in elements)
		E.show(C)

	return src

/HUD_element/proc/hide()
	var/client/observer = getObserver()
	if (!observer)
		if (QDELETED(src))
			return
		return src

	var/identifier = getIdentifier()
	if (identifier)
		var/list/observerHUD = _getObserverHUD()
		var/HUD_element/currentClientElement = observerHUD[identifier]
		if (currentClientElement)
			if (currentClientElement == src)
				observerHUD[identifier] = null
			else
				log_to_dd("Error: HUD element identifier '[identifier]' was occupied by another element during hide()")
				return

	observer.screen -= src

	_setObserver()

	var/list/HUD_element/elements = getElements()
	for(var/HUD_element/E in elements)
		E.hide()

	if (_hideParentOnHide)
		var/HUD_element/parent = getParent()
		if (parent)
			parent = parent.hide()
			if (!parent) //parent deleted
				return

	if (_deleteOnHide && !QDELETED(src))
		qdel(src)
		return

	return src

/HUD_element/proc/setIconAdditionsData(var/additionType, var/list/additionsData)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Trying to add icon addition data without setting type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return

	if(!is_associative(additionsData))
		error("OverlayData list is not associative")
		return

	for (var/additionName in additionsData)
		var/list/data = additionsData[additionName]
		if(!is_associative(data))
			error("OverlayData list contains not associative data list with name\"[additionName]\".")
			continue
		setIconAddition(additionType, additionName, data["icon"], data["icon_state"], data["dir"], data["color"], data["alpha"], data["is_plain"])
	return src

/HUD_element/proc/setIconAddition(var/additionType, var/additionName, var/addIcon, var/addIconState, var/addDir, var/color, var/alpha, var/isPlain)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Trying to add icon addition without setting type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return
	if(!additionName)
		error("No addition name was passed")
		return

	var/list/data = getIconAdditionData(additionType, additionName)
	// if passed only overlay name and there is overlay with this name then we null delete it
	if(data && (!icon && !color && !alpha))
		data[additionName] = null
		qdel(_iconsBuffer["[additionType]_[additionName]"])
		_iconsBuffer["[additionType]_[additionName]"] = null
		updateIcon()
		return src

	if(!data)
		data = list()
		if(additionType == HUD_ICON_UNDERLAY)
			_iconUnderlaysData[additionName] = data
		else if(additionType == HUD_ICON_OVERLAY)
			_iconOverlaysData[additionName] = data

	if(addIcon)
		data["icon"] = addIcon
		data["icon_state"] = addIconState
		data["dir"] = addDir
		data["is_plain"] = isPlain
	else
		data["icon"] = null

	setIconAdditionAlpha(additionType, additionName, alpha, noIconUpdate = TRUE)
	setIconAdditionColor(additionType, additionName, color, noIconUpdate = TRUE)

	_assembleAndBufferIcon(additionType, additionName, data)
	updateIcon()

	return src

/HUD_element/proc/setIconAdditionAlpha(var/additionType, var/additionName, var/alpha, var/noIconUpdate = FALSE)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Trying to set icon addition alpha without setting type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return
	var/list/data = getIconAdditionData(additionType, additionName)
	if(!data)
		error("Can't set overlay icon alpha, no addition data.")
		return
	data["alpha"] = alpha
	if(!noIconUpdate)
		_assembleAndBufferIcon(additionType, additionName, data)
		updateIcon()
	return src

/HUD_element/proc/setIconAdditionColor(var/additionType, var/additionName, var/color, var/noIconUpdate = FALSE)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Trying to set icon addition color without setting type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return
	var/list/data = getIconAdditionData(additionType, additionName)
	if(!data)
		error("Can't set overlay icon color, no addition data.")
		return
	data["color"] = color
	if(!noIconUpdate)
		_assembleAndBufferIcon(additionType, additionName, data)
		updateIcon()
	return src

/HUD_element/proc/getIconAdditionData(var/additionType, var/additionName)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Trying to get icon addition data without setting type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return

	if(additionType == HUD_ICON_UNDERLAY)
		return _iconUnderlaysData[additionName]

	else if(additionType == HUD_ICON_OVERLAY)
		return _iconOverlaysData[additionName]

/HUD_element/proc/updateIcon()
	_updateLayers()
	return src

/HUD_element/proc/getChildElementWithID(var/id)
	for(var/HUD_element/element in getElements())
		if(element.getIdentifier() == id)
			return element
	error("No element found with id \"[id]\".")

/HUD_element/proc/moveChildOnTop(var/id)
	if(!_elements.len)
		error("Element has no child elements.")
		return
	var/HUD_element/E = getChildElementWithID(id)
	if (E)
		_elements.Remove(E)
		_elements.Insert(1,E)
		return E
	else
		error("moveChildOnTop(): No element with id \"[id]\" found.")

/HUD_element/proc/moveChildToBottom(var/id)
	if(!_elements.len)
		error("Element has no child elements.")
		return
	var/HUD_element/E = getChildElementWithID(id)
	if (E)
		_elements.Remove(E)
		_elements.Add(E)
		return E
	else
		error("moveChildToBottom(): No element with id \"[id]\" found.")

/HUD_element/proc/setClickedInteraction(var/state, var/list/iconData , var/duration = 8)
	if(!iconData || duration <= 0)
		error("incorrect button interaction setup.")
		_onClickedInteraction = FALSE
		return
	_onClickedInteraction = state
	if (state)
		_onClickedHighlightDuration = duration

		setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_CLICKED, iconData["icon"], iconData["icon_state"], color = iconData["color"], alpha = iconData["alpha"], isPlain = iconData["is_plain"])
	else
		_onClickedState = FALSE


/HUD_element/proc/setHoveredInteraction(var/state, var/list/iconData)
	if(!iconData)
		error("incorrect button interaction setup.")
		_onHoveredInteraction = FALSE
		return
	_onHoveredInteraction = state
	if (state)
		setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_HOVERED, iconData["icon"], iconData["icon_state"], color = iconData["color"], alpha = iconData["alpha"], isPlain = iconData["is_plain"])
	else
		_onHoveredState = FALSE

/HUD_element/proc/setToggledInteraction(var/state, var/list/iconData)
	if(!iconData)
		error("incorrect button interaction setup.")
		_onToggledInteraction = FALSE
		return
	_onToggledInteraction = state
	if (state)
		setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_TOGGLED, iconData["icon"], iconData["icon_state"], color = iconData["color"], alpha = iconData["alpha"], isPlain = iconData["is_plain"])
	else
		_onToggledState = FALSE

/HUD_element/proc/toggleDebugMode()
	debugMode = !debugMode
	if(debugMode)
		var/HUD_element/debugBox = new("\[debug_box\]([type])_[getIdentifier()]")
		debugBox.setName("\[debug_box\]([type])_[getIdentifier()]")
		debugBox.setIconFromDMI('icons/mob/screen/misc.dmi',"white_box")
		debugBox.setPosition(getAbsolutePositionX(), getAbsolutePositionY())
		debugBox.scaleToSize(getWidth(),getHeight())
		debugBox.setDimensions(getWidth(),getHeight())
		debugBox.color = debugColor
		debugBox.alpha = 80
		debugBox.updateIconInformation()
		_connectElement(debugBox)
		debugBox.show(_observer)
	else
		var/HUD_element/debugBox = getChildElementWithID("\[debug_box\]([type])_[getIdentifier()]")
		debugBox.hide()
		_disconnectElement(debugBox)
		qdel(debugBox)
	/*
		I.DrawBox(ReadRGB(COLOR_BLACK),0,0,getWidth(),getHeight())
		I.DrawBox(ReadRGB(debugColor),1,1,getWidth()-1,getHeight()-1)
		setIconOverlay(HUD_OVERLAY_DEBUG,I, alpha = 80)*/

	updateIcon()

// mob clicks overrides
/HUD_element/move_camera_by_click()
	return

/HUD_element/attack_ghost(mob/observer/ghost/user as mob)
	return
