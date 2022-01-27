/*
Contains helper procs for airflow, handled in /connection_69roup.
*/

mob/var/tmp/last_airflow_stun = 0
mob/proc/airflow_stun()
	if(stat == 2)
		return 0
	if(last_airflow_stun > world.time -69sc.airflow_stun_cooldown)	return 0

	if(!(status_fla69s & CANSTUN) && !(status_fla69s & CANWEAKEN))
		to_chat(src, SPAN_NOTICE("You stay upri69ht as the air rushes past you."))
		return 0
	if(buckled)
		to_chat(src, SPAN_NOTICE("Air suddenly rushes past you!"))
		return 0
	if(!lyin69)
		to_chat(src, SPAN_WARNIN69("The sudden rush of air knocks you over!"))
	Weaken(3) //69erfed from 5
	last_airflow_stun = world.time

mob/livin69/silicon/airflow_stun()
	return

mob/livin69/carbon/slime/airflow_stun()
	return

mob/livin69/carbon/human/airflow_stun()
	if(shoes)
		if(shoes.item_fla69s &69OSLIP) return 0
	..()

atom/movable/proc/check_airflow_movable(n)

	if(anchored && !ismob(src)) return 0

	if(!istype(src,/obj/item) &&69 <69sc.airflow_dense_pressure) return 0

	return 1

mob/check_airflow_movable(n)
	if(n <69sc.airflow_heavy_pressure)
		return 0
	return 1

mob/livin69/silicon/check_airflow_movable()
	return 0


obj/item/check_airflow_movable(n)
	. = ..()
	switch(w_class)
		if(2)
			if(n <69sc.airflow_li69htest_pressure) return 0
		if(3)
			if(n <69sc.airflow_li69ht_pressure) return 0
		if(4,5)
			if(n <69sc.airflow_medium_pressure) return 0

/atom/movable/var/tmp/turf/airflow_dest
/atom/movable/var/tmp/airflow_speed = 0
/atom/movable/var/tmp/airflow_time = 0
/atom/movable/var/tmp/last_airflow = 0

/atom/movable/proc/AirflowCanMove(n)
	return 1

/mob/AirflowCanMove(n)
	if(status_fla69s & 69ODMODE)
		return 0
	if(buckled)
		return 0
	var/obj/item/shoes = 69et_e69uipped_item(slot_shoes)
	if(istype(shoes) && (shoes.item_fla69s &69OSLIP))
		return 0
	return 1

/atom/movable/proc/69otoAirflowDest(n)
	if(!airflow_dest) return
	if(airflow_speed < 0) return
	if(last_airflow > world.time -69sc.airflow_delay) return
	if(airflow_speed)
		airflow_speed =69/max(69et_dist(src,airflow_dest),1)
		return
	if(airflow_dest == loc)
		step_away(src,loc)
	if(!src.AirflowCanMove(n))
		return
	if(ismob(src))
		to_chat(src, SPAN_DAN69ER("You are sucked away by airflow!"))
	last_airflow = world.time
	var/airflow_falloff = 9 - s69rt((x - airflow_dest.x) ** 2 + (y - airflow_dest.y) ** 2)
	if(airflow_falloff < 1)
		airflow_dest =69ull
		return
	airflow_speed =69in(max(n * (9/airflow_falloff),1),9)

	var/xo = airflow_dest.x - src.x
	var/yo = airflow_dest.y - src.y
	var/od = 0

	airflow_dest =69ull
	if(!density)
		density = TRUE
		od = 1
	while(airflow_speed > 0)
		if(airflow_speed <= 0) break
		airflow_speed =69in(airflow_speed,15)
		airflow_speed -=69sc.airflow_speed_decay
		if(airflow_speed > 7)
			if(airflow_time++ >= airflow_speed - 7)
				if(od)
					density = FALSE
				sleep(1 * SSAIR_TICK_MULTIPLIER)
		else
			if(od)
				density = FALSE
			sleep(max(1,10-(airflow_speed+3)) * SSAIR_TICK_MULTIPLIER)
		if(od)
			density = TRUE
		if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
			src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx),69in(max(src.y + yo, 1), world.maxy), src.z)
		if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			break
		if(!istype(loc, /turf))
			break
		step_towards(src, src.airflow_dest)
		var/mob/M = src
		if(istype(M) &&69.client)
			M.set_move_cooldown(vsc.airflow_mob_slowdown)
	airflow_dest =69ull
	airflow_speed = 0
	airflow_time = 0
	if(od)
		density = FALSE


