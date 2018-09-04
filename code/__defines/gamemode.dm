#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

// Security levels.
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_BLUE  1
#define SEC_LEVEL_RED   2

#define BE_PLANT "BE_PLANT"
#define BE_SYNTH "BE_SYNTH"
#define BE_PAI   "BE_PAI"

// Storyteller names macro
#define STORYTELLER_BASE "erida"

// antag template macros.
#define ROLE_BORER "borer"
#define ROLE_BORER_REPRODUCED "borer_r"
#define ROLE_XENOMORPH "xeno"
#define ROLE_LOYALIST "loyalist"
#define ROLE_MUTINEER "mutineer"
#define ROLE_COMMANDO "commando"
#define ROLE_DEATHSQUAD "deathsquad"
#define ROLE_ACTOR "actor"
#define ROLE_MERCENARY "mercenary"
#define ROLE_CHANGELING "changeling"
#define ROLE_MONKEY "monkey"
#define ROLE_MALFUNCTION "malf"
#define ROLE_TRAITOR "traitor"
#define ROLE_TRAITOR_SYNTH "robo_traitor"
#define ROLE_MARSHAL "marshal"

#define ROLE_EXCELSIOR_REV "excelsior_rev"

#define ROLE_INQUISITOR "inquisitor"
#define ROLE_SECDOC_DEFENDER "secdoc_defender"

#define FACTION_EXCELSIOR "excelsior"
#define FACTION_BORERS "borers"
#define FACTION_XENOMORPHS "xenomorphs"

#define ROLESET_TRAITOR "traitor"
#define ROLESET_VERSUS_TRAITOR "double_agents"

#define DEFAULT_TELECRYSTAL_AMOUNT 25

/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		0x1		//can a ghost cast it?
#define NEEDSCLOTHES	0x2		//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		0x4		//does it require the caster to be human?
#define Z2NOCAST		0x8		//if this is added, the spell can't be cast at centcomm
#define STATALLOWED		0x10	//if set, the user doesn't have to be conscious to cast. Required for ghost spells
#define IGNOREPREV		0x20	//if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		0x40	//does the spell include the caster in its target selection?
#define SELECTABLE		0x80	//can you select each target for the spell?
//AOE spells
#define IGNOREDENSE		0x40	//are dense turfs ignored in selection?
#define IGNORESPACE		0x80	//are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	0x100	//used by construct spells - checks for nullrods
#define NO_BUTTON		0x200	//spell won't show up in the HUD with this

//invocation
#define SpI_SHOUT	"shout"
#define SpI_WHISPER	"whisper"
#define SpI_EMOTE	"emote"
#define SpI_NONE	"none"

//upgrading
#define Sp_SPEED	"speed"
#define Sp_POWER	"power"
#define Sp_TOTAL	"total"

//casting costs
#define Sp_RECHARGE	"recharge"
#define Sp_CHARGES	"charges"
#define Sp_HOLDVAR	"holdervar"

#define INITIALIZATION_NOW 1
#define INITIALIZATION_HAS_BEGUN 2
#define INITIALIZATION_COMPLETE 4
#define INITIALIZATION_NOW_AND_COMPLETE (INITIALIZATION_NOW|INITIALIZATION_COMPLETE)
