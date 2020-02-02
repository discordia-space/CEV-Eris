/datum/design/research/item/exosuit
	category = "Exosuit Equipment"
	time = 10
	materials = list(MATERIAL_STEEL = 10)

/datum/design/research/item/mechfab/exosuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] for installation in an exosuit hardpoint."

/datum/design/research/item/mechfab/exosuit
	name = "exosuit frame"
	id = "mech_frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 70
	materials = list(MATERIAL_STEEL = 20)
	category = "Exosuits"

#include "exosuits_components.dm"
#include "exosuits_equipment.dm"
