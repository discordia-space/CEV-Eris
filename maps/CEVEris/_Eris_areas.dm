
////////////
//CEV ERIS//
////////////


/area/eris
	ship_area = TRUE
	icon_state = "erisyellow"

//Maintenance

/area/eris/maintenance
	is_maintenance = TRUE
	flags = AREA_FLAG_RAD_SHIELDED
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	forced_ambience = list('sound/ambience/maintambience1.ogg','sound/ambience/maintambience2.ogg','sound/ambience/maintambience3.ogg','sound/ambience/maintambience4.ogg','sound/ambience/maintambience5.ogg','sound/ambience/maintambience6.ogg')
	area_light_color = COLOR_LIGHTING_MAINT_DARK

/area/eris/maintenance/junk
	name = "Junk Beacon"
	icon_state = "disposal"

/area/eris/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/eris/maintenance/oldtele
	name = "Reserve Teleporter"
	icon_state = "erisblue"

/area/eris/maintenance/oldbridge
	name = "Old Bridge"
	icon_state = "erisblue"

/area/eris/maintenance/fueltankstorage
	name = "Fueltank Storage"
	icon_state = "erisblue"

/area/eris/maintenance/section1deck1central
	name = "First Section Deck 1 Fore Maintenance"
	icon_state = "section1deck1central"

/area/eris/maintenance/section1deck2central
	name = "First Section Deck 2 Fore Maintenance"
	icon_state = "section1deck2central"

/area/eris/maintenance/section1deck3central
	name = "First Section Deck 3 Fore Maintenance"
	icon_state = "section1deck3central"

/area/eris/maintenance/section1deck4central
	name = "First Section Deck 4 Fore Maintenance"
	icon_state = "section1deck4central"

/area/eris/maintenance/section1deck5central
	name = "First Section Deck 5 Fore Maintenance"
	icon_state = "section1deck5central"

/area/eris/maintenance/section2deck1port
	name = "Second Section Deck 1 Port Maintenance"
	icon_state = "section2deck1port"

/area/eris/maintenance/section2deck1starboard
	name = "Second Section Deck 1 Starboard Maintenance"
	icon_state = "section2deck1starboard"

/area/eris/maintenance/section2deck2port
	name = "Second Section Deck 2 Port Maintenance"
	icon_state = "section2deck2port"

/area/eris/maintenance/section2deck2starboard
	name = "Second Section Deck 2 Starboard Maintenance"
	icon_state = "section2deck2starboard"

/area/eris/maintenance/section2deck3port
	name = "Second Section Deck 3 Port Maintenance"
	icon_state = "section2deck3port"

/area/eris/maintenance/section2deck3starboard
	name = "Second Section Deck 3 Starboard Maintenance"
	icon_state = "section2deck3starboard"

/area/eris/maintenance/section2deck4port
	name = "Second Section Deck 4 Port Maintenance"
	icon_state = "section2deck4port"

/area/eris/maintenance/section2deck4starboard
	name = "Second Section Deck 4 Starboard Maintenance"
	icon_state = "section2deck4starboard"

/area/eris/maintenance/section2deck4central
	name = "Second Section Deck 4 Central Maintenance"
	icon_state = "section2deck4central"

/area/eris/maintenance/section2deck5port
	name = "Second Section Deck 5 Port Maintenance"
	icon_state = "section2deck5port"

/area/eris/maintenance/section2deck5starboard
	name = "Second Section Deck 5 Starboard Maintenance"
	icon_state = "section2deck5starboard"

/area/eris/maintenance/section3deck1central
	name = "Third Section Deck 1 Central Maintenance"
	icon_state = "section3deck1central"

/area/eris/maintenance/section3deck2port
	name = "Third Section Deck 2 Port Maintenance"
	icon_state = "section3deck2port"

/area/eris/maintenance/section3deck2starboard
	name = "Third Section Deck 2 Starboard Maintenance"
	icon_state = "section3deck2starboard"

