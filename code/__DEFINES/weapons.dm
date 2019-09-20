//This file is for defines related to damage, armor, and generally violence

//Weapon Force: Provides the base damage for melee weapons.
//These are due for a review and overhaul, generally too powerful
#define WEAPON_FORCE_HARMLESS		3
#define WEAPON_FORCE_WEAK			7
#define WEAPON_FORCE_NORMAL			10
#define WEAPON_FORCE_PAINFUL		15
#define WEAPON_FORCE_DANGEROUS		20
#define WEAPON_FORCE_ROBUST			26
#define WEAPON_FORCE_LETHAL			51


//Resistance values, used on floors, windows, airlocks, girders, and similar hard targets.
//Resistance value is also used on simple animals.
//Reduces the damage they take by flat amounts
#define RESISTANCE_NONE 				0
#define RESISTANCE_FRAGILE 				4
#define RESISTANCE_AVERAGE 				8
#define RESISTANCE_IMPROVED 			12
#define RESISTANCE_TOUGH 				16
#define RESISTANCE_ARMOURED 			20
#define RESISTANCE_HEAVILY_ARMOURED 	24
#define RESISTANCE_VAULT 				32
#define RESISTANCE_UNBREAKABLE 			100


//Structure damage values: Multipliers on base damage for attacking hard targets
//Blades are weaker, and heavy/blunt weapons are stronger.
//Drills, fireaxes and energy melee weapons are the high end
#define STRUCTURE_DAMAGE_BLADE 			0.5
#define STRUCTURE_DAMAGE_WEAK 			0.8
#define STRUCTURE_DAMAGE_NORMAL 		1.0
#define STRUCTURE_DAMAGE_BLUNT 			1.3
#define STRUCTURE_DAMAGE_HEAVY 			1.5
#define STRUCTURE_DAMAGE_BREACHING 		1.8
#define STRUCTURE_DAMAGE_BORING 		3

//Quick defines for fire modes
#define FULL_AUTO_250		list(mode_name="full auto",  mode_type = /datum/firemode/automatic, fire_delay=2.4, icon="auto")
#define FULL_AUTO_400		list(mode_name="full auto",  mode_type = /datum/firemode/automatic, fire_delay=1.5, icon="auto")
#define FULL_AUTO_600		list(mode_name="full auto",  mode_type = /datum/firemode/automatic, fire_delay=1  , icon="auto")

#define SEMI_AUTO_NODELAY	list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, icon="semi")

