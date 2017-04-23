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

/obj/item/organ/external/proc/sync_colour_to_human(var/mob/living/carbon/human/human)
	skin_tone = null
	skin_col = null
	hair_col = null
	if(status & ORGAN_ROBOT)
		return
	if(species && human.species && species.name != human.species.name)
		return
	if(!isnull(human.s_tone) && (human.species.appearance_flags & HAS_SKIN_TONE))
		skin_tone = human.s_tone
	if(human.species.appearance_flags & HAS_SKIN_COLOR)
		skin_col = human.skin_color
	hair_col = human.hair_color

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

/obj/item/organ/external/head/sync_colour_to_human(var/mob/living/carbon/human/human)
	..()
	var/obj/item/organ/eyes/eyes = owner.internal_organs_by_name["eyes"]
	if(eyes) eyes.update_colour()

/obj/item/organ/external/head/removed()
	update_icon(1)
	..()

/obj/item/organ/external/head/update_icon()

	..()
	overlays.Cut()
	if(!owner || !owner.species)
		return
	if(owner.species.has_organ["eyes"])
		var/icon/l_eye = new/icon('icons/mob/human_face.dmi', "eye_l[owner.body_build.index]")
		var/icon/r_eye = new/icon('icons/mob/human_face.dmi', "eye_r[owner.body_build.index]")
		var/obj/item/organ/eyes/eyes = owner.internal_organs_by_name["eyes"]
		var/icon/eyes_icon

		if(!eyes)
			eyes_icon = l_eye
			eyes_icon.Blend(r_eye, ICON_OVERLAY)
			eyes_icon.Blend(rgb(128,0,0), ICON_ADD)
		else
			if(istype(eyes, /obj/item/organ/eyes/oneeye))
				var/obj/item/organ/eyes/oneeye/OE = eyes
				if(OE.right_eye)
					eyes_icon = r_eye
				else
					eyes_icon = l_eye
				eyes_icon.Blend(OE.eyes_color, ICON_ADD)
			else if(istype(eyes, /obj/item/organ/eyes/heterohromia))
				var/obj/item/organ/eyes/heterohromia/HT = eyes
				eyes_icon = r_eye
				eyes_icon.Blend(HT.eyes_color, ICON_ADD)
				l_eye.Blend(HT.second_color, ICON_ADD)
				eyes_icon.Blend(l_eye, ICON_OVERLAY)
			else
				eyes_icon = l_eye
				eyes_icon.Blend(r_eye, ICON_OVERLAY)
				eyes_icon.Blend(eyes.eyes_color, ICON_ADD)

		mob_icon.Blend(eyes_icon, ICON_OVERLAY)
		overlays |= eyes_icon

	if(owner.lip_style && (species && (species.appearance_flags & HAS_LIPS)))
		var/icon/lip_icon = new/icon('icons/mob/human_face.dmi', "lips[owner.lip_style][owner.body_build.index]")
		mob_icon.Blend(lip_icon, ICON_OVERLAY)

	if(!(status & ORGAN_ROBOT))
		if(owner.f_style)
			var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
			if(facial_hair_style && facial_hair_style.species_allowed && (species.get_bodytype() in facial_hair_style.species_allowed))
				var/icon/facial = new/icon(facial_hair_style.icon, facial_hair_style.icon_state)
				if(facial_hair_style.do_colouration)
					facial.Blend(owner.facial_color, ICON_ADD)
				overlays |= facial

		if(owner.h_style && !(owner.head && (owner.head.flags_inv & BLOCKHEADHAIR)))
			var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
			if(hair_style && (species.get_bodytype() in hair_style.species_allowed))
				var/icon/hair = new/icon(hair_style.icon, hair_style.icon_state)
				if(hair_style.do_colouration)
					hair.Blend(hair_col, ICON_ADD)
				overlays |= hair

	return mob_icon

/obj/item/organ/external/update_icon(var/regenerate = 0)
	if (!owner)//special check
		qdel(src)
		return
	var/gender = "_m"
	if (dna && dna.GetUIState(DNA_UI_GENDER))
		gender = "_f"
	else if(owner && owner.gender == FEMALE)
		gender = "_f"

	icon_state = "[limb_name][gender][owner.body_build.index][is_stump()?"_s":""]"
	if(src.force_icon)
		icon = src.force_icon
	else if(!dna)
		icon = 'icons/mob/human_races/r_human.dmi'
	else if(status & ORGAN_ROBOT)
		icon = 'icons/mob/human_races/robotic.dmi'
	else if(status & ORGAN_MUTATED)
		icon = species.deform
	else
		icon = species.icobase

	mob_icon = new/icon(icon, icon_state)

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
	icon = mob_icon

/obj/item/organ/external/proc/get_icon()
	update_icon()
	return mob_icon