/area/eris/maintenance/section3deck3port
	name = "Third Section Deck 3 Port Maintenance"
	icon_state = "section3deck3port"

/area/eris/maintenance/section3deck3starboard
	name = "Third Section Deck 3 Starboard Maintenance"
	icon_state = "section3deck3starboard"

/area/eris/maintenance/section3deck4port
	name = "Third Section Deck 4 Port Maintenance"
	icon_state = "section3deck4port"

/area/eris/maintenance/section3deck4starboard
	name = "Third Section Deck 4 Starboard Maintenance"
	icon_state = "section3deck4starboard"

/area/eris/maintenance/section3deck4central
	name = "Third Section Deck 4 Central Maintenance"
	icon_state = "section3deck4central"

/area/eris/maintenance/section3deck5port
	name = "Third Section Deck 5 Port Maintenance"
	icon_state = "section3deck5port"

/area/eris/maintenance/section3deck5starboard
	name = "Third Section Deck 5 Starboard Maintenance"
	icon_state = "section3deck5starboard"

/area/eris/maintenance/section4deck1central
	name = "Fourth Section Deck 1 Central Maintenance"
	icon_state = "section4deck1central"

/area/eris/maintenance/section4deck2port
	name = "Fourth Section Deck 4 Port Maintenance"
	icon_state = "section4deck2port"

/area/eris/maintenance/section4deck2starboard
	name = "Fourth Section Deck 4 Starboard Maintenance"
	icon_state = "section4deck2starboard"

/area/eris/maintenance/section4deck3port
	name = "Fourth Section Deck 3 Port Maintenance"
	icon_state = "section4deck3port"

/area/eris/maintenance/section4deck4port
	name = "Fourth Section Deck 2 Port Maintenance"
	icon_state = "section4deck4port"

/area/eris/maintenance/section4deck4central
	name = "Fourth Section Deck 2 Central Maintenance"
	icon_state = "section4deck4central"

/area/eris/maintenance/section4deck5port
	name = "Fourth Section Deck 1 Port Maintenance"
	icon_state = "section4deck5port"

/area/eris/maintenance/section4deck5starboard
	name = "Fourth Section Deck 1 Starboard Maintenance"
	icon_state = "section4deck5starboard"


// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/eris/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	forced_ambience = list('sound/ambience/maintambience.ogg')


/area/eris/maintenance/substation/engineering
	name = "Engineering Substation"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/eris/maintenance/substation/section1
	name = "First Section Substation"

/area/eris/maintenance/substation/section2
	name = "Second Section Substation"

/area/eris/maintenance/substation/section3
	name = "Third Section Substation"

/area/eris/maintenance/substation/section4
	name = "Fourth Section Substation"

/area/eris/maintenance/substation/bridge
	name = "Bridge Substation"




//Hallway

/area/eris/hallway
	sound_env = LARGE_ENCLOSED
	icon_state = "erisgreen"
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

/area/eris/hallway/side/morguehallway
	name = "Morgue Hallway"

/area/eris/hallway/side/atmosphericshallway
	name = "Atmospherics Hallway"

/area/eris/hallway/side/cryo
	name = "Cryo Hallway"

/area/eris/hallway/side/bridgehallway
	name = "Bridge Hallway"
	icon_state = "erisblue"

/area/eris/hallway/side/eschangara
	name = "Escape Hangar A"
	icon_state = "erisred"
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

/area/eris/hallway/side/eschangarb
	name = "Escape Hangar B"
	icon_state = "erisred"
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE




//Command
/area/eris/command
	name = "\improper Command"
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/eris/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"

/area/eris/command/meeting_room
	name = "\improper Heads of Staff Meeting Room"
	icon_state = "bridge"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/eris/command/bridgebar
	name = "V.I.P. Bar"
	icon_state = "erisblue"
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/command/captain
	name = "\improper Command - Captain's Office"
	icon_state = "captain"
	sound_env = SMALL_SOFTFLOOR
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/command/fo
	name = "\improper Command - First Officer's Office"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR

