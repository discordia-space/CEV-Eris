/obj/screen/film_grain
	name = "Film Grain"
	icon = 'code/modules/sanity_grain/static.dmi'
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

	var/datum/stat_holder/S = owner.stats
	var/light_grain_perks = list(
		PERK_SURVIVOR, PERK_VAGABOND,  // Jobs
		PERK_NIHILIST, PERK_LOWBORN,   // Fates
		PERK_HOLY_LIGHT,               // Aura
	)

	var/state = "[rand(1, 9)] "
	for(var/perk in S.perks ? light_grain_perks : list())
		if(S.getPerk(perk))
			switch(new_level)
				if(-INFINITY to 30)
					state += "light"
				if(30 to INFINITY)
					state = ""

			grain.icon_state = state
			return

	switch(new_level)
		if(-INFINITY to 30)
			state += "moderate"
		if(30 to 60)
			state += "light"
		if(60 to INFINITY)
			state = ""

	grain.icon_state = state
