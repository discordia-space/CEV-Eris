
/datum/interface/new_player
	mobtype = /mob/new_player
	styleName = "ErisStyle"

/datum/interface/new_player/buildUI()
	var/HUD_element/lobbyBackground = newUIElement("Lobby Image", /HUD_element, list(icon = GLOB.lobbyScreen.imageFile, icon_state = GLOB.lobbyScreen.imageName))

	lobbyBackground.setAlignment(HUD_HORIZONTAL_WEST_INSIDE_ALIGNMENT, HUD_VERTICAL_NORTH_INSIDE_ALIGNMENT)
	postBuildUI()

/datum/interface/new_player/postBuildUI()
	return