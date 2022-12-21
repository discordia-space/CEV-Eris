var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/species = SPECIES_HUMAN

	var/b_type = "A+"					//blood type (not-chooseable)

	var/s_base = ""						//Base skin colour
	var/s_tone = 0						//Skin tone

	var/h_style = "Bald"				//Hair type
	var/f_style = "Shaved"				//Face hair type

	var/hair_color = "#000000"			//Hair color
	var/facial_color = "#000000"		//Face hair color
	var/skin_color = "#000000"			//Skin color
	var/eyes_color = "#000000"			//Eye color

	var/disabilities = 0

	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "black"
	var/list/bgstate_options = list("steel", "dark_steel", "white_tiles", "black_tiles", "wood", "carpet", "white", "black")

/datum/category_item/player_setup_item/physical/body
	name = "Body"
	sort_order = 2
	var/hide_species = TRUE

/datum/category_item/player_setup_item/physical/body/load_character(var/savefile/S)
	from_file(S["species"], pref.species)
	from_file(S["skin_tone"], pref.s_tone)
	from_file(S["skin_base"], pref.s_base)
	from_file(S["hair_style_name"], pref.h_style)
	from_file(S["facial_style_name"], pref.f_style)
	from_file(S["b_type"], pref.b_type)
	from_file(S["disabilities"], pref.disabilities)
	pref.preview_icon = null
	from_file(S["bgstate"], pref.bgstate)
	from_file(S["eyes_color"], pref.eyes_color)
	from_file(S["skin_color"], pref.skin_color)
	from_file(S["hair_color"], pref.hair_color)
	from_file(S["facial_color"], pref.facial_color)


/datum/category_item/player_setup_item/physical/body/save_character(var/savefile/S)
	to_file(S["species"], pref.species)
	to_file(S["skin_tone"], pref.s_tone)
	to_file(S["skin_base"], pref.s_base)
	to_file(S["hair_style_name"],pref.h_style)
	to_file(S["facial_style_name"],pref.f_style)
	to_file(S["b_type"], pref.b_type)
	to_file(S["disabilities"], pref.disabilities)
	to_file(S["bgstate"], pref.bgstate)
	to_file(S["eyes_color"], pref.eyes_color)
	to_file(S["skin_color"], pref.skin_color)
	to_file(S["hair_color"], pref.hair_color)
	to_file(S["facial_color"], pref.facial_color)

/datum/category_item/player_setup_item/physical/body/sanitize_character(var/savefile/S)
	pref.h_style		= sanitize_inlist(pref.h_style, GLOB.hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, GLOB.facial_hair_styles_list, initial(pref.f_style))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))
	pref.hair_color		= iscolor(pref.hair_color) ? pref.hair_color : "#000000"
	pref.facial_color	= iscolor(pref.facial_color) ? pref.facial_color : "#000000"
	pref.skin_color		= iscolor(pref.skin_color) ? pref.skin_color : "#000000"
	pref.eyes_color		= iscolor(pref.eyes_color) ? pref.eyes_color : "#000000"

	if(!pref.species || !(pref.species in playable_species))
		pref.species = SPECIES_HUMAN

	sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))

	pref.s_base = ""

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))

	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "black"

/datum/category_item/player_setup_item/physical/body/content(var/mob/user)
	if(!pref.preview_icon)
		pref.update_preview_icon()
	user << browse_rsc(pref.preview_icon, "previewicon.png")

	var/datum/species/mob_species = all_species[pref.species]
	. += "<style>span.color_holder_box{display: inline-block; width: 20px; height: 8px; border:1px solid #000; padding: 0px;}</style>"
	. += "<hr>"
	. += "<table><tr style='vertical-align:top; width: 100%'><td width=65%><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"

	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"

	. += "Base Colour: <a href='?src=\ref[src];base_skin=1'>[pref.s_base]</a><br>"

	. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"

	. += "Needs Glasses: <a href='?src=\ref[src];disabilities=[NEARSIGHTED]'><b>[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br><br>"

	. += "<b>Hair:</b><br>"
	. += " Style: <a href='?src=\ref[src];cycle_hair=right'>&lt;&lt;</a><a href='?src=\ref[src];cycle_hair=left'>&gt;&gt;</a><a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];hair_color=1'><span class='color_holder_box' style='background-color:[pref.hair_color]'></span></a><br>"

	. += "<br><b>Facial:</b><br>"
	. += " Style: <a href='?src=\ref[src];cycle_facial_hair=right'>&lt;&lt;</a><a href='?src=\ref[src];cycle_facial_hair=left'>&gt;&gt;</a><a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];facial_color=1'><span class='color_holder_box' style='background-color:[pref.facial_color]'></span></a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes: </b>"
		. += "<a href='?src=\ref[src];eye_color=1'><span class='color_holder_box' style='background-color:[pref.eyes_color]'></span></a><br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color: </b>"
		. += "<a href='?src=\ref[src];skin_color=1'><span class='color_holder_box' style='background-color:[pref.skin_color]'></span></a><br>"

	. += "</td><td style = 'text-align:center;' width = 35%><b>Preview</b><br>"
	. += "<div style ='padding-bottom:-2px;' class='statusDisplay'><img src=previewicon.png width=[pref.preview_icon.Width()] height=[pref.preview_icon.Height()]></div>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "</td></tr></table>"




