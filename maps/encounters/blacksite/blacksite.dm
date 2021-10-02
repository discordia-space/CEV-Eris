#include "blacksite_small.dmm"
#include "blacksite_medium.dmm"
#include "blacksite_large.dmm"

/////
// Map data
/////
/obj/map_data/blacksite
	name = "Blacksite Level"
	is_player_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	is_sealed = TRUE
	height = 1

/obj/map_data/blacksite/small
	name = "Small Blacksite Level"

/obj/map_data/blacksite/medium
	name = "Medium Blacksite Level"

/obj/map_data/blacksite/large
	name = "Large Blacksite Level"

/////
// Map templates
/////
/datum/map_template/blacksite
	template_flags = 0
	var/prefix = "maps/encounters/blacksite/blacksite_"
	var/suffix = null

/datum/map_template/blacksite/New()
	mappath += (prefix + suffix)
	..()

/datum/map_template/blacksite/small
	name = "blacksite_small"
	id = "blacksite_small"
	suffix = "small_chunk.dmm"

/datum/map_template/blacksite/medium
	name = "blacksite_medium"
	id = "blacksite_medium"
	suffix = "medium_chunk.dmm"

/datum/map_template/blacksite/large
	name = "blacksite_large"
	id = "blacksite_large"
	suffix = "large_chunk.dmm"

/////
// Overmap effect
/////
/obj/effect/overmap/sector/blacksite
	name = "unknown spatial phenomenon"
	desc = "An abandoned blacksite, carved inside an asteroid. Might be a hundred years old."
	generic_waypoints = list(
		"nav_blacksite_1",
		"nav_blacksite_2"
	)
	known = 0
	invisibility = 101

	name_stages = list("abandoned blacksite", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("ring_destroyed", "object", "poi")

/obj/effect/overmap/sector/blacksite/Initialize()
	. = ..()
	new /obj/effect/overmap_event/poi/blacksite(loc, src)

/obj/effect/overmap/sector/blacksite/small
	generic_waypoints = list(
		"nav_blacksite_small_1",
		"nav_blacksite_small_2"
	)

/obj/effect/overmap/sector/blacksite/medium
	generic_waypoints = list(
		"nav_blacksite_medium_1",
		"nav_blacksite_medium_2"
	)

/obj/effect/overmap/sector/blacksite/large
	generic_waypoints = list(
		"nav_blacksite_large_1",
		"nav_blacksite_large_2"
	)

/////
// Shuttle landmarks
/////
/obj/effect/shuttle_landmark/blacksite
	name = "Abandoned Blacksite Navpoint"
	icon_state = "shuttle-green"
	base_turf = /turf/space
	var/x_corner
	var/y_corner
	var/datum/map_template/chunk_template

/obj/effect/shuttle_landmark/blacksite/trigger_landmark()
	var/turf/T = get_turf(locate(x_corner, y_corner, z))  // Bottom left corner turf
	load_chunk(T, chunk_template, SOUTH)  // Load chunk

/obj/effect/shuttle_landmark/blacksite/small
	x_corner = 44
	y_corner = 78
	chunk_template = new /datum/map_template/blacksite/small

/obj/effect/shuttle_landmark/blacksite/medium
	x_corner = 83
	y_corner = 80
	chunk_template = new /datum/map_template/blacksite/medium

/obj/effect/shuttle_landmark/blacksite/large
	x_corner = 83
	y_corner = 80
	chunk_template = new /datum/map_template/blacksite/medium

/obj/effect/shuttle_landmark/blacksite/small/nav1
	name = "Abandoned Small Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_small_1"

/obj/effect/shuttle_landmark/blacksite/small/nav2
	name = "Abandoned Small Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_small_2"

/obj/effect/shuttle_landmark/blacksite/medium/nav1
	name = "Abandoned Small Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_medium_1"

/obj/effect/shuttle_landmark/blacksite/medium/nav2
	name = "Abandoned Small Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_medium_2"

/obj/effect/shuttle_landmark/blacksite/large/nav1
	name = "Abandoned Medium Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_large_1"

/obj/effect/shuttle_landmark/blacksite/large/nav2
	name = "Abandoned Large Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_large_2"

/////
// Custom paper notes
/////
/obj/item/paper/blacksite/medium
	name = "incident log"
	spawn_blacklisted = TRUE

/obj/item/paper/blacksite/medium/note01
	info = "<B>Automated Situation Report</B><br> H+0:\
	        <br> # Warning, contamination, 4 subjects breaked from their cells.\
	        <br> # Warning, 10 guards failed to pacify subjects.\
			<br> # Death report: 9 guards, 3 science personnel, 2 engineers, 1 office clerk.\
			<br> # Bolting the prison door."

/obj/item/paper/blacksite/medium/note02
	info = "<B>Automated Situation Report</B><br> H+1:\
	        <br> # Door is sustaining damage. Probability of successful containement under acceptable value.\
	        <br> # Preparing for evacuation and ship conservation.\
			<br> # Distress signal sent."

/obj/item/paper/blacksite/medium/note03
	info = "<B>Automated Situation Report</B><br> H+2:\
	        <br> # Prison door has been breached.\
	        <br> # 3 subjects entered through the door and are facing security robots.\
			<br> # Warning, camera detected mutations out of the testing chamber.\
			<br> # Security guard number 2 that participated in initial try of subjects pacification was wounded, but bleeding stopped and wounds sealed themselves.\
			<br> # Battle report: 2 subjects eliminated, 5 security bots lost.\
			<br> # Warning, a loose subject is heading to the office with 4 people inside.\
			<br> # Bolting the office."

/obj/item/paper/blacksite/medium/note04
	info = "<B>Automated Situation Report</B><br> H+3:\
	        <br> # Warning: guard number 2 skin turned yellow, muscle tissue increased 1.5 times and he became aggressive.\
			<br> # Bolting room and 2 medics and 1 scientist inside.\
	        <br> # Warning. High risk of mutation leaving the ship out without control.\
	        <br> # Beginning to consider lockdown protocol 731.\
	        <br> # Evacuation preparation - low. Casualities - high. Mutation threat level - high. Chances of people escaping - low.\
	        <br> # Activating protocol 731.\
	        <br> # Bolting all doors.\
	        <br> # Draining oxygen out of all rooms.\
	        <br> # Locking down all lockers.\
	        <br> # Activating additional security bots."

/obj/item/paper/blacksite/medium/note05
	info = "<B>Automated Situation Report</B><br> H+4:\
	        <br> # Subject is eliminated. Security guard eliminated. 2 security bots lost, 1 still active.\
	        <br> # All possibly infected personnel eliminated.\
	        <br> # Beginning clean up procedures."

/obj/item/paper/blacksite/medium/note06
	info = "<B>Automated Situation Report</B><br> H+9:\
	        <br> # Security bots burnt all corpses and cleaning bots cleaned up all the blood.\
	        <br> # Activating sleeping mode. Minimal machinery and bot have for energy preservation.\
	        <br> # Awaiting for OneStar security forces to come."
