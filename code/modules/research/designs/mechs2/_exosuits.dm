/datum/design/research/item/exosuit
	category = CAT_MECH + " Equipment"
	build_type = AUTOLATHE | MECHFAB

/datum/design/research/item/mechfab/exosuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] for installation in an exosuit hardpoint."

/datum/design/research/item/mechfab/exosuit
	category = CAT_MECH
