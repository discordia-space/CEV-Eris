// Damage things. TODO: Merge these down to reduce on defines.
// Way to waste perfectly good damage-type names (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(damagetype) in the proc.
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

#define FIRE_DAMAGE_MODIFIER 0.0215 // Higher values result in more external fire damage to the skin. (default 0.0215)
#define AIR_DAMAGE_MODIFIER 2.025  // More means less damage from hot air scalding lungs, less = more damage. (default 2.025)

//Armor defines

#define ARMOR_MELEE			"melee"
#define ARMOR_BULLET		"bullet"
#define ARMOR_ENERGY		"energy"
#define ARMOR_BOMB			"bomb"
#define ARMOR_BIO			"bio"
#define ARMOR_RAD			"rad"

//Blood levels. These are percentages based on the species blood_volume
#define BLOOD_VOLUME_SAFE_MODIFIER    45
#define BLOOD_VOLUME_OKAY_MODIFIER    35
#define BLOOD_VOLUME_BAD_MODIFIER     20

// Organ processes
#define OP_EYES          "eyes"
#define OP_HEART         "heart"
#define OP_LUNGS         "lungs"
#define OP_LIVER         "liver"
#define OP_KIDNEYS       "kidneys"
#define OP_APPENDIX      "appendix"
#define OP_STOMACH       "stomach"
#define OP_BONE          "bone"
#define OP_MUSCLE        "muscle"
#define OP_NERVE         "nerve"
#define OP_BLOOD_VESSEL  "blood vessel"

// Extra organs
#define OP_KIDNEY_LEFT    "left kidney"
#define OP_KIDNEY_RIGHT   "right kidney"

// Carrion organ processes
#define OP_MAW       "carrion maw"
#define OP_SPINNERET "carrion spinneret"
#define OP_CHEMICALS "chemmical vessel"

// Unique organs.
#define BP_MOUTH    "mouth"
#define BP_EYES     "eyes"
#define BP_BRAIN    "brain"
#define BP_B_CHEST  "ribcage"
#define BP_B_GROIN  "pelvis"
#define BP_B_HEAD   "skull"
#define BP_B_L_ARM  "left humerus"
#define BP_B_R_ARM  "right humerus"
#define BP_B_L_LEG  "left femur"
#define BP_B_R_LEG  "right femur"

// Unique carrion Organs.
#define BP_SPCORE   "spider core"

//Augmetations
#define BP_AUGMENT_R_ARM         "right arm augment"
#define BP_AUGMENT_L_ARM         "left arm augment"
#define BP_AUGMENT_R_LEG         "right leg augment"
#define BP_AUGMENT_L_LEG         "left leg augment"
#define BP_AUGMENT_CHEST_ARMOUR   "chest armor augment"
#define BP_AUGMENT_CHEST_ACTIVE  "active chest augment"
#define BP_AUGMENT_HEAD           "head augment"

//Augment flags
#define AUGMENTATION_MECHANIC 1
#define AUGMENTATION_ORGANIC  2


// Limbs.
#define BP_L_LEG  "l_leg"
#define BP_R_LEG  "r_leg"
#define BP_L_ARM  "l_arm"
#define BP_R_ARM  "r_arm"
#define BP_HEAD   "head"
#define BP_CHEST  "chest"
#define BP_GROIN  "groin"
#define BP_LEGS list(BP_R_LEG, BP_L_LEG)
#define BP_ARMS list(BP_R_ARM, BP_L_ARM)
#define BP_ALL_LIMBS list(BP_CHEST, BP_GROIN, BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
#define BP_BY_DEPTH list(BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_CHEST)

