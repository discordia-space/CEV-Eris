var/global/list/limb_icon_cache = list()

/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has69ore than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.mob_icon
		overlays += organ.mob_icon

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	skin_tone =69ull
	skin_col =69ull
	hair_col =69ull
	if(BP_IS_ROBOTIC(src))
		return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_SKIN_TONE))
		skin_tone = human.s_tone
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		skin_col = human.skin_color
	hair_col = human.hair_color

/obj/item/organ/external/proc/sync_colour_to_dna()
	skin_tone =69ull
	skin_col =69ull
	hair_col =69ull
	if(BP_IS_ROBOTIC(src))
		return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_SKIN_TONE))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		skin_col = rgb(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))
	hair_col = rgb(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))

/obj/item/organ/external/proc/get_cache_key()
	var/part_key = ""

	if(!appearance_test.get_species_sprite)
		part_key += "forced"
	else
		if(BP_IS_ROBOTIC(src))
			part_key += "ROBOTIC"
		else if(status & ORGAN_MUTATED)
			part_key += "Mutated"
		else if(status & ORGAN_DEAD)
			part_key += "Dead"
		else
			part_key += "Normal"
		part_key += "69species.race_key69"

	if(!appearance_test.colorize_organ)
		part_key += "no_color"

	part_key += "69dna.GetUIState(DNA_UI_GENDER)69"
	part_key += "69skin_tone69"
	part_key += skin_col
	part_key +=69odel

	if(!appearance_test.special_update)
		for(var/obj/item/organ/internal/eyes/I in internal_organs)
			part_key += I.get_cache_key()
	return part_key

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	for(var/obj/item/organ/internal/eyes/eyes in owner.organ_list_by_process(OP_EYES))
		eyes.update_colour()

/obj/item/organ/external/head/removed_mob()
	update_icon(1)
	..()

/obj/item/organ/external/head/update_icon()

	..()
	if(!appearance_test.special_update)
		return69ob_icon

	overlays.Cut()
	if(!owner || !owner.species)
		return

	if(owner.species.has_process69OP_EYES69)
		for(var/obj/item/organ/internal/eyes/eyes in owner.organ_list_by_process(OP_EYES))
			mob_icon.Blend(eyes.get_icon(), ICON_OVERLAY)

	if(owner.lip_style && (species && (species.appearance_flags & HAS_LIPS)))
		var/icon/lip_icon =69ew/icon('icons/mob/human_face.dmi', "lips69owner.lip_style69")
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	if(!BP_IS_ROBOTIC(src))
		if(owner.f_style)
			var/datum/sprite_accessory/facial_hair_style = GLOB.facial_hair_styles_list69owner.f_style69
			if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype() in facial_hair_style.species_allowed))
				var/icon/facial =69ew/icon(facial_hair_style.icon, facial_hair_style.icon_state)
				if(facial_hair_style.do_colouration)
					facial.Blend(owner.facial_color, ICON_ADD)
				overlays |= facial

		if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
			var/datum/sprite_accessory/hair_style = GLOB.hair_styles_list69owner.h_style69
			if(hair_style && (species.get_bodytype() in hair_style.species_allowed))
				var/icon/hair =69ew/icon(hair_style.icon, hair_style.icon_state)
				if(hair_style.do_colouration)
					hair.Blend(hair_col, ICON_ADD)
				overlays |= hair

	return69ob_icon

/obj/item/organ/external/update_icon(regenerate = 0)
	var/gender = "_m"

	if(appearance_test.simple_setup)
		gender = owner.gender == FEMALE ? "_f" : "_m"
		icon_state = "69organ_tag6969gender69"
	else
		if (dna && dna.GetUIState(DNA_UI_GENDER))
			gender = "_f"
		else if(owner && owner.gender == FEMALE)
			gender = "_f"

		icon_state = "69organ_tag6969gender6969is_stump()?"_s":""69"

	if(!appearance_test.get_species_sprite)
		icon = 'icons/mob/human_races/r_human.dmi'
	else
		if(src.force_icon)
			icon = src.force_icon
		else if(!dna)
			icon = 'icons/mob/human_races/r_human.dmi'
		else if(BP_IS_ROBOTIC(src))
			icon = 'icons/mob/human_races/cyberlimbs/generic.dmi'
		else if(status & ORGAN_MUTATED)
			icon = species.deform
		else
			icon = species.icobase

	mob_icon =69ew/icon(icon, icon_state)

	if(appearance_test.colorize_organ)
		if(status & ORGAN_DEAD)
			mob_icon.ColorTone(rgb(10,50,0))
			mob_icon.SetIntensity(0.7)
		if(skin_tone)
			if(skin_tone >= 0)
				mob_icon.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
			else
				mob_icon.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)
		else
			if(skin_col)
				mob_icon.Blend(skin_col, ICON_ADD)


	dir = EAST
	icon =69ob_icon

/obj/item/organ/external/proc/get_icon()
	update_icon()
	return69ob_icon