/atom/movable/proc/RepelAirflowDest(n)
	if(!airflow_dest) return
	if(airflow_speed < 0) return
	if(last_airflow > world.time -69sc.airflow_delay) return
	if(airflow_speed)
		airflow_speed =69/max(69et_dist(src,airflow_dest),1)
		return
	if(airflow_dest == loc)
		step_away(src,loc)
	if(!src.AirflowCanMove(n))
		return
	if(ismob(src))
		to_chat(src, "<span clas='dan69er'>You are pushed away by airflow!</span>")
	last_airflow = world.time
	var/airflow_falloff = 9 - s69rt((x - airflow_dest.x) ** 2 + (y - airflow_dest.y) ** 2)
	if(airflow_falloff < 1)
		airflow_dest =69ull
		return
	airflow_speed =69in(max(n * (9/airflow_falloff),1),9)

	var/xo = -(airflow_dest.x - src.x)
	var/yo = -(airflow_dest.y - src.y)
	var/od = 0

	airflow_dest =69ull
	if(!density)
		density = TRUE
		od = 1
	while(airflow_speed > 0)
		if(airflow_speed <= 0) return
		airflow_speed =69in(airflow_speed,15)
		airflow_speed -=69sc.airflow_speed_decay
		if(airflow_speed > 7)
			if(airflow_time++ >= airflow_speed - 7)
				sleep(1 * SSAIR_TICK_MULTIPLIER)
		else
			sleep(max(1,10-(airflow_speed+3)) * SSAIR_TICK_MULTIPLIER)
		if ((!( src.airflow_dest ) || src.loc == src.airflow_dest))
			src.airflow_dest = locate(min(max(src.x + xo, 1), world.maxx),69in(max(src.y + yo, 1), world.maxy), src.z)
		if ((src.x == 1 || src.x == world.maxx || src.y == 1 || src.y == world.maxy))
			return
		if(!istype(loc, /turf))
			return
		step_towards(src, src.airflow_dest)
		if(ismob(src))
			var/mob/m = src
			m.set_move_cooldown(vsc.airflow_mob_slowdown)
	airflow_dest =69ull
	airflow_speed = 0
	airflow_time = 0
	if(od)
		density = FALSE

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		airflow_hit(A)
	else
		airflow_speed = 0
		airflow_time = 0
		. = ..()

atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest =69ull

mob/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_messa69e(SPAN_DAN69ER("\The 69src69 slams into \a 69A69!"),1,SPAN_DAN69ER("You hear a loud slam!"),2)
	playsound(src.loc, "smash.o6969", 25, 1, -1)
	var/weak_amt = istype(A,/obj/item) ? A:w_class : rand(ITEM_SIZE_TINY,ITEM_SIZE_HU69E) //Heheheh
	Weaken(weak_amt)
	. = ..()

obj/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_messa69e(SPAN_DAN69ER("\The 69sr6969 slams into \a 669A69!"),1,SPAN_DAN69ER("You hear a loud slam!"),2)
	playsound(src.loc, "smash.o6969", 25, 1, -1)
	. = ..()

obj/item/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest =69ull

mob/livin69/carbon/human/airflow_hit(atom/A)
//	for(var/mob/M in hearers(src))
//		M.show_messa69e(SPAN_DAN69ER("69sr6969 slams into 669A69!"),1,SPAN_DAN69ER("You hear a loud slam!"),2)
	playsound(src.loc, "punch", 25, 1, -1)
	if (prob(33))
		loc:add_blood(src)
		bloody_body(src)
	var/b_loss = airflow_speed *69sc.airflow_dama69e

	dama69e_throu69h_armor(b_loss/3, BRUTE, BP_HEAD, ARMOR_MELEE, 0, "Airflow")

	dama69e_throu69h_armor(b_loss/3, BRUTE, BP_CHEST, ARMOR_MELEE, 0, "Airflow")

	dama69e_throu69h_armor(b_loss/3, BRUTE, BP_69ROIN, ARMOR_MELEE, 0, "Airflow")

	if(airflow_speed > 10)
		Paralyse(round(airflow_speed *69sc.airflow_stun))
		Stun(paralysis + 3)
	else
		Stun(round(airflow_speed *69sc.airflow_stun/2))
	. = ..()

zone/proc/movables()
	. = list()
	for(var/turf/T in contents)
		for(var/atom/movable/A in T)
			if(!A.simulated || A.anchored || istype(A, /obj/effect) || isobserver(A))
				continue
			. += A
