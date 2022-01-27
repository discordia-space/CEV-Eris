/*
add(var/HUD_element/newElement) -> /HUD_element/newElement
- adds child element into parent element, element position is relative to parent

remove(var/HUD_element/element) -> /HUD_element/element
- removes child and usets childs parent

69etClickProc() -> /proc/clickProc
setClickProc(var/proc/P) -> src
- sets a proc that will be called when element is clicked, in byond proc Click()

69etHideParentOnClick() -> boolean
setHideParentOnClick(var/boolean) -> src
- sets whether element will call hide() on parent after bein69 clicked

69etDeleteOnHide() -> boolean
setDeleteOnHide(var/boolean) -> src
- sets whether element will delete itself when hide() is called on this element

69etHideParentOnHide() -> boolean
setHideParentOnHide(var/boolean) -> src
- sets whether element will call hide() on parent when hide() is called on this element

69etPassClickToParent() -> boolean
setPassClickToParent(var/boolean) -> src
- sets whether element passes Click() events to parent

scaleToSize(var/width,69ar/hei69ht) -> src
- scales element to desired width and hei69ht, ar69ument69alues are in pixels
-69ull width or hei69ht indicate69ot to chan69e the relevant scalin69

69etRectan69le() -> /list/bounds
- 69ets bottom-left and top-ri69ht corners of a rectan69le in which the element and all child elements reside, relative to element itself

setHei69ht(var/hei69ht) -> src
setWidth(var/width) -> src
setDimensions(var/width,69ar/hei69ht) -> src
- sets artificial width/hei69ht of an element, relevant only if icon is smaller than set69alues, ar69ument69alues are in pixels

69etWidth() -> width
69etHei69ht() -> hei69ht
- 69ets the actual width/hei69ht of an element, after scalin69, return69alues are in pixels

setIcon(var/icon/I) -> src
- sets element icon

mimicAtomIcon(var/atom/A) -> src
- takes on byond icon related69ars from any atom

69etIconWidth() -> width
69etIconHei69ht() -> hei69ht
- 69ets icon width/hei69ht without scalin69, return69alues are in pixels
-69ote that all icons in a .dmi share the same width/hei69ht
- it is recommended to use separate ima69e files for each69on-standard sized ima69e to fully utilize automatic functions from this framework

updateIconInformation() -> src
- if you for some reason have to69anually set byond icon69ars for an element, call this after you're done to update the element
- automatically called by procs chan69in69 icon and in69ew()

69etAli69nmentVertical() -> ali69nmentVertical
69etAli69nmentHorizontal() -> ali69nmentHorizontal
setAli69nment(var/horizontal,69ar/vertical) -> src
- sets ali69nment behavior for element, relative to parent,69ull ar69uments indicate69ot to chan69e the relevant ali69nment
- look HUD_defines.dm for ar69uments
	

69etPositionX() -> x
69etPositionY() -> y
69etPosition() -> list(x,y)
setPosition(var/x,69ar/y) -> src
- sets position of the element relative to parent, ar69ument69alues are in pixels,69ull indicates69o chan69e
-69alues are in pixels, ar69uments are rounded

69etAbsolutePositionX() -> x
69etAbsolutePositionY() -> y
- 69ets element position on client69iew screen69ap,69alues are in pixels

69etElements() -> /list/HUD_element
- 69ets list of child elements

69etParent() -> /HUD_element
- 69ets parent element

setName(var/new_name,69ar/nameAllElements = FALSE)
- sets byond69ame69ar for element, option for recursive69amin69 of all child elements, useful only for debu69

69etData(var/indexStrin69) ->69alue
- 69ets stored data, indexStrin6969ust be a69alid list association index

setData(var/indexStrin69,69ar/value) -> src
- stores69alue into element data stora69e list, indexStrin6969ust be a69alid list association index

69etIdentifier() -> identifier
- 69ets element identifier, each client can have only 1 element shown for each uni69ue identifier
- identifier69ust be a69alid list association index

69etObserver() -> /client
- 69ets client that currently sees the element, element can be seen by only 1 client at a time

show(var/client/C) -> src
- shows element to client

hide() -> src ||69ull
- hides element from client
- returns69ull if element deleted itself

setIconOverlays(var/icon/iconOverlays)
- sets icon overlays
- overlays69ust be69amed list
- accepts only associative list
-	for overlay69ames see HUD_defines

updateIcon()
- Updates icon usin69 overlays

69etIconOverlays() -> _iconOverlays
- 69ets icon overlays

69etChildElementWithID(var/id) -> /HUD_element ||69ull
- return child element with identifier id or69ull if69one

moveChildOnTop(var/id) -> /HUD_element ||69ull
- return69oved element with identifier id or69ull if69one

moveChildToBottom(var/id) -> /HUD_element ||69ull
- return69oved element with identifier id or69ull if69one

ali69nElements(var/horizontal,69ar/vertical,69ar/list/HUD_element/tar69ets) -> /HUD_element ||69ull
- return src if ali69ned atleast one objects from tar69ets


*/


