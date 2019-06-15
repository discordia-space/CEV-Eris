/datum/design/research/item/wirer
	name = "Custom wirer tool"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

	build_path = /obj/item/device/integrated_electronics/wirer
	sort_string = "VBVAA"

/datum/design/research/item/debugger
	name = "Custom circuit debugger tool"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/device/integrated_electronics/debugger
	sort_string = "VBVAB"



/datum/design/research/item/custom_circuit_assembly
	name = "Small custom assembly"
	desc = "An customizable assembly for simple, small devices."
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_POWER = 2)
	build_path = /obj/item/device/electronic_assembly
	sort_string = "VCAAA"

/datum/design/research/item/custom_circuit_assembly/medium
	name = "Medium custom assembly"
	desc = "An customizable assembly suited for more ambitious mechanisms."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	build_path = /obj/item/device/electronic_assembly/medium
	sort_string = "VCAAB"

/datum/design/research/item/custom_circuit_assembly/drone
	name = "Drone custom assembly"
	desc = "An customizable assembly optimized for autonomous devices."
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/device/electronic_assembly/drone
	sort_string = "VCAAC"

/datum/design/research/item/custom_circuit_assembly/large
	name = "Large custom assembly"
	desc = "An customizable assembly for large machines."
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_path = /obj/item/device/electronic_assembly/large
	sort_string = "VCAAD"

/datum/design/research/item/custom_circuit_assembly/implant
	name = "Implant custom assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 3, TECH_BIO = 5)
	build_path = /obj/item/weapon/implant/integrated_circuit
	sort_string = "VCAAE"
