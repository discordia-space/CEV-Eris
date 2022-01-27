/obj/effect/mineral
	name = "mineral69ein"
	icon = 'icons/obj/mining.dmi'
	desc = "Shiny."
	mouse_opacity = 0
	density = FALSE
	anchored = TRUE
	layer = FLASH_LAYER
	var/ore_key
	var/image/scanner_image

/obj/effect/mineral/New(var/newloc,69ar/ore/M)
	..(newloc)
	name = "69M.display_name69 deposit"
	ore_key =69.name
	icon_state = "rock_69ore_key69"
	var/turf/T = get_turf(src)
	T.overlays += image('icons/obj/mining.dmi', "rock_69ore_key69", dir = 1)
	if(T.color)
		color = T.color

/obj/effect/mineral/proc/get_scan_overlay()
	if(!scanner_image)
		var/ore/O = ore_data69ore_key69
		if(O)
			scanner_image = image(icon, loc = get_turf(src), icon_state = (O.scan_icon ? O.scan_icon : icon_state))
		else
			to_chat(world, "No ore data for 69src69!")
	return scanner_image