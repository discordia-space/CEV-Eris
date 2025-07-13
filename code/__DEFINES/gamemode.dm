
//SSticker.current_state values
/// Game is loading
#define GAME_STATE_STARTUP		0
/// Game is loaded and in pregame lobby
#define GAME_STATE_PREGAME		1
/// Game is attempting to start the round
#define GAME_STATE_SETTING_UP	2
/// Game has round in progress
#define GAME_STATE_PLAYING		3
/// Game has round finished
#define GAME_STATE_FINISHED		4

// Used for SSticker.force_ending
/// Default, round is not being forced to end.
#define END_ROUND_AS_NORMAL 0
/// End the round now as normal
#define FORCE_END_ROUND 1
/// For admin forcing roundend, can be used to distinguish the two
#define ADMIN_FORCE_END_ROUND 2


#define BE_PLANT "BE_PLANT"
#define BE_SYNTH "BE_SYNTH"
#define BE_PAI   "BE_PAI"

// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB        0x1 // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB        0x2 // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT     0x4 // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME         0x8 // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     0x10 // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         0x20 // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         0x40 // Generates a leader antagonist.
#define ANTAG_HAS_NUKE           0x80 // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN         0x100 // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE           0x200 // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE    0x400 // Causes antagonists to use an appearance modifier on spawn.
#define ANTAG_RANDOM_EXCEPTED	0x800 // If a game mode randomly selects antag types, antag types with this flag should be excluded.

//A flag to skip target selection
#define ANTAG_SKIP_TARGET	-1

// Storyteller names macro
#define STORYTELLER_BASE "guide"

// antag bantypes macros.
#define ROLE_BANTYPE_BORER ROLE_BORER
#define ROLE_BANTYPE_MALFUNCTION ROLE_MALFUNCTION
#define ROLE_BANTYPE_TRAITOR ROLE_TRAITOR
#define ROLE_BANTYPE_INQUISITOR ROLE_INQUISITOR
#define ROLE_BANTYPE_EXCELSIOR ROLE_EXCELSIOR_REV
#define ROLE_BANTYPE_CARRION ROLE_CARRION
#define ROLE_BANTYPE_CREW_SIDED ROLE_MARSHAL
#define ROLE_BANTYPE_BLITZ ROLE_BLITZ

// antag template macros. commented out ones are leftover from baycode
#define ROLE_BORER "Cortical Borer"
#define ROLE_BORER_REPRODUCED "Cortical Borer (Reproduced)"
// #define ROLE_LOYALIST "Loyalist"
// #define ROLE_MUTINEER "Mutineer"
// #define ROLE_COMMANDO "Commando"
// #define ROLE_DEATHSQUAD "Death Squad"
// #define ROLE_ARTIST "Artist"
#define ROLE_MERCENARY "Serbian Mercenary"
#define ROLE_PIRATE "Pirate"
#define ROLE_CARRION "Carrion"
#define ROLE_MONKEY "Monkey"
#define ROLE_MALFUNCTION "Malf AI"
#define ROLE_CONTRACTOR "Contractor"
#define ROLE_CONTRACTOR_SYNTH "Robo Contractor"
#define ROLE_MARSHAL "Ironhammer Marshal"

#define ROLE_EXCELSIOR_REV "Excelsior Infiltrator"

#define ROLE_INQUISITOR "Inquisitor"
// #define ROLE_SECDOC_DEFENDER "Secdoc Defender"


#define ROLE_BLITZ "Blitzshell"
#define ROLE_PAI "PAI"
#define ROLE_DRONE "Drone"
#define ROLE_POSIBRAIN "Positronic Brain"

#define FACTION_EXCELSIOR "excelsior"
#define FACTION_BORERS "borers"
#define FACTION_SERBS	"serbians"
#define FACTION_PIRATES	"pirates"
#define FACTION_NEOTHEOLOGY	"neotheologists"

#define ROLES_CONTRACT_COMPLETE list(ROLE_CONTRACTOR,ROLE_CARRION) // Blitz not included
#define ROLES_CONTRACT_VIEW list(ROLE_CONTRACTOR,ROLE_CARRION,ROLE_BLITZ,ROLE_MARSHAL)
#define ROLES_UPLINK_BASE list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY)

#define ROLESET_CONTRACTOR "contractor"

#define DEFAULT_TELECRYSTAL_AMOUNT 25
#define IMPLANT_TELECRYSTAL_AMOUNT(x) (round(x * 0.49)) // If this cost is ever greater than half of DEFAULT_TELECRYSTAL_AMOUNT then it is possible to buy more TC than you spend


/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		0x1		//can a ghost cast it?
#define NEEDSCLOTHES	0x2		//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		0x4		//does it require the caster to be human?
#define Z2NOCAST		0x8		//if this is added, the spell can't be cast at centcom
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
