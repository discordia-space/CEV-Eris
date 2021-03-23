GLOBAL_DATUM_INIT(update_icon_event, /decl/observ/update_icon, new)

/decl/observ/update_icon
	name = "Updated Icon"
	expected_type = /atom

/atom/update_icon()
	. = ..()
	GLOB.update_icon_event.raise_event(src, icon, icon_state, overlays)
