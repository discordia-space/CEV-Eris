#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

//basic spider mob, these generally guard nests
/mob/living/superior_animal/giant_spider
	name = "giant spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has deep red eyes."
	icon_state = "guard"
	speak_emote = list("chitters")
	emote_see = list("chitters", "rubs its legs")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat
	stop_automated_movement_when_pulled = 0
	maxHealth = 200
	health = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	var/poison_per_bite = 5
	var/poison_type = "toxin"
	faction = "spiders"
	var/busy = 0
	pass_flags = PASSTABLE
	move_to_delay = 6
	speed = 3

//nursemaids - these create webs and eggs
/mob/living/superior_animal/giant_spider/nurse
	desc = "Furry and black, it makes you shudder to look at it. This one has brilliant green eyes."
	icon_state = "nurse"
	maxHealth = 40
	health = 40
	melee_damage_lower = 5
	melee_damage_upper = 10
	poison_per_bite = 10
	var/atom/cocoon_target
	poison_type = "stoxin"
	var/fed = 0

//hunters have the most poison and move the fastest, so they can find prey
/mob/living/superior_animal/giant_spider/hunter
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon_state = "hunter"
	maxHealth = 120
	health = 120
	melee_damage_lower = 10
	melee_damage_upper = 20
	poison_per_bite = 5
	move_to_delay = 4

/mob/living/superior_animal/giant_spider/New(var/location, var/atom/parent)
	get_light_and_color(parent)
	..()

/mob/living/superior_animal/giant_spider/attemptAttackOnTarget()
	var/target = ..()
	if (target)
		playsound(src, 'sound/weapons/spiderlunge.ogg', 30, 1, -3)
	if(isliving(target))
		var/mob/living/L = target
		if(L && L.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/superior_animal/giant_spider/nurse/attemptAttackOnTarget()
	var/target = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(prob(poison_per_bite))
			var/obj/item/organ/external/O = safepick(H.organs)
			if(O && !(O.robotic >= ORGAN_ROBOT))
				var/eggs = new /obj/effect/spider/eggcluster(O, src)
				O.implants += eggs

/mob/living/superior_animal/giant_spider/Life()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			//1% chance to skitter madly away
			if(!busy && prob(1))
				/*var/list/move_targets = list()
				for(var/turf/T in orange(20, src))
					move_targets.Add(T)*/
				stop_automated_movement = 1
				walk_to(src, pick(orange(20, src)), 1, move_to_delay)
				spawn(50)
					stop_automated_movement = 0
					walk(src,0)

/mob/living/superior_animal/giant_spider/nurse/proc/GiveUp(var/C)
	spawn(100)
		if(busy == MOVING_TO_TARGET)
			if(cocoon_target == C && get_dist(src,cocoon_target) > 1)
				cocoon_target = null
				busy = 0
				stop_automated_movement = 0

/mob/living/superior_animal/giant_spider/nurse/Life()
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_IDLE)
			//30% chance to stop wandering and do something
			if(!busy && prob(30))
				//first, check for potential food nearby to cocoon
				var/list/cocoonTargets = new
				for(var/mob/living/C in getObjectsInView())
					if(C.stat != CONSCIOUS)
						cocoonTargets += C

				cocoon_target = safepick(nearestObjectsInList(cocoonTargets,src,1))
				if (cocoon_target)
					busy = MOVING_TO_TARGET
					walk_to(src, cocoon_target, 1, move_to_delay)
					GiveUp(cocoon_target) //give up if we can't reach target
					return

				//second, spin a sticky spiderweb on this tile
				if(!(locate(/obj/effect/spider/stickyweb) in get_turf(src)))
					busy = SPINNING_WEB
					src.visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance."))
					stop_automated_movement = 1
					spawn(40)
						if(busy == SPINNING_WEB)
							if(!(locate(/obj/effect/spider/stickyweb) in get_turf(src)))
								new /obj/effect/spider/stickyweb(src.loc)
							busy = 0
							stop_automated_movement = 0
				else
					//third, lay an egg cluster there
					if((fed > 0) && !(locate(/obj/effect/spider/eggcluster) in get_turf(src)))
						busy = LAYING_EGGS
						src.visible_message(SPAN_NOTICE("\The [src] begins to lay a cluster of eggs."))
						stop_automated_movement = 1
						spawn(50)
							if(busy == LAYING_EGGS)
								if(!(locate(/obj/effect/spider/eggcluster) in get_turf(src)))
									new /obj/effect/spider/eggcluster(loc, src)
									fed--
								busy = 0
								stop_automated_movement = 0
					else
						//fourthly, cocoon any nearby items so those pesky pinkskins can't use them
						var/list/nearestObjects = nearestObjectsInList(getObjectsInView(),src,1)
						for(var/obj/O in nearestObjects)
							if(O.anchored)
								continue
							if(istype(O, /obj/item) || istype(O, /obj/structure) || istype(O, /obj/machinery))
								cocoonTargets += O

						cocoon_target = safepick(cocoonTargets)
						if (cocoon_target)
							busy = MOVING_TO_TARGET
							stop_automated_movement = 1
							walk_to(src, cocoon_target, 1, move_to_delay)
							GiveUp(cocoon_target) //give up if we can't reach target

			else if(busy == MOVING_TO_TARGET && cocoon_target)
				if(get_dist(src, cocoon_target) <= 1)
					busy = SPINNING_COCOON
					src.visible_message(SPAN_NOTICE("\The [src] begins to secrete a sticky substance around \the [cocoon_target]."))
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

									C = C || new(targetTurf)
									O.loc = C

								for(var/mob/living/M in targetTurf)
									if((M.stat == CONSCIOUS) || istype(M, /mob/living/superior_animal/giant_spider))
										continue
									large_cocoon = 1

									if ((M.getBruteLoss() < 150) && istype(M, /mob/living/carbon))
										src.visible_message(SPAN_WARNING("\The [src] sticks a proboscis into \the [cocoon_target] and sucks a viscous substance out."))
										M.adjustBruteLoss(100)
										fed++

									C = C || new(targetTurf)
									M.loc = C
									break

								if(C && (large_cocoon || C.is_large_cocoon))
									C.becomeLarge()
								cocoon_target = null

							busy = 0
							stop_automated_movement = 0

		else
			busy = 0
			stop_automated_movement = 0

#undef SPINNING_WEB
#undef LAYING_EGGS
#undef MOVING_TO_TARGET
#undef SPINNING_COCOON
