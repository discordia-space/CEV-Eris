/* Toxins, poisons, venoms */

/datum/reagent/toxin
	name = "toxin"
	id = "toxin"
	description = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	reagent_state = LIQUID
	color = "#CF3600"
	metabolism = REM * 0.05 // 0.01 by default. They last a while and slowly kill you.
	var/strength = 1		// Base CE_TOXIN magnitude, multiplied by effect multiplier
	var/sanityloss = 0
	reagent_type = "Toxin"

/datum/reagent/toxin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(strength)
		var/multi = effect_multiplier
		if(issmall(M))  // Small bodymass, more effect from lower volume.
			multi *= 2
		if(sanityloss && ishuman(M))
			var/mob/living/carbon/human/H = M
			H.sanity.onToxin(src, multi)
		M.add_chemical_effect(CE_TOXIN, strength)

/datum/reagent/toxin/overdose(mob/living/carbon/M, alien)
	if(strength)
		M.add_chemical_effect(CE_TOXIN, strength * dose / 4)

/datum/reagent/toxin/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic used in creating plastic sheets."
	taste_description = "plastic"
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 6

/datum/reagent/toxin/oil
	name = "Oil"
	id = "oil"
	description = "Crude oil, commonly found on habitable planets."
	taste_description = "money"
	reagent_state = LIQUID
	color = "#0C0C0C"

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	reagent_state = LIQUID
	color = "#792300"
	strength = 1
	nerve_system_accumulations = 60
	addiction_chance = 20
	heating_point = 523
	heating_products = list("toxin")

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	reagent_state = LIQUID
	color = "#003333"
	strength = 1
	overdose = REAGENTS_OVERDOSE/3
	addiction_chance = 10
	nerve_system_accumulations = 5
	heating_point = 523
	heating_products = list("toxin")
	reagent_type = "Toxin/Stimulator"
	withdrawal_threshold = 10
	withdrawal_rate = REM

/datum/reagent/toxin/carpotoxin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT, STIM_TIME, "carpotoxin")

/datum/reagent/toxin/carpotoxin/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "carpotoxin_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "carpotoxin_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "carpotoxin_w")

/datum/reagent/toxin/carpotoxin/overdose(mob/living/carbon/M, alien)
	if(prob(80))
		M.adjustBrainLoss(2)
	if(strength)
		if(issmall(M))
			M.add_chemical_effect(CE_TOXIN, strength)
		else
			M.add_chemical_effect(CE_TOXIN, strength)

///datum/reagent/toxin/blattedin is defined in blattedin.dm

/datum/reagent/toxin/plasma
	name = "Plasma"
	id = "plasma"
	description = "Plasma in its liquid form."
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#9D14DB"
	strength = 3
	touch_met = 5

/datum/reagent/toxin/plasma/touch_mob(mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/toxin/plasma/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	M.take_organ_damage(0, effect_multiplier * 0.1) //being splashed directly with plasma causes minor chemical burns
	if(prob(50))
		M.pl_effects()

/datum/reagent/toxin/plasma/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	T.assume_gas("plasma", volume, T20C)
	remove_self(volume)
	return TRUE

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	taste_mult = 0.6
	reagent_state = LIQUID
	color = "#CF3600"
	strength = 2
	metabolism = REM * 2

/datum/reagent/toxin/cyanide/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.adjustOxyLoss(2 * effect_multiplier)
	M.AdjustSleeping(1)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 0
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/potassium_chloride/overdose(mob/living/carbon/M, alien)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath - 10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)


/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	strength = 1
	overdose = 20

/datum/reagent/toxin/potassium_chlorophoride/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "death"
	reagent_state = SOLID
	color = "#669900"
	metabolism = REM
	strength = 0.4

