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
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.

/datum/design/research/item
	build_type = PROTOLATHE

/datum/design/research/item/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/disk/design_disk
	sort_string = "GAAAA"

/datum/design/research/item/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "GAAAB"

/datum/design/research/item/stock_part
	build_type = PROTOLATHE

/datum/design/research/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

/datum/design/research/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/research/item/stock_part/basic_capacitor
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "CAAAA"

/datum/design/research/item/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "CAAAB"

/datum/design/research/item/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "CAAAC"

/datum/design/research/item/stock_part/micro_mani
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "CAABA"

/datum/design/research/item/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "CAABB"

/datum/design/research/item/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "CAABC"

/datum/design/research/item/stock_part/basic_matter_bin
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "CAACA"

/datum/design/research/item/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "CAACB"

/datum/design/research/item/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "CAACC"

/datum/design/research/item/stock_part/basic_micro_laser
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "CAADA"

/datum/design/research/item/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "CAADB"

/datum/design/research/item/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "CAADC"

/datum/design/research/item/stock_part/basic_sensor
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"

/datum/design/research/item/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"

/datum/design/research/item/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"

/datum/design/research/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"

/datum/design/research/item/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/research/item/powercell/AssembleDesignName()
	name = "Power cell ([item_name])"

/datum/design/research/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of [initial(C.autorecharging) ? "microreactor" : "power"] cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/research/item/powercell/large/basic
	name = "Moebius \"Power-Geyser 2000L\""
	build_type = PROTOLATHE | MECHFAB
	id = "basic_cell_b"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell/large/moebius
	category = "Misc"
	sort_string = "DAAAA"

/datum/design/research/item/powercell/large/high
	name = "Moebius \"Power-Geyser 7000L\""
	build_type = PROTOLATHE | MECHFAB
	id = "high_cell_b"
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/large/moebius/high
	category = "Misc"
	sort_string = "DAAAB"

/datum/design/research/item/powercell/large/super
	name = "Moebius \"Power-Geyser 13000L\""
	id = "super_cell_b"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/large/moebius/super
	category = "Misc"
	sort_string = "DAAAC"

/datum/design/research/item/powercell/large/hyper
	name = "Moebius \"Power-Geyser 18000L\""
	id = "hyper_cell_b"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/large/moebius/hyper
	category = "Misc"
	sort_string = "DAAAD"

/datum/design/research/item/powercell/medium/basic
	name = "Moebius \"Power-Geyser 700M\""
	build_type = PROTOLATHE | MECHFAB
	id = "basic_cell_m"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell/medium/moebius
	category = "Misc"
	sort_string = "DAAAF"

/datum/design/research/item/powercell/medium/high
	name = "Moebius \"Power-Geyser 900M\""
	build_type = PROTOLATHE | MECHFAB
	id = "high_cell_m"
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/medium/moebius/high
	category = "Misc"
	sort_string = "DAAAI"

/datum/design/research/item/powercell/medium/super
	name = "Moebius \"Power-Geyser 1000M\""
	id = "super_cell_m"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/medium/moebius/super
	category = "Misc"
	sort_string = "DAAAO"

/datum/design/research/item/powercell/medium/hyper
	name = "Moebius \"Power-Geyser 1300M\""
	id = "hyper_cell_m"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/medium/moebius/hyper
	category = "Misc"
	sort_string = "DAAAP"

/datum/design/research/item/powercell/small/basic
	name = "Moebius \"Power-Geyser 120S\""
	build_type = PROTOLATHE | MECHFAB
	id = "basic_cell_s"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell/small/moebius
	category = "Misc"
	sort_string = "DAAAQ"

/datum/design/research/item/powercell/small/high
	name = "Moebius \"Power-Geyser 250S\""
	build_type = PROTOLATHE | MECHFAB
	id = "high_cell_s"
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/small/moebius/high
	category = "Misc"
	sort_string = "DAAAZ"

