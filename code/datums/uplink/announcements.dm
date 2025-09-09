/****************
* Announcements *
*****************/
/datum/uplink_item/abstract/announcements
	category = /datum/uplink_category/services

/datum/uplink_item/abstract/announcements/buy(var/obj/item/device/uplink/U, var/mob/user)
	. = ..()
	if(.)
		log_and_message_admins("has triggered a falsified [src]", user)

/datum/uplink_item/abstract/announcements/announce
	name = "Shipwide Announcement"
	item_cost = 1
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	desc = "Broadcasts a message anonymously to the entire vessel. Triggers immediately after supplying additional data."
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/announce/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/args)
	var/message = input(user, "What would you like the text of the announcement to be? Write as much as you like, The title will appear as Unknown Broadcast", "False Announcement") as text|null
	if (!message)
		return FALSE
	command_announcement.Announce(message, "Unknown Broadcast", use_text_to_speech = TRUE)
	return 1

/datum/uplink_item/abstract/announcements/fake_crew_arrival
	name = "Crew Arrival Announcement/Records"
	desc = "Creates a fake crew arrival announcement as well as fake crew records, using your current appearance (including held items!) and worn id card. Trigger with care!"
	item_cost = 6
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_crew_arrival/New()
	..()
	antag_roles = list(ROLE_MERCENARY)

/datum/uplink_item/abstract/announcements/fake_crew_arrival/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/user, var/list/args)
	if(!user)
		return 0

	var/obj/item/card/id/I = user.GetIdCard()
	var/datum/computer_file/report/crew_record/random_record
	if(GLOB.all_crew_records.len)
		random_record = pick(GLOB.all_crew_records)

	var/datum/computer_file/report/crew_record/general = new()
	if(I)
		general.set_age(I.age)
		general.set_job(I.assignment)
		general.set_name(I.registered_name)
		general.set_sex(I.sex)
	else
		var/mob/living/carbon/human/H
		if(ishuman(user))
			H = user
			general.set_age(H.age)
		else
			general.set_age(initial(H.age))
		var/assignment = GetAssignment(user)
		general.set_job(assignment)
		general.set_department(args["department"])
		general.set_name(user.real_name)
		general.set_sex(capitalize(user.gender))

	general.set_species(user.get_species())

	if(random_record)
		general.set_fingerprint(random_record.get_fingerprint())
		general.set_bloodtype(random_record.get_bloodtype())
		general.set_dna(random_record.get_bloodtype())

	if(I)
		general.set_fingerprint(I.fingerprint_hash)
		general.set_bloodtype(I.blood_type)
		general.set_dna(I.dna_hash)

	AnnounceArrival(general.get_name(), general.get_job(), "has completed cryogenic revival")
	return 1

/datum/uplink_item/abstract/announcements/fake_ion_storm
	name = "Ion Storm Announcement"
	desc = "Interferes with the ship's ion sensors. Triggers immediately upon investment."
	item_cost = 2
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_ion_storm/get_goods(var/obj/item/device/uplink/U, var/loc)
	ion_storm_announcement()
	return 1

/datum/uplink_item/abstract/announcements/fake_radiation
	name = "Radiation Storm Announcement"
	desc = "Interferes with the ship's radiation sensors. Triggers immediately upon investment."
	item_cost = 4
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_radiation/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/datum/event/radiation_storm/syndicate/S =  new(null, EVENT_LEVEL_MODERATE)
	S.Initialize()
	return 1

/datum/uplink_item/abstract/announcements/fake_serb
	name = "Unknown ship Announcement"
	desc = "Interferes with the ship's array sensors. Triggers immediately upon investment."
	item_cost = 3
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)

/datum/uplink_item/abstract/announcements/fake_serb/get_goods(var/obj/item/device/uplink/U, var/loc)
	var/datum/shuttle/autodock/multi/antag/mercenary/merc = /datum/shuttle/autodock/multi/antag/mercenary
	command_announcement.Announce(initial(merc.arrival_message), initial(merc.announcer) || "[boss_name]")
	qdel(merc)
	return 1