/area/eris/command/fo/quarters
	name = "\improper Command - First Officer's Quarters"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/command/meo
	name = "\improper Research - MEO's Office"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/eris/command/meo/quarters
	name = "\improper Research - MEO's Quarters"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/command/exultant
	name = "\improper Engineering - Exultant Office"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/eris/command/exultant/quarters
	name = "\improper Engineering - Exultant Quarters"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/command/mbo
	name = "\improper Medbay - MBO's Office"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/eris/command/mbo/quarters
	name = "\improper Medbay - MBO's Quarters"
	icon_state = "head_quarters"
	sound_env = SMALL_SOFTFLOOR
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/command/commander
	name = "Ironhammer Commander's Office"
	icon_state = "hammerred"
	sound_env = SMALL_SOFTFLOOR
	area_light_color = COLOR_LIGHTING_CREW_SOFT
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/eris/command/merchant
	name = "\improper Cargo - Merchant Office"
	icon_state = "quart"
	sound_env = SMALL_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/eris/command/teleporter
	name = "\improper Teleporter"
	icon_state = "teleporter"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/eris/command/tcommsat
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')
	flags = AREA_FLAG_CRITICAL

/area/eris/command/tcommsat/chamber
	name = "\improper Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/eris/command/tcommsat/computer
	name = "\improper Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/eris/command/courtroom
	name = "\improper Courtroom"
	icon_state = "courtroom"


//Crew Quarters
/area/eris/crew_quarters
	name = "\improper Dormitories"
	icon_state = "Sleep"
	area_light_color = COLOR_LIGHTING_CREW_SOFT
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/eris/crew_quarters/toilet
	name = "\improper Dormitory Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/eris/crew_quarters/toilet/public
	name = "Public Toilet"
	icon_state = "erisyellow"

/area/eris/crew_quarters/toilet/medbay
	name = "Medbay Toilet"
	icon_state = "erisyellow"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/eris/crew_quarters/sleep
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/eris/crew_quarters/sleep/engi_wash
	name = "\improper Engineering Washroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/eris/crew_quarters/sleep/bedrooms
	name = "\improper Dormitory Bedroom One"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR

/area/eris/crew_quarters/sleep/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "Sleep"
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	flags = AREA_FLAG_CRITICAL | AREA_FLAG_RAD_SHIELDED

/area/eris/crew_quarters/sleep_male
	name = "\improper Male Dorm"
	icon_state = "Sleep"

/area/eris/crew_quarters/sleep_male/toilet_male
	name = "\improper Male Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/eris/crew_quarters/sleep_female
	name = "\improper Female Dorm"
	icon_state = "Sleep"

/area/eris/crew_quarters/sleep_female/toilet_female
	name = "\improper Female Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/eris/crew_quarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"

/area/eris/crew_quarters/locker/locker_toilet
	name = "\improper Locker Toilets"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/eris/crew_quarters/fitness
	name = "\improper Fitness Room"
	icon_state = "fitness"

/area/eris/crew_quarters/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/eris/crew_quarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/eris/crew_quarters/kitchen_storage
	name = "\improper Kitchen Storage"
	icon_state = "kitchen"

/area/eris/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/eris/crew_quarters/barconference
	name = "\improper Conference Room"
	icon_state = "erisblue"
	sound_env = LARGE_SOFTFLOOR

/area/eris/crew_quarters/barbackroom
	name = "Bar Backroom"
	icon_state = "erisgreen"

/area/eris/crew_quarters/barquarters
	name = "Bar Quarters"
	icon_state = "erisblue"

/area/eris/crew_quarters/theatre
	name = "\improper Theatre"
	icon_state = "Theatre"
	sound_env = LARGE_SOFTFLOOR

/area/eris/crew_quarters/clownoffice
	name = "Clown Office"
	icon_state = "erisblue"

/area/eris/crew_quarters/library
 	name = "\improper Library"
 	icon_state = "library"
 	sound_env = LARGE_SOFTFLOOR