/datum/reagent/toxin/zombiepowder/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.6 * effect_multiplier)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	M.timeofdeath = world.time
	M.add_chemical_effect(CE_NOPULSE, 1)

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
		M.timeofdeath = 0
	. = ..()

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "fertilizer"
	id = "fertilizer"
	description = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	reagent_state = LIQUID
	strength = 0.1 // It's not THAT poisonous.
	color = "#664330"

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	id = "eznutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	id = "robustharvest"

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife."
	taste_mult = 1
	reagent_state = LIQUID
	color = "#49002E"
	strength = 0.4

/datum/reagent/toxin/plantbgone/touch_turf(turf/T)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/effect/overlay/wallrot) in W)
			for(var/obj/effect/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message(SPAN_NOTICE("The fungi are completely dissolved by the solution!"))
	return TRUE

/datum/reagent/toxin/plantbgone/touch_obj(obj/O, var/volume)
	if(istype(O, /obj/effect/plant) && !istype(O, /obj/effect/plant/hivemind))
		qdel(O)
	if(istype(O, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = O
		T.seed = null
		T.weedlevel = 0
		T.pestlevel = 0
		T.update_icon()
		return

/datum/reagent/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#8E18A9"
	power = 10
	meltdose = 4

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolism = REM * 2.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/lexorin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.take_organ_damage(0.3 * effect_multiplier, 0)
	if(M.losebreath < 15)
		M.losebreath++

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations."
	taste_description = "slime"
	taste_mult = 0.9
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/toxin/mutagen/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(33))
		affect_blood(M, alien, effect_multiplier)

/datum/reagent/toxin/mutagen/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(67))
		affect_blood(M, alien, effect_multiplier)

/datum/reagent/toxin/mutagen/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.flags & NO_SCAN)
			return
	M.apply_effect(1 * effect_multiplier, IRRADIATE, 0)

/datum/reagent/toxin/mutagen/moeball
	name = "mass of still twitching meat"
	id = "moeball"
	description = "Will cause mutations."
	taste_description = "slimy twitching flesh"
	taste_mult = 1.2
	reagent_state = SOLID
	color = "#5C4033"
	var/gene_type
	var/gene_value
	metabolism = REM * 2
	scannable = TRUE

/datum/reagent/toxin/mutagen/moeball/proc/isWorm()
	name = "mass of still whirling worms"
	description = "Will remove mutations."
	taste_description = "slimy wriggling worms"

/datum/reagent/toxin/mutagen/moeball/initialize_data(list/newdata) // Called when the reagent is created.
	if(!isnull(newdata))
		data = newdata
		gene_type = newdata["gene_type"]
		gene_value = newdata["gene_value"]
		if(!gene_type) // No mutation value means it is worms not flesh
			isWorm()
	return

/datum/reagent/toxin/mutagen/moeball/get_data()
	return list("gene_type" = gene_type, "gene_value" = gene_value)

/datum/reagent/toxin/mutagen/moeball/mix_data(var/newdata, var/newamount)
	if(!(newdata["gene_value"] == data["gene_value"]))
		gene_value = pick(subtypesof(/datum/mutation/t0))
		gene_type = "mutation"
	else if(!newdata["gene_type"] || !data["gene_type"])
		gene_type = null
		isWorm()

/datum/reagent/toxin/mutagen/moeball/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(10))
		affect_blood(M, alien, effect_multiplier)

/datum/reagent/toxin/mutagen/moeball/proc/mutate(mob/living/carbon/human/H, alien, effect_multiplier)
	if(gene_type)
		switch(gene_type)
			if("mutation")
				var/datum/mutation/U = gene_value
				U.imprint(H)

			if("b_type")
				H.b_type = gene_value
				H.fixblood()
				H.adjustOxyLoss(rand(10, 50))

			if("real_name")
				H.real_name = gene_value
				H.dna_trace = sha1(gene_value)
				H.fingers_trace = md5(gene_value)

			if("species")
				var/datum/species/S = gene_value
				H.set_species(S.name)
		to_chat(H, SPAN_DANGER("Some part of you feels wrong, like it's not you anymore."))
	else
		var/datum/mutation/U = gene_value ? gene_value : (H.active_mutations.len ? pick(H.active_mutations) : null)
		U?.cleanse(H)

	// Neither safe nor pleasant experience
	H.add_chemical_effect(CE_TOXIN, rand(5, 25))
	H.sanity.changeLevel(-20)

