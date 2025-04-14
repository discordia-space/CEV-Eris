/mob/living/carbon/human/proc/change_appearance(var/flags = APPEARANCE_ALL_HAIR, var/location = src, var/mob/user = src, var/datum/nano_topic_state/state =GLOB.default_state)
	var/datum/nano_module/appearance_changer/AC = new(location, src)
	AC.flags = flags
	AC.nano_ui_interact(user, state = state)

/mob/living/carbon/human/proc/change_species(var/new_species)
	if(!new_species)
		return

	if(species == new_species)
		return

	if(!(new_species in GLOB.all_species))
		return

	set_species(new_species)
	reset_hair()
	return 1

/mob/living/carbon/human/proc/change_name(var/type)
	if (type == "random")
		var/datum/language/L = get_default_language()
		L.set_random_name(src)

	else
		var/newname = input("Choose a name for your character.","Your Name", real_name)
		fully_replace_character_name(real_name, newname)
	to_chat(src, span_notice("Your name is now [real_name]"))

/mob/living/carbon/human/proc/change_gender(var/gender)
	if(src.gender == gender)
		return

	src.gender = gender
	regenerate_icons() //This is overkill, but we do need to update all of the clothing. Maybe there's a more precise call
	//reset_hair()
	//update_body()
	return 1

/mob/living/carbon/human/proc/change_hair(var/hair_style)
	if(!hair_style)
		return

	if(h_style == hair_style)
		return

	if(!(hair_style in GLOB.hair_styles_list))
		return

	h_style = hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair(var/facial_hair_style)
	if(!facial_hair_style)
		return

	if(f_style == facial_hair_style)
		return

	if(!(facial_hair_style in GLOB.facial_hair_styles_list))
		return

	f_style = facial_hair_style

	update_hair()
	return 1

/mob/living/carbon/human/proc/reset_hair()
	var/list/valid_hairstyles = generate_valid_hairstyles()
	var/list/valid_facial_hairstyles = generate_valid_facial_hairstyles()

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		h_style = "Bald"

	if(valid_facial_hairstyles.len)
		f_style = pick(valid_facial_hairstyles)
	else
		//this shouldn't happen
		f_style = "Shaved"

	update_hair()

/mob/living/carbon/human/proc/change_eye_color(var/color)
	if(color == eyes_color)
		return

	eyes_color = color

	update_eyes()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_hair_color(var/color)
	if(color == hair_color)
		return

	hair_color = color

	force_update_limbs()
	update_body()
	update_hair()
	return 1

/mob/living/carbon/human/proc/change_facial_hair_color(var/color)
	if(color == facial_color)
		return

	facial_color = color

	update_hair()
	return 1

/mob/living/carbon/human/proc/change_skin_color(var/color)
	if(color == skin_color || !(species.appearance_flags & HAS_SKIN_COLOR))
		return

	skin_color = color

	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/change_skin_tone(var/tone)
	if(s_tone == tone || !(species.appearance_flags & HAS_SKIN_TONE))
		return

	s_tone = tone

	force_update_limbs()
	update_body()
	return 1

/mob/living/carbon/human/proc/generate_valid_species()
	return GLOB.all_species

/mob/living/carbon/human/proc/generate_valid_hairstyles(var/check_gender = 1)
	. = list()
	var/list/hair_styles = species.get_hair_styles()
	for(var/hair_style in hair_styles)
		var/datum/sprite_accessory/S = hair_styles[hair_style]
		if(check_gender)
			if(gender == MALE && S.gender == FEMALE)
				continue
			if(gender == FEMALE && S.gender == MALE)
				continue
		.[hair_style] = S

/mob/living/carbon/human/proc/generate_valid_facial_hairstyles()
	return species.get_facial_hair_styles(gender)

/mob/living/carbon/human/proc/force_update_limbs()
	for(var/obj/item/organ/external/O in organs)
		O.sync_colour_to_human(src)
	update_body(0)

/mob/living/carbon/human/proc/randomize_appearance()
	hair_color = rgb(25 * rand(3,8),25 * rand(1,3),25 * rand(1,3)) //curated hair color
	change_skin_tone(roll("1d20") * -10) //skintone randomization borrowed from corpse spawner. Increment by 10 to increase variance
	change_hair(pick(GLOB.hair_styles_list)) //pick from hairstyles
	change_hair_color(hair_color)
	change_facial_hair_color(hair_color)
	age = rand(20,50)
	//set gender and gender specific traits
	var/gender = pick(MALE, FEMALE)
	var/list/tts_voices = new()
	if(gender == FEMALE) //defaults are MALE so check for FEMALE first, use MALE as default case
		change_gender(gender)
		tts_voices += TTS_SEED_DEFAULT_FEMALE //Failsafe voice
	else
		change_facial_hair(pick(GLOB.facial_hair_styles_list)) //pick a random facial hair
		tts_voices += TTS_SEED_DEFAULT_MALE //Failsafe voice
	real_name = species.get_random_name(gender) //set name according to gender
	//Set voice based on gender
	for(var/i in tts_seeds) //from tts_seeds, add voices that match gender tag to list tts_voices
		var/list/V = tts_seeds[i]
		if((V["gender"] == gender || V["category"] == "any") && (V["category"] == "human" || V["gender"] == "any")) //cribbed from /code/modules/client/preference_setup/general/01_basic.dm
			tts_voices += i
	tts_seed = pick(tts_voices) //pick a random voice from list tts_voices
