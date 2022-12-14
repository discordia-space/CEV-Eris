
GLOBAL_LIST_EMPTY_TYPED(globalEffects, /datum/statusEffect)
SUBSYSTEM_DEF(statusEffects)
	name = "Status effects"
	flags = SS_TICKER
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 1
	var/list/mob/affectedMobs = list()

/datum/controller/subsystem/statusEffects/init()
	for(var/effect in subtypesof(/datum/statusEffect))
		globalEffects[effect.identifier] = effect

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
				effect.OnFinish()
				qdel(effect)
				if(!length(affectedMobs[affectedMob]))
					affectedMobs -= affectedMob
				continue
			statusEffect.doEffect()

proc/addStatusEffect(mob/target, effectType, duration)
	if(!target || target.gc_destroyed)
		return FALSE
	// Not bad per say , but we shouldn't be using this subsystem for this scenario
	if(duration < 1)
		CRASH("Attempt to create statusEffect with a duration below 1 : [duration]")
		return FALSE
	if(!globalEffects[effectType])
		CRASH("Invalid effectType received : [effectType]")
		return FALSE
	var/datum/statusEffect/createdEffect = new globalEffects[effectType]
	createdEffect.startingTime = world.time
	createdEffect.duration = duration
	if(SSstatusEffects.affectedMobs[target])
		SSstatusEffects.affectedMobs[target] += createdEffect
	else
		SSstatusEffects.affectedMobs += target
		SSstatusEffects.affectedMobs[target] += createdEffect

/datum/statusEffect
	// A identifying tag, always a define
	var/identifier
	// Starting world time
	var/startingTime
	// Duration in ms added ontop of startng time
	var/duration
	// Mob reference , a weak one to not prevent deletions
	var/datum/weakref/mobReference

/datum/statusEffect/proc/doEffect()
	return TRUE

/datum/statusEffect/proc/OnFinish()
	qdel(src)

/datum/statusEffect/proc/OnStart()


