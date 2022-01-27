
var/list/weighted_randomevent_locations = list()
var/list/weighted_mundaneevent_locations = list()

/datum/trade_destination
	var/name = ""
	var/description = ""
	var/distance = 0
	var/list/willing_to_buy = list()
	var/list/willing_to_sell = list()
	var/can_shuttle_here = 0		//one day crew from the exodus will be able to travel to this destination
	var/list/viable_random_events = list()
	var/list/temp_price_change69BIOMEDICAL69
	var/list/viable_mundane_events = list()

/datum/trade_destination/proc/get_custom_eventstring(var/event_type)
	return null

//distance is69easured in AU and co-relates to travel time
/datum/trade_destination/centcom
	name = "CentCom"
	description = "NanoTrasen's administrative centre for Tau Ceti."
	distance = 1.2
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CORPORATE_ATTACK, AI_LIBERATION)
	viable_mundane_events = list(ELECTION, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/anansi
	name = "NSS Anansi"
	description = "Medical station ran by Second Red Cross (but owned by NT) for handling emergency cases from nearby colonies."
	distance = 1.7
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CULT_CELL_REVEALED, BIOHAZARD_OUTBREAK, PIRATES, ALIEN_RAIDERS)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH, BARGAINS, GOSSIP)

/datum/trade_destination/anansi/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the NSS Anansi, Second Red Cross Society wishes to announce a69ajor breakthough in the field of \
		69pick("mind-machine interfacing","neuroscience","nano-augmentation","genetics")69. 69company_name69 is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/atomos
	name = "IHS Atomos"
	description = "Corvette assigned to patrol local space."
	distance = 0.1
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, AI_LIBERATION, PIRATES)

/datum/trade_destination/redolant
	name = "OAV Redolant"
	description = "Osiris Atmospherics station in orbit around the only gas giant insystem. They retain tight control over shipping rights, and Osiris warships protecting their prize are not an uncommon sight in Tau Ceti."
	distance = 0.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(INDUSTRIAL_ACCIDENT, PIRATES, CORPORATE_ATTACK)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH)

/datum/trade_destination/redolant/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the OAV Redolant, Osiris Atmospherics wishes to announce a69ajor breakthough in the field of \
		69pick("plasma research","high energy flux capacitance","super-compressed69aterials","theoretical particle physics")69. 69company_name69 is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/beltway
	name = "Beltway69ining chain"
	description = "A co-operative effort between Beltway and NanoTrasen to exploit the rich outer asteroid belt of the Tau Ceti system."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(PIRATES, INDUSTRIAL_ACCIDENT)
	viable_mundane_events = list(TOURISM)

/datum/trade_destination/biesel
	name = "Biesel"
	description = "Large ship yards, strong economy and a stable, well-educated populace, Biesel largely owes allegiance to Sol /69essel Contracting and begrudgingly tolerates NT. Capital is Lowell City."
	distance = 2.3
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL,69OURNING)
	viable_mundane_events = list(BARGAINS, GOSSIP, SONG_DEBUT,69OVIE_RELEASE, ELECTION, TOURISM, RESIGNATION, CELEBRITY_DEATH)

/datum/trade_destination/new_gibson
	name = "New Gibson"
	description = "Heavily industrialised rocky planet containing the69ajority of the planet-bound resources in the system, New Gibson is torn by unrest and has69ery little wealth to call it's own except in the hands of the corporations who jostle with NT for control."
	distance = 6.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL,69OURNING)
	viable_mundane_events = list(ELECTION, TOURISM, RESIGNATION)

/datum/trade_destination/luthien
	name = "Luthien"
	description = "A small colony established on a feral, untamed world (largely jungle). Savages and wild beasts attack the outpost regularly, although NT69aintains tight69ilitary control."
	distance = 8.9
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL,69OURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

/datum/trade_destination/reade
	name = "Reade"
	description = "A cold,69etal-deficient world, NT69aintains large pastures in whatever available space in an attempt to salvage something from this profitless colony."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL,69OURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)
