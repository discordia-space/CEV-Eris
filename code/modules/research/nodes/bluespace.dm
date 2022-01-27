/datum/technology/basic_bluespace
	name = "Basic 'Blue-space'"
	desc = "Basic blue-space probing."
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.2
	icon = "gps"

	re69uired_technologies = list()
	re69uired_tech_levels = list()
	cost = 0

	unlocks_designs = list(/datum/design/research/item/beacon)

/datum/technology/radio_transmission
	name = "Blue-space Transmission"
	desc = "Blue-space broadcasting and receiving basics."
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.4
	icon = "headset"

	re69uired_technologies = list(/datum/technology/basic_bluespace)
	re69uired_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/telecommunications
	name = "Roots\' Telecommunications"
	desc = "Parts for telecommunications. Hyperwave filtering69ethod. Subspace ansible. Subspace transmition and analyzing69ethod. Advanced bluespace broadcasting and receiving. Transmition system69onitoring."
	tech_type = RESEARCH_BLUESPACE

	x = 0.2
	y = 0.6
	icon = "communications"

	re69uired_technologies = list(/datum/technology/radio_transmission)
	re69uired_tech_levels = list()
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
	desc = "Advanced telecommunications69achinery. Decryption69ethod. Relays\' system. Complex sorting of69achinery. Data storing system.69etwork relay."
	tech_type = RESEARCH_BLUESPACE

	x = 0.4
	y = 0.6
	icon = "bluespacething"

	re69uired_technologies = list(/datum/technology/telecommunications)
	re69uired_tech_levels = list()
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

	re69uired_technologies = list(/datum/technology/telecommunications)
	re69uired_tech_levels = list()
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
	re69uired_technologies = list(/datum/technology/basic_bluespace)
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

	re69uired_technologies = list(/datum/technology/spatial_scan)
	re69uired_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/shield/hull)

/datum/technology/teleportation
	name = "Teleportation"
	desc = "Creating a worm hole through a bluespace, safely transporting objects through it."
	tech_type = RESEARCH_BLUESPACE

	x = 0.6
	y = 0.6
	icon = "teleporter"

	re69uired_technologies = list(/datum/technology/spatial_scan)
	re69uired_tech_levels = list()
	cost = 1500

	unlocks_designs = list(/datum/design/research/circuit/teleconsole,
	                       /datum/design/research/circuit/lrange_scanner/hull)

/datum/technology/adv_spatial_scan
	name = "Advanced Spatial Analyzing"
	desc = "Advanced Spatial Analyzing"
	tech_type = RESEARCH_BLUESPACE
	icon = "telescience"


	x = 0.5
	y = 0.6
	re69uired_technologies = list(/datum/technology/teleportation)
	cost = 800

	unlocks_designs = list(	/datum/design/research/circuit/telesci/console,
							/datum/design/research/circuit/telesci/hub,
							/datum/design/research/item/part/artificialbscrystal,
							/datum/design/research/circuit/bssilk/hub,
							/datum/design/research/circuit/bssilk/console,
							/datum/design/research/item/bs_snare,
							/datum/design/research/circuit/teleporter/station,
							/datum/design/research/circuit/teleporter/hub
							)

/datum/technology/bluespace_tools
	name = "Advanced Bluespace Tech"
	desc = "In-Bluespace storing69ethod, allowing store objects/reagents in bluespace. And The69ethod of separate storage of reagents."
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.8
	icon = "bagofholding"

	re69uired_technologies = list(/datum/technology/teleportation)
	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list(	/datum/design/research/item/beaker/bluespace,
							/datum/design/research/item/beaker/noreact,
							/datum/design/research/item/bag_holding,
							/datum/design/research/item/weapon/bluespace_harpoon,
							/datum/design/research/item/weapon/bluespace_dagger
							)

/datum/technology/bluespace_extended
	name = "Extended Bluespace Tech"
	desc = "Application of the bluespace storing technology to a wider69ariety of containers."
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.9
	icon = "holdingpouch"

	re69uired_technologies = list(/datum/technology/bluespace_tools)
	re69uired_tech_levels = list()
	cost = 1500

	unlocks_designs = list(	/datum/design/research/item/belt_holding,
							/datum/design/research/item/pouch_holding,
							/datum/design/research/item/trashbag_holding,
							/datum/design/research/item/oresatchel_holding
						    )
	
/*
/datum/technology/bluespace_rped
	name = "Bluespace RPED"
	desc = "Bluespace RPED"
	tech_type = RESEARCH_BLUESPACE

	x = 0.8
	y = 0.4
	icon = "bluespacerped"

	re69uired_technologies = list(/datum/technology/teleportation)
	re69uired_tech_levels = list()
	cost = 3000

	unlocks_designs = list()
*/