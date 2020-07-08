/datum/design/research/circuit
	build_type = IMPRINTER
	chemicals = list("silicon" = 5)

/datum/design/research/circuit/AssembleDesignName(atom/temp_atom)
	..()
	var/obj/item/weapon/circuitboard/C = temp_atom
	if(!istype(C))
		return

	if(C.board_type == "machine")
		name = "Machine circuit ([item_name])"
	else if(C.board_type == "computer")
		name = "Computer circuit ([item_name])"

/datum/design/research/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/research/circuit/arcade_battle
	name = "battle arcade machine"
	build_path = /obj/item/weapon/circuitboard/arcade/battle
	sort_string = "MAAAA"
	category = CAT_MISC

/datum/design/research/circuit/arcade_orion_trail
	name = "orion trail arcade machine"
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail
	sort_string = "MABAA"
	category = CAT_MISC

/datum/design/research/circuit/secdata
	name = "security records console"
	build_path = /obj/item/weapon/circuitboard/secure_data
	sort_string = "DABAA"
	category = CAT_COMP

/datum/design/research/circuit/prisonmanage
	name = "prisoner management console"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"
	category = CAT_COMP

/datum/design/research/circuit/med_data
	name = "medical records console"
	build_path = /obj/item/weapon/circuitboard/med_data
	sort_string = "FAAAA"
	category = CAT_COMP

/datum/design/research/circuit/operating
	name = "patient monitoring console"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"
	category = CAT_COMP

/datum/design/research/circuit/scan_console
	name = "DNA machine"
	build_path = /obj/item/weapon/circuitboard/scan_consolenew
	sort_string = "FAGAA"
	category = CAT_MEDI

/datum/design/research/circuit/sleeper
	name = "Sleeper"
	build_path = /obj/item/weapon/circuitboard/sleeper
	sort_string = "FAGAB"
	category = CAT_MEDI

/datum/design/research/circuit/clonepod
	name = "clone pod"
	build_path = /obj/item/weapon/circuitboard/clonepod
	sort_string = "FAGAE"
	category = CAT_MEDI

/datum/design/research/circuit/clonescanner
	name = "cloning scanner"
	build_path = /obj/item/weapon/circuitboard/clonescanner
	sort_string = "FAGAG"
	category = CAT_MEDI

/datum/design/research/circuit/chemmaster
	name = "ChemMaster 3000"
	build_path = /obj/item/weapon/circuitboard/chemmaster
	sort_string = "FAHAA"
	category = CAT_MEDI

/datum/design/research/circuit/chem_heater
	name = "Chemical Heater"
	build_path = /obj/item/weapon/circuitboard/chem_heater
	sort_string = "FAHAB"
	category = CAT_MEDI

/datum/design/research/circuit/chemical_dispenser
	name = "Chemical Dispenser"
	build_path = /obj/item/weapon/circuitboard/chemical_dispenser
	sort_string = "FAHAC"
	category = CAT_MEDI

/datum/design/research/circuit/teleconsole
	name = "teleporter control console"
	build_path = /obj/item/weapon/circuitboard/teleporter
	sort_string = "HAAAA"
	category = CAT_BLUE

/datum/design/research/circuit/robocontrol
	name = "robotics control console"
	build_path = /obj/item/weapon/circuitboard/robotics
	sort_string = "HAAAB"
	category = CAT_COMP

/datum/design/research/circuit/rdconsole
	name = "R&D control console"
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAE"
	category = CAT_COMP

/datum/design/research/circuit/aifixer
	name = "AI integrity restorer"
	build_path = /obj/item/weapon/circuitboard/aifixer
	sort_string = "HAAAF"
	category = CAT_COMP

/datum/design/research/circuit/comm_monitor
	name = "telecommunications monitoring console"
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"
	category = CAT_TCOM

/datum/design/research/circuit/comm_server
	name = "telecommunications server monitoring console"
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"
	category = CAT_TCOM

/datum/design/research/circuit/message_monitor
	name = "messaging monitor console"
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACC"
	category = CAT_TCOM

/datum/design/research/circuit/aiupload
	name = "AI upload console"
	build_path = /obj/item/weapon/circuitboard/aiupload
	sort_string = "HAABA"
	category = CAT_COMP

/datum/design/research/circuit/borgupload
	name = "cyborg upload console"
	build_path = /obj/item/weapon/circuitboard/borgupload
	sort_string = "HAABB"
	category = CAT_COMP

/datum/design/research/circuit/destructive_analyzer
	name = "destructive analyzer"
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"
	category = CAT_COMP

/datum/design/research/circuit/protolathe
	name = "protolathe"
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"
	category = CAT_MACHINE

/datum/design/research/circuit/circuit_imprinter
	name = "circuit imprinter"
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"
	category = CAT_MACHINE

/datum/design/research/circuit/autolathe
	name = "autolathe"
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"
	category = CAT_MACHINE

/datum/design/research/circuit/rdservercontrol
	name = "R&D server control console"
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"
	category = CAT_COMP

/datum/design/research/circuit/rdserver
	name = "R&D server"
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"
	category = CAT_MACHINE

/datum/design/research/circuit/mechfab
	name = "exosuit fabricator"
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"
	category = CAT_MACHINE

/datum/design/research/circuit/mech_recharger
	name = "mech recharger"
	build_path = /obj/item/weapon/circuitboard/mech_recharger
	sort_string = "HACAA"
	category = CAT_MACHINE

