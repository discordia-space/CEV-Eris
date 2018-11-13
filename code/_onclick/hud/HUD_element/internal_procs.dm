/*
all vars and procs starting with _ are meant to be used only internally
see external_procs.dm for usable procs and documentation on how to use them
*/

/HUD_element/proc/_recalculateAlignmentOffset()
	/*
	horizontal/vertical alignment values:
	0 == no alignment
	1 == bordering west/south side of parent from outside
	2 == bordering west/south side of parent from inside
	3 == center of parent
	4 == bordering east/north side of parent from inside
	5 == bordering east/north side of parent from outside
	*/

	//todo: no parent means align relative to screen/view
	var/HUD_element/parent = getParent()
	switch (_currentAlignmentHorizontal)
		if (0)
			_alignmentOffsetX = 0
		if (1)
			_alignmentOffsetX = -getWidth()
		if (2)
			_alignmentOffsetX = 0
		if (3)
			if (parent)
				_alignmentOffsetX = parent.getWidth()/2 - getWidth()/2
		if (4)
			if (parent)
				_alignmentOffsetX = parent.getWidth() - getWidth()
		if (5)
			if (parent)
				_alignmentOffsetX = parent.getWidth()
		else
			_alignmentOffsetX = 0

	switch (_currentAlignmentVertical)
		if (0)
			_alignmentOffsetY = 0
		if (1)
			_alignmentOffsetY = -getHeight()
		if (2)
			_alignmentOffsetY = 0
		if (3)
			if (parent)
				_alignmentOffsetY = parent.getHeight()/2 - getHeight()/2
		if (4)
			if (parent)
				_alignmentOffsetY = parent.getHeight() - getHeight()
		if (5)
			if (parent)
				_alignmentOffsetY = parent.getHeight()
		else
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

/HUD_element/proc/_setParent(var/HUD_element/E)
	_parent = E

	return src
