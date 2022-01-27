// Event defines.
#define EVENT_LEVEL_MUNDANE  "mundane"
#define EVENT_LEVEL_MODERATE "moderate"
#define EVENT_LEVEL_MAJOR    "major"
#define EVENT_LEVEL_ROLESET  "roleset"
#define EVENT_LEVEL_ECONOMY  "economy"


//The threshold of points that we69eed before attemptin69 to purchase thin69s
#define POOL_THRESHOLD_MUNDANE	25
#define POOL_THRESHOLD_MODERATE	50
#define POOL_THRESHOLD_MAJOR	90
#define POOL_THRESHOLD_ROLESET	120


//Event ta69s. These loosely describe what the event will do to the ship and crew
//Storytellers can69ary the wei69htin69 and cost of events based on these ta69s

//The event 69enerates69onsters or anta69s to battle.
//Example: Infestation, spiders, carp
//Most anta69s are ta6969ed combat too
//Combat events usually create work for ironhammer and69edical
#define TA69_COMBAT "combat"



//The event involves one or69ery few people. The people who are unaffected often won't care
//Examples: Ion storm,69iral infection
#define TA69_TAR69ETED "tar69eted"



//The event involves69ost or all of the crew, everyone has somethin69 to do, everyone is involved
//Examples: Radiation storm, li69hts out, comms blackout
#define TA69_COMMUNAL "communal"



//The event has the potential to deal dama69e to the ship and its structures
//Examples:69eteors, APC dama69e, camera failure
//Destructive events usually create work for en69ineers
#define TA69_DESTRUCTIVE "destructive"



//The event is69e69ative. It harms people, breaks thin69s, and 69enerally creates problems
//This is pretty69uch every event and anta69. Almost everythin69 will be ta6969ed with69e69ative
#define TA69_NE69ATIVE "ne69ative"



//The event helps people, 69ives them stuff, heals them
//There are a few "nice anta69s" which this can be applied to.
//No current random events afaik
#define TA69_POSITIVE "positive"


//The event helps to invoke a horror69ibe. Plun69es players into darkness,69akes terrifyin69 creatures, etc
#define TA69_SCARY "scary"


//The event comes from outside the ship.69aybe you have to 69o EVA to deal with it, or fi69ht off boarders
//Examples:69eteors, carp, ro69ue drones,69ercenaries, raiders
#define TA69_EXTERNAL "external"

