/datum/reagent/other
	reagent_type = "Other"

/* Paint and crayons */
/datum/reagent/other/crayon_dust
	name = "Crayon dust"
	id = "crayon_dust"
	description = "Intensely coloured powder obtained by grinding crayons."
	taste_description = "the back of class"
	reagent_state = LIQUID
	color = "#888888"
	overdose = 5

/datum/reagent/other/crayon_dust/red
	name = "Red crayon dust"
	id = "crayon_dust_red"
	color = "#FE191A"

/datum/reagent/other/crayon_dust/orange
	name = "Orange crayon dust"
	id = "crayon_dust_orange"
	color = "#FFBE4F"

/datum/reagent/other/crayon_dust/yellow
	name = "Yellow crayon dust"
	id = "crayon_dust_yellow"
	color = "#FDFE7D"

/datum/reagent/other/crayon_dust/green
	name = "Green crayon dust"
	id = "crayon_dust_green"
	color = "#18A31A"

/datum/reagent/other/crayon_dust/blue
	name = "Blue crayon dust"
	id = "crayon_dust_blue"
	color = "#247CFF"

/datum/reagent/other/crayon_dust/purple
	name = "Purple crayon dust"
	id = "crayon_dust_purple"
	color = "#CC0099"

/datum/reagent/other/crayon_dust/grey //Mime
	name = "Grey crayon dust"
	id = "crayon_dust_grey"
	color = "#808080"

/datum/reagent/other/crayon_dust/brown //Rainbow
	name = "Brown crayon dust"
	id = "crayon_dust_brown"
	color = "#846F35"

/datum/reagent/other/paint
	name = "Paint"
	id = "paint"
	description = "This paint will stick to almost any object."
	taste_description = "chalk"
	reagent_state = LIQUID
	color = "#808080"
	overdose = REAGENTS_OVERDOSE * 0.5
	color_weight = 20

/datum/reagent/other/paint/touch_turf(turf/T)
	if(istype(T) && !istype(T, /turf/space))
		T.color = color
	return TRUE

/datum/reagent/other/paint/touch_obj(obj/O)
	if(istype(O))
		O.color = color

/datum/reagent/other/paint/touch_mob(mob/M)
	if(istype(M) && !isobserver(M)) //painting observers: not allowed
		M.color = color //maybe someday change this to paint only clothes and exposed body parts for human mobs.

/datum/reagent/other/paint/get_data()
	return color

/datum/reagent/other/paint/initialize_data(var/newdata)
	..()
	color = newdata
	return

/datum/reagent/other/paint/mix_data(var/newdata, var/newamount)
	var/list/colors = list(0, 0, 0, 0)
	var/tot_w = 0

	var/hex1 = uppertext(color)
	var/hex2 = uppertext(newdata)
	if(length(hex1) == 7)
		hex1 += "FF"
	if(length(hex2) == 7)
		hex2 += "FF"
	if(length(hex1) != 9 || length(hex2) != 9)
		return
	colors[1] += hex2num(copytext(hex1, 2, 4)) * volume
	colors[2] += hex2num(copytext(hex1, 4, 6)) * volume
	colors[3] += hex2num(copytext(hex1, 6, 8)) * volume
	colors[4] += hex2num(copytext(hex1, 8, 10)) * volume
	tot_w += volume
	colors[1] += hex2num(copytext(hex2, 2, 4)) * newamount
	colors[2] += hex2num(copytext(hex2, 4, 6)) * newamount
	colors[3] += hex2num(copytext(hex2, 6, 8)) * newamount
	colors[4] += hex2num(copytext(hex2, 8, 10)) * newamount
	tot_w += newamount

	color = rgb(colors[1] / tot_w, colors[2] / tot_w, colors[3] / tot_w, colors[4] / tot_w)
	return

