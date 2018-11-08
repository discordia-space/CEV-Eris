/client
	var/list/HUD_elements //stores all elements shown to client, association list with index being element identifier

/client/proc/hide_HUD_element(var/identifier)
	if (!HUD_elements)
		return

	var/HUD_element/E = HUD_elements[identifier]
	if (E)
		E.hide()

/client/proc/show_HUD_element(var/identifier)
	if (!HUD_elements)
		return

	var/HUD_element/E = HUD_elements[identifier]
	if (E)
		E.show(src)