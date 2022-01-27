/datum/disease2/effectholder
	var/name = "Holder"
	var/datum/disease2/effect/effect
	var/chance = 0 //Chance in percenta69e each tick
	var/cure = "" //Type of cure it re69uires
	var/happensonce = 0
	var/multiplier = 1 //The chance the effects are WORSE
	var/sta69e = 0

/datum/disease2/effectholder/proc/runeffect(var/mob/livin69/carbon/human/mob,var/sta69e)
	if(happensonce > -1 && effect.sta69e <= sta69e && prob(chance))
		effect.activate(mob,69ultiplier)
		if(happensonce == 1)
			happensonce = -1

/datum/disease2/effectholder/proc/69etrandomeffect(var/badness = 1, exclude_types=list())
	var/list/datum/disease2/effect/list = list()
	for(var/e in (typesof(/datum/disease2/effect) - /datum/disease2/effect))
		var/datum/disease2/effect/f = e
		if(e in exclude_types)
			continue
		if(initial(f.badness) > badness)	//we don't want such stron69 effects
			continue
		if(initial(f.sta69e) <= src.sta69e)
			list += f
	var/type = pick(list)
	effect =69ew type()
	effect.69enerate()
	chance = rand(0,effect.chance_maxm)
	multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/minormutate()
	switch(pick(1,2,3,4,5))
		if(1)
			chance = rand(0,effect.chance_maxm)
		if(2)
			multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/majormutate(exclude_types=list())
	69etrandomeffect(3, exclude_types)

////////////////////////////////////////////////////////////////
////////////////////////EFFECTS/////////////////////////////////
////////////////////////////////////////////////////////////////

/datum/disease2/effect
	var/chance_maxm = 50 //note that disease effects only proc once every 3 ticks for humans
	var/name = "Blankin69 effect"
	var/sta69e = 4
	var/maxm = 1
	var/badness = 1
	var/data // For semi-procedural effects; this should be 69enerated in 69enerate() if used

	proc/activate(var/mob/livin69/carbon/mob,var/multiplier)
	proc/deactivate(var/mob/livin69/carbon/mob)
	proc/69enerate(copy_data) // copy_data will be69on-null if this is a copy; it should be used to initialise the data for this effect if present

/datum/disease2/effect/invisible
	name = "Waitin69 Syndrome"
	sta69e = 1
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		return

////////////////////////STA69E 4/////////////////////////////////

/datum/disease2/effect/nothin69
	name = "Nil Syndrome"
	sta69e = 4
	badness = 1
	chance_maxm = 0

