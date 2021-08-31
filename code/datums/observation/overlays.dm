GLOBAL_DATUM_INIT(add_overlays_event, /decl/observ/add_overlays, new)
GLOBAL_DATUM_INIT(remove_overlays_event, /decl/observ/remove_overlays, new)
GLOBAL_DATUM_INIT(set_overlays_event, /decl/observ/set_overlays, new)
GLOBAL_DATUM_INIT(cut_overlays_event, /decl/observ/cut_overlays, new)

/decl/observ/add_overlays
	name = "Added Overlays"
	expected_type = /atom
/decl/observ/remove_overlays
	name = "Removed Overlays"
	expected_type = /atom
/decl/observ/set_overlays
	name = "Set Overlays"
	expected_type = /atom
/decl/observ/cut_overlays
	name = "Cut Overlays"
	expected_type = /atom

/atom/add_overlays()
	. = ..()
	GLOB.add_overlays_event.raise_event(src, args)
/atom/remove_overlays()
	. = ..()
	GLOB.remove_overlays_event.raise_event(src, args)
/atom/set_overlays(list/value)
	. = ..()
	GLOB.set_overlays_event.raise_event(src, args)
/atom/cut_overlays()
	. = ..()
	GLOB.cut_overlays_event.raise_event(src, args)

