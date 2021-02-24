GLOBAL_DATUM_INIT(set_icon_event, /decl/observ/set_icon, new)
/decl/observ/set_icon
	name = "Icon Changed"
	expected_type = /atom
/atom/SetIcon(value)
	. = ..()
	GLOB.set_icon_event.raise_event(src, value)

GLOBAL_DATUM_INIT(set_icon_state_event, /decl/observ/set_icon_state, new)
/decl/observ/set_icon_state
	name = "Icon State Changed"
	expected_type = /atom
/atom/SetIconState(value)
	. = ..()
	GLOB.set_icon_state_event.raise_event(src, value)
