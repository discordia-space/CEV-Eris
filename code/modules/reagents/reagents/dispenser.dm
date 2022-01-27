/datum/reagent/acetone
	name = "Acetone"
	id = "acetone"
	description = "A colorless li69uid solvent used in chemical synthesis."
	taste_description = "acid"
	reagent_state = LI69UID
	color = "#808080"
	metabolism = REM * 0.2
	reagent_type = "General"

/datum/reagent/acetone/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustToxLoss(effect_multiplier * 0.3)

/datum/reagent/acetone/touch_obj(obj/O)	//I copied this wholesale from ethanol and could likely be converted into a shared proc. ~Techhead
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat =69ull
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

/datum/reagent/metal
	reagent_type = "Metal"

/datum/reagent/metal/aluminum
	name = "Aluminum"
	id = "aluminum"
	taste_description = "metal"
	taste_mult = 1.1
	description = "A silvery white and ductile69ember of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8"

/datum/reagent/toxin/ammonia
	name = "Ammonia"
	id = "ammonia"
	taste_description = "mordant"
	taste_mult = 2
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = LI69UID
	color = "#404030"
	metabolism = REM * 0.5

/datum/reagent/toxin/ammonia/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustToxLoss(effect_multiplier * 0.15)

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the builing block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1C1300"
	ingest_met = REM * 5
	reagent_type = "Reactive69onmetal"

/datum/reagent/carbon/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	if(M.ingested &&69.ingested.reagent_list.len > 1) //69eed to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (M.ingested.reagent_list.len - 1)
		for(var/datum/reagent/R in69.ingested.reagent_list)
			if(R == src)
				continue
			M.ingested.remove_reagent(R.id, effect_multiplier * effect)

/datum/reagent/carbon/touch_turf(turf/T)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay =69ew/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha =69olume * 30
		else
			dirtoverlay.alpha =69in(dirtoverlay.alpha +69olume * 30, 255)
	return TRUE

/datum/reagent/metal/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile69etal."
	taste_description = "copper"
	color = "#6E3B08"

/datum/reagent/ethanol
	name = "Ethanol"
	id = "ethanol"
	description = "A well-known alcohol with a69ariety of applications."
	taste_description = "pure alcohol"
	reagent_state = LI69UID
	color = "#404030"
	metabolism = REM * 0.25
	ingest_met = REM * 8
	touch_met = 5
	var/strength_mod = 1
	var/toxicity = 1
	scannable = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0
	sanity_gain_ingest = 0.5 //this defines how good eating/drinking the thing will69ake you feel, scales off strength and strength69od(ethanol)
	taste_tag = list()  // list the tastes the thing got there

	glass_icon_state = "glass_clear"
	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a69ariety of applications."
	reagent_type = "Alcohol"

/datum/reagent/ethanol/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 15)

/datum/reagent/ethanol/on_mob_add(mob/living/L)
	..()
	SEND_SIGNAL(L, COMSIG_CARBON_HAPPY, src,69OB_ADD_DRUG)

/datum/reagent/ethanol/on_mob_delete(mob/living/L)
	..()
	SEND_SIGNAL(L, COMSIG_CARBON_HAPPY, src,69OB_DELETE_DRUG)

/datum/reagent/ethanol/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_PAINKILLER, 125 * effect_multiplier)	// Effect69ultiplier is 0.2, same strength as paracetamol

	M.add_chemical_effect(CE_ALCOHOL, 1)

//Tough people can drink a lot
	var/tolerance = 3 +69ax(0,69.stats.getStat(STAT_TGH)) * 0.1

	if(M.stats.getPerk(/datum/perk/sommelier))
		tolerance *= 10

	if(volume * strength_mod >= tolerance) // Early warning
		M.make_dizzy(9) // It is decreased at the speed of 3 per tick

	if(volume * strength_mod >= tolerance * 2) // Slurring
		M.slurring =69ax(M.slurring, 30)

	if(volume * strength_mod >= tolerance * 4) // Confusion - walking in random directions
		M.confused =69ax(M.confused, 20)

	// if(volume * strength_mod >= tolerance * 4) // Blurry69ision //69ot fun
	//	M.eye_blurry =69ax(M.eye_blurry, 10)

	if(volume * strength_mod >= tolerance * 6) // Drowsyness - periodically falling asleep
		M.drowsyness =69ax(M.drowsyness, 20)

	if(volume * strength_mod >= tolerance * 8) // Pass out
		M.paralysis =69ax(M.paralysis, 20)
		M.sleeping  =69ax(M.sleeping, 30)

	if(volume * strength_mod >= tolerance * 10) // Toxic dose, at least 30 ethanol re69uired
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)

	metabolism = REM * (0.25 + dose * 0.05) // For the sake of better balancing between alcohol strengths

	if(M.sleeping)
		metabolism *= 1.5