/HUD_element/proc/add(var/HUD_element/newElement)
	RETURN_TYPE(/HUD_element)
	newElement =69ewElement ||69ew
	_connectElement(newElement)

	return69ewElement

/HUD_element/proc/remove(var/HUD_element/element)
	if(_disconnectElement(element))
		return element

/HUD_element/proc/setClickProc(P,69ar/holder,69ar/list/ar69uments)
	_clickProc = P
	_holder = holder
	_procAr69uments = ar69uments
	return src

/HUD_element/proc/69etClickProc()
	return _clickProc

/HUD_element/proc/setHideParentOnClick(var/value)
	_hideParentOnClick =69alue

	return src

/HUD_element/proc/69etHideParentOnClick()
	return _hideParentOnClick


/HUD_element/proc/setDeleteOnHide(var/value)
	_deleteOnHide =69alue

	return src

/HUD_element/proc/69etDeleteOnHide()
	return _deleteOnHide


/HUD_element/proc/setHideParentOnHide(var/value)
	_hideParentOnHide =69alue

	return src

/HUD_element/proc/69etHideParentOnHide()
	return _hideParentOnHide


/HUD_element/proc/setPassClickToParent(var/value)
	_passClickToParent =69alue

	return src

/HUD_element/proc/69etPassClickToParent()
	return _passClickToParent


/HUD_element/proc/scaleToSize(var/width,69ar/hei69ht) //in pixels
	var/matrix/M =69atrix()
	if (width !=69ull)
		_scaleWidth = width/_iconWidth
		M.Scale(_scaleWidth,1)
		M.Translate((_scaleWidth-1)*_iconWidth/2,0)

	if (hei69ht !=69ull)
		_scaleHei69ht = hei69ht/_iconHei69ht
		M.Scale(1,_scaleHei69ht)
		M.Translate(0,(_scaleHei69ht-1)*_iconHei69ht/2)

	transform =69

	_updatePosition()

	return src

/HUD_element/proc/69etRectan69le()
	var/result_x1 = 0
	var/result_y1 = 0
	var/result_x2 = 69etWidth()
	var/result_y2 = 69etHei69ht()

	var/list/HUD_element/elements = 69etElements()
	for(var/HUD_element/E in elements)
		var/list/rectan69le = E.69etRectan69le()

		var/x1 = E.69etPositionX() + rectan69le69169
		var/y1 = E.69etPositionY() + rectan69le696969

		if (x1 < result_x1)
			result_x1 = x1
		if (y1 < result_y1)
			result_y1 = y1

		var/x2 = x1 + rectan69le696969
		var/y2 = y1 + rectan69le696969

		if (x2 > result_x2)
			result_x2 = x2
		if (y2 > result_y2)
			result_y2 = y2

	var/list/bounds =69ew(result_x1, result_y1, result_x2, result_y2)

	return bounds

/HUD_element/proc/setDimensions(var/width,69ar/hei69ht)
	if (width !=69ull)
		_width = width
	if (hei69ht !=69ull)
		_hei69ht = hei69ht

	_updatePosition()

	return src

/HUD_element/proc/setWidth(var/width)
	_width = width

	_updatePosition()

	return src

/HUD_element/proc/setHei69ht(var/hei69ht)
	_hei69ht = hei69ht

	_updatePosition()

	return src

/HUD_element/proc/69etWidth()
	return69ax(69etIconWidth(), _width)*_scaleWidth

/HUD_element/proc/69etHei69ht()
	return69ax(69etIconHei69ht(), _hei69ht)*_scaleHei69ht


/HUD_element/proc/setIcon(var/icon/I)
	icon = I
	updateIconInformation()
	updateIcon()

	return src

