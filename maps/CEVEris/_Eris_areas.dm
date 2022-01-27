
////////////
//CE69 ERIS//
////////////


/area/eris
	ship_area = TRUE
	icon_state = "erisyellow"

//Maintenance

/area/eris/maintenance
	is_maintenance = TRUE
	fla69s = AREA_FLA69_RAD_SHIELDED
	sound_en69 = TUNNEL_ENCLOSED
	turf_initializer =69ew /datum/turf_initializer/maintenance(69
	forced_ambience = list('sound/ambience/maintambience1.o6969','sound/ambience/maintambience2.o6969','sound/ambience/maintambience3.o6969','sound/ambience/maintambience4.o6969','sound/ambience/maintambience5.o6969','sound/ambience/maintambience6.o6969'69
	area_li69ht_color = COLOR_LI69HTIN69_MAINT_DARK

/area/eris/maintenance/junk
	name = "Junk Beacon"
	icon_state = "disposal"

/area/eris/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/eris/maintenance/oldtele
	name = "Reser69e Teleporter"
	icon_state = "erisblue"

/area/eris/maintenance/oldbrid69e
	name = "Old Brid69e"
	icon_state = "erisblue"

/area/eris/maintenance/fueltankstora69e
	name = "Fueltank Stora69e"
	icon_state = "erisblue"

/area/eris/maintenance/section1deck1central
	name = "First Section Deck 1 Fore69aintenance"
	icon_state = "section1deck1central"

/area/eris/maintenance/section1deck2central
	name = "First Section Deck 2 Fore69aintenance"
	icon_state = "section1deck2central"

/area/eris/maintenance/section1deck3central
	name = "First Section Deck 3 Fore69aintenance"
	icon_state = "section1deck3central"

/area/eris/maintenance/section1deck4central
	name = "First Section Deck 4 Fore69aintenance"
	icon_state = "section1deck4central"

/area/eris/maintenance/section1deck5central
	name = "First Section Deck 5 Fore69aintenance"
	icon_state = "section1deck5central"

/area/eris/maintenance/section2deck1port
	name = "Second Section Deck 1 Port69aintenance"
	icon_state = "section2deck1port"

/area/eris/maintenance/section2deck1starboard
	name = "Second Section Deck 1 Starboard69aintenance"
	icon_state = "section2deck1starboard"

/area/eris/maintenance/section2deck2port
	name = "Second Section Deck 2 Port69aintenance"
	icon_state = "section2deck2port"

/area/eris/maintenance/section2deck2starboard
	name = "Second Section Deck 2 Starboard69aintenance"
	icon_state = "section2deck2starboard"

/area/eris/maintenance/section2deck3port
	name = "Second Section Deck 3 Port69aintenance"
	icon_state = "section2deck3port"

/area/eris/maintenance/section2deck3starboard
	name = "Second Section Deck 3 Starboard69aintenance"
	icon_state = "section2deck3starboard"

/area/eris/maintenance/section2deck4port
	name = "Second Section Deck 4 Port69aintenance"
	icon_state = "section2deck4port"

/area/eris/maintenance/section2deck4starboard
	name = "Second Section Deck 4 Starboard69aintenance"
	icon_state = "section2deck4starboard"

/area/eris/maintenance/section2deck4central
	name = "Second Section Deck 4 Central69aintenance"
	icon_state = "section2deck4central"

/area/eris/maintenance/section2deck5port
	name = "Second Section Deck 5 Port69aintenance"
	icon_state = "section2deck5port"

/area/eris/maintenance/section2deck5starboard
	name = "Second Section Deck 5 Starboard69aintenance"
	icon_state = "section2deck5starboard"

/area/eris/maintenance/section3deck1central
	name = "Third Section Deck 1 Central69aintenance"
	icon_state = "section3deck1central"

/area/eris/maintenance/section3deck2port
	name = "Third Section Deck 2 Port69aintenance"
	icon_state = "section3deck2port"

/area/eris/maintenance/section3deck2starboard
	name = "Third Section Deck 2 Starboard69aintenance"
	icon_state = "section3deck2starboard"

/area/eris/maintenance/section3deck3port
	name = "Third Section Deck 3 Port69aintenance"
	icon_state = "section3deck3port"

/area/eris/maintenance/section3deck3starboard
	name = "Third Section Deck 3 Starboard69aintenance"
	icon_state = "section3deck3starboard"

/area/eris/maintenance/section3deck4port
	name = "Third Section Deck 4 Port69aintenance"
	icon_state = "section3deck4port"

/area/eris/maintenance/section3deck4starboard
	name = "Third Section Deck 4 Starboard69aintenance"
	icon_state = "section3deck4starboard"

/area/eris/maintenance/section3deck4central
	name = "Third Section Deck 4 Central69aintenance"
	icon_state = "section3deck4central"

/area/eris/maintenance/section3deck5port
	name = "Third Section Deck 5 Port69aintenance"
	icon_state = "section3deck5port"

/area/eris/maintenance/section3deck5starboard
	name = "Third Section Deck 5 Starboard69aintenance"
	icon_state = "section3deck5starboard"

/area/eris/maintenance/section4deck1central
	name = "Fourth Section Deck 1 Central69aintenance"
	icon_state = "section4deck1central"

/area/eris/maintenance/section4deck2port
	name = "Fourth Section Deck 4 Port69aintenance"
	icon_state = "section4deck2port"

/area/eris/maintenance/section4deck2starboard
	name = "Fourth Section Deck 4 Starboard69aintenance"
	icon_state = "section4deck2starboard"

/area/eris/maintenance/section4deck3port
	name = "Fourth Section Deck 3 Port69aintenance"
	icon_state = "section4deck3port"

/area/eris/maintenance/section4deck4port
	name = "Fourth Section Deck 2 Port69aintenance"
	icon_state = "section4deck4port"

/area/eris/maintenance/section4deck4central
	name = "Fourth Section Deck 2 Central69aintenance"
	icon_state = "section4deck4central"

/area/eris/maintenance/section4deck5port
	name = "Fourth Section Deck 1 Port69aintenance"
	icon_state = "section4deck5port"

/area/eris/maintenance/section4deck5starboard
	name = "Fourth Section Deck 1 Starboard69aintenance"
	icon_state = "section4deck5starboard"


// SUBSTATIONS (Subtype of69aint, that should let them ser69e as shielded area durin69 radstorm69

/area/eris/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_en69 = SMALL_ENCLOSED
	forced_ambience = list('sound/ambience/maintambience.o6969'69


/area/eris/maintenance/substation/en69ineerin69
	name = "En69ineerin69 Substation"
	holomap_color = HOLOMAP_AREACOLOR_EN69INEERIN69

/area/eris/maintenance/substation/section1
	name = "First Section Substation"

/area/eris/maintenance/substation/section2
	name = "Second Section Substation"

/area/eris/maintenance/substation/section3
	name = "Third Section Substation"

/area/eris/maintenance/substation/section4
	name = "Fourth Section Substation"

/area/eris/maintenance/substation/brid69e
	name = "Brid69e Substation"




//Hallway

/area/eris/hallway
	sound_en69 = LAR69E_ENCLOSED
	icon_state = "eris69reen"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/eris/hallway/main/section1
	name = "First Section Hallway"
	icon_state = "hallway1"

/area/eris/hallway/main/section2
	name = "Second Section Hallway"
	icon_state = "hallway2"

/area/eris/hallway/main/section3
	name = "Third Section Hallway"
	icon_state = "hallway3"

/area/eris/hallway/main/section4
	name = "Fourth Section Hallway"
	icon_state = "hallway4"

/area/eris/hallway/side/section3port
	name = "Third Section Port Hallway"
	icon_state = "hallway3side"

/area/eris/hallway/side/section3starboard
	name = "Third Section Starboard Hallway"
	icon_state = "hallway3side"

/area/eris/hallway/side/hydroponicshallway
	name = "Hydroponics Hallway"
	icon_state = "erisyellow"

/area/eris/hallway/side/mor69uehallway
	name = "Mor69ue Hallway"

/area/eris/hallway/side/atmosphericshallway
	name = "Atmospherics Hallway"

/area/eris/hallway/side/cryo
	name = "Cryo Hallway"

/area/eris/hallway/side/brid69ehallway
	name = "Brid69e Hallway"
	icon_state = "erisblue"

/area/eris/hallway/side/eschan69ara
	name = "Escape Han69ar A"
	icon_state = "erisred"
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/eris/hallway/side/eschan69arb
	name = "Escape Han69ar B"
	icon_state = "erisred"
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE




//Command
/area/eris/command
	name = "\improper Command"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/eris/command/brid69e
	name = "\improper Brid69e"
	icon_state = "brid69e"

/area/eris/command/meetin69_room
	name = "\improper Heads of Staff69eetin69 Room"
	icon_state = "brid69e"
	ambience = list(69
	sound_en69 =69EDIUM_SOFTFLOOR

/area/eris/command/brid69ebar
	name = "69.I.P. Bar"
	icon_state = "erisblue"
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/command/captain
	name = "\improper Command - Captain's Office"
	icon_state = "captain"
	sound_en69 = SMALL_SOFTFLOOR
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/command/fo
	name = "\improper Command - First Officer's Office"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR

/area/eris/command/fo/69uarters
	name = "\improper Command - First Officer's 69uarters"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/command/meo
	name = "\improper Research -69EO's Office"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/eris/command/meo/69uarters
	name = "\improper Research -69EO's 69uarters"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/command/exultant
	name = "\improper En69ineerin69 - Exultant Office"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_EN69INEERIN69

/area/eris/command/exultant/69uarters
	name = "\improper En69ineerin69 - Exultant 69uarters"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/command/mbo
	name = "\improper69edbay -69BO's Office"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/eris/command/mbo/69uarters
	name = "\improper69edbay -69BO's 69uarters"
	icon_state = "head_69uarters"
	sound_en69 = SMALL_SOFTFLOOR
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/command/commander
	name = "Ironhammer Commander's Office"
	icon_state = "hammerred"
	sound_en69 = SMALL_SOFTFLOOR
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/eris/command/merchant
	name = "\improper Car69o -69erchant Office"
	icon_state = "69uart"
	sound_en69 = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CAR69O

/area/eris/command/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/eris/command/tcommsat
	ambience = list('sound/ambience/ambisin2.o6969', 'sound/ambience/si69nal.o6969', 'sound/ambience/si69nal.o6969', 'sound/ambience/ambi69en10.o6969'69
	fla69s = AREA_FLA69_CRITICAL

/area/eris/command/tcommsat/chamber
	name = "\improper Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/eris/command/tcommsat/computer
	name = "\improper Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/eris/command/courtroom
	name = "\improper Courtroom"
	icon_state = "courtroom"


//Crew 69uarters
/area/eris/crew_69uarters
	name = "\improper Dormitories"
	icon_state = "Sleep"
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/eris/crew_69uarters/toilet
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"
	sound_en69 = SMALL_ENCLOSED

/area/eris/crew_69uarters/toilet/public
	name = "Public Toilet"
	icon_state = "erisyellow"

/area/eris/crew_69uarters/toilet/medbay
	name = "Medbay Toilet"
	icon_state = "erisyellow"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/eris/crew_69uarters/sleep
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/eris/crew_69uarters/sleep/en69i_wash
	name = "\improper En69ineerin69 Washroom"
	icon_state = "toilet"
	sound_en69 = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_EN69INEERIN69

/area/eris/crew_69uarters/sleep/bedrooms
	name = "\improper Dormitory Bedroom One"
	icon_state = "Sleep"
	sound_en69 = SMALL_SOFTFLOOR

/area/eris/crew_69uarters/sleep/cryo
	name = "\improper Cryo69enic Stora69e"
	icon_state = "Sleep"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	fla69s = AREA_FLA69_CRITICAL | AREA_FLA69_RAD_SHIELDED

/area/eris/crew_69uarters/sleep_male
	name = "\improper69ale Dorm"
	icon_state = "Sleep"

/area/eris/crew_69uarters/sleep_male/toilet_male
	name = "\improper69ale Toilets"
	icon_state = "toilet"
	sound_en69 = SMALL_ENCLOSED

/area/eris/crew_69uarters/sleep_female
	name = "\improper Female Dorm"
	icon_state = "Sleep"

/area/eris/crew_69uarters/sleep_female/toilet_female
	name = "\improper Female Toilets"
	icon_state = "toilet"
	sound_en69 = SMALL_ENCLOSED

/area/eris/crew_69uarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"

/area/eris/crew_69uarters/locker/locker_toilet
	name = "\improper Locker Toilets"
	icon_state = "toilet"
	sound_en69 = SMALL_ENCLOSED

/area/eris/crew_69uarters/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/eris/crew_69uarters/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/eris/crew_69uarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/eris/crew_69uarters/kitchen_stora69e
	name = "\improper Kitchen Stora69e"
	icon_state = "kitchen"

/area/eris/crew_69uarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_en69 = LAR69E_SOFTFLOOR

/area/eris/crew_69uarters/barbackroom
	name = "Bar Backroom"
	icon_state = "eris69reen"

/area/eris/crew_69uarters/bar69uarters
	name = "Bar 69uarters"
	icon_state = "erisblue"

/area/eris/crew_69uarters/theatre
	name = "\improper Theatre"
	icon_state = "Theatre"
	sound_en69 = LAR69E_SOFTFLOOR

/area/eris/crew_69uarters/clownoffice
	name = "Clown Office"
	icon_state = "erisblue"

/area/eris/crew_69uarters/library
 	name = "\improper Library"
 	icon_state = "library"
 	sound_en69 = LAR69E_SOFTFLOOR

/area/eris/crew_69uarters/librarybackroom
	name = "Library Backroom"
	icon_state = "eris69reen"

/area/eris/crew_69uarters/janitor/
	name = "\improper Custodial Closet"
	icon_state = "janitor"

/area/eris/crew_69uarters/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"

/area/eris/crew_69uarters/hydroponics/69arden
	name = "\improper 69arden"
	icon_state = "69arden"

/area/eris/crew_69uarters/clothin69stora69e
	name = "Clothin69 Stora69e"
	icon_state = "erisyellow"

/area/eris/crew_69uarters/pube69a
	name = "Public E.69.A. Stora69e"
	icon_state = "erisblue"

/area/eris/crew_69uarters/publichydro
	name = "Public Hydroponics"
	icon_state = "erisblue"

//69eoTheolo69y

/area/eris/neotheolo69y
	icon_state = "eris69reen"
	area_li69ht_color = COLOR_LI69HTIN69_NEOTHEOLO69Y_BRI69HT
	holomap_color = COLOR_LI69HTIN69_NEOTHEOLO69Y_DARK

/area/eris/neotheolo69y/chapel
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.o6969','sound/ambience/ambicha2.o6969','sound/ambience/ambicha3.o6969','sound/ambience/ambicha4.o6969'69
	sound_en69 = LAR69E_ENCLOSED

/area/eris/neotheolo69y/stora69e
	name = "\improper Church Stora69e"
	icon_state = "erisyellow"
	area_li69ht_color = COLOR_LI69HTIN69_NEOTHEOLO69Y_BRI69HT

/area/eris/neotheolo69y/bioreactor
	name = "\improper Church Bioreactor Room"
	icon_state = "erisblue"
	area_li69ht_color = COLOR_LI69HTIN69_NEOTHEOLO69Y_BRI69HT

/area/eris/neotheolo69y/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"
	area_li69ht_color = COLOR_LI69HTIN69_NEOTHEOLO69Y_DARK

/area/eris/neotheolo69y/chapelritualroom
	name = "Chapel Rituals Room"
	icon_state = "eris69reen"

/area/eris/neotheolo69y/bio69enerator
	name = "\improper Church Bio69enerator Room"
	icon_state = "erisred"
	area_li69ht_color = COLOR_LI69HTIN69_NEOTHEOLO69Y_BRI69HT

/area/eris/neotheolo69y/churchbarracks
	name = "Church Barracks"
	icon_state = "erisblue"

/area/eris/neotheolo69y/churchcorridor
	name = "Church Hallway"
	icon_state = "erisyellow"

/area/eris/neotheolo69y/churchbooth
	name = "Chapel 69endin69 Booth"
	icon_state = "erisyellow"

//En69ineerin69

/area/eris/en69ineerin69
	name = "\improper En69ineerin69"
	icon_state = "en69ineerin69"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	holomap_color = HOLOMAP_AREACOLOR_EN69INEERIN69
	ambience = list('sound/ambience/technoambient1.o6969','sound/ambience/technoambient2.o6969','sound/ambience/technoambient3.o6969','sound/ambience/technoambient4.o6969','sound/ambience/technoambient5.o6969','sound/ambience/technoambient6.o6969'69

/area/eris/en69ineerin69/69ra69ity_69enerator
	name = "69ra69ity 69enerator Room"
	icon_state = "blue"
	fla69s = AREA_FLA69_CRITICAL

/area/eris/en69ineerin69/shield_69enerator
	name = "Shield 69enerator Room"
	icon_state = "blueold"

/area/eris/en69ineerin69/lon69_ran69e_scanner
	name = "Lon69 Ran69e Scanner Room"
	icon_state = "blueold"

/area/eris/en69ineerin69/atmos
 	name = "\improper Atmospherics"
 	icon_state = "atmos"
 	sound_en69 = LAR69E_ENCLOSED

/area/eris/en69ineerin69/atmos/monitorin69
	name = "\improper Atmospherics69onitorin69 Room"
	icon_state = "atmos_monitorin69"
	sound_en69 = STANDARD_STATION

/area/eris/en69ineerin69/atmos/stora69e
	name = "\improper Atmospherics Stora69e"
	icon_state = "atmos_stora69e"
	sound_en69 = SMALL_ENCLOSED

/area/eris/en69ineerin69/drone_fabrication
	name = "\improper En69ineerin69 Drone Fabrication"
	icon_state = "drone_fab"
	sound_en69 = SMALL_ENCLOSED

/area/eris/en69ineerin69/en69ine_smes
	name = "\improper En69ineerin69 SMES"
	icon_state = "en69ine_smes"
	sound_en69 = SMALL_ENCLOSED

/area/eris/en69ineerin69/en69ine_room
	name = "\improper En69ine Room"
	icon_state = "en69ine"
	sound_en69 = LAR69E_ENCLOSED
	fla69s = AREA_FLA69_CRITICAL
	ambience = list('sound/ambience/technoen69ineambient.o6969'69

/area/eris/en69ineerin69/en69ine_airlock
	name = "\improper En69ine Room Airlock"
	icon_state = "en69ine"

/area/eris/en69ineerin69/en69ine_monitorin69
	name = "\improper En69ine69onitorin69 Room"
	icon_state = "en69ine_monitorin69"
	fla69s = AREA_FLA69_CRITICAL

/area/eris/en69ineerin69/en69ine_waste
	name = "\improper En69ine Waste Handlin69"
	icon_state = "en69ine_waste"
	fla69s = AREA_FLA69_CRITICAL

/area/eris/en69ineerin69/en69ineerin69_monitorin69
	name = "\improper En69ineerin6969onitorin69 Room"
	icon_state = "en69ine_monitorin69"

/area/eris/en69ineerin69/foyer
	name = "\improper En69ineerin69 Foyer"
	icon_state = "en69ineerin69_foyer"

/area/eris/en69ineerin69/stora69e
	name = "\improper En69ineerin69 Stora69e"
	icon_state = "en69ineerin69_stora69e"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/en69ineerin69/break_room
	name = "\improper En69ineerin69 Break Room"
	icon_state = "en69ineerin69_break"
	sound_en69 =69EDIUM_SOFTFLOOR

/area/eris/en69ineerin69/en69ine_e69a
	name = "\improper En69ine E69A"
	icon_state = "en69ine_e69a"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/en69ineerin69/locker_room
	name = "\improper En69ineerin69 Locker Room"
	icon_state = "en69ineerin69_locker"

/area/eris/en69ineerin69/workshop
	name = "\improper En69ineerin69 Workshop"
	icon_state = "en69ineerin69_workshop"

/area/eris/en69ineerin69/starboardhallway
	name = "En69ineerin69 Starboard Hallway"
	icon_state = "eris69reen"

/area/eris/en69ineerin69/wastin69room
	name = "Wastin69 Room"
	icon_state = "erisred"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/en69ineerin69/post
	name = "En69ineerin69 Post"
	icon_state = "erisred"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/en69ineerin69/wastin69room
	name = "Wastin69 Room"
	icon_state = "erisred"

/area/eris/en69ineerin69/techstora69e
	name = "Tools Stora69e"
	icon_state = "erisred"

/area/eris/en69ineerin69/telecommonitor
	name = "Telecommunications69onitor Room"
	icon_state = "erisred"

/area/eris/en69ineerin69/breakroom
	name = "En69ineerin69 Break Room"
	icon_state = "erisred"

/area/eris/en69ineerin69/freezercontrol
	name = "Freezer Control"
	icon_state = "erisred"

/area/eris/en69ineerin69/atmoscontrol
	name = "Atmospherics Control"
	icon_state = "erisred"

/area/eris/en69ineerin69/en69e69a
	name = "En69ineerin69 E.69.A. Stora69e"
	icon_state = "erisblue"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/en69ineerin69/construction
	name = "\improper En69ineerin69 Construction Area"
	is_maintenance = TRUE
	icon_state = "yellow"

/area/eris/en69ineerin69/propulsion
	name = "Propulsion Han69ar"
	icon_state = "propulsion"

/area/eris/en69ineerin69/propulsion/left
	name = "Left Propulsion Han69ar"

/area/eris/en69ineerin69/propulsion/ri69ht
	name = "Ri69ht Propulsion Han69ar"

//MedBay
/area/eris/medical/medbay
	name = "\improper69edical"
	icon_state = "eris69reen"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/eris/medical/medbay
	name = "\improper69edbay"
	icon_state = "medbay"
	ambience = list('sound/ambience/si69nal.o6969'69

//Medbay is a lar69e area, these additional areas help le69el out APC load.
/area/eris/medical/medbay2
	name = "\improper69edbay Hallway - Starboard"
	icon_state = "medbay2"
	ambience = list('sound/ambience/si69nal.o6969'69

/area/eris/medical/medbay3
	name = "\improper69edbay Hallway - Fore"
	icon_state = "medbay3"
	ambience = list('sound/ambience/si69nal.o6969'69

/area/eris/medical/medbay4
	name = "\improper69edbay Hallway - Aft"
	icon_state = "medbay4"
	ambience = list('sound/ambience/si69nal.o6969'69

/area/eris/medical/biostora69e
	name = "\improper Secondary Stora69e"
	icon_state = "medbay2"
	ambience = list('sound/ambience/si69nal.o6969'69

/area/eris/medical/reception
	name = "\improper69edbay Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/si69nal.o6969'69

/area/eris/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/si69nal.o6969'69
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/medical/medbreak
	name = "\improper Break Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/si69nal.o6969'69

/area/eris/medical/patients_rooms
	name = "\improper Patient's Rooms"
	icon_state = "patients"

/area/eris/medical/ward
	name = "\improper Reco69ery Ward"
	icon_state = "patients"

/area/eris/medical/patient_a
	name = "\improper Isolation A"
	icon_state = "patients"

/area/eris/medical/patient_b
	name = "\improper Isolation B"
	icon_state = "patients"

/area/eris/medical/patient_c
	name = "\improper Isolation C"
	icon_state = "patients"

/area/eris/medical/patient_win69
	name = "\improper Patient Win69"
	icon_state = "patients"

/area/eris/medical/cmostore
	name = "\improper Secure Stora69e"
	icon_state = "CMO"

/area/eris/medical/69irolo69y
	name = "\improper 69irolo69y"
	icon_state = "69irolo69y"

/area/eris/medical/69irolo69yaccess
	name = "\improper 69irolo69y Access"
	icon_state = "69irolo69y"

/area/eris/medical/mor69ue
	name = "\improper69or69ue"
	icon_state = "mor69ue"
	ambience = list('sound/ambience/ambimo1.o6969','sound/ambience/ambimo2.o6969'69

/area/eris/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/eris/medical/sur69ery
	name = "\improper Operatin69 Theatre 1"
	icon_state = "sur69ery"

/area/eris/medical/sur69ery2
	name = "\improper Operatin69 Theatre 2"
	icon_state = "sur69ery"

/area/eris/medical/sur69eryobs
	name = "\improper Operation Obser69ation Room"
	icon_state = "sur69ery"

/area/eris/medical/sur69eryprep
	name = "\improper Pre-Op Prep Room"
	icon_state = "sur69ery"

/area/eris/medical/cryo
	name = "\improper Cryo69enics"
	icon_state = "cryo"

/area/eris/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/eris/medical/69enetics
	name = "\improper 69enetics Lab"
	icon_state = "69enetics"

/area/eris/medical/69enetics_clonin69
	name = "\improper Clonin69 Lab"
	icon_state = "clonin69"

/area/eris/medical/sleeper
	name = "\improper Emer69ency Treatment Centre"
	icon_state = "exam_room"

/area/eris/medical/chemstor
	name = "Chemical Stora69e"
	icon_state = "erisblue"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/medical/mede69a
	name = "Medical E.69.A. Stora69e"
	icon_state = "erisblue"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/medical/paramedic
	name = "\improper Paramedic Closet"
	icon_state = "erisyellow"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/medical/medbay/iso
	name = "Isolation Win69"
	icon_state = "eris69reen"

/area/eris/medical/medbay/uppercor
	name = "Medbay Upper Coridor"
	icon_state = "eris69reen"




//Security

/area/eris/security
	name = "Security"
	icon_state = "security"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/eris/security/main
	name = "\improper Security Office"
	icon_state = "security"

/area/eris/security/lobby
	name = "\improper Security Lobby"
	icon_state = "security"

/area/eris/security/bri69
	name = "\improper Security - Bri69"
	icon_state = "bri69"

/area/eris/security/bri69/prison_break(69
	for(69ar/obj/structure/closet/secure_closet/bri69/temp_closet in src69
		temp_closet.set_locked(FALSE69
	for(69ar/obj/machinery/door_timer/temp_timer in src69
		temp_timer.releasetime = 1
	..(69

/area/eris/security/prison
	name = "\improper Security - Prison Win69"
	icon_state = "sec_prison"

/area/eris/security/prison/prison_break(69
	for(69ar/obj/structure/closet/secure_closet/bri69/temp_closet in src69
		temp_closet.set_locked(FALSE69
	for(69ar/obj/machinery/door_timer/temp_timer in src69
		temp_timer.releasetime = 1
	..(69

/area/eris/security/warden
	name = "\improper Security - 69unnery Ser69eant's Office"
	icon_state = "Warden"

/area/eris/security/armoury
	name = "\improper Security - Armory"
	icon_state = "Warden"

/area/eris/security/detecti69es_office
	name = "\improper Security - Forensic Office"
	icon_state = "detecti69e"
	sound_en69 =69EDIUM_SOFTFLOOR

/area/eris/security/ran69e
	name = "\improper Security - Firin69 Ran69e"
	icon_state = "firin69ran69e"

/area/eris/security/tactical
	name = "\improper Security - Tactical E69uipment"
	icon_state = "Tactical"

/area/eris/security/nuke_stora69e
	name = "\improper 69ault"
	icon_state = "nuke_stora69e"

/area/eris/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint2
	name = "\improper Security - Arri69al Checkpoint"
	icon_state = "security"

/area/eris/security/checkpoint/supply
	name = "Security Post - Car69o Bay"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint/en69ineerin69
	name = "Security Post - En69ineerin69"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint/medical
	name = "Security Post -69edbay"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/eris/security/69acantoffice
	name = "\improper 69acant Office"
	icon_state = "security"

/area/eris/security/69acantoffice2
	name = "\improper 69acant Office"
	icon_state = "security"

/area/eris/security/inspectors_office
	name = "Inspectors Office"
	icon_state = "hammerblue"
	area_li69ht_color = COLOR_LI69HTIN69_CREW_SOFT

/area/eris/security/disposal
	name = "Security Disposal"
	fla69s = AREA_FLA69_RAD_SHIELDED
	icon_state = "hammerblue"
	is_maintenance = TRUE

/area/eris/security/barracks
	name = "Ironhammer Barracks"
	icon_state = "hammerblue"

/area/eris/security/prisoncells
	name = "Prison Cells"
	icon_state = "hammerblue"

/area/eris/security/e69idencestora69e
	name = "E69idence Stora69e"
	icon_state = "hammerred"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/security/armory
	name = "Armory"
	icon_state = "hammerred"

/area/eris/security/exerooms
	name = "Executi69e Rooms"
	icon_state = "hammerred"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/security/maintpost
	name = "Maintenance Post"
	fla69s = AREA_FLA69_RAD_SHIELDED
	icon_state = "hammerred"
	is_maintenance = TRUE


/area/eris/69uartermaster
	name = "\improper69erchants"
	icon_state = "69uart"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	holomap_color = HOLOMAP_AREACOLOR_CAR69O

/area/eris/69uartermaster/office
	name = "\improper Car69o Office"
	icon_state = "69uartoffice"

/area/eris/69uartermaster/artistoffice
	name = "\improper 69uild Artist Office"
	icon_state = "erisyellow"

/area/eris/69uartermaster/stora69e
	name = "\improper Car69o Bay"
	icon_state = "69uartstora69e"
	sound_en69 = LAR69E_ENCLOSED

/area/eris/69uartermaster/minin69dock
	name = "\improper Car69o69inin69 Dock"
	icon_state = "minin69"

/area/eris/69uartermaster/disposaldrop
	name = "Disposal and Deli69ery"
	icon_state = "erisred"

/area/eris/69uartermaster/han69arsupply
	name = "Supply Shuttle Han69ar"
	icon_state = "erisblue"

/area/eris/69uartermaster/misc
	name = "\improper Car69o Barracks"
	icon_state = "erisyellow"

//Research and De69elopment
/area/eris/rnd
	area_li69ht_color = COLOR_LI69HTIN69_SCI_BRI69HT
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	ambience = list('sound/ambience/researchambient1.o6969','sound/ambience/researchambient2.o6969','sound/ambience/researchambient3.o6969','sound/ambience/researchambient4.o6969','sound/ambience/researchambient5.o6969','sound/ambience/researchambient6.o6969','sound/ambience/researchambient7.o6969','sound/ambience/researchambient8.o6969','sound/ambience/researchambient9.o6969'69

/area/eris/rnd/research
	name = "\improper Research and De69elopment"
	icon_state = "research"

/area/eris/rnd/scient
	name = "Science Department Entrance"
	icon_state = "erisblue"

/area/eris/rnd/dockin69
	name = "\improper Research Dock"
	icon_state = "research_dock"

/area/eris/rnd/lab
	name = "\improper Research Lab"
	icon_state = "toxlab"

/area/eris/rnd/char69ebay
	name = "\improper69ech Bay"
	icon_state = "mechbay"

/area/eris/rnd/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/eris/rnd/rdoffice
	name = "\improper69oebius Expedition O69erseer's Office"
	icon_state = "head_69uarters"

/area/eris/rnd/supermatter
	name = "\improper Supermatter Lab"
	icon_state = "toxlab"

/area/eris/rnd/xenobiolo69y
	name = "\improper Xenobiolo69y Lab"
	icon_state = "xeno_lab"

/area/eris/rnd/xenobiolo69y/xenoflora_stora69e
	name = "\improper Xenoflora Stora69e"
	icon_state = "xeno_f_store"

/area/eris/rnd/xenobiolo69y/xenoflora
	name = "\improper Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/eris/rnd/stora69e
	name = "\improper Toxins Stora69e"
	icon_state = "toxstora69e"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/rnd/mixin69
	name = "\improper Toxins69ixin69 Room"
	icon_state = "toxmix"

/area/eris/rnd/misc_lab
	name = "\improper69iscellaneous Research"
	icon_state = "toxmisc"
	area_li69ht_color = COLOR_LI69HTIN69_SCI_DARK

/area/eris/rnd/ser69er
	name = "\improper Ser69er Room"
	icon_state = "ser69er"

/area/eris/rnd/podbay
	name = "Pod Bay"
	icon_state = "erisblue"

/area/eris/rnd/anomal
	name = "Anomalous Research Laboratory"
	icon_state = "erisblue"

/area/eris/rnd/anomalisolone
	name = "Anomalous Research Isolation One"
	fla69s = AREA_FLA69_RAD_SHIELDED
	icon_state = "eris69reen"

/area/eris/rnd/anomalisoltwo
	name = "Anomalous Research Isolation Two"
	fla69s = AREA_FLA69_RAD_SHIELDED
	icon_state = "eris69reen"

/area/eris/rnd/anomalisolthree
	name = "Anomalous Research Isolation Three"
	fla69s = AREA_FLA69_RAD_SHIELDED
	icon_state = "eris69reen"

/area/eris/rnd/ser69er
	name = "\improper Research Ser69er Room"
	fla69s = AREA_FLA69_RAD_SHIELDED
	icon_state = "ser69er"

//Stora69e
/area/eris/stora69e/primary
	name = "Primary Tool Stora69e"
	icon_state = "primarystora69e"

/area/eris/stora69e/tech
	name = "Technical Stora69e"
	icon_state = "auxstora69e"
