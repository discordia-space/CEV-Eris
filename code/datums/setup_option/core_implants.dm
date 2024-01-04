/datum/category_item/setup_option/core_implant/cruciform
	name = "Cruciform"
	desc = "Soul holder for every NeoTheology disciple."
	implant_type = /obj/item/implant/core_implant/cruciform
	restricted_depts = IRONHAMMER | COMMAND
	allowed_depts = CHURCH
	allow_modifications = FALSE

/// WARNING , DON'T PUT ` in the names . they break the option selection!!! SPCR - first day of 2024
/datum/category_item/setup_option/core_implant/cyberinterface
	name = "Cyberinterface - Basic"
	desc = "A cyberinterface for the average cyberpunk who can't afford proper ones"
	target_organ = BP_HEAD
	implant_type = /obj/item/implant/cyberinterface/basic
	restricted_depts = ALLDEPS
	allowed_depts = SERVICE | GUILD | IRONHAMMER | MEDICAL | SCIENCE
	allow_modifications = TRUE

/datum/category_item/setup_option/core_implant/cyberinterface/ihc
	name = "Cyberinterface - IH command suite"
	desc = "A special cyberinterface designed for IH commanders & sergeants."
	restricted_depts = ALLDEPS
	implant_type = /obj/item/implant/cyberinterface/ironhammer
	allowed_depts = null
	allowed_jobs = list(/datum/job/ihc, /datum/job/gunserg)

/datum/category_item/setup_option/core_implant/cyberinterface/technomancer
	name = "Cyberinterface - League brother"
	desc = "A cyberinterface given to all members of the technomancer's league."
	implant_type = /obj/item/implant/cyberinterface/league
	restricted_depts = ALLDEPS
	allowed_depts = ENGINEERING | TECHNOMANCER

/datum/category_item/setup_option/core_implant/cyberinterface/technomancer/leader
	name = "Cyberinterface - League champion"
	desc = "A cyberinterface given to all leaders of league tribes."
	implant_type = /obj/item/implant/cyberinterface/league/leader
	restricted_depts = ALLDEPS
	allowed_depts = null
	allowed_jobs = list(/datum/job/chief_engineer)

/datum/category_item/setup_option/core_implant/cyberinterface/moebius
	name = "Cyberinterface - Moebius prototype"
	desc = "A recently developed cyberinterface produced by Moebius. Given to all leaders"
	implant_type = /obj/item/implant/cyberinterface/moebius
	restricted_depts = ALLDEPS
	allowed_depts = null
	allowed_jobs = list(/datum/job/rd, /datum/job/cmo)

// They better not make jokes about edging with this one , SPCR-2024
/datum/category_item/setup_option/core_implant/cyberinterface/guild_command
	name = "Cyberinterface - Guilds edge"
	desc = "A advanced cyberinterface, given to the top ranks in the Aster's guild."
	implant_type = /obj/item/implant/cyberinterface/asters
	restricted_depts = ALLDEPS
	allowed_depts = null
	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/merchant)
