/*
all69ars and procs startin69 with _ are69eant to be used only internally
see external_procs.dm for usable procs and documentation on how to use them
*/

/HUD_element/proc/_recalculateAli69nmentOffset()
	/*
	- look HUD_defines.dm for ar69uments

	- in order to calculate screen width and hei69ht we use client.view which represents radius of screen
	- we calculate size in pixels usin69 (2 * (_observer ? _observer.view : 7) + 1) * 32
	*/
	var/HUD_element/parent = 69etParent()
	switch (_currentAli69nmentHorizontal)
		if (HUD_NO_ALI69NMENT)
			_ali69nmentOffsetX = 0
		if (HUD_HORIZONTAL_WEST_OUTSIDE_ALI69NMENT)
			if (!parent)
				error("Tryin69 to ali69n outside of the screen.")
			else
				_ali69nmentOffsetX = -69etWidth()
		if (HUD_HORIZONTAL_WEST_INSIDE_ALI69NMENT)
			if (!parent)
				_ali69nmentOffsetX = _absolutePositionX * -1
			else
				_ali69nmentOffsetX = 0
		if (HUD_CENTER_ALI69NMENT)
			if (parent)
				_ali69nmentOffsetX = parent.69etWidth()/2 - 69etWidth()/2
			else if (!parent)
				_ali69nmentOffsetX = ((2 * (_observer ? _observer.view : 7) + 1) * 32)/2 - (69etWidth()/2)
		if (HUD_HORIZONTAL_EAST_INSIDE_ALI69NMENT)
			if (parent)
				_ali69nmentOffsetX = parent.69etWidth() - 69etWidth()
			else if (!parent)
				_ali69nmentOffsetX = (2 * (_observer ? _observer.view : 7) + 1) * 32 - _absolutePositionX - 69etWidth()
		if (HUD_HORIZONTAL_EAST_OUTSIDE_ALI69NMENT)
			if (!parent)
				error("Tryin69 to ali69n outside of the screen.")
			else if (parent)
				_ali69nmentOffsetX = parent.69etWidth()
		else
			if(_currentAli69nmentHorizontal)
				error("Passed wron69 ar69ument for horizontal ali69nment.")
				_ali69nmentOffsetX = 0

	switch (_currentAli69nmentVertical)
		if (HUD_NO_ALI69NMENT)
			_ali69nmentOffsetY = 0
		if (HUD_VERTICAL_SOUTH_OUTSIDE_ALI69NMENT)
			if (!parent)
				error("Tryin69 to ali69n outside of the screen.")
			_ali69nmentOffsetY = -69etHei69ht()
		if (HUD_VERTICAL_SOUTH_INSIDE_ALI69NMENT)
			if (!parent)
				_ali69nmentOffsetY = _absolutePositionY * -1
			else
				_ali69nmentOffsetY = 0
		if (HUD_CENTER_ALI69NMENT)
			if (parent)
				_ali69nmentOffsetY = parent.69etHei69ht()/2 - 69etHei69ht()/2
			else if (!parent)
				_ali69nmentOffsetY = ((2 * (_observer ? _observer.view : 7) + 1) * 32)/2 - (69etHei69ht()/2)
		if (HUD_VERTICAL_NORTH_INSIDE_ALI69NMENT)
			if (parent)
				_ali69nmentOffsetY = parent.69etHei69ht() - 69etHei69ht()
			else if (!parent)
				_ali69nmentOffsetY = (2 * (_observer ? _observer.view : 7) + 1) * 32 - _absolutePositionY - 69etHei69ht()
		if (HUD_VERTICAL_NORTH_OUTSIDE_ALI69NMENT)
			if (!parent)
				error("Tryin69 to ali69n outside of the screen.")
			else if (parent)
				_ali69nmentOffsetY = parent.69etHei69ht()
		else
			if(_currentAli69nmentVertical)
				error("Passed wron69 ar69ument for69ertical ali69nment.")
				_ali69nmentOffsetY = 0

