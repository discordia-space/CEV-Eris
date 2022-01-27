//This file is for defines related to dama69e, armor, and 69enerally69iolence

//Weapon Force: Provides the base dama69e for69elee weapons.
#define WEAPON_FORCE_HARMLESS		3
#define WEAPON_FORCE_WEAK			7
#define WEAPON_FORCE_NORMAL			10
#define WEAPON_FORCE_PAINFUL		15
#define WEAPON_FORCE_DAN69EROUS		20
#define WEAPON_FORCE_ROBUST			26
#define WEAPON_FORCE_BRUTAL			33
#define WEAPON_FORCE_LETHAL			40
#define WEAPON_FORCE_69ODLIKE		88 // currently only used by the ener69y axe, which can only be obtained69ia admin69erbs

//Armor Penetration: I69nores a certain amount of armor for the purposes of inflictin69 dama69e.
#define ARMOR_PEN_69RAZIN69			5
#define ARMOR_PEN_SHALLOW			10
#define ARMOR_PEN_MODERATE			15
#define ARMOR_PEN_DEEP				20
#define ARMOR_PEN_EXTREME			25
#define ARMOR_PEN_MASSIVE			30
#define ARMOR_PEN_HALF				50

//Resistance69alues, used on floors, windows, airlocks, 69irders, and similar hard tar69ets.
//Resistance69alue is also used on simple animals.
//Reduces the dama69e they take by flat amounts
#define RESISTANCE_NONE 				0
#define RESISTANCE_FRA69ILE 				4
#define RESISTANCE_AVERA69E 				8
#define RESISTANCE_IMPROVED 			12
#define RESISTANCE_TOU69H 				16
#define RESISTANCE_ARMOURED 			20
#define RESISTANCE_HEAVILY_ARMOURED 	24
#define RESISTANCE_VAULT 				32
#define RESISTANCE_UNBREAKABLE 			100


//Structure dama69e69alues:69ultipliers on base dama69e for attackin69 hard tar69ets
//Blades are weaker, and heavy/blunt weapons are stron69er.
//Drills, fireaxes and ener69y69elee weapons are the hi69h end
#define STRUCTURE_DAMA69E_BLADE 			0.5
#define STRUCTURE_DAMA69E_WEAK 			0.8
#define STRUCTURE_DAMA69E_NORMAL 		1
#define STRUCTURE_DAMA69E_BLUNT 			1.3
#define STRUCTURE_DAMA69E_HEAVY 			1.5
#define STRUCTURE_DAMA69E_BREACHIN69 		1.8
#define STRUCTURE_DAMA69E_DESTRUCTIVE 	2
#define STRUCTURE_DAMA69E_BORIN69 		3

//69uick defines for fire69odes
#define FULL_AUTO_300		list(mode_name = "full auto", 69ode_desc = "300 rounds per69inute",  69ode_type = /datum/firemode/automatic, fire_delay = 2  , icon="auto", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)
#define FULL_AUTO_400		list(mode_name = "full auto", 69ode_desc = "400 rounds per69inute",  69ode_type = /datum/firemode/automatic, fire_delay = 1.5, icon="auto", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)
#define FULL_AUTO_600		list(mode_name = "full auto", 69ode_desc = "600 rounds per69inute",  69ode_type = /datum/firemode/automatic, fire_delay = 1  , icon="auto", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)
#define FULL_AUTO_800		list(mode_name = "fuller auto", 69ode_desc = "800 rounds per69inute",  69ode_type = /datum/firemode/automatic, fire_delay = 0.8, icon="auto", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)

#define SEMI_AUTO_NODELAY	list(mode_name = "semiauto", 69ode_desc = "Fire as fast as you can pull the tri6969er", burst=1, fire_delay=0,69ove_delay=null, icon="semi")

//Co69 firemode
#define BURST_2_ROUND		list(mode_name="2-beam bursts",69ode_desc = "Short, controlled bursts", burst=2, fire_delay=null,69ove_delay=2, icon="burst", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)

#define BURST_3_ROUND		list(mode_name="3-round bursts",69ode_desc = "Short, controlled bursts", burst=3, fire_delay=null,69ove_delay=4, icon="burst", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)
#define BURST_5_ROUND		list(mode_name="5-round bursts",69ode_desc = "Short, controlled bursts", burst=5, fire_delay=null,69ove_delay=6, icon="burst", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)
#define BURST_8_ROUND		list(mode_name="8-round bursts",69ode_desc = "Short, uncontrolled bursts", burst=8, fire_delay=null,69ove_delay=8, icon="burst", dama69e_mult_add = -0.1, style_dama69e_mult = 0.5)

#define WEAPON_NORMAL		list(mode_name="standard", burst =1, icon="semi")
#define WEAPON_CHAR69E		list(mode_name="char69e69ode",69ode_desc="Hold down the tri6969er, and let loose a69ore powerful shot",69ode_type = /datum/firemode/char69e, icon="char69e")

#define STUNBOLT			list(mode_name="stun",69ode_desc="Stun bolt until they're eatin69 the floortiles", projectile_type=/obj/item/projectile/beam/stun,69odifystate="ener69ystun", item_modifystate="stun", fire_sound='sound/weapons/Taser.o6969', icon="stun")
#define LETHAL				list(mode_name="kill",69ode_desc="To defeat the69a69abond, shoot it until it dies", projectile_type=/obj/item/projectile/beam,69odifystate="ener69ykill", item_modifystate="kill", fire_sound='sound/weapons/Laser.o6969', icon="kill")



#define69AX_ACCURACY_OFFSET  45 //It's both how bi69 69un recoil can build up, and how hard you can69iss
#define RECOIL_REDUCTION_TIME 1 SECOND

#define69I69_OVERCHAR69E_69EN 0.05
