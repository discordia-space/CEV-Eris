#define ALL (~0) //For convenience.
#define NONE 0

#define FLAGS_EQUALS(flag, flags) ((flag & (flags)) == (flags))

// for /datum/var/datum_flags
#define DF_USE_TAG (1<<0)
#define DF_VAR_EDITED (1<<1)
#define DF_ISPROCESSING (1<<2)
