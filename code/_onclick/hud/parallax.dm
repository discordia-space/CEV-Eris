GLOBAL_VAR_INIT(random_parallax, pick("space0", "space1", "space2", "space3", "space4", "space5", "space6"))

/obj/parallax_screen
	icon = 'icons/parallax.dmi'

/obj/parallax_screen/New()
	icon_state = GLOB.random_parallax

/obj/parallax
	name = "parallax"
	mouse_opacity = 0
	blend_mode = BLEND_MULTIPLY
	plane = PLANE_SPACE_PARALLAX
//	invisibility = 101
	anchored = 1
	var/mob/owner
	var/obj/parallax_screen/parallax_screen
	var/list/layers = list()

/obj/parallax/New(mob/M)
	owner = M
	owner.parallax = src
	parallax_screen = new /obj/parallax_screen
	parallax_screen.plane = plane
	overlays += parallax_screen
	update()
	..(null)

/obj/parallax/proc/update() //This proc updates your parallax (duh). If your view has been altered by binoculars, admin fuckery, and so on. We need to make the space bigger by applying a matrix transform to it. This is hardcoded for now.
	if(!owner || !owner.client)
		return
	overlays.Cut()
	var/turf/T = get_turf(owner.client.eye)
	screen_loc = "CENTER:[-224-(T&&T.x)],CENTER:[-224-(T&&T.y)]"
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
	overlays  += parallax_screen

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
