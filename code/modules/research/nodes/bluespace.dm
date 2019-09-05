/datum/technology/basic_bluespace
	name = "Basic 'Blue-space'"
	desc = "Basic 'Blue-space'"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.2
	icon = "gps"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/beacon)

/datum/technology/radio_transmission
	name = "Radio Transmission"
	desc = "Radio Transmission"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.4
	icon = "headset"

	required_technologies = list(/datum/technology/basic_bluespace)
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/telecommunications
	name = "Telecommunications"
	desc = "Telecommunications"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.6
	icon = "communications"

	required_technologies = list(/datum/technology/radio_transmission)
	required_tech_levels = list()
	cost = 600

	unlocks_designs = list(/datum/design/research/circuit/comconsole)

/datum/technology/bluespace_telecommunications
	name = "Bluespace Telecommunications"
	desc = "Bluespace Telecommunications"
	tech_type = RESEARCH_BLUESPACE

	x = 0.4
	y = 0.6
	icon = "bluespacething"

	required_technologies = list(/datum/technology/telecommunications)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(/datum/design/research/circuit/comm_monitor, /datum/design/research/circuit/comm_server,
						/datum/design/research/circuit/message_monitor, /datum/design/research/circuit/tcom/receiver,
						/datum/design/research/circuit/tcom/bus, /datum/design/research/circuit/tcom/hub,
						/datum/design/research/circuit/tcom/relay, /datum/design/research/circuit/tcom/processor,
						/datum/design/research/circuit/tcom/server, /datum/design/research/circuit/tcom/broadcaster,
						/datum/design/research/circuit/ntnet_relay,
						/datum/design/research/item/part/subspace_ansible, /datum/design/research/item/part/hyperwave_filter, 
						/datum/design/research/item/part/subspace_amplifier, /datum/design/research/item/part/subspace_treatment, 
						/datum/design/research/item/part/subspace_analyzer, /datum/design/research/item/part/subspace_crystal,
						/datum/design/research/item/part/subspace_transmitter)
/*
/datum/technology/transmission_encryption
	name = "Transmission Encryption"
	desc = "Transmission Encryption"
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.8
	icon = "radiogrid"

	required_technologies = list(/datum/technology/telecommunications)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()
*/
/datum/technology/spatial_scan
	name = "Spatial Analyzing"
	desc = "Spatial Analyzing"
	tech_type = RESEARCH_BLUESPACE
	icon = "pda"


	x = 0.5
	y = 0.4
	required_technologies = list(/datum/technology/basic_bluespace)
	cost = 800

	unlocks_designs = list(	/datum/design/research/item/ano_scanner,
							/datum/design/research/item/beacon_locator,
							/datum/design/research/item/gps
							)

/datum/technology/bluespace_shield
	name = "Bluespace Shields"
	desc = "Bluespace Shields"
	tech_type = RESEARCH_BLUESPACE

	x = 0.4
	y = 0.4
	icon = "shield"

	required_technologies = list(/datum/technology/spatial_scan)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/shield/hull)

/datum/technology/teleportation
	name = "Teleportation"
	desc = "Teleportation"
	tech_type = RESEARCH_BLUESPACE

	x = 0.6
	y = 0.6
	icon = "teleporter"

	required_technologies = list(/datum/technology/spatial_scan)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/teleconsole)

/datum/technology/bluespace_tools
	name = "Bluespace Tools"
	desc = "Bluespace Tools"
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.8
	icon = "bagofholding"

	required_technologies = list(/datum/technology/teleportation)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/research/item/beaker/bluespace,
							/datum/design/research/item/beaker/noreact,
							/datum/design/research/item/bag_holding
							)
/*
/datum/technology/bluespace_rped
	name = "Bluespace RPED"
	desc = "Bluespace RPED"
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.4
	icon = "bluespacerped"

	required_technologies = list(/datum/technology/teleportation)
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list()
*/