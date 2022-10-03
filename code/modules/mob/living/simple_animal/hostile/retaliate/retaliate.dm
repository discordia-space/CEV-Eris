/mob/living/simple_animal/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple_animal/hostile/retaliate/Found(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			stance = HOSTILE_STANCE_ATTACK
			return L
		else
			enemies -= L

/mob/living/simple_animal/hostile/retaliate/ListTargets()
	if(!enemies.len)
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple_animal/hostile/retaliate/proc/Retaliate()
	var/list/around = getMobsInRangeChunked(src, 7, TRUE)
	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(M.faction != faction)
				enemies |= M

	for(var/mob/living/simple_animal/hostile/retaliate/H in around)
		if(H.faction == faction)
			H.enemies |= enemies
	return 0

/mob/living/simple_animal/hostile/retaliate/adjustBruteLoss(var/damage)
	..(damage)
	Retaliate()
