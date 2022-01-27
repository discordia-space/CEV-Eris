//Refreshes the icon and sets the luminosity
/obj/machinery/portable_atmospherics/hydroponics/update_icon()
	// Update name.
	if(seed)
		if(mechanical)
			name = "69base_name69 (#69seed.uid69)"
		else
			name = "69seed.seed_name69"
	else
		name = initial(name)

	if(labelled)
		name += " (69labelled69)"

	cut_overlays()
	update_overlays()

// Updates the plant overlay.
/obj/machinery/portable_atmospherics/hydroponics/update_overlays()
	.=..()
	var/list/new_overlays = .
	for(var/overlay in new_overlays)
		overlays += overlay
	if(!isnull(seed))
		if(mechanical && health <= (seed.get_trait(TRAIT_ENDURANCE) / 2))
			overlays += "over_lowhealth3"
		if(dead)
			var/ikey = "69seed.get_trait(TRAIT_PLANT_ICON)69-dead"
			var/image/dead_overlay = plant_controller.plant_icon_cache69"69ikey69"69
			if(!dead_overlay)
				dead_overlay = image('icons/obj/hydroponics_growing.dmi', "69ikey69")
				dead_overlay.color = DEAD_PLANT_COLOUR
			overlays |= dead_overlay
		else
			if(!seed.growth_stages)
				seed.update_growth_stages()
			if(!seed.growth_stages)
				to_chat(world, SPAN_DANGER("Seed type 69seed.get_trait(TRAIT_PLANT_ICON)69 cannot find a growth stage69alue."))
				return
			var/overlay_stage = 1
			if(age >= seed.get_trait(TRAIT_MATURATION))
				overlay_stage = seed.growth_stages
			else
				var/maturation = seed.get_trait(TRAIT_MATURATION)/seed.growth_stages
				if(maturation < 1)
					maturation = 1
				overlay_stage =69aturation ?69ax(1,round(age/maturation)) : 1
			var/ikey = "69seed.get_trait(TRAIT_PLANT_ICON)69-69overlay_stage69"
			var/image/plant_overlay = plant_controller.plant_icon_cache69"69ikey69-69seed.get_trait(TRAIT_PLANT_COLOUR)69"69
			if(!plant_overlay)
				plant_overlay = image('icons/obj/hydroponics_growing.dmi', "69ikey69")
				plant_overlay.color = seed.get_trait(TRAIT_PLANT_COLOUR)
				plant_controller.plant_icon_cache69"69ikey69-69seed.get_trait(TRAIT_PLANT_COLOUR)69"69 = plant_overlay
			overlays |= plant_overlay
			if(harvest && overlay_stage == seed.growth_stages)
				ikey = "69seed.get_trait(TRAIT_PRODUCT_ICON)69"
				var/image/harvest_overlay = plant_controller.plant_icon_cache69"product-69ikey69-69seed.get_trait(TRAIT_PLANT_COLOUR)69"69
				if(!harvest_overlay)
					harvest_overlay = image('icons/obj/hydroponics_products.dmi', "69ikey69")
					harvest_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
					plant_controller.plant_icon_cache69"product-69ikey69-69seed.get_trait(TRAIT_PRODUCT_COLOUR)69"69 = harvest_overlay
				overlays |= harvest_overlay
	//Draw the cover.
	if(closed_system)
		overlays += "hydrocover"
	//Updated the69arious alert icons.
	if(mechanical)
		if(waterlevel <= 10)
			overlays += "over_lowwater3"
		if(nutrilevel <= 2)
			overlays += "over_lownutri3"
		if(weedlevel >= 5 || pestlevel >= 5 || toxins >= 40)
			overlays += "over_alert3"
		if(harvest)
			overlays += "over_harvest3"

	if((!density || !opacity) && seed && seed.get_trait(TRAIT_LARGE))
		if(!mechanical)
			set_density(1)
		set_opacity(1)
	else
		if(!mechanical)
			set_density(0)
		set_opacity(0)


	// Update bioluminescence.
	if(seed)
		if(seed.get_trait(TRAIT_BIOLUM))
			var/clr
			if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
				clr = seed.get_trait(TRAIT_BIOLUM_COLOUR)
			set_light(round(seed.get_trait(TRAIT_POTENCY)/10), l_color = clr)
			return
	set_light(0)
	return
