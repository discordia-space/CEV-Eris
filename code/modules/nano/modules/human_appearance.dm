/datum/nano_module/appearance_changer
	name = "Appearance Editor"
	available_to_ai = FALSE
	var/flags = APPEARANCE_ALL_HAIR
	var/mob/living/carbon/human/owner =69ull
	var/list/valid_species = list()
	var/list/valid_hairstyles = list()
	var/list/valid_facial_hairstyles = list()

	var/check_whitelist
	var/list/whitelist
	var/list/blacklist



/datum/nano_module/appearance_changer/New(var/location,69ar/mob/living/carbon/human/H,69ar/check_species_whitelist = 1,69ar/list/species_whitelist = list("human"),69ar/list/species_blacklist = list())
	..()
	owner = H
	src.check_whitelist = check_species_whitelist
	src.whitelist = species_whitelist
	src.blacklist = species_blacklist


/datum/nano_module/appearance_changer/Topic(ref, href_list,69ar/datum/topic_state/state = GLOB.default_state)
	if(..())
		return 1

	if(href_list69"name"69)
		if(can_change(APPEARANCE_NAME))
			if(owner.change_name(href_list69"name"69))
				cut_and_generate_data()
				return 1

	if(href_list69"race"69)
		if(can_change(APPEARANCE_RACE) && (href_list69"race"69 in69alid_species))
			if(owner.change_species(href_list69"race"69))
				cut_and_generate_data()
				return 1
	if(href_list69"gender"69)
		if(can_change(APPEARANCE_GENDER) && (href_list69"gender"69 in owner.species.genders))
			if(owner.change_gender(href_list69"gender"69))
				cut_and_generate_data()
				return 1
	//if(href_list69"skin_tone"69)
		// TODO: enable after baymed
		/*if(can_change_skin_tone())
			var/new_s_tone = input(usr, "Choose your character's skin-tone:\n1 (lighter) - 69owner.species.max_skin_tone()69 (darker)", "Skin Tone", -owner.s_tone + 35) as69um|null
			if(isnum(new_s_tone) && can_still_topic(state))// && owner.species.appearance_flags & HAS_SKIN_TONE_NORMAL)	// TODO: enable after baymed
				new_s_tone = 35 -69ax(min(round(new_s_tone), owner.species.max_skin_tone()), 1)
				return owner.change_skin_tone(new_s_tone)*/
	if(href_list69"skin_color"69)
		if(can_change_skin_color())
			var/new_skin = input(usr, "Choose your character's skin colour: ", "Skin Color", owner.skin_color) as color|null
			if(new_skin && can_still_topic(state))
				if(owner.change_skin_color(new_skin))
					update_dna()
					return 1
	if(href_list69"hair"69)
		if(can_change(APPEARANCE_HAIR) && (href_list69"hair"69 in69alid_hairstyles))
			if(owner.change_hair(href_list69"hair"69))
				update_dna()
				return 1
	if(href_list69"hair_color"69)
		if(can_change(APPEARANCE_HAIR_COLOR))
			var/new_hair = input("Please select hair color.", "Hair Color", owner.hair_color) as color|null
			if(new_hair && can_still_topic(state))
				if(owner.change_hair_color(new_hair))
					update_dna()
					return 1
	if(href_list69"facial_hair"69)
		if(can_change(APPEARANCE_FACIAL_HAIR) && (href_list69"facial_hair"69 in69alid_facial_hairstyles))
			if(owner.change_facial_hair(href_list69"facial_hair"69))
				update_dna()
				return 1
	if(href_list69"facial_hair_color"69)
		if(can_change(APPEARANCE_FACIAL_HAIR_COLOR))
			var/new_facial = input("Please select facial hair color.", "Facial Hair Color", owner.facial_color) as color|null
			if(new_facial && can_still_topic(state))
				if(owner.change_facial_hair_color(new_facial))
					update_dna()
					return 1
	if(href_list69"eye_color"69)
		if(can_change(APPEARANCE_EYE_COLOR))
			var/new_eyes = input("Please select eye color.", "Eye Color", owner.eyes_color) as color|null
			if(new_eyes && can_still_topic(state))
				if(owner.change_eye_color(new_eyes))
					update_dna()
					return 1

	return 0