/datum/design/research/item/powercell/small/super
	name = "Moebius \"Power-Geyser 300S\""
	id = "super_cell_s"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/small/moebius/super
	category = "Misc"
	sort_string = "DAAAW"

/datum/design/research/item/powercell/small/hyper
	name = "Moebius \"Power-Geyser 400S\""
	id = "hyper_cell_s"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/small/moebius/hyper
	category = "Misc"
	sort_string = "DAAAY"

/datum/design/research/item/powercell/large/nuclear
	name = "Moebius \"Atomcell 13000L\""
	id = "nuke_cell_b"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/large/moebius/nuclear
	category = "Misc"
	sort_string = "DAAAZ"

/datum/design/research/item/powercell/medium/nuclear
	name = "Moebius \"Atomcell 1000M\""
	id = "nuke_cell_m"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/medium/moebius/nuclear
	category = "Misc"
	sort_string = "DAABA"

/datum/design/research/item/powercell/small/nuclear
	name = "Moebius \"Atomcell 300S\""
	id = "nuke_cell_s"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/small/moebius/nuclear
	category = "Misc"
	sort_string = "DAABB"


/datum/design/research/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/research/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/research/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/research/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/research/item/mesons
	name = "Optical meson scanners design"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GAAAC"

/datum/design/research/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

/datum/design/research/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/tool/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/research/item/weapon/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/tool/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/research/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/tool/pickaxe/diamonddrill
	sort_string = "KAAAC"
///////////////////////////////////
/////////Shield Generators/////////
///////////////////////////////////
/datum/design/research/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PLASMA = 3)

/datum/design/research/circuit/shield/AssembleDesignName()
	name = "Shield generator circuit design ([name])"

/datum/design/research/circuit/shield/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] shield generator."

/datum/design/research/circuit/shield/hull
	name = "hull"
	id = "shield_gen"
	build_path = /obj/item/weapon/circuitboard/shield_generator
	sort_string = "VAAAB"
/*
/datum/design/research/circuit/shield/capacitor
	name = "capacitor"
	desc = "Allows for the construction of a shield capacitor circuit board."
	id = "shield_cap"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_cap
	sort_string = "VAAAC"*/



/datum/design/research/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

/datum/design/research/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFA"

/datum/design/research/item/medical/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	build_path = /obj/item/device/scanner/mass_spectrometer
	sort_string = "MACAA"

/datum/design/research/item/medical/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/scanner/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/research/item/medical/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/scanner/reagent_scanner
	sort_string = "MACBA"

/datum/design/research/item/medical/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/scanner/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/research/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/research/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	sort_string = "MADAA"

/datum/design/research/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
	sort_string = "MADAB"

/datum/design/research/item/medical/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MBAAA"

/datum/design/research/item/scalpel_laser
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	build_path = /obj/item/weapon/tool/scalpel/laser
	sort_string = "MBBAA"



/datum/design/research/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/research/item/implant/chemical
	name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/chem
	sort_string = "MFAAA"

/datum/design/research/item/implant/freedom
	name = "freedom"
	id = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/freedom
	sort_string = "MFAAB"

/datum/design/research/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/research/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/research/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TAAAA"

/datum/design/research/item/weapon/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)

	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAAAB"

/datum/design/research/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	sort_string = "TAAAC"

/datum/design/research/item/weapon/plasmapistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PLASMA = 4)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAAAD"

/datum/design/research/item/weapon/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAAAE"

/datum/design/research/item/weapon/stunshell
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TAACB"

/datum/design/research/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/research/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/research/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)

	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/research/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/research/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TBAAA"

/datum/design/research/item/stock_part/subspace_ansible
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "UAAAA"

/datum/design/research/item/stock_part/hyperwave_filter
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
	sort_string = "UAAAB"

/datum/design/research/item/stock_part/subspace_amplifier
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "UAAAC"

/datum/design/research/item/stock_part/subspace_treatment
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "UAAAD"

