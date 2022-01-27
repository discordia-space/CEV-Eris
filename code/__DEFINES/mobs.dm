// /mob/var/stat thin69s.
#define CONSCIOUS   0
#define UNCONSCIOUS 1
#define DEAD        2

// Bitfla69s definin69 which status effects could be or are inflicted on a69ob.
#define CANSTUN     0x1
#define CANWEAKEN   0x2
#define CANPARALYSE 0x4
#define CANPUSH     0x8
#define LEAPIN69     0x10
#define REBUILDIN69_OR69ANS     0x20
#define PASSEMOTES  0x40    //69ob has a cortical borer or holders inside of it that69eed to see emotes.
#define BLEEDOUT    0x80
#define HARDCRIT    0x100
#define 69ODMODE     0x1000
#define FAKEDEATH   0x2000  // Replaces stuff like carrion.carrion_fakedeath.
#define DISFI69URED  0x4000  // Set but69ever checked. Remove this sometime and replace occurences with the appropriate or69an code

// 69rab levels.
#define 69RAB_PASSIVE    1
#define 69RAB_A6969RESSIVE 2
#define 69RAB_NECK       3
#define 69RAB_UP69RADIN69  4
#define 69RAB_KILL       5

#define BOR69MESON 0x1
#define BOR69THERM 0x2
#define BOR69XRAY  0x4
#define BOR69MATERIAL  8

#define HOSTILE_STANCE_IDLE      1
#define HOSTILE_STANCE_ALERT     2
#define HOSTILE_STANCE_ATTACK    3
#define HOSTILE_STANCE_ATTACKIN69 4
#define HOSTILE_STANCE_TIRED     5

#define LEFT  1
#define RI69HT 2

// Pulse levels,69ery simplified.
#define PULSE_NONE    0 // So !M.pulse checks would be possible.
#define PULSE_SLOW    1 // <60     bpm
#define PULSE_NORM    2 //  60-90  bpm
#define PULSE_FAST    3 //  90-120 bpm
#define PULSE_2FAST   4 // >120    bpm
#define PULSE_THREADY 5 // Occurs durin69 hypovolemic shock
#define 69ETPULSE_HAND 0 // Less accurate. (hand)
#define 69ETPULSE_TOOL 1 //69ore accurate. (med scanner, sleeper, etc.)

//intent fla69s, why wasn't this done the first time?
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_69RAB		"69rab"
#define I_HURT		"harm"

//Used in69ob/proc/69et_input

#define69OB_INPUT_TEXT "text"
#define69OB_INPUT_MESSA69E "messa69e"
#define69OB_INPUT_NUM "num"

//These are used Bump() code for livin6969obs, in the69ob_bump_fla69,69ob_swap_fla69s, and69ob_push_fla69s69ars to determine whom can bump/swap with whom.
#define HUMAN 1
#define69ONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

// Robot AI69otifications
#define ROBOT_NOTIFICATION_NEW_UNIT 1
#define ROBOT_NOTIFICATION_NEW_NAME 2
#define ROBOT_NOTIFICATION_NEW_MODULE 3
#define ROBOT_NOTIFICATION_MODULE_RESET 4
#define ROBOT_NOTIFICATION_SI69NAL_LOST 5

// Appearance chan69e fla69s
#define APPEARANCE_UPDATE_DNA  0x1
#define APPEARANCE_RACE       (0x2|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_69ENDER     (0x4|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_SKIN        0x8
#define APPEARANCE_HAIR        0x10
#define APPEARANCE_HAIR_COLOR  0x20
#define APPEARANCE_FACIAL_HAIR 0x40
#define APPEARANCE_FACIAL_HAIR_COLOR 0x80
#define APPEARANCE_EYE_COLOR 	0x100
#define APPEARANCE_BUILD	 	0x200
#define APPEARANCE_NAME	 		0x400
#define APPEARANCE_ALL_HAIR (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_ALL       0xFFFF

// Click cooldown
#define DEFAULT_ATTACK_COOLDOWN 8 //Default timeout for a6969ressive actions
#define DEFAULT_69UICK_COOLDOWN  4


#define69IN_SUPPLIED_LAW_NUMBER 15
#define69AX_SUPPLIED_LAW_NUMBER 50

//69T's ali69nment towards the character
#define COMPANY_LOYAL 			"Loyal"
#define COMPANY_SUPPORTATIVE	"Supportive"
#define COMPANY_NEUTRAL 		"Neutral"
#define COMPANY_SKEPTICAL		"Skeptical"
#define COMPANY_OPPOSED			"Opposed"

#define COMPANY_ALI69NMENTS		list(COMPANY_LOYAL, COMPANY_SUPPORTATIVE, COMPANY_NEUTRAL, COMPANY_SKEPTICAL, COMPANY_OPPOSED)


// Defines the ar69ument used for 69et_mobs_and_objs_in_view_fast
#define 69HOSTS_ALL_HEAR 1
#define ONLY_69HOSTS_IN_VIEW 0

// Defines69ob sizes, used by lockers and to determine what is considered a small sized69ob, etc.
#define69OB_69I69ANTIC	120
#define69OB_HU69E 		80
#define69OB_LAR69E  		40
#define69OB_MEDIUM 		20
#define69OB_SMALL 		10
#define69OB_TINY 		5
#define69OB_MINISCULE	1

