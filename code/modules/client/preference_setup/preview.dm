#define MODIFICATION_ORGANIC 1
#define MODIFICATION_SILICON 2
#define MODIFICATION_REMOVED 3

datum/preferences
	var/req_update_icon = 1
	var/icon/preview_icon  = null
	var/icon/preview_south = null
	var/icon/preview_north = null
	var/icon/preview_east  = null
	var/icon/preview_west  = null
	var/preview_dir = SOUTH

datum/preferences/proc/update_preview_icon()
	req_update_icon = 0			//No check. Can be forced.
	qdel(preview_south)
	qdel(preview_north)
	qdel(preview_east)
	qdel(preview_west)

	var/datum/species/current_species = all_species[species]
	var/datum/body_build/bodybuild = current_species.get_body_build(gender, body_build)

	var/g = "_m"
	if(gender == FEMALE)
		g = "_f"
	var/b = bodybuild.index
	g += b

	var/icon/icobase = current_species.icobase

	preview_icon = new /icon('icons/mob/human.dmi', "blank")

	var/list/organ_list = list(BP_CHEST,BP_GROIN,BP_HEAD)
	if(preview_dir & (SOUTH|WEST))
		organ_list += list(BP_R_ARM,BP_R_HAND,BP_R_LEG,BP_R_FOOT, BP_L_LEG,BP_L_FOOT,BP_L_ARM,BP_L_HAND)
	else
		organ_list += list(BP_L_LEG,BP_L_FOOT,BP_L_ARM,BP_L_HAND, BP_R_ARM,BP_R_HAND,BP_R_LEG,BP_R_FOOT)
	for(var/organ in organ_list)
		var/datum/body_modification/mod = get_modification(organ)
		var/datum/organ_description/OD = current_species.has_limbs[organ]
		var/datum/body_modification/PBM = get_modification(OD.parent_organ)
		if(PBM && (PBM.nature == MODIFICATION_REMOVED || PBM.nature == MODIFICATION_SILICON))
			mod = PBM

		if(!mod.is_allowed(organ, src))
			mod = new/datum/body_modification/none

		if(!mod.replace_limb)
			var/icon/organ_icon = new(icobase, "[organ][g]")
			// Skin color
			if(current_species && (current_species.flags & HAS_SKIN_COLOR))
				organ_icon.Blend(skin_color, ICON_ADD)

			// Skin tone
			if(current_species && (current_species.appearance_flags & HAS_SKIN_TONE))
				if (s_tone >= 0)
					organ_icon.Blend(rgb(s_tone, s_tone, s_tone), ICON_ADD)
				else
					organ_icon.Blend(rgb((-s_tone),  (-s_tone),  (-s_tone)), ICON_SUBTRACT)
			preview_icon.Blend(organ_icon, ICON_OVERLAY)
		preview_icon.Blend(mod.get_mob_icon(organ, bodybuild.index, modifications_colors[organ], gender, species),ICON_OVERLAY)

	// Underwear
	if(current_species.appearance_flags & HAS_UNDERWEAR)
		for(var/underwear_category_name in all_underwear)
			var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
			if(underwear_category)
				var/underwear_item_name = all_underwear[underwear_category_name]
				var/datum/category_item/underwear/underwear_item = underwear_category.items_by_name[underwear_item_name]
				if(underwear_item.icon_state)
					preview_icon.Blend(icon(bodybuild.underwear_icon, underwear_item.icon_state), ICON_OVERLAY)
			else
				all_underwear -= underwear_category_name

	// Eyes color
	var/icon/eyes = new /icon('icons/mob/human.dmi', "blank")
	var/datum/body_modification/mod = get_modification(O_EYES)
	if(!mod.replace_limb)
		eyes.Blend(new/icon(current_species.faceicobase, "eye_l[b]"), ICON_OVERLAY)
		eyes.Blend(new/icon(current_species.faceicobase, "eye_r[b]"), ICON_OVERLAY)
		if((current_species))
			eyes.Blend(eyes_color, ICON_ADD)
	eyes.Blend(mod.get_mob_icon(O_EYES, bodybuild.index, modifications_colors[O_EYES], null, species), ICON_OVERLAY)

	// Hair Style'n'Color
	var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
	if(hair_style)
		var/icon/hair = new/icon(hair_style.icon, hair_style.icon_state)
		hair.Blend(hair_color, ICON_ADD)
		eyes.Blend(hair, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
	if(facial_hair_style)
		var/icon/facial = new/icon(facial_hair_style.icon, facial_hair_style.icon_state)
		facial.Blend(facial_color, ICON_ADD)
		eyes.Blend(facial, ICON_OVERLAY)

	var/icon/clothes = null
	//This gives the preview icon clothes depending on which job(if any) is set to 'high'
	if(job_civilian_low & ASSISTANT || !job_master)
		clothes = new /icon(bodybuild.uniform_icon, "grey")
		clothes.Blend(new /icon(bodybuild.shoes_icon, "black"), ICON_UNDERLAY)
		if(backbag == 2)
			clothes.Blend(new /icon(bodybuild.backpack_icon, "backpack"), ICON_OVERLAY)
		else if(backbag == 3 || backbag == 4)
			clothes.Blend(new /icon(bodybuild.backpack_icon, "satchel"), ICON_OVERLAY)

	else
		var/datum/job/J = job_master.GetJob(high_job_title)
		if(J)
			var/t_state

			var/obj/item/clothing/under/UF = J.uniform
			t_state = initial(UF.icon_state)
			clothes = new /icon(bodybuild.get_mob_icon("uniform", t_state), t_state)

			var/obj/item/clothing/shoes/SH = J.shoes
			t_state = initial(SH.icon_state)
			clothes.Blend(new /icon(bodybuild.get_mob_icon("shoes", t_state), t_state), ICON_UNDERLAY)

			var/obj/item/clothing/gloves/GL = J.gloves
			t_state = initial(GL.icon_state)
			if(GL)
				clothes.Blend(new /icon(bodybuild.get_mob_icon("gloves", t_state), t_state), ICON_UNDERLAY)

			var/obj/item/weapon/storage/belt/BT = J.belt
			t_state = initial(BT.icon_state)
			if(BT)
				clothes.Blend(new /icon(bodybuild.get_mob_icon("belt", t_state), t_state), ICON_OVERLAY)

			var/obj/item/clothing/suit/ST = J.suit
			t_state =  initial(ST.icon_state)
			if(ST)
				clothes.Blend(new /icon(bodybuild.get_mob_icon("suit", t_state), t_state), ICON_OVERLAY)

			var/obj/item/clothing/head/HT = J.hat
			t_state = initial(HT.icon_state)
			if(HT)
				clothes.Blend(new /icon(bodybuild.get_mob_icon("head", t_state), t_state), ICON_OVERLAY)

			if(backbag > 1)
				var/obj/item/weapon/storage/backpack/BP = /obj/item/weapon/storage/backpack
				switch(backbaglist[backbag])
					if("Backpack")
						BP = J.backpacks[1] ? J.backpacks[1] : /obj/item/weapon/storage/backpack
					if("Satchel Job")
						BP = J.backpacks[2] ? J.backpacks[2] : /obj/item/weapon/storage/backpack
					if("Satchel")
						BP = J.backpacks[3] ? J.backpacks[3] : /obj/item/weapon/storage/backpack
				t_state = initial(BP.icon_state)
				clothes.Blend(new /icon(bodybuild.get_mob_icon("back", t_state), t_state), ICON_OVERLAY)

	if(disabilities & NEARSIGHTED)
		eyes.Blend(new /icon(bodybuild.get_mob_icon("glasses", "glasses"), "glasses"), ICON_OVERLAY)

	preview_icon.Blend(eyes, ICON_OVERLAY)

	if(clothes)
		preview_icon.Blend(clothes, ICON_OVERLAY)

	var/icon/result = icon(preview_icon)
	// Scaling here to prevent blurring in the browser.
	result.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2)

	preview_south = new(result, dir = SOUTH)
	preview_north = new(result, dir = NORTH)
	preview_east  = new(result, dir = EAST)
	preview_west  = new(result, dir = WEST)

	qdel(eyes)
	qdel(clothes)

#undef MODIFICATION_REMOVED
#undef MODIFICATION_ORGANIC
#undef MODIFICATION_SILICON