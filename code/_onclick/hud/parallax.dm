GLOBAL_VAR_INIT(random_parallax, pick("space0", "space1", "space2", "space3", "space4", "space5", "space6"))

/obj/parallax
	icon = 'icons/parallax.dmi'
	icon_state = "space0"
	name = "parallax"
	mouse_opacity = 0
	blend_mode = BLEND_MULTIPLY
	plane = PLANE_SPACE_PARALLAX
	var/speed = 0.6
//	invisibility = 101
	anchored = TRUE
	var/mob/owner

/obj/parallax/New(mob/M)
	owner = M
	owner.parallax += src
	icon_state = GLOB.random_parallax
	update()
	..(null)

/obj/parallax/Destroy()
	owner = null
	return ..()

/obj/parallax/proc/update() //This proc updates your parallax (duh). If your view has been altered by binoculars, admin fuckery, and so on. We need to make the space bigger by applying a matrix transform to it. This is hardcoded for now.
	if(!owner || !owner.client)
		return
	overlays.Cut()
	icon_state = GLOB.random_parallax
	var/turf/T = get_turf(owner.client.eye)
	var/image/far
	var/image/close
	//And now we change depending on what is happening in processing events
	for(var/datum/event/E in SSevent.active_events)
		switch(E.storyevent.id)
			if("bluespace interphase")
				icon_state = "space_empty"
			if("graveyard")
				icon_state = "space_empty"
			if("bluespace storm")
				icon_state = "space_empty"
			if("ion blizzard")
				icon_state = "space_empty"
			if("photon vortex")
				icon_state = "space_empty"
			if("micro debris")
				icon_state = "space_empty"
				far = image("icon"='icons/parallax.dmi', "icon_state"="micro_debris_far", "layer"=1)
				close = image("icon"='icons/parallax.dmi', "icon_state"="micro_debris_close", "layer"=2)
			if("nebula")
				icon_state = "space_empty"
			else
				icon_state = GLOB.random_parallax
		continue //Only one event changes our state, priority should be from up to down if there are multiple
	if(far)
		far.pixel_x = (T&&T.x) * 0.4
		far.pixel_y = (T&&T.y) * 0.4
	if(close)
		close.pixel_x = (T&&T.x) * 0.9
		close.pixel_y = (T&&T.y) * 0.9
	overlays += close
	overlays += far
	screen_loc = "CENTER:[-224-(T&&T.x)],CENTER:[-224-(T&&T.y)]"
	var/view = owner.client.view
	var/matrix/M = matrix()	//create matrix for transformation
	if(view != world.view)	//Not bigger than world view. We don't need transforming
		var/toscale = view	//How many extra tiles we need to fill with parallax. EG. Their view is 8. World view is 7. So one extra tile is needed.
		switch(view)
			if(8)
				toscale = 1.2
			if(9)
				toscale = 1.4
			if(10)
				toscale = 1.6
			if(11)
				toscale = 1.8
			if(12)
				toscale = 2
			if(13)
				toscale = 2.2
			if(14)
				toscale = 2.4
			if(128)
				toscale = 4
		M.Scale(toscale)
		src.transform = M
	else
		M.Scale(1)
		src.transform = M






/obj/parallax/update_plane()
	return

/obj/parallax/set_plane(var/np)
	plane = np


/mob
	var/obj/parallax/parallax

/mob/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	if(. && parallax)
		parallax.update()

/mob/forceMove(atom/destination, var/special_event, glide_size_override=0)
	. = ..()
	if(. && parallax)
		parallax.update()


/mob/Login()
	if(!parallax)
		parallax = new(src)
	client.screen += parallax
	..()
