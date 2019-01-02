/*
	
*/

/HUD_element/button
	
	var/_activated_color
	var/_activated_alpha

/HUD_element/button/New()
	..()

/HUD_element/button/Destroy()
	. = ..()

/HUD_element/button/MouseEntered(location)

	return ..()

/HUD_element/button/MouseExited(object,location,control,params)

	return ..()

/HUD_element/Click(location,control,params)

	return ..()