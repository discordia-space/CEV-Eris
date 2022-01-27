
/datum/interface/AI_Eris
	mobtype = /mob/living/silicon/ai
	styleName = "ErisStyle"

/datum/interface/AI_Eris/buildUI()
	// #####	CREATING LAYOUTS    #####
	var/HUD_element/layout/horizontal/actionPanel =69ewUIElement("actionPanel", /HUD_element/layout/horizontal)
	var/HUD_element/layout/vertical/cameraPanel =69ewUIElement("cameraPanel", /HUD_element/layout/vertical)
	var/HUD_element/layout/vertical/navigationPanel =69ewUIElement("navigationPanel", /HUD_element/layout/vertical)
	
	// #####	CREATING LIST THAT WILL CONTAIN ELEMENTS FOR EASY ACCESS    #####
	var/list/HUD_element/actions = list()
	var/list/HUD_element/camera = list()
	var/list/HUD_element/navigation = list()

	// #####	CREATING UI ELEMENTS AND ASSIGNING THEM APPROPRIATE LISTS    #####
	camera +=69ewUIElement("Take Photo", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "photo"))
	camera +=69ewUIElement("View Photos", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "photos"))
	camera +=69ewUIElement("Cameras", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "cameras"))
	camera +=69ewUIElement("Toggle Camera Light", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "camera_light"))
	camera +=69ewUIElement("Track With Camera", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "track"))
	
	actions +=69ewUIElement("Email", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "email"))
	actions +=69ewUIElement("Announce", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "announce"))
	actions +=69ewUIElement("Crew sensors", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "crew_sensors"))
	actions +=69ewUIElement("Subsystems", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "subsystems"))
	actions +=69ewUIElement("Show Alerts", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "alerts"))
	actions +=69ewUIElement("State Laws", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "state_laws"))
	actions +=69ewUIElement("Crew69anifest", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "manifest"))
	
	navigation +=69ewUIElement("Move downwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "down"))
	navigation +=69ewUIElement("AI Core", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "core"))
	navigation +=69ewUIElement("Move upwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "up"))

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
	getElementByID("Crew69anifest").setClickProc(/mob/living/silicon/ai/proc/ai_roster, _observer.mob)
	getElementByID("State Laws").setClickProc(/mob/living/silicon/ai/proc/ai_checklaws, _observer.mob)

	getElementByID("AI Core").setClickProc(/mob/living/silicon/ai/proc/core, _observer.mob)
	getElementByID("Move upwards").setClickProc(/mob/living/silicon/ai/proc/ai_movement_up, _observer.mob)
	getElementByID("Move downwards").setClickProc(/mob/living/silicon/ai/proc/ai_movement_down, _observer.mob)

	// #####	ALIGNING ELEMENTS USING LAYOUTS    #####
	cameraPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT, camera, 0)
	actionPanel.alignElements(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_NO_ALIGNMENT, actions, 0)
	navigationPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT,69avigation, 0)

	// #####	ALIGNING LAYOUTS TO SCREEN    #####
	//panels is aligned to screen because they have69o parent
	cameraPanel.setAlignment(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	actionPanel.setAlignment(HUD_CENTER_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	navigationPanel.setAlignment(HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	postBuildUI()


// Simplified69ersion of AI HUD accessible to humans. Used in surveillance_pod.dm
/datum/interface/AI_Simple
	mobtype = /mob/observer/eye/pod
	styleName = "ErisStyle"

/datum/interface/AI_Simple/buildUI()
	// #####	CREATING LAYOUTS    #####
	var/HUD_element/layout/vertical/navigationPanel =69ewUIElement("navigationPanel", /HUD_element/layout/vertical)
	
	// #####	CREATING LIST THAT WILL CONTAIN ELEMENTS FOR EASY ACCESS    #####
	var/list/HUD_element/navigation = list()

	// #####	CREATING UI ELEMENTS AND ASSIGNING THEM APPROPRIATE LISTS    #####
//	navigation +=69ewUIElement("Track With Camera", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "track"))
//	navigation +=69ewUIElement("Crew Sensors", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "crew_sensors"))
	navigation +=69ewUIElement("Toogle Acceleration", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "camera_light"))
	navigation +=69ewUIElement("Reset Camera", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "core"))
	navigation +=69ewUIElement("Move Downwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "down"))
	navigation +=69ewUIElement("Move Upwards", /HUD_element/button/thin/ai, list(icon = 'icons/mob/screen/silicon/AI/HUD_actionButtons.dmi',icon_state = "up"))

	// #####	ADDING CLICK PROCS TO BUTTONS    #####
//	getElementByID("Track With Camera").setClickProc(/mob/living/silicon/ai/proc/ai_camera_track, _observer.mob)
//	getElementByID("Crew Sensors").setClickProc(/mob/proc/show_crew_sensors, _observer.mob)
	getElementByID("Toogle Acceleration").setClickProc(/mob/proc/acceleration_toogle, _observer.mob)
	getElementByID("Reset Camera").setClickProc(/mob/proc/reset_view, _observer.mob)
	getElementByID("Move Downwards").setClickProc(/mob/proc/zMoveDown, _observer.mob)
	getElementByID("Move Upwards").setClickProc(/mob/proc/zMoveUp, _observer.mob)

	// #####	ALIGNING ELEMENTS USING LAYOUTS    #####
	navigationPanel.alignElements(HUD_NO_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT,69avigation, 0)

	// #####	ALIGNING LAYOUTS TO SCREEN    #####
	navigationPanel.setAlignment(HUD_HORIZONTAL_EAST_INSIDE_ALIGNMENT, HUD_VERTICAL_SOUTH_INSIDE_ALIGNMENT)
	postBuildUI()