/area/eris/crew_quarters/librarybackroom
	name = "Library Backroom"
	icon_state = "erisgreen"

/area/eris/crew_quarters/janitor/
	name = "\improper Custodial Closet"
	icon_state = "janitor"

/area/eris/crew_quarters/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"

/area/eris/crew_quarters/hydroponics/garden
	name = "\improper Garden"
	icon_state = "garden"

/area/eris/crew_quarters/clothingstorage
	name = "Clothing Storage"
	icon_state = "erisyellow"

/area/eris/crew_quarters/pubeva
	name = "Public E.V.A. Storage"
	icon_state = "erisblue"

/area/eris/crew_quarters/publichydro
	name = "Public Hydroponics"
	icon_state = "erisblue"

// NeoTheology

/area/eris/neotheology
	icon_state = "erisgreen"
	area_light_color = COLOR_LIGHTING_NEOTHEOLOGY_BRIGHT
	holomap_color = COLOR_LIGHTING_NEOTHEOLOGY_DARK

/area/eris/neotheology/chapel
	name = "\improper Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')
	sound_env = LARGE_ENCLOSED

/area/eris/neotheology/storage
	name = "\improper Church Storage"
	icon_state = "erisyellow"
	area_light_color = COLOR_LIGHTING_NEOTHEOLOGY_BRIGHT

/area/eris/neotheology/bioreactor
	name = "\improper Church Bioreactor Room"
	icon_state = "erisblue"
	area_light_color = COLOR_LIGHTING_NEOTHEOLOGY_BRIGHT

/area/eris/neotheology/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"
	area_light_color = COLOR_LIGHTING_NEOTHEOLOGY_DARK

/area/eris/neotheology/chapelritualroom
	name = "Chapel Rituals Room"
	icon_state = "erisgreen"

/area/eris/neotheology/biogenerator
	name = "\improper Church Biogenerator Room"
	icon_state = "erisred"
	area_light_color = COLOR_LIGHTING_NEOTHEOLOGY_BRIGHT

/area/eris/neotheology/churchbarracks
	name = "Church Barracks"
	icon_state = "erisblue"

/area/eris/neotheology/churchcorridor
	name = "Church Hallway"
	icon_state = "erisyellow"

/area/eris/neotheology/churchbooth
	name = "Chapel Vending Booth"
	icon_state = "erisyellow"

//Engineering

/area/eris/engineering
	name = "\improper Engineering"
	icon_state = "engineering"
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	ambience = list('sound/ambience/technoambient1.ogg','sound/ambience/technoambient2.ogg','sound/ambience/technoambient3.ogg','sound/ambience/technoambient4.ogg','sound/ambience/technoambient5.ogg','sound/ambience/technoambient6.ogg')

/area/eris/engineering/gravity_generator
	name = "Gravity Generator Room"
	icon_state = "blue"
	flags = AREA_FLAG_CRITICAL

/area/eris/engineering/shield_generator
	name = "Shield Generator Room"
	icon_state = "blueold"

/area/eris/engineering/long_range_scanner
	name = "Long Range Scanner Room"
	icon_state = "blueold"

/area/eris/engineering/atmos
 	name = "\improper Atmospherics"
 	icon_state = "atmos"
 	sound_env = LARGE_ENCLOSED

/area/eris/engineering/atmos/monitoring
	name = "\improper Atmospherics Monitoring Room"
	icon_state = "atmos_monitoring"
	sound_env = STANDARD_STATION

/area/eris/engineering/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/eris/engineering/drone_fabrication
	name = "\improper Engineering Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/eris/engineering/engine_smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/eris/engineering/engine_room
	name = "\improper Engine Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	flags = AREA_FLAG_CRITICAL
	ambience = list('sound/ambience/technoengineambient.ogg')

/area/eris/engineering/engine_airlock
	name = "\improper Engine Room Airlock"
	icon_state = "engine"

