#include "blacksite_small.dmm"
#include "blacksite_medium.dmm"
#include "blacksite_large.dmm"

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

/obj/effect/shuttle_landmark/blacksite/nav1
	name = "Abandoned Blacksite Navpoint #1"
	icon_state = "shuttle-green"
	landmark_tag = "nav_blacksite_1"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/blacksite/nav2
	name = "Abandoned Blacksite Navpoint #2"
	icon_state = "shuttle-green"
	landmark_tag = "nav_blacksite_2"
	base_turf = /turf/space

/obj/effect/shuttle_landmark/blacksite/nav1/small
	name = "Abandoned Small Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_small_1"

/obj/effect/shuttle_landmark/blacksite/nav2/small
	name = "Abandoned Small Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_small_2"

/obj/effect/shuttle_landmark/blacksite/nav1/medium
	name = "Abandoned Small Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_medium_1"

/obj/effect/shuttle_landmark/blacksite/nav2/medium
	name = "Abandoned Small Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_medium_2"

/obj/effect/shuttle_landmark/blacksite/nav1/large
	name = "Abandoned Medium Blacksite Navpoint #1"
	landmark_tag = "nav_blacksite_large_1"

/obj/effect/shuttle_landmark/blacksite/nav2/large
	name = "Abandoned Large Blacksite Navpoint #2"
	landmark_tag = "nav_blacksite_large_2"

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
