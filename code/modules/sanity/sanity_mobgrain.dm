/obj/screen/film_grain
	name = "Film Grain"
	icon = 'code/modules/sanity/static.dmi'
	screen_loc = ui_entire_screen
	alpha = 110
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = 0

/datum/sanity
	var/obj/screen/film_grain/grain

/datum/sanity/New(mob/living/carbon/human/H)
	..()
	grain = new()

/mob/living/carbon/human/show_HUD()
	..()
	if(client)
		client.screen += sanity.grain

/datum/sanity/updateLevel(new_level)
	..()
	var/state = "[rand(1, 9)] "
	switch(new_level)
		if(-INFINITY to 30)
			state += "moderate"
		if(30 to 60)
			state += "light"
		if(60 to INFINITY)
			state = ""

	grain.icon_state = state

/mob/living/silicon
	var/obj/screen/film_grain/grain

/mob/living/silicon/New()
	..()
	grain = new()
	grain.icon_state = "[rand(1, 9)] moderate"

/mob/living/silicon/show_HUD()
	..()
	if(client)
		client.screen += grain
