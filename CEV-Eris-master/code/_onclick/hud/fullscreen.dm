/obj/screen/fullscreen
	icon = 'icons/obj/hud_full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/screen/fullscreen/New(new_icon_state)
	..(null)
	if(new_icon_state)
		src.icon_state = new_icon_state

/obj/screen/fullscreen/tile
	icon = 'icons/mob/screen1.dmi'
	screen_loc = ui_entire_screen
