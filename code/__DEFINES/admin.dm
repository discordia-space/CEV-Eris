// A set of constants used to determine which type of69ute an admin wishes to apply.
// Please read and understand the69utin69/automutin69 stuff before chan69in69 these.69UTE_IC_AUTO, etc. = (MUTE_IC << 1)
// Therefore there69eeds to be a 69ap between the fla69s for the automute fla69s.
#define69UTE_IC        0x1
#define69UTE_OOC       0x2
#define69UTE_PRAY      0x4
#define69UTE_ADMINHELP 0x8
#define69UTE_DEADCHAT  0x10
#define69UTE_ALL       0xFFFF

//69umber of identical69essa69es re69uired to 69et the spam-prevention auto-mute thin69 to tri6969er warnin69s and automutes.
#define SPAM_TRI6969ER_WARNIN69  5
#define SPAM_TRI6969ER_AUTOMUTE 10

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LO69OUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

// Admin permissions.
#define R_FUN           0x1
#define R_SERVER        0x2
#define R_DEBU69         0x4
#define R_PERMISSIONS   0x8
#define R_MENTOR        0x10
#define R_MOD           0x20
#define R_ADMIN         0x40

// Host permission (sum of all permissions above) is e69ual to 127 or 0x7F
#define R_HOST 0x7F // Used for debu69/mock only

#define R_MAXPERMISSION 0x40 // This holds the69aximum69alue for a permission. It is used in iteration, so keep it updated.

#define ADMIN_VERB_ADD(path, ri69hts, keep)\
	world/re69istrate_verbs() {..(); cmd_re69istrate_verb(path, ri69hts, keep);}
