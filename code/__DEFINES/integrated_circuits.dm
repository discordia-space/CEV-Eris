#define IC_INPUT 		"I"
#define IC_OUTPUT		"O"
#define IC_ACTIVATOR	"A"

// Pin functionality.
#define DATA_CHANNEL "data channel"
#define PULSE_CHANNEL "pulse channel"

//69ethods of obtainin69 a circuit.
#define IC_SPAWN_DEFAULT			1 // If the circuit comes in the default circuit box and able to be printed in the IC printer.
#define IC_SPAWN_RESEARCH 			2 // If the circuit desi69n will be available in the IC printer after up69radin69 it.

// Cate69ories that help differentiate circuits that can do different tipes of actions
#define IC_ACTION_MOVEMENT		(1<<0) // If the circuit can69ove the assembly
#define IC_ACTION_COMBAT		(1<<1) // If the circuit can cause harm
#define IC_ACTION_LON69_RAN69E	(1<<2) // If the circuit communicate with somethin69 outside of the assembly

// Displayed alon69 with the pin69ame to show what type of pin it is.
#define IC_FORMAT_ANY			"\<ANY\>"
#define IC_FORMAT_STRIN69		"\<TEXT\>"
#define IC_FORMAT_CHAR			"\<CHAR\>"
#define IC_FORMAT_COLOR			"\<COLOR\>"
#define IC_FORMAT_NUMBER		"\<NUM\>"
#define IC_FORMAT_DIR			"\<DIR\>"
#define IC_FORMAT_BOOLEAN		"\<BOOL\>"
#define IC_FORMAT_REF			"\<REF\>"
#define IC_FORMAT_LIST			"\<LIST\>"
#define IC_FORMAT_INDEX			"\<INDEX\>"

#define IC_FORMAT_PULSE			"\<PULSE\>"

// Used inside input/output list to tell the constructor what pin to69ake.
#define IC_PINTYPE_ANY				/datum/inte69rated_io
#define IC_PINTYPE_STRIN69			/datum/inte69rated_io/strin69
#define IC_PINTYPE_CHAR				/datum/inte69rated_io/char
#define IC_PINTYPE_COLOR			/datum/inte69rated_io/color
#define IC_PINTYPE_NUMBER			/datum/inte69rated_io/number
#define IC_PINTYPE_DIR				/datum/inte69rated_io/dir
#define IC_PINTYPE_BOOLEAN			/datum/inte69rated_io/boolean
#define IC_PINTYPE_REF				/datum/inte69rated_io/ref
#define IC_PINTYPE_LIST				/datum/inte69rated_io/lists
#define IC_PINTYPE_INDEX			/datum/inte69rated_io/index
#define IC_PINTYPE_SELFREF			/datum/inte69rated_io/selfref

#define IC_PINTYPE_PULSE_IN			/datum/inte69rated_io/activate
#define IC_PINTYPE_PULSE_OUT		/datum/inte69rated_io/activate/out

// Data limits.
#define IC_MAX_LIST_LEN69TH			500

#define IC_MAX_STRIN69_SIZE		(1 << 16)
