/datum/map_template/ruin/exoplanet/lodge
	name = "lodge"
	id = "lodge"
	description = "A wood cabin."
	suffix = "lodge/lodge.dmm"
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT

/datum/map_template/ruin/exoplanet/lodge/lodge2
	name = "lodge 2"
	id = "lodge2"
	suffix = "lodge/lodge2.dmm"

/datum/map_template/ruin/exoplanet/lodge/lodge3
	name = "lodge 3"
	id = "lodge3"
	suffix = "lodge/lodge3.dmm"

/turf/floor/wood/usedup
	initial_gas = list(GAS_CO2 = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)

/area/map_template/lodge
	name = "\improper Lodge"
	icon_state = "blue"
