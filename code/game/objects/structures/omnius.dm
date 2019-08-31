/obj/structure/omnius
	name = "omnius generator"
	icon_state = "omnius"
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	var/cooldown = 0

	attack_hand(mob/living/user as mob)
		if(cooldown == 0)
			cooldown = 1
			emp_in(src.loc, 1, 1, 0)
			sleep(460)
			cooldown = 0

/obj/structure/omnius/proc/emp_in(turf/epicenter, heavy_range, light_range, log=0)
	for(var/mob/M in range(heavy_range, epicenter))
		M << 'sound/effects/EMPulse.ogg'

	for(var/atom/T in range(light_range, epicenter))
		#ifdef EMPDEBUG
		var/time = world.timeofday
		#endif
		var/distance = get_dist(epicenter, T)
		if(distance < heavy_range)
			T.emp_act(1)
		else if(distance == heavy_range)
			if(prob(50))
				T.emp_act(1)
			else
				T.emp_act(2)
		else if(distance <= light_range)
			T.emp_act(2)
		#ifdef EMPDEBUG
		if((world.timeofday - time) >= EMPDEBUG)
			log_and_message_admins("EMPDEBUG: [T.name] - [T.type] - took [world.timeofday - time]ds to process emp_act()!")
		#endif
	return 1

/obj/structure/omnius/emitter/proc/shoot()
	if(shooting == 0)
		shooting = 1
		while(cooldown < 80)
			cooldown++
			sleep(rand(1,2))
			var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/emitter( src.loc )
			A.damage = round(2000/DAMAGE_POWER_TRANSFER)
			A.launch( get_step(src.loc, pick(SOUTH, NORTH, WEST, EAST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)) )
		cooldown = 0
	shooting = 0

/obj/structure/omnius/emitter
	var/shooting = 0

	attack_hand(mob/living/user as mob)
		shoot()

/obj/structure/omnius/teleporter

	proc/teleport()
		for(var/mob/living/carbon/human/H in range(7, src))
			H.loc = locate(x + rand(-14, 14), y + rand(-14, 14), z)

	attack_hand(mob/living/user as mob)
		if(cooldown == 0)
			cooldown = 1
			teleport()
			sleep(660)
			cooldown = 0