/datum/reagent/toxin/mutagen/moeball/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(15))
		to_chat(M, SPAN_DANGER("You feel your veins crackling and sending chills all over your skin!"))
		M.add_chemical_effect(CE_TOXIN, rand(4, 8) * effect_multiplier)
		M.adjustOxyLoss(rand(5, 20))
	if(dose > 3 && ishuman(M))
		mutate(M, alien, effect_multiplier)
		dose = dose - 3
		if(prob(50 - M.stats.getStat(STAT_TGH)))
			M.vomit() // It really isn't going to help

/datum/reagent/toxin/mutagen/moeball/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	if(prob(10))
		to_chat(M, SPAN_DANGER("Your insides are burning!"))
		M.add_chemical_effect(CE_TOXIN, rand(2, 6) * effect_multiplier)
	if(dose > 4 && ishuman(M))
		mutate(M, alien, effect_multiplier)
		dose = dose - 4
		if(prob(100 - M.stats.getStat(STAT_TGH)))
			M.vomit()

/datum/reagent/medicine/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence."
	taste_description = "slime"
	taste_mult = 1.3
	reagent_state = LIQUID
	color = "#801E28"

/datum/reagent/medicine/slimejelly/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.species.name == SPECIES_SLIME)
		M.heal_organ_damage(1 * effect_multiplier, 1 * effect_multiplier)
		return
	if(prob(10))
		to_chat(M, SPAN_DANGER("Your insides are burning!"))
		M.add_chemical_effect(CE_TOXIN, rand(10, 30) * effect_multiplier)
	else if(prob(40))
		M.heal_organ_damage(2.5 * effect_multiplier, 0)

/datum/reagent/medicine/soporific
	name = "Soporific"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#009CA8"
	metabolism = REM * 5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/medicine/soporific/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose < 1)
		if(effective_dose == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(effective_dose < 1.5)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(effective_dose < 5)
		if(prob(50))
			M.Weaken(2)
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/medicine/fun_gas
	name = "N2O"
	id = "sagent"
	description = "An effective sedative used during surgery to keep patients asleep."
	taste_description = "bitterness"
	reagent_state = GAS
	color = "#D3D3D3"
	metabolism = REM * 10
	overdose = REAGENTS_OVERDOSE / 3 // Even 10 is a lot of this
	scannable = TRUE

/datum/reagent/medicine/fun_gas/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	var/effective_dose = dose / 2
	dose *= 0.75 // Reduce the dose to prevent buildup from little N2O
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose < 1)
		if(effective_dose == metabolism * 2 || prob(10))
			M.emote("giggle")
	else if(effective_dose < 1.5)
		M.eye_blurry = max(M.eye_blurry, 10)
		if(prob(20))
			M.emote(pick("giggle", "laugh"))
	else if(effective_dose < 5)
		if(prob(50))
			M.Weaken(2)
		if(prob(30))
			M.emote("giggle")
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/medicine/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#000067"
	metabolism = REM * 5
	overdose = REAGENTS_OVERDOSE * 0.5

/datum/reagent/medicine/chloralhydrate/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	var/effective_dose = dose
	if(issmall(M))
		effective_dose *= 2

	if(effective_dose == metabolism)
		M.confused += 2
		M.drowsyness += 2
	else if(effective_dose < 2)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		M.sleeping = max(M.sleeping, 30)

	if(effective_dose > 1)
		M.add_chemical_effect(CE_TOXIN, effect_multiplier)

/datum/reagent/medicine/chloralhydrate/beer2 //disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	taste_description = "shitty piss water"
	reagent_state = LIQUID
	color = "#664300"

	glass_icon_state = "beerglass"
	glass_name = "beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

