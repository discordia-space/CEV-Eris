#define DELEM(damType, damValue) (list(damType,damValue))

/proc/dhApplyMultiplier(list/damages, multiplier)
	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			damageElement[2] *= multiplier

/proc/dhApplyStrictMultiplier(list/damages, list/acceptableArmors, list/acceptableTypes, multiplier)
	for(var/armorType in acceptableArmors)
		if(length(damages[armorType]))
			for(var/list/damageElement in damages[armorType])
				if(locate(damageElement[1]) in acceptableTypes)
					damageElement[2] *= multiplier

/proc/dhAddDamage(list/damages, armorType, damageType, damageValue)
	if(!length(damages[armorType]))
		damages[armorType] = list()
	damages[armorType]:Add(DELEM(damageType, damageValue))
	return TRUE

/proc/dhAdjOrAddDamage(list/damages, armorType, damageType, damageValue)
	if(!length(damages[armorType]))
		dhAddDamage(damages, armorType, damageType, damageValue)
		return
	for(var/list/damageElement in damages[armorType])
		if(damageElement[1] == damageType)
			damageElement[2] += damageValue
			return
	dhAddDamage(damages, armorType, damageType, damageValue)

/proc/dhRemoveStrictDamage(list/damages, armorType, damageType, damageValue)
	if(!locate(armorType) in damages)
		return
	for(var/list/damageElement in damages[armorType])
		if(damageElement[1] == damageType)
			var/removed = clamp(damageValue, 0, damageElement[2])
			damageValue -= removed
			damageElement[2] -= removed
			if(damageValue <= 0)
				return
	return

/proc/dhRemoveDamage(list/damages, damageType, damageValue)
	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			if(damageElement[1] == damageType)
				var/removed = clamp(damageValue, 0, damageElement[2])
				damageValue -= removed
				damageElement[2] -= removed
				if(damageValue <= 0)
					return
	return

/proc/dhRemoveDamageEqual(list/damages, removeValue)
	var/elementCount = 0
	var/leftOver = 0
	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			if(damageElement[2] > 0)
				elementCount++

	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			if(damageElement[2] <= 0)
				continue
			var/blocked = max(removeValue/elementCount + leftOver, 0, damageElement[2])
			if(blocked < removeValue/elementCount)
				leftOver += removeValue/elementCount - blocked
			else
				leftOver -= blocked - removeValue/elementCount
			damageElement[2] -= blocked


/proc/dhTotalDamage(list/damages)
	. = 0
	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			. += damageElement[2]
	return .

/proc/dhTotalDamageDamageType(list/damages, damageType)
	. = 0
	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			if(damageElement[1] == damageType)
				. += damageElement[2]
	return .

/proc/dhTotalDamageArmorType(list/damages, armorType)
	. = 0
	if(!length(damages[armorType]))
		return .
	for(var/list/damageElement in damages[armorType])
		. += damageElement[2]
	return .

/proc/dhTotalDamageStrict(list/damages, list/armorTypes, list/damageTypes)
	. = 0
	for(var/armorType in armorTypes)
		if(length(damages[armorType]))
			for(var/list/damageElement in damages[armorType])
				if(locate(damageElement[1]) in damageTypes)
					. += damageElement[2]
	return .

/proc/dhHasDamageType(list/damages, damageType)
	for(var/armorType in damages)
		for(var/list/damageElement in damages[armorType])
			if(damageElement[1] == damageType)
				return TRUE
	return FALSE




