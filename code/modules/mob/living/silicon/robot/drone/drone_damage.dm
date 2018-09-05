//Redefining some robot procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/used_weapon = null)
	bruteloss += brute
	fireloss += burn

/mob/living/silicon/robot/drone/heal_overall_damage(var/brute, var/burn)

	bruteloss -= brute
	fireloss -= burn

	if(bruteloss<0) bruteloss = 0
	if(fireloss<0) fireloss = 0

/mob/living/silicon/robot/drone/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/emp = 0)
	take_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/heal_organ_damage(var/brute, var/burn)
	heal_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/getFireLoss()
	return fireloss

/mob/living/silicon/robot/drone/getBruteLoss()
	return bruteloss


/mob/living/silicon/robot/drone/get_fall_damage(var/turf/from, var/turf/dest)
	//Drones were instagibbing due to eris's screwed up mob sizes.
	//Design intent here: Drones are agile, rolly polly little machines that will fall very often.
	//Fall damage will be minor for them and generally nonlethal

	//Fall damage is capped at a third of their current health, so it can never kill
	return min(2, health * 0.3)


//On impact, drones will roll, with a little animation, and they will not be stunned like most other mobs
/mob/living/silicon/robot/drone/fall_impact(var/turf/from, var/turf/dest)
	take_overall_damage(get_fall_damage(from, dest))
	playsound(src, 'sound/weapons/slice.ogg', 100, 1, 10)
	visible_message(SPAN_NOTICE("[src] lands from above and rolls nimbly along the floor."), SPAN_NOTICE("You roll on impact, minimising damage!"))
	SpinAnimation(4, 2)
	updatehealth()