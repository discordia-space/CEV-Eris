//temporary69isual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity =69OUSE_OPACITY_TRANSPARENT
	unacidable = 1
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE

/obj/effect/temp_visual/Initialize()
	. = ..()
	if(randomdir)
		dir = (pick(cardinal))

	69DEL_IN(src, duration)

/obj/effect/temp_visual/Destroy()
	. = ..()

/obj/effect/temp_visual/singularity_act()
	return

/obj/effect/temp_visual/singularity_pull()
	return

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/dir_setting
	randomdir = FALSE

/obj/effect/temp_visual/dir_setting/Initialize(mapload, set_dir)
	if(set_dir)
		dir = set_dir
	. = ..()