/area/eris/engineering/engine_monitoring
	name = "\improper Engine Monitoring Room"
	icon_state = "engine_monitoring"
	flags = AREA_FLAG_CRITICAL

/area/eris/engineering/engine_waste
	name = "\improper Engine Waste Handling"
	icon_state = "engine_waste"
	flags = AREA_FLAG_CRITICAL

/area/eris/engineering/engineering_monitoring
	name = "\improper Engineering Monitoring Room"
	icon_state = "engine_monitoring"

/area/eris/engineering/foyer
	name = "\improper Engineering Foyer"
	icon_state = "engineering_foyer"

/area/eris/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "engineering_storage"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/engineering/breakroom
	name = "\improper Engineering Break Room"
	icon_state = "engineering_break"
	sound_env = MEDIUM_SOFTFLOOR

/area/eris/engineering/engine_eva
	name = "\improper Engine EVA"
	icon_state = "engine_eva"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/engineering/locker_room
	name = "\improper Engineering Locker Room"
	icon_state = "engineering_locker"

/area/eris/engineering/workshop
	name = "\improper Engineering Workshop"
	icon_state = "engineering_workshop"

/area/eris/engineering/starboardhallway
	name = "Engineering Starboard Hallway"
	icon_state = "erisgreen"

/area/eris/engineering/wastingroom
	name = "Wasting Room"
	icon_state = "erisred"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/engineering/post
	name = "Engineering Post"
	icon_state = "erisred"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/engineering/wastingroom
	name = "Wasting Room"
	icon_state = "erisred"

/area/eris/engineering/techstorage
	name = "Tools Storage"
	icon_state = "erisred"

/area/eris/engineering/telecommonitor
	name = "Telecommunications Monitor Room"
	icon_state = "erisred"

/area/eris/engineering/freezercontrol
	name = "Freezer Control"
	icon_state = "erisred"

/area/eris/engineering/atmoscontrol
	name = "Atmospherics Control"
	icon_state = "erisred"

/area/eris/engineering/engeva
	name = "Engineering E.V.A. Storage"
	icon_state = "erisblue"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/engineering/construction
	name = "\improper Engineering Construction Area"
	is_maintenance = TRUE
	icon_state = "yellow"

/area/eris/engineering/propulsion
	name = "Propulsion Hangar"
	icon_state = "propulsion"

/area/eris/engineering/propulsion/left
	name = "Left Propulsion Hangar"

/area/eris/engineering/propulsion/right
	name = "Right Propulsion Hangar"

//MedBay
/area/eris/medical/medbay
	name = "\improper Medical"
	icon_state = "erisgreen"
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/eris/medical/medbay
	name = "\improper Medbay"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

//Medbay is a large area, these additional areas help level out APC load.
/area/eris/medical/medbay2
	name = "\improper Medbay Hallway - Starboard"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/eris/medical/medbay3
	name = "\improper Medbay Hallway - Fore"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/eris/medical/medbay4
	name = "\improper Medbay Hallway - Aft"
	icon_state = "medbay4"
	ambience = list('sound/ambience/signal.ogg')

/area/eris/medical/biostorage
	name = "\improper Secondary Storage"
	icon_state = "medbay2"
	ambience = list('sound/ambience/signal.ogg')

/area/eris/medical/reception
	name = "\improper Medbay Reception"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/eris/medical/psych
	name = "\improper Psych Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/medical/medbreak
	name = "\improper Break Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')

/area/eris/medical/patients_rooms
	name = "\improper Patient's Rooms"
	icon_state = "patients"

/area/eris/medical/ward
	name = "\improper Recovery Ward"
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

/area/eris/medical/patient_wing
	name = "\improper Patient Wing"
	icon_state = "patients"

/area/eris/medical/cmostore
	name = "\improper Secure Storage"
	icon_state = "CMO"

/area/eris/medical/virology
	name = "\improper Virology"
	icon_state = "virology"

/area/eris/medical/virologyaccess
	name = "\improper Virology Access"
	icon_state = "virology"

