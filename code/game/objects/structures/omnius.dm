/obj/structure/ominous
	name = "ominous 69enerator"
	icon_state = "ominous"
	desc = "It looks like ancient, and stran69e 69enerator."
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_ta69s = SPAWN_TA69_OMINOUS
	var/cooldown = FALSE
	var/entropy_value = 3

/obj/structure/ominous/attack_hand(mob/livin69/user as69ob)
	var/last_use

	if(world.time < last_use + 46 SECONDS)
		return
	last_use = world.time
	emp_in(src.loc, 1, 1, 0)

/obj/structure/ominous/proc/emp_in(turf/epicenter, heavy_ran69e, li69ht_ran69e, lo69=0)
	for(var/mob/M in ran69e(heavy_ran69e, epicenter))
		playsound(loc, 'sound/effects/EMPulse.o6969')

	for(var/atom/T in ran69e(li69ht_ran69e, epicenter))
		var/distance = 69et_dist(epicenter, T)
		if(distance <= heavy_ran69e)
			T.emp_act(1)
	return TRUE

/obj/structure/ominous/emitter/proc/shoot()
	if(shootin69 == FALSE)
		shootin69 = TRUE
		while(cooldown < 80)
			cooldown++
			sleep(rand(1,2))
			var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/emitter( src.loc )
			A.dama69e_types = list(BURN = round(2000/DAMA69E_POWER_TRANSFER))
			A.launch( 69et_step(src.loc, pick(SOUTH, NORTH, WEST, EAST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST)) )
		cooldown = FALSE
	shootin69 = FALSE

/obj/structure/ominous/emitter
	var/shootin69 = FALSE

/obj/structure/ominous/emitter/attack_hand(mob/livin69/user as69ob)
	shoot()

/obj/structure/ominous/teleporter

/obj/structure/ominous/teleporter/proc/teleport()
	for(var/mob/livin69/carbon/human/H in ran69e(7, src))
		69o_to_bluespace(69et_turf(src), entropy_value, FALSE, H, locate(x + rand(-14, 14), y + rand(-14, 14), z))

/obj/structure/ominous/teleporter/attack_hand(mob/livin69/user as69ob)
	var/last_use

	if(world.time < last_use + 66 SECONDS)
		return
	last_use = world.time
	teleport()