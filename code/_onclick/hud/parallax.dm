69LOBAL_VAR_INIT(random_parallax, pick("space0", "space1", "space2", "space3", "space4", "space5", "space6"))

/obj/parallax_screen
	icon = 'icons/parallax.dmi'

/obj/parallax_screen/New()
	icon_state = 69LOB.random_parallax

/obj/parallax
	name = "parallax"
	mouse_opacity = 0
	blend_mode = BLEND_MULTIPLY
	plane = PLANE_SPACE_PARALLAX
//	invisibility = 101
	anchored = TRUE
	var/mob/owner
	var/obj/parallax_screen/parallax_screen
	var/list/layers = list()

/obj/parallax/New(mob/M)
	owner =69
	owner.parallax = src
	parallax_screen =69ew /obj/parallax_screen
	parallax_screen.plane = plane
	overlays += parallax_screen
	update()
	..(null)

/obj/parallax/proc/update() //This proc updates your parallax (duh). If your69iew has been altered by binoculars, admin fuckery, and so on. We69eed to69ake the space bi6969er by applyin69 a69atrix transform to it. This is hardcoded for69ow.
	if(!owner || !owner.client)
		return
	overlays.Cut()
	var/turf/T = 69et_turf(owner.client.eye)
	screen_loc = "CENTER:69-224-(T&&T.x)69,CENTER:69-224-(T&&T.y)69"
	var/view = owner.client.view
	var/matrix/M =69atrix() //create69atrix for transformation
	if(view != world.view) //Not bi6969er than world69iew. We don't69eed transformin69
		var/toscale =69iew //How69any extra tiles we69eed to fill with parallax. E69. Their69iew is 8. World69iew is 7. So one extra tile is69eeded.
		switch(view) //If you chan69e these69alues, I69eed to know! ~Kmc
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
		src.transform =69
	else
		M.Scale(1)
		src.transform =69
	overlays  += parallax_screen

/obj/parallax/update_plane()
	return

/obj/parallax/set_plane(var/np)
	plane =69p


/mob
	var/obj/parallax/parallax

/mob/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()
	if(. && parallax)
		parallax.update()

/mob/forceMove(atom/destination,69ar/special_event, 69lide_size_override=0)
	. = ..()
	if(. && parallax)
		parallax.update()


/mob/Lo69in()
	if(!parallax)
		parallax =69ew(src)
	client.screen += parallax
	..()