/datum/design/research/item/stock_part/subspace_analyzer
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "UAAAE"

/datum/design/research/item/stock_part/subspace_crystal
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "UAAAF"

/datum/design/research/item/stock_part/subspace_transmitter
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "UAAAG"

/datum/design/research/item/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAAAH"

/datum/design/research/item/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/device/paicard
	sort_string = "VABAI"

/datum/design/research/item/intellicard
	name = "'intelliCard', AI preservation and transportation system"
	desc = "Allows for the construction of an intelliCard."
	id = "intellicard"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/device/aicard
	sort_string = "VACAA"

/datum/design/research/item/posibrain
	name = "Positronic brain"
	id = "posibrain"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/device/mmi/digital/posibrain
	category = "Misc"
	sort_string = "VACAB"

/datum/design/research/item/mmi
	name = "Man-machine interface"
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/device/mmi
	category = "Misc"
	sort_string = "VACBA"

/datum/design/research/item/mmi_radio
	name = "Radio-enabled man-machine interface"
	id = "mmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"
	sort_string = "VACBB"

/datum/design/research/item/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/research/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "VAEAA"

/datum/design/research/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

//Why is there a science design to craft a cardboard box full of things? That is not how this works
/*
/datum/design/research/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	sort_string = "VASBA"
*/

// Modular computer components
// Hard drives
/datum/design/research/item/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/hard_drive/
	sort_string = "VBAAA"

/datum/design/research/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/research/item/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/hard_drive/super
	sort_string = "VBAAC"

/datum/design/research/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/research/item/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/hard_drive/small
	sort_string = "VBAAE"

/datum/design/research/item/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/hard_drive/micro
	sort_string = "VBAAF"

// Network cards
/datum/design/research/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card
	sort_string = "VBAAG"

/datum/design/research/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card/advanced
	sort_string = "VBAAH"

/datum/design/research/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/network_card/wired
	sort_string = "VBAAI"

// Data crystals (USB flash drives)
/datum/design/research/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable
	sort_string = "VBAAJ"

/datum/design/research/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	sort_string = "VBAAK"

/datum/design/research/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/hard_drive/portable/super
	sort_string = "VBAAL"

// Card slot
/datum/design/research/item/modularcomponent/cardslot
	name = "ID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/card_slot
	sort_string = "VBAAM"

// Nano printer
/datum/design/research/item/modularcomponent/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/nano_printer
	sort_string = "VBAAO"

// Card slot
/datum/design/research/item/modularcomponent/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	build_path = /obj/item/weapon/computer_hardware/tesla_link
	sort_string = "VBAAP"

/datum/design/research/item/modularcomponent/cpu
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit
	sort_string = "VBAAW"

/datum/design/research/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/small
	sort_string = "VBAAX"

/datum/design/research/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	chemicals = list("sacid" = 40)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic
	sort_string = "VBAAY"

/datum/design/research/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	chemicals = list("sacid" = 20)
	build_path = /obj/item/weapon/computer_hardware/processor_unit/photonic/small
	sort_string = "VBAAZ"
/*
CIRCUITS BELOW
*/

/datum/design/research/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	chemicals = list("sacid" = 20) //Acid is used for inscribing circuits, but intentionally not part of the final reagents
	time = 5

/datum/design/research/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/research/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/research/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/battle
	sort_string = "MAAAA"

/datum/design/research/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail
	sort_string = "MABAA"

/datum/design/research/circuit/secdata
	name = "security records console"
	id = "sec_data"
	build_path = /obj/item/weapon/circuitboard/secure_data
	sort_string = "DABAA"

/datum/design/research/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/research/circuit/med_data
	name = "medical records console"
	id = "med_data"
	build_path = /obj/item/weapon/circuitboard/med_data
	sort_string = "FAAAA"

/datum/design/research/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"

/datum/design/research/circuit/scan_console
	name = "DNA machine"
	id = "scan_console"
	build_path = /obj/item/weapon/circuitboard/scan_consolenew
	sort_string = "FAGAA"

