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
#define ARMOR_PEN_GRAZING			1.2
#define ARMOR_PEN_SHALLOW			1.4
#define ARMOR_PEN_MODERATE			1.6
#define ARMOR_PEN_DEEP				1.8
#define ARMOR_PEN_HALF				2
#define ARMOR_PEN_EXTREME			2.5
#define ARMOR_PEN_MASSIVE			3
#define ARMOR_PEN_MAX				10

//Wounding Multiplier: Increases damage taken, applied after armor.

#define WOUNDING_TRIVIAL			0.1
#define WOUNDING_TINY				0.25
#define WOUNDING_SMALL				0.5
#define WOUNDING_INTERMEDIATE		0.75
#define WOUNDING_NORMAL				1
#define WOUNDING_WIDE				1.5
#define WOUNDING_EXTREME			2

//Injury Type: Degrades specific wounding multipliers depending on sharpness and edge

#define INJURY_TYPE_LIVING "living" // Anything with soft organs
#define INJURY_TYPE_UNLIVING "unliving" // Things with hard vital parts, but not a proper organism, such as robots. TODO: FBPs into their own species - all robotic limbs possessing the defined species regardless of torso
#define INJURY_TYPE_HOMOGENOUS "homogenous" // Solid objects, such as walls, slimes (they contain a slime core, but otherwise are a single "cell", with no distinct organs), golems

//Resistance values, used on floors, windows, airlocks, girders, and similar hard targets.
//Resistance value is also used on simple animals.
//Reduces the damage they take by flat amounts
#define RESISTANCE_NONE 				0
#define RESISTANCE_FLIMSY				2
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
#define STRUCTURE_DAMAGE_POWERFUL    	2
#define STRUCTURE_DAMAGE_DESTRUCTIVE 	3

//Quick defines for fire modes
#define FULL_AUTO_300		list(mode_name = "full auto",  mode_desc = "300 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 4  , icon="auto")
#define FULL_AUTO_400		list(mode_name = "full auto",  mode_desc = "400 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 3, icon="auto")
#define FULL_AUTO_600		list(mode_name = "full auto",  mode_desc = "600 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 2  , icon="auto")
#define FULL_AUTO_800		list(mode_name = "fuller auto",  mode_desc = "800 rounds per minute",   mode_type = /datum/firemode/automatic, fire_delay = 1.6, icon="auto")

#define SEMI_AUTO_300	list(mode_name = "semiauto",  mode_desc = "Fire as fast as you can pull the trigger", burst=1, fire_delay=4, move_delay=null, icon="semi")

//Cog firemode
#define BURST_2_BEAM		list(mode_name="2-beam bursts", mode_desc = "Short, controlled bursts", burst=2, fire_delay=null, move_delay=2, icon="burst")

#define BURST_2_ROUND			list(mode_name="2-round bursts", mode_desc = "Short, controlled bursts", burst=2, fire_delay=null, move_delay=2, icon="burst")
#define BURST_3_ROUND			list(mode_name="3-round bursts", mode_desc = "Short, controlled bursts", burst=3, fire_delay=null, move_delay=4, icon="burst")
#define BURST_3_ROUND_RAPID		list(mode_name=" High-delay Rapid 3-round bursts", mode_desc = "Short, fast bursts with a higher delay between bursts", burst=3, fire_delay=15, move_delay=4, icon="auto", burst_delay = 0.5)
#define BURST_3_ROUND_DAMAGE	list(mode_name="3-round bursts", mode_desc = "Short, controlled bursts", burst=3, fire_delay=null, move_delay=4, icon="burst")
#define BURST_5_ROUND			list(mode_name="5-round bursts", mode_desc = "Short, controlled bursts", burst=5, fire_delay=null, move_delay=6, icon="burst")
#define BURST_8_ROUND			list(mode_name="8-round bursts", mode_desc = "Short, uncontrolled bursts", burst=8, fire_delay=null, move_delay=8, icon="burst")

//SMG rapid
#define BURST_3_ROUND_SMG	list(mode_name=" High-delay Rapid 3-round bursts", mode_desc = "Short, fast bursts with a short recovery time between bursts to allow the barrel to cool", burst=3, fire_delay=12, move_delay=3, icon="auto", burst_delay = 1.4)
#define BURST_6_ROUND_SMG	list(mode_name=" High-delay Rapid 6-round bursts", mode_desc = "Long, fast bursts with a long recovery time between bursts to allow the barrel to cool", burst=6, fire_delay=25, move_delay=5, icon="auto", burst_delay = 1.4)

#define WEAPON_NORMAL		list(mode_name="standard", burst =1, icon="semi")
#define WEAPON_CHARGE		list(mode_name="charge mode", mode_desc="Hold down the trigger, and let loose a more powerful shot", mode_type = /datum/firemode/charge, icon="charge")

#define STUNBOLT			list(mode_name="stun", mode_desc="Stun bolt until they're eating the floortiles", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun", item_modifystate="stun", fire_sound='sound/weapons/Taser.ogg', icon="stun")
#define LETHAL				list(mode_name="kill", mode_desc="To defeat the Vagabond, shoot it until it dies", projectile_type=/obj/item/projectile/beam, modifystate="energykill", item_modifystate="kill", fire_sound='sound/weapons/Laser.ogg', icon="kill")



#define MAX_ACCURACY_OFFSET  45 //It's both how big gun recoil can build up, and how hard you can miss
#define RECOIL_REDUCTION_TIME 1 SECOND

#define VIG_OVERCHARGE_GEN 0.05

#define EMBEDDED_RECOIL(x)     list(1.3 *x, 0  *x, 0  *x )
#define HANDGUN_RECOIL(x)      list(1.15*x, 0.1*x, 0.6*x )
#define SMG_RECOIL(x)          list(1   *x, 0.2*x, 1.2*x )
#define CARBINE_RECOIL(x)      list(0.85*x, 0.3*x, 1.8*x )
#define RIFLE_RECOIL(x)        list(0.7 *x, 0.4*x, 2.4*x )
#define LMG_RECOIL(x)          list(0.55*x, 0.5*x, 3*x   )
#define HMG_RECOIL(x)          list(0.4 *x, 0.6*x, 3.6*x )
