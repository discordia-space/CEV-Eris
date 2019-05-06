/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design/research				//Datum for object designs, used in construction
	req_tech = list()				//IDs of that techs the object originated from and the minimum level requirements.

/datum/design/research/item
	build_type = AUTOLATHE | PROTOLATHE

/datum/design/research/item/mechfab
	build_type = MECHFAB
	category = "Misc"
	req_tech = list(TECH_MATERIAL = 1)


/datum/design/research/item/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/disk/autolathe_disk/blank
	sort_string = "GAAAA"

/datum/design/research/item/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "GAAAB"


/datum/design/research/item/flash
	name = "flash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = AUTOLATHE | MECHFAB
	build_path = /obj/item/device/flash
	category = "Misc"



/datum/design/research/item/hud
	name_category = "HUD glasses"

/datum/design/research/item/hud/health
	name = "health scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/research/item/hud/security
	name = "security records"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/research/item/mesons
	name = "Optical meson scanners"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/powered/meson
	sort_string = "GAAAC"



/datum/design/research/item/medical
	name_category = "biotech device prototype"

/datum/design/research/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFA"

/datum/design/research/item/medical/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	build_path = /obj/item/device/scanner/mass_spectrometer
	sort_string = "MACAA"

/datum/design/research/item/medical/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/scanner/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/research/item/medical/reagent_scanner
	desc = "A device for identifying chemicals."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/scanner/reagent_scanner
	sort_string = "MACBA"

/datum/design/research/item/medical/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/scanner/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/research/item/beaker
	name_category = "beaker prototype"

/datum/design/research/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	sort_string = "MADAA"

/datum/design/research/item/beaker/bluespace
	name = "bluespace"
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
	sort_string = "MADAB"

/datum/design/research/item/medical/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MBAAA"

/datum/design/research/item/scalpel_laser
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	build_path = /obj/item/weapon/tool/scalpel/laser
	sort_string = "MBBAA"




/datum/design/research/item/light_replacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAAAH"

/datum/design/research/item/paicard
	name = "'pAI', personal artificial intelligence device"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/device/paicard
	sort_string = "VABAI"

/datum/design/research/item/intellicard
	name = "'intelliCard', AI preservation and transportation system"
	desc = "Allows for the construction of an intelliCard."
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/device/aicard
	sort_string = "VACAA"

/datum/design/research/item/posibrain
	name = "Positronic brain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/device/mmi/digital/posibrain
	category = "Misc"
	sort_string = "VACAB"

/datum/design/research/item/mmi
	name = "Man-machine interface"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/device/mmi
	category = "Misc"
	sort_string = "VACBA"

/datum/design/research/item/mmi_radio
	name = "Radio-enabled man-machine interface"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"
	sort_string = "VACBB"

/datum/design/research/item/beacon
	name = "Bluespace tracking beacon design"
	req_tech = list(TECH_BLUESPACE = 1)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/research/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "VAEAA"

/datum/design/research/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	req_tech = list(TECH_ILLEGAL = 2)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

//Why is there a science design to craft a cardboard box full of things? That is not how this works
/*
/datum/design/research/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	req_tech = list(TECH_ILLEGAL = 2)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	sort_string = "VASBA"
*/
