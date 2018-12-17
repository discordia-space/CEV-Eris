/*
	List of AI actions buttons that AI can use
*/

/HUD_element/ui
	var/icon/_icon_overlay

/HUD_element/ui/New(var/name)
	..()

/HUD_element/ui/proc/setIconOverlay(var/icon/iconOverlay)
	_icon_overlay = iconOverlay

/HUD_element/ui/proc/getIconOverlay()
	return _icon_overlay