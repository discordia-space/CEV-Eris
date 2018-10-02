/var/list/lighting_update_lights = list() // List of lighting sources queued for update.

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 1
	init_order = INIT_ORDER_LIGHTING
	flags = SS_TICKER

/datum/controller/subsystem/lighting/stat_entry()
	..("L:[lighting_update_lights.len]")

/datum/controller/subsystem/lighting/Initialize(start_timeofday)
	fire() // for now, this proc also acts as initialize step, so Eris won't stay in dark until round starts.
	return ..()

/datum/controller/subsystem/lighting/fire()
	for(var/A in lighting_update_lights)
		if(!A)
			continue

		var/datum/light_source/L = A
		. = L.check()
		if(L.destroyed || . || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	// We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

	for(var/A in lighting_update_overlays)
		if(!A)
			continue

		var/atom/movable/lighting_overlay/L = A // Typecasting this later so BYOND doesn't istype each entry.
		L.update_overlay()
		L.needs_update = FALSE

	lighting_update_overlays.Cut()
	lighting_update_lights.Cut()
