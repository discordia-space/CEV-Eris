/datum/job_flavor
	var/title
	var/list/stat_modifiers

/datum/job_flavor/assistant/stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/veterinarian
	title = "Cattle Export Vehicle \"Eris\" Veterinarian"

/datum/job_flavor/assistant/shepherd
	title = "Cattle Export Vehicle \"Eris\" Shepherd"

/datum/job_flavor/assistant/colonist
	title = "Colony Expansion Vehicle \"Eris\" Colonist"

/datum/job_flavor/assistant/geoengineer
	title = "Colony Expansion Vehicle \"Eris\" Geoengineer"

/datum/job_flavor/assistant/ecologist
	title = "Colony Expansion Vehicle \"Eris\" Ecologist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/ensign
	title = "Command Evacuation Vehicle \"Eris\" Ensign"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/pilot
	title = "Command Evacuation Vehicle \"Eris\" Pilot"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/cmcp_janitor
	title = "Command Evacuation Vehicle \"Eris\" Command Master Chief Petty Janitor"

/datum/job_flavor/assistant/dc_tech
	title = "Combat Engineer Vehicle \"Eris\" Damage Control Technician"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 16,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/field_eng
	title = "Combat Engineer Vehicle \"Eris\" Field Engineer"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 16,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/politruk
	title = "Cosmicheskiy Edinstveniy Velikohod \"Eris\" Politruk"

/datum/job_flavor/assistant/krasnoarmeets
	title = "Cosmicheskiy Edinstveniy Velikohod \"Eris\" Krasnoarmeets"

/datum/job_flavor/assistant/kosmonavt
	title = "Cosmicheskiy Edinstveniy Velikohod \"Eris\" Kosmonavt"
	stat_modifiers = list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 16,
		STAT_MEC = 16,
		STAT_VIG = 16,
		STAT_COG = 16
	)

/datum/job_flavor/assistant/reg_officer
	title = "Czech Emigration Vessel \"Eris\" Registration Officer"

/datum/job_flavor/assistant/refugee
	title = "Czech Emigration Vessel \"Eris\" Refugee"

/datum/job_flavor/assistant/mig_officer
	title = "Czech Emigration Vessel \"Eris\" Emigration Officer"

/datum/job_flavor/assistant/protein_farmer
	title = "Cockroach Exile Vessel \"Eris\" Protein Farmer"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/biotechnician
	title = "Cockroach Exile Vessel \"Eris\" Biotechnician"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/bioterror_spec
	title = "Cockroach Exile Vessel \"Eris\" Bioterror Specialist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/bomber
	title = "Capital Extermination Vessel \"Eris\" Bomber"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/m_arms
	title = "Capital Extermination Vessel \"Eris\" Master at Arms"
	stat_modifiers = list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/loader
	title = "Capital Extermination Vessel \"Eris\" Loader"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
	)

/datum/job_flavor/assistant/cat_psy
	title = "Cat Exhibition Vessel \"Eris\" Cat Psychologist"

/datum/job_flavor/assistant/feline_herder
	title = "Cat Exhibition Vessel \"Eris\" Feline Herder"

/datum/job_flavor/assistant/breeder
	title = "Cat Exhibition Vessel \"Eris\" Breeder"

/datum/job_flavor/assistant/mixologist
	title = "Corporate Entertain Vehicle \"Eris\" Mixologist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
	)

/datum/job_flavor/assistant/stripper
	title = "Corporate Entertain Vehicle \"Eris\" Stripper"

/datum/job_flavor/assistant/officiant
	title = "Corporate Entertain Vehicle \"Eris\" Officiant"

/datum/job_flavor/assistant/quartermaster
	title = "Class \"Emigrator\" Vessel \"Eris\" Quartermaster"

/datum/job_flavor/assistant/deck_chief
	title = "Class \"Emigrator\" Vessel \"Eris\" Deck Chief"

/datum/job_flavor/assistant/deck_tech
	title = "Class \"Emigrator\" Vessel \"Eris\" Deck Technician"

/datum/job_flavor/assistant/patriarch
	title = "Christian Era Vector \"Eris\" Patriarch"

/datum/job_flavor/assistant/protodeacon
	title = "Christian Era Vector \"Eris\" Protodeacon"

/datum/job_flavor/assistant/archimandrite
	title = "Christian Era Vector \"Eris\" Archimandrite"
