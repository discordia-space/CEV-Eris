// Ported from Haine and WrongEnd with much gratitude!
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=WHAT-EVER=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/obj/effect/window_lwall_spawn
	name = "window spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "sp_full-window"
	density = 1
	anchored = 1.0
	var/win_path = /obj/structure/window/basic/full
	var/activated = FALSE

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

/obj/effect/window_lwall_spawn/proc/handle_window_spawn(var/obj/structure/window/W)
	PoolOrNew(win_path, src.loc)
	return

/obj/effect/window_lwall_spawn/proc/activate()
	PoolOrNew(/obj/structure/grille, src.loc)
	handle_window_spawn(src)
	activated = TRUE
	return

/obj/effect/window_lwall_spawn/reinforced
	name = "reinforced window grille spawner"
	icon_state = "sp_full-window"
	win_path = /obj/structure/window/reinforced/full

/obj/effect/window_lwall_spawn/smartspawn
	name = "reinforced window smart spawner"
	icon_state = "sp-smart_full-window"

/obj/effect/window_lwall_spawn/smartspawn/handle_window_spawn(var/obj/structure/window/W)
	if ((locate(/turf/space) in range(1, src)) || (locate(/turf/simulated/floor/hull) in range(1, src)))
		PoolOrNew(/obj/structure/window/reinforced/full, src.loc)
	else
		PoolOrNew(/obj/structure/window/basic/full, src.loc)
	return

/obj/effect/window_lwall_spawn/plasma
	name = "plasma window grille spawner"
	icon_state = "sp_full-window-plasma"
	win_path = /obj/structure/window/plasmabasic/full

/obj/effect/window_lwall_spawn/reinforced/polarized
	name = "polarized window grille spawner"
	icon_state = "sp_full-window-tinted"
	win_path = /obj/structure/window/reinforced/polarized/full
	var/id

/obj/effect/window_lwall_spawn/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/P)
	..()
	if(id)
		P.id = id
	return

