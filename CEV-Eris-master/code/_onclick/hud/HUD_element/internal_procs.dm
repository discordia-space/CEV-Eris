/*
all vars and procs starting with _ are meant to be used only internally
see external_procs.dm for usable procs and documentation on how to use them
*/

/HUD_element/proc/_recalculateAlignmentOffset()
	/*
	- look HUD_defines.dm for arguments

	- in order to calculate screen width and height we use client.view which represents radius of screen
	- we calculate size in pixels using (2 * (_observer ? _observer.view : 7) + 1) * 32
	*/
	var/HUD_element/parent = getParent()
	switch (_currentAlignmentHorizontal)
		if (HUD_NO_ALIGNMENT)
			_alignmentOffsetX = 0
		if (HUD_HORIZONTAL_WEST_OUTSIDE_ALIGNMENT)
			if (!parent)
				error("Trying to align outside of the screen.")
			else
				_alignmentOffsetX = -getWidth()
		if (HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT)
			if (!parent)
				_alignmentOffsetX = _absolutePositionX * -1
			else
				_alignmentOffsetX = 0
		if (HUD_CENTER_ALIGNMENT)
			if (parent)
				_alignmentOffsetX = parent.getWidth()/2 - getWidth()/2
			else if (!parent)
				_alignmentOffsetX = ((2 * (_observer ? _observer.view : 7) + 1) * 32)/2 - (getWidth()/2)
		if (HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT)
			if (parent)
				_alignmentOffsetX = parent.getWidth() - getWidth()
			else if (!parent)
				_alignmentOffsetX = (2 * (_observer ? _observer.view : 7) + 1) * 32 - _absolutePositionX - getWidth()
		if (HUD_HORIZONTAL_EAST_OUTSIDE_ALIGNMENT)
			if (!parent)
				error("Trying to align outside of the screen.")
			else if (parent)
				_alignmentOffsetX = parent.getWidth()
		else
			if(_currentAlignmentHorizontal)
				error("Passed wrong argument for horizontal alignment.")
				_alignmentOffsetX = 0

	switch (_currentAlignmentVertical)
		if (HUD_NO_ALIGNMENT)
			_alignmentOffsetY = 0
		if (HUD_VERTICAL_SOUTH_OUTSIDE_ALIGNMENT)
			if (!parent)
				error("Trying to align outside of the screen.")
			_alignmentOffsetY = -getHeight()
		if (HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
			if (!parent)
				_alignmentOffsetY = _absolutePositionY * -1
			else
				_alignmentOffsetY = 0
		if (HUD_CENTER_ALIGNMENT)
			if (parent)
				_alignmentOffsetY = parent.getHeight()/2 - getHeight()/2
			else if (!parent)
				_alignmentOffsetY = ((2 * (_observer ? _observer.view : 7) + 1) * 32)/2 - (getHeight()/2)
		if (HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT)
			if (parent)
				_alignmentOffsetY = parent.getHeight() - getHeight()
			else if (!parent)
				_alignmentOffsetY = (2 * (_observer ? _observer.view : 7) + 1) * 32 - _absolutePositionY - getHeight()
		if (HUD_VERTICAL_NORTH_OUTSIDE_ALIGNMENT)
			if (!parent)
				error("Trying to align outside of the screen.")
			else if (parent)
				_alignmentOffsetY = parent.getHeight()
		else
			if(_currentAlignmentVertical)
				error("Passed wrong argument for vertical alignment.")
				_alignmentOffsetY = 0

/HUD_element/proc/_updatePosition()
	var/realX = _relativePositionX
	var/realY = _relativePositionY

	var/HUD_element/parent = getParent()
	if (parent)
		realX += parent._absolutePositionX
		realY += parent._absolutePositionY

	_recalculateAlignmentOffset()
	realX += _alignmentOffsetX
	realY += _alignmentOffsetY

	_absolutePositionX = realX
	_absolutePositionY = realY

	screen_loc = "[_screenBottomLeftX]:[round(realX)],[_screenBottomLeftY]:[round(realY)]"

	var/list/HUD_element/elements = getElements()
	for(var/HUD_element/E in elements)
		E._updatePosition()

	return src

/HUD_element/proc/_getObserverHUD()
	var/client/observer = getObserver()
	if (!observer)
		var/identifier = getIdentifier()
		log_to_dd("Error: HUD element with identifier '[identifier]' has no observer")
		return

	if (!observer.HUD_elements)
		observer.HUD_elements = new

	return observer.HUD_elements

/HUD_element/proc/_setObserver(var/client/C)
	_observer = C

	return src

/HUD_element/proc/_connectElement(var/HUD_element/E)
	if (!E)
		log_to_dd("Error: Invalid HUD element '[E]'")
		return

	var/list/HUD_element/elements = getElements()
	if (elements.Find(E))
		log_to_dd("Error: HUD element '[E]' already connected")
		return

	var/HUD_element/parent = E.getParent()
	if (parent)
		var/list/HUD_element/elementRemove = parent.getElements()
		elementRemove.Remove(E)

	E._setParent(src)
	elements.Add(E)

	return src

/HUD_element/proc/_disconnectElement(var/HUD_element/E)
	if (!E)
		log_to_dd("Error: Invalid HUD element '[E]'")
		return

	var/list/HUD_element/elements = getElements()
	if (elements.Find(E))
		elements.Remove(E)

	E._unsetParent()
	
	return src

/HUD_element/proc/_setParent(var/HUD_element/E)
	_parent = E

	return src

/HUD_element/proc/_unsetParent()
	_parent = null

	return src

/HUD_element/proc/_addAdditionIcon(var/additionType, var/additionName)
	if(!_iconsBuffer["[additionType]_[additionName]"])
		if(getIconAdditionData(additionType, additionName))
			error("Icon for [additionType]_[additionName] is not buffered.")
			return
	if(additionType == HUD_ICON_UNDERLAY)
		underlays += _iconsBuffer["[additionType]_[additionName]"]
	else if(additionType == HUD_ICON_OVERLAY)
		overlays += _iconsBuffer["[additionType]_[additionName]"]

/HUD_element/proc/_assembleAndBufferIcon(var/additionType, var/additionName, var/list/data)
	if(!data)
		error("Nothing was passed to buffer")
		return
	//TODO: make so this can also work with non dmi files (png, gif)
	var/icon/I = new(data["icon"], data["icon_state"], data["dir"])
	if(I)
		if(data["is_plain"])
			I.PlainPaint(data["color"])
		else if(data["color"])
			I.ColorTone(data["color"])
		if(data["alpha"])
			I.ChangeOpacity(data["alpha"]/255)

		_iconsBuffer["[additionType]_[additionName]"] = I
		return I
	return null

/HUD_element/proc/_updateLayers()
	overlays.Cut()
	underlays.Cut()

	if(!debugMode)
		for(var/name in _iconUnderlaysData)
			_addAdditionIcon(HUD_ICON_UNDERLAY, name)
		for(var/name in _iconOverlaysData)
			if(name == HUD_OVERLAY_TOGGLED || name == HUD_OVERLAY_HOVERED || name == HUD_OVERLAY_CLICKED)
				continue
			_addAdditionIcon(HUD_ICON_OVERLAY, name)

		if(_onToggledInteraction)
			_addAdditionIcon(HUD_ICON_OVERLAY, HUD_OVERLAY_TOGGLED)
		if(_onHoveredState)
			_addAdditionIcon(HUD_ICON_OVERLAY, HUD_OVERLAY_HOVERED)
		if(_onClickedState)
			_addAdditionIcon(HUD_ICON_OVERLAY, HUD_OVERLAY_CLICKED)

/HUD_element/button/MouseEntered(location)
	if(_onHoveredInteraction && !_onHoveredState)
		_onHoveredState = TRUE
		updateIcon()
	return ..()

/HUD_element/button/MouseExited(object,location,control,params)
	if(_onHoveredInteraction)
		_onHoveredState = FALSE
		updateIcon()
	return ..()

/HUD_element/button/Click(location,control,params)
	if(_onClickedInteraction && !_onClickedState)
		_onClickedState = TRUE
		updateIcon()
		spawn(_onClickedHighlightDuration)
			_onClickedState = FALSE
			updateIcon()

	if(_onToggledInteraction)
		_onToggledState = !_onToggledState
		updateIcon()

	return ..()