/datum/reagent/ethanol/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)

	var/datum/reagents/metabolism/met =69.get_metabolism_handler(CHEM_BLOOD)
	met.add_reagent(id, effect_multiplier / 2) // Only half of it enters the bloodstream

	if(druggy != 0)
		M.druggy =69ax(M.druggy, druggy)

	if(adj_temp > 0 &&69.bodytemperature < targ_temp) // 310 is the69ormal bodytemp. 310.055
		M.bodytemperature =69in(targ_temp,69.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 &&69.bodytemperature > targ_temp)
		M.bodytemperature =69in(targ_temp,69.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

	apply_sanity_effect(M, effect_multiplier)
	SEND_SIGNAL(M, COMSIG_CARBON_HAPPY, src, ON_MOB_DRUG)

/datum/reagent/ethanol/touch_obj(obj/O)
	if(istype(O, /obj/item/paper))
		var/obj/item/paper/paperaffected = O
		paperaffected.clearpaper()
		to_chat(usr, "The solution dissolves the ink on the paper.")
		return
	if(istype(O, /obj/item/book))
		if(volume < 5)
			return
		var/obj/item/book/affectedbook = O
		affectedbook.dat =69ull
		to_chat(usr, "<span class='notice'>The solution dissolves the ink on the book.</span>")
	return

/datum/reagent/toxin/hydrazine
	name = "Hydrazine"
	id = "hydrazine"
	description = "A toxic, colorless, flammable li69uid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting69etal"
	reagent_state = LI69UID
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5

/datum/reagent/toxin/hydrazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustToxLoss(0.4 * effect_multiplier)

/datum/reagent/toxin/hydrazine/affect_touch(mob/living/carbon/M, alien, effect_multiplier) // Hydrazine is both toxic and flammable.
	M.adjust_fire_stacks(0.4 / 12)
	M.adjustToxLoss(0.2 * effect_multiplier)

/datum/reagent/toxin/hydrazine/touch_turf(turf/T)
	new /obj/effect/decal/cleanable/li69uid_fuel(T,69olume)
	remove_self(volume)
	return TRUE

/datum/reagent/metal/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a69etal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"


/datum/reagent/metal/iron/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	M.add_chemical_effect(CE_BLOODRESTORE, 0.8 * effect_multiplier)

/datum/reagent/metal/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/metal/lithium/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/metal/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LI69UID
	color = "#484848"

/datum/reagent/metal/mercury/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch", "drool", "moan"))
	M.adjustBrainLoss(0.1)

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"
	reagent_type = "Reactive69onmetal"


/datum/reagent/metal/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts69iolently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#A0A0A0"

/datum/reagent/metal/potassium/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/metal/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth69etal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	reagent_state = SOLID
	color = "#C7C7C7"

/datum/reagent/metal/radium/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.apply_effect(1 * (issmall(M) ? effect_multiplier * 2 : effect_multiplier), IRRADIATE, 0) // Radium69ay increase your chances to cure a disease
	if(M.virus2.len)
		for(var/ID in69.virus2)
			var/datum/disease2/disease/V =69.virus269ID69
			if(prob(5))
				M.antibodies |=69.antigen
				if(prob(50))
					M.apply_effect(50, IRRADIATE, check_protection = 0) // curing it that way69ay kill you instead


/datum/reagent/metal/radium/touch_turf(turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return TRUE
	return TRUE

/datum/reagent/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A69ery corrosive69ineral acid with the69olecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LI69UID
	color = "#DB5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	reagent_type = "Acid"
	var/power = 5
	var/meltdose = 10 // How69uch is69eeded to69elt

/datum/reagent/acid/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.take_organ_damage(0, (issmall(M) ? effect_multiplier * 2: effect_multiplier * power * 2))

/datum/reagent/acid/affect_touch(mob/living/carbon/M, alien, effect_multiplier) // This is the69ost interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, "<span class='danger'>Your 69H.head69 protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(volume >69eltdose)
				H << "<span class='danger'>Your 69H.head6969elts away!</span>"
				69del(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				remove_self(meltdose)
		if(volume <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, "<span class='danger'>Your 69H.wear_mask69 protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(volume >69eltdose)
				H << "<span class='danger'>Your 69H.wear_mask6969elts away!</span>"
				69del(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				remove_self(meltdose)
		if(volume <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				H << "<span class='danger'>Your 69H.glasses69 partially protect you from the acid!</span>"
				volume /= 2
			else if(volume >69eltdose)
				H << "<span class='danger'>Your 69H.glasses6969elt away!</span>"
				69del(H.glasses)
				H.update_inv_glasses(1)
				remove_self(meltdose / 2)
		if(volume <= 0)
			return

	if(volume <69eltdose) //69ot enough to69elt anything
		M.take_organ_damage(0, effect_multiplier * power * 0.2) //burn damage, since it causes chemical burns. Acid doesn't69ake bones shatter, like brute trauma would.
		return
	if(!M.unacidable &&69olume > 0)
		if(ishuman(M) &&69olume >=69eltdose)
			var/mob/living/carbon/human/H =69
			var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
			if(affecting)
				if(affecting.take_damage(0,69olume * power * 0.1))
					H.UpdateDamageIcon()
				if(prob(100 *69olume /69eltdose)) // Applies disfigurement
					if (!(H.species && (H.species.flags &69O_PAIN)))
						H.emote("scream")
					H.status_flags |= DISFIGURED
		else
			M.take_organ_damage(0,69olume * power * 0.1) // Balance. The damage is instant, so it's weaker. 10 units -> 5 damage, double for pacid. 120 units beaker could deal 60, but a) it's burn, which is69ot as dangerous, b) it's a one-use weapon, c)69issing with it will splash it over the ground and d) clothes give some protection, so69ot everything will hit

/datum/reagent/acid/touch_obj(obj/O)
	if(istype(O, /obj/effect/plant/hivemind))
		69del(O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/plant)) && (volume >69eltdose))
		var/obj/effect/decal/cleanable/molten_item/I =69ew/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an 69O69 some time ago."
		for(var/mob/M in69iewers(5, O))
			to_chat(M, "<span class='warning'>\The 69O6969elts.</span>")
		69del(O)
		remove_self(meltdose) // 10 units of acid will69ot69elt EVERYTHING on the tile

/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and69ore acidic.
	name = "Hydrochloric Acid"
	id = "hclacid"
	description = "A69ery corrosive69ineral acid with the69olecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LI69UID
	color = "#808080"
	power = 3
	meltdose = 8

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent69etalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8"
	reagent_type = "Metalloid"

/datum/reagent/metal/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty69etal"
	reagent_state = SOLID
	color = "#808080"

/datum/reagent/organic/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste. It is69ot a good idea to inject too69uch raw sugar into your bloodstream."
	taste_description = "sugar"
	taste_mult = 1.8
	overdose = 40
	reagent_state = SOLID
	color = "#FFFFFF"
	glass_icon_state = "iceglass"
	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."

/datum/reagent/organic/sugar/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustNutrition(1 * effect_multiplier)

/datum/reagent/organic/sugar/overdose(mob/living/carbon/M, alien)
	..()
	M.add_side_effect("Headache", 11)
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)
	if(ishuman(M))
		var/mob/living/carbon/human/H =69
		var/obj/item/organ/internal/heart/L = H.random_organ_by_process(OP_HEART)
		if(istype(L))
			L.take_damage(1, 0)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#BF8C00"
	reagent_type = "Reactive69onmetal"

/datum/reagent/metal/tungsten
	name = "Tungsten"
	id = "tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#DCDCDC"