/area/eris/medical/morgue
	name = "\improper Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')

/area/eris/medical/chemistry
	name = "\improper Chemistry"
	icon_state = "chem"

/area/eris/medical/surgery
	name = "\improper Operating Theatre 1"
	icon_state = "surgery"

/area/eris/medical/surgery2
	name = "\improper Operating Theatre 2"
	icon_state = "surgery"

/area/eris/medical/surgeryobs
	name = "\improper Operation Observation Room"
	icon_state = "surgery"

/area/eris/medical/surgeryprep
	name = "\improper Pre-Op Prep Room"
	icon_state = "surgery"

/area/eris/medical/cryo
	name = "\improper Cryogenics"
	icon_state = "cryo"

/area/eris/medical/exam_room
	name = "\improper Exam Room"
	icon_state = "exam_room"

/area/eris/medical/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"

/area/eris/medical/genetics_cloning
	name = "\improper Cloning Lab"
	icon_state = "cloning"

/area/eris/medical/sleeper
	name = "\improper Emergency Treatment Centre"
	icon_state = "exam_room"

/area/eris/medical/chemstor
	name = "Chemical Storage"
	icon_state = "erisblue"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/medical/medeva
	name = "Medical E.V.A. Storage"
	icon_state = "erisblue"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/medical/paramedic
	name = "\improper Paramedic Closet"
	icon_state = "erisyellow"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/medical/medbay/iso
	name = "Isolation Wing"
	icon_state = "erisgreen"

/area/eris/medical/medbay/uppercor
	name = "Medbay Upper Coridor"
	icon_state = "erisgreen"

/area/eris/medical/medbay/organs
	name = "\improper Visceral Research"
	icon_state = "erisgreen"



//Security

/area/eris/security
	name = "Security"
	icon_state = "security"
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/eris/security/main
	name = "\improper Security Office"
	icon_state = "security"

/area/eris/security/lobby
	name = "\improper Security Lobby"
	icon_state = "security"

/area/eris/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"

/area/eris/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.set_locked(FALSE)
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/eris/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"

/area/eris/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.set_locked(FALSE)
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.releasetime = 1
	..()

/area/eris/security/warden
	name = "\improper Security - Gunnery Sergeant's Office"
	icon_state = "Warden"

/area/eris/security/armoury
	name = "\improper Security - Armory"
	icon_state = "Warden"

/area/eris/security/detectives_office
	name = "\improper Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/eris/security/range
	name = "\improper Security - Firing Range"
	icon_state = "firingrange"

/area/eris/security/tactical
	name = "\improper Security - Tactical Equipment"
	icon_state = "Tactical"

/area/eris/security/nuke_storage
	name = "\improper Vault"
	icon_state = "nuke_storage"

/area/eris/security/checkpoint
	name = "\improper Security Checkpoint"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint2
	name = "\improper Security - Arrival Checkpoint"
	icon_state = "security"

/area/eris/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/eris/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/eris/security/vacantoffice
	name = "\improper Vacant Office"
	icon_state = "security"

/area/eris/security/vacantoffice2
	name = "\improper Vacant Office"
	icon_state = "security"

/area/eris/security/inspectors_office
	name = "Inspectors Office"
	icon_state = "hammerblue"
	area_light_color = COLOR_LIGHTING_CREW_SOFT

/area/eris/security/disposal
	name = "Security Disposal"
	flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "hammerblue"
	is_maintenance = TRUE

/area/eris/security/barracks
	name = "Ironhammer Barracks"
	icon_state = "hammerblue"

/area/eris/security/prisoncells
	name = "Prison Cells"
	icon_state = "hammerblue"

/area/eris/security/evidencestorage
	name = "Evidence Storage"
	icon_state = "hammerred"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/security/armory
	name = "Armory"
	icon_state = "hammerred"

/area/eris/security/exerooms
	name = "Executive Rooms"
	icon_state = "hammerred"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/security/maintpost
	name = "Maintenance Post"
	flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "hammerred"
	is_maintenance = TRUE


