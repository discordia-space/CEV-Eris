/*
	Layout object that used to contain and align multiple UI elements
*/

/HUD_element/layout
	

/HUD_element/layout/New(var/name)
	..()

/HUD_element/layout/Destroy()
	..()

/HUD_element/layout/setIcon()
	return

/HUD_element/layout/scaleToSize()
	return

/HUD_element/layout/updateIconInformation()
	return

/HUD_element/layout/add(var/HUD_element/newElement)
	_width += newElement.getWidth()
	_height += newElement.getHeight()
	return ..()

/HUD_element/layout/remove(var/HUD_element/element)
	_width -= element.getWidth()
	_height -= element.getHeight()
	return ..()

/HUD_element/layout/setDimensions(var/width, var/height)
	return

/HUD_element/layout/setWidth(var/width)
	return

/HUD_element/layout/setHeight(var/height)
	return
	