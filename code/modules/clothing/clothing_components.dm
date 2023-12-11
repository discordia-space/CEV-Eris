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
	/// Armor values , will be fetched from material on initialize and multiplied
	armor = list(
		BRUTE = 1,
		BURN = 1,
		TOX = 1,
		OXY = 1,
		CLONE = 1,
		HALLOSS = 0,
		BLAST = 1,
		PSY = 1
	)
	/// Defines damage degradation from various damage sources to the armor's health , multiplied agaisnt the projectile's damage. Fetched from material
	var/list/armorDegradation = list(
		BRUTE = 1,
		BURN = 1,
		TOX = 1,
		OXY = 1,
		CLONE = 1,
		HALLOSS = 0,
		BLAST = 1,
		PSY = 1
	)
	/// A bit-set variable for various armor flags
	var/armorFlags = null
	/// A list of sounds used for when blocking hits OR various actions against is
	var/list/armorSounds = list(
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
	. = ..()
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

/// Gets given the armorType to return a value for. Override this for your special plates
/// Call this for the standard rounding i guess(after you set the armor[armorType])
/obj/item/clothing_component/proc/customDregadation(armorType)
	return round(armor[armorType], 0.1)

/obj/item/clothing_component/proc/updateArmor()
	for(var/armorType in armor)
		switch(armorFlags)
			if(CF_ARMOR_DEG_LINEAR)
				armor[armorType] = round((maxArmorHealth / (armorHealth + 0.1)) * material.armor[armorType] * CLOTH_NORMAL_MTA_MUT, 0.1)
			if(CF_ARMOR_DEG_EXPONENTIAL)
				armor[armorType] = round((maxArmorHealth/(clamp((maxArmorHealth - armorHealth + 0.1)**2, 0, maxArmorHealth))) * material.armor[armorType] * CLOTH_NORMAL_MTA_MUT, 0.1)
			if(CF_ARMOR_DEG_CUSTOM)
				armor[armorType] = customDregadation(armorType)