// Organs helpers.
#define BP_IS_ORGANIC(org)  (org.nature == MODIFICATION_ORGANIC)
#define BP_IS_ROBOTIC(org) (org.nature == MODIFICATION_SILICON || org.nature == MODIFICATION_LIFELIKE)
#define BP_IS_SILICON(org) (org.nature == MODIFICATION_SILICON)	// Prothetics that are obvious
#define BP_IS_REMOVED(org) (org.nature == MODIFICATION_REMOVED)
#define BP_IS_ASSISTED(org) (org.nature == MODIFICATION_ASSISTED)
#define BP_IS_LIFELIKE(org) (org.nature == MODIFICATION_LIFELIKE)


// Organ defines.
#define ORGAN_CUT_AWAY	(1<<0)
#define ORGAN_BLEEDING	(1<<1)
#define ORGAN_BROKEN	(1<<2)
#define ORGAN_DESTROYED	(1<<3)
#define ORGAN_SPLINTED	(1<<4)
#define ORGAN_DEAD		(1<<5)
#define ORGAN_MUTATED	(1<<6)
#define ORGAN_INFECTED	(1<<7)
#define ORGAN_WOUNDED	(1<<8)

// Body part functions
#define BODYPART_GRASP				(1<<0)
#define BODYPART_STAND				(1<<1)
#define BODYPART_REAGENT_INTAKE		(1<<2)
#define BODYPART_GAS_INTAKE			(1<<3)

#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2
#define DROPLIMB_EDGE_BURN 3

#define MODIFICATION_ORGANIC 0	// Organic
#define MODIFICATION_ASSISTED 1 // Like pacemakers, not robotic
#define MODIFICATION_SILICON 2	// Fully robotic, no organic parts
#define MODIFICATION_LIFELIKE 3	// Robotic, made to appear organic
#define MODIFICATION_REMOVED 4	// Removed completly

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_SELF_REPAIR_CAP 30

#define ORGAN_RECOVERY_THRESHOLD (5 MINUTES)

// INTERNAL ORGANS
#define IORGAN_VITAL_HEALTH 12 // Heart
#define IORGAN_VITAL_BRUISE 6
#define IORGAN_VITAL_BREAK 8
#define IORGAN_STANDARD_HEALTH 8
#define IORGAN_STANDARD_BRUISE 3
#define IORGAN_STANDARD_BREAK 5
#define IORGAN_SMALL_HEALTH 6
#define IORGAN_SMALL_BRUISE 2
#define IORGAN_SMALL_BREAK 4
#define IORGAN_TINY_HEALTH 4
#define IORGAN_TINY_BRUISE 1
#define IORGAN_TINY_BREAK 2
#define IORGAN_SKELETAL_HEALTH 14
#define IORGAN_SKELETAL_BRUISE 4
#define IORGAN_SKELETAL_BREAK 6
#define IORGAN_MAX_HEALTH 14 // Brain

#define IORGAN_KIDNEY_TOX_RATIO 0.25
#define IORGAN_LIVER_TOX_RATIO 0.75

// INTERNAL WOUNDS
#define TREATMENT_ITEM 1
#define TREATMENT_TOOL 2
#define TREATMENT_CHEM 3

#define IWOUND_CAN_DAMAGE		(1<<0)
#define IWOUND_PROGRESS			(1<<1)
#define IWOUND_PROGRESS_DEATH	(1<<2)
#define IWOUND_SPREAD			(1<<3)
#define IWOUND_HALLUCINATE		(1<<4)

#define IWOUND_INSIGNIFICANT_DAMAGE 0.05
#define IWOUND_LIGHT_DAMAGE 0.1
#define IWOUND_MEDIUM_DAMAGE 0.25
#define IWOUND_HEAVY_DAMAGE 0.5

#define IWOUND_1_MINUTE	30
#define IWOUND_2_MINUTES 60
#define IWOUND_3_MINUTES 90
#define IWOUND_4_MINUTES 120
#define IWOUND_5_MINUTES 150

// Organ generation
#define ORGAN_HAS_BONES			(1<<0)
#define ORGAN_HAS_BLOOD_VESSELS	(1<<1)
#define ORGAN_HAS_NERVES		(1<<2)
#define ORGAN_HAS_MUSCLES		(1<<3)
