// Event defines.
#define EVENT_LEVEL_MUNDANE  "mundane"
#define EVENT_LEVEL_MODERATE "moderate"
#define EVENT_LEVEL_MAJOR    "major"
#define EVENT_LEVEL_ROLESET  "roleset"
#define EVENT_LEVEL_ECONOMY  "economy"


//The threshold of points that we need before attempting to purchase things
#define POOL_THRESHOLD_MUNDANE	25
#define POOL_THRESHOLD_MODERATE	50
#define POOL_THRESHOLD_MAJOR	90
#define POOL_THRESHOLD_ROLESET	120


//Event tags. These loosely describe what the event will do to the ship and crew
//Storytellers can vary the weighting and cost of events based on these tags

//The event generates monsters or antags to battle.
//Example: Infestation, spiders, carp
//Most antags are tagged combat too
//Combat events usually create work for ironhammer and medical
#define TAG_COMBAT "combat"



//The event involves one or very few people. The people who are unaffected often won't care
//Examples: Ion storm, viral infection
#define TAG_TARGETED "targeted"



//The event involves most or all of the crew, everyone has something to do, everyone is involved
//Examples: Radiation storm, lights out, comms blackout
#define TAG_COMMUNAL "communal"



//The event has the potential to deal damage to the ship and its structures
//Examples: Meteors, APC damage, camera failure
//Destructive events usually create work for engineers
#define TAG_DESTRUCTIVE "destructive"



//The event is negative. It harms people, breaks things, and generally creates problems
//This is pretty much every event and antag. Almost everything will be tagged with negative
#define TAG_NEGATIVE "negative"



//The event helps people, gives them stuff, heals them
//There are a few "nice antags" which this can be applied to.
//No current random events afaik
#define TAG_POSITIVE "positive"


//The event helps to invoke a horror vibe. Plunges players into darkness, makes terrifying creatures, etc
#define TAG_SCARY "scary"


//The event comes from outside the ship. Maybe you have to go EVA to deal with it, or fight off boarders
//Examples: Meteors, carp, rogue drones, mercenaries, raiders
#define TAG_EXTERNAL "external"

