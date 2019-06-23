// These are designed to be used within /datum/movement_handler procs
// Do not attempt to use in /atom/movable/proc/DoMove, /atom/movable/proc/MayMove, etc.
#define IS_SELF(w) !IS_NOT_SELF(w)
#define IS_NOT_SELF(w) (w && w != host)

// DELAY MOVEMENT TAG 
#define DELAY_ORIGIN "origin"
#define DELAY_VENTCRAWL "ventcrawl"
#define DELAY_AIRFLOW "airflow"
#define DELAY_HUMAN "human"
#define DELAY_SLIME "slime"
#define DELAY_ROBOT "robot"
#define DELAY_SIMPLE_ANIMAL "simple animal"
#define DELAY_MECH "mech"
#define DELAY_MOB "mob"
#define DELAY_LIVING "living"
#define DELAY_CARBON "carbon"
