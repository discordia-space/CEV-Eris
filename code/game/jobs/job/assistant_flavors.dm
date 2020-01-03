/datum/job_flavor
	var/title
	var/list/also_known_languages
	var/outfit_type
	var/list/stat_modifiers
	var/list/perks

//
// Vagabonds
//
/datum/job_flavor/vagabond/stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)


// Cosmic Exploration Vessel
/datum/job_flavor/vagabond/cosmic

/datum/job_flavor/vagabond/cosmic/assistant
	title = "Assistant"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5, LANGUAGE_JIVE = 25)
	outfit_type = /decl/hierarchy/outfit/job/assistant
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/cosmic/crewman
	title = "Crewman"
	outfit_type = /decl/hierarchy/outfit/job/crewman
	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
		STAT_BIO = 10,
		STAT_MEC = 10,
		STAT_VIG = 10,
		STAT_COG = 10
	)

/datum/job_flavor/vagabond/veterinarian
	title = "Cattle Export Vehicle \"Eris\" Veterinarian"

/datum/job_flavor/vagabond/shepherd
	title = "Cattle Export Vehicle \"Eris\" Shepherd"

/datum/job_flavor/vagabond/colonist
	title = "Colony Expansion Vehicle \"Eris\" Colonist"

/datum/job_flavor/vagabond/geoengineer
	title = "Colony Expansion Vehicle \"Eris\" Geoengineer"

/datum/job_flavor/vagabond/ecologist
	title = "Colony Expansion Vehicle \"Eris\" Ecologist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/ensign
	title = "Command Evacuation Vehicle \"Eris\" Ensign"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/pilot
	title = "Command Evacuation Vehicle \"Eris\" Pilot"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/cmcp_janitor
	title = "Command Evacuation Vehicle \"Eris\" Command Master Chief Petty Janitor"

/datum/job_flavor/vagabond/dc_tech
	title = "Combat Engineer Vehicle \"Eris\" Damage Control Technician"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 16,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/field_eng
	title = "Combat Engineer Vehicle \"Eris\" Field Engineer"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 16,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/politruk
	title = "Cosmicheskiy Edinstveniy Velikohod \"Eris\" Politruk"

/datum/job_flavor/vagabond/krasnoarmeets
	title = "Cosmicheskiy Edinstveniy Velikohod \"Eris\" Krasnoarmeets"

/datum/job_flavor/vagabond/kosmonavt
	title = "Cosmicheskiy Edinstveniy Velikohod \"Eris\" Kosmonavt"
	stat_modifiers = list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 16,
		STAT_MEC = 16,
		STAT_VIG = 16,
		STAT_COG = 16
	)

/datum/job_flavor/vagabond/reg_officer
	title = "Czech Emigration Vessel \"Eris\" Registration Officer"

/datum/job_flavor/vagabond/refugee
	title = "Czech Emigration Vessel \"Eris\" Refugee"

/datum/job_flavor/vagabond/mig_officer
	title = "Czech Emigration Vessel \"Eris\" Emigration Officer"

/datum/job_flavor/vagabond/protein_farmer
	title = "Cockroach Exile Vessel \"Eris\" Protein Farmer"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/biotechnician
	title = "Cockroach Exile Vessel \"Eris\" Biotechnician"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/bioterror_spec
	title = "Cockroach Exile Vessel \"Eris\" Bioterror Specialist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/bomber
	title = "Capital Extermination Vessel \"Eris\" Bomber"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/m_arms
	title = "Capital Extermination Vessel \"Eris\" Master at Arms"
	stat_modifiers = list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/vagabond/loader
	title = "Capital Extermination Vessel \"Eris\" Loader"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
	)

/datum/job_flavor/vagabond/cat_psy
	title = "Cat Exhibition Vessel \"Eris\" Cat Psychologist"

/datum/job_flavor/vagabond/feline_herder
	title = "Cat Exhibition Vessel \"Eris\" Feline Herder"

/datum/job_flavor/vagabond/breeder
	title = "Cat Exhibition Vessel \"Eris\" Breeder"

/datum/job_flavor/vagabond/mixologist
	title = "Corporate Entertain Vehicle \"Eris\" Mixologist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
	)

/datum/job_flavor/vagabond/stripper
	title = "Corporate Entertain Vehicle \"Eris\" Stripper"

/datum/job_flavor/vagabond/officiant
	title = "Corporate Entertain Vehicle \"Eris\" Officiant"

/datum/job_flavor/vagabond/quartermaster
	title = "Class \"Emigrator\" Vessel \"Eris\" Quartermaster"

/datum/job_flavor/vagabond/deck_chief
	title = "Class \"Emigrator\" Vessel \"Eris\" Deck Chief"

/datum/job_flavor/vagabond/deck_tech
	title = "Class \"Emigrator\" Vessel \"Eris\" Deck Technician"

/datum/job_flavor/vagabond/patriarch
	title = "Christian Era Vector \"Eris\" Patriarch"

/datum/job_flavor/vagabond/protodeacon
	title = "Christian Era Vector \"Eris\" Protodeacon"

/datum/job_flavor/vagabond/archimandrite
	title = "Christian Era Vector \"Eris\" Archimandrite"
