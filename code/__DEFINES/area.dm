//Area defines
//power flags
#define ALWAYS_UNPOWERED (1<<0)
#define NO_POWER_REQUIRED (1<<1)
#define POWER_LIGHT (1<<2)
#define POWER_ENVIRON (1<<3)
#define POWER_EQUIP (1<<4)
#define POWER_ALL_CHANNELS (POWER_LIGHT|POWER_ENVIRON|POWER_EQUIP)
//These are defines since these procs are incredibly hot.
#define IS_AREA_POWERED(area, chan) (((NO_POWER_REQUIRED|chan) & area.power_flags) && !(ALWAYS_UNPOWERED & area.power_flags))
//Does not check if power is available.
#define USE_AREA_POWER(area, amt, chan) (chan & POWER_LIGHT) ? (area.used_light += amt) : (chan & POWER_ENVIRON) ? (area.used_environ += amt) : (chan & POWER_EQUIP) ? (area.used_equip += amt) : 0
