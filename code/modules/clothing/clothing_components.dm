/obj/item/clothing_component
	name = "Buggy clothing component"
	desc = "You shouldn't see this subtype... annoy SPCR to fix his code."
	spawn_blacklisted = TRUE
	/// Defines the weight of this component. More causes people to get slowdown
	var/weight = 0
	/// Defines the volume of this component. Makes a component take a lot more volume that other could use
	var/volume = 0
	/// Defines the armor of this health. Fetched from material and multiplied
	var/armorHealth = 1500
	/// Defines the max health this armor may have. Fetched from material and multiplied
	var/maxArmorHealth = 1500
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
	/// Multiple of this would be so bad on memory. Make custom subtypes for snowflake armor Degradations - SPCR 2023
	var/global/list/armorDegradation = list(
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
	/// The material used here , we fetch armor values from it. Initially the material name for init purposes
	var/material/material = null
	/// A multiplier on the material armor values
	var/materialArmorMut = 1

/obj/item/clothing_component/Initialize()
	/// Don't set material if you don't want to do anything with material value grabs
	if(!material)
		return ..()
	/// Set armors before they're converted to the armor datum
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

/// Gets given the armorType to return a value for. Override this for your special plates
/// Call this for the standard rounding i guess(after you set the armor[armorType])
/// Sends the armorType for your special handling SPCR - 2023
/obj/item/clothing_component/proc/customDregadation(armorType, armorValue)
	return round(armorValue, 0.1)

/obj/item/clothing_component/proc/updateArmor()
	var/list/tempArmor = list()
	for(var/armorType in ALL_ARMOR)
		switch(armorFlags)
			if(CF_ARMOR_DEG_LINEAR)
				tempArmor[armorType] = round((maxArmorHealth / (armorHealth + 0.1)) * material.armor[armorType] * CLOTH_NORMAL_MTA_MUT, 0.1)
			if(CF_ARMOR_DEG_EXPONENTIAL)
				tempArmor[armorType] = round((maxArmorHealth/(clamp((maxArmorHealth - armorHealth + 0.1)**2, 0, maxArmorHealth))) * material.armor[armorType] * CLOTH_NORMAL_MTA_MUT, 0.1)
			if(CF_ARMOR_DEG_CUSTOM)
				tempArmor[armorType] = customDregadation(armorType, material.armor[armorType])

