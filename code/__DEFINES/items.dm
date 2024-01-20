#define REQ_FUEL 1
#define REQ_CELL 2
#define REQ_FUEL_OR_CELL 4

//Aspect defines
#define UPGRADE_PRECISION "precision"
#define UPGRADE_WORKSPEED "workspeed"
#define UPGRADE_DEGRADATION_MULT "degradation_mult"
#define UPGRADE_FORCE_MULT "force_mult"
#define UPGRADE_FORCE_MOD "force_mod"
#define UPGRADE_FUELCOST_MULT "fuelcost_mult"
#define UPGRADE_POWERCOST_MULT "powercost_mult"

#define UPGRADE_BULK "bulk_mod"

#define UPGRADE_HEALTH_THRESHOLD "health_threshold_modifier"

#define UPGRADE_MAXFUEL "max_fuel"

#define UPGRADE_MAXUPGRADES "maxUpgrades"

#define UPGRADE_SANCTIFY "sanctify"

#define UPGRADE_COLOR "color"

//boolean
#define UPGRADE_SHARP "sharp"

#define UPGRADE_CELLPLUS "cell_hold_upgrade"

//flags
#define UPGRADE_ITEMFLAGPLUS "item_flag_add"

// Weapon minimum fire_delay
#define GUN_MINIMUM_FIRETIME 1.1 // 110 MS , ~9 shots per second.

// When present as a spritetag, this denotes whether the part is installed. When present as a parttag, it denotes that the sprite is currently activated.
// Used for sprite handling, when present as both parts it will modify the base sprite and all overlays.
#define PARTMOD_STRIPPED 0
#define PARTMOD_FOLDING_STOCK 1
#define PARTMOD_SLIDE 2
#define PARTMOD_FRAME_SPRITE 4 // Defines whether grips or frames determine the inhands, TODO: remove this when V3 comes

//Weapon upgrade defines

// Modification removability (toolmods, gunparts, etc.)
#define MOD_REMOVABLE 1
#define MOD_FUSED 0
#define MOD_INTEGRAL -1

//Int multiplier
#define GUN_UPGRADE_DAMAGE_MULT "damage_mult"
#define GUN_UPGRADE_HALLOSS_MULT "halloss_mult"
#define GUN_UPGRADE_PEN_MULT "penetration_mult"
#define GUN_UPGRADE_PIERC_MULT "pierce_mult"
#define GUN_UPGRADE_RICO_MULT "ricochet_mult"
#define GUN_UPGRADE_FIRE_DELAY_MULT "fire_delay_mult"
#define GUN_UPGRADE_MOVE_DELAY_MULT "move_delay_mult"
#define GUN_UPGRADE_RECOIL "recoil_mult"
#define GUN_UPGRADE_MUZZLEFLASH "muzzleflash_mult"
#define GUN_UPGRADE_STEPDELAY_MULT "stepdelay_mult"
#define GUN_UPGRADE_CHARGECOST "chargecost_mult"
#define GUN_UPGRADE_OVERCHARGE_MAX "overcharge_max_mult"
#define GUN_UPGRADE_OVERCHARGE_RATE "overcharge_rate_mult"
#define GUN_UPGRADE_ONEHANDPENALTY "onehandpenalty_mult"

//Int additive
#define GUN_UPGRADE_DAMAGEMOD_PLUS "damage_plus"
#define GUN_UPGRADE_MAGUP "magazine_addition"

#define GUN_UPGRADE_DAMAGE_BRUTE "brute_damage"
#define GUN_UPGRADE_DAMAGE_BURN "burn_damage"
#define GUN_UPGRADE_DAMAGE_TOX "toxin_damage"
#define GUN_UPGRADE_DAMAGE_OXY "oxygen_damage"
#define GUN_UPGRADE_DAMAGE_CLONE "clone_damage"
#define GUN_UPGRADE_DAMAGE_HALLOSS "hallucination_damage"
#define GUN_UPGRADE_DAMAGE_RADIATION "radiation_damage"
#define GUN_UPGRADE_DAMAGE_PSY "psy_damage"
#define GUN_UPGRADE_MELEEDAMAGE "melee_damage"
#define GUN_UPGRADE_MELEEPENETRATION "melee_penetration"

#define GUN_UPGRADE_OFFSET "offset" //Constant offset, in degrees
#define GUN_UPGRADE_ZOOM "zoom"

