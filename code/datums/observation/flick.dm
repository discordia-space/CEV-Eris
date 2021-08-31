GLOBAL_DATUM_INIT(flicker_event, /decl/observ/flickered, new)

/decl/observ/flickered
	name = "Flickered"
	expected_type = /atom

/datum/flicker(iconOrState)
	. = ..()
	GLOB.flicker_event.raise_event(src, iconOrState)
