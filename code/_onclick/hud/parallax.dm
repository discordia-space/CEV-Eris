/obj/parallax
	name = "parallax"
	mouse_opacity = 0
	blend_mode = BLEND_MULTIPLY
	plane = PARALLAX_PLANE
//	invisibility = 101
	anchored = 1
	var/mob/owner
	var/image/image

	New(mob/M)
		owner = M
		owner.parallax = src
		image = image('icons/parallax.dmi', src, "space")
		overlays += image
		update()
		..(null)

	proc/update()
		if(!owner || !owner.client)
			return
		var/turf/T = get_turf(owner.client.eye)
		screen_loc = "CENTER:[-224-(T&&T.x)],CENTER:[-224-(T&&T.y)]"

/mob
	var/obj/parallax/parallax

/mob/Move()
	. = ..()
	if(. && parallax)
		parallax.update()

/mob/forceMove()
	. = ..()
	if(. && parallax)
		parallax.update()

/mob/Login()
	if(!parallax)
		parallax = new(src)
	client.screen += parallax
	..()
