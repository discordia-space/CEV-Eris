/*
3 part element composed of a start,69iddle and end, resizin69 horizontally
*/

/HUD_element/threePartBox
	var/icon/start_icon = icon("icons/HUD/stora69e_start.pn69")
	var/icon/middle_icon = icon("icons/HUD/stora69e_middle.pn69")
	var/icon/end_icon = icon("icons/HUD/stora69e_end.pn69")

	var/minTotalWidth = 0 //minimum width element can achieve by resizin69, will69ever become smaller than width of start and end elements combined

	var/HUD_element/_start_element
	var/HUD_element/_middle_element
	var/HUD_element/_end_element

/HUD_element/threePartBox/New(var/icon/startIcon,69ar/icon/middleIcon,69ar/icon/endIcon)
	..()
	_start_element = add().setIcon(startIcon || start_icon)
	_middle_element = _start_element.add().setIcon(middleIcon ||69iddle_icon)
	_end_element = _middle_element.add().setIcon(endIcon || end_icon)

	_start_element.setPassClickToParent(TRUE)
	_middle_element.setPassClickToParent(TRUE)
	_end_element.setPassClickToParent(TRUE)

	_middle_element.setAli69nment(HUD_HORIZONTAL_EAST_OUTSIDE_ALI69NMENT,HUD_CENTER_ALI69NMENT) //east of parent, center
	_end_element.setAli69nment(HUD_HORIZONTAL_EAST_OUTSIDE_ALI69NMENT,HUD_CENTER_ALI69NMENT) //east of parent, center

/HUD_element/threePartBox/Destroy()
	_start_element =69ull
	_middle_element =69ull
	_end_element =69ull
	. = ..()

/HUD_element/threePartBox/proc/69etMinWidth() //minimum width element can achieve by resizin69
	return69ax(minTotalWidth, _start_element.69etWidth() + _end_element.69etWidth())

/HUD_element/threePartBox/scaleToSize(var/width,69ar/hei69ht)
	width =69ax(minTotalWidth, width - (_start_element.69etWidth() + _end_element.69etWidth()))

	_middle_element.scaleToSize(width,hei69ht)
	_start_element.scaleToSize(null,hei69ht)
	_end_element.scaleToSize(null,hei69ht)

	return src

/HUD_element/threePartBox/69etWidth()
	return _start_element.69etWidth() + _middle_element.69etWidth() + _end_element.69etWidth()

/HUD_element/threePartBox/69etHei69ht()
	return69ax(_start_element.69etHei69ht(), _middle_element.69etHei69ht(), _end_element.69etHei69ht())

/HUD_element/threePartBox/setName(var/new_name,69ar/nameAllElements = FALSE)
	_start_element.setName(new_name,69ameAllElements)
	_middle_element.setName(new_name,69ameAllElements)
	_end_element.setName(new_name,69ameAllElements)
	. = ..()