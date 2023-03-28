//How wall icons work
//1. A default sprite is specified in the wall's variables. This is quickly forgotten so ignore it
//2. Sprites are chosen from wall_masks.dmi, based on the material of the wall. Seven sets of four small sprites are carefully picked from
// to make the corners of each wall tile.
//3. These are blended with the material's colour to create a wall image which bends and connects to other walls

//The logic for how connections work is mostly found in tables.dm, in the dirs_to_corner_states proc

/turf/simulated/wall/proc/update_material(update = TRUE)
	icon_base = ""
	icon_base_reinf = ""
	health = 0
	maxHealth = 0

	if(material)
		//We'll set the icon bases to those of the materials
		icon_base = material.icon_base
		base_color = material.icon_colour
		if(reinf_material)
			icon_base_reinf = reinf_material.icon_reinf
			reinf_color = reinf_material.icon_colour
			construction_stage = 6
		else
			construction_stage = null
		if(!material)
			material = get_material_by_name(MATERIAL_STEEL)
		if(material)
			explosion_resistance = material.explosion_resistance
			hitsound = material.hitsound
			health = material.integrity
			maxHealth = material.integrity
		if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
			explosion_resistance = reinf_material.explosion_resistance
		if(reinf_material)
			health += reinf_material.integrity
			maxHealth += reinf_material.integrity
			name = "reinforced [material.display_name] wall"
			desc = "It seems to be a section of hull reinforced with [reinf_material.display_name] and plated with [material.display_name]."
		else
			name = "[material.display_name] wall"
			desc = "It seems to be a section of hull plated with [material.display_name]."

		if(material.opacity > 0.5 && !opacity)
			set_light(1)
		else if(material.opacity < 0.5 && opacity)
			set_light(0)

		//IF we have a radioactive material on our walls then we need to process
		var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
		if(total_radiation)
			START_PROCESSING(SSturf, src) //Used for radiation.

	//If we have overrides for icon bases, we set them here. even if we just set them from the material, those will be overridden
	if (icon_base_override)
		icon_base = icon_base_override

	if (icon_base_reinf_override)
		icon_base_reinf = icon_base_reinf_override

	if (base_color_override)
		base_color = base_color_override

	if (reinf_color_override)
		reinf_color = reinf_color_override

	//Update will be false at roundstart
	if (update)
		update_connections(1)
		update_icon()


/turf/simulated/wall/proc/set_material(var/material/newmaterial, var/material/newrmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	update_material()

/turf/simulated/wall/update_icon()
	if(!icon_base)
		return

	overlays.Cut()
	var/image/I
	for(var/i = 1 to 4)
		I = image('icons/turf/wall_masks.dmi', "[icon_base][wall_connections[i]]", dir = GLOB.cardinal[i])

		I.color = base_color
		overlays += I

	if(icon_base_reinf)
		if(construction_stage != null && construction_stage < 6)
			I = image('icons/turf/wall_masks.dmi', "reinf_construct-[construction_stage]")
			I.color = reinf_color
			overlays += I
		else
			if("[icon_base_reinf]0" in icon_states('icons/turf/wall_masks.dmi'))
				// Directional icon
				for(var/i = 1 to 4)
					I = image('icons/turf/wall_masks.dmi', "[icon_base_reinf][wall_connections[i]]", dir = 1<<(i-1))
					I.color = reinf_color
					overlays += I
			else
				I = image('icons/turf/wall_masks.dmi', icon_base_reinf)
				I.color = reinf_color
				overlays += I

	var/overlay = round((1 - health/maxHealth) * damage_overlays.len) + 1
	if(overlay > damage_overlays.len)
		overlay = damage_overlays.len

	overlays += damage_overlays[overlay]


/turf/simulated/wall/proc/update_connections(propagate = 0)
	if(!material)
		return
	var/list/dirs = list()
	for(var/turf/simulated/wall/W in RANGE_TURFS(1, src) - src)
		if(!W.material)
			continue
		if(propagate)
			W.update_connections()
			W.update_icon()
		if(can_join_with(W))
			dirs += get_dir(src, W)

	for(var/obj/structure/low_wall/T in orange(src, 1))
		if (!T.connected)
			continue

		var/T_dir = get_dir(src, T)
		dirs |= T_dir
		if(propagate)
			T.update_connections()
			T.update_icon()

	wall_connections = dirs_to_corner_states(dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return TRUE
	return FALSE
