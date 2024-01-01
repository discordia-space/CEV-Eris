/datum/category_item/setup_option/core_implant/cruciform
	name = "Cruciform"
	desc = "Soul holder for every NeoTheology disciple."
	implant_type = /obj/item/implant/core_implant/cruciform
	restricted_depts = IRONHAMMER | COMMAND
	allowed_depts = CHURCH
	allow_modifications = FALSE

/datum/category_item/setup_option/core_implant/cyberinterface
	name = "Cyberinterface - Basic"
	desc = "A cyberinterface for the average cyberpunk who can't afford proper ones"
	target_organ = BP_HEAD
	implant_type = /obj/item/implant/cyberinterface
	restricted_depts = CHURCH
	allow_modifications = TRUE

/datum/category_item/setup_option/core_implant/cyberinterface/ihc
	name = "Cyberinterface - IHC Suite"
	desc = "A special cyberinterface designed for IH commanders."
	implant_type = /obj/item/implant/cyberinterface
	allowed_depts = IRONHAMMER
	allowed_jobs = list(/datum/job/ihc)

/datum/category_item/setup_option/core_implant/cyberinterface/technomancer
	name = "Cyberinterface - League's brother"
	desc = "A cyberinterface given to all members of the technomancer's league."
	implant_type = /obj/item/implant/cyberinterface
	allowed_depts = ENGINEERING

/datum/category_item/setup_option/core_implant/cyberinterface/technomancer/leader
	name = "Cyberinterface - League's champhion"
	desc = "A cyberinterface given to all leaders of league tribes."
	implant_type = /obj/item/implant/cyberinterface
	allowed_depts = ENGINEERING
	allowed_jobs = list(/datum/job/chief_engineer)

/datum/category_item/setup_option/core_implant/cyberinterface/moebius
	name = "Cyberinterface - Moebius prototype"
	desc = "A recently developed cyberinterface produced by Moebius. Given to all leaders"
	implant_type = /obj/item/implant/cyberinterface
	allowed_depts = MEDICAL | SCIENCE
	allowed_jobs = list(/datum/job/rd, /datum/job/cmo)

