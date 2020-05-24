#define MOVING_TO_TARGET 1
#define EATING_TARGET 2

/mob/living/carbon/superior_animal/roach/proc/GiveUp(var/C)
	spawn(100)
		if(busy == MOVING_TO_TARGET)
			if(eat_target == C && get_dist(src,eat_target) > 1)
				eat_target = null
				busy = 0
				stop_automated_movement = 0

/mob/living/carbon/superior_animal/roach/Life()
	. = ..()
	if(!stat) // if is conscious
		if(stance == HOSTILE_STANCE_IDLE)
			//30% chance to stop wandering and do something
			if(!busy && prob(30))
				//first, check for potential food nearby
				var/list/eatTargets = new
				for(var/mob/living/C in getObjectsInView())
					if(C.stat != CONSCIOUS)
						eatTargets += C
				
				eat_target = safepick(nearestObjectsInList(eatTargets,src,1))
				if (eat_target)
					busy = MOVING_TO_TARGET
					set_glide_size(DELAY2GLIDESIZE(move_to_delay))
					walk_to(src, eat_target, 1, move_to_delay)
					GiveUp(eat_target) //give up if we can't reach target
					return

			else if(busy == MOVING_TO_TARGET && eat_target)
				if(get_dist(src, eat_target) <= 1)
					busy = EATING_TARGET
					stop_automated_movement = 1
					src.visible_message(SPAN_NOTICE("\The [src] begins to eat \the [eat_target]."))
					walk(src,0)
					spawn(250)
						if(busy == EATING_TARGET)
							if(eat_target && istype(eat_target.loc, /turf) && get_dist(src,eat_target) <= 1)
								var/turf/targetTurf = eat_target.loc

								for(var/mob/living/M in targetTurf)
									if((M.stat == CONSCIOUS)) // Don't try to eat someone that is alive
										continue

									if (istype(M, /mob/living/carbon/human)) // Eat only humans
										var/mob/living/carbon/human/H = M
										
										// Process Cruciform
										var/obj/item/weapon/implant/core_implant/cruciform/CI = H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform, FALSE)
										if (CI)
											var/mob/N = CI.wearer
											CI.name = "[N]'s Cruciform"
											CI.uninstall()

										// Gib victim but remove non synthetic organs
										H.gib(max_range=1, keep_only_robotics=TRUE)

										// Spawn human remains
										var/remainsType = /obj/item/remains/human
										new remainsType(targetTurf)

										// Hide the remaining part of the corpse (all flesh parts are not gibbed)
										H.canmove = 0
										H.icon = null
										H.invisibility = 101

										// End message
										src.visible_message(SPAN_WARNING("\The [src] finishes eating \the [eat_target], leaving only bones."))

									break

								eat_target = null

							busy = 0
							stop_automated_movement = 0
		else
			busy = 0
			stop_automated_movement = 0

#undef MOVING_TO_TARGET
#undef EATING_TARGET