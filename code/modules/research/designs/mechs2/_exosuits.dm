/datum/design/research/item/exosuit
	category = CAT_MECHA + " Equipment"
	time = 10
	materials = list(MATERIAL_STEEL = 10)

/datum/design/research/item/mechfab/exosuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] for installation in an exosuit hardpoint."

/datum/design/research/item/mechfab/exosuit
	category = CAT_MECHA

#include "exosuits_components.dm"
#include "exosuits_equipment.dm"