/datum/category_item/player_setup_item/physical/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/physical/body/OnTopic(var/href,var/list/href_list, var/mob/user)

	var/datum/species/mob_species = all_species[pref.species]
	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.hair_color) as color|null
		if(new_hair && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.hair_color = new_hair
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = mob_species.get_hair_styles()
		var/new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.h_style)  as null|anything in valid_hairstyles

		mob_species = all_species[pref.species]
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles()))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_color) as color|null
		if(new_facial && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_color = new_facial
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.eyes_color) as color|null
		if(new_eyes && has_flag(all_species[pref.species], HAS_EYE_COLOR) && CanUseTopic(user))
			pref.eyes_color = new_eyes
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["base_skin"])
		var/new_s_base = input(user, "Choose your character's base colour:", CHARACTER_PREFERENCE_INPUT_TITLE) as null
		if(new_s_base && CanUseTopic(user))
			pref.s_base = new_s_base
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to 225", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.s_tone) + 35) as num|null

		mob_species = all_species[pref.species]
		if(new_s_tone && CanUseTopic(user))
			pref.s_tone = 35 - max(min(round(new_s_tone), 220), 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.skin_color) as color|null
		if(new_skin && has_flag(all_species[pref.species], HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.skin_color = new_skin
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)

		var/new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.f_style)  as null|anything in valid_facialhairstyles

		mob_species = all_species[pref.species]
		if(new_f_style && CanUseTopic(user) && mob_species.get_facial_hair_styles(pref.gender))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_list_item(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_hair"])
		var/list/valid_hairstyles = mob_species.get_hair_styles()
		var/old_pos = valid_hairstyles.Find(pref.h_style)
		var/new_h_style
		if(href_list["cycle_hair"] == "right")
			if(old_pos - 1 < 1)
				return TOPIC_NOACTION
			new_h_style = valid_hairstyles[old_pos-1]
		else
			if(old_pos + 1 > valid_hairstyles.len)
				return TOPIC_NOACTION
			new_h_style = valid_hairstyles[old_pos+1]

		mob_species = all_species[pref.species]
		if(new_h_style && CanUseTopic(user) && (new_h_style in mob_species.get_hair_styles()))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["cycle_facial_hair"])
		var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)
		var/old_pos = valid_facialhairstyles.Find(pref.f_style)
		var/new_f_style
		if(href_list["cycle_facial_hair"] == "right")
			if(old_pos - 1 < 1)
				return TOPIC_NOACTION
			new_f_style = valid_facialhairstyles[old_pos-1]
		else
			if(old_pos + 1 > valid_facialhairstyles.len)
				return TOPIC_NOACTION
			new_f_style = valid_facialhairstyles[old_pos+1]
		mob_species = all_species[pref.species]
		if(new_f_style && CanUseTopic(user) && mob_species.get_facial_hair_styles(pref.gender))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()

	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_hairstyles = mob_species.get_hair_styles()

	if(valid_hairstyles.len)
		pref.h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		pref.h_style = GLOB.hair_styles_list["Bald"]

	pref.h_style = GLOB.hair_styles_list["Bald"]

/datum/category_item/player_setup_item/proc/ResetFacialHair()

	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)

	if(valid_facialhairstyles.len)
		pref.f_style = pick(valid_facialhairstyles)
	else
		//this shouldn't happen
		pref.f_style = GLOB.facial_hair_styles_list["Shaved"]
	pref.f_style = GLOB.facial_hair_styles_list["Shaved"]