/* Transformations */

/datum/reagent/toxin/slimetoxin
	name = "Mutation Toxin"
	id = "mutationtoxin"
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/toxin/slimetoxin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name != SPECIES_SLIME)
			to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
			H.set_species(SPECIES_SLIME)

/datum/reagent/toxin/aslimetoxin
	name = "Advanced Mutation Toxin"
	id = "amutationtoxin"
	description = "An advanced corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/toxin/aslimetoxin/affect_blood(mob/living/carbon/M, alien, effect_multiplier) // TODO: check if there's similar code anywhere else
	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(M))
		return
	to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(M)
	M.canmove = 0
	M.icon = null
	M.overlays.Cut()
	M.invisibility = 101
	for(var/obj/item/W in M)
		if(istype(W, /obj/item/implant)) //TODO: Carn. give implants a dropped() or something
			qdel(W)
			continue
		W.layer = initial(W.layer)
		W.loc = M.loc
		W.dropped(M)
	var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
	new_mob.a_intent = "hurt"
	new_mob.universal_speak = 1
	if(M.mind)
		M.mind.transfer_to(new_mob)
	else
		new_mob.key = M.key
	qdel(M)

/datum/reagent/other/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#535E66"

/datum/reagent/toxin/pararein
	name = "Pararein"
	id = "pararein"
	description = "Venom used by spiders. Infamous for it's influence of the nervous system."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#a37d9c"
	metabolism = REM * 2
	overdose = REAGENTS_OVERDOSE/3
	addiction_chance = 0
	nerve_system_accumulations = 10
	strength = 2
	sanityloss = 1
	heating_point = 523
	heating_products = list("toxin")

/datum/reagent/toxin/pararein/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "pararein")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "pararein")
	M.stats.addTempStat(STAT_COG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "pararein")
	sanity_gain = 1.2
	if(prob(10))
		to_chat(M, SPAN_WARNING ("You feel like your mind is boiling and the blood in your veins is coming alive!"))

/datum/reagent/toxin/aranecolmin
	name = "Aranecolmin"
	id = "aranecolmin"
	description = "Toxin used by Nurse spiders. Speeds up metabolism of other spider toxins immensely."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#acc107"
	overdose = REAGENTS_OVERDOSE
	strength = 1
	metabolism = REM * 2
	addiction_chance = 0
	nerve_system_accumulations = 5

/datum/reagent/toxin/aranecolmin/on_mob_add(mob/living/L)
	. = ..()
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		if(LAZYLEN(C.internal_organs) && C.bloodstr && C.bloodstr.has_reagent("pararein"))
			var/obj/item/organ/internal/I = pick(C.internal_organs)
			to_chat(C, "Something burns inside your [I.parent.name]...")
			create_overdose_wound(I, C, /datum/component/internal_wound/organic/heavy_poisoning, "rot", TRUE)

/datum/reagent/toxin/aranecolmin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_PAINKILLER, 15)

/datum/reagent/toxin/diplopterum
	name = "Diplopterum"
	id = "diplopterum"
	description = "Can be found in tissues of the roaches."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#c9bed2"
	overdose = REAGENTS_OVERDOSE * 0.66
	strength = 1
	addiction_chance = 10
	nerve_system_accumulations = 5
	heating_point = 573
	heating_products = list("radium", "acetone", "hydrazine", "nutriment")
	reagent_type = "Toxin/Stimulator"
	withdrawal_threshold = 15

/datum/reagent/toxin/diplopterum/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_MEC, STAT_LEVEL_BASIC, STIM_TIME, "diplopterum")

/datum/reagent/toxin/diplopterum/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_MEC, -STAT_LEVEL_BASIC, STIM_TIME, "diplopterum_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "diplopterum_w")

/datum/reagent/toxin/diplopterum/overdose(mob/living/carbon/M, alien)
	var/od_toxicity = (dose / 2) * strength
	if(issmall(M))
		M.add_chemical_effect(CE_TOXIN, od_toxicity * 2)
	else
		M.add_chemical_effect(CE_TOXIN, od_toxicity)

