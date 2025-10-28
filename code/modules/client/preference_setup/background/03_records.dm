/datum/preferences
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/memory = ""

/datum/category_item/player_setup_item/background/records
	name = "Records"
	sort_order = 5

/datum/category_item/player_setup_item/background/records/load_character(var/savefile/S)
	from_file(S["med_record"],pref.med_record)
	from_file(S["sec_record"],pref.sec_record)
	from_file(S["gen_record"],pref.gen_record)
	from_file(S["memory"],pref.memory)

/datum/category_item/player_setup_item/background/records/save_character(var/savefile/S)
	to_file(S["memory"],pref.memory)

/datum/category_item/player_setup_item/background/records/content(var/mob/user)
	. = list()
	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		if(pref.med_record)
			. += "Medical Records: "
			. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br>"
		if(pref.gen_record)
			. += "Employment Records: "
			. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br>"
		if(pref.sec_record)
			. += "Security Records: "
			. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"
		. += "Memory: "
		. += "<a href='?src=\ref[src];set_memory=1'>[TextPreview(pref.memory,40)]</a><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/background/records/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["set_medical_records"])
		input(user,"Read medical information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as message|null
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		input(user,"Read employment information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as message|null
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		input(user,"Read security information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as message|null
		return TOPIC_REFRESH

	else if(href_list["set_memory"])
		var/memes = sanitize(input(user,"Enter memorized information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(memes) && CanUseTopic(user))
			pref.memory = memes
		return TOPIC_REFRESH

	. =  ..()

/datum/category_item/player_setup_item/background/records/proc/load_record(savefile/S, recordtype)
	var/recordgiven = S["[recordtype]"]
	if(S["version"] >= 19)
		if(!recordgiven || !(recordtype in pref.vars))
			return FALSE

		if(istype(recordgiven, /datum/storedrecord))
			pref.vars[recordtype] = recordgiven
	else
		if(istext(recordgiven) && (recordtype in pref.vars))
			pref.vars[recordtype] = recordgiven



/datum/storedrecord

/datum/storedrecord/proc/transfertocomputer(datum/report_field/tofile)
	// nobody here.
/datum/storedrecord/security
	var/list/crimes = list()
	var/list/evidence = list()
	var/list/locations = list()


/datum/storedrecord/security/transfertocomputer(datum/report_field/tofile)
	if(!istype(tofile, /datum/report_field/arraylinkage))
		return FALSE
	var/datum/report_field/arraylinkage/toset = tofile
	toset.arrays = list()
	toset.arrays["crimes"] = crimes // edit these appropriately on any changes
	toset.arrays["evidence"] = evidence // don't forget to synch these indexes
	toset.arrays["locations"] = locations

/datum/storedrecord/security/default // used by default
	crimes = list("No crimes on record.")
	evidence = list("N/A.")
	locations = list("N/A.")


/datum/storedrecord/medical
	var/list/prosthetics = list()
	var/list/wounds = list()
	var/list/bodystate = list()
	var/list/chemhistory = list()
	var/list/psychological = list()


/datum/storedrecord/medical/transfertocomputer(datum/report_field/tofile)
	if(!istype(tofile, /datum/report_field/arrayclump))
		return FALSE
	var/datum/report_field/arrayclump/toset = tofile
	var/list/tochange = toset.value
	tochange["prosthetics"] = prosthetics // change these appropriately as well
	tochange["wounds"] = wounds // but as an arrayclump, they don't need synchronized indexing
	tochange["Body state"] = bodystate
	tochange["chemhistory"] = chemhistory
	tochange["psychological"] = psychological


/datum/storedrecord/medical/default // used by default
	prosthetics = list("No prosthetics on record.")
	wounds = list("No wounds on record.")
	bodystate = list("Alive at time of writing.")
	chemhistory = list("Chemical record is clean.")
	psychological = list("No psychological profiling has been done at time of writing.")


/datum/storedrecord/general
	var/background // background is defined by fates
	var/origin // origin is defined by origin




/datum/storedrecord/general/default // used by default
	background = list("Unremarkable.")
	origin = list("Origin unknown.")

