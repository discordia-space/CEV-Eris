/datum/technology/basic_bluespace
	name = "Basic 'Blue-space'"
	desc = "Basic blue-space probing."
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.2
	icon = "gps"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/beacon)

/datum/technology/radio_transmission
	name = "Blue-space Transmission"
	desc = "Blue-space broadcasting and receiving basics."
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.4
	icon = "headset"

	required_technologies = list(/datum/technology/basic_bluespace)
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/telecommunications
	name = "Roots\' Telecommunications"
	desc = "Parts for telecommunications. Hyperwave filtering method. Subspace ansible. Subspace transmition and analyzing method. Advanced bluespace broadcasting and receiving. Transmition system monitoring."
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.6
	icon = "communications"

	required_technologies = list(/datum/technology/radio_transmission)
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list(	/datum/design/research/circuit/comconsole,
							/datum/design/research/circuit/message_monitor,
							/datum/design/research/circuit/comm_monitor,
							/datum/design/research/circuit/comm_server,
							/datum/design/research/circuit/tcom/receiver,
							/datum/design/research/circuit/tcom/broadcaster,

							/datum/design/research/item/part/subspace_ansible,
							/datum/design/research/item/part/hyperwave_filter, 
							/datum/design/research/item/part/subspace_amplifier,
							/datum/design/research/item/part/subspace_treatment, 
							/datum/design/research/item/part/subspace_analyzer,
							/datum/design/research/item/part/subspace_crystal,
							/datum/design/research/item/part/subspace_transmitter)

/datum/technology/bluespace_telecommunications
	name = "Advanced Telecommunications"
	desc = "Advanced telecommunications machinery. Decryption method. Relays\' system. Complex sorting of machinery. Data storing system. Network relay."
	tech_type = RESEARCH_BLUESPACE

	x = 0.4
	y = 0.6
	icon = "bluespacething"

	required_technologies = list(/datum/technology/telecommunications)
	required_tech_levels = list()
	cost = 800

	unlocks_designs = list( 
							/datum/design/research/circuit/tcom/bus,
							/datum/design/research/circuit/tcom/hub,
							/datum/design/research/circuit/tcom/processor,
							/datum/design/research/circuit/tcom/server,
							/datum/design/research/circuit/tcom/relay,
							/datum/design/research/circuit/ntnet_relay
						)
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
	desc = "Basics of spatial analyze, generally using for location of beacons and anomaly analyzing."
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
	desc = "Improved light-shields with using of bluespace technologies."
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
	desc = "Creating a worm hole through a bluespace, safely transporting objects through it."
	tech_type = RESEARCH_BLUESPACE

	x = 0.6
	y = 0.6
	icon = "teleporter"

	required_technologies = list(/datum/technology/spatial_scan)
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/teleconsole)

/datum/technology/adv_spatial_scan
	name = "Advanced Spatial Analyzing"
	desc = "Advanced Spatial Analyzing"
	tech_type = RESEARCH_BLUESPACE
	icon = "telescience"


	x = 0.5
	y = 0.6
	required_technologies = list(/datum/technology/teleportation)
	cost = 800

	unlocks_designs = list(	/datum/design/research/circuit/telesci/console,
							/datum/design/research/circuit/telesci/hub,
							/datum/design/research/item/part/artificialbscrystal,
							/datum/design/research/circuit/bssilk/hub,
							/datum/design/research/circuit/bssilk/console,
							/datum/design/research/item/bs_snare
							)

/datum/technology/bluespace_tools
	name = "Advanced Bluespace Tech"
	desc = "In-Bluespace storing method, allowing store objects/reagents in bluespace. And The method of separate storage of reagents."
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.8
	icon = "bagofholding"

	required_technologies = list(/datum/technology/teleportation)
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list(	/datum/design/research/item/beaker/bluespace,
							/datum/design/research/item/beaker/noreact,
							/datum/design/research/item/bag_holding,
							/datum/design/research/item/weapon/bluespace_harpoon
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