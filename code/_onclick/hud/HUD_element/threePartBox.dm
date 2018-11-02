/HUD_element/threePartBox
	var/icon/_start_icon = icon("icons/HUD/storage_start.png")
	var/icon/_middle_icon = icon("icons/HUD/storage_middle.png")
	var/icon/_end_icon = icon("icons/HUD/storage_end.png")

	var/_minTotalWidth = 0

	var/HUD_element/_start_element
	var/HUD_element/_middle_element
	var/HUD_element/_end_element

/HUD_element/threePartBox/New(var/icon/startIcon, var/icon/middleIcon, var/icon/endIcon)
	..()
	_start_element = add().setIcon(startIcon || _start_icon)
	_middle_element = _start_element.add().setIcon(middleIcon || _middle_icon)
	_end_element = _middle_element.add().setIcon(endIcon || _end_icon)

	_start_element.setPassClickToParent(TRUE)
	_middle_element.setPassClickToParent(TRUE)
	_end_element.setPassClickToParent(TRUE)

	_middle_element.setAlignment(5,3) //east of parent, center
	_end_element.setAlignment(5,3) //east of parent, center

/HUD_element/threePartBox/Destroy()
	_start_element = null
	_middle_element = null
	_end_element = null
	. = ..()

/HUD_element/threePartBox/proc/getMinWidth()
	return max(_minTotalWidth, _start_element.getWidth() + _end_element.getWidth())

/HUD_element/threePartBox/scaleToSize(var/width, var/height)
	width = max(0, width - (_start_element.getWidth() + _end_element.getWidth()))

	_middle_element.scaleToSize(width,height)
	_start_element.scaleToSize(null,height)
	_end_element.scaleToSize(null,height)

	return src

/HUD_element/threePartBox/getWidth()
	return _start_element.getWidth() + _middle_element.getWidth() + _end_element.getWidth()

/HUD_element/threePartBox/getHeight()
	return max(_start_element.getHeight(), _middle_element.getHeight(), _end_element.getHeight())

/HUD_element/threePartBox/setName(var/new_name, var/nameAllElements = FALSE)
	_start_element.setName(new_name, nameAllElements)
	_middle_element.setName(new_name, nameAllElements)
	_end_element.setName(new_name, nameAllElements)
	. = ..()