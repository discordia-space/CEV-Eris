#define I_SINGULO "singulo"

/atom/proc/singularity_act()
	return

/atom/proc/singularity_pull()
	return

/mob/living/singularity_act()
	investigate_log("has been consumed by a singularity", I_SINGULO)
	gib()
	return 20

/mob/living/singularity_pull(S)
	step_towards(src, S)

/mob/living/carbon/human/singularity_pull(S, current_size)
	if(current_size >= STAGE_THREE)
		var/list/handlist = list(l_hand, r_hand)
		for(var/obj/item/hand in handlist)
			if(prob(current_size*5) && hand.w_class >= ((11-current_size)/2) && u_equip(hand))
				step_towards(hand, src)
				to_chat(src, "<span class = 'warning'>The 69S69 yanks \the 69hand69 from your grip!</span>")
	apply_effect(current_size * 3, IRRADIATE)
	if(shoes)
		if(shoes.item_flags &69OSLIP) return 0
	..()

/obj/singularity_act()
	if(simulated)
		ex_act(1)
		if(src)
			qdel(src)
		return 2

/obj/singularity_pull(S, current_size)
	if(simulated && !anchored)
		step_towards(src, S)

/obj/effect/beam/singularity_pull()
	return

/obj/effect/overlay/singularity_pull()
	return

/obj/item/singularity_pull(S, current_size)
	set waitfor = 0
	if(anchored)
		return
	sleep(0) //this is69eeded or69ultiple items will be thrown sequentially and69ot simultaneously
	if(current_size >= STAGE_FOUR)
		//throw_at(S, 14, 3)
		step_towards(src,S)
		sleep(1)
		step_towards(src,S)
	else if(current_size > STAGE_ONE)
		step_towards(src,S)
	else ..()

/obj/machinery/atmospherics/pipe/singularity_pull()
	return

/obj/machinery/power/supermatter/shard/singularity_act()
	src.loc =69ull
	qdel(src)
	return 5000

/obj/machinery/power/supermatter/singularity_act()
	if(!src.loc)
		return

	var/prints = ""
	if(src.fingerprintshidden)
		prints = ", all touchers : " + src.fingerprintshidden

	SetUniversalState(/datum/universal_state/supermatter_cascade)
	log_admin("New super singularity69ade by eating a SM crystal 69prints69. Last touched by 69src.fingerprintslast69.")
	message_admins("New super singularity69ade by eating a SM crystal 69prints69. Last touched by 69src.fingerprintslast69.")
	src.loc =69ull
	qdel(src)
	return 50000

/obj/item/projectile/beam/emitter/singularity_pull()
	return

/obj/item/storage/backpack/holding/singularity_act(S, current_size)
	var/dist =69ax((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/obj/item/storage/pouch/holding/singularity_act(S, current_size)
	var/dist =69ax((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/obj/item/storage/belt/holding/singularity_act(S, current_size)
	var/dist =69ax((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/obj/item/storage/bag/trash/singularity_act(S, current_size)
	var/dist =69ax((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/obj/item/storage/bag/ore/holding/singularity_act(S, current_size)
	var/dist =69ax((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/turf/singularity_act(S, current_size)
	if(!is_plating())
		for(var/obj/O in contents)
			if(O.level != 1)
				continue
			if(O.invisibility == 101)
				O.singularity_act(src, current_size)
	ChangeTurf(get_base_turf_by_area(src))
	return 2

/turf/space/singularity_act()
	return

/*******************
*69ar-Sie Act/Pull *
*******************/
/atom/proc/singuloCanEat()
	return 1

/mob/observer/singuloCanEat()
	return 0

/mob/new_player/singuloCanEat()
	return 0
