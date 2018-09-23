/obj/effect/temp_visual/obj_pickup_ghost
	duration = 2 //in deciseconds
	randomdir = FALSE

/obj/effect/temp_visual/obj_pickup_ghost/Initialize(var/mapload, var/atom/picked_up)
	. = ..()
	icon = picked_up.icon
	icon_state = picked_up.icon_state
	set_dir(picked_up.dir)
	pixel_x = picked_up.pixel_x
	pixel_y = picked_up.pixel_y
	color = picked_up.color

/obj/effect/temp_visual/obj_pickup_ghost/proc/animate_towards(var/atom/target)
	var/new_pixel_x = (target.x - src.x) * 32
	var/new_pixel_y = (target.y - src.y) * 32
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = matrix()*0, time = duration)
