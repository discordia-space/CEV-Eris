#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define69OVING_TO_TARGET 3
#define SPINNING_COCOON 4

//nursemaids - these create webs and eggs
/mob/living/carbon/superior_animal/giant_spider/nurse
	name = "Kouchiku Spider"
	desc = "A69assive tangleweb spider. It's abdomen takes up the69ajority of the creature's69ass. For a giant arachnid, this one seems especially fragile."
	icon_state = "nurse"
	icon_living = "nurse"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 3
	var/atom/cocoon_target
	poison_type = "aranecolmin"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/spider/nurse
	move_to_delay = 5
	meat_amount = 3
	rarity_value = 75
	var/fed = 0
	var/egg_inject_chance = 4

/mob/living/carbon/superior_animal/giant_spider/nurse/UnarmedAttack()
	..()
	if(ishuman(target_mob))
		var/mob/living/carbon/human/H = target_mob
		if(prob(egg_inject_chance))
			var/obj/item/organ/external/O = safepick(H.organs)
			if(O && !BP_IS_ROBOTIC(O))
				src.visible_message(SPAN_DANGER("69src69 injects something into the 69O69 of 69H69!"))
				var/obj/effect/spider/eggcluster/minor/S =69ew()
				S.loc = O
				O.implants += S


/mob/living/carbon/superior_animal/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(100)
		if(busy ==69OVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target =69ull
				busy = 0
				stop_automated_movement = 0

/mob/living/carbon/superior_animal/giant_spider/nurse/handle_ai()
	if(!..())
		return FALSE
	if(stance == HOSTILE_STANCE_IDLE)
		//30% chance to stop wandering and do something
		if(!busy && prob(30))
			//first, check for potential food69earby to cocoon
			var/list/cocoonTargets =69ew
			for(var/mob/living/C in getPotentialTargets())
				if(C.stat != CONSCIOUS)
					cocoonTargets += C

			cocoon_target = safepick(nearestObjectsInList(cocoonTargets,src,1))
			if (cocoon_target)
				busy =69OVING_TO_TARGET
				set_glide_size(DELAY2GLIDESIZE(move_to_delay))
				walk_to(src, cocoon_target, 1,69ove_to_delay)
				GiveUp(cocoon_target) //give up if we can't reach target
				return

				//second, spin a sticky spiderweb on this tile
			if(!(locate(/obj/effect/spider/stickyweb) in get_turf(src)))
				busy = SPINNING_WEB
				src.visible_message(SPAN_NOTICE("\The 69src69 begins to secrete a sticky substance."))
				stop_automated_movement = 1
				spawn(40)
					if(busy == SPINNING_WEB)
						if(!(locate(/obj/effect/spider/stickyweb) in get_turf(src)))
							new /obj/effect/spider/stickyweb(src.loc)
							update_openspace()
						busy = 0
						stop_automated_movement = 0
			else
				//third, lay an egg cluster there
				if((fed > 0) && !(locate(/obj/effect/spider/eggcluster) in get_turf(src)))
					busy = LAYING_EGGS
					src.visible_message(SPAN_NOTICE("\The 69src69 begins to lay a cluster of eggs."))
					stop_automated_movement = 1
					spawn(50)
						if(busy == LAYING_EGGS)
							if(!(locate(/obj/effect/spider/eggcluster) in get_turf(src)))
								new /obj/effect/spider/eggcluster(loc, src)
								fed--
								update_openspace()
							busy = 0
							stop_automated_movement = 0
				else
					//fourthly, cocoon any69earby items so those pesky pinkskins can't use them
					var/list/nearestObjects =69earestObjectsInList(getObjectsInView(),src,1)
					for(var/obj/O in69earestObjects)
						if(O.anchored)
							continue
						if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
							cocoonTargets += O

					cocoon_target = safepick(cocoonTargets)
					if (cocoon_target)
						busy =69OVING_TO_TARGET
						stop_automated_movement = 1
						set_glide_size(DELAY2GLIDESIZE(move_to_delay))
						walk_to(src, cocoon_target, 1,69ove_to_delay)
						GiveUp(cocoon_target) //give up if we can't reach target

		else if(busy ==69OVING_TO_TARGET && cocoon_target)
			if(get_dist(src, cocoon_target) <= 1)
				busy = SPINNING_COCOON
				src.visible_message(SPAN_NOTICE("\The 69src69 begins to secrete a sticky substance around \the 69cocoon_target69."))
				stop_automated_movement = 1
				walk(src,0)
				spawn(50)
					if(busy == SPINNING_COCOON)
						if(cocoon_target && istype(cocoon_target.loc, /turf) && get_dist(src,cocoon_target) <= 1)
							var/obj/effect/spider/cocoon/C = locate() in cocoon_target.loc
							var/large_cocoon
							var/turf/targetTurf = cocoon_target.loc

							for(var/obj/O in targetTurf)
								if (O.anchored)
									continue
								if (istype(O, /obj/item))
								else if (istype(O, /obj/structure) || istype(O, /obj/machinery))
									large_cocoon = 1
								else
									continue

								C = C ||69ew(targetTurf)
								O.forceMove(C)

							for(var/mob/living/M in targetTurf)
								if((M.stat == CONSCIOUS) || istype(M, /mob/living/carbon/superior_animal/giant_spider) || is_carrion(M))
									continue
								large_cocoon = 1

								if (istype(M, /mob/living/carbon/human))
									var/mob/living/carbon/human/H =69
									if (H.get_blood_volume() >= 1)
										src.visible_message(SPAN_WARNING("\The 69src69 sticks a proboscis into \the 69cocoon_target69 and sucks a69iscous substance out."))
										H.drip_blood(H.species.blood_volume)
										fed++

								C = C ||69ew(targetTurf)
								M.forceMove(C)
								break

							if (C)
								if(large_cocoon || C.is_large_cocoon)
									C.becomeLarge()
								C.update_openspace()

							cocoon_target =69ull

						busy = 0
						stop_automated_movement = 0



#undef SPINNING_WEB
#undef LAYING_EGGS
#undef69OVING_TO_TARGET
#undef SPINNING_COCOON
