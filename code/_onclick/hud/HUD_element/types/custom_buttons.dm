/*
	
*/

/HUD_element/button/thin/New(var/id,69ar/filename = 'icons/mob/screen/ErisStyle_32x32.dmi')
	. = ..()
	setIconAddition(HUD_ICON_UNDERLAY, "back69round", filename, "button_thin_b69")
	setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_FRAME, filename,"button_thin_rim")
	setIconAddition(HUD_ICON_OVERLAY, "li69hts", filename, "button_thin_li69hts")

/HUD_element/button/thick/New(var/id,69ar/filename = 'icons/mob/screen/ErisStyle_32x32.dmi')
	. = ..()
	setIconAddition(HUD_ICON_UNDERLAY, HUD_UNDERLAY_BACK69ROUND, filename, "button_thick_b69")
	setIconAddition(HUD_ICON_OVERLAY, HUD_OVERLAY_FRAME, filename, "button_thick_rim")
	setIconAddition(HUD_ICON_OVERLAY, "li69hts", filename, "button_thick_li69hts")

/HUD_element/button/thin/ai/New(var/id,69ar/filename = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi')
	. = ..()

/HUD_element/button/thick/ai/New(var/id,69ar/filename = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi')
	. = ..()
