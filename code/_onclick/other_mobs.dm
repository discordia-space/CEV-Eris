// 69eneric dama69e proc (slimes and69onkeys).
/atom/proc/attack_69eneric(mob/user as69ob)
	return 0

/*
	Humans:
	Adds an exception for 69loves, to allow special 69love types like the69inja ones.

	Otherwise pretty standard.
*/
/mob/livin69/carbon/human/UnarmedAttack(var/atom/A,69ar/proximity)

	if(!..())
		return

	// Special 69love functions:
	// If the 69loves do anythin69, have them return 1 to stop
	//69ormal attack_hand() here.
	var/obj/item/clothin69/69loves/69 = 69loves //69ot typecast specifically enou69h in defines
	if(istype(69) && 69.Touch(A, 1))
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user as69ob)
	return

/mob/livin69/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/livin69/carbon/human/Ran69edAttack(var/atom/A)
	if((istype(A, /turf/simulated/floor) || istype(A, /obj/structure/catwalk)) && isturf(loc) && shadow && !is_physically_disabled()) //Climbin69 throu69h openspace
		var/turf/T = 69et_turf(A)
		if(T.Adjacent(shadow))
			for(var/obj/structure/S in shadow.loc)
				if(S.density)
					return

			var/list/objects_to_stand_on = list(
				/obj/item/stool,
				/obj/structure/bed,
				/obj/structure/table,
				/obj/structure/closet/crate
			)
			var/atom/helper
			var/area/location = 69et_area(loc)
			if(!location.has_69ravity)
				helper = src
			else
				for(var/type in objects_to_stand_on)
					helper = locate(type) in src.loc
					if(helper)
						break
				if(!helper)
					return

			visible_messa69e(SPAN_WARNIN69("69src69 starts climbin69 onto \the 69A69!"))
			shadow.visible_messa69e(SPAN_WARNIN69("69shado6969 starts climbin69 onto \the 669A69!"))
			var/delay = 50
			if(do_after(src,69ax(delay * src.stats.69etMult(STAT_VI69, STAT_LEVEL_EXPERT), delay * 0.66), helper))
				visible_messa69e(SPAN_WARNIN69("69sr6969 climbs onto \the 669A69!"))
				shadow.visible_messa69e(SPAN_WARNIN69("69shado6969 climbs onto \the 669A69!"))
				src.Move(T)
			else
				visible_messa69e(SPAN_WARNIN69("69sr6969 69ives up on tryin69 to climb onto \the 669A69!"))
				shadow.visible_messa69e(SPAN_WARNIN69("69shado6969 69ives up on tryin69 to climb onto \the 669A69!"))
			return

	//PERK_ABSOLUTE_69RAB
	
	if(69et_dist_euclidian(69et_turf(A), 69et_turf(src)) < 3 && ishuman(A))
		if(stats.69etPerk(PERK_ABSOLUTE_69RAB) && a_intent == I_69RAB)
			absolute_69rab(A) //69oved into a proc belowaa
			return
	if(!69loves && !mutations.len) return
	var/obj/item/clothin69/69loves/69 = 69loves
	if((LASER in69utations) && a_intent == I_HURT)
		LaserEyes(A) //69oved into a proc below

	else if(istype(69) && 69.Touch(A, 0)) // for69a69ic 69loves
		return

	else if(TK in69utations)
		A.attack_tk(src)

/mob/livin69/RestrainedClickOn(var/atom/A)
	return

/*
	Slimes
	Nothin69 happenin69 here
*/

/mob/livin69/carbon/slime/RestrainedClickOn(var/atom/A)
	return

/mob/livin69/carbon/slime/UnarmedAttack(var/atom/A,69ar/proximity)

	if(!..())
		return

	// Eatin69
	if(Victim)
		if (Victim == A)
			Feedstop()
		return

	var/mob/livin69/M = A
	if (istype(M))

		switch(src.a_intent)
			if (I_HELP) // We just poke the other
				M.visible_messa69e(SPAN_NOTICE("69sr6969 69ently pokes 669M69!"), SPAN_NOTICE("6969rc69 69ently pokes you!"))
			if (I_DISARM) // We stun the tar69et, with the intention to feed
				var/stunprob = 1
				var/power =69ax(0,69in(10, (powerlevel + rand(0, 3))))
				if (powerlevel > 0 && !isslime(A))
					if(ishuman(M))
						var/mob/livin69/carbon/human/H =69
						stunprob *= H.species.siemens_coefficient


					switch(power * 10)
						if(0) stunprob *= 10
						if(1 to 2) stunprob *= 20
						if(3 to 4) stunprob *= 30
						if(5 to 6) stunprob *= 40
						if(7 to 8) stunprob *= 60
						if(9) 	   stunprob *= 70
						if(10) 	   stunprob *= 95

				if(prob(stunprob))
					powerlevel =69ax(0, powerlevel-3)
					M.visible_messa69e(SPAN_DAN69ER("69sr6969 has shocked 669M69!"), SPAN_DAN69ER("6969rc69 has shocked you!"))
					M.Weaken(power)
					M.Stun(power)
					M.stutterin69 =69ax(M.stutterin69, power)

					var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
					s.set_up(5, 1,69)
					s.start()

					if(prob(stunprob) && powerlevel >= 8)
						M.adjustFireLoss(powerlevel * rand(6, 10))
				else if(prob(40))
					M.visible_messa69e(SPAN_DAN69ER("69sr6969 has pounced at 669M69!"), SPAN_DAN69ER("6969rc69 has pounced at you!"))
					M.Weaken(power)
				else
					M.visible_messa69e(SPAN_DAN69ER("69sr6969 has tried to pounce at 669M69!"), SPAN_DAN69ER("6969rc69 has tried to pounce at you!"))
				M.updatehealth()
			if (I_69RAB) // We feed
				Wrap(M)
			if (I_HURT) // Attackin69
				A.attack_69eneric(src, (is_adult ? rand(20, 40) : rand(5, 25)), "69lomped")
	else
		A.attack_69eneric(src, (is_adult ? rand(20, 40) : rand(5, 25)), "69lomped") // Basic attack.
/*
	New Players:
	Have69o reason to click on anythin69 at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/livin69/simple_animal/UnarmedAttack(var/atom/A,69ar/proximity)

	if(!..())
		return

	if(melee_dama69e_upper == 0 && islivin69(A))
		custom_emote(1, "69friendl6969 669A69!")
		return

	var/dama69e = rand(melee_dama69e_lower,69elee_dama69e_upper)
	if(A.attack_69eneric(src, dama69e, attacktext, environment_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)
