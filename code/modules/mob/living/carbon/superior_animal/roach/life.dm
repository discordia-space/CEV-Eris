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
					src.visible_message(SPAN_NOTICE("\The [src] begins to eat \the [eat_target]."))
					walk(src,0)
					src.stop_automated_movement = 1
					spawn(250)
						if(busy == EATING_TARGET)
							if(eat_target && istype(eat_target.loc, /turf) && get_dist(src,eat_target) <= 1)
								var/turf/targetTurf = eat_target.loc

								for(var/mob/living/M in targetTurf)
									if((M.stat == CONSCIOUS))
										continue

									if (istype(M, /mob/living/carbon/human))
										var/mob/living/carbon/human/H = M
										
										// Process Cruciform
										var/obj/item/weapon/implant/core_implant/cruciform/CI = H.get_core_implant(/obj/item/weapon/implant/core_implant/cruciform, FALSE)
										if (CI)
											var/mob/N = CI.wearer
											CI.name = "[N]'s Cruciform"
											CI.uninstall()

										// Gib victim but remove non synthetic organs
										H.gib(keep_only_robotics=TRUE)

										/*var/on_turf = istype(H.loc, /turf)

										for(var/obj/item/organ/I in H.internal_organs)
											if (I.nature == MODIFICATION_SILICON) //(BP_IS_ROBOTIC(I))
												src.visible_message(SPAN_WARNING("Synth internal detected"))
												I.removed()
												if(on_turf)
													I.throw_at(get_edge_target_turf(H,pick(alldirs)),rand(1,3),30)

										for(var/obj/item/organ/external/E in H.organs)
											if (E.nature == MODIFICATION_SILICON)//(BP_IS_ROBOTIC(E))
												src.visible_message(SPAN_WARNING("Synth external detected"))
												E.droplimb(TRUE, DROPLIMB_EDGE, 1)
												if(on_turf)
													E.throw_at(get_edge_target_turf(H,pick(alldirs)),rand(1,3),30)

										sleep(1)

										src.visible_message(SPAN_WARNING("Pass 4"))
										for(var/obj/item/D in H)
											if (!istype(D, /obj/item/organ))
												drop_from_inventory(D)*/

											//I.throw_at(get_edge_target_turf(H,pick(alldirs)), rand(1,3), round(30/I.w_class))

										/*H.canmove = 0
										H.icon = null
										H.invisibility = 101*/

										// gibs(H.loc, H.dna, null, H.species.flesh_color, H.species.blood_color)

										/*gibs(H.loc, H.dna, null, H.species.flesh_color, H.species.blood_color)

										death(1)
										if (istype(H.loc, /obj/item/weapon/holder))
											var/obj/item/weapon/holder/L = loc
											L.release_mob()*/

										/*var/atom/movable/overlay/animation = null
										transforming = TRUE
										ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
										canmove = 0
										icon = null
										invisibility = 101

										animation = new(loc)
										animation.icon_state = "blank"
										animation.icon = iconfile
										animation.master = src

										flick(anim, animation)
										new remains(loc)*/



										//remove_from_dead_mob_list()

										//H.remove_from_dead_mob_list()
										//qdel(H)
										//H.dust()

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