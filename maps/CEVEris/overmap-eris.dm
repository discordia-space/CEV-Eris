/obj/effect/overmap/ship/eris
	name = "CEV Eris"
	fore_dir = NORTH
	vessel_mass = 300
	default_delay = 20 SECONDS
	speed_mod = 5 SECONDS

	start_x = 9
	start_y = 10

	restricted_waypoints = list(
		"Vasiliy Dokuchaev" = list("nav_dock_expl"), 	//can't have random shuttles popping inside the ship
		"Hulk" = list("nav_dock_hulk")
	)

/*	generic_waypoints = list(
		"nav_merc_deck1",
		"nav_merc_deck2",
		"nav_merc_deck3",
		"nav_merc_deck4",
		"nav_merc_deck5",
		"nav_ert_deck1",
		"nav_ert_deck2",
		"nav_ert_deck3",
		"nav_ert_deck4",
		"nav_ert_deck5",
		"nav_deck1_calypso",
		"nav_deck2_calypso",
		"nav_deck3_calypso",
		"nav_deck4_calypso",
		"nav_bridge_calypso",
		"nav_deck1_guppy",
		"nav_deck2_guppy",
		"nav_deck3_guppy",
		"nav_deck4_guppy",
		"nav_bridge_guppy",
		"nav_hangar_aquila",
		"nav_deck1_aquila",
		"nav_deck2_aquila",
		"nav_deck3_aquila",
		"nav_deck4_aquila",
		"nav_bridge_aquila"
	)*/

/obj/machinery/computer/shuttle_control/explore/exploration_shuttle
	name = "shuttle control console"
	shuttle_tag = "Vasiliy Dokuchaev"
	req_access = list()

/obj/machinery/computer/shuttle_control/explore/hulk
	name = "shuttle control console"
	shuttle_tag = "Hulk"
	req_access = list()