/datum/reagent/toxin/seligitillin
	name = "Seligitillin"
	id = "seligitillin"
	description = "Promotes blood clotting. Harvested from Seuche roaches."
	taste_description = "plague"
	reagent_state = LIQUID
	color = "#6d33b4"
	overdose = REAGENTS_OVERDOSE/2
	addiction_chance = 10
	nerve_system_accumulations = 5
	heating_point = 573
	heating_products = list("radium", "ammonia", "sulfur", "nutriment")
	withdrawal_threshold = 10

/datum/reagent/toxin/seligitillin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_BLOODCLOT, 0.25)
	M.heal_organ_damage(0.25 * effect_multiplier, 0, 3)

/datum/reagent/toxin/seligitillin/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, STIM_TIME, "seligitillin_w")

/datum/reagent/toxin/seligitillin/overdose(mob/living/carbon/M, alien)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/internal/vital/heart/S = H.random_organ_by_process(OP_HEART)
	if(istype(S))
		S.take_damage(dose/2, FALSE, TOX)
	var/obj/item/organ/internal/liver/L = H.random_organ_by_process(OP_LIVER)
	if(istype(L))
		L.take_damage(dose/2, FALSE, TOX)

/datum/reagent/toxin/starkellin
	name = "Starkellin"
	id = "starkellin"
	description = "Harvested from Panzer roaches."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#736bbe"
	overdose = REAGENTS_OVERDOSE/2
	addiction_chance = 15
	nerve_system_accumulations = 5
	heating_point = 573
	heating_products = list("radium", "aluminum", "tungsten", "nutriment")
	reagent_type = "Toxin/Stimulator"
	withdrawal_threshold = 10

/datum/reagent/toxin/starkellin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_BASIC, STIM_TIME, "starkellin")

/datum/reagent/toxin/starkellin/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "starkellin_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "starkellin_w")

/datum/reagent/toxin/gewaltine
	name = "Gewaltine"
	id = "gewaltine"
	description = "Harvested from Jager roaches."
	taste_description = "raw meat"
	reagent_state = LIQUID
	color = "#9452ba"
	overdose = REAGENTS_OVERDOSE/2
	addiction_chance = 20
	nerve_system_accumulations = 5
	strength = 1
	heating_point = 573
	heating_products = list("radium", "mercury", "sugar", "nutriment")
	reagent_type = "Toxin/Stimulator"
	withdrawal_threshold = 10

/datum/reagent/toxin/gewaltine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_BASIC, STIM_TIME, "gewaltine")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "gewaltine")

/datum/reagent/toxin/gewaltine/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT, STIM_TIME, "gewaltine_w")
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_BASIC, STIM_TIME, "gewaltine_w")

/datum/reagent/toxin/gewaltine/overdose(mob/living/carbon/M, alien)
	M.adjustCloneLoss(2)

/datum/reagent/toxin/fuhrerole
	name = "Fuhrerole"
	id = "fuhrerole"
	description = "Harvested from Fuhrer roaches."
	taste_description = "third reich"
	reagent_state = LIQUID
	color = "#a6b85b"
	overdose = 8
	addiction_chance = 30
	nerve_system_accumulations = 4
	heating_point = 573
	heating_products = list("radium", "mercury", "lithium", "nutriment")
	withdrawal_threshold = 5

/datum/reagent/toxin/fuhrerole/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "fuhrerole_w")
	M.faction = "roach"

/datum/reagent/toxin/fuhrerole/on_mob_delete(mob/living/L)
	..()
	L.faction = initial(L.faction)

/datum/reagent/toxin/fuhrerole/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_BASIC, STIM_TIME, "fuhrerole_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_BASIC, STIM_TIME, "fuhrerole_w")

/datum/reagent/toxin/fuhrerole/overdose(mob/living/carbon/M, alien)
	M.add_chemical_effect(CE_SPEECH_VOLUME, rand(3,4))
	M.adjustBrainLoss(0.5)

