SUBSYSTEM_DEF(statusEffects)
	name = "Status effects"
	flags = SS_TICKER
	priority = FIRE_PRIORITY_STATUSEFFECTS
	init_order = INIT_ORDER_STATUSEFFECTS
	runlevels = RUNLEVEL_GAME
	wait = 20
	var/list/mob/affectedMobs = list()

/datum/controller/subsystem/statusEffects/Initialize()
	for(var/datum/statusEffect/effect as anything in subtypesof(/datum/statusEffect))
		GLOB.globalEffects[initial(effect.identifier)] = effect
	return ..()

/datum/controller/subsystem/statusEffects/fire(resumed=FALSE)
	for(var/mobReference as anything in affectedMobs)
		if(!locate(mobReference))
			for(var/effect as anything in affectedMobs[mobReference])
				QDEL_NULL(effect)
			affectedMobs[mobReference] = null
			affectedMobs -= mobReference
		else
			for(var/datum/statusEffect/effect as anything in affectedMobs[mobReference])
				if((effect.startingTime + effect.duration) < world.time)
					affectedMobs[mobReference] -= effect
					effect.onFinish()
					qdel(effect)
					if(!length(affectedMobs[mobReference]))
						affectedMobs -= mobReference
						break
					continue
				effect.doEffect()

// Adds a status effect , if theres already a effect but the new one is gonna last longer the original one gets extended
proc/addStatusEffect(mob/target, effectType, duration)
	if(QDELETED(target))
		return FALSE
	// Not bad per say , but we shouldn't be using this subsystem for this scenario
	if(duration < 1)
		CRASH("Attempt to create statusEffect with a duration below 1 : [duration]")
	if(!GLOB.globalEffects[effectType])
		CRASH("Invalid effectType received : [effectType]")
	var/ef_type = GLOB.globalEffects[effectType]
	var/datum/statusEffect/createdEffect = new ef_type()
	if(!(createdEffect.flags & SE_FLAG_UNIQUE ))
		if(length(SSstatusEffects.affectedMobs[ref(target)]))
			var/datum/statusEffect/existingEffect = locate(ef_type) in SSstatusEffects.affectedMobs[ref(target)]
			if(existingEffect)
				if(existingEffect.duration + existingEffect.startingTime < world.time + duration)
					existingEffect.startingTime = world.time
					existingEffect.duration = duration
				return TRUE

	createdEffect.startingTime = world.time
	createdEffect.duration = duration
	createdEffect.mobReference = ref(target)
	if(length(SSstatusEffects.affectedMobs[ref(target)]))
		SSstatusEffects.affectedMobs[ref(target)] += createdEffect
	else
		SSstatusEffects.affectedMobs[ref(target)] += list(createdEffect)
	createdEffect.onStart()
	return TRUE

proc/removeStatusEffect(mob/target, effectType)
	if(QDELETED(target))
		return 0
	if(!effectType)
		return 0
	for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[ref(target)])
		if(effect.identifier == effectType)
			// guarantees removal on next tick
			effect.duration = -1

proc/hasStatusEffect(mob/target, effectType)
	if(QDELETED(target))
		return FALSE
	if(!effectType)
		return FALSE
	for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[ref(target)])
		if(effect.identifier == effectType)
			return TRUE
	return FALSE

proc/getStatusEffectDuration(mob/target, effectType)
	. = 0
	if(QDELETED(target))
		return 0
	if(!effectType)
		return 0
	for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[ref(target)])
		if(effect.identifier == effectType)
			if(effect.flags & SE_FLAG_UNIQUE)
				if(. < effect.duration + effect.startingTime - world.time)
					. = effect.duration + effect.startingTime - world.time
			else
				return effect.duration + effect.startingTime - world.time
	return .

// expect a list if its a unique effect
proc/getStatusEffect(mob/target, effectType)
	var/list/return_list = list()
	if(QDELETED(target))
		return FALSE
	if(!effectType)
		return FALSE
	for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[ref(target)])
		if(effect.identifier == effectType)
			if(!(effect.flags & SE_FLAG_UNIQUE))
				return effect
			return_list.Add(effect)
	return return_list


/datum/statusEffect
	// A identifying tag, always a define
	var/identifier
	// Starting world time
	var/startingTime
	// Duration in ms added ontop of startng time
	var/duration
	// Flags for defining extra behaviour
	var/flags
	// Mob reference , a weak one to not prevent deletions
	var/mobReference = null


// Called for every tick
/datum/statusEffect/proc/doEffect()
	return TRUE

// Called once  this status effect is removed.
/datum/statusEffect/proc/onFinish()
	return TRUE

// Caled once this status effect is added
/datum/statusEffect/proc/onStart()
	return TRUE

/datum/statusEffect/weakened
	identifier = SE_WEAKENED

/datum/statusEffect/weakened/onStart()
	var/mob/owner = locate(mobReference)
	if(owner)
		owner.update_lying_buckled_and_verb_status()
		owner.updateicon()

/datum/statusEffect/weakened/onFinish()
	var/mob/owner = locate(mobReference)
	if(owner)
		owner.update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
		owner.updateicon()

/datum/statusEffect/stunned
	identifier = SE_STUNNED

/datum/statusEffect/stunned/onStart()
	var/mob/owner = locate(mobReference)
	if(owner)
		owner.update_lying_buckled_and_verb_status()
		owner.updateicon()

/datum/statusEffect/stunned/onFinish()
	var/mob/owner = locate(mobReference)
	if(owner)
		owner.update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
		owner.updateicon()


/datum/statusEffect/paralyzed
	identifier = SE_PARALYZED

/datum/statusEffect/paralyzed/onStart()
	var/mob/owner = locate(mobReference)
	if(owner)
		owner.update_lying_buckled_and_verb_status()
		owner.updateicon()

/datum/statusEffect/paralyzed/onFinish()
	var/mob/owner = locate(mobReference)
	if(owner)
		owner.update_lying_buckled_and_verb_status()	//updates lying, canmove and icons
		owner.updateicon()





