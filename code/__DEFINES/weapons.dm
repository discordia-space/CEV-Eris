//This file is for defines related to damage, armor, and generally violence

//Weapon Force: Provides the base damage for melee weapons.
#define WEAPON_FORCE_HARMLESS		3
#define WEAPON_FORCE_WEAK			7
#define WEAPON_FORCE_NORMAL			10
#define WEAPON_FORCE_PAINFUL		15
#define WEAPON_FORCE_DANGEROUS		20
#define WEAPON_FORCE_ROBUST			26
#define WEAPON_FORCE_BRUTAL			33
#define WEAPON_FORCE_LETHAL			40
#define WEAPON_FORCE_GODLIKE		88 // currently only used by the energy axe, which can only be obtained via admin verbs

//Armor Penetration: Ignores a certain amount of armor for the purposes of inflicting damage.
#define ARMOR_PEN_GRAZING			5
#define ARMOR_PEN_SHALLOW			10
#define ARMOR_PEN_MODERATE			15
#define ARMOR_PEN_DEEP				20
#define ARMOR_PEN_EXTREME			25
#define ARMOR_PEN_MASSIVE			30
#define ARMOR_PEN_HALF				50

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
#define STRUCTURE_DAMAGE_NORMAL 		1
#define STRUCTURE_DAMAGE_BLUNT 			1.3
#define STRUCTURE_DAMAGE_HEAVY 			1.5
#define STRUCTURE_DAMAGE_BREACHING 		1.8
#define STRUCTURE_DAMAGE_DESTRUCTIVE 	2
#define STRUCTURE_DAMAGE_BORING 		3

//Quick defines for fire modes
#define FULL_AUTO_300		list(mode_name = "full auto",  mode_type = /datum/firemode/automatic, fire_delay = 2  , icon="auto", damage_mult_add = -0.1)
#define FULL_AUTO_400		list(mode_name = "full auto",  mode_type = /datum/firemode/automatic, fire_delay = 1.5, icon="auto", damage_mult_add = -0.1)
#define FULL_AUTO_600		list(mode_name = "full auto",  mode_type = /datum/firemode/automatic, fire_delay = 1  , icon="auto", damage_mult_add = -0.1)
#define FULL_AUTO_800		list(mode_name = "full auto",  mode_type = /datum/firemode/automatic, fire_delay = 0.8, icon="auto", damage_mult_add = -0.1)

#define SEMI_AUTO_NODELAY	list(mode_name="semiauto", burst=1, fire_delay=0, move_delay=null, icon="semi")

#define BURST_3_ROUND		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4, icon="burst", damage_mult_add = -0.1)
#define BURST_5_ROUND		list(mode_name="5-round bursts", burst=5, fire_delay=null, move_delay=6, icon="burst", damage_mult_add = -0.1)
#define BURST_8_ROUND		list(mode_name="8-round bursts", burst=8, fire_delay=null, move_delay=8, icon="burst", damage_mult_add = -0.1)

#define WEAPON_NORMAL		list(mode_name="standard", icon="semi")
#define WEAPON_CHARGE		list(mode_name="charge mode", mode_type = /datum/firemode/charge, icon="charge")

#define MAX_ACCURACY_OFFSET  30 //It's both how big gun recoil can build up, and how hard you can miss
#define RECOIL_REDUCTION_TIME 1 SECOND

#define VIG_OVERCHARGE_GEN 0.05