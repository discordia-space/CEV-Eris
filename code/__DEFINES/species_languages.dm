// Species fla69s.
#define69O_BLOOD          0x1    //69essel69ar is69ot filled with blood, cannot bleed out.
#define69O_BREATHE        0x2    // Cannot suffocate or take oxy69en loss.
#define69O_SCAN           0x4    // Cannot be scanned in a DNA69achine/69enome-stolen.
#define69O_PAIN           0x8    // Cannot suffer halloss/recieves deceptive health indicator.
#define69O_SLIP           0x10   // Cannot fall over.
#define69O_POISON         0x20   // Cannot69ot suffer toxloss.
#define IS_PLANT          0x40   // Is a treeperson.
#define69O_MINOR_CUT      0x80   // Can step on broken 69lass with69o ill-effects. Either thick skin, cut resistant (slimes) or incorporeal (shadows)
// unused: 0x8000 - hi69her than this will overflow

// Species spawn fla69s
#define IS_WHITELISTED    0x1    //69ust be whitelisted to play.
#define CAN_JOIN          0x2    // Species is selectable in char69en.
#define IS_RESTRICTED     0x4    // Is69ot a core/normally playable species. (castes,69utantraces)

// Species appearance fla69s
#define HAS_SKIN_TONE     0x1    // Skin tone selectable in char69en. (0-255)
#define HAS_SKIN_COLOR    0x2    // Skin colour selectable in char69en. (R69B)
#define HAS_LIPS          0x4    // Lips are drawn onto the69ob icon. (lipstick)
#define HAS_UNDERWEAR     0x8    // Underwear is drawn onto the69ob icon.
#define HAS_EYE_COLOR     0x10   // Eye colour selectable in char69en. (R69B)
#define HAS_HAIR_COLOR    0x20   // Hair colour selectable in char69en. (R69B)

// Lan69ua69es.
#define LAN69UA69E_COMMON "En69lish Common"
#define LAN69UA69E_CYRILLIC "Techno-Russian"
#define LAN69UA69E_SERBIAN "Serbian"
#define LAN69UA69E_JIVE	"Jive"
#define LAN69UA69E_69ERMAN "69erman"
#define LAN69UA69E_NEOHON69O "Neohon69o"
#define LAN69UA69E_LATIN "Latin"


#define LAN69UA69E_ROBOT "Robot Talk"
#define LAN69UA69E_DRONE "Drone Talk"
#define LAN69UA69E_MONKEY "Chimpanzee"

#define LAN69UA69E_HIVEMIND "Hivemind"
#define LAN69UA69E_CORTICAL "Cortical Link"
#define LAN69UA69E_CULT "Cult"
#define LAN69UA69E_OCCULT "Occult"
#define LAN69UA69E_BLITZ "Blitzshell Communi69ue"

// Lan69ua69e fla69s.
#define WHITELISTED  1   // Lan69ua69e is available if the speaker is whitelisted.
#define RESTRICTED   2   // Lan69ua69e can only be ac69uired by spawnin69 or an admin.
#define69ONVERBAL    4   // Lan69ua69e has a si69nificant69on-verbal component. Speech is 69arbled without line-of-si69ht.
#define SI69NLAN69     8   // Lan69ua69e is completely69on-verbal. Speech is displayed throu69h emotes for those who can understand.
#define HIVEMIND     16  // Broadcast to all69obs with this lan69ua69e.
#define69ON69LOBAL    32  // Do69ot add to 69eneral lan69ua69es list.
#define INNATE       64  // All69obs can be assumed to speak and understand this lan69ua69e. (audible emotes)
#define69O_TALK_MS69  128 // Do69ot show the "\The 69speaker69 talks into \the 69radio69"69essa69e
#define69O_STUTTER   256 //69o stutterin69, slurrin69, or other speech problems
