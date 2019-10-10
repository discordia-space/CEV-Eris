/datum/job_flavor
	var/title				//Forced title
	var/list/stat_modifiers
	var/prefixtitle
	var/maintitle
	var/customisible_mainassigment = 0

/datum/job_flavor/assistant
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)
	customisible_mainassigment = 1

/datum/job_flavor/assistant/cattleexport
	prefixtitle		=	"Cattle Export Vehicle \"Eris\""
	maintitle		=	"Veterinarian"

/datum/job_flavor/assistant/cattleexport/shepherd
	maintitle		=	"Shepherd"

/datum/job_flavor/assistant/colonyexpansion
	prefixtitle		=	"Colony Expansion Vehicle \"Eris\""
	maintitle		=	"Colonist"

/datum/job_flavor/assistant/colonyexpansion/geoengineer
	maintitle		=	"Geoengineer"

/datum/job_flavor/assistant/colonyexpansion/ecologist
	maintitle		=	"Ecologist"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/commandevac
	prefixtitle		=	"Command Evacuation Vehicle \"Eris\""
	maintitle		=	"Ensign"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/commandevac/pilot
	maintitle		=	"Pilot"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/commandevac/cmcp_janitor
	maintitle = "Command Master Chief Petty Janitor"

/datum/job_flavor/assistant/commandevac/dc_tech
	maintitle = "Damage Control Technician"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 16,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/combateng
	prefixtitle		=	"Combat Engineer Vehicle \"Eris\" "
	maintitle		=	"Field Engineer"
	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 16,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/cosmicheskiyvelikohod
	prefixtitle		=	"Cosmicheskiy Edinstveniy Velikohod \"Eris\""
	maintitle		=	"Politruk"

/datum/job_flavor/assistant/cosmicheskiyvelikohod/krasnoarmeets
	maintitle		=	"Krasnoarmeets"

/datum/job_flavor/assistant/cosmicheskiyvelikohod/kosmonavt
	maintitle		=	"Kosmonavt"
	stat_modifiers 	=	list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 16,
		STAT_MEC = 16,
		STAT_VIG = 16,
		STAT_COG = 16
	)

/datum/job_flavor/assistant/czechemigration
	prefixtitle		=	"Czech Emigration Vessel \"Eris\""
	maintitle		=	"Registration Officer"

/datum/job_flavor/assistant/czechemigration/refugee
	maintitle		=	"Refugee"

/datum/job_flavor/assistant/czechemigration/mig_officer
	maintitle		=	"Emigration Officer"

/datum/job_flavor/assistant/cockroachexile
	prefixtitle		=	"Cockroach Exile Vessel \"Eris\""
	maintitle		=	"Protein Farmer"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/cockroachexile/biotechnician
	maintitle		=	"Biotechnician"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/cockroachexile/bioterror_spec
	maintitle		=	"Bioterror Specialist"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/capitalextermination
	prefixtitle		=	"Capital Extermination Vessel \"Eris\""
	maintitle		=	"Bomber"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 16,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/capitalextermination/m_arms
	maintitle		=	"Master at Arms"
	stat_modifiers	=	list(
		STAT_ROB = 16,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

/datum/job_flavor/assistant/capitalextermination/loader
	maintitle		=	"Loader"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 16,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
	)

/datum/job_flavor/assistant/catexhibition
	prefixtitle = "Cat Exhibition Vessel \"Eris\""
	maintitle = "Cat Psychologist"

/datum/job_flavor/assistant/catexhibition/feline_herder
	maintitle = "Feline Herder"

/datum/job_flavor/assistant/catexhibition/breeder
	maintitle = "Breeder"

/datum/job_flavor/assistant/corpentertain
	prefixtitle		=	"Corporate Entertain Vehicle \"Eris\""
	maintitle		=	"Mixologist"
	stat_modifiers	=	list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 16,
		STAT_MEC = 8,
		STAT_VIG = 8,
	)

/datum/job_flavor/assistant/corpentertain/stripper
	maintitle		=	"Stripper"

/datum/job_flavor/assistant/corpentertain/officiant
	maintitle		=	"Officiant"

/datum/job_flavor/assistant/emigratorclass
	prefixtitle		=	"Class \"Emigrator\" Vessel \"Eris\""
	maintitle		=	"Quartermaster"

/datum/job_flavor/assistant/emigratorclass/deck_chief
	maintitle		=	"Deck Chief"

/datum/job_flavor/assistant/emigratorclass/deck_tech
	maintitle		=	"Deck Technician"

/datum/job_flavor/assistant/cristianera
	prefixtitle		=	"Christian Era Vector \"Eris\""
	maintitle		=	"Patriarch"

/datum/job_flavor/assistant/cristianera/protodeacon
	maintitle		=	"Protodeacon"

/datum/job_flavor/assistant/cristianera/archimandrite
	maintitle		=	"Archimandrite"
