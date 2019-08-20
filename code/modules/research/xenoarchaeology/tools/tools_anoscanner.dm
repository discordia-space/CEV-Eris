
/obj/item/device/ano_scanner
	name = "Alden-Saraspova counter"
	desc = "Aids in triangulation of exotic particles."
	icon = 'icons/obj/device.dmi'
	icon_state = "ano_scanner"
	item_state = "lampgreen"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT
	var/nearest_artifact_id = "unknown"
	var/nearest_artifact_distance = -1
	var/last_scan_time = 0
	var/scan_delay = 25

/obj/item/device/ano_scanner/Initialize()
	. = ..()
	scan()

/obj/item/device/ano_scanner/afterattack(var/atom/target, mob/user as mob)
	if (istype(target, /obj/effect/portal))
		var/obj/effect/portal/P = target
		if (P.failchance)
			to_chat(user, SPAN_NOTICE("This aperture has approximately [100-P.failchance]% stability."))
		else
			to_chat(user, SPAN_NOTICE("This aperture appears to be stable and safe."))

		var/time_existed = world.time - P.birthtime
		var/time_remaining = P.lifetime - time_existed
		to_chat(user, SPAN_NOTICE("It should remain open for approximately another [time2text(time_remaining, "hh hours and mm minutes")]"))

/obj/item/device/ano_scanner/attack_self(var/mob/user as mob)
	return src.interact(user)

/obj/item/device/ano_scanner/interact(var/mob/user as mob)
	if(world.time - last_scan_time >= scan_delay)
		spawn(0)
			icon_state = "ano_scanner2"
			scan()

			if(!user) return

			if(nearest_artifact_distance >= 0)
				to_chat(user, "Exotic energy detected on wavelength '[nearest_artifact_id]' in a radius of [nearest_artifact_distance]m")
			else
				to_chat(user, "Background radiation levels detected.")
	else
		to_chat(user, "Scanning array is recharging.")
	spawn(25)
		icon_state = "ano_scanner"

/obj/item/device/ano_scanner/proc/scan()
	set background = 1

	last_scan_time = world.time
	nearest_artifact_distance = -1
	var/turf/cur_turf = get_turf(src)
	for(var/turf/simulated/mineral/T in SSxenoarch.artifact_spawning_turfs)
		if(T.artifact_find)
			if(T.z == cur_turf.z)
				var/cur_dist = get_dist(cur_turf, T) * 2
				if( (nearest_artifact_distance < 0 || cur_dist < nearest_artifact_distance) && cur_dist <= T.artifact_find.artifact_detect_range )
					nearest_artifact_distance = cur_dist + rand() * 2 - 1
					nearest_artifact_id = T.artifact_find.artifact_id
		else
			SSxenoarch.artifact_spawning_turfs.Remove(T)
	cur_turf.visible_message("<span class='info'>[src] clicks.</span>")
