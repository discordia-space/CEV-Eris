/obj/parallax
	name = "parallax"
	mouse_opacity = 0
	blend_mode = BLEND_MULTIPLY
	plane = PARALLAX_PLANE
	invisibility = 101
	anchored = 1
	var/mob/owner
	var/image/image

	New(mob/M)
		owner = M
		owner.parallax = src
		image = image('icons/parallax.dmi', src, "space")
		image.invisibility = 0
		update()

	proc/update()
		forceMove(get_turf(owner))
		pixel_x = -224-owner.x
		pixel_y = -224-owner.y

/mob
	var/obj/parallax/parallax

/mob/Move()
	. = ..()
	if(parallax)
		parallax.update()

/mob/forceMove()
	. = ..()
	if(parallax)
		parallax.update()

/mob/Login()
	if(!parallax)
		parallax = new(src)
	src << parallax.image
	..()
