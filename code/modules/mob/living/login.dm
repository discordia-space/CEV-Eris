
/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the69ind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the69ind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)

	client.showSmartTip()
	return .