/datum/design/research/circuit/clonepod
	name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/clonepod
	sort_string = "FAGAE"

/datum/design/research/circuit/clonescanner
	name = "cloning scanner"
	id = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/clonescanner
	sort_string = "FAGAG"

/datum/design/research/circuit/chemmaster
	name = "ChemMaster 3000"
	id = "chemmaster"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/chemmaster
	sort_string = "FAHAA"

/datum/design/research/circuit/teleconsole
	name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/teleporter
	sort_string = "HAAAA"

/datum/design/research/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/robotics
	sort_string = "HAAAB"

/datum/design/research/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/mecha_control
	sort_string = "HAAAC"

/datum/design/research/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAE"

/datum/design/research/circuit/aifixer
	name = "AI integrity restorer"
	id = "aifixer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/aifixer
	sort_string = "HAAAF"

/datum/design/research/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/research/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/research/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACC"

/datum/design/research/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/aiupload
	sort_string = "HAABA"

/datum/design/research/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/borgupload
	sort_string = "HAABB"

/datum/design/research/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/research/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/research/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/research/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/research/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/research/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"

/datum/design/research/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"

/datum/design/research/circuit/mech_recharger
	name = "mech recharger"
	id = "mech_recharger"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/mech_recharger
	sort_string = "HACAA"

/datum/design/research/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/recharge_station
	sort_string = "HACAC"

/datum/design/research/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/research/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/research/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/drone_control
	sort_string = "JAAAD"

/datum/design/research/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAE"

/datum/design/research/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAF"

/datum/design/research/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PLASMA = 3, TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/research/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/research/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/research/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/research/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"

/datum/design/research/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/research/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/research/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/airlock_electronics/secure
	sort_string = "JDAAA"

/datum/design/research/circuit/ordercomp
	name = "supply ordering console"
	id = "ordercomp"
	build_path = /obj/item/weapon/circuitboard/ordercomp
	sort_string = "KAAAA"

/datum/design/research/circuit/supplycomp
	name = "supply control console"
	id = "supplycomp"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/supplycomp
	sort_string = "KAAAB"

/datum/design/research/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/research/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/research/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
	sort_string = "KCAAB"

/datum/design/research/circuit/comconsole
	name = "communications console"
	id = "comconsole"
	build_path = /obj/item/weapon/circuitboard/communications
	sort_string = "LAAAA"

///////////////////////////////////
////////////Mecha Modules//////////
///////////////////////////////////

/datum/design/research/circuit/mecha
	req_tech = list(TECH_DATA = 3)

/datum/design/research/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/research/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

//Ripley ==============================================

/datum/design/research/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/main
	sort_string = "NAAAA"

/datum/design/research/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/peripherals
	sort_string = "NAAAB"

//Odysseus ==============================================

/datum/design/research/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/main
	sort_string = "NAABA"

/datum/design/research/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/peripherals
	sort_string = "NAABB"

//Gygax ==============================================

/datum/design/research/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/main
	sort_string = "NAACA"

/datum/design/research/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/peripherals
	sort_string = "NAACB"

/datum/design/research/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/targeting
	sort_string = "NAACC"

//Durand ==============================================

/datum/design/research/circuit/mecha/durand_main
	name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/main
	sort_string = "NAADA"

/datum/design/research/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/peripherals
	sort_string = "NAADB"

/datum/design/research/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/targeting
	sort_string = "NAADC"

//Phazon ==============================================