/datum/design/research/circuit/recharge_station
	name = "cyborg recharge station"
	build_path = /obj/item/weapon/circuitboard/recharge_station
	sort_string = "HACAC"
	category = CAT_MACHINE

/datum/design/research/circuit/repair_station
	name = "cyborg auto-repair platform"
	build_path = /obj/item/weapon/circuitboard/repair_station
	sort_string = "HACAE"
	category = CAT_MACHINE

/datum/design/research/circuit/recharger
	name = "recharger"
	build_path = /obj/item/weapon/circuitboard/recharger
	sort_string = "HACAD"

/datum/design/research/circuit/atmosalerts
	name = "atmosphere alert console"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"
	category = CAT_COMP

/datum/design/research/circuit/air_management
	name = "atmosphere monitoring console"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"
	category = CAT_COMP

/datum/design/research/circuit/dronecontrol
	name = "drone control console"
	build_path = /obj/item/weapon/circuitboard/drone_control
	sort_string = "JAAAD"
	category = CAT_COMP

/datum/design/research/circuit/powermonitor
	name = "power monitoring console"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAE"
	category = CAT_COMP

/datum/design/research/circuit/solarcontrol
	name = "solar control console"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAF"
	category = CAT_COMP

/datum/design/research/circuit/pacman
	name = "PACMAN-type generator"
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"
	category = CAT_POWER

/datum/design/research/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"
	category = CAT_POWER

/datum/design/research/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"
	category = CAT_POWER

/datum/design/research/circuit/batteryrack
	name = "cell rack PSU"
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"
	category = CAT_POWER

/datum/design/research/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"
	category = CAT_POWER

/datum/design/research/circuit/breakerbox
	name = "breaker box"
	build_path = /obj/item/weapon/circuitboard/breakerbox
	sort_string = "JBABC"
	category = CAT_POWER

/datum/design/research/circuit/gas_heater
	name = "gas heating system"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"
	category = CAT_MACHINE

/datum/design/research/circuit/gas_cooler
	name = "gas cooling system"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"
	category = CAT_MACHINE

/datum/design/research/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	build_path = /obj/item/weapon/airlock_electronics/secure
	sort_string = "JDAAA"
	category = CAT_MISC

/datum/design/research/circuit/ordercomp
	name = "supply ordering console"
	build_path = /obj/item/weapon/circuitboard/ordercomp
	sort_string = "KAAAA"
	category = CAT_COMP

/datum/design/research/circuit/supplycomp
	name = "supply control console"
	build_path = /obj/item/weapon/circuitboard/supplycomp
	sort_string = "KAAAB"
	category = CAT_COMP

/datum/design/research/circuit/biogenerator
	name = "biogenerator"
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"
	category = CAT_MACHINE

/datum/design/research/circuit/miningdrill
	name = "mining drill head"
	build_path = /obj/item/weapon/circuitboard/miningdrill
	sort_string = "KCAAA"
	category = CAT_MINING

/datum/design/research/circuit/miningdrillbrace
	name = "mining drill brace"
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
	sort_string = "KCAAB"
	category = CAT_MINING

/datum/design/research/circuit/comconsole
	name = "communications console"
	build_path = /obj/item/weapon/circuitboard/communications
	sort_string = "LAAAA"
	category = CAT_COMP


// Telecomms
/datum/design/research/circuit/tcom
	name_category = "telecommunications machinery"
	category = CAT_TCOM

/datum/design/research/circuit/tcom/server
	name = "server mainframe"
	build_path = /obj/item/weapon/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/research/circuit/tcom/processor
	name = "processor unit"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/research/circuit/tcom/bus
	name = "bus mainframe"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/research/circuit/tcom/hub
	name = "hub mainframe"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/research/circuit/tcom/relay
	name = "relay mainframe"
	build_path = /obj/item/weapon/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/research/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/research/circuit/tcom/receiver
	name = "subspace receiver"
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/research/circuit/ntnet_relay
	name = "NTNet Quantum Relay"
	build_path = /obj/item/weapon/circuitboard/ntnet_relay
	sort_string = "WAAAA"


// Shield Generators
/datum/design/research/circuit/shield
	name_category = "shield generator"
	category = CAT_MISC

/datum/design/research/circuit/shield/hull
	name = "hull"
	build_path = /obj/item/weapon/circuitboard/shield_generator
	sort_string = "VAAAB"
/*
/datum/design/research/circuit/shield/capacitor
	name = "capacitor"
	desc = "Allows for the construction of a shield capacitor circuit board."
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_cap
	sort_string = "VAAAC"*/

//BS
/datum/design/research/circuit/telesci/console
	name = "TeleSci Console"
	build_path = /obj/item/weapon/circuitboard/telesci_console
	sort_string = "VAAAD"
	category = CAT_BLUE

/datum/design/research/circuit/telesci/hub
	name = "TeleSci Pad"
	build_path = /obj/item/weapon/circuitboard/telesci_pad
	sort_string = "VAAAE"
	category = CAT_BLUE

/datum/design/research/circuit/bssilk/console
	name = "Bluespace Snare Control Console"
	build_path = /obj/item/weapon/circuitboard/bssilk_cons
	sort_string = "VAAAK"
	category = CAT_BLUE

/datum/design/research/circuit/bssilk/hub
	name = "Bluespace Snare Hub"
	build_path = /obj/item/weapon/circuitboard/bssilk_hub
	sort_string = "VAAAG"
	category = CAT_BLUE