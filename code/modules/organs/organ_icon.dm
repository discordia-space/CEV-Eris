var/global/list/limb_icon_cache = list()

/obj/item/organ/external/set_dir()
	return

/obj/item/organ/external/proc/compile_icon()
	overlays.Cut()
	 // This is a kludge, only one icon has more than one generation of children though.
	for(var/obj/item/organ/external/organ in contents)
		if(organ.children && organ.children.len)
			for(var/obj/item/organ/external/child in organ.children)
				overlays += child.mob_icon
		overlays += organ.mob_icon

/obj/item/organ/external/sync_to_owner()
	for(var/obj/item/organ/I in internal_organs)
		I.sync_to_owner()
	skin_tone = null
	skin_col = null
	hair_col = null
	if(status & ORGAN_ROBOT)
		return
	if(species && owner.species && species.name != owner.species.name)
		return
	if(!isnull(owner.s_tone) && (owner.species.appearance_flags & HAS_SKIN_TONE))
		skin_tone = owner.s_tone
	if(owner.species.appearance_flags & HAS_SKIN_COLOR)
		skin_col = owner.skin_color
	hair_col = owner.hair_color
	if(gendered)
		gendered = (owner.gender == MALE)? "_m": "_f"
	body_build = owner.body_build.index
	icon = null

/obj/item/organ/external/proc/sync_colour_to_dna()
	skin_tone = null
	skin_col = null
	hair_col = null
	if(status & ORGAN_ROBOT)
		return
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)) && (species.appearance_flags & HAS_SKIN_TONE))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	if(species.appearance_flags & HAS_SKIN_COLOR)
		skin_col = rgb(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))
	hair_col = rgb(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))

/obj/item/organ/external/update_icon()

	get_icon()
	apply_colors()
	apply_special()
	icon = mob_icon
	dir  = SOUTH
	return icon

/obj/item/organ/external/get_icon()
	icon_state = "[organ_tag][gendered][body_build]"

	if(default_icon)
		mob_icon = new /icon(default_icon, icon_state)
	else if(!dna)
		mob_icon = new/icon('icons/mob/human_races/r_human.dmi', icon_state)
	else if(status & ORGAN_MUTATED)
		mob_icon = new /icon(species.deform, icon_state)
	else
		mob_icon = new /icon(species.icobase, icon_state)

/obj/item/organ/external/proc/apply_colors()
	if(status & ORGAN_DEAD)
		mob_icon.ColorTone(rgb(10,50,0))
		mob_icon.SetIntensity(0.7)
	if(skin_tone)
		if(skin_tone >= 0)
			mob_icon.Blend(rgb(skin_tone, skin_tone, skin_tone), ICON_ADD)
		else
			mob_icon.Blend(rgb(-skin_tone,  -skin_tone,  -skin_tone), ICON_SUBTRACT)

	if(skin_col)
		mob_icon.Blend(skin_col, ICON_ADD)
/*
	if(tattoo)
		var/icon/tattoo_icon = new/icon('icons/mob/tattoo.dmi', "[organ_tag]_[tattoo][body_build]")
		tattoo_icon.Blend(tattoo_color, ICON_ADD)
		mob_icon.Blend(tattoo_icon, ICON_OVERLAY)
*/
/obj/item/organ/external/proc/apply_special()
	if(internal_organs)
		var/icon/tmp_icon = null
		for(var/obj/item/organ/I in internal_organs)
			tmp_icon = I.get_icon()
			if(tmp_icon)
				mob_icon.Blend(tmp_icon, ICON_OVERLAY)

	return mob_icon

/obj/item/organ/external/head
	var/icon/hair
	var/icon/facial

/obj/item/organ/external/head/removed(user, delete_children)
	update_icon()
	if(hair)   mob_icon.Blend(hair, ICON_OVERLAY)
	if(facial) mob_icon.Blend(facial, ICON_OVERLAY)
	icon = mob_icon
	..()

/obj/item/organ/external/head/update_icon()

	..()
	overlays.Cut()
	if(!owner || !owner.species)
		return icon

	if(owner.lip_style && species && species.appearance_flags & HAS_LIPS)
		var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips[owner.lip_style][body_build]")
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	if(!(status & ORGAN_ROBOT))
		if(owner.f_style)
			var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
			if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype() in facial_hair_style.species_allowed))
				facial = new/icon(facial_hair_style.icon, "[facial_hair_style.icon_state]_s")
				if(facial_hair_style.do_colouration)
					facial.Blend(owner.facial_color, ICON_ADD)
				overlays |= facial

		if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
			var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
			if(hair_style && (species.get_bodytype() in hair_style.species_allowed))
				hair = new/icon(hair_style.icon, "[hair_style.icon_state]_s")
				if(hair_style.do_colouration)
					hair.Blend(hair_col, ICON_ADD)
				overlays |= hair

	icon = mob_icon
	return icon

/obj/item/organ/external/get_icon_key()
	if(status & ORGAN_MUTATED)
		. = "mutated"
	else if(status & ORGAN_DEAD)
		. = "dead"
	else
		. = "normal"

	. += "[model][tattoo][tattoo_color]"

	if(species.flags & HAS_SKIN_TONE)
		. += num2text(skin_tone)
	if(species.flags & HAS_SKIN_COLOR)
		. += skin_col

	for(var/obj/item/organ/I in internal_organs)
		. += I.get_icon_key()

