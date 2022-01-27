/datum/preferences
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/memory = ""

/datum/category_item/player_setup_item/physical/records
	name = "Records"
	sort_order = 5

/datum/category_item/player_setup_item/physical/records/load_character(var/savefile/S)
	from_file(S69"med_record"69,pref.med_record)
	from_file(S69"sec_record"69,pref.sec_record)
	from_file(S69"gen_record"69,pref.gen_record)
	from_file(S69"memory"69,pref.memory)

/datum/category_item/player_setup_item/physical/records/save_character(var/savefile/S)
	to_file(S69"med_record"69,pref.med_record)
	to_file(S69"sec_record"69,pref.sec_record)
	to_file(S69"gen_record"69,pref.gen_record)
	to_file(S69"memory"69,pref.memory)

/datum/category_item/player_setup_item/physical/records/content(var/mob/user)
	. = list()
	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Medical Records: "
		. += "<a href='?src=\ref69src69;set_medical_records=1'>69TextPreview(pref.med_record,40)69</a><br>"
		. += "Employment Records: "
		. += "<a href='?src=\ref69src69;set_general_records=1'>69TextPreview(pref.gen_record,40)69</a><br>"
		. += "Security Records: "
		. += "<a href='?src=\ref69src69;set_security_records=1'>69TextPreview(pref.sec_record,40)69</a><br>"
		. += "Memory: "
		. += "<a href='?src=\ref69src69;set_memory=1'>69TextPreview(pref.memory,40)69</a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/records/OnTopic(var/href,var/list/href_list,69ar/mob/user)
	if(href_list69"set_medical_records"69)
		var/new_medical = sanitize(input(user,"Enter69edical information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as69essage|null,69AX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list69"set_general_records"69)
		var/new_general = sanitize(input(user,"Enter employment information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as69essage|null,69AX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list69"set_security_records"69)
		var/sec_medical = sanitize(input(user,"Enter security information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as69essage|null,69AX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list69"set_memory"69)
		var/memes = sanitize(input(user,"Enter69emorized information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as69essage|null,69AX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(memes) && CanUseTopic(user))
			pref.memory =69emes
		return TOPIC_REFRESH

	. =  ..()
