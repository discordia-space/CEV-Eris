/*
	
*/

/HUD_element/button/thin

/HUD_element/button/thin/New()
	setIcon(icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"button_thin_rim"))
	setIconOverlays(list("bottom" = icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"button_thin_bg")))
	return ..()

/HUD_element/button/thick

/HUD_element/button/thick/New()
	setIcon(icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"button_thick_rim"))
	setIconOverlays(list("bottom" = icon('icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',"button_thick_bg")))
	return ..()