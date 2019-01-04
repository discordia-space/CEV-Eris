/*
	Layout object that used to align multiple UI elements

	TODO: insert elements
*/

/HUD_element/layout
	var/list/_paddingData = list()
	debugColor = COLOR_YELLOW

/HUD_element/layout/setIcon()
	return

/HUD_element/layout/scaleToSize()
	return

/HUD_element/layout/updateIconInformation()
	return

/HUD_element/layout/proc/_spreadElements()

/HUD_element/layout/proc/alignElements(var/horizontal, var/vertical, var/list/HUD_element/targets, var/padding = 0)
	if(targets && targets.len)
		for (var/list/HUD_element/T in targets)
			add(T,padding,padding)
			T.setAlignment(horizontal,vertical)
	else
		return
	return src

/HUD_element/layout/horizontal/_spreadElements()
	setWidth(0)
	for(var/HUD_element/E in _paddingData)
		var/list/data = _paddingData[E]
		setWidth(getWidth() + data["left"])
		if(E.getAlignmentHorizontal() == HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT)
			E.setPosition(-getWidth())
		else
			E.setPosition(getWidth())
		setWidth(getWidth() + E.getWidth())
		setWidth(getWidth() + data["right"])

/HUD_element/layout/vertical/_spreadElements()
	setHeight(0)
	for(var/HUD_element/E in _paddingData)
		var/list/data = _paddingData[E]
		setHeight(getHeight() + data["bottom"])
		E.setPosition(null, getWidth())
		setHeight(getHeight() + E.getHeight())
		setHeight(getHeight() + data["top"])

/HUD_element/layout/proc/setPadding()
	return FALSE

/HUD_element/layout/horizontal/setPadding(var/HUD_element/element, var/paddingLeft, var/paddingRight)
	if(!_paddingData[element])
		error("no padding data found for [element.getIdentifier()].")
		return FALSE

	if(paddingLeft)
		var/list/data = _paddingData[element]
		data["left"] = paddingLeft
	
	if(paddingRight)
		var/list/data = _paddingData[element]
		data["right"] = paddingRight
	
	_spreadElements()
	return TRUE

/HUD_element/layout/vertical/setPadding(var/HUD_element/element, var/paddingBottom, var/paddingTop)
	if(!_paddingData[element])
		error("no padding data found for [element.getIdentifier()].")
		return FALSE

	if(paddingBottom)
		var/list/data = _paddingData[element]
		data["bottom"] = paddingBottom
	
	if(paddingTop)
		var/list/data = _paddingData[element]
		data["top"] = paddingTop
	
	_spreadElements()
	return TRUE

/HUD_element/layout/horizontal/add(var/HUD_element/newElement, var/paddingLeft = 0, var/paddingRight = 0)
	_paddingData[newElement] = list("left" = paddingLeft, "right" = paddingRight)
	setHeight(max(getHeight(), newElement.getHeight()))

	_spreadElements()
	
	return ..()

/HUD_element/layout/vertical/add(var/HUD_element/newElement, var/paddingBottom = 0, var/paddingTop = 0)
	_paddingData[newElement] = list("bottom" = paddingBottom, "top" = paddingTop)
	setWidth(max(getHeight(), newElement.getHeight()))

	_spreadElements()
	
	return ..()

/HUD_element/layout/remove(var/HUD_element/element)
	. = ..()
	if(!getElements())
		setHeight(0)
		setWidth(0)
	
	if(_paddingData[element])
		_paddingData[element] = null

	_spreadElements()
	return .

/HUD_element/layout/setDimensions(var/width, var/height)
	return
/*
/HUD_element/layout/setWidth(var/width)
	return

/HUD_element/layout/setHeight(var/height)
	return
*/