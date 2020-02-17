/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	item_cost = 5
	path = /obj/item/weapon/storage/toolbox/syndicate
	desc = "Danger. Very robust. Filled with advanced tools."
/datum/uplink_item/item/tools/shield_diffuser
	name = "Shield Diffuser"
	item_cost = 4
	path = /obj/item/device/shield_diffuser
	desc = "A handheld device that disrupts shields, allowing you to effortlessly pass through. Be sure to bring some spare power cells!."

/datum/uplink_item/item/tools/money
	name = "Operations Funding"
	item_cost = 13
	path = /obj/item/weapon/storage/secure/briefcase/money
	desc = "A briefcase with 10,000 untraceable credits for funding your sneaky activities."

/datum/uplink_item/item/tools/pocketchange
	name = "Spending Money"
	item_cost = 1
	path = /obj/item/weapon/spacecash/bundle/c500
	desc = "A bundle of 500 untraceable credits to cover a few basic expenses."

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	item_cost = 3
	path = /obj/item/weapon/storage/box/syndie_kit/clerical

/datum/uplink_item/item/tools/plastique
	name = "C-4 (Destroys walls)"
	item_cost = 3
	path = /obj/item/weapon/plastique

/datum/uplink_item/item/tools/heavy_vest
	name = "Heavy Armor Vest"
	item_cost = 6
	path = /obj/item/clothing/suit/storage/vest/merc

/datum/uplink_item/item/tools/heavy_helmet
	name = "Heavy Armor Helmet"
	item_cost = 4
	path = /obj/item/clothing/head/armor/helmet/merchelm

/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	item_cost = 4
	path = /obj/item/device/encryptionkey/syndicate

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	item_cost = 5
	path = /obj/item/device/encryptionkey/binary

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	item_cost = 6
	path = /obj/item/weapon/card/emag

/datum/uplink_item/item/tools/hacking_tool
	name = "Door Hacking Tool"
	item_cost = 6
	path = /obj/item/weapon/tool/multitool/hacktool
	desc = "Appears and functions as a standard multitool until the mode is toggled by applying a screwdriver appropriately. \
			When in hacking mode this device will grant full access to any standard airlock within 20 to 40 seconds. \
			This device will also be able to immediately access the last 6 to 8 hacked airlocks."

/datum/uplink_item/item/tools/space_suit
	name = "Mercenary Voidsuit"
	item_cost = 6
	path = /obj/item/weapon/storage/box/syndie_kit/space

/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	item_cost = 6
	path = /obj/item/clothing/glasses/powered/thermal/syndi

/datum/uplink_item/item/tools/thermal_lens
	name = "Thermal Imaging Lenses"
	item_cost = 10
	path = /obj/item/clothing/glasses/powered/thermal/lens

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	item_cost = 10
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/teleporter
	name = "Teleporter Circuit Board"
	item_cost = 8
	path = /obj/item/weapon/circuitboard/teleporter

/datum/uplink_item/item/tools/teleporter/New()
	..()
	antag_roles = list(ROLE_MERCENARY)

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	item_cost = 14
	path = /obj/item/weapon/aiModule/syndicate

/datum/uplink_item/item/tools/supply_beacon
	name = "Hacked Supply Beacon (DANGER!)"
	item_cost = 14
	path = /obj/item/supply_beacon

/datum/uplink_item/item/tools/mind_fryer
	name = "Mind Fryer"
	desc = "When activated, attacks the minds of people nearby, causing sanity loss and inducing mental breakdowns. \
			The device owner is immune to this effect."
	item_cost = 3
	path = /obj/item/device/mind_fryer
	antag_roles = list()

/datum/uplink_item/item/tools/mind_fryer/buy(obj/item/device/uplink/U)
	. = ..()
	if(.)
		var/obj/item/device/mind_fryer/M = .
		M.owner = U.uplink_owner

/datum/uplink_item/item/tools/spy_sensor
	name = "Spying Sensor (4x)"
	desc = "A set of sensor packages designed to collect some information for your client. \
			Place the sensors in target area, make sure to activate each one and do not move or otherwise disturb them."
	item_cost = 1
	path = /obj/item/weapon/storage/box/syndie_kit/spy_sensor
	antag_roles = ROLES_CONTRACT

/datum/uplink_item/item/tools/spy_sensor/buy(obj/item/device/uplink/U)
	. = ..()
	if(.)
		var/obj/item/weapon/storage/box/syndie_kit/spy_sensor/B = .
		for(var/obj/item/device/spy_sensor/S in B)
			S.owner = U.uplink_owner

/datum/uplink_item/item/tools/bsdm
	name = "Blue Space Direct Mail Unit"
	item_cost = 1
	path = /obj/item/weapon/storage/bsdm
	antag_roles = ROLES_CONTRACT

/datum/uplink_item/item/tools/bsdm/can_view(obj/item/device/uplink/U)
	return ..() && (U.bsdm_time > world.time)

/datum/uplink_item/item/tools/bsdm/buy(obj/item/device/uplink/U)
	. = ..()
	if(.)
		var/obj/item/weapon/storage/bsdm/B = .
		B.owner = U.uplink_owner

/datum/uplink_item/item/tools/bsdm_free
	name = "Blue Space Direct Mail Unit"
	item_cost = 0
	path = /obj/item/weapon/storage/bsdm
	antag_roles = ROLES_CONTRACT

/datum/uplink_item/item/tools/bsdm_free/can_view(obj/item/device/uplink/U)
	return ..() && (U.bsdm_time <= world.time)

/datum/uplink_item/item/tools/bsdm_free/buy(obj/item/device/uplink/U)
	. = ..()
	if(.)
		var/obj/item/weapon/storage/bsdm/B = .
		B.owner = U.uplink_owner
		U.bsdm_time = world.time + 10 MINUTES

/datum/uplink_item/item/tools/mental_imprinter
	name = "Mental Imprinter"
	item_cost = 5
	path = /obj/item/device/mental_imprinter
