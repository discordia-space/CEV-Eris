/datum/design/research/item/wirer
	name = "Custom wirer tool"
	build_path = /obj/item/device/integrated_electronics/wirer
	sort_string = "VBVAA"
	category = CAT_CIRCUITS

/datum/design/research/item/debugger
	name = "Custom circuit debugger tool"
	build_path = /obj/item/device/integrated_electronics/debugger
	sort_string = "VBVAB"
	category = CAT_CIRCUITS

/datum/design/research/item/detailer
	name = "Custom circuit detailer tool"
	build_path = /obj/item/device/integrated_electronics/detailer
	sort_string = "VBVAC"
	category = CAT_CIRCUITS

/datum/design/research/item/analyzer
	name = "Custom circuit analyzer tool"
	build_path = /obj/item/device/integrated_electronics/analyzer
	sort_string = "VBVAD"
	category = CAT_CIRCUITS

/datum/design/research/item/custom_circuit_assembly
	name = "Small custom assembly"
	desc = "An customizable assembly for simple, small devices."
	build_path = /obj/item/device/electronic_assembly
	sort_string = "VCAAA"
	category = CAT_CIRCUITS

/datum/design/research/item/custom_circuit_assembly/AssembleDesignMaterials(atom/temp_atom)
	if(istype(temp_atom, /obj))
		for(var/obj/item/device/electronic_assembly/A in temp_atom.GetAllContents(includeSelf = TRUE))
			A.matter[MATERIAL_STEEL] = round((A.max_complexity + A.max_components) / 20)
	..()

/datum/design/research/item/custom_circuit_assembly/medium
	name = "Medium custom assembly"
	desc = "An customizable assembly suited for more ambitious mechanisms."
	build_path = /obj/item/device/electronic_assembly/medium
	sort_string = "VCAAB"

/datum/design/research/item/custom_circuit_assembly/drone
	name = "Drone custom assembly"
	desc = "An customizable assembly optimized for autonomous devices."
	build_path = /obj/item/device/electronic_assembly/drone
	sort_string = "VCAAC"

/datum/design/research/item/custom_circuit_assembly/large
	name = "Large custom assembly"
	desc = "An customizable assembly for large machines."
	build_path = /obj/item/device/electronic_assembly/large
	sort_string = "VCAAD"

/datum/design/research/item/custom_circuit_assembly/implant
	name = "Implant custom assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	build_path = /obj/item/implant/integrated_circuit
	sort_string = "VCAAE"

/datum/design/research/item/custom_circuit_assembly/printer
	name = "Integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	build_path = /obj/item/device/integrated_circuit_printer
	sort_string = "VCAAF"

/datum/design/research/item/custom_circuit_assembly/advanced_designs
	name = "Integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced
	sort_string = "VCAAG"

/datum/design/research/item/custom_circuit_assembly/cloning
	name = "Integrated circuit printer cloning disk - instance printing"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allow printer to print assemblies in seconds, litterally."
	build_path = /obj/item/disk/integrated_circuit/upgrade/clone
	sort_string = "VCAAH"
