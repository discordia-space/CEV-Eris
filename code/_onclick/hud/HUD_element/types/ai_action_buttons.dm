/*
	List of AI actions buttons that AI can use
*/

/HUD_element/ui
	var/icon/defaultIcon

/HUD_element/ui/New(var/icon/newIcon)
	if(!newIcon && !defaultIcon)
		log_debug("UI element created with null icon.")
	setIcon(newIcon || defaultIcon)
	..()

/HUD_element/ui/ai/alerts
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","alerts")

/*/HUD_element/ui/ai/bots
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","bots")
*/
/HUD_element/ui/ai/announce
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","announce")

/HUD_element/ui/ai/camera_light
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","camera_light")

/HUD_element/ui/ai/cameras
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","cameras")

/HUD_element/ui/ai/crew_sensors
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","crew_sensors")

/HUD_element/ui/ai/core
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","ai_core")

/HUD_element/ui/ai/take_photo
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","take_photo")

/HUD_element/ui/ai/email
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","email")

/HUD_element/ui/ai/manifest
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","manifest")

/HUD_element/ui/ai/photos
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","photos")

/HUD_element/ui/ai/evacuate
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","evacuate")

/HUD_element/ui/ai/radio
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","radio")

/HUD_element/ui/ai/state_laws
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","state_laws")

/HUD_element/ui/ai/track
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","track")

/HUD_element/ui/ai/subsystems
	defaultIcon = icon("icons/mob/screen/silicon/AI/HUD_actions.dmi","subsystems")
