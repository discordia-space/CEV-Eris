//Redefining some robot procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone/take_overall_damage(brute = 0, burn = 0, sharp = FALSE, used_weapon)
	bruteloss += brute
	fireloss += burn

/mob/living/silicon/robot/drone/heal_overall_damage(brute, burn)

	bruteloss -= brute
	fireloss -= burn

	if(bruteloss<0) bruteloss = 0
	if(fireloss<0) fireloss = 0

/mob/living/silicon/robot/drone/take_organ_damage(brute = 0, burn = 0, sharp = FALSE, emp = 0)
	take_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/heal_organ_damage(brute, burn)
	heal_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/getFireLoss()
	return fireloss

/mob/living/silicon/robot/drone/getBruteLoss()
	return bruteloss


/mob/living/silicon/robot/drone/get_fall_damage(turf/from, turf/dest)
	//Drones were instagibbing due to eris's screwed up mob sizes.
	//Design intent here: Drones are agile, rolly polly little machines that will fall very often.
	//Fall damage will be minor for them and generally nonlethal

	//Fall damage is capped at a third of their current health, so it can never kill
	return min(2, health * 0.3)


//On impact, drones will roll, with a little animation, and they will not be stunned like most other mobs
/mob/living/silicon/robot/drone/fall_impact(turf/from, turf/dest)
	take_overall_damage(get_fall_damage(from, dest))
	playsound(src, 'sound/weapons/slice.ogg', 100, 1, 10)
	visible_message(span_notice("[src] lands from above and rolls nimbly along the floor."), span_notice("You roll on impact, minimising damage!"))
	SpinAnimation(4, 2)
	updatehealth()
