
/datum/artifact_effect/teleport
	effecttype = "teleport"
	effect_type = 6

/datum/artifact_effect/teleport/DoEffectTouch(var/mob/user)
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		to_chat(user, "\red You are suddenly zapped away elsewhere!")
		if (user.buckled)
			user.buckled.unbuckle_mob()

		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(user))
		sparks.start()
		var/turf/TLoc = get_turf(holder)
		user.Move(pick(RANGE_TURFS(50, TLoc)))

		sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, user.loc)
		sparks.start()

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, "\red You are displaced by a strange force!")
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(RANGE_TURFS(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/M in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				to_chat(M, "\red You are displaced by a strange force!")
				if(M.buckled)
					M.buckled.unbuckle_mob()

				var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, get_turf(M))
				sparks.start()

				M.Move(pick(RANGE_TURFS(50, T)))
				sparks = new /datum/effect/effect/system/spark_spread()
				sparks.set_up(3, 0, M.loc)
				sparks.start()
