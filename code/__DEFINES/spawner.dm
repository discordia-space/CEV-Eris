#define SPAWN_ITEM  "item"
#define SPAWN_WEAPON "weapon"
#define SPAWN_TOOL "tool"
#define SPAWN_ODDITY "oddity"

//weapon
#define SPAWN_GUN "gun"
#define SPAWN_KNIFE "knife"

//guns
#define SPAWN_ENERGY_GUN "energy_gun"
#define SPAWN_BALISTIC_GUN "balistic_gun"

//mob
#define SPAWN_MOB "mob"
#define SPAWN_HOSTILE_MOB "hostile mob"
#define SAPAWN_FRIENDLY_MOB "friendly mob"

//SPAWN_MACHINERY
#define SPAWN_MACHINERY "machinery"

GLOBAL_LIST_INIT(all_spawn_tags, list(SPAWN_ITEM, SPAWN_WEAPON, SPAWN_TOOL,
									SPAWN_ODDITY, SPAWN_GUN, SPAWN_KNIFE,
                                    SPAWN_ENERGY_GUN, SPAWN_ENERGY_GUN, SPAWN_BALISTIC_GUN,
                                    SPAWN_MOB, SPAWN_HOSTILE_MOB, SAPAWN_FRIENDLY_MOB,
                                    SPAWN_MACHINERY))

