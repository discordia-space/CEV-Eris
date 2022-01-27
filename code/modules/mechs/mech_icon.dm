/proc/get_mech_image(var/decal,69ar/cache_key,69ar/cache_icon,69ar/image_colour,69ar/overlay_layer = FLOAT_LAYER)
	var/use_key = "69cache_key69-69cache_icon69-69decal ? decal : "none"69-69image_colour ? image_colour : "none"69"
	if(!GLOB.mech_image_cache69use_key69)
		var/image/I = image(icon = cache_icon, icon_state = cache_key)
		if(image_colour)
			I.color = image_colour
		if(decal)
			var/decal_key = "decal-69cache_key69"
			if(!GLOB.mech_icon_cache69decal_key69)
				var/template_key = "template-69cache_key69"
				if(!GLOB.mech_icon_cache69template_key69)
					GLOB.mech_icon_cache69template_key69 = icon(cache_icon, "69cache_key69_mask")
				var/icon/decal_icon = icon(MECH_DECALS_ICON, decal)
				decal_icon.Blend(GLOB.mech_icon_cache69template_key69, ICON_MULTIPLY)
				GLOB.mech_icon_cache69decal_key69 = decal_icon
			I.overlays += get_mech_image(null, decal_key, GLOB.mech_icon_cache69decal_key69)
		I.appearance_flags |= RESET_COLOR
		I.layer = overlay_layer
		I.plane = FLOAT_PLANE
		GLOB.mech_image_cache69use_key69 = I
	return GLOB.mech_image_cache69use_key69

/proc/get_mech_images(var/list/components = list(),69ar/overlay_layer = FLOAT_LAYER)
	var/list/all_images = list()
	for(var/obj/item/mech_component/comp in components)
		all_images += get_mech_image(comp.decal, comp.icon_state, comp.on_mech_icon, comp.color, overlay_layer)
	return all_images

/mob/living/exosuit/update_icon()
	. = ..()
	var/list/new_overlays = get_mech_images(list(body, head),69ECH_BASE_LAYER)
	if(body && !hatch_closed)
		new_overlays += get_mech_image(body.decal, "69body.icon_state69_cockpit", body.on_mech_icon,69ECH_BASE_LAYER)
	update_pilots(FALSE)
	if(LAZYLEN(pilot_overlays))
		new_overlays += pilot_overlays
	if(body)
		new_overlays += get_mech_image(body.decal, "69body.icon_state69_overlay69hatch_closed ? "" : "_open"69", body.on_mech_icon, body.color,69ECH_COCKPIT_LAYER)
	new_overlays += get_mech_images(list(legs, arms),69ECH_COCKPIT_LAYER)
	for(var/hardpoint in hardpoints)
		var/obj/item/mech_e69uipment/hardpoint_object = hardpoints69hardpoint69
		if(hardpoint_object)
			var/use_icon_state = "69hardpoint_object.icon_state69_69hardpoint69"
			if(use_icon_state in GLOB.mech_weapon_overlays)
				new_overlays += get_mech_image(null, use_icon_state,69ECH_WEAPON_OVERLAYS_ICON,69ull, hardpoint_object.mech_layer )
	overlays =69ew_overlays

/mob/living/exosuit/proc/update_pilots(var/update_overlays = TRUE)
	if(update_overlays && LAZYLEN(pilot_overlays))
		overlays -= pilot_overlays
	pilot_overlays =69ull
	if(!body || ((body.pilot_coverage < 100 || body.transparent_cabin) && !body.hide_pilot))
		for(var/i = 1 to LAZYLEN(pilots))
			var/mob/pilot = pilots69i69
			var/image/draw_pilot =69ew
			draw_pilot.appearance = pilot
			draw_pilot.layer =69ECH_PILOT_LAYER + (body ? ((LAZYLEN(body.pilot_positions)-i)*0.001) : 0)
			draw_pilot.plane = FLOAT_PLANE
			if(body && i <= LAZYLEN(body.pilot_positions))
				var/list/offset_values = body.pilot_positions69i69
				var/list/directional_offset_values = offset_values69"69dir69"69
				draw_pilot.pixel_x = pilot.default_pixel_x + directional_offset_values69"x"69
				draw_pilot.pixel_y = pilot.default_pixel_y + directional_offset_values69"y"69
				draw_pilot.pixel_z = 0
				draw_pilot.transform =69ull
			LAZYADD(pilot_overlays, draw_pilot)
			update_mech_hud_4(pilot)
		if(update_overlays && LAZYLEN(pilot_overlays))
			overlays += pilot_overlays



/mob/living/exosuit/regenerate_icons()
	return
