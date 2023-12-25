/*
#define HEAD        0x1
#define FACE        0x2
#define EYES        0x4
#define EARS        0x8
#define UPPER_TORSO 0x10
#define LOWER_TORSO 0x20
#define LEG_LEFT    0x40
#define LEG_RIGHT   0x80
#define LEGS        0xC0    //  LEG_LEFT | LEG_RIGHT
#define ARM_LEFT    0x400
#define ARM_RIGHT   0x800
#define ARMS        0xC00   //  ARM_LEFT | ARM_RIGHT
#define FULL_BODY   0xFFFF
 CLOTH COVERING DEFINES FOR CONVENIENCE */

GLOBAL_LIST(armorDegrdCache)
GLOBAL_LIST(armorInitialCache)
/obj/item/armor_component
	name = "Buggy armor plate"
	desc = "You shouldn't see this subtype... annoy SPCR to fix his code."
	icon = 'icons/obj/armor/armorSprites.dmi'
	spawn_blacklisted = TRUE
	/// Weight , set to 0 since we will set it ourselves
	weight = 0
	/// Defines the volume of this component. Makes a component take a lot more volume that other could use. Only used for component stuff
	var/volume = 0
	/// Defines the armor of this health. Fetched from material and multiplied
	var/armorHealth = 1500
	/// Defines the max health this armor may have. Fetched from material and multiplied
	var/maxArmorHealth = 1500
	var/covering = UPPER_TORSO | LOWER_TORSO
	/// Armor values , will be fetched from material on initialize and multiplied(if it is defined)
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_SLASH = 0,
		ARMOR_POINTY = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_ELECTRIC = 0,
		ARMOR_BIO = 0,
		ARMOR_CHEM = 0,
		ARMOR_RAD = 0
	)
	/// Defines damage degradation from various damage sources to the armor's health , multiplied agaisnt the projectile's damage. Global because having
	/// Multiple of this would be so bad on memory.
	var/list/armorDegradation = list(
		ARMOR_BLUNT = 1,
		ARMOR_SLASH = 1,
		ARMOR_POINTY = 1,
		ARMOR_BULLET = 1,
		ARMOR_ENERGY = 1,
		ARMOR_ELECTRIC = 1,
		ARMOR_BIO = 1,
		ARMOR_CHEM = 1,
		ARMOR_RAD = 1
	)
	/// A bit-set variable for various armor flags
	var/armorFlags = null
	/// A list of sounds used for when blocking hits OR various actions against is
	var/global/list/armorSounds = list(
		CS_PROJBLOCK = null,
		CS_PROJPARTIALBLOCK = null,
		CS_PROJPENETRATE = null,
		CS_MELLEBLOCK = null,
		CS_MELLEPARTIALBLOCK = null,
		CS_MELLEPENETRATE = null
	)
	/// The material used here , we fetch armor values from it. Initially the material name for init purposes or null for none
	/// We fetch armor degradation from it unless we have the custom degr flag, same with armors
	var/material/material = null
	/// A multiplier on the material armor values
	var/materialArmorMut = 1

/obj/item/armor_component/Initialize()
	if(!GLOB.armorDegrdCache)
		GLOB.armorDegrdCache = list()
	if(!GLOB.armorDegrdCache[type])
		GLOB.armorDegrdCache = armorDegradation
	else
		del(armorDegradation)
		armorDegradation = GLOB.armorDegrdCache
	/// Set armors before they're converted to the armor datum
	if(!material)
		. = ..()
		if(!GLOB.armorInitialCache)
			GLOB.armorInitialCache = list()
		if(!GLOB.armorInitialCache[type])
			GLOB.armorInitialCache[type] = armor.getList()
		return
	material = get_material_by_name(material)
	for(var/armorType in material.armor)
		if(!(armorFlags & CF_ARMOR_CUSTOM_VALS))
			armor[armorType] = round(material.armor[armorType] * CLOTH_NORMAL_MTA_MUT, 0.1)
		if(!(armorFlags & CF_ARMOR_CUSTOM_DEGR))
			armorDegradation[armorType] = material.armorDegradation[armorType]
	if(!(armorFlags & CF_ARMOR_CUSTOM_INTEGRITY))
		armorHealth = maxArmorHealth = round(material.integrity * CLOTH_NORMAL_MTI_MUT)
	if(!(armorFlags & CF_ARMOR_CUSTOM_WEIGHT))
		weight = round(material.weight * CLOTH_NORMAL_MTW_MUT)
	/// CALL PARENT TO INIT ARMOR DATUM
	. = ..()