/* Things that didn't fit anywhere else */

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	taste_description = "100% abuse"
	reagent_state = LIQUID
	color = "#C8A5DC"
	affects_dead = 1 //This can even heal dead people.

	glass_icon_state = "golden_cup"
	glass_name = "golden cup"
	glass_desc = "It's magic. We don't have to explain it."
	appear_in_default_catalog = FALSE

/datum/reagent/adminordrazine/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	affect_blood(M, alien, effect_multiplier)

/datum/reagent/adminordrazine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.radiation = 0
	M.heal_organ_damage(5,5)
	M.adjustToxLoss(-5)
	M.hallucination_power = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetWeakened(0)
	M.SetStunned(0)
	M.SetParalysis(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0

/datum/reagent/metal/gold
	name = "Gold"
	id = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	taste_description = "expensive metal"
	reagent_state = SOLID
	color = "#F7C430"

/datum/reagent/metal/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	taste_description = "expensive yet reasonable metal"
	reagent_state = SOLID
	color = "#D0D0D0"

/datum/reagent/metal/uranium
	name ="Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	taste_description = "the inside of a reactor"
	reagent_state = SOLID
	color = "#B8B8C0"

/datum/reagent/metal/uranium/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	affect_ingest(M, alien, effect_multiplier)

/datum/reagent/metal/uranium/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.apply_effect(effect_multiplier, IRRADIATE, 0)

/datum/reagent/metal/uranium/touch_turf(turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return TRUE
	return TRUE


/datum/reagent/adrenaline
	name = "Adrenaline"
	id = "adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#C8A5DC"
	reagent_type = "Organic/Stimulator"
	withdrawal_threshold = 30

/datum/reagent/adrenaline/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.SetParalysis(0)
	M.SetWeakened(0)
	M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT * effect_multiplier, STIM_TIME, "adrenaline")
	M.adjustToxLoss(rand(3))

/datum/reagent/adrenaline/withdrawal_act(mob/living/carbon/M)
	M.adjustOxyLoss(15)

/datum/reagent/water/holywater/touch_turf(turf/T)
	if(volume >= 5)
		T.holy = 1
	return TRUE

/datum/reagent/other/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	taste_description = "iron"
	reagent_state = LIQUID
	color = "#604030"

/datum/reagent/other/surfactant // Foam precursor
	name = "Azosurfactant"
	id = "surfactant"
	description = "A isocyanate liquid that forms a foam when mixed with water."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#9E6B38"

/datum/reagent/other/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#664B63"

/datum/reagent/other/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	taste_description = "sweet tasting metal"
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/other/thermite/touch_turf(turf/T)
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.overlays += image('icons/effects/effects.dmi',icon_state = "#673910")
			remove_self(5)
	return TRUE

/datum/reagent/other/thermite/touch_mob(mob/living/L, var/amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / 5)

/datum/reagent/other/thermite/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustFireLoss(3 * 0.6)

/datum/reagent/other/matter_deconstructor //Currently uncraftable, used in excelsior reclaimer
	name = "Matter deconstructor"
	id = "deconstructor"
	description = "A celluose based combound able to deconstruct matter into it's base components, not 100% effective."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#DC7633"
	touch_met = 50

/datum/reagent/other/matter_deconstructor/touch_obj(obj/O)
	var/list/matter = O.matter
	if(length(matter))
		for(var/i in matter)
			var/material/M = get_material_by_name(i)
			var/matter_ammount = round(matter[i] * 0.75) // around 75% matterials back
			if (matter_ammount < 1)
				continue
			var/obj/item/stack/material/MS = new M.stack_type(O.drop_location())
			MS.amount = matter_ammount
		O.Destroy()

/datum/reagent/other/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#A5F0EE"
	touch_met = 50

/datum/reagent/other/space_cleaner/touch_obj(obj/O)
	O.clean_blood()
	O.color = "white"

/datum/reagent/other/space_cleaner/touch_turf(turf/T)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			if(S.wet >= 2)
				S.wet_floor(1, TRUE)
		T.clean_blood()

		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(rand(5, 10))

	T.color = "white"
	return TRUE

/datum/reagent/other/space_cleaner/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	if(M.r_hand)
		M.r_hand.clean_blood()
	if(M.l_hand)
		M.l_hand.clean_blood()
	if(M.wear_mask)
		if(M.wear_mask.clean_blood())
			M.update_inv_wear_mask(0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head(0)
		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit(0)
		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform(0)
		if(H.shoes)
			if(H.shoes.clean_blood())
				H.update_inv_shoes(0)
		else
			H.clean_blood(1)
			return
	M.clean_blood()
	M.color = "white"

/datum/reagent/other/lube // TODO: spraying on borgs speeds them up
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	reagent_state = LIQUID
	color = "#009CA8"

/datum/reagent/other/lube/touch_turf(turf/simulated/T)
	if(!istype(T))
		return TRUE
	if(volume >= 1)
		T.wet_floor(2)
	return TRUE

/datum/reagent/other/silicate
	name = "Silicate"
	id = "silicate"
	description = "A compound that can be used to reinforce glass."
	taste_description = "plastic"
	reagent_state = LIQUID
	color = "#C7FFFF"

/datum/reagent/other/silicate/touch_obj(obj/O)
	if(istype(O, /obj/structure/window))
		var/obj/structure/window/W = O
		W.apply_silicate(volume)
		remove_self(volume)
	return

/datum/reagent/other/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	taste_description = "sweetness"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/other/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	taste_description = "oil"
	reagent_state = LIQUID
	color = "#808080"

/datum/reagent/other/nitroglycerin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/other/coolant
	name = "Coolant"
	id = "coolant"
	description = "Industrial coolant. Used to lower the freezing point and raise the boiling point of liquid in a system."
	taste_description = "sourness"
	taste_mult = 1.1
	reagent_state = LIQUID
	color = "#C8A5DC"
	var/reagent_property_coeff = 2796	// 0.7857 * 3559, the density (kg/L) and specific heat (J/(kg K)) of 50:50 propylene glycol water
	var/latent_heat = 600			// Arbitrarily chosen amount. Just needs to be worse than refrigerant.

/*		Proc was removed because of griefing
#define COOLANT_LATENT_HEAT 19000
/datum/reagent/other/coolant/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = 0 // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * COOLANT_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>\The [src] sizzles as it lands on \the [T]!</span>")
*/

/datum/reagent/other/coolant/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustToxLoss(1)
	M.add_chemical_effect(CE_TOXIN, 1)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/organ_process = pick(OP_LIVER, OP_LUNGS, OP_KIDNEYS, OP_BLOOD_VESSEL, OP_STOMACH)
		var/obj/item/organ/internal/I = H.random_organ_by_process(organ_process)
		if(istype(I))
			I.take_damage(1, TRUE)

// This was created to give people a way to cool reagents without needing a chem heater. Use it in a sprayer.
/datum/reagent/other/coolant/touch_obj(obj/O, amount)
	if(!istype(O, /obj/item/reagent_containers))	// Remove this check if we want to apply this to all objects.
		return

	// Q = mc(del_T);	Realistically, we'd look at the properties of the reagent being cooled and the removed heat (Q) of the coolant/refrigerant.
	// temp change = Q / mc
	var/removed_heat = amount * latent_heat								// Ignoring surrounding temp for simplicity
	var/volume_in_liters = amount / 30									// L, Water latent heat comment in core.dm says 30u is 1 L
	var/reagent_property_divisor = volume_in_liters * reagent_property_coeff
	var/temperature_change = removed_heat / reagent_property_divisor	// K

	O.reagents.chem_temp = max(O.reagents.chem_temp - temperature_change, 2.7)
	O.reagents.handle_reactions()

// Not even close to how refrigerant is used IRL, but it's just a game.
/datum/reagent/other/coolant/refrigerant
	name = "Refrigerant"
	id = "refrigerant"
	description = "Industrial refrigerant R13. Used to remove heat."
	taste_description = "fresh grass"
	color = "#b6dca5"
	reagent_property_coeff = 1496	// 1.21 * 1236, denstiy and specific heat of R22 refrigerant.
	latent_heat = 1900				// Roughly a tenth of water's latent heat from core.dm

/datum/reagent/other/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	taste_description = "a special education class"
	color = "#FFFFCC"

/datum/reagent/other/woodpulp
	name = "Wood Pulp"
	id = "woodpulp"
	description = "A mass of wood fibers."
	taste_description = "wood"
	reagent_state = LIQUID
	color = "#B97A57"

/datum/reagent/other/luminol
	name = "Luminol"
	id = "luminol"
	description = "A compound that interacts with blood on the molecular level."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#F2F3F4"

/datum/reagent/other/luminol/touch_obj(obj/O)
	O.reveal_blood()

/datum/reagent/other/luminol/touch_mob(mob/living/L)
	L.reveal_blood()

/datum/reagent/other/arectine
	name = "Arectine"
	id = "arectine"
	description = "Makes user emit light."
	taste_description = "fireflies"
	reagent_state = LIQUID
	color = "#a6b85b"
	overdose = 25
	addiction_chance = 5

/datum/reagent/other/arectine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.set_light(2.5)

/datum/reagent/other/arectine/overdose(mob/living/carbon/M, alien)
	if(prob(10))
		M.IgniteMob()

/datum/reagent/other/arectine/on_mob_delete(mob/living/L)
	..()
	L.set_light(0)

/datum/reagent/other/instantice
	name = "InstantIce"
	id = "instant_ice"
	description = "Will cool reagents inside container when mixed with water to -50C"
	taste_description = "nothing"
	reagent_state = LIQUID
	color = "#bbc5f0"

/datum/reagent/other/rejuvenating_agent
	name = "Rejuvenating agent"
	id = "rejuvenating_agent"
	description = "A complex reagent that, applied to an object, is capable of eliminating most of the effects of the passage of time"
	taste_description = "nothing"
	reagent_state = LIQUID
	color = "#c8d0f5"

/datum/reagent/other/rejuvenating_agent/touch_obj(obj/O)
	if(istype(O))
		O.make_young()

/datum/reagent/resuscitator
	name = "Resuscitator"
	id = "resuscitator"
	description = "Incredibly rare cardiac stimulant."
	reagent_state = LIQUID
	color = "#A0522D"
	metabolism = 1
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	affects_dead = TRUE
	reagent_type = "Medicine"

/datum/reagent/resuscitator/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/heart = H.random_organ_by_process(OP_HEART)
		if(heart)
			heart.damage += 0.5
			if(prob(30))
				to_chat(H, SPAN_DANGER("Your heart feels like it's going to tear itself out of you!"))
		if(H.stat == DEAD)
			H.resuscitate()

/datum/reagent/resuscitator/overdose(mob/living/carbon/M, alien)
	. = ..()

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/heart = H.random_organ_by_process(OP_HEART)
		if(heart)
			heart.die()

/datum/reagent/oddity_tea
	name = "tea"
	id = "oddity_tea"
	description = "Unusually refreshing tea."
	taste_description = "refreshing tea"
	reagent_state = LIQUID
	color = "#cf820f"
	metabolism = REM * 0.2
	nerve_system_accumulations = 20
	sanity_gain_ingest = 0.5	
	taste_tag = list(TASTE_LIGHT)
	glass_icon_state = "teaglass"
	glass_name = "odd tea"
	glass_desc = "Tea of unrecognizable type. There is tiny golden bits floating in it."
	appear_in_default_catalog = FALSE
	reagent_type = "Drink"

/datum/reagent/oddity_tea/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 0.3)
	M.add_chemical_effect(CE_PULSE, 1.5)
