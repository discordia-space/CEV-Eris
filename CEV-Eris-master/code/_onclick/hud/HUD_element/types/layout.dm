/*
	Layout object that used to align multiple UI elements

	TODO: insert elements
*/

/HUD_element/layout
	var/list/_paddingData = list()
	var/_alignment
	debugColor = COLOR_YELLOW

/HUD_element/layout/setIcon()
	return

/HUD_element/layout/scaleToSize()
	return

/HUD_element/layout/updateIconInformation()
	return

/HUD_element/layout/proc/_spreadElements()

/HUD_element/layout/proc/alignElements(var/horizontal, var/vertical, var/list/HUD_element/targets, var/padding = 0)
	return src

/HUD_element/layout/horizontal/alignElements(var/horizontal, var/vertical, var/list/HUD_element/targets, var/padding = 0)
	_alignment = horizontal
	if(targets && targets.len)
		for (var/HUD_element/T in targets)
			add(T,padding,padding)
			//we are using _aligment to align elements in alignElements()
			T.setAlignment(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT,vertical)
	else
		return
	. = ..()

/HUD_element/layout/vertical/alignElements(var/horizontal, var/vertical, var/list/HUD_element/targets, var/padding = 0)
	_alignment = vertical
	if(targets && targets.len)
		for (var/HUD_element/T in targets)
			add(T,padding,padding)
			//we are using _aligment to align elements in alignElements()
			T.setAlignment(horizontal, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	else
		return
	. = ..()

/HUD_element/layout/horizontal/_spreadElements()
	setWidth(0)

	if(!_paddingData.len)
		return

	if (_alignment == HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT)
		for(var/i = 1, i <= _paddingData.len, i++)
			var/HUD_element/E = _paddingData[i]
			var/list/data = _paddingData[E]
			setWidth(getWidth() + data["left"])
			E.setPosition(getWidth())
			setWidth(getWidth() + E.getWidth())
			setWidth(getWidth() + data["right"])

	else if (_alignment == HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT)
		for(var/i = _paddingData.len, i >= 1, i--)
			var/HUD_element/E = _paddingData[i]
			var/list/data = _paddingData[E]
			setWidth(getWidth() + data["right"])
			E.setPosition(getWidth())
			setWidth(getWidth() + E.getWidth())
			setWidth(getWidth() + data["left"])

/HUD_element/layout/vertical/_spreadElements()
	setHeight(0)

	if(!_paddingData.len)
		return

	if (_alignment == HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT)
		for(var/i = 1, i <= _paddingData.len, i++)
			var/HUD_element/E = _paddingData[i]
			var/list/data = _paddingData[E]
			setHeight(getHeight() + data["bottom"])
			E.setPosition(null, getHeight())
			setHeight(getHeight() + E.getHeight())
			setHeight(getHeight() + data["top"])

	else if (_alignment == HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
		for(var/i = _paddingData.len, i >= 1, i--)
			var/HUD_element/E = _paddingData[i]
			var/list/data = _paddingData[E]
			setHeight(getHeight() + data["top"])
			E.setPosition(null, getHeight())
			setHeight(getHeight() + E.getHeight())
			setHeight(getHeight() + data["bottom"])

/HUD_element/layout/proc/setPadding()
	return FALSE

/HUD_element/layout/horizontal/setPadding(var/HUD_element/element, var/paddingLeft, var/paddingRight)
	if(!element)
		error("No element was passed to padding setting.")
		return FALSE

	if(!(locate(element) in getElements()))
		error("Trying to set padding for element that is not connected to layout.")
		return

	var/list/data = _paddingData[element]
	if(!data)
		data = list()
		_paddingData[element] = data

	if(paddingLeft)
		data["left"] = paddingLeft
	if(paddingRight)
		data["right"] = paddingRight
	
	_spreadElements()
	return TRUE

/HUD_element/layout/vertical/setPadding(var/HUD_element/element, var/paddingBottom, var/paddingTop)
	if(!element)
		error("No element was passed to padding setting.")
		return FALSE

	if(!(locate(element) in getElements()))
		error("Trying to set padding for element that is not connected to layout.")
		return

	var/list/data = _paddingData[element]
	if(!data)
		data = list()
		_paddingData[element] = data

	if(paddingBottom)
		data["bottom"] = paddingBottom
	if(paddingTop)
		data["top"] = paddingTop
	
	_spreadElements()
	return TRUE

/HUD_element/layout/horizontal/add(var/HUD_element/newElement, var/paddingLeft = 0, var/paddingRight = 0)
	. = ..()
	setPadding(newElement, paddingLeft, paddingRight)
	setHeight(max(getHeight(), newElement.getHeight()))

	_spreadElements()

/HUD_element/layout/vertical/add(var/HUD_element/newElement, var/paddingBottom = 0, var/paddingTop = 0)
	. = ..()
	setPadding(newElement, paddingBottom, paddingTop)
	setWidth(max(getWidth(), newElement.getWidth()))

	_spreadElements()

/HUD_element/layout/remove(var/HUD_element/element)
	. = ..()
	if(!getElements())
		setHeight(0)
		setWidth(0)
	
	if(_paddingData[element])
		_paddingData[element] = null

	_spreadElements()

/HUD_element/layout/setDimensions(var/width, var/height)
	return
/*
/HUD_element/layout/setWidth(var/width)
	return

/HUD_element/layout/setHeight(var/height)
	return
*/