/datum/disease2/effect/69ibbin69tons
	name = "69ibbin69tons Syndrome"
	sta69e = 4
	badness = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		// Probabilities have been tweaked to kill in ~2-369inutes, 69ivin69 5-1069essa69es.
		// Probably69eeds69ore balancin69, but it's better than LOL U 69IBBED69OW, especially69ow that69iruses can potentially have69o si69ns up until 69ibbin69tons.
		mob.adjustBruteLoss(10*multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			var/obj/item/or69an/external/O = pick(H.or69ans)
			if(prob(25))
				to_chat(mob, SPAN_WARNIN69("Your 69O.name69 feels as if it69i69ht burst!"))
			if(prob(10))
				spawn(50)
					if(O)
						O.droplimb(0,DROPLIMB_BLUNT)
		else
			if(prob(75))
				to_chat(mob, SPAN_WARNIN69("Your whole body feels like it69i69ht fall apart!"))
			if(prob(10))
				mob.adjustBruteLoss(25*multiplier)

/datum/disease2/effect/radian
	name = "Radian's Syndrome"
	sta69e = 4
	maxm = 3
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.apply_effect(2*multiplier, IRRADIATE, check_protection = 0)

/datum/disease2/effect/deaf
	name = "Dead Ear Syndrome"
	sta69e = 4
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.adjustEarDama69e(0,20)

/datum/disease2/effect/killertoxins
	name = "Toxification Syndrome"
	sta69e = 4
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.adjustToxLoss(15*multiplier)

/datum/disease2/effect/dna
	name = "Reverse Pattern Syndrome"
	sta69e = 4
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.bodytemperature =69ax(mob.bodytemperature, 350)
		scramble(0,mob,10)
		mob.apply_dama69e(10, CLONE)

/datum/disease2/effect/or69ans
	name = "Shutdown Syndrome"
	sta69e = 4
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			var/or69an = pick(list(BP_R_ARM,BP_L_ARM,BP_R_LE69,BP_R_LE69))
			var/obj/item/or69an/external/E = H.or69ans_by_name69or69a6969
			if (!(E.status & OR69AN_DEAD))
				E.status |= OR69AN_DEAD
				to_chat(H, SPAN_NOTICE("You can't feel your 69E.nam6969 anymore..."))
				for (var/obj/item/or69an/external/C in E.children)
					C.status |= OR69AN_DEAD
			H.update_body(1)
		mob.adjustToxLoss(15*multiplier)

	deactivate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			for (var/obj/item/or69an/external/E in H.or69ans)
				E.status &= ~OR69AN_DEAD
				for (var/obj/item/or69an/external/C in E.children)
					C.status &= ~OR69AN_DEAD
			H.update_body(1)

/datum/disease2/effect/immortal
	name = "Lon69evity Syndrome"
	sta69e = 4
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			for (var/obj/item/or69an/external/E in H.or69ans)
				if (E.status & OR69AN_BROKEN && prob(30))
					E.mend_fracture()
		var/heal_amt = -5*multiplier
		mob.apply_dama69es(heal_amt,heal_amt,heal_amt,heal_amt)

	deactivate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			to_chat(H, SPAN_NOTICE("You suddenly feel hurt and old..."))
			H.a69e += 8
		var/backlash_amt = 5*multiplier
		mob.apply_dama69es(backlash_amt,backlash_amt,backlash_amt,backlash_amt)

/datum/disease2/effect/bones
	name = "Fra69ile Bones Syndrome"
	sta69e = 4
	badness = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			for (var/obj/item/or69an/external/E in H.or69ans)
				E.min_broken_dama69e =69ax(5, E.min_broken_dama69e - 30)

	deactivate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			for (var/obj/item/or69an/external/E in H.or69ans)
				E.min_broken_dama69e = initial(E.min_broken_dama69e)

////////////////////////STA69E 3/////////////////////////////////

/datum/disease2/effect/toxins
	name = "Hyperacidity"
	sta69e = 3
	maxm = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.adjustToxLoss((2*multiplier))

/datum/disease2/effect/shakey
	name = "World Shakin69 Syndrome"
	sta69e = 3
	maxm = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		shake_camera(mob,5*multiplier)

/datum/disease2/effect/telepathic
	name = "Telepathy Syndrome"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.dna.SetSEState(REMOTETALKBLOCK,1)
		domutcheck(mob,69ull,69UTCHK_FORCED)

/datum/disease2/effect/mind
	name = "Lazy69ind Syndrome"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			var/obj/item/or69an/internal/brain/B = H.random_or69an_by_process(BP_BRAIN)
			if (B && B.dama69e < B.min_broken_dama69e)
				B.take_dama69e(5)
		else
			mob.setBrainLoss(10)

/datum/disease2/effect/hallucinations
	name = "Hallucinational Syndrome"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.hallucination(25, 25)

/datum/disease2/effect/deaf
	name = "Hard of Hearin69 Syndrome"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.ear_deaf = 5

/datum/disease2/effect/69i6969le
	name = "Uncontrolled Lau69hter Effect"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*69i6969le")

/datum/disease2/effect/confusion
	name = "Topo69raphical Cretinism"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		to_chat(mob, SPAN_NOTICE("You have trouble tellin69 ri69ht and left apart all of a sudden."))
		mob.confused += 10

/datum/disease2/effect/mutation
	name = "DNA De69radation"
	sta69e = 3
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.apply_dama69e(2, CLONE)

/datum/disease2/effect/69roan
	name = "69roanin69 Syndrome"
	sta69e = 3
	chance_maxm = 25
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*69roan")

/datum/disease2/effect/chem_synthesis
	name = "Chemical Synthesis"
	sta69e = 3
	chance_maxm = 25

	69enerate(c_data)
		if(c_data)
			data = c_data
		else
			data = pick("bicaridine", "kelotane", "anti_toxin", "inaprovaline", "space_dru69s", "su69ar",
						"tramadol", "dexalin", "cryptobiolin", "impedrezene", "hyperzine", "ethylredoxrazine",
						"mindbreaker", "69lucose")
		var/datum/rea69ent/R = 69LOB.chemical_rea69ents_list69dat6969
		name = "69initial(name6969 (69initial(R.nam69)69)"

	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if (mob.rea69ents.69et_rea69ent_amount(data) < 5)
			mob.rea69ents.add_rea69ent(data, 2)

////////////////////////STA69E 2/////////////////////////////////

/datum/disease2/effect/scream
	name = "Loudness Syndrome"
	sta69e = 2
	chance_maxm = 25
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*scream")

/datum/disease2/effect/drowsness
	name = "Automated Sleepin69 Syndrome"
	sta69e = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.drowsyness += 10

/datum/disease2/effect/sleepy
	name = "Restin69 Syndrome"
	sta69e = 2
	chance_maxm = 15
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*collapse")

/datum/disease2/effect/blind
	name = "Blackout Syndrome"
	sta69e = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.eye_blind =69ax(mob.eye_blind, 4)

/datum/disease2/effect/cou69h
	name = "Anima Syndrome"
	sta69e = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*cou69h")
		for(var/mob/livin69/carbon/M in oview(2,mob))
			mob.spread_disease_to(M)

/datum/disease2/effect/hun69ry
	name = "Appetiser Effect"
	sta69e = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.nutrition =69ax(0,69ob.nutrition - 200)

/datum/disease2/effect/frid69e
	name = "Refrid69erator Syndrome"
	sta69e = 2
	chance_maxm = 25
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*shiver")

/datum/disease2/effect/hair
	name = "Hair Loss"
	sta69e = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if(ishuman(mob))
			var/mob/livin69/carbon/human/H =69ob
			if(H.species.name == SPECIES_HUMAN && !(H.h_style == "Bald") && !(H.h_style == "Baldin69 Hair"))
				to_chat(H, SPAN_DAN69ER("Your hair starts to fall out in clumps..."))
				spawn(50)
					H.h_style = "Baldin69 Hair"
					H.update_hair()

/datum/disease2/effect/stimulant
	name = "Adrenaline Extra"
	sta69e = 2
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		to_chat(mob, SPAN_NOTICE("You feel a rush of ener69y inside you!"))
		if (mob.rea69ents.69et_rea69ent_amount("hyperzine") < 10)
			mob.rea69ents.add_rea69ent("hyperzine", 4)
		if (prob(30))
			mob.jitteriness += 10

////////////////////////STA69E 1/////////////////////////////////

/datum/disease2/effect/sneeze
	name = "Coldin69tons Effect"
	sta69e = 1
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		if (prob(30))
			to_chat(mob, SPAN_WARNIN69("You feel like you are about to sneeze!"))
		sleep(5)
		mob.say("*sneeze")
		for(var/mob/livin69/carbon/M in 69et_step(mob,mob.dir))
			mob.spread_disease_to(M)
		if (prob(50))
			var/obj/effect/decal/cleanable/mucus/M =69ew(69et_turf(mob))
			M.virus2 =69irus_copylist(mob.virus2)

/datum/disease2/effect/69unck
	name = "Flemmin69tons"
	sta69e = 1
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		to_chat(mob, SPAN_WARNIN69("Mucous runs down the back of your throat."))

/datum/disease2/effect/drool
	name = "Saliva Effect"
	sta69e = 1
	chance_maxm = 25
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*drool")

/datum/disease2/effect/twitch
	name = "Twitcher"
	sta69e = 1
	chance_maxm = 25
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		mob.say("*twitch")

/datum/disease2/effect/headache
	name = "Headache"
	sta69e = 1
	activate(var/mob/livin69/carbon/mob,var/multiplier)
		to_chat(mob, SPAN_WARNIN69("Your head hurts a bit."))
