// Ported from Haine and WrongEnd with much gratitude!
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=WHAT-EVER=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/obj/effect/window_lwall_spawn
	name = "window spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "sp_full_window"
	density = 1
	anchored = 1.0
	var/win_path = /obj/structure/window/basic/full
	var/wall_path = /obj/structure/low_wall
	var/activated = FALSE


/obj/effect/window_lwall_spawn/smartspawn/onestar
	wall_path = /obj/structure/low_wall/onestar

// stops ZAS expanding zones past us, the windows will block the zone anyway
/obj/effect/window_lwall_spawn/CanPass()
	return FALSE

/obj/effect/window_lwall_spawn/attack_hand()
	attack_generic()

/obj/effect/window_lwall_spawn/attack_ghost()
	attack_generic()

/obj/effect/window_lwall_spawn/attack_generic()
	activate()

/obj/effect/window_lwall_spawn/Initialize()
	. = ..()
	if(!win_path)
		return
	if(SSticker.current_state < GAME_STATE_PLAYING)
		if(activated)
			return
		activate()
		return INITIALIZE_HINT_QDEL
	else
		if(activated)
			return
		activate()
		spawn(10)
			qdel(src)


/obj/effect/window_lwall_spawn/proc/handle_window_spawn(var/obj/structure/window/W)
	new win_path(loc)

	return

/obj/effect/window_lwall_spawn/proc/activate()
	new wall_path(loc)
	handle_window_spawn(src)
	activated = TRUE
	return

/obj/effect/window_lwall_spawn/reinforced
	name = "reinforced window low-wall spawner"
	icon_state = "sp_full_window_reinforced"
	win_path = /obj/structure/window/reinforced/full

/obj/effect/window_lwall_spawn/smartspawn
	name = "reinforced window low-wall smart spawner"
	icon_state = "sp_smart_full_window"

/obj/effect/window_lwall_spawn/smartspawn/handle_window_spawn(var/obj/structure/window/W)
	if (is_turf_near_space(loc))
		new /obj/structure/window/reinforced/full(loc)
	else
		for (var/a in cardinal_turfs(loc))
			var/turf/T = a
			if (is_turf_near_space(T))
				if ((locate(/obj/structure/window) in T) || (locate(/obj/effect/window_lwall_spawn) in T))
					new /obj/structure/window/reinforced/full(loc)
					return

		new /obj/structure/window/basic/full(loc)
		return

/obj/effect/window_lwall_spawn/plasma
	name = "plasma window low-wall spawner"
	icon_state = "sp_full_window_plasma"
	win_path = /obj/structure/window/plasmabasic/full

/obj/effect/window_lwall_spawn/plasma/reinforced
	name = "reinforced plasma window low-wall spawner"
	icon_state = "sp_full_window_plasma_reinforced"
	win_path = /obj/structure/window/reinforced/plasma/full

/obj/effect/window_lwall_spawn/smartspawnplasma
	name = "reinforced plasma window low-wall smart spawner"
	icon_state = "sp_smart_full_window_plasma"

/obj/effect/window_lwall_spawn/smartspawnplasma/handle_window_spawn(var/obj/structure/window/W)
	if (is_turf_near_space(loc))
		new /obj/structure/window/plasmabasic/full(loc)
	else
		for (var/a in cardinal_turfs(loc))
			var/turf/T = a
			if (is_turf_near_space(T))
				if ((locate(/obj/structure/window/reinforced/plasma/full) in T) || (locate(/obj/effect/window_lwall_spawn/plasma/reinforced) in T))
					new /obj/structure/window/plasmabasic/full(loc)
					return

		new /obj/structure/window/reinforced/plasma/full(loc)
		return

/obj/effect/window_lwall_spawn/reinforced/polarized
	name = "polarized window low-wall spawner"
	icon_state = "sp_full_window_tinted"
	win_path = /obj/structure/window/reinforced/polarized/full
	var/id

/obj/effect/window_lwall_spawn/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/P)
	..()
	if(id)
		P.id = id
	return