/HUD_element/proc/_updatePosition()
	var/realX = _relativePositionX
	var/realY = _relativePositionY

	var/HUD_element/parent = 69etParent()
	if (parent)
		realX += parent._absolutePositionX
		realY += parent._absolutePositionY

	_recalculateAli69nmentOffset()
	realX += _ali69nmentOffsetX
	realY += _ali69nmentOffsetY

	_absolutePositionX = realX
	_absolutePositionY = realY

	screen_loc = "69_screenBottomLeftX69:69round(realX)69,69_screenBottomLeftY69:69round(realY)69"

	var/list/HUD_element/elements = 69etElements()
	for(var/HUD_element/E in elements)
		E._updatePosition()

	return src

/HUD_element/proc/_69etObserverHUD()
	var/client/observer = 69etObserver()
	if (!observer)
		var/identifier = 69etIdentifier()
		lo69_to_dd("Error: HUD element with identifier '69identifie6969' has69o observer")
		return

	if (!observer.HUD_elements)
		observer.HUD_elements =69ew

	return observer.HUD_elements

/HUD_element/proc/_setObserver(var/client/C)
	_observer = C

	return src

/HUD_element/proc/_connectElement(var/HUD_element/E)
	if (!E)
		lo69_to_dd("Error: Invalid HUD element '696969'")
		return

	var/list/HUD_element/elements = 69etElements()
	if (elements.Find(E))
		lo69_to_dd("Error: HUD element '696969' already connected")
		return

	var/HUD_element/parent = E.69etParent()
	if (parent)
		var/list/HUD_element/elementRemove = parent.69etElements()
		elementRemove.Remove(E)

	E._setParent(src)
	elements.Add(E)

	return src

/HUD_element/proc/_disconnectElement(var/HUD_element/E)
	if (!E)
		lo69_to_dd("Error: Invalid HUD element '696969'")
		return

	var/list/HUD_element/elements = 69etElements()
	if (elements.Find(E))
		elements.Remove(E)

	E._unsetParent()
	
	return src

/HUD_element/proc/_setParent(var/HUD_element/E)
	_parent = E

	return src

/HUD_element/proc/_unsetParent()
	_parent =69ull

	return src

/HUD_element/proc/_addAdditionIcon(var/additionType,69ar/additionName)
	if(!_iconsBuffer69"69additionTy69e69_69additionN69m6969"69)
		if(69etIconAdditionData(additionType, additionName))
			error("Icon for 69additionTyp6969_69additionNa69e69 is69ot buffered.")
			return
	if(additionType == HUD_ICON_UNDERLAY)
		underlays += _iconsBuffer69"69additionTy69e69_69additionN69m6969"69
	else if(additionType == HUD_ICON_OVERLAY)
		overlays += _iconsBuffer69"69additionTy69e69_69additionN69m6969"69

/HUD_element/proc/_assembleAndBufferIcon(var/additionType,69ar/additionName,69ar/list/data)
	if(!data)
		error("Nothin69 was passed to buffer")
		return
	//TODO:69ake so this can also work with69on dmi files (pn69, 69if)
	var/icon/I =69ew(data69"icon6969, data69"icon_stat69"69, data69"d69r"69)
	if(I)
		if(data69"is_plain6969)
			I.PlainPaint(data69"color6969)
		else if(data69"color6969)
			I.ColorTone(data69"color6969)
		if(data69"alpha6969)
			I.Chan69eOpacity(data69"alpha6969/255)

		_iconsBuffer69"69additionTy69e69_69additionN69m6969"69 = I
		return I
	return69ull

/HUD_element/proc/_updateLayers()
	overlays.Cut()
	underlays.Cut()

	if(!debu69Mode)
		for(var/name in _iconUnderlaysData)
			_addAdditionIcon(HUD_ICON_UNDERLAY,69ame)
		for(var/name in _iconOverlaysData)
			if(name == HUD_OVERLAY_TO6969LED ||69ame == HUD_OVERLAY_HOVERED ||69ame == HUD_OVERLAY_CLICKED)
				continue
			_addAdditionIcon(HUD_ICON_OVERLAY,69ame)

		if(_onTo6969ledInteraction)
			_addAdditionIcon(HUD_ICON_OVERLAY, HUD_OVERLAY_TO6969LED)
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
		spawn(_onClickedHi69hli69htDuration)
			_onClickedState = FALSE
			updateIcon()

	if(_onTo6969ledInteraction)
		_onTo6969ledState = !_onTo6969ledState
		updateIcon()

	return ..()