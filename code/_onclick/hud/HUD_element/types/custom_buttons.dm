/*
	
*/

/HUD_element/button/thin/New()
	. = ..()
	//icon is blank cuz we adding rim as overlay and will colorize it
	var/iconFile = 'icons/mob/screen/ErisStyle_32x32.dmi'
	setIconFromDMI(iconFile, "blank")
	setIconOverlay(HUD_OVERLAY_BACKGROUND_1, icon(iconFile,"button_thin_rim"))
	setIconOverlay(HUD_OVERLAY_BACKGROUND_2, icon(iconFile,"button_thin_bg"))
	setIconOverlay(HUD_OVERLAY_BACKGROUND_3, icon(iconFile,"button_thin_lights"))

/HUD_element/button/thick/New()
	. = ..()
	var/iconFile = 'icons/mob/screen/ErisStyle_32x32.dmi'
	setIconFromDMI(iconFile, "button_thick_rim")
	setIconOverlay(HUD_OVERLAY_BACKGROUND_1, icon(iconFile,"button_thick_bg"))
	setIconOverlay(HUD_OVERLAY_BACKGROUND_2, icon(iconFile,"button_thick_lights"))

/HUD_element/button/thin/ai/New()
	. = ..()
	var/iconFile = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi'
	setIconFromDMI(iconFile, "button_thin_rim")
	setIconOverlay(HUD_OVERLAY_BACKGROUND_1, icon(iconFile,"button_thin_bg"))
	//setIconOverlay(HUD_OVERLAY_BACKGROUND_2, null)
	setIconOverlay(HUD_OVERLAY_BACKGROUND_3, icon(iconFile,"button_thin_lights"))

/HUD_element/button/thick/ai/New()
	. = ..()
	var/iconFile = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi'
	setIconFromDMI(iconFile, "button_thick_rim")
	setIconOverlay(HUD_OVERLAY_BACKGROUND_1, icon(iconFile,"button_thick_bg"))
	setIconOverlay(HUD_OVERLAY_BACKGROUND_2, icon(iconFile,"button_thick_lights"))