/datum/nano_module/appearance_changer/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(!owner || !owner.species)
		return

	generate_data(check_whitelist, whitelist, blacklist)
	var/list/data = host.initial_data()

	data69"change_name"69 = can_change(APPEARANCE_NAME)
	if (data69"change_name"69)
		data69"name"69 = owner.real_name
	data69"specimen"69 = owner.species.name
	data69"gender"69 = owner.gender
	data69"change_race"69 = can_change(APPEARANCE_RACE)
	if(data69"change_race"69)
		var/species69069
		for(var/specimen in69alid_species)
			species69++species.len69 =  list("specimen" = specimen)
		data69"species"69 = species

	data69"change_gender"69 = can_change(APPEARANCE_GENDER)
	if(data69"change_gender"69)
		var/genders69069
		for(var/gender in owner.species.genders)
			genders69++genders.len69 =  list("gender_name" = gender2text(gender), "gender_key" = gender)
		data69"genders"69 = genders

	data69"change_skin_tone"69 = can_change_skin_tone()
	data69"change_skin_color"69 = can_change_skin_color()
	data69"change_eye_color"69 = can_change(APPEARANCE_EYE_COLOR)
	data69"change_hair"69 = can_change(APPEARANCE_HAIR)
	if(data69"change_hair"69)
		var/hair_styles69069
		for(var/hair_style in69alid_hairstyles)
			hair_styles69++hair_styles.len69 = list("hairstyle" = hair_style)
		data69"hair_styles"69 = hair_styles
		data69"hair_style"69 = owner.h_style

	data69"change_facial_hair"69 = can_change(APPEARANCE_FACIAL_HAIR)
	if(data69"change_facial_hair"69)
		var/facial_hair_styles69069
		for(var/facial_hair_style in69alid_facial_hairstyles)
			facial_hair_styles69++facial_hair_styles.len69 = list("facialhairstyle" = facial_hair_style)
		data69"facial_hair_styles"69 = facial_hair_styles
		data69"facial_hair_style"69 = owner.f_style

	data69"change_hair_color"69 = can_change(APPEARANCE_HAIR_COLOR)
	data69"change_facial_hair_color"69 = can_change(APPEARANCE_FACIAL_HAIR_COLOR)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "appearance_changer.tmpl", "69src69", 800, 450, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/appearance_changer/proc/update_dna()
	if(owner && (flags & APPEARANCE_UPDATE_DNA))
		owner.update_dna()

/datum/nano_module/appearance_changer/proc/can_change(var/flag)
	return owner && (flags & flag)

/datum/nano_module/appearance_changer/proc/can_change_skin_tone()
	return owner && (flags & APPEARANCE_SKIN)// && owner.species.appearance_flags & HAS_A_SKIN_TONE	// TODO: enable after baymed

/datum/nano_module/appearance_changer/proc/can_change_skin_color()
	return owner && (flags & APPEARANCE_SKIN) && owner.species.appearance_flags & HAS_SKIN_COLOR

/datum/nano_module/appearance_changer/proc/cut_and_generate_data()
	//69aking the assumption that the available species remain constant
	valid_facial_hairstyles.Cut()
	valid_facial_hairstyles.Cut()
	generate_data()

/datum/nano_module/appearance_changer/proc/generate_data()
	if(!owner)
		return
	if(!valid_species.len)
		valid_species = owner.generate_valid_species(check_whitelist, whitelist, blacklist)
	if(!valid_hairstyles.len || !valid_facial_hairstyles.len)
		valid_hairstyles = owner.generate_valid_hairstyles(check_gender = 0)
		valid_facial_hairstyles = owner.generate_valid_facial_hairstyles()
