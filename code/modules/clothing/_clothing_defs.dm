
/// For accesing sounds to play from clothing components for various actions
#define CS_PROJBLOCK "projblocked"
#define CS_PROJPARTIALBLOCK "projpartialblock"
#define CS_PROJPENETRATE "projpenetrate"
#define CS_MELLEBLOCK "melleblocked"
#define CS_MELLEPARTIALBLOCK "mellepartialblock"
#define CS_MELLEPENETRATE "mellepenetrate"

/// For defining the effects armor
/// Linear armor degradation based on health
#define CF_ARMOR_DEG_LINEAR 1<<1
/// Exponential armor degradation , based on how much health has been lost.
#define CF_ARMOR_DEG_EXPONENTIAL 1<<2
/// Custom armor degradation , will call proc/customDregadation and expect its new armor values
#define CF_ARMOR_DEG_CUSTOM 1<<3
/// For custom armor values , will not fetch from material type
#define CF_ARMOR_CUSTOM_VALS 1<<4
/// Will not fetch integrity from material
#define CF_ARMOR_CUSTOM_INTEGRITY 1<<5
/// Will not fetch weight from material
#define CF_ARMOR_CUSTOM_WEIGHT 1<<6
/// Will not fetch degradation from material
#define CF_ARMOR_CUSTOM_DEGR 1<<7

/// Multiplier for material armor values to clothing.  1 for now since they match 1 to 1
#define CLOTH_NORMAL_MTA_MUT 1
/// Multiplier for material integrity to clothing healthArmor , 5 times for clothing since bullests are very damaging
#define CLOTH_NORMAL_MTI_MUT 5
/// Multiplier for material weight to clothing weight. a little bit less since the human body is curvier than a cube
#define CLOTH_NORMAL_MTW_MUT 0.6

/// Indexes for volumes on each bodypart and armor plates
#define CLOTH_ARMOR_TORSO 1
#define CLOTH_ARMOR_SIDEGUARDS 2

/// Clothing flags
/// A cloth whose armor plates can't be modified.
#define CLOTH_NO_MOD 1<<1

/// Defines for accesories

/// Glueable armor.
#define ACS_GARMOR "garmor"
/// Armband , custom type so there can only be one
#define ACS_ARMBAND "armband"
/// For anything that can be used as decor and that generally doesn't stack.
#define ACS_DECOR "decor"
/// For utility related stuff , holster, etc.
#define ACS_UTILITY "utility"
