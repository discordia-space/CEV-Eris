/mob/observer/ghost/Login()
	. = ..()
	if(!. || !client)
		return FALSE

	if (ghost_image)
		ghost_image.appearance = src
		ghost_image.appearance_flags = RESET_ALPHA
	updateghostimages()

	if (client)
		client.CAN_MOVE_DIAGONALLY = TRUE
		client.showSmartTip()
