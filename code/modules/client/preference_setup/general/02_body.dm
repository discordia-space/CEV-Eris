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
	from_file(S69"species"69, pref.species)
	from_file(S69"skin_tone"69, pref.s_tone)
	from_file(S69"skin_base"69, pref.s_base)
	from_file(S69"hair_style_name"69, pref.h_style)
	from_file(S69"facial_style_name"69, pref.f_style)
	from_file(S69"b_type"69, pref.b_type)
	from_file(S69"disabilities"69, pref.disabilities)
	pref.preview_icon = null
	from_file(S69"bgstate"69, pref.bgstate)
	from_file(S69"eyes_color"69, pref.eyes_color)
	from_file(S69"skin_color"69, pref.skin_color)
	from_file(S69"hair_color"69, pref.hair_color)
	from_file(S69"facial_color"69, pref.facial_color)


/datum/category_item/player_setup_item/physical/body/save_character(var/savefile/S)
	to_file(S69"species"69, pref.species)
	to_file(S69"skin_tone"69, pref.s_tone)
	to_file(S69"skin_base"69, pref.s_base)
	to_file(S69"hair_style_name"69,pref.h_style)
	to_file(S69"facial_style_name"69,pref.f_style)
	to_file(S69"b_type"69, pref.b_type)
	to_file(S69"disabilities"69, pref.disabilities)
	to_file(S69"bgstate"69, pref.bgstate)
	to_file(S69"eyes_color"69, pref.eyes_color)
	to_file(S69"skin_color"69, pref.skin_color)
	to_file(S69"hair_color"69, pref.hair_color)
	to_file(S69"facial_color"69, pref.facial_color)

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

	var/datum/species/mob_species = all_species69pref.species69
	. += "<style>span.color_holder_box{display: inline-block; width: 20px; height: 8px; border:1px solid #000; padding: 0px;}</style>"
	. += "<hr>"
	. += "<table><tr style='vertical-align:top; width: 100%'><td width=65%><b>Body</b> "
	. += "(<a href='?src=\ref69src69;random=1'>&reg;</A>)"
	. += "<br>"

	. += "Blood Type: <a href='?src=\ref69src69;blood_type=1'>69pref.b_type69</a><br>"

	. += "Base Colour: <a href='?src=\ref69src69;base_skin=1'>69pref.s_base69</a><br>"

	. += "Skin Tone: <a href='?src=\ref69src69;skin_tone=1'>69-pref.s_tone + 3569/220</a><br>"

	. += "Needs Glasses: <a href='?src=\ref69src69;disabilities=69NEARSIGHTED69'><b>69pref.disabilities & NEARSIGHTED ? "Yes" : "No"69</b></a><br><br>"

	. += "<b>Hair:</b><br>"
	. += " Style: <a href='?src=\ref69src69;cycle_hair=right'>&lt;&lt;</a><a href='?src=\ref69src69;cycle_hair=left'>&gt;&gt;</a><a href='?src=\ref69src69;hair_style=1'>69pref.h_style69</a>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref69src69;hair_color=1'><span class='color_holder_box' style='background-color:69pref.hair_color69'></span></a><br>"

	. += "<br><b>Facial:</b><br>"
	. += " Style: <a href='?src=\ref69src69;cycle_facial_hair=right'>&lt;&lt;</a><a href='?src=\ref69src69;cycle_facial_hair=left'>&gt;&gt;</a><a href='?src=\ref69src69;facial_style=1'>69pref.f_style69</a>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref69src69;facial_color=1'><span class='color_holder_box' style='background-color:69pref.facial_color69'></span></a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes: </b>"
		. += "<a href='?src=\ref69src69;eye_color=1'><span class='color_holder_box' style='background-color:69pref.eyes_color69'></span></a><br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color: </b>"
		. += "<a href='?src=\ref69src69;skin_color=1'><span class='color_holder_box' style='background-color:69pref.skin_color69'></span></a><br>"

	. += "</td><td style = 'text-align:center;' width = 35%><b>Preview</b><br>"
	. += "<div style ='padding-bottom:-2px;' class='statusDisplay'><img src=previewicon.png width=69pref.preview_icon.Width()69 height=69pref.preview_icon.Height()69></div>"
	. += "<br><a href='?src=\ref69src69;cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref69src69;toggle_preview_value=69EQUIP_PREVIEW_LOADOUT69'>69pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"69</a>"
	. += "<br><a href='?src=\ref69src69;toggle_preview_value=69EQUIP_PREVIEW_JOB69'>69pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"69</a>"
	. += "</td></tr></table>"




