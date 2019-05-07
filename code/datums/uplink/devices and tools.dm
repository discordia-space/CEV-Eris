/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	item_cost = 20
	path = /obj/item/weapon/storage/toolbox/syndicate
	desc = "Contains all basic tools including multitool and insulated gloves. Toolbox by itself is pretty robust weapon too."

/datum/uplink_item/item/tools/shield_diffuser
	name = "Shield Diffuser"
	item_cost = 40
	path = /obj/item/device/shield_diffuser
	desc = "A handheld device that disrupts shields, allowing you to effortlessly pass through. Be sure to bring some spare power cells!."

/datum/uplink_item/item/tools/money
	name = "Operations Funding"
	item_cost = 130
	path = /obj/item/weapon/storage/secure/briefcase/money
	desc = "A briefcase with 10,000 untraceable credits for funding your sneaky activities."

/datum/uplink_item/item/tools/pocketchange
	name = "Spending Money"
	item_cost = 10
	path = /obj/item/weapon/spacecash/bundle/c500
	desc = "A bundle of 500 untraceable credits to cover a few basic expenses."

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	item_cost = 30
	path = /obj/item/weapon/storage/box/syndie_kit/clerical

/datum/uplink_item/item/tools/plastique
	name = "C-4 (Destroys walls)"
	item_cost = 30
	path = /obj/item/weapon/plastique

/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	item_cost = 40
	path = /obj/item/device/encryptionkey/syndicate

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	item_cost = 50
	path = /obj/item/device/encryptionkey/binary

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	item_cost = 60
	path = /obj/item/weapon/card/emag

/datum/uplink_item/item/tools/hacking_tool
	name = "Door Hacking Tool"
	item_cost = 60
	path = /obj/item/weapon/tool/multitool/hacktool
	desc = "Appears and functions as a standard multitool until the mode is toggled by applying a screwdriver appropriately. \
			When in hacking mode this device will grant full access to any standard airlock within 20 to 40 seconds. \
			This device will also be able to immediately access the last 6 to 8 hacked airlocks."

/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	item_cost = 60
	path = /obj/item/clothing/glasses/thermal/syndi

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	item_cost = 100
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/teleporter
	name = "Teleporter Circuit Board"
	item_cost = 500
	path = /obj/item/weapon/circuitboard/teleporter

/datum/uplink_item/item/tools/teleporter/New()
	..()
	antag_roles = list(ROLE_MERCENARY)

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	item_cost = 140
	path = /obj/item/weapon/aiModule/syndicate

/datum/uplink_item/item/tools/supply_beacon
	name = "Hacked Supply Beacon (DANGER!)"
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT
	path = /obj/item/supply_beacon
	desc = "Needs to be deployed with wrench on powered wire node. Upon activation, calls massive pod deploying on it location, crushing and exploding everything under and near it."
