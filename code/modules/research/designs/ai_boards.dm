/datum/design/research/circuit/aicore
	name = "AI core"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/aicore
	sort_string = "XAAAA"


/datum/design/research/aimodule
	build_type = IMPRINTER
	name_category = "AI module"

/datum/design/research/aimodule/safeguard
	name = "Safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/safeguard
	sort_string = "XABAA"

/datum/design/research/aimodule/onehuman
	name = "OneCrewMember"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/oneHuman
	sort_string = "XABAB"

/datum/design/research/aimodule/protectstation
	name = "ProtectStation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/protectStation
	sort_string = "XABAC"

/datum/design/research/aimodule/notele
	name = "TeleporterOffline"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/aiModule/teleporterOffline
	sort_string = "XABAD"

/datum/design/research/aimodule/quarantine
	name = "Quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/quarantine
	sort_string = "XABAE"

/datum/design/research/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/oxygen
	sort_string = "XABAF"

/datum/design/research/aimodule/freeform
	name = "Freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/freeform
	sort_string = "XABAG"

/datum/design/research/aimodule/reset
	name = "Reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/reset
	sort_string = "XAAAA"

/datum/design/research/aimodule/purge
	name = "Purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/purge
	sort_string = "XAAAB"

// Core modules
/datum/design/research/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	name_category = "AI core module"

/datum/design/research/aimodule/core/freeformcore
	name = "Freeform"
	build_path = /obj/item/weapon/aiModule/freeformcore
	sort_string = "XACAA"

/datum/design/research/aimodule/core/asimov
	name = "Asimov"
	build_path = /obj/item/weapon/aiModule/asimov
	sort_string = "XACAB"

/datum/design/research/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	build_path = /obj/item/weapon/aiModule/paladin
	sort_string = "XACAC"

/datum/design/research/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/tyrant
	sort_string = "XACAD"
