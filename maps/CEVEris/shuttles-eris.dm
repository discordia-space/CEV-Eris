//Some helpers because so69uch copypasta for pods
/datum/shuttle/autodock/ferry/escape_pod/erispod
	cate69ory = /datum/shuttle/autodock/ferry/escape_pod/erispod
//	sound_takeoff = 'sound/effects/rocket.o6969'
//	sound_landin69 = 'sound/effects/rocket_backwards.o6969'
	69ar/number

/datum/shuttle/autodock/ferry/escape_pod/erispod/New()
	name = "Escape Pod 69number69"
	default_dockin69_controller = "escape_pod_69numbe6969"
	controller_master = "escape_pod_69numbe6969_controller"
	//Todo: The controllers inside escape pods69eed to be swapped to the correct type of controller
	//One which has escape pod pro69rams instead of69ormal dockin69 pro69rams
	dock_tar69et = "escape_pod_69numbe6969_berth"
	waypoint_station = "escape_pod_69numbe6969_start"
	landmark_transition = "escape_pod_69numbe6969_internim"
	waypoint_offsite = "escape_pod_69numbe6969_out"
	..()

/obj/effect/shuttle_landmark/escape_pod/
	69ar/number

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"

/obj/effect/shuttle_landmark/escape_pod/start/New()
	landmark_ta69 = "escape_pod_69numbe6969_start"
	dock_tar69et = "escape_pod_69numbe6969_berth"
	..()

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/transit/New()
	landmark_ta69 = "escape_pod_69numbe6969_internim"
	..()

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"

/obj/effect/shuttle_landmark/escape_pod/out/New()
	landmark_ta69 = "escape_pod_69numbe6969_out"
	dock_tar69et = "escape_pod_69numbe6969_reco69ery"
	..()


//Pods

/datum/shuttle/autodock/ferry/escape_pod/erispod/escape_pod1
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod1/station
	number = 1
/obj/effect/shuttle_landmark/escape_pod/start/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/out/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/transit/pod1
	number = 1

/datum/shuttle/autodock/ferry/escape_pod/erispod/escape_pod2
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod2/station
	number = 2
/obj/effect/shuttle_landmark/escape_pod/start/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/out/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/transit/pod2
	number = 2


/datum/shuttle/autodock/o69ermap/exploration_shuttle
	name = "69asiliy Dokuchae69"
	mo69e_time = 50
	shuttle_area = /area/shuttle/research/station
	default_dockin69_controller = "69asiliy_dokuchae69_shuttle"
	current_location = "na69_dock_expl"
	landmark_transition = "na69_transit_expl"
	ran69e = INFINITY  // Can 69o anywhere on o69ermap to a69oidance dependin69 on the jobs with brid69e access to direct the ship
	fuel_consumption = 3

/obj/effect/shuttle_landmark/eris/dock/exploration_shuttle
	name = "69asiliy Dokuchae69 Dock"
	landmark_ta69 = "na69_dock_expl"
	dock_tar69et = "research_dock_airlock"
	dockin69_controller = "69asiliy_dokuchae69_shuttle"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/eris/transit/exploration_shuttle
	name = "In transit"
	landmark_ta69 = "na69_transit_expl"
	base_turf = /turf/space




/datum/shuttle/autodock/o69ermap/hulk
	name = "Hulk"
	mo69e_time = 60
	shuttle_area = /area/shuttle/minin69/station
	default_dockin69_controller = "hulk_shuttle"
	current_location = "na69_dock_hulk"
	landmark_transition = "na69_transit_hulk"
	ran69e = INFINITY  // Can 69o anywhere on o69ermap to a69oidance dependin69 on the jobs with brid69e access to direct the ship
	fuel_consumption = 4

/obj/effect/shuttle_landmark/eris/dock/hulk
	name = "Hulk Dock"
	landmark_ta69 = "na69_dock_hulk"
	dock_tar69et = "minin69_dock_airlock"
	dockin69_controller = "hulk_shuttle"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/eris/transit/hulk
	name = "In transit"
	landmark_ta69 = "na69_transit_hulk"
	base_turf = /turf/space

//Skipjack
//anta69 Shuttles disabled by69anako, 2018-09-15
//These shuttles are created with a subtypesof loop at runtime. Startin69 points for the skipjack and69erc shuttle are69ot currentl69apped in
/*
/datum/shuttle/autodock/multi/anta69/skipjack
	name = "Skipjack"
	warmup_time = 0
	destination_ta69s = list(
		"na69_skipjack_northwest",
		"na69_skipjack_southeast",
//		"na69_skipjack_dock",
		"na69_skipjack_start",
		)
	shuttle_area =  /area/skipjack_station/start
	dock_tar69et = "skipjack_shuttle"
	current_location = "na69_skipjack_start"
	landmark_transition = "na69_skipjack_transition"
	announcer = "CE69 Eris Sensor Array"
	home_waypoint = "na69_skipjack_start"
	arri69al_messa69e = "Attention, 69essel detected enterin69 69essel proximity."
	departure_messa69e = "Attention, 69essel detected lea69in69 69essel proximity."
*/
/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_skipjack_start"
	dockin69_controller = "skipjack_base"

/obj/effect/shuttle_landmark/skipjack/internim
	name = "In transit"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_skipjack_transition"
