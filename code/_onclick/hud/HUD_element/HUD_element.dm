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

	var/_scaleWidth = 1 //mutliplier of iconWidth
	var/_scaleHeight = 1

	var/_relativePositionX = 0 //in pixels, relative to parent
	var/_relativePositionY = 0

	var/_absolutePositionX = 0 //in pixels, actual map view coordinates
	var/_absolutePositionY = 0

	var/_iconWidth = 0 //in pixels
	var/_iconHeight = 0

/HUD_element/New(var/identifier)
	_elements = new
	_identifier = identifier
	updateIconInformation()

/HUD_element/Destroy()
	hide()

	var/list/HUD_element/elements = getElements()
	for(var/HUD_element/E in elements)
		qdel(E)
	elements.Cut()

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
		if (_iconWidth || _iconHeight)
			_iconWidth = 0
			_iconHeight = 0
			_updatePosition()
		return

	var/icon/I = new(fcopy_rsc(icon),icon_state,dir)
	var/newIconWidth = I.Width()
	var/newIconHeight = I.Height()
	if ((newIconWidth == _iconWidth) && (newIconHeight == _iconHeight))
		return

	_iconWidth = newIconWidth
	_iconHeight = newIconHeight
	_updatePosition()

	return src

/HUD_element/proc/resize(width,height) //in pixels
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

	var/list/bounds = new(result_x1,result_y1,result_x2,result_y2)

	return bounds

/HUD_element/proc/getWidth()
	return getIconWidth()

/HUD_element/proc/getHeight()
	return getIconHeight()

/HUD_element/proc/getIconWidth()
	return _iconWidth*_scaleWidth

/HUD_element/proc/getIconHeight()
	return _iconHeight*_scaleHeight

/HUD_element/proc/setIcon(var/icon/I)
	icon = I
	updateIconInformation()

	return src

/HUD_element/proc/_updatePosition()
	var/realX = _relativePositionX
	var/realY = _relativePositionY

	var/HUD_element/parent = getParent()
	if (parent)
		realX += parent._absolutePositionX
		realY += parent._absolutePositionY

	_absolutePositionX = realX
	_absolutePositionY = realY

	screen_loc = "[_screenBottomLeftX]:[realX],[_screenBottomLeftY]:[realY]"

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


