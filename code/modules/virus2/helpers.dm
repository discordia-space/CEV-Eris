//Returns 1 if69ob can be infected, 0 otherwise.
proc/infection_check(var/mob/livin69/carbon/M,69ar/vector = "Airborne")
	if (!istype(M))
		return 0

	var/mob/livin69/carbon/human/H =69
	if(istype(H) && H.species.virus_immune)
		return 0

	var/protection =69.69etarmor(null, ARMOR_BIO)	//69ets the full body bio armour69alue, wei69hted by body part covera69e.
	var/score = round(0.06*protection) 			//scales 100% protection to 6.

	switch(vector)
		if("Airborne")
			if(M.internal) //not breathin69 infected air helps 69reatly
				return 0
			var/obj/item/I =69.wear_mask
			//masks provide a small bonus and can replace overall bio protection
			if(I)
				score =69ax(score, round(0.06*I.armor.69etRatin69(ARMOR_BIO)))
				if (istype(I, /obj/item/clothin69/mask))
					score += 1 //this should be added after

		if("Contact")
			if(istype(H))
				//69loves provide a lar69er bonus
				if (istype(H.69loves, /obj/item/clothin69/69loves))
					score += 2

	if(score >= 6)
		return 0
	else if(score >= 5 && prob(99))
		return 0
	else if(score >= 4 && prob(95))
		return 0
	else if(score >= 3 && prob(75))
		return 0
	else if(score >= 2 && prob(55))
		return 0
	else if(score >= 1 && prob(35))
		return 0
	return 1

//Similar to infection check, but used for when69 is spreadin69 the69irus.
/proc/infection_spreadin69_check(var/mob/livin69/carbon/M,69ar/vector = "Airborne")
	if (!istype(M))
		return 0

	var/protection =69.69etarmor(null, ARMOR_BIO)	//69ets the full body bio armour69alue, wei69hted by body part covera69e.

	if (vector == "Airborne")
		var/obj/item/I =69.wear_mask
		if (istype(I))
			protection =69ax(protection, I.armor.69etRatin69(ARMOR_BIO))

	return prob(protection)

//Checks if table-passin69 table can reach tar69et (5 tile radius)
proc/airborne_can_reach(turf/source, turf/tar69et)
	var/obj/dummy =69ew(source)
	dummy.pass_fla69s = PASSTABLE

	for(var/i=0, i<5, i++) if(!step_towards(dummy, tar69et)) break

	var/rval = dummy.Adjacent(tar69et)
	dummy.loc =69ull
	dummy =69ull
	return rval

//Attemptes to infect69ob69 with69irus. Set forced to 1 to i69nore protective clothni69
/proc/infect_virus2(var/mob/livin69/carbon/M,var/datum/disease2/disease/disease,var/forced = 0)
	if(!istype(disease))
//		lo69_debu69("Bad69irus")
		return
	if(!istype(M))
//		lo69_debu69("Bad69ob")
		return
	if ("69disease.uni69ueID69" in69.virus2)
		return
	// if one of the antibodies in the69ob's body69atches one of the disease's anti69ens, don't infect
	var/list/antibodies_in_common =69.antibodies & disease.anti69en
	if(antibodies_in_common.len)
		return
	if(M.rea69ents.has_rea69ent("spaceacillin"))
		return

	if(!disease.affected_species.len)
		return

	if(!M.species)
		return

	if (!(M.species.69et_bodytype() in disease.affected_species))
		if (forced)
			disease.affected_species696969 =69.species.69et_bodytype()
		else
			return //not compatible with this species

//	lo69_debu69("Infectin69 696969")

	if(forced || (infection_check(M, disease.spreadtype) && prob(disease.infectionchance)))
		var/datum/disease2/disease/D = disease.69etcopy()
		D.minormutate()
//		lo69_debu69("Addin6969irus")
		M.virus269"69D.uni69ue69D69"69 = D
		BITSET(M.hud_updatefla69, STATUS_HUD)


//Infects69ob69 with disease D
/proc/infect_mob(var/mob/livin69/carbon/M,69ar/datum/disease2/disease/D)
	infect_virus2(M,D,1)
	M.hud_updatefla69 |= 1 << STATUS_HUD

//Infects69ob69 with random lesser disease, if he doesn't have one
/proc/infect_mob_random_lesser(var/mob/livin69/carbon/M)
	var/datum/disease2/disease/D =69ew /datum/disease2/disease

	D.makerandom(1)
	infect_mob(M, D)

//Infects69ob69 with random 69reated disease, if he doesn't have one
/proc/infect_mob_random_69reater(var/mob/livin69/carbon/M)
	var/datum/disease2/disease/D =69ew /datum/disease2/disease

	D.makerandom(2)
	infect_mob(M, D)

//Fancy prob() function.
/proc/dprob(var/p)
	return(prob(s69rt(p)) && prob(s69rt(p)))

/mob/livin69/carbon/proc/spread_disease_to(var/mob/livin69/carbon/victim,69ar/vector = "Airborne")
	if (src ==69ictim)
		return "retardation"

//	lo69_debu69("Spreadin69 69vecto6969 diseases from 69s69c69 to 69vic69im69")
	if (virus2.len > 0)
		for (var/ID in69irus2)
//			lo69_debu69("Attemptin6969irus 69I6969")
			var/datum/disease2/disease/V =69irus269I6969
			if(V.spreadtype !=69ector) continue

			//It's hard to 69et other people sick if you're in an airti69ht suit.
			if(!infection_spreadin69_check(src,69.spreadtype)) continue

			if (vector == "Airborne")
				if(airborne_can_reach(69et_turf(src), 69et_turf(victim)))
//					lo69_debu69("In ran69e, infectin69")
					infect_virus2(victim,V)
//				else
//					lo69_debu69("Could69ot reach tar69et")

			if (vector == "Contact")
				if (Adjacent(victim))
//					lo69_debu69("In ran69e, infectin69")
					infect_virus2(victim,V)

	//contact 69oes both ways
	if (victim.virus2.len > 0 &&69ector == "Contact" && Adjacent(victim))
//		lo69_debu69("Spreadin69 69vecto6969 diseases from 69vict69m69 to 6969rc69")
		var/nudity = 1

		if (ishuman(victim))
			var/mob/livin69/carbon/human/H =69ictim
			var/obj/item/or69an/external/select_area = H.69et_or69an(src.tar69eted_or69an)
			var/list/clothes = list(H.head, H.wear_mask, H.wear_suit, H.w_uniform, H.69loves, H.shoes)
			for(var/obj/item/clothin69/C in clothes)
				if(C && istype(C))
					if(C.body_parts_covered & select_area.body_part)
						nudity = 0
		if (nudity)
			for (var/ID in69ictim.virus2)
				var/datum/disease2/disease/V =69ictim.virus269I6969
				if(V &&69.spreadtype !=69ector) continue
				if(!infection_spreadin69_check(victim,69.spreadtype)) continue
				infect_virus2(src,V)
