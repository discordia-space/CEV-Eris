//Redefining some robot procs, since drones can't be repaired and really shouldn't take component damage.
/mob/living/silicon/robot/drone/take_overall_damage(var/brute = 0,69ar/burn = 0,69ar/sharp = FALSE,69ar/used_weapon)
	bruteloss += brute
	fireloss += burn

/mob/living/silicon/robot/drone/heal_overall_damage(var/brute,69ar/burn)

	bruteloss -= brute
	fireloss -= burn

	if(bruteloss<0) bruteloss = 0
	if(fireloss<0) fireloss = 0

/mob/living/silicon/robot/drone/take_organ_damage(var/brute = 0,69ar/burn = 0,69ar/sharp = FALSE,69ar/emp = 0)
	take_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/heal_organ_damage(var/brute,69ar/burn)
	heal_overall_damage(brute,burn)

/mob/living/silicon/robot/drone/getFireLoss()
	return fireloss

/mob/living/silicon/robot/drone/getBruteLoss()
	return bruteloss


/mob/living/silicon/robot/drone/get_fall_damage(var/turf/from,69ar/turf/dest)
	//Drones were instagibbing due to eris's screwed up69ob sizes.
	//Design intent here: Drones are agile, rolly polly little69achines that will fall69ery often.
	//Fall damage will be69inor for them and generally69onlethal

	//Fall damage is capped at a third of their current health, so it can69ever kill
	return69in(2, health * 0.3)


//On impact, drones will roll, with a little animation, and they will69ot be stunned like69ost other69obs
/mob/living/silicon/robot/drone/fall_impact(var/turf/from,69ar/turf/dest)
	take_overall_damage(get_fall_damage(from, dest))
	playsound(src, 'sound/weapons/slice.ogg', 100, 1, 10)
	visible_message(SPAN_NOTICE("69src69 lands from above and rolls69imbly along the floor."), SPAN_NOTICE("You roll on impact,69inimising damage!"))
	SpinAnimation(4, 2)
	updatehealth()