/area/eris/quartermaster
	name = "\improper Merchants"
	icon_state = "quart"
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/eris/quartermaster/office
	name = "\improper Cargo Office"
	icon_state = "quartoffice"

/area/eris/quartermaster/artistoffice
	name = "\improper Guild Artist Office"
	icon_state = "erisyellow"

/area/eris/quartermaster/storage
	name = "\improper Cargo Bay"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/eris/quartermaster/miningdock
	name = "\improper Cargo Mining Dock"
	icon_state = "mining"

/area/eris/quartermaster/disposaldrop
	name = "Disposal and Delivery"
	icon_state = "erisred"

/area/eris/quartermaster/hangarsupply
	name = "Supply Shuttle Hangar"
	icon_state = "erisblue"

/area/eris/quartermaster/misc
	name = "\improper Cargo Barracks"
	icon_state = "erisyellow"

//Research and Development
/area/eris/rnd
	area_light_color = COLOR_LIGHTING_SCI_BRIGHT
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	ambience = list('sound/ambience/researchambient1.ogg','sound/ambience/researchambient2.ogg','sound/ambience/researchambient3.ogg','sound/ambience/researchambient4.ogg','sound/ambience/researchambient5.ogg','sound/ambience/researchambient6.ogg','sound/ambience/researchambient7.ogg','sound/ambience/researchambient8.ogg','sound/ambience/researchambient9.ogg')

/area/eris/rnd/research
	name = "\improper Research and Development"
	icon_state = "research"

/area/eris/rnd/scient
	name = "Science Department Entrance"
	icon_state = "erisblue"

/area/eris/rnd/docking
	name = "\improper Research Dock"
	icon_state = "research_dock"

/area/eris/rnd/lab
	name = "\improper Research Lab"
	icon_state = "toxlab"

/area/eris/rnd/chargebay
	name = "\improper Mech Bay"
	icon_state = "mechbay"

/area/eris/rnd/robotics
	name = "\improper Robotics Lab"
	icon_state = "robotics"

/area/eris/rnd/rdoffice
	name = "\improper Moebius Expedition Overseer's Office"
	icon_state = "head_quarters"

/area/eris/rnd/supermatter
	name = "\improper Supermatter Lab"
	icon_state = "toxlab"

/area/eris/rnd/xenobiology
	name = "\improper Xenobiology Lab"
	icon_state = "xeno_lab"

/area/eris/rnd/xenobiology/xenoflora_storage
	name = "\improper Xenoflora Storage"
	icon_state = "xeno_f_store"

/area/eris/rnd/xenobiology/xenoflora
	name = "\improper Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/eris/rnd/storage
	name = "\improper Toxins Storage"
	icon_state = "toxstorage"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/rnd/mixing
	name = "\improper Toxins Mixing Room"
	icon_state = "toxmix"

/area/eris/rnd/misc_lab
	name = "\improper Miscellaneous Research"
	icon_state = "toxmisc"
	area_light_color = COLOR_LIGHTING_SCI_DARK

/area/eris/rnd/server
	name = "\improper Server Room"
	icon_state = "server"

/area/eris/rnd/podbay
	name = "Pod Bay"
	icon_state = "erisblue"

/area/eris/rnd/anomal
	name = "Anomalous Research Laboratory"
	icon_state = "erisblue"

/area/eris/rnd/anomalisolone
	name = "Anomalous Research Isolation One"
	flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "erisgreen"

/area/eris/rnd/anomalisoltwo
	name = "Anomalous Research Isolation Two"
	flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "erisgreen"

/area/eris/rnd/anomalisolthree
	name = "Anomalous Research Isolation Three"
	flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "erisgreen"

/area/eris/rnd/server
	name = "\improper Research Server Room"
	flags = AREA_FLAG_RAD_SHIELDED
	icon_state = "server"

//Storage
/area/eris/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/eris/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"