/datum/category_item/player_setup_item/physical/body/proc/has_flag(var/datum/species/mob_species,69ar/flag)
	return69ob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/physical/body/OnTopic(var/href,var/list/href_list,69ar/mob/user)

	var/datum/species/mob_species = all_species69pref.species69
	if(href_list69"toggle_species_verbose"69)
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list69"random"69)
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	/*else if(href_list69"change_descriptor"69)
		if(mob_species.descriptors)
			var/desc_id = href_list69"change_descriptor"69
			if(pref.body_descriptors69desc_id69)
				var/datum/mob_descriptor/descriptor =69ob_species.descriptors69desc_id69
				var/choice = input("Please select a descriptor.", "Descriptor") as null|anything in descriptor.chargen_value_descriptors
				if(choice &&69ob_species.descriptors69desc_id69) // Check in case they sneakily changed species.
					pref.body_descriptors69desc_id69 = descriptor.chargen_value_descriptors69choice69
					return TOPIC_REFRESH
	*/

	else if(href_list69"blood_type"69)
		var/new_b_type = input(user, "Choose your character's blood-type:", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in69alid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	/*else if(href_list69"show_species"69)
		var/choice = input("Which species would you like to look at?") as null|anything in playable_species
		if(choice)
			var/datum/species/current_species = all_species69choice69
			user << browse(current_species.get_description(), "window=species;size=700x400")
			return TOPIC_HANDLED

	else if(href_list69"set_species"69)

		var/list/species_to_pick = list()
		for(var/species in playable_species)
			if(!check_rights(R_ADMIN, 0) && config.usealienwhitelist)
				var/datum/species/current_species = all_species69species69
				if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
					continue
				else if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species))
					continue
			species_to_pick += species

		var/choice = input("Select a species to play as.") as null|anything in species_to_pick
		if(!choice || !(choice in all_species))
			return

		var/prev_species = pref.species
		pref.species = choice
		if(prev_species != pref.species)
			mob_species = all_species69pref.species69
			if(!(pref.gender in69ob_species.genders))
				pref.gender =69ob_species.genders69169

			ResetAllHair()

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = 0
			pref.age =69ax(min(pref.age,69ob_species.max_age),69ob_species.min_age)

			reset_limbs() // Safety for species with incompatible69anufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			//prune_occupation_prefs()
			pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)

			pref.cultural_info =69ob_species.default_cultural_info.Copy()

			return TOPIC_REFRESH_UPDATE_PREVIEW
	*/
	else if(href_list69"hair_color"69)
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.hair_color) as color|null
		if(new_hair && has_flag(all_species69pref.species69, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.hair_color = new_hair
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"hair_style"69)
		var/list/valid_hairstyles =69ob_species.get_hair_styles()
		var/new_h_style = input(user, "Choose your character's hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.h_style)  as null|anything in69alid_hairstyles

		mob_species = all_species69pref.species69
		if(new_h_style && CanUseTopic(user) && (new_h_style in69ob_species.get_hair_styles()))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"facial_color"69)
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.facial_color) as color|null
		if(new_facial && has_flag(all_species69pref.species69, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_color = new_facial
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"eye_color"69)
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.eyes_color) as color|null
		if(new_eyes && has_flag(all_species69pref.species69, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.eyes_color = new_eyes
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"base_skin"69)
		var/new_s_base = input(user, "Choose your character's base colour:", CHARACTER_PREFERENCE_INPUT_TITLE) as null//|anything in69ob_species.base_skin_colours
		if(new_s_base && CanUseTopic(user))
			pref.s_base = new_s_base
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"skin_tone"69)
		//var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to 69mob_species.max_skin_tone()69", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.s_tone) + 35) as num|null
		var/new_s_tone = input(user, "Choose your character's skin-tone. Lower numbers are lighter, higher are darker. Range: 1 to 225", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.s_tone) + 35) as num|null

		mob_species = all_species69pref.species69
		if(new_s_tone && CanUseTopic(user))
			//pref.s_tone = 35 -69ax(min(round(new_s_tone),69ob_species.max_skin_tone()), 1)
			pref.s_tone = 35 -69ax(min(round(new_s_tone), 220), 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"skin_color"69)
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", CHARACTER_PREFERENCE_INPUT_TITLE, pref.skin_color) as color|null
		if(new_skin && has_flag(all_species69pref.species69, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.skin_color = new_skin
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"facial_style"69)
		var/list/valid_facialhairstyles =69ob_species.get_facial_hair_styles(pref.gender)

		var/new_f_style = input(user, "Choose your character's facial-hair style:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.f_style)  as null|anything in69alid_facialhairstyles

		mob_species = all_species69pref.species69
		if(new_f_style && CanUseTopic(user) &&69ob_species.get_facial_hair_styles(pref.gender))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"disabilities"69)
		var/disability_flag = text2num(href_list69"disabilities"69)
		pref.disabilities ^= disability_flag
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"toggle_preview_value"69)
		pref.equip_preview_mob ^= text2num(href_list69"toggle_preview_value"69)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"cycle_bg"69)
		pref.bgstate = next_list_item(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list69"cycle_hair"69)
		var/list/valid_hairstyles =69ob_species.get_hair_styles()
		var/old_pos =69alid_hairstyles.Find(pref.h_style)
		var/new_h_style
		if(href_list69"cycle_hair"69 == "right")
			if(old_pos - 1 < 1)
				return TOPIC_NOACTION
			new_h_style =69alid_hairstyles69old_pos-169
		else
			if(old_pos + 1 >69alid_hairstyles.len)
				return TOPIC_NOACTION
			new_h_style =69alid_hairstyles69old_pos+169

		mob_species = all_species69pref.species69
		if(new_h_style && CanUseTopic(user) && (new_h_style in69ob_species.get_hair_styles()))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list69"cycle_facial_hair"69)
		var/list/valid_facialhairstyles =69ob_species.get_facial_hair_styles(pref.gender)
		var/old_pos =69alid_facialhairstyles.Find(pref.f_style)
		var/new_f_style
		if(href_list69"cycle_facial_hair"69 == "right")
			if(old_pos - 1 < 1)
				return TOPIC_NOACTION
			new_f_style =69alid_facialhairstyles69old_pos-169
		else
			if(old_pos + 1 >69alid_facialhairstyles.len)
				return TOPIC_NOACTION
			new_f_style =69alid_facialhairstyles69old_pos+169
		mob_species = all_species69pref.species69
		if(new_f_style && CanUseTopic(user) &&69ob_species.get_facial_hair_styles(pref.gender))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()

	var/datum/species/mob_species = all_species69pref.species69
	var/list/valid_hairstyles =69ob_species.get_hair_styles()

	if(valid_hairstyles.len)
		pref.h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		pref.h_style = GLOB.hair_styles_list69"Bald"69

	pref.h_style = GLOB.hair_styles_list69"Bald"69

/datum/category_item/player_setup_item/proc/ResetFacialHair()

	var/datum/species/mob_species = all_species69pref.species69
	var/list/valid_facialhairstyles =69ob_species.get_facial_hair_styles(pref.gender)

	if(valid_facialhairstyles.len)
		pref.f_style = pick(valid_facialhairstyles)
	else
		//this shouldn't happen
		pref.f_style = GLOB.facial_hair_styles_list69"Shaved"69
	pref.f_style = GLOB.facial_hair_styles_list69"Shaved"69