/datum/reagent/toxin/kaiseraurum
	name = "Kaiseraurum"
	id = "kaiseraurum"
	description = "Harvested from Kaiser roaches."
	taste_description = "Kommandant\'s authority"
	reagent_state = LIQUID
	color = "#030f08"
	addiction_chance = 50
	addiction_threshold = 8
	overdose = 6
	nerve_system_accumulations = 50
	heating_point = 573
	heating_products = list("fuhrerole", "radium", "nutriment", "tungsten")
	reagent_type = "Toxin/Stimulator"
	withdrawal_threshold = 10

/datum/reagent/toxin/kaiseraurum/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.stats.addTempStat(STAT_VIG, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "kaiseraurum")
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "kaiseraurum")
	M.stats.addTempStat(STAT_ROB, STAT_LEVEL_BASIC * effect_multiplier, STIM_TIME, "kaiseraurum")
	M.faction = "roach"

/datum/reagent/toxin/kaiseraurum/withdrawal_act(mob/living/carbon/M)
	M.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, STIM_TIME, "kaiseraurum_w")
	M.stats.addTempStat(STAT_TGH, -STAT_LEVEL_ADEPT, STIM_TIME, "kaiseraurum_w")
	M.stats.addTempStat(STAT_ROB, -STAT_LEVEL_ADEPT, STIM_TIME, "kaiseraurum_w")

/datum/reagent/toxin/kaiseraurum/overdose(mob/living/carbon/M, alien)
	M.add_chemical_effect(CE_SPEECH_VOLUME, rand(3, 4))
	M.adjustBrainLoss(0.5)
	M.add_chemical_effect(CE_TOXIN, 10)	// This should be a cool roach-specific wound instead of generic toxicity

/datum/reagent/toxin/biomatter
	name = "Biomatter"
	id = "biomatter"
	description = "A goo of unknown to you origin. Its better to stay that way."
	taste_description = "vomit"
	reagent_state = LIQUID
	color = "#527f4f"
	strength = 0.25

/datum/reagent/toxin/biomatter/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.take_organ_damage(0, effect_multiplier * strength)

/datum/reagent/toxin/biomatter/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	if(prob(10 - (5 * M.stats.getMult(STAT_TGH))))
		M.vomit()

/datum/reagent/toxin/biomatter/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	..()
	if(prob(5 - (4 * M.stats.getMult(STAT_TGH))))
		M.vomit()

/datum/reagent/toxin/biomatter/touch_turf(turf/T)
	if(volume >= 5)
		if(volume >= 45)
			spill_biomass(T, alldirs)
		else if(volume >= 25)
			spill_biomass(T, cardinal)
		else
			spill_biomass(T)
		remove_self(volume)
		return TRUE

/datum/reagent/toxin/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A highly poisonous liquid. Smells strongly of bleach."
	reagent_state = LIQUID
	taste_description = "bleach"
	color = "#707c13"
	strength = 15

/datum/reagent/toxin/chlorine/touch_obj(obj/O)
	if(istype(O, /obj/effect/plant/hivemind))
		qdel(O)

/datum/reagent/toxin/tar
	name = "Tar"
	id = "tar"
	description = "A dark, viscous liquid."
	taste_description = "petroleum"
	color = "#140b30"
	reagent_state = LIQUID
	strength = 4

/datum/reagent/toxin/mold
	name = "Mold"
	id = "mold"
	description = "Food that went rotting for so long it liquefied. Do not consume."
	taste_description = "stale vomit mixed with pineapples"
	reagent_state = LIQUID
	color = "#467508"
	metabolism = REM
	overdose = REAGENTS_OVERDOSE/2
	nerve_system_accumulations = 5
	strength = 1
	sanityloss = 2

/datum/reagent/toxin/mold/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	. = ..()
	if(prob(20 * effect_multiplier))
		M.vomit()
