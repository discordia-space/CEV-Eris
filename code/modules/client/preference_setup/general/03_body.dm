var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 3

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["species"]			>> pref.species
	S["hair_color"]			>> pref.hair_color
	S["facial_color"]		>> pref.facial_color
	S["skin_tone"]			>> pref.s_tone
	S["skin_color"]			>> pref.skin_color
	S["hair_style_name"]	>> pref.h_style
	S["facial_style_name"]	>> pref.f_style
	S["eyes_color"]			>> pref.eyes_color
	S["b_type"]				>> pref.b_type
	S["disabilities"]		>> pref.disabilities
	S["organ_data"]			>> pref.organ_data
	S["rlimb_data"]			>> pref.rlimb_data

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["species"]			<< pref.species
	S["hair_color"]			<< pref.hair_color
	S["facial_color"]		<< pref.facial_color
	S["skin_tone"]			<< pref.s_tone
	S["skin_color"]			<< pref.skin_color
	S["hair_style_name"]	<< pref.h_style
	S["facial_style_name"]	<< pref.f_style
	S["eyes_color"]			<< pref.eyes_color
	S["b_type"]				<< pref.b_type
	S["disabilities"]		<< pref.disabilities
	S["organ_data"]			<< pref.organ_data
	S["rlimb_data"]			<< pref.rlimb_data

/datum/category_item/player_setup_item/general/body/sanitize_character(var/savefile/S)
	if(!pref.species || !(pref.species in playable_species))
		pref.species = "Human"
	pref.hair_color		= iscolor(pref.hair_color) ? pref.hair_color : "#000000"
	pref.facial_color	= iscolor(pref.facial_color) ? pref.facial_color : "#000000"
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.skin_color		= iscolor(pref.skin_color) ? pref.skin_color : "#000000"
	pref.h_style		= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.eyes_color		= iscolor(pref.eyes_color) ? pref.eyes_color : "#000000"
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data) pref.rlimb_data = list()

/datum/category_item/player_setup_item/general/body/content(var/mob/user)
	. = list()
	if(pref.req_update_icon == 1)
		pref.update_preview_icon()
	if(pref.preview_north && pref.preview_south && pref.preview_east && pref.preview_west)
		user << browse_rsc(pref.preview_north, "new_previewicon[NORTH].png")
		user << browse_rsc(pref.preview_south, "new_previewicon[SOUTH].png")
		user << browse_rsc(pref.preview_east, "new_previewicon[EAST].png")
		user << browse_rsc(pref.preview_west, "new_previewicon[WEST].png")

	var/mob_species = all_species[pref.species]
	. += "<table><tr style='vertical-align:top'><td><b>Body</b> "
	. += "(<a href='?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"
	. += "Blood Type: <a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"

	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "Skin Tone: <a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a><br>"
	. += "Needs Glasses: <a href='?src=\ref[src];disabilities=[NEARSIGHTED]'><b>[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br>"

	. += "</td><td><b>Preview</b><br>"
	. += "<br><td style='width:80px;text-align:center'><div class='statusDisplay'><img src=new_previewicon[pref.preview_dir].png height=64 width=64></center></div>"
	. += "<br><a href='?src=\ref[src];rotate=right'>&lt;&lt;&lt;</a> <a href='?src=\ref[src];rotate=left'>&gt;&gt;&gt;</a></td>"
	. += "</td></tr></table>"

	. += "<b>Hair</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> <font face='fixedsys' size='3' color='[pref.hair_color]'><table style='display:inline;' bgcolor='[pref.hair_color]'><tr><td>__</td></tr></table></font> "
	. += " Style: <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>"

	. += "<br><b>Facial</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> <font face='fixedsys' size='3' color='[pref.facial_color]'><table  style='display:inline;' bgcolor='[pref.facial_color]'><tr><td>__</td></tr></table></font> "
	. += " Style: <a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eyes</b><br>"
		. += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> <font face='fixedsys' size='3' color='[pref.eyes_color]'><table  style='display:inline;' bgcolor='[pref.eyes_color]'><tr><td>__</td></tr></table></font><br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color</b><br>"
		. += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> <font face='fixedsys' size='3' color='[pref.skin_color]'><table style='display:inline;' bgcolor='[pref.skin_color]'><tr><td>__</td></tr></table></font><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = all_species[pref.species]

	if(href_list["random"])
		pref.randomize_appearance_for()
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null|anything in valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", pref.hair_color) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.hair_color = new_hair
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = list()
		for(var/hairstyle in hair_styles_list)
			var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue

			valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

		var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference", pref.h_style)  as null|anything in valid_hairstyles
		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", pref.facial_color) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.facial_color = new_facial
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", pref.eyes_color) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.eyes_color = new_eyes
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35)  as num|null
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", pref.skin_color) as color|null
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.skin_color = new_skin
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = list()
		for(var/facialhairstyle in facial_hair_styles_list)
			var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
			if(pref.gender == MALE && S.gender == FEMALE)
				continue
			if(pref.gender == FEMALE && S.gender == MALE)
				continue
			if(!(mob_species.get_bodytype() in S.species_allowed))
				continue

			valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

		var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference", pref.f_style)  as null|anything in valid_facialhairstyles
		if(new_f_style && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.f_style = new_f_style
			pref.req_update_icon = 1
			return TOPIC_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		pref.req_update_icon = 1
		return TOPIC_REFRESH

	else if(href_list["rotate"])
		if(href_list["rotate"] == "right")
			pref.preview_dir = turn(pref.preview_dir,-90)
		else
			pref.preview_dir = turn(pref.preview_dir,90)
		return TOPIC_REFRESH

	return ..()