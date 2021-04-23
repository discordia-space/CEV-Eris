#include "junk_tractor_beam.dmm"

/obj/map_data/junk_tractor_beam
	name = "Junk Field Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = FALSE
	height = 1
	is_sealed = TRUE

/area/junk_tractor_beam
	icon_state = "away"
	name = "Junk Field"
	var/asteroid_spawns = list()
	var/mob_spawns = list()
	var/teleporter_spawns = list()
	var/teleporter
	var/portal
