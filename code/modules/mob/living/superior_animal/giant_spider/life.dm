/mob/living/carbon/superior_animal/giant_spider/Life()
	. = ..()
	if(stat == CONSCIOUS)
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