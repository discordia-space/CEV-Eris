/datum/design/research/item/powercell
	build_type = AUTOLATHE | PROTOLATHE | MECHFAB
	name_category = "power cell"

/datum/design/research/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of [initial(C.autorecharging) ? "microreactor" : "power"] cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/research/item/powercell/large/basic
	name = "Moebius \"Power-Geyser 2000L\""
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell/large/moebius
	category = "Misc"
	sort_string = "DAAAA"

/datum/design/research/item/powercell/large/high
	name = "Moebius \"Power-Geyser 7000L\""
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/large/moebius/high
	category = "Misc"
	sort_string = "DAAAB"

/datum/design/research/item/powercell/large/super
	name = "Moebius \"Power-Geyser 13000L\""
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/large/moebius/super
	category = "Misc"
	sort_string = "DAAAC"

/datum/design/research/item/powercell/large/hyper
	name = "Moebius \"Power-Geyser 18000L\""
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/large/moebius/hyper
	category = "Misc"
	sort_string = "DAAAD"

/datum/design/research/item/powercell/medium/basic
	name = "Moebius \"Power-Geyser 700M\""
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell/medium/moebius
	category = "Misc"
	sort_string = "DAAAF"

/datum/design/research/item/powercell/medium/high
	name = "Moebius \"Power-Geyser 900M\""
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/medium/moebius/high
	category = "Misc"
	sort_string = "DAAAI"

/datum/design/research/item/powercell/medium/super
	name = "Moebius \"Power-Geyser 1000M\""
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/medium/moebius/super
	category = "Misc"
	sort_string = "DAAAO"

/datum/design/research/item/powercell/medium/hyper
	name = "Moebius \"Power-Geyser 1300M\""
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/medium/moebius/hyper
	category = "Misc"
	sort_string = "DAAAP"

/datum/design/research/item/powercell/small/basic
	name = "Moebius \"Power-Geyser 120S\""
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell/small/moebius
	category = "Misc"
	sort_string = "DAAAQ"

/datum/design/research/item/powercell/small/high
	name = "Moebius \"Power-Geyser 250S\""
	build_type = PROTOLATHE | MECHFAB
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/small/moebius/high
	category = "Misc"
	sort_string = "DAAAV"

/datum/design/research/item/powercell/small/super
	name = "Moebius \"Power-Geyser 300S\""
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/small/moebius/super
	category = "Misc"
	sort_string = "DAAAW"

/datum/design/research/item/powercell/small/hyper
	name = "Moebius \"Power-Geyser 400S\""
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/small/moebius/hyper
	category = "Misc"
	sort_string = "DAAAX"

/datum/design/research/item/powercell/large/nuclear
	name = "Moebius \"Atomcell 13000L\""
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/large/moebius/nuclear
	category = "Misc"
	sort_string = "DAAAZ"

/datum/design/research/item/powercell/medium/nuclear
	name = "Moebius \"Atomcell 1000M\""
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/medium/moebius/nuclear
	category = "Misc"
	sort_string = "DAABA"

/datum/design/research/item/powercell/small/nuclear
	name = "Moebius \"Atomcell 300S\""
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/cell/small/moebius/nuclear
	category = "Misc"
	sort_string = "DAABB"
