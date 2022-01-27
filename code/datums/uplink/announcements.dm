/****************
* Announcements *
*****************/
/datum/uplink_item/abstract/announcements
	category = /datum/uplink_category/services

/datum/uplink_item/abstract/announcements/buy(var/obj/item/device/uplink/U,69ar/mob/user)
	. = ..()
	if(.)
		log_and_message_admins("has triggered a falsified 69src69", user)

/datum/uplink_item/abstract/announcements/announce
	name = "Shipwide Announcement"
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	desc = "Broadcasts a69essage anonymously to the entire69essel. Triggers immediately after supplying additional data."
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/announce/get_goods(var/obj/item/device/uplink/U,69ar/loc,69ar/mob/user,69ar/list/args)
	var/message = input(user, "What would you like the text of the announcement to be? Write as69uch as you like, The title will appear as Unknown Broadcast", "False Announcement") as text|null
	if (!message)
		return FALSE
	command_announcement.Announce(message, "Unknown Broadcast")
	return 1

/datum/uplink_item/abstract/announcements/fake_crew_arrival
	name = "Crew Arrival Announcement/Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Trigger with care!"
	item_cost = 6
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_crew_arrival/New()
	..()
	antag_roles = list(ROLE_MERCENARY)

/datum/uplink_item/abstract/announcements/fake_crew_arrival/get_goods(var/obj/item/device/uplink/U,69ar/loc,69ar/mob/user,69ar/list/args)
	if(!user)
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	var/datum/data/record/random_general_record
	var/datum/data/record/random_medical_record
	if(data_core.general.len)
		random_general_record	= pick(data_core.general)
		random_medical_record	= find_medical_record("id", random_general_record.fields69"id"69)

	var/datum/data/record/general = data_core.CreateGeneralRecord(user)
	if(I)
		general.fields69"age"69 = I.age
		general.fields69"rank"69 = I.assignment
		general.fields69"real_rank"69 = I.assignment
		general.fields69"name"69 = I.registered_name
		general.fields69"sex"69 = I.sex
	else
		var/mob/living/carbon/human/H
		if(ishuman(user))
			H = user
			general.fields69"age"69 = H.age
		else
			general.fields69"age"69 = initial(H.age)
		var/assignment = GetAssignment(user)
		general.fields69"rank"69 = assignment
		general.fields69"real_rank"69 = assignment
		general.fields69"name"69 = user.real_name
		general.fields69"sex"69 = capitalize(user.gender)

	general.fields69"species"69 = user.get_species()
	var/datum/data/record/medical = data_core.CreateMedicalRecord(general.fields69"name"69, general.fields69"id"69)
	data_core.CreateSecurityRecord(general.fields69"name"69, general.fields69"id"69)

	if(!random_general_record)
		general.fields69"fingerprint"69 	= random_general_record.fields69"fingerprint"69
	if(random_medical_record)
		medical.fields69"b_type"69		= random_medical_record.fields69"b_type"69
		medical.fields69"b_dna"69			= random_medical_record.fields69"b_type"69

	if(I)
		general.fields69"fingerprint"69 	= I.fingerprint_hash
		medical.fields69"b_type"69	= I.blood_type
		medical.fields69"b_dna"69		= I.dna_hash

	AnnounceArrival(general.fields69"name"69, general.fields69"rank"69, "has completed cryogenic revival")
	return 1

/datum/uplink_item/abstract/announcements/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "Interferes with the ship's ion sensors. Triggers immediately upon investment."
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_ion_storm/get_goods(var/obj/item/device/uplink/U,69ar/loc)
	ion_storm_announcement()
	return 1

/datum/uplink_item/abstract/announcements/fake_radiation
	name = "Radiation Storm Announcement"
	desc = "Interferes with the ship's radiation sensors. Triggers immediately upon investment."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_radiation/get_goods(var/obj/item/device/uplink/U,69ar/loc)
	var/datum/event/radiation_storm/syndicate/S =  new(null, EVENT_LEVEL_MODERATE)
	S.Initialize()
	return 1

/datum/uplink_item/abstract/announcements/fake_serb
	name = "Unknown ship Announcement"
	desc = "Interferes with the ship's array sensors. Triggers immediately upon investment."
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_serb/get_goods(var/obj/item/device/uplink/U,69ar/loc)
	var/datum/shuttle/autodock/multi/antag/mercenary/merc = /datum/shuttle/autodock/multi/antag/mercenary
	command_announcement.Announce(initial(merc.arrival_message), initial(merc.announcer) || "69boss_name69")
	qdel(merc)
	return 1
