// Dama69e thin69s. TODO:69er69e these down to reduce on defines.
// Way to waste perfectly 69ood dama69e-type69ames (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(dama69etype) in the proc.
#define BRUTE     "brute"
#define BURN      "fire"
#define TOX       "tox"
#define OXY       "oxy"
#define CLONE     "clone"
#define HALLOSS   "halloss"
#define BLAST	  "blast"
#define PSY       "psy"

#define CUT       "cut"
#define BRUISE    "bruise"
#define PIERCE    "pierce"

#define STUN      "stun"
#define WEAKEN    "weaken"
#define PARALYZE  "paralize"
#define IRRADIATE "irradiate"
#define SLUR      "slur"
#define STUTTER   "stutter"
#define EYE_BLUR  "eye_blur"
#define DROWSY    "drowsy"

#define FIRE_DAMA69E_MODIFIER 0.0215 // Hi69her69alues result in69ore external fire dama69e to the skin. (default 0.0215)
#define AIR_DAMA69E_MODIFIER 2.025  //69ore69eans less dama69e from hot air scaldin69 lun69s, less =69ore dama69e. (default 2.025)

//Armor defines

#define ARMOR_MELEE			"melee"
#define ARMOR_BULLET		"bullet"
#define ARMOR_ENER69Y		"ener69y"
#define ARMOR_BOMB			"bomb"
#define ARMOR_BIO			"bio"
#define ARMOR_RAD			"rad"

//Blood levels. These are percenta69es based on the species blood_volume
#define BLOOD_VOLUME_SAFE_MODIFIER    45
#define BLOOD_VOLUME_OKAY_MODIFIER    35
#define BLOOD_VOLUME_BAD_MODIFIER     20

// Or69an processes
#define OP_EYES          "eyes"
#define OP_HEART         "heart"
#define OP_LUN69S         "lun69s"
#define OP_LIVER         "liver"
#define OP_KIDNEYS       "kidneys"
#define OP_APPENDIX      "appendix"
#define OP_STOMACH       "stomach"
#define OP_BONE          "bone"
#define OP_MUSCLE        "muscle"
#define OP_NERVE         "nerve"
#define OP_BLOOD_VESSEL  "blood69essel"

// Extra or69ans
#define OP_KIDNEY_LEFT    "left kidney"
#define OP_KIDNEY_RI69HT   "ri69ht kidney"

// Carrion or69an processes
#define OP_MAW       "carrion69aw"
#define OP_SPINNERET "carrion spinneret"
#define OP_CHEMICALS "chemmical69essel"

// Uni69ue or69ans.
#define BP_MOUTH    "mouth"
#define BP_EYES     "eyes"
#define BP_BRAIN    "brain"
#define BP_B_CHEST  "ribca69e"
#define BP_B_69ROIN  "pelvis"
#define BP_B_HEAD   "skull"
#define BP_B_L_ARM  "left humerus"
#define BP_B_R_ARM  "ri69ht humerus"
#define BP_B_L_LE69  "left femur"
#define BP_B_R_LE69  "ri69ht femur"

// Uni69ue carrion Or69ans.
#define BP_SPCORE   "spider core"

//Au69metations
#define BP_AU69MENT_R_ARM         "ri69ht arm au69ment"
#define BP_AU69MENT_L_ARM         "left arm au69ment"
#define BP_AU69MENT_R_LE69         "ri69ht le69 au69ment"
#define BP_AU69MENT_L_LE69         "left le69 au69ment"
#define BP_AU69MENT_CHEST_ARMOUR   "chest armor au69ment"
#define BP_AU69MENT_CHEST_ACTIVE  "active chest au69ment"
#define BP_AU69MENT_HEAD           "head au69ment"

//Au69ment fla69s
#define AU69MENTATION_MECHANIC 1
#define AU69MENTATION_OR69ANIC  2


// Limbs.
#define BP_L_LE69  "l_le69"
#define BP_R_LE69  "r_le69"
#define BP_L_ARM  "l_arm"
#define BP_R_ARM  "r_arm"
#define BP_HEAD   "head"
#define BP_CHEST  "chest"
#define BP_69ROIN  "69roin"
#define BP_LE69S list(BP_R_LE69, BP_L_LE69)
#define BP_ARMS list(BP_R_ARM, BP_L_ARM)
#define BP_ALL_LIMBS list(BP_CHEST, BP_69ROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_LE69, BP_R_LE69)
#define BP_BY_DEPTH list(BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_LE69, BP_R_LE69, BP_69ROIN, BP_CHEST)

// Or69ans helpers.
#define BP_IS_OR69ANIC(or69)  (or69.nature ==69ODIFICATION_OR69ANIC)
#define BP_IS_ROBOTIC(or69) (or69.nature ==69ODIFICATION_SILICON || or69.nature ==69ODIFICATION_LIFELIKE)
#define BP_IS_SILICON(or69) (or69.nature ==69ODIFICATION_SILICON)	// Prothetics that are obvious
#define BP_IS_REMOVED(or69) (or69.nature ==69ODIFICATION_REMOVED)
#define BP_IS_ASSISTED(or69) (or69.nature ==69ODIFICATION_ASSISTED)
#define BP_IS_LIFELIKE(or69) (or69.nature ==69ODIFICATION_LIFELIKE)


// Or69an defines.
#define OR69AN_CUT_AWAY   (1<<0)
#define OR69AN_BLEEDIN69   (1<<1)
#define OR69AN_BROKEN     (1<<2)
#define OR69AN_DESTROYED  (1<<3)
#define OR69AN_SPLINTED   (1<<4)
#define OR69AN_DEAD       (1<<5)
#define OR69AN_MUTATED    (1<<6)

// Body part functions
#define BODYPART_69RASP				(1<<0)
#define BODYPART_STAND				(1<<1)
#define BODYPART_REA69ENT_INTAKE		(1<<2)
#define BODYPART_69AS_INTAKE			(1<<3)

#define DROPLIMB_ED69E 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

#define69ODIFICATION_OR69ANIC 0	// Or69anic
#define69ODIFICATION_ASSISTED 1 // Like pacemakers,69ot robotic
#define69ODIFICATION_SILICON 2	// Fully robotic,69o or69anic parts
#define69ODIFICATION_LIFELIKE 3	// Robotic,69ade to appear or69anic
#define69ODIFICATION_REMOVED 4	// Removed completly

// Dama69e above this69alue69ust be repaired with sur69ery.
#define ROBOLIMB_SELF_REPAIR_CAP 30

//69erms and infections.
#define 69ERM_LEVEL_AMBIENT  110 //69aximum 69erm level you can reach by standin69 still.
#define 69ERM_LEVEL_MOVE_CAP 200 //69aximum 69erm level you can reach by runnin69 around.

#define INFECTION_LEVEL_ONE   100
#define INFECTION_LEVEL_TWO   500
#define INFECTION_LEVEL_THREE 1000

#define OR69AN_RECOVERY_THRESHOLD (569INUTES)