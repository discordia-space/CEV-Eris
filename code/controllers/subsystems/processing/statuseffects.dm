SUBSYSTEM_DEF(statusEffects)
	name = "Status effects"
	flags = SS_TICKER
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 1
	var/list/mob/affectedMobs = list()

/datum/controller/subsystem/statusEffects/Initialize()
	for(var/datum/statusEffect/effect as anything in subtypesof(/datum/statusEffect))
		GLOB.globalEffects[effect.identifier] = effect

/datum/controller/subsystem/statusEffects/fire(resumed=FALSE)
	for(var/mob/affectedMob as anything in affectedMobs)
		for(var/datum/statusEffect/effect as anything in affectedMobs[affectedMob])
			if(!effect.mobReference.resolve())
				affectedMobs[affectedMob] -= effect
				qdel(effect)
				if(!length(affectedMobs[affectedMob]))
					affectedMobs -= affectedMob
			if((effect.startingTime + effect.duration) < world.time)
				affectedMobs[affectedMob] -= effect
				effect.onFinish()
				qdel(effect)
				if(!length(affectedMobs[affectedMob]))
					affectedMobs -= affectedMob
				continue
			effect.doEffect()

// Adds a status effect , if theres already a effect but the new one is gonna last longer the original one gets extended
proc/addStatusEffect(mob/target, effectType, duration)
	if(!target || target.gc_destroyed)
		return FALSE
	// Not bad per say , but we shouldn't be using this subsystem for this scenario
	if(duration < 1)
		CRASH("Attempt to create statusEffect with a duration below 1 : [duration]")
	if(!GLOB.globalEffects[effectType])
		CRASH("Invalid effectType received : [effectType]")
	var/datum/statusEffect/createdEffect = new GLOB.globalEffects[effectType]
	if(!(createdEffect.flags & SE_FLAG_UNIQUE ))
		if(SSstatusEffects.affectedMobs[target])
			var/list/l = SSstatusEffects.affectedMobs[target]
			var/pos = l.Find(createdEffect)
			var/datum/statusEffect/existingEffect = SSstatusEffects.affectedMobs[target][pos]
			if(!(existingEffect.duration + existingEffect.startingTime > world.time + duration))
				existingEffect.startingTime = world.time
				existingEffect.duration = duration
			return TRUE

	createdEffect.startingTime = world.time
	createdEffect.duration = duration
	createdEffect.mobReference = WEAKREF(target)
	createdEffect.onStart()
	if(SSstatusEffects.affectedMobs[target])
		SSstatusEffects.affectedMobs[target] += createdEffect
	else
		SSstatusEffects.affectedMobs += target
		SSstatusEffects.affectedMobs[target] += createdEffect
	return TRUE

proc/removeStatusEffect(mob/target, effectType)
	if(!target || target.gc_destroyed)
		return 0
	if(!effectType)
		return 0
	if(SSstatusEffects.affectedMobs[target])
		for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[target])
			if(effect.identifier == effectType)
				// guarantees removal on next tick
				effect.duration = -1

proc/hasStatusEffect(mob/target, effectType)
	if(!target || target.gc_destroyed)
		return FALSE
	if(!effectType)
		return FALSE
	if(SSstatusEffects.affectedMobs[target])
		for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[target])
			if(effect.identifier == effectType)
				return TRUE
	return FALSE

proc/getStatusEffectDuration(mob/target, effectType)
	if(!target || target.gc_destroyed)
		return 0
	if(!effectType)
		return 0
	if(SSstatusEffects.affectedMobs[target])
		for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[target])
			return effect.duration + effect.startingTime - world.time
	return 0

// expect a list if its a unique effect
proc/getStatusEffect(mob/target, effectType)
	var/list/return_list = list()
	if(!target || target.gc_destroyed)
		return FALSE
	if(!effectType)
		return FALSE
	if(SSstatusEffects.affectedMobs[target])
		for(var/datum/statusEffect/effect as anything in SSstatusEffects.affectedMobs[target])
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
	var/datum/weakref/mobReference


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

/datum/statusEffect/weakened/onFinish()
	var/mob/owner =  mobReference.resolve()
	if(owner)
		owner.update_lying_buckled_and_verb_status()	//updates lying, canmove and icons

/datum/statusEffect/stunned
	identifier = SE_STUNNED

/datum/statusEffect/stunned/onFinish()
	var/mob/owner =  mobReference.resolve()
	if(owner)
		owner.update_icon()
/datum/statusEffect/paralyzed
	identifier = SE_PARALYZED



