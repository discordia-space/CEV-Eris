
/datum/interface/AI_Eris
	mobtype = /mob/living/silicon/ai
	styleName = "ErisStyle"

/datum/interface/AI_Eris/buildUI()
	// #####	CREATING LAYOUTS    #####
	var/HUD_element/layout/horizontal/actionPanel = newUIElement("actionPanel", /HUD_element/layout/horizontal)
	var/HUD_element/layout/vertical/cameraPanel = newUIElement("cameraPanel", /HUD_element/layout/vertical)
	var/HUD_element/layout/vertical/navigationPanel = newUIElement("navigationPanel", /HUD_element/layout/vertical)
	
	// #####	CREATING LIST THAT WILL CONTAIN ELEMENTS FOR EASY ACCESS    #####
	var/list/HUD_element/actions = list()
	var/list/HUD_element/camera = list()
	var/list/HUD_element/navigation = list()

	// #####	CREATING UI ELEMENTS AND ASSIGNING THEM APPROPRIATE LISTS    #####
	camera += newUIElement("Take Photo", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "photo"))
	camera += newUIElement("View Photos", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "photos"))
	camera += newUIElement("Cameras", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "cameras"))
	camera += newUIElement("Toggle Camera Light", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "camera_light"))
	camera += newUIElement("Track With Camera", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "track"))
	
	actions += newUIElement("Email", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "email"))
	actions += newUIElement("Announce", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "announce"))
	actions += newUIElement("Crew sensors", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "crew_sensors"))
	actions += newUIElement("Subsystems", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "subsystems"))
	actions += newUIElement("Show Alerts", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "alerts"))
	actions += newUIElement("State Laws", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "state_laws"))
	actions += newUIElement("Crew Manifest", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "manifest"))
	
	navigation += newUIElement("Move downwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "down"))
	navigation += newUIElement("AI Core", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "core"))
	navigation += newUIElement("Move upwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "up"))

	// #####	ADDING CLICK PROCS TO BUTTONS    #####
	getElementByID("Take Photo").setClickProc(/mob/living/silicon/ai/proc/take_photo, _observer.mob)
	getElementByID("View Photos").setClickProc(/mob/living/silicon/ai/proc/view_photos, _observer.mob)
	getElementByID("Cameras").setClickProc(/mob/living/silicon/ai/proc/ai_camera_list, _observer.mob)
	getElementByID("Toggle Camera Light").setClickProc(/mob/living/silicon/ai/proc/toggle_camera_light, _observer.mob)
	getElementByID("Track With Camera").setClickProc(/mob/living/silicon/ai/proc/ai_camera_track, _observer.mob)
	
	getElementByID("Announce").setClickProc(/mob/living/silicon/ai/proc/ai_announcement, _observer.mob)
	getElementByID("Crew sensors").setClickProc(/mob/living/silicon/verb/show_crew_sensors, _observer.mob)
	getElementByID("Subsystems").setClickProc(/mob/living/silicon/verb/activate_subsystem, _observer.mob)
	getElementByID("Email").setClickProc(/mob/living/silicon/verb/show_email, _observer.mob)
	getElementByID("Show Alerts").setClickProc(/mob/living/silicon/verb/show_alerts, _observer.mob)
	getElementByID("Crew Manifest").setClickProc(/mob/living/silicon/ai/proc/ai_roster, _observer.mob)
	getElementByID("State Laws").setClickProc(/mob/living/silicon/ai/proc/ai_checklaws, _observer.mob)

	getElementByID("AI Core").setClickProc(/mob/living/silicon/ai/proc/core, _observer.mob)
	getElementByID("Move upwards").setClickProc(/mob/living/silicon/ai/proc/ai_movement_up, _observer.mob)
	getElementByID("Move downwards").setClickProc(/mob/living/silicon/ai/proc/ai_movement_down, _observer.mob)

	// #####	ALIGNING ELEMENTS USING LAYOUTS    #####
	cameraPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT, camera, 0)
	actionPanel.alignElements(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_NO_ALIGNMENT, actions, 0)
	navigationPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT, navigation, 0)

	// #####	ALIGNING LAYOUTS TO SCREEN    #####
	//panels is aligned to screen because they have no parent
	cameraPanel.setAlignment(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	actionPanel.setAlignment(HUD_CENTER_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	navigationPanel.setAlignment(HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	postBuildUI()