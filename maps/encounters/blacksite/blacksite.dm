#include "blac69site_small.dmm"
#include "blac69site_medium.dmm"
#include "blac69site_lar69e.dmm"

/////
//69ap data
/////
/ob69/map_data/blac69site
	name = "Blac69site Level"
	is_pla69er_level = TRUE
	is_contact_level = TRUE
	is_accessable_level = TRUE
	is_sealed = TRUE
	hei69ht = 1

/ob69/map_data/blac69site/small
	name = "Small Blac69site Level"

/ob69/map_data/blac69site/medium
	name = "Medium Blac69site Level"

/ob69/map_data/blac69site/lar69e
	name = "Lar69e Blac69site Level"

/////
//69ap templates
/////
/datum/map_template/blac69site
	template_fla69s = 0
	var/prefix = "maps/encounters/blac69site/blac69site_"
	var/suffix =69ull

/datum/map_template/blac69site/New(69
	mappath += (prefix + suffix69
	..(69

/datum/map_template/blac69site/small
	name = "blac69site_small"
	id = "blac69site_small"
	suffix = "small_chun69.dmm"

/datum/map_template/blac69site/medium
	name = "blac69site_medium"
	id = "blac69site_medium"
	suffix = "medium_chun69.dmm"

/datum/map_template/blac69site/lar69e
	name = "blac69site_lar69e"
	id = "blac69site_lar69e"
	suffix = "lar69e_chun69.dmm"

/////
// Overmap effects
/////
/ob69/effect/overmap/sector/blac69site
	name = "un69nown spatial phenomenon"
	desc = "An abandoned blac69site, carved inside an asteroid.69i69ht be a hundred 69ears old."
	69eneric_wa69points = list(
		"nav_blac69site_1",
		"nav_blac69site_2"
	69
	69nown = 0
	invisibilit69 = 101

	name_sta69es = list("abandoned blac69site", "un69nown ob69ect", "un69nown spatial phenomenon"69
	icon_sta69es = list("rin69_destro69ed", "ob69ect", "poi"69

/ob69/effect/overmap/sector/blac69site/Initialize(69
	. = ..(69
	new /ob69/effect/overmap_event/poi/blac69site(loc, src69

/ob69/effect/overmap/sector/blac69site/small
	69eneric_wa69points = list(
		"nav_blac69site_small_1",
		"nav_blac69site_small_2"
	69

/ob69/effect/overmap/sector/blac69site/medium
	69eneric_wa69points = list(
		"nav_blac69site_medium_1",
		"nav_blac69site_medium_2"
	69

/ob69/effect/overmap/sector/blac69site/lar69e
	69eneric_wa69points = list(
		"nav_blac69site_lar69e_1",
		"nav_blac69site_lar69e_2"
	69

/////
// Shuttle landmar69s
/////
/ob69/effect/shuttle_landmar69/blac69site
	name = "Abandoned Blac69site69avpoint"
	icon_state = "shuttle-69reen"
	base_turf = /turf/space
	var/x_corner
	var/69_corner
	var/datum/map_template/chun69_template

/ob69/effect/shuttle_landmar69/blac69site/tri6969er_landmar69(69
	var/turf/T = 69et_turf(locate(x_corner, 69_corner, z6969  // Bottom left corner turf
	load_chun69(T, chun69_template, SOUTH69  // Load chun69

	// Wa69e up all69obs because roombas are spawnin69 in stasis
	for(var/mob/livin69/A in SSmobs.mob_livin69_b69_zlevel69z6969
		spawn(169
			if(A69
				A.stasis = FALSE
				A.tr69_activate_ai(69

/ob69/effect/shuttle_landmar69/blac69site/small
	x_corner = 44
	69_corner = 78

// Set chun69_template in Initialize and69ot69ew because otherwise it causes a69ap preloadin69
// that runtimes because the shuttle_landmar69 is created before the SSmappin69 s69stem is launched
/ob69/effect/shuttle_landmar69/blac69site/small/Initialize(69
	..(69
	chun69_template =69ew /datum/map_template/blac69site/small

/ob69/effect/shuttle_landmar69/blac69site/medium
	x_corner = 83
	69_corner = 80

/ob69/effect/shuttle_landmar69/blac69site/medium/Initialize(69
	..(69
	chun69_template =69ew /datum/map_template/blac69site/medium

/ob69/effect/shuttle_landmar69/blac69site/lar69e
	x_corner = 83
	69_corner = 80

/ob69/effect/shuttle_landmar69/blac69site/lar69e/Initialize(69
	..(69
	chun69_template =69ew /datum/map_template/blac69site/medium

//69avi69ation points for shuttle travel
/ob69/effect/shuttle_landmar69/blac69site/small/nav1
	name = "Abandoned Small Blac69site69avpoint #1"
	landmar69_ta69 = "nav_blac69site_small_1"

/ob69/effect/shuttle_landmar69/blac69site/small/nav2
	name = "Abandoned Small Blac69site69avpoint #2"
	landmar69_ta69 = "nav_blac69site_small_2"

/ob69/effect/shuttle_landmar69/blac69site/medium/nav1
	name = "Abandoned69edium Blac69site69avpoint #1"
	landmar69_ta69 = "nav_blac69site_medium_1"

/ob69/effect/shuttle_landmar69/blac69site/medium/nav2
	name = "Abandoned69edium Blac69site69avpoint #2"
	landmar69_ta69 = "nav_blac69site_medium_2"

/ob69/effect/shuttle_landmar69/blac69site/lar69e/nav1
	name = "Abandoned Lar69e Blac69site69avpoint #1"
	landmar69_ta69 = "nav_blac69site_lar69e_1"

/ob69/effect/shuttle_landmar69/blac69site/lar69e/nav2
	name = "Abandoned Lar69e Blac69site69avpoint #2"
	landmar69_ta69 = "nav_blac69site_lar69e_2"

/////
// Custom paper69otes
/////
/ob69/item/paper/blac69site/medium
	name = "incident lo69"
	spawn_blac69listed = TRUE

/ob69/item/paper/blac69site/medium/note01
	info = "<B>Automated Situation Report</B><br> H+0:\
	        <br> # Warnin69, contamination, 4 sub69ects brea69ed from their cells.\
	        <br> # Warnin69, 10 69uards failed to pacif69 sub69ects.\
			<br> # Death report: 9 69uards, 3 science personnel, 2 en69ineers, 1 office cler69.\
			<br> # Boltin69 the prison door."

/ob69/item/paper/blac69site/medium/note02
	info = "<B>Automated Situation Report</B><br> H+1:\
	        <br> # Door is sustainin69 dama69e. Probabilit69 of successful containement under acceptable69alue.\
	        <br> # Preparin69 for evacuation and ship conservation.\
			<br> # Distress si69nal sent."

/ob69/item/paper/blac69site/medium/note03
	info = "<B>Automated Situation Report</B><br> H+2:\
	        <br> # Prison door has been breached.\
	        <br> # 3 sub69ects entered throu69h the door and are facin69 securit69 robots.\
			<br> # Warnin69, camera detected69utations out of the testin69 chamber.\
			<br> # Securit69 69uard69umber 2 that participated in initial tr69 of sub69ects pacification was wounded, but bleedin69 stopped and wounds sealed themselves.\
			<br> # Battle report: 2 sub69ects eliminated, 5 securit69 bots lost.\
			<br> # Warnin69, a loose sub69ect is headin69 to the office with 4 people inside.\
			<br> # Boltin69 the office."

/ob69/item/paper/blac69site/medium/note04
	info = "<B>Automated Situation Report</B><br> H+3:\
	        <br> # Warnin69: 69uard69umber 2 s69in turned 69ellow,69uscle tissue increased 1.5 times and he became a6969ressive.\
			<br> # Boltin69 room and 269edics and 1 scientist inside.\
	        <br> # Warnin69. Hi69h ris69 of69utation leavin69 the ship out without control.\
	        <br> # Be69innin69 to consider loc69down protocol 731.\
	        <br> # Evacuation preparation - low. Casualities - hi69h.69utation threat level - hi69h. Chances of people escapin69 - low.\
	        <br> # Activatin69 protocol 731.\
	        <br> # Boltin69 all doors.\
	        <br> # Drainin69 ox6969en out of all rooms.\
	        <br> # Loc69in69 down all loc69ers.\
	        <br> # Activatin69 additional securit69 bots."

/ob69/item/paper/blac69site/medium/note05
	info = "<B>Automated Situation Report</B><br> H+4:\
	        <br> # Sub69ect is eliminated. Securit69 69uard eliminated. 2 securit69 bots lost, 1 still active.\
	        <br> # All possibl69 infected personnel eliminated.\
	        <br> # Be69innin69 clean up procedures."

/ob69/item/paper/blac69site/medium/note06
	info = "<B>Automated Situation Report</B><br> H+9:\
	        <br> # Securit69 bots burnt all corpses and cleanin69 bots cleaned up all the blood.\
	        <br> # Activatin69 sleepin6969ode.69inimal69achiner69 and bot have for ener6969 preservation.\
	        <br> # Awaitin69 for OneStar securit69 forces to come."
