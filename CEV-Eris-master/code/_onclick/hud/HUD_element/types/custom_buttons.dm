/*
	
*/

/HUD_element/button/thin/New(var/id, var/filename = 'icons/mob/screen/ErisStyle_32x32.dmi')
	. = ..()
	setIconAddition(HUD_ICON_UNDERLAY, "background", filename, "button_thin_bg")
	setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_FRAME, filename,"button_thin_rim")
	setIconAddition(HUD_ICON_OVERLAY, "lights", filename, "button_thin_lights")

/HUD_element/button/thick/New(var/id, var/filename = 'icons/mob/screen/ErisStyle_32x32.dmi')
	. = ..()
	setIconAddition(HUD_ICON_UNDERLAY, HUD_UNDERLAY_BACKGROUND, filename, "button_thick_bg")
	setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_FRAME, filename, "button_thick_rim")
	setIconAddition(HUD_ICON_OVERLAY, "lights", filename, "button_thick_lights")

/HUD_element/button/thin/ai/New(var/id, var/filename = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi')
	. = ..()

/HUD_element/button/thick/ai/New(var/id, var/filename = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi')
	. = ..()