/datum/design/research/circuit/mecha/phazon_main
	name = "'Phazon' central control"
	id = "phazon_main"
	req_tech = list(TECH_DATA = 5, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/phazon/main
	sort_string = "NAAEA"

/datum/design/research/circuit/mecha/phazon_peri
	name = "'Phazon' peripherals control"
	id = "phazon_peri"
	req_tech = list(TECH_DATA = 5, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/phazon/peripherals
	sort_string = "NAAEB"

/datum/design/research/circuit/mecha/phazon_targ
	name = "'Phazon' weapon control and targeting"
	id = "phazon_targ"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 3, TECH_BLUESPACE = 5)
	build_path = /obj/item/weapon/circuitboard/mecha/phazon/targeting
	sort_string = "NAAEC"



/datum/design/research/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/datum/design/research/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/research/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/research/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/research/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/research/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/research/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/research/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/research/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/research/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/research/circuit/ntnet_relay
	name = "NTNet Quantum Relay"
	id = "ntnet_relay"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/research/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/aicore
	sort_string = "XAAAA"

/datum/design/research/aimodule
	build_type = IMPRINTER

/datum/design/research/aimodule/AssembleDesignName()
	name = "AI module ([name])"

/datum/design/research/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."


/datum/design/research/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/safeguard
	sort_string = "XABAA"

/datum/design/research/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/oneHuman
	sort_string = "XABAB"

/datum/design/research/aimodule/protectstation
	name = "ProtectStation"
	id = "protectstation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/protectStation
	sort_string = "XABAC"

/datum/design/research/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/aiModule/teleporterOffline
	sort_string = "XABAD"

/datum/design/research/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/quarantine
	sort_string = "XABAE"

/datum/design/research/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/oxygen
	sort_string = "XABAF"

/datum/design/research/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/freeform
	sort_string = "XABAG"

/datum/design/research/aimodule/reset
	name = "Reset"
	id = "reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/reset
	sort_string = "XAAAA"

/datum/design/research/aimodule/purge
	name = "Purge"
	id = "purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/purge
	sort_string = "XAAAB"

// Core modules
/datum/design/research/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/research/aimodule/core/AssembleDesignName()
	name = "AI core module ([name])"

/datum/design/research/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

/datum/design/research/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/weapon/aiModule/freeformcore
	sort_string = "XACAA"

/datum/design/research/aimodule/core/asimov
	name = "Asimov"
	id = "asimov"
	build_path = /obj/item/weapon/aiModule/asimov
	sort_string = "XACAB"

/datum/design/research/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/weapon/aiModule/paladin
	sort_string = "XACAC"

/datum/design/research/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	id = "tyrant"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/tyrant
	sort_string = "XACAD"


/datum/design/research/item/wirer
	name = "Custom wirer tool"
	id = "wirer"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

	build_path = /obj/item/device/integrated_electronics/wirer
	sort_string = "VBVAA"

/datum/design/research/item/debugger
	name = "Custom circuit debugger tool"
	id = "debugger"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/device/integrated_electronics/debugger
	sort_string = "VBVAB"



/datum/design/research/item/custom_circuit_assembly
	name = "Small custom assembly"
	desc = "An customizable assembly for simple, small devices."
	id = "assembly-small"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_POWER = 2)
	build_path = /obj/item/device/electronic_assembly
	sort_string = "VCAAA"

/datum/design/research/item/custom_circuit_assembly/medium
	name = "Medium custom assembly"
	desc = "An customizable assembly suited for more ambitious mechanisms."
	id = "assembly-medium"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	build_path = /obj/item/device/electronic_assembly/medium
	sort_string = "VCAAB"

/datum/design/research/item/custom_circuit_assembly/drone
	name = "Drone custom assembly"
	desc = "An customizable assembly optimized for autonomous devices."
	id = "assembly-drone"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/device/electronic_assembly/drone
	sort_string = "VCAAC"

/datum/design/research/item/custom_circuit_assembly/large
	name = "Large custom assembly"
	desc = "An customizable assembly for large machines."
	id = "assembly-large"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/device/electronic_assembly/large
	sort_string = "VCAAD"

/datum/design/research/item/custom_circuit_assembly/implant
	name = "Implant custom assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	id = "assembly-implant"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 3, TECH_BIO = 5)
	build_path = /obj/item/weapon/implant/integrated_circuit
	sort_string = "VCAAE"