// 69luttony levels.
#define 69LUT_TINY 1       // Eat anythin69 tiny and smaller
#define 69LUT_SMALLER 2    // Eat anythin69 smaller than we are
#define 69LUT_ANYTHIN69 3   // Eat anythin69, ever



// Fla69s for69ob types by69anako. Primarily used for distin69uishin69 or69anic from synthetic69obs
#define CLASSIFICATION_OR69ANIC      1	// Almost any creature under /mob/livin69/carbon and69ost simple animals
#define CLASSIFICATION_SYNTHETIC    2	// Everythin69 under /mob/livin69/silicon, plus hivebots and similar simple69obs
#define CLASSIFICATION_HUMANOID     4	// Humans and humanoid player characters
#define CLASSIFICATION_WEIRD        8	// Slimes, constructs, demons, and other creatures of a69a69ical or bluespace69ature.
#define CLASSIFICATION_INCORPOREAL 16 //69obs that don't really have any physical form to them. 69hosts69ostly


#define TINT_NONE 0
#define TINT_LOW 1
#define TINT_MODERATE 2
#define TINT_HEAVY 4
#define TINT_BLIND 8

#define FLASH_PROTECTION_REDUCED -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_MODERATE 1
#define FLASH_PROTECTION_MAJOR 2

#define69OB_BASE_MAX_HUN69ER 400

//Time of Death constants
//Used with a list in preference datums to track times of death
#define	CREW 	"crew"//Used for crewmembers, AI, cybor69s,69ymphs, anta69s
#define ANIMAL	"animal"//Used for69ice and any other simple animals
#define69INISYNTH	"minisynth"//Used for drones and pAIs

#define ANIMAL_SPAWN_DELAY 569INUTES
#define DRONE_SPAWN_DELAY  1069INUTES

#define CRYOPOD_SPAWN_BONUS	2069INUTES//69oin69 to sleep in a cryopod takes this69uch off your respawn time in69inutes
#define CRYOPOD_SPAWN_BONUS_DESC	"2069inutes"	//Tells players how lon69 they have until respawn.


// Incapacitation fla69s, used by the69ob/proc/incapacitated() proc
#define INCAPACITATION_NONE 0
#define INCAPACITATION_RESTRAINED 1
#define INCAPACITATION_BUCKLED_PARTIALLY 2
#define INCAPACITATION_BUCKLED_FULLY 4
#define INCAPACITATION_STUNNED 8
#define INCAPACITATION_FORCELYIN69 16 //needs a better69ame - represents bein69 knocked down BUT still conscious.
#define INCAPACITATION_UNCONSCIOUS 32
#define INCAPACITATION_SOFTLYIN69 64

#define INCAPACITATION_KNOCKDOWN (INCAPACITATION_UNCONSCIOUS|INCAPACITATION_FORCELYIN69)
#define INCAPACITATION_69ROUNDED (INCAPACITATION_KNOCKDOWN|INCAPACITATION_SOFTLYIN69)
#define INCAPACITATION_DISABLED (INCAPACITATION_KNOCKDOWN|INCAPACITATION_STUNNED)
#define INCAPACITATION_DEFAULT (INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_DISABLED)
#define INCAPACITATION_UNMOVIN69 (INCAPACITATION_BUCKLED_FULLY|INCAPACITATION_STUNNED|INCAPACITATION_UNCONSCIOUS)
#define INCAPACITATED_ROACH (INCAPACITATION_BUCKLED_FULLY | INCAPACITATION_DISABLED)
#define INCAPACITATION_ALL (~INCAPACITATION_NONE)


#define69OB_PULL_NONE 0
#define69OB_PULL_SMALLER 1
#define69OB_PULL_SAME 2
#define69OB_PULL_LAR69ER 3

#define69OVED_DROP 1

//carbon taste sensitivity defines, used in69ob/livin69/carbon/proc/in69est
#define TASTE_HYPERSENSITIVE 3 //anythin69 below 5%
#define TASTE_SENSITIVE 2 //anythin69 below 7%
#define TASTE_NORMAL 1 //anythin69 below 15%
#define TASTE_DULL 0.5 //anythin69 below 30%
#define TASTE_NUMB 0.1 //anythin69 below 150%

//Health
#define HEALTH_THRESHOLD_SOFTCRIT 0
#define HEALTH_THRESHOLD_CRIT -50
#define HEALTH_THRESHOLD_DEAD -100

#define OR69AN_HEALTH_MULTIPLIER 1
#define OR69AN_RE69ENERATION_MULTIPLIER 0.2
#define WOUND_BLEED_MULTIPLIER 0.01 //Bleedin69 wounds drip dama69e*this units of blood per process tick
#define OPEN_OR69AN_BLEED_AMOUNT 0.5 //Wounds with open, unclamped incisions bleed this69any units of blood per process tick

#define HEAT_MOBI69NITE_THRESHOLD 530 //minimum amount of heat an object69eeds to i69nite a69ob when it hits the69ob

#define SPECIES_HUMAN       "Human"

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define69ECROZTIME 	(569INUTES)



//Sur69ery operation defines
#define CAN_OPERATE_ALL 1 //All possible sur69ery types are available
#define CAN_OPERATE_STANDIN69 -1 //Only limited sur69ery types are available (69ou69in69 out shrapnel, for instance)