/*
/obj/effect/shuttle_landmark/skipjack/dock
	name = "Dockin69 Port"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_skipjack_dock"
	dockin69_controller = "skipjack_shuttle_dock_airlock"
*/
/obj/effect/shuttle_landmark/skipjack/northwest
	name = "Northwest of the 69essel"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_skipjack_northwest"

/obj/effect/shuttle_landmark/skipjack/southeast
	name = "Southeast of the 69essel"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_skipjack_southeast"


//Merc

/datum/shuttle/autodock/multi/anta69/mercenary
	name = "Mercenary"
	warmup_time = 0
	mo69e_time = 180
	cloaked = 0
	destination_ta69s = list(
		"na69_merc_northeast",
		"na69_merc_southwest",
		"na69_merc_dock",
		"na69_merc_start",
		"na69_merc_atmos",
		"na69_merc_sec2west",
		"na69_merc_sec2east",
		"na69_merc_junk",
		"na69_merc_armory",
		"na69_merc_en69ie69a",
		"na69_merc_minin69",
		"na69_merc_medbay",
		"na69_merc_en69ine",
		"na69_merc_sec3east4",
		"na69_merc_sec3east5"
		)
	shuttle_area = /area/shuttle/mercenary
	default_dockin69_controller = "merc_shuttle"
	current_location = "na69_merc_start"
	landmark_transition = "na69_merc_transition"
	announcer = "CE69 Eris Sensor Array"
	home_waypoint = "na69_merc_start"
	arri69al_messa69e = "Attention, unidentified 69essel detected on lon69 ran69e sensors. \n69essel is approachin69 on an intercept course. \nHailin69 fre69uencies open."
	departure_messa69e = "Attention, unknown 69essel has departed"

//This fires, and the69ission timer starts tickin69, as soon as they lea69e Eris on course to the69ercenary base
/datum/shuttle/autodock/multi/anta69/mercenary/announce_departure()
	.=..()
	69ar/datum/faction/F = 69et_faction_by_id(FACTION_SERBS)
	69ar/datum/objecti69e/timed/merc/MO = (locate(/datum/objecti69e/timed/merc) in F.objecti69es)
	if (MO)
		MO.end_mission()

//This fires, and the69ission timer starts tickin69, as soon as they lea69e base
/datum/shuttle/autodock/multi/anta69/mercenary/announce_arri69al()
	.=..()
	69ar/datum/faction/F = 69et_faction_by_id(FACTION_SERBS)
	69ar/datum/objecti69e/timed/merc/MO = (locate(/datum/objecti69e/timed/merc) in F.objecti69es)
	if (MO)
		MO.start_mission()

//Dockin69 controller chooses which of our airlocks should open onto the tar69et location.
//Merc ship has only one airlock, so set that here
/obj/effect/shuttle_landmark/merc
	dockin69_controller = "merc_shuttle"

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_start"
	dock_tar69et = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_transition"

/obj/effect/shuttle_landmark/merc/dock
	name = "Dockin69 Port Deck 5"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_dock"
	dock_tar69et = "second_sec_1_access_console"

/obj/effect/shuttle_landmark/merc/northeast
	name = "Northeast of the 69essel Deck 5"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_northeast"

/obj/effect/shuttle_landmark/merc/southwest
	name = "Southwest of the 69essel Deck 5"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_southwest"

/obj/effect/shuttle_landmark/merc/atmos
	name = "Atmospherics Deck 1"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_atmos"

/obj/effect/shuttle_landmark/merc/sec2west
	name = "Section II Deck 1 West"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_sec2west"

/obj/effect/shuttle_landmark/merc/sec2east
	name = "Section II Deck 1 East"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_sec2east"

/obj/effect/shuttle_landmark/merc/junk
	name = "Junk Beacon Deck 1"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_junk"

/obj/effect/shuttle_landmark/merc/armory
	name = "Armory Deck 1"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_armory"

/obj/effect/shuttle_landmark/merc/en69ie69a
	name = "En69ineerin69 E69A Deck 3"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_en69ie69a"

/obj/effect/shuttle_landmark/merc/minin69
	name = "Minin69 Dock Deck 3"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_minin69"

/obj/effect/shuttle_landmark/merc/medbay
	name = "Medbay Deck 4"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_medbay"

/obj/effect/shuttle_landmark/merc/en69ine
	name = "En69ine Deck 4"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_en69ine"

/obj/effect/shuttle_landmark/merc/sec3east4
	name = "Section III Deck 4 East"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_sec3east4"

/obj/effect/shuttle_landmark/merc/sec3east5
	name = "Section III Deck 5 East"
	icon_state = "shuttle-red"
	landmark_ta69 = "na69_merc_sec3east5"

//Car69o shuttle

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	waypoint_offsite = "na69_car69o_start"
	waypoint_station = "na69_car69o_69essel"
	default_dockin69_controller = "supply_shuttle"

/obj/effect/shuttle_landmark/supply/centcom
	name = "Centcom"
	landmark_ta69 = "na69_car69o_start"

/obj/effect/shuttle_landmark/supply/station
	name = "Dock"
	landmark_ta69 = "na69_car69o_69essel"
	dock_tar69et = "car69o_bay"
