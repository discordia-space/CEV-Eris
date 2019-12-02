#define BASE_ACCURACY_REGEN 0.75 //Recoil reduction per ds with 0 VIG
#define VIG_ACCURACY_REGEN  0.015 //Recoil reduction per ds per VIG
#define MIN_ACCURACY_REGEN  0.4 //How low can we get with negative VIG
#define MAX_ACCURACY_OFFSET  75 //It's both how big gun recoil can build up, and how hard you can miss

/mob/living/proc/handle_recoil(var/obj/item/weapon/gun/G)
	if(G.recoil_buildup)
		recoil += G.recoil_buildup
		update_recoil(G)


/mob/living/proc/calc_reduction()
	return max(BASE_ACCURACY_REGEN + stats.getStat(STAT_VIG)*VIG_ACCURACY_REGEN, MIN_ACCURACY_REGEN)

//Called to get current recoil value
/mob/living/proc/calc_recoil()
	if(!recoil || !last_recoil_update)
		return 0
	var/time = world.time - last_recoil_update
	if(time)
		//About the following code. This code is a mess, and we SHOULD NOT USE WORLD TIME FOR RECOIL
		var/timed_reduction = min(time**2, 400)
		recoil -= timed_reduction * calc_reduction()

		if(recoil <= 0)
			recoil = 0
			last_recoil_update = 0
		else
			last_recoil_update = world.time
	return recoil

//Called after setting recoil
/mob/living/proc/update_recoil(var/obj/item/weapon/gun/G)
	if(recoil <= 0)
		recoil = 0
		last_recoil_update = 0
	else
		if(last_recoil_update)
			calc_recoil()
		else
			last_recoil_update = world.time
	deltimer(recoil_timer)
	recoil_timer = null
	update_recoil_cursor(G)

/mob/living/proc/update_recoil_cursor(var/obj/item/weapon/gun/G)
	G.update_cursor(src)
	var/bottom = 0
	switch(recoil)
		if(0 to 10)
			;
		if(10 to 20)
			bottom = 10
		if(20 to 30)
			bottom = 20
		if(30 to 50)
			bottom = 30
		if(50 to MAX_ACCURACY_OFFSET)
			bottom = 50
		if(MAX_ACCURACY_OFFSET to INFINITY)
			bottom = MAX_ACCURACY_OFFSET
	if(bottom)
		var/reduction = calc_reduction()
		if(reduction > 0)
			recoil_timer = addtimer(CALLBACK(src, .proc/update_recoil_cursor, G), 1 + (recoil - bottom) / reduction)
