/datum/design/research/item/stock_part
	build_type = AUTOLATHE | PROTOLATHE
	name_category = "component"

/datum/design/research/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/research/item/stock_part/basic_capacitor
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "CAAAA"

/datum/design/research/item/stock_part/adv_capacitor
	req_tech = list(TECH_POWER = 3)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "CAAAB"

/datum/design/research/item/stock_part/super_capacitor
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "CAAAC"

/datum/design/research/item/stock_part/micro_mani
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "CAABA"

/datum/design/research/item/stock_part/nano_mani
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "CAABB"

/datum/design/research/item/stock_part/pico_mani
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "CAABC"

/datum/design/research/item/stock_part/basic_matter_bin
	req_tech = list(TECH_MATERIAL = 1)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "CAACA"

/datum/design/research/item/stock_part/adv_matter_bin
	req_tech = list(TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "CAACB"

/datum/design/research/item/stock_part/super_matter_bin
	req_tech = list(TECH_MATERIAL = 5)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "CAACC"

/datum/design/research/item/stock_part/basic_micro_laser
	req_tech = list(TECH_MAGNET = 1)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "CAADA"

/datum/design/research/item/stock_part/high_micro_laser
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "CAADB"

/datum/design/research/item/stock_part/ultra_micro_laser
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "CAADC"

/datum/design/research/item/stock_part/basic_sensor
	req_tech = list(TECH_MAGNET = 1)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"

/datum/design/research/item/stock_part/adv_sensor
	req_tech = list(TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"

/datum/design/research/item/stock_part/phasic_sensor
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"


// Telecomm parts
/datum/design/research/item/stock_part/subspace_ansible
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "UAAAA"

/datum/design/research/item/stock_part/hyperwave_filter
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
	sort_string = "UAAAB"

/datum/design/research/item/stock_part/subspace_amplifier
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "UAAAC"

/datum/design/research/item/stock_part/subspace_treatment
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "UAAAD"

/datum/design/research/item/stock_part/subspace_analyzer
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "UAAAE"

/datum/design/research/item/stock_part/subspace_crystal
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "UAAAF"

/datum/design/research/item/stock_part/subspace_transmitter
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "UAAAG"


// SMES coils
/datum/design/research/item/stock_part/smes_coil
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4, TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/smes_coil
	sort_string = "UAAAH"

/datum/design/research/item/stock_part/smes_coil/weak
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/smes_coil/weak
	sort_string = "UAAAI"

/datum/design/research/item/stock_part/smes_coil/super_io
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/smes_coil/super_io
	sort_string = "UAAAJ"

/datum/design/research/item/stock_part/smes_coil/super_capacity
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/smes_coil/super_capacity
	sort_string = "UAAAK"


// RPED
/datum/design/research/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"
