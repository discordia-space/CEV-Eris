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

/obj/parallax/far
	icon_state = ""
	speed = 1
	plane = PLANE_SPACE_PARALLAX_FAR

/obj/parallax/close
	icon_state = ""
	speed = 1.4
	plane = PLANE_SPACE_PARALLAX_CLOSE

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
	var/turf/T = get_turf(owner.client.eye)
	screen_loc = "CENTER:[-224-(T&&T.x)],CENTER:[-224-(T&&T.y)]"

	//And now we change depending on what is happening in processing events
	for(var/datum/event/E in SSevent.active_events)
		switch(E.storyevent.id)
			if("bluespace interphase")
				icon_state = "micro_debris"
			if("graveyard")
				icon_state = "micro_debris"
			if("bluespace storm")
				icon_state = "micro_debris"
			if("ion blizzard")
				icon_state = "micro_debris"
			if("photon vortex")
				icon_state = "micro_debris"
			if("micro debris")
				icon_state = "micro_debris"
			if("nebula")
				icon_state = "micro_debris"
			else
				icon_state = "micro_debris"
		continue //Only one event changes our state


		// USE OVERLAYS FOR THIS!!!!!!


		overlays_standing[BLOCKING_LAYER] = image("icon"='icons/mob/misc_overlays.dmi', "icon_state"="block", "layer"=BLOCKING_LAYER)





	var/client/C = mymob.client
	if(!C)
		return
	var/turf/posobj = get_turf(C.eye)
	if(!posobj)
		return
	var/area/areaobj = posobj.loc


	C.previous_turf = posobj

	for(var/thing in C.parallax_layers)
		var/atom/movable/screen/parallax_layer/L = thing
		L.update_status(mymob)
		if (L.view_sized != C.view)
			L.update_o(C.view)

		var/change_x
		var/change_y

		if(L.absolute)
			var/new_offset_x = -(posobj.x - SSparallax.planet_x_offset) * L.speed
			var/new_offset_y = -(posobj.y - SSparallax.planet_y_offset) * L.speed
			change_x = new_offset_x - L.offset_x
			change_y = new_offset_y - L.offset_y
			L.offset_x = new_offset_x
			L.offset_y = new_offset_y
		else
			change_x = offset_x * L.speed
			L.offset_x -= change_x
			change_y = offset_y * L.speed
			L.offset_y -= change_y

			if(L.offset_x > 240)
				L.offset_x -= 480
			if(L.offset_x < -240)
				L.offset_x += 480
			if(L.offset_y > 240)
				L.offset_y -= 480
			if(L.offset_y < -240)
				L.offset_y += 480

		if(L.smooth_movement && !areaobj.parallax_movedir && (offset_x || offset_y))
			L.transform = matrix(1, 0, offset_x*L.speed, 0, 1, offset_y*L.speed)
			animate(L, transform=matrix(), time = SSparallax.wait, flags = ANIMATION_PARALLEL)

		L.screen_loc = "CENTER-7:[round(L.offset_x,1)],CENTER-7:[round(L.offset_y,1)]"












	var/view = owner.client.view
	var/matrix/M = matrix() //create matrix for transformation
	if(view != world.view) //Not bigger than world view. We don't need transforming
		var/toscale = view //How many extra tiles we need to fill with parallax. EG. Their view is 8. World view is 7. So one extra tile is needed.
		switch(view) //If you change these values, I need to know! ~Kmc
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
