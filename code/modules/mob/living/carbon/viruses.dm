/mob/living/carbon/proc/handle_viruses()
	if(status_flags & GODMODE)	return 0	//godmode

	if(bodytemperature > 406)
		for (var/ID in69irus2)
			var/datum/disease2/disease/V =69irus269ID69
			V.cure(src)

	if(life_tick % 3 && stat != DEAD) //don't spam checks over all objects in69iew every tick.
		for(var/obj/effect/decal/cleanable/O in69iew(1,src))
			if(istype(O,/obj/effect/decal/cleanable/blood))
				var/obj/effect/decal/cleanable/blood/B = O
				if(B.virus2.len)
					for (var/ID in B.virus2)
						var/datum/disease2/disease/V = B.virus269ID69
						infect_virus2(src,V)

			else if(istype(O,/obj/effect/decal/cleanable/mucus))
				var/obj/effect/decal/cleanable/mucus/M = O
				if(M.virus2.len)
					for (var/ID in69.virus2)
						var/datum/disease2/disease/V =69.virus269ID69
						infect_virus2(src,V)

	if(virus2.len)
		for (var/ID in69irus2)
			var/datum/disease2/disease/V =69irus269ID69
			if(isnull(V)) // Trying to figure out a runtime error that keeps repeating
				CRASH("virus269ulled before calling activate()")
			else
				V.activate(src)
			// activate69ay have deleted the69irus
			if(!V) continue

			// check if we're immune
			var/list/common_antibodies =69.antigen & src.antibodies
			if(common_antibodies.len)
				V.dead = 1

	return