//Type configuration
#define GUN_UPGRADE_DEFINE_OK_CALIBERS "ok_calibers"
#define GUN_UPGRADE_DEFINE_CALIBER "caliber"
#define GUN_UPGRADE_DEFINE_MAG_WELL "mag_well"
#define GUN_UPGRADE_DEFINE_STOCK "stock"
#define GUN_UPGRADE_FIREMODES "firemodes"
#define GUN_UPGRADE_DEFINE_GRIP "grip"

//boolean
#define GUN_UPGRADE_SILENCER "silencable"
#define GUN_UPGRADE_FORCESAFETY "safety force"
#define GUN_UPGRADE_HONK "why"
#define GUN_UPGRADE_FULLAUTO "full auto"
#define GUN_UPGRADE_EXPLODE "self destruct"
#define GUN_UPGRADE_RIGGED "rigged"
#define GUN_UPGRADE_THERMAL "thermal scope"
#define GUN_UPGRADE_BAYONET "bayonet"
#define GUN_UPGRADE_FLASHLIGHT "flashlight"
#define GUN_UPGRADE_GILDED "gilded"
#define GUN_UPGRADE_DNALOCK "biocoded"
#define GUN_UPGRADE_FOREGRIP "foregrip"
#define GUN_UPGRADE_BIPOD "bipod"

//Location Tag defines

#define GUN_UNDERBARREL "underbarrel slot"
#define GUN_BARREL "barrel attachment slot"
#define GUN_TRIGGER "trigger slot"
#define GUN_MUZZLE "muzzle slot"
#define GUN_SCOPE "scope slot"
#define GUN_MECHANISM "misc slot"
#define GUN_GRIP "grip attachment slot"
#define GUN_COSMETIC "cosmetic slot"

// Reminder: projectile_defines.dm contains a lot of unused slots

#define PART_BARREL "barrel slot"
#define PART_MECHANISM "firing mechanism slot"
#define PART_GRIP "grip slot"
#define PART_STOCK "stock slot"

//Whitelist Tag defines
#define GUN_SILENCABLE "silencable"
#define GUN_PROJECTILE "projectile firing"
#define GUN_ENERGY "energy firing"
#define GUN_LASER "laser firing"
#define GUN_REVOLVER "revolver"
#define GUN_INTERNAL_MAG "internal mag"
#define GUN_GILDABLE "gildable"
#define GUN_FA_MODDABLE "full auto moddable"
#define GUN_MODULAR "modular"

#define GUN_CALIBRE_35 "caliber .35"

#define GUN_AMR "Is a SA AMR \"Hristov\""

// A rare, random item
#define RANDOM_RARE_ITEM list(\
					/obj/spawner/oddities = 8,\
					/obj/spawner/material/resources/rare = 3,\
					/obj/spawner/tool/advanced = 5,\
					/obj/spawner/gun/normal = 3,\
					/obj/spawner/lathe_disk/advanced = 2,\
					/obj/item/cell/small/moebius/nuclear = 1,\
					/obj/item/cell/medium/moebius/hyper = 1,\
					/obj/spawner/rig = 1.5,\
					/obj/spawner/rig/damaged = 1.5,\
					/obj/spawner/voidsuit = 4,\
					/obj/spawner/pouch = 2,\
					/obj/spawner/tool_upgrade/rare = 4,\
					/obj/spawner/rig_module/rare = 4,\
					/obj/spawner/credits/c1000 = 3,\
					/obj/spawner/exosuit_equipment = 3,\
					/obj/spawner/cloth/holster = 4,\
					/obj/item/stash_spawner = 4,\
					/obj/item/storage/deferred/crate/german_uniform = 4)

GLOBAL_LIST_INIT(tool_aspects_blacklist, list(UPGRADE_COLOR, UPGRADE_ITEMFLAGPLUS, UPGRADE_CELLPLUS, UPGRADE_SHARP, UPGRADE_BULK))
GLOBAL_LIST_INIT(weapon_aspects_blacklist, list(GUN_UPGRADE_SILENCER, GUN_UPGRADE_FORCESAFETY, GUN_UPGRADE_HONK, GUN_UPGRADE_FULLAUTO,
											GUN_UPGRADE_EXPLODE, GUN_UPGRADE_RIGGED, UPGRADE_SANCTIFY))
