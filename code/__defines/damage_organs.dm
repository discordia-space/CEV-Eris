// Damage things. TODO: Merge these down to reduce on defines.
// Way to waste perfectly good damage-type names (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(damagetype) in the proc.
#define BRUTE     "brute"
#define BURN      "fire"
#define TOX       "tox"
#define OXY       "oxy"
#define CLONE     "clone"
#define HALLOSS   "halloss"

#define CUT       "cut"
#define BRUISE    "bruise"
#define PIERCE    "pierce"

#define STUN      "stun"
#define WEAKEN    "weaken"
#define PARALYZE  "paralize"
#define IRRADIATE "irradiate"
#define AGONY     "agony"     // Added in PAIN!
#define SLUR      "slur"
#define STUTTER   "stutter"
#define EYE_BLUR  "eye_blur"
#define DROWSY    "drowsy"

#define FIRE_DAMAGE_MODIFIER 0.0215 // Higher values result in more external fire damage to the skin. (default 0.0215)
#define  AIR_DAMAGE_MODIFIER 2.025  // More means less damage from hot air scalding lungs, less = more damage. (default 2.025)

// Bodyparts and organs.
#define O_MOUTH    "mouth"
#define O_EYES     "eyes"
#define O_HEART    "heart"
#define O_LUNGS    "lungs"
#define O_BRAIN    "brain"
#define O_LIVER    "liver"
#define O_KIDNEYS  "kidneys"
#define O_APPENDIX "appendix"
#define O_CELL     "cell"

#define O_PLASMA   "plasma vessel"
#define O_HIVE     "hive node"
#define O_NUTRIENT "nutrient vessel"
#define O_STRATA   "neural strata"
#define O_RESPONSE "response node"
#define O_GBLADDER "gas bladder"
#define O_POLYP    "polyp segment"
#define O_ANCHOR   "anchoring ligament"
#define O_ACID     "acid gland"
#define O_EGG      "egg sac"
#define O_RESIN    "resin spinner"

#define BP_L_FOOT "l_foot"
#define BP_R_FOOT "r_foot"
#define BP_L_LEG  "l_leg"
#define BP_R_LEG  "r_leg"
#define BP_L_HAND "l_hand"
#define BP_R_HAND "r_hand"
#define BP_L_ARM  "l_arm"
#define BP_R_ARM  "r_arm"
#define BP_HEAD   "head"
#define BP_CHEST  "chest"
#define BP_GROIN  "groin"

#define BP_LEGS list(BP_R_LEG, BP_L_LEG, BP_R_FOOT, BP_L_FOOT)
#define BP_ALL list(BP_CHEST, BP_GROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)


// Organ defines.
#define ORGAN_CUT_AWAY   (1<<0)
#define ORGAN_BLEEDING   (1<<1)
#define ORGAN_BROKEN     (1<<2)
#define ORGAN_DESTROYED  (1<<3)
#define ORGAN_SPLINTED   (1<<4)
#define ORGAN_DEAD       (1<<5)
#define ORGAN_MUTATED    (1<<6)

#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

#define ORGAN_ASSISTED 1 // Like pacemakers, not robotic
#define ORGAN_ROBOT    2 // Fully robotic, no organic parts
#define ORGAN_LIFELIKE 3 // Robotic, made to appear organic

#define ORGAN_PROCESS_ACCURACY 10

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_SELF_REPAIR_CAP 30

//Germs and infections.
#define GERM_LEVEL_AMBIENT  110 // Maximum germ level you can reach by standing still.
#define GERM_LEVEL_MOVE_CAP 200 // Maximum germ level you can reach by running around.

#define INFECTION_LEVEL_ONE   100
#define INFECTION_LEVEL_TWO   500
#define INFECTION_LEVEL_THREE 1000
