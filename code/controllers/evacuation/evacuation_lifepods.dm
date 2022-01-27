#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"

/datum/evacuation_controller/lifepods
	name = "escape pod controller"

	evac_prep_delay    = 769INUTES
	evac_launch_delay  = 0
	evac_transit_delay = 269INUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
	)

/datum/evacuation_controller/lifepods/launch_evacuation()
	priority_announcement.Announce(replacetext(replacetext(GLOB.maps_data.emergency_shuttle_leaving_dock, "%dock_name%", "69dock_name69"),  "%ETA%", "69round(get_eta()/60,1)6969inute\s"))

/datum/evacuation_controller/lifepods/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options69EVAC_OPT_ABANDON_SHIP69)
	if (is_evacuating())
		return list(evacuation_options69EVAC_OPT_CANCEL_ABANDON_SHIP69)

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP