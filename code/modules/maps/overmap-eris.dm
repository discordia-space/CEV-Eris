/obj/effect/overmap/ship/eris
	name = "CEV Eris"
	fore_dir = NORTH
	vessel_mass = 300
	default_delay = 20 SECONDS
	speed_mod = 5 SECONDS

	name_stages = list("CEV Eris", "unknown vessel", "unknown spatial phenomenon")
	icon_stages = list("eris", "ship", "poi")

	start_x = 9
	start_y = 10

/obj/effect/overmap/ship/eris/Process()
	overmap_event_handler.scan_loc(src, loc, can_scan()) // Eris uses its sensors to scan nearby events
	.=..()

/obj/machinery/computer/shuttle_control/explore/exploration_shuttle
	name = "shuttle control console"
	shuttle_tag = "Vasiliy Dokuchaev"
	req_access = list()

/obj/machinery/computer/shuttle_control/explore/hulk
	name = "shuttle control console"
	shuttle_tag = "Hulk"
	req_access = list()
