/client
	var/list/HUD_elements

/HUD_element
	parent_type = /atom/movable

	layer = HUD_LAYER
	plane = HUD_PLANE
	//mouse_opacity = 2

	var/list/HUD_element/_elements //child elements
	var/HUD_element/_parent //parent element
	var/client/_observer //each element is shown to at most 1 client
	var/_identifier //unique identitifier for this element, if such element is already seen by a client, it is closed first

	var/_screenBottomLeftX = 1 //in tiles
	var/_screenBottomLeftY = 1

	var/_scaleWidth = 1 //mutliplier of width
	var/_scaleHeight = 1

	var/_relativePositionX = 0 //in pixels, relative to parent
	var/_relativePositionY = 0

	var/_absolutePositionX = 0 //in pixels, actual map view coordinates
	var/_absolutePositionY = 0

	var/_iconWidth = 0 //in pixels
	var/_iconHeight = 0

	var/_width = 0 //in pixels
	var/_height = 0

	var/_currentAlignmentVertical = 0 //alignment within parent element
	var/_currentAlignmentHorizontal = 0

	var/_alignmentOffsetX = 0 //in pixels
	var/_alignmentOffsetY = 0

	var/_hideParentOnClick = FALSE
	var/_deleteOnHide = FALSE
	var/_hideParentOnHide = FALSE
	var/_passClickToParent = FALSE

	var/proc/_clickProc //called when element is clicked
	var/list/_data //internal storage that can be utilized by _clickProc

/HUD_element/proc/setClickProc(var/proc/P)
	_clickProc = P

/HUD_element/proc/getClickProc()
	return _clickProc

/HUD_element/proc/setHideParentOnClick(var/value)
	_hideParentOnClick = value

/HUD_element/proc/getHideParentOnClick()
	return _hideParentOnClick

/HUD_element/proc/setDeleteOnHide(var/value)
	_deleteOnHide = value

/HUD_element/proc/getDeleteOnHide()
	return _deleteOnHide

/HUD_element/proc/setHideParentOnHide(var/value)
	_hideParentOnHide = value

/HUD_element/proc/getHideParentOnHide()
	return _hideParentOnHide

/HUD_element/proc/setPassClickToParent(var/value)
	_passClickToParent = value

/HUD_element/proc/getPassClickToParent()
	return _passClickToParent

/HUD_element/New(var/identifier)
	_elements = new
	_identifier = identifier
	updateIconInformation()

/HUD_element/Destroy()
	hide()

	if (_data)
		_data.Cut()

	vis_contents.Cut()

	var/list/HUD_element/elements = getElements()
	for(var/HUD_element/E in elements)
		elements -= E
		if (!QDELETED(E))
			qdel(E)

	var/HUD_element/parent = getParent()
	if (parent)
		parent.getElements().Remove(src)
		_setParent()

	return QDEL_HINT_QUEUE

/HUD_element/proc/add(var/HUD_element/newElement)
	newElement = newElement || new
	_connectElement(newElement)

	return newElement

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

/HUD_element/proc/scaleToSize(var/width,var/height) //in pixels
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
	_width = width
	_height = height

	_updatePosition()

/HUD_element/proc/setWidth(var/width)
	_width = width

	_updatePosition()

/HUD_element/proc/setHeight(var/height)
	_height = height

	_updatePosition()

/HUD_element/proc/getWidth()
	return max(getIconWidth(), _width)*_scaleWidth

/HUD_element/proc/getHeight()
	return max(getIconHeight(), _height)*_scaleHeight

/HUD_element/proc/getIconWidth()
	return _iconWidth

/HUD_element/proc/getIconHeight()
	return _iconHeight

/HUD_element/proc/setIcon(var/icon/I)
	icon = I
	updateIconInformation()

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

/HUD_element/proc/setPosition(var/x,var/y) //in pixels
	_relativePositionX = round(x)
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

/HUD_element/proc/getIdentifier()
	return _identifier

/HUD_element/proc/getObserver()
	return _observer

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

/HUD_element/proc/getElements()
	return _elements

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

/HUD_element/proc/getParent()
	return _parent

/HUD_element/proc/_setParent(var/HUD_element/E)
	_parent = E

	return src

/HUD_element/proc/mimicAtomIcon(var/atom/A)
	icon = A.icon
	icon_state = A.icon_state
	dir = A.dir
	color = A.color
	alpha = A.alpha
	overlays = A.overlays
	underlays = A.underlays

	updateIconInformation()

	return src

/HUD_element/proc/setName(var/new_name, var/nameAllElements = FALSE)
	name = new_name
	if (nameAllElements)
		var/list/HUD_element/elements = getElements()
		for(var/HUD_element/E in elements)
			E.setName(new_name, TRUE)

/HUD_element/Click(location,control,params)
	if (_clickProc)
		call(_clickProc)(src, usr, location, control, params)

	if (_passClickToParent)
		var/HUD_element/parent = getParent()
		if (parent)
			parent = parent.Click(location, control, params)
			if (!parent) //parent deleted
				return

	if (_hideParentOnClick)
		var/HUD_element/parent = getParent()
		if (parent)
			parent = parent.hide()
			if (!parent) //parent deleted
				return

/HUD_element/proc/getData(var/indexString)
	if (_data)
		return _data[indexString]

/HUD_element/proc/setData(var/indexString, var/value)
	_data = _data || new
	_data[indexString] = value