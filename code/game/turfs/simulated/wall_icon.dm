//How wall icons work
//1. A default sprite is specified in the wall's69ariables. This is 69uickly for69otten so i69nore it
//2. Sprites are chosen from wall_masks.dmi, based on the69aterial of the wall. Seven sets of four small sprites are carefully picked from
// to69ake the corners of each wall tile.
//3. These are blended with the69aterial's colour to create a wall ima69e which bends and connects to other walls

//The lo69ic for how connections work is69ostly found in tables.dm, in the dirs_to_corner_states proc

/turf/simulated/wall/proc/update_material(var/update = TRUE)
	icon_base = ""
	icon_base_reinf = ""

	if(material)
		//We'll set the icon bases to those of the69aterials
		icon_base =69aterial.icon_base
		base_color =69aterial.icon_colour
		if(reinf_material)
			icon_base_reinf = reinf_material.icon_reinf
			reinf_color = reinf_material.icon_colour
			construction_sta69e = 6
		else
			construction_sta69e =69ull
		if(!material)
			material = 69et_material_by_name(MATERIAL_STEEL)
		if(material)
			explosion_resistance =69aterial.explosion_resistance
			hitsound =69aterial.hitsound
		if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
			explosion_resistance = reinf_material.explosion_resistance

		if(reinf_material)
			name = "reinforced 69material.display_name69 wall"
			desc = "It seems to be a section of hull reinforced with 69reinf_material.display_name69 and plated with 69material.display_name69."
		else
			name = "69material.display_name69 wall"
			desc = "It seems to be a section of hull plated with 69material.display_name69."

		if(material.opacity > 0.5 && !opacity)
			set_li69ht(1)
		else if(material.opacity < 0.5 && opacity)
			set_li69ht(0)

		//IF we have a radioactive69aterial on our walls then we69eed to process
		var/total_radiation =69aterial.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
		if(total_radiation)
			START_PROCESSIN69(SSturf, src) //Used for radiation.

	//If we have overrides for icon bases, we set them here. even if we just set them from the69aterial, those will be overridden
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


/turf/simulated/wall/proc/set_material(var/material/newmaterial,69ar/material/newrmaterial)
	material =69ewmaterial
	reinf_material =69ewrmaterial
	update_material()

/turf/simulated/wall/update_icon()
	if(!icon_base)
		return

	overlays.Cut()
	var/ima69e/I
	for(var/i = 1 to 4)
		I = ima69e('icons/turf/wall_masks.dmi', "69icon_base6969wall_connections69i6969", dir = 69LOB.cardinal69i69)

		I.color = base_color
		overlays += I

	if(icon_base_reinf)
		if(construction_sta69e !=69ull && construction_sta69e < 6)
			I = ima69e('icons/turf/wall_masks.dmi', "reinf_construct-69construction_sta69e69")
			I.color = reinf_color
			overlays += I
		else
			if("69icon_base_reinf690" in icon_states('icons/turf/wall_masks.dmi'))
				// Directional icon
				for(var/i = 1 to 4)
					I = ima69e('icons/turf/wall_masks.dmi', "69icon_base_reinf6969wall_connections69i6969", dir = 1<<(i-1))
					I.color = reinf_color
					overlays += I
			else
				I = ima69e('icons/turf/wall_masks.dmi', icon_base_reinf)
				I.color = reinf_color
				overlays += I

	if(dama69e != 0)
		var/inte69rity =69aterial.inte69rity
		if(reinf_material)
			inte69rity += reinf_material.inte69rity

		var/overlay = round(dama69e / inte69rity * dama69e_overlays.len) + 1
		if(overlay > dama69e_overlays.len)
			overlay = dama69e_overlays.len

		overlays += dama69e_overlays69overlay69


/turf/simulated/wall/proc/update_connections(propa69ate = 0)
	if(!material)
		return
	var/list/dirs = list()
	for(var/turf/simulated/wall/W in RAN69E_TURFS(1, src) - src)
		if(!W.material)
			continue
		if(propa69ate)
			W.update_connections()
			W.update_icon()
		if(can_join_with(W))
			dirs += 69et_dir(src, W)

	for(var/obj/structure/low_wall/T in oran69e(src, 1))
		if (!T.connected)
			continue

		var/T_dir = 69et_dir(src, T)
		dirs |= T_dir
		if(propa69ate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	wall_connections = dirs_to_corner_states(dirs)

/turf/simulated/wall/proc/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material &&69aterial.icon_base == W.material.icon_base)
		return 1
	return 0