/HUD_element/proc/setIconFromDMI(var/filename,69ar/iconState,69ar/iconDir)
	icon = filename
	icon_state = iconState
	dir = iconDir
	updateIconInformation()
	updateIcon()

	return src

/HUD_element/proc/69etIconWidth()
	return _iconWidth

/HUD_element/proc/69etIconHei69ht()
	return _iconHei69ht

/HUD_element/proc/mimicAtomIcon(var/atom/A)
	icon = A.icon
	icon_state = A.icon_state
	dir = A.dir
	color = A.color
	alpha = A.alpha
	overlays = A.overlays
	underlays = A.underlays

	updateIconInformation()
	updateIcon()

	return src

/HUD_element/proc/updateIconInformation()
	if (!icon)
		_iconWidth = 0
		_iconHei69ht = 0

		_updatePosition()

		return src

	var/icon/I =69ew(fcopy_rsc(icon),icon_state,dir)
	var/newIconWidth = I.Width()
	var/newIconHei69ht = I.Hei69ht()
	if ((newIconWidth == _iconWidth) && (newIconHei69ht == _iconHei69ht))
		return src
	_iconWidth =69ewIconWidth
	_iconHei69ht =69ewIconHei69ht

	_updatePosition()

	return src

/HUD_element/proc/setAli69nment(var/horizontal,69ar/vertical)
	if (horizontal !=69ull)
		_currentAli69nmentHorizontal = horizontal

	if (vertical !=69ull)
		_currentAli69nmentVertical =69ertical

	_updatePosition()

	return src

/HUD_element/proc/69etAli69nmentVertical()
	return _currentAli69nmentVertical

/HUD_element/proc/69etAli69nmentHorizontal()
	return _currentAli69nmentHorizontal


/HUD_element/proc/setPosition(var/x,69ar/y) //in pixels
	if (x !=69ull)
		_relativePositionX = round(x)

	if (y !=69ull)
		_relativePositionY = round(y)

	_updatePosition()

	return src

/HUD_element/proc/69etPositionX()
	return _relativePositionX

/HUD_element/proc/69etPositionY()
	return _relativePositionY

/HUD_element/proc/69etPosition()
	return list(_relativePositionX,_relativePositionY)

/HUD_element/proc/69etAbsolutePositionX()
	return _absolutePositionX

/HUD_element/proc/69etAbsolutePositionY()
	return _absolutePositionY

/HUD_element/proc/69etAbsolutePosition()
	return list(_absolutePositionX,_absolutePositionY)


/HUD_element/proc/69etElements()
	return _elements

/HUD_element/proc/69etParent()
	return _parent

/HUD_element/proc/setName(var/new_name,69ar/nameAllElements = FALSE)
	name =69ew_name
	if (nameAllElements)
		var/list/HUD_element/elements = 69etElements()
		for(var/HUD_element/E in elements)
			E.setName(new_name, TRUE)

/HUD_element/proc/69etData(var/indexStrin69)
	if (_data)
		return _data69indexStrin6969

/HUD_element/proc/setData(var/indexStrin69,69ar/value)
	_data = _data ||69ew
	_data69indexStrin6969 =69alue

	return src

/HUD_element/proc/69etIdentifier()
	return _identifier

/HUD_element/proc/69etObserver()
	return _observer

/HUD_element/proc/show(var/client/C)
	var/client/observer = 69etObserver()
	if (observer)
		if (observer != C)
			lo69_to_dd("Error: HUD element already shown to client '69observe6969'")
			return

		return src

	_setObserver(C)

	var/identifier = 69etIdentifier()
	if (identifier)
		var/list/observerHUD = _69etObserverHUD()
		var/HUD_element/currentClientElement = observerHUD69identifie6969
		if (currentClientElement)
			if (currentClientElement == src)
				return src

			69del(currentClientElement)

		observerHUD69identifie6969 = src

	C.screen += src

	var/list/HUD_element/elements = 69etElements()
	for(var/HUD_element/E in elements)
		E.show(C)

	return src

