// Event defines.
#define EVENT_LEVEL_MUNDANE  1
#define EVENT_LEVEL_MODERATE 2
#define EVENT_LEVEL_MAJOR    3
#define EVENT_LEVEL_ROLESET  4
#define EVENT_LEVEL_ECONOMY  5


//The threshold of points that we need before attempting to purchase things
#define POOL_THRESHOLD_MUNDANE	20
#define POOL_THRESHOLD_MODERATE	40
#define POOL_THRESHOLD_MAJOR	80
#define POOL_THRESHOLD_ROLESET	120


//Event tags. These loosely describe what the event will do to the ship and crew
//Storytellers can vary the weighting and cost of events based on these tags

//The event generates monsters or antags to battle.
//Example: Infestation, spiders, carp
//Most antags are tagged combat too
//Combat events usually create work for ironhammer and medical
#define TAG_COMBAT "combat"


//The event involves one or very few people.
//Examples: Ion storm, viral infection
#define TAG_TARGETED "targeted"


//The event involves most or all of the crew, everyone has something to do
//Examples: Radiation storm, lights out, comms blackout
#define TAG_COMMUNAL "communal"


//The event has the potential to deal damage to the ship and its structures
//Examples: Meteors, APC damage, camera failure
//Destructive events usually create work for engineers
#define TAG_DESTRUCTIVE "destructive"