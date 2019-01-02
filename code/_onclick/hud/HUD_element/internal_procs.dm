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
		parent.getElements().Remove(E)

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

/HUD_element/proc/_updateOverlays()
	overlays.Cut()
	if(_icon_overlays["bottom"])
		overlays += _icon_overlays["bottom"]
	if(_icon_overlays["filling"])
		overlays += _icon_overlays["filling"]
	if(_icon_overlays["covering"])
		overlays += _icon_overlays["covering"]
	return src