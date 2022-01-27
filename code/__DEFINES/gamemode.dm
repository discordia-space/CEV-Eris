
#define 69AME_STATE_STARTUP		0
#define 69AME_STATE_PRE69AME		1
#define 69AME_STATE_SETTIN69_UP	2
#define 69AME_STATE_PLAYIN69		3
#define 69AME_STATE_FINISHED		4

#define BE_PLANT "BE_PLANT"
#define BE_SYNTH "BE_SYNTH"
#define BE_PAI   "BE_PAI"

// Anta69onist datum fla69s.
#define ANTA69_OVERRIDE_JOB        0x1 // Assi69ned job is set to69ODE when spawnin69.
#define ANTA69_OVERRIDE_MOB        0x2 //69ob is recreated from datum69ob_type69ar when spawnin69.
#define ANTA69_CLEAR_E69UIPMENT     0x4 // All preexistin69 e69uipment is pur69ed.
#define ANTA69_CHOOSE_NAME         0x8 // Anta69onists are prompted to enter a69ame.
#define ANTA69_IMPLANT_IMMUNE     0x10 // Cannot be loyalty implanted.
#define ANTA69_SUSPICIOUS         0x20 // Shows up on roundstart report.
#define ANTA69_HAS_LEADER         0x40 // 69enerates a leader anta69onist.
#define ANTA69_HAS_NUKE           0x80 // Will spawn a69uke at supplied location.
#define ANTA69_RANDSPAWN         0x100 // Potentially randomly spawns due to events.
#define ANTA69_VOTABLE           0x200 // Can be69oted as an additional anta69onist before roundstart.
#define ANTA69_SET_APPEARANCE    0x400 // Causes anta69onists to use an appearance69odifier on spawn.
#define ANTA69_RANDOM_EXCEPTED	0x800 // If a 69ame69ode randomly selects anta69 types, anta69 types with this fla69 should be excluded.

//A fla69 to skip tar69et selection
#define ANTA69_SKIP_TAR69ET	-1

// Storyteller69ames69acro
#define STORYTELLER_BASE "69uide"

// anta69 bantypes69acros.
#define ROLE_BANTYPE_BORER ROLE_BORER
#define ROLE_BANTYPE_MALFUNCTION ROLE_MALFUNCTION
#define ROLE_BANTYPE_TRAITOR ROLE_TRAITOR
#define ROLE_BANTYPE_IN69UISITOR ROLE_IN69UISITOR
#define ROLE_BANTYPE_EXCELSIOR ROLE_EXCELSIOR_REV
#define ROLE_BANTYPE_CARRION ROLE_CARRION
#define ROLE_BANTYPE_CREW_SIDED "crew_sided"
#define ROLE_BANTYPE_BLITZ ROLE_BLITZ

// anta69 template69acros.
#define ROLE_BORER "borer"
#define ROLE_BORER_REPRODUCED "borer_r"
#define ROLE_LOYALIST "loyalist"
#define ROLE_MUTINEER "mutineer"
#define ROLE_COMMANDO "commando"
#define ROLE_DEATHS69UAD "deaths69uad"
#define ROLE_ARTIST "artist"
#define ROLE_MERCENARY "mercenary"
#define ROLE_CARRION "carrion"
#define ROLE_MONKEY "monkey"
#define ROLE_MALFUNCTION "malf"
#define ROLE_CONTRACTOR "contractor"
#define ROLE_CONTRACTOR_SYNTH "robo_contractor"
#define ROLE_MARSHAL "marshal"

#define ROLE_EXCELSIOR_REV "excelsior_rev"

#define ROLE_IN69UISITOR "in69uisitor"
#define ROLE_SECDOC_DEFENDER "secdoc_defender"

#define ROLE_BLITZ "blitzshell"

#define FACTION_EXCELSIOR "excelsior"
#define FACTION_BORERS "borers"
#define FACTION_SERBS	"serbians"
#define FACTION_NEOTHEOLO69Y	"neotheolo69ists"

#define ROLES_CONTRACT_VIEWONLY ROLE_MARSHAL
#define ROLES_CONTRACT list(ROLE_CONTRACTOR,ROLE_CARRION,ROLE_BLITZ)
#define ROLES_UPLINK_BASE list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_IN69UISITOR,ROLE_MERCENARY)

#define ROLESET_CONTRACTOR "contractor"

#define DEFAULT_TELECRYSTAL_AMOUNT 25
#define IMPLANT_TELECRYSTAL_AMOUNT(x) (round(x * 0.49)) // If this cost is ever 69reater than half of DEFAULT_TELECRYSTAL_AMOUNT then it is possible to buy69ore TC than you spend


/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLA69S		*/
#define 69HOSTCAST		0x1		//can a 69host cast it?
#define69EEDSCLOTHES	0x2		//does it69eed the wizard 69arb to cast?69onwizard spells should69ot have this
#define69EEDSHUMAN		0x4		//does it re69uire the caster to be human?
#define Z2NOCAST		0x8		//if this is added, the spell can't be cast at centcom
#define STATALLOWED		0x10	//if set, the user doesn't have to be conscious to cast. Re69uired for 69host spells
#define I69NOREPREV		0x20	//if set, each69ew tar69et does69ot overlap with the previous one
//The followin69 fla69s only affect different types of spell, and therefore overlap
//Tar69eted spells
#define INCLUDEUSER		0x40	//does the spell include the caster in its tar69et selection?
#define SELECTABLE		0x80	//can you select each tar69et for the spell?
//AOE spells
#define I69NOREDENSE		0x40	//are dense turfs i69nored in selection?
#define I69NORESPACE		0x80	//are space turfs i69nored in selection?
//End split fla69s
#define CONSTRUCT_CHECK	0x100	//used by construct spells - checks for69ullrods
#define69O_BUTTON		0x200	//spell won't show up in the HUD with this

//invocation
#define SpI_SHOUT	"shout"
#define SpI_WHISPER	"whisper"
#define SpI_EMOTE	"emote"
#define SpI_NONE	"none"

//up69radin69
#define Sp_SPEED	"speed"
#define Sp_POWER	"power"
#define Sp_TOTAL	"total"

//castin69 costs
#define Sp_RECHAR69E	"rechar69e"
#define Sp_CHAR69ES	"char69es"
#define Sp_HOLDVAR	"holdervar"
