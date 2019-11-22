//temporary visual effects
/obj/effect/temp_visual
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = 1
	var/duration = 10 //in deciseconds
	var/randomdir = TRUE

/obj/effect/temp_visual/Initialize()
	. = ..()
	if(randomdir)
		dir = (pick(cardinal))

	QDEL_IN(src, duration)

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

/obj/effect/temp_visual/resourceInsertion
	randomdir = FALSE

/obj/effect/temp_visual/resourceInsertion/proc/setMaterial(var/material)
	return

/obj/effect/temp_visual/resourceInsertion/protolathe
	icon = 'icons/obj/machines/research.dmi'
	duration = 8

/obj/effect/temp_visual/resourceInsertion/protolathe/setMaterial(var/material)
	icon_state = "protolathe_[material]"
	if(!(icon_state in icon_states(icon)))
		icon_state = "protolathe_metal"
	..()