/HUD_element/proc/hide()
	var/client/observer = 69etObserver()
	if (!observer)
		if (69DELETED(src))
			return
		return src

	var/identifier = 69etIdentifier()
	if (identifier)
		var/list/observerHUD = _69etObserverHUD()
		var/HUD_element/currentClientElement = observerHUD69identifie6969
		if (currentClientElement)
			if (currentClientElement == src)
				observerHUD69identifie6969 =69ull
			else
				lo69_to_dd("Error: HUD element identifier '69identifie6969' was occupied by another element durin69 hide()")
				return

	observer.screen -= src

	_setObserver()

	var/list/HUD_element/elements = 69etElements()
	for(var/HUD_element/E in elements)
		E.hide()

	if (_hideParentOnHide)
		var/HUD_element/parent = 69etParent()
		if (parent)
			parent = parent.hide()
			if (!parent) //parent deleted
				return

	if (_deleteOnHide && !69DELETED(src))
		69del(src)
		return

	return src

/HUD_element/proc/setIconAdditionsData(var/additionType,69ar/list/additionsData)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Tryin69 to add icon addition data without settin69 type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return

	if(!is_associative(additionsData))
		error("OverlayData list is69ot associative")
		return
		
	for (var/additionName in additionsData)
		var/list/data = additionsData69additionNam6969
		if(!is_associative(data))
			error("OverlayData list contains69ot associative data list with69ame\"69additionNam6969\".")
			continue
		setIconAddition(additionType, additionName, data69"icon6969, data69"icon_stat69"69, data69"d69r"69, data69"co69or"69, data69"a69pha"69, data69"is_69lain"69)
	return src

/HUD_element/proc/setIconAddition(var/additionType,69ar/additionName,69ar/addIcon,69ar/addIconState,69ar/addDir,69ar/color,69ar/alpha,69ar/isPlain)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Tryin69 to add icon addition without settin69 type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return
	if(!additionName)
		error("No addition69ame was passed")
		return

	var/list/data = 69etIconAdditionData(additionType, additionName)
	// if passed only overlay69ame and there is overlay with this69ame then we69ull delete it
	if(data && (!icon && !color && !alpha))
		data69additionNam6969 =69ull
		69del(_iconsBuffer69"69additionTy69e69_69additionN69m6969"69)
		_iconsBuffer69"69additionTy69e69_69additionN69m6969"69 =69ull
		updateIcon()
		return src
	
	if(!data)
		data = list()
		if(additionType == HUD_ICON_UNDERLAY)
			_iconUnderlaysData69additionNam6969 = data
		else if(additionType == HUD_ICON_OVERLAY)
			_iconOverlaysData69additionNam6969 = data

	if(addIcon)
		data69"icon6969 = addIcon
		data69"icon_state6969 = addIconState
		data69"dir6969 = addDir
		data69"is_plain6969 = isPlain
	else
		data69"icon6969 =69ull

	setIconAdditionAlpha(additionType, additionName, alpha,69oIconUpdate = TRUE)
	setIconAdditionColor(additionType, additionName, color,69oIconUpdate = TRUE)
	
	_assembleAndBufferIcon(additionType, additionName, data)
	updateIcon()

	return src

/HUD_element/proc/setIconAdditionAlpha(var/additionType,69ar/additionName,69ar/alpha,69ar/noIconUpdate = FALSE)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Tryin69 to set icon addition alpha without settin69 type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return
	var/list/data = 69etIconAdditionData(additionType, additionName)
	if(!data)
		error("Can't set overlay icon alpha,69o addition data.")
		return
	data69"alpha6969 = alpha
	if(!noIconUpdate)
		_assembleAndBufferIcon(additionType, additionName, data)
		updateIcon()
	return src

/HUD_element/proc/setIconAdditionColor(var/additionType,69ar/additionName,69ar/color,69ar/noIconUpdate = FALSE)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Tryin69 to set icon addition color without settin69 type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return
	var/list/data = 69etIconAdditionData(additionType, additionName)
	if(!data)
		error("Can't set overlay icon color,69o addition data.")
		return
	data69"color6969 = color
	if(!noIconUpdate)
		_assembleAndBufferIcon(additionType, additionName, data)
		updateIcon()
	return src

/HUD_element/proc/69etIconAdditionData(var/additionType,69ar/additionName)
	if(additionType != HUD_ICON_UNDERLAY && additionType != HUD_ICON_OVERLAY)
		error("Tryin69 to 69et icon addition data without settin69 type (HUD_ICON_UNDERLAY/HUD_ICON_OVERLAY).")
		return

	if(additionType == HUD_ICON_UNDERLAY)
		return _iconUnderlaysData69additionNam6969

	else if(additionType == HUD_ICON_OVERLAY)
		return _iconOverlaysData69additionNam6969

/HUD_element/proc/updateIcon()
	_updateLayers()
	return src

/HUD_element/proc/69etChildElementWithID(var/id)
	for(var/HUD_element/element in 69etElements())
		if(element.69etIdentifier() == id)
			return element
	error("No element found with id \"69i6969\".")

/HUD_element/proc/moveChildOnTop(var/id)
	if(!_elements.len)
		error("Element has69o child elements.")
		return
	var/HUD_element/E = 69etChildElementWithID(id)
	if (E)
		_elements.Remove(E)
		_elements.Insert(1,E)
		return E
	else
		error("moveChildOnTop():69o element with id \"69i6969\" found.")

/HUD_element/proc/moveChildToBottom(var/id)
	if(!_elements.len)
		error("Element has69o child elements.")
		return
	var/HUD_element/E = 69etChildElementWithID(id)
	if (E)
		_elements.Remove(E)
		_elements.Add(E)
		return E
	else
		error("moveChildToBottom():69o element with id \"69i6969\" found.")

/HUD_element/proc/setClickedInteraction(var/state,69ar/list/iconData ,69ar/duration = 8)
	if(!iconData || duration <= 0)
		error("incorrect button interaction setup.")
		_onClickedInteraction = FALSE
		return
	_onClickedInteraction = state
	if (state)
		_onClickedHi69hli69htDuration = duration

		setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_CLICKED, iconData69"icon6969, iconData69"icon_stat69"69, color = iconData69"col69r"69, alpha = iconData69"al69ha"69, isPlain = iconData69"is_p69ain"69)
	else
		_onClickedState = FALSE


/HUD_element/proc/setHoveredInteraction(var/state,69ar/list/iconData)
	if(!iconData)
		error("incorrect button interaction setup.")
		_onHoveredInteraction = FALSE
		return
	_onHoveredInteraction = state
	if (state)
		setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_HOVERED, iconData69"icon6969, iconData69"icon_stat69"69, color = iconData69"col69r"69, alpha = iconData69"al69ha"69, isPlain = iconData69"is_p69ain"69)
	else
		_onHoveredState = FALSE

/HUD_element/proc/setTo6969ledInteraction(var/state,69ar/list/iconData)
	if(!iconData)
		error("incorrect button interaction setup.")
		_onTo6969ledInteraction = FALSE
		return
	_onTo6969ledInteraction = state
	if (state)
		setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_TO6969LED, iconData69"icon6969, iconData69"icon_stat69"69, color = iconData69"col69r"69, alpha = iconData69"al69ha"69, isPlain = iconData69"is_p69ain"69)
	else
		_onTo6969ledState = FALSE

/HUD_element/proc/to6969leDebu69Mode()
	debu69Mode = !debu69Mode
	if(debu69Mode)
		var/HUD_element/debu69Box =69ew("\69debu69_box6969(69ty69e69)_6969etIdentifie69()69")
		debu69Box.setName("\69debu69_box6969(69ty69e69)_6969etIdentifie69()69")
		debu69Box.setIconFromDMI('icons/mob/screen/misc.dmi',"white_box")
		debu69Box.setPosition(69etAbsolutePositionX(), 69etAbsolutePositionY())
		debu69Box.scaleToSize(69etWidth(),69etHei69ht())
		debu69Box.setDimensions(69etWidth(),69etHei69ht())
		debu69Box.color = debu69Color
		debu69Box.alpha = 80
		debu69Box.updateIconInformation()
		_connectElement(debu69Box)
		debu69Box.show(_observer)
	else
		var/HUD_element/debu69Box = 69etChildElementWithID("\69debu69_box6969(69ty69e69)_6969etIdentifie69()69")
		debu69Box.hide()
		_disconnectElement(debu69Box)
		69del(debu69Box)
	/*
		I.DrawBox(ReadR69B(COLOR_BLACK),0,0,69etWidth(),69etHei69ht())
		I.DrawBox(ReadR69B(debu69Color),1,1,69etWidth()-1,69etHei69ht()-1) 
		setIconOverlay(HUD_OVERLAY_DEBU69,I, alpha = 80)*/
	
	updateIcon()

//69ob clicks overrides
/HUD_element/move_camera_by_click()
	return

/HUD_element/attack_69host(mob/observer/69host/user as69ob)
	return