/obj/item/armor_component/examine(user, distance)
	var/description = ""
	description += SPAN_NOTICE("Its current integrity is [armorHealth] / [maxArmorHealth] \n")
	for(var/armorType in armor.getList())
		description += SPAN_NOTICE("It has a rating of [armor.getRating(armorType)] against [armorType] \n")
	..(user, afterDesc = description)

/// Gets given the armorType to return a value for. Override this for your special plates
/// Call this for the standard rounding i guess(after you set the armor[armorType])
/// Sends the armorType for your special handling SPCR - 2023
/obj/item/armor_component/proc/customDregadation(armorType, armorValue)
	return round(armorValue, 0.1)

/obj/item/armor_component/proc/updateArmor()
	var/list/tempArmor = list()
	var/list/armorReference = null
	if(armorFlags & CF_ARMOR_CUSTOM_VALS)
		armorReference = GLOB.armorInitialCache[type]
	else
		armorReference = material.armor
	for(var/armorType in ALL_ARMOR)
		var/armorInitial = armorReference[armorType]
		if(armorFlags & CF_ARMOR_DEG_LINEAR)
			tempArmor[armorType] = round(((armorHealth + 0.0001)/ maxArmorHealth) * armorInitial * CLOTH_NORMAL_MTA_MUT, 0.1)
		else if(armorFlags & CF_ARMOR_DEG_EXPONENTIAL)
			tempArmor[armorType] = round(((armorHealth+0.0001)/maxArmorHealth)**2 * armorInitial * CLOTH_NORMAL_MTA_MUT, 0.1)
		else
			tempArmor[armorType] = customDregadation(armorType, armorInitial)


	armor = getArmor(
		ARMOR_BLUNT = tempArmor[ARMOR_BLUNT],
		ARMOR_SLASH = tempArmor[ARMOR_SLASH],
		ARMOR_POINTY = tempArmor[ARMOR_POINTY],
		ARMOR_BULLET = tempArmor[ARMOR_BULLET],
		ARMOR_ENERGY = tempArmor[ARMOR_ENERGY],
		ARMOR_ELECTRIC = tempArmor[ARMOR_ELECTRIC],
		ARMOR_BIO = tempArmor[ARMOR_BIO],
		ARMOR_CHEM = tempArmor[ARMOR_CHEM],
		ARMOR_RAD = tempArmor[ARMOR_RAD]
	)

/// Def zone is checked in clothing before
/obj/item/armor_component/blockDamages(list/armorToDam, armorDiv, woundMult, defZone)
	for(var/armorType in armorToDam)
		if(armorHealth <= 0)
			break
		for(var/list/damageElement in armorToDam[armorType])
			var/blocked = clamp(armor.getRating(armorType)/armorDiv, 0, damageElement[2])
			damageElement[2] -= blocked
			/// armorDiv also increases damage to
			armorHealth -= blocked * armorDegradation[armorType] * armorDiv
	updateArmor()
	return armorToDam


/obj/item/armor_component/plate
	name = "Armor plate"
	desc = "A very basic armor plate"
	covering = UPPER_TORSO | LOWER_TORSO
	armorFlags = CF_ARMOR_CUSTOM_VALS | CF_ARMOR_CUSTOM_DEGR | CF_ARMOR_CUSTOM_INTEGRITY | CF_ARMOR_CUSTOM_WEIGHT | CF_ARMOR_DEG_LINEAR
	/// A basic armor will have a volume storage of 3
	volume = 1

/obj/item/armor_component/sideguards
	name = "Leg & Arm guards"
	desc = "A basic set of rounded armor components for covering knees and ankles."
	covering = ARMS | LEGS
	armorFlags = CF_ARMOR_CUSTOM_VALS | CF_ARMOR_CUSTOM_DEGR | CF_ARMOR_CUSTOM_INTEGRITY | CF_ARMOR_CUSTOM_WEIGHT | CF_ARMOR_DEG_LINEAR
	volume = 1

/*
/obj/item/armor_component/armguards
	name = "Arm guards"
	desc = "A set of basic arm guards"
	covering = ARMS
	armorFlags = CF_ARMOR_CUSTOM_VALS | CF_ARMOR_CUSTOM_DEGR | CF_ARMOR_CUSTOM_INTEGRITY | CF_ARMOR_CUSTOM_WEIGHT | CF_ARMOR_DEG_LINEAR
	/// A basic armor will have a volume storage of 2 for these
	volume = 1

/obj/item/armor_component/legguards
	name = "Leg guards"
	desc = "A set of basic leg guards"
	covering = LEGS
	armorFlags = CF_ARMOR_CUSTOM_VALS | CF_ARMOR_CUSTOM_DEGR | CF_ARMOR_CUSTOM_INTEGRITY | CF_ARMOR_CUSTOM_WEIGHT | CF_ARMOR_DEG_LINEAR
	volume = 1
*/


