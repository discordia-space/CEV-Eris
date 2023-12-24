
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
	getElementByID("Take Photo").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai, take_photo), _observer.mob)
	getElementByID("View Photos").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,view_photos), _observer.mob)
	getElementByID("Cameras").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_camera_list), _observer.mob)
	getElementByID("Toggle Camera Light").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,toggle_camera_light), _observer.mob)
	getElementByID("Track With Camera").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_camera_track), _observer.mob)

	getElementByID("Announce").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_announcement), _observer.mob)
	getElementByID("Crew sensors").setClickProc(TYPE_VERB_REF(/mob/living/silicon,show_crew_sensors), _observer.mob)
	getElementByID("Subsystems").setClickProc(TYPE_VERB_REF(/mob/living/silicon,activate_subsystem), _observer.mob)
	getElementByID("Email").setClickProc(TYPE_VERB_REF(/mob/living/silicon,show_email), _observer.mob)
	getElementByID("Show Alerts").setClickProc(TYPE_VERB_REF(/mob/living/silicon,show_alerts), _observer.mob)
	getElementByID("Crew Manifest").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_roster), _observer.mob)
	getElementByID("State Laws").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_checklaws), _observer.mob)

	getElementByID("AI Core").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,core), _observer.mob)
	getElementByID("Move upwards").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_movement_up), _observer.mob)
	getElementByID("Move downwards").setClickProc(TYPE_PROC_REF(/mob/living/silicon/ai,ai_movement_down), _observer.mob)

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


// Simplified version of AI HUD accessible to humans. Used in surveillance_pod.dm
/datum/interface/AI_Simple
	mobtype = /mob/observer/eye/pod
	styleName = "ErisStyle"

/datum/interface/AI_Simple/buildUI()
	// #####	CREATING LAYOUTS    #####
	var/HUD_element/layout/vertical/navigationPanel = newUIElement("navigationPanel", /HUD_element/layout/vertical)

	// #####	CREATING LIST THAT WILL CONTAIN ELEMENTS FOR EASY ACCESS    #####
	var/list/HUD_element/navigation = list()

	// #####	CREATING UI ELEMENTS AND ASSIGNING THEM APPROPRIATE LISTS    #####
//	navigation += newUIElement("Track With Camera", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "track"))
//	navigation += newUIElement("Crew Sensors", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "crew_sensors"))
	navigation += newUIElement("Toogle Acceleration", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "camera_light"))
	navigation += newUIElement("Reset Camera", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "core"))
	navigation += newUIElement("Move Downwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "down"))
	navigation += newUIElement("Move Upwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "up"))

	// #####	ADDING CLICK PROCS TO BUTTONS    #####
//	getElementByID("Track With Camera").setClickProc(/mob/living/silicon/ai/proc/ai_camera_track, _observer.mob)
//	getElementByID("Crew Sensors").setClickProc(/mob/proc/show_crew_sensors, _observer.mob)
	getElementByID("Toogle Acceleration").setClickProc(TYPE_PROC_REF(/mob,acceleration_toogle), _observer.mob)
	getElementByID("Reset Camera").setClickProc(TYPE_PROC_REF(/mob,reset_view), _observer.mob)
	getElementByID("Move Downwards").setClickProc(TYPE_PROC_REF(/mob,zMoveDown), _observer.mob)
	getElementByID("Move Upwards").setClickProc(TYPE_PROC_REF(/mob,zMoveUp), _observer.mob)

	// #####	ALIGNING ELEMENTS USING LAYOUTS    #####
	navigationPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT, navigation, 0)

	// #####	ALIGNING LAYOUTS TO SCREEN    #####
	navigationPanel.setAlignment(HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	postBuildUI()
