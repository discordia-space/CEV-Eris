/datum/reagent/organic
	reagent_type = "Organic"
/* Food */
/datum/reagent/organic/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 2
	var/nutriment_factor = 12 // Per metabolism tick
	var/regen_factor = 0.8 //Used for simple animal health regeneration
	var/injectable = 0
	sanity_gain_ingest = 0.3 //well they are a sort of food so, this defines how good eating the thing will make you feel
	taste_tag = list()  // list the tastes the thing got there
	color = "#664330"

/datum/reagent/organic/nutriment/mix_data(var/list/newdata, var/newamount)
	if(!islist(newdata) || !newdata.len)
		return
	..()
	for(var/i in 1 to newdata.len)
		if(!(newdata[i] in data))
			data.Add(newdata[i])
			data[newdata[i]] = 0
		data[newdata[i]] += newdata[newdata[i]]
	var/totalFlavor = 0
	for(var/i in 1 to data.len)
		totalFlavor += data[data[i]]

	if(totalFlavor != 0)
		var/flavors_to_remove = list()
		for(var/flavor in data) //cull the tasteless
			if(data[flavor]/totalFlavor * 100 < 10)
				flavors_to_remove += flavor

		data -= flavors_to_remove

/datum/reagent/organic/nutriment/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	if(!injectable)
		M.adjustToxLoss(0.1 * effect_multiplier)
		return
	affect_ingest(M, alien, effect_multiplier * 1.2)

/datum/reagent/organic/nutriment/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	// Small bodymass, more effect from lower volume.
	M.adjustNutrition(nutriment_factor * (issmall(M) ? effect_multiplier * 2 : effect_multiplier)) // For hunger and fatness
	M.add_chemical_effect(CE_BLOODRESTORE, 0.1 * (issmall(M) ? effect_multiplier * 2 : effect_multiplier))

	apply_sanity_effect(M, effect_multiplier)

/datum/reagent/organic/nutriment/glucose
	name = "Glucose"
	id = "glucose"
	description = "Most important source of energy in all organisms."
	color = "#FFFFFF"
	taste_tag = list(TASTE_SWEET)

	injectable = 1

/datum/reagent/organic/nutriment/protein
	name = "Animal Protein"
	taste_description = "some sort of protein"
	id = "protein"
	description = "Essential nutrient for the human body."
	color = "#440000"
	taste_tag = list(TASTE_SLIMEY)


/datum/reagent/organic/nutriment/protein/egg
	name = "Egg Yolk"
	taste_description = "egg"
	id = "egg"
	description = "Store significant amounts of protein and choline"
	color = "#FFFFAA"
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/organic/nutriment/honey
	name = "Honey"
	id = "honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 4
	color = "#FFFF00"
	taste_tag = list(TASTE_SWEET,TASTE_SLIMEY)

/datum/reagent/organic/nutriment/flour
	name = "flour"
	id = "flour"
	description = "A powder made by grinding raw grains, roots, beans, nuts, or seeds."
	taste_description = "chalky wheat"
	reagent_state = SOLID
	nutriment_factor = 0.4
	color = "#FFFFFF"
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/organic/nutriment/flour/touch_turf(turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/flour(T)
	return TRUE

/datum/reagent/organic/nutriment/coco
	name = "Coco Powder"
	id = "coco"
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	reagent_state = SOLID
	nutriment_factor = 2
	color = "#302000"
	taste_tag = list(TASTE_SWEET,TASTE_SLIMEY)

/datum/reagent/organic/nutriment/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	reagent_state = LIQUID
	nutriment_factor = 0.8
	color = "#792300"
	taste_tag = list(TASTE_SALTY)

/datum/reagent/organic/nutriment/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "It's tomato paste."
	taste_description = "ketchup"
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#731008"
	taste_tag = list(TASTE_SWEET)

/datum/reagent/organic/nutriment/rice
	name = "Rice"
	id = "rice"
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	reagent_state = SOLID
	nutriment_factor = 0.4
	color = "#FFFFFF"
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/organic/nutriment/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	reagent_state = LIQUID
	nutriment_factor = 0.4
	color = "#801E28"
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/organic/nutriment/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	reagent_state = LIQUID
	nutriment_factor = 8
	color = "#302000"
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/organic/nutriment/cornoil/touch_turf(turf/simulated/T)
	if(!istype(T))
		return TRUE

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if(volume >= 3)
		T.wet_floor()
	return TRUE

/datum/reagent/organic/nutriment/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	taste_description = "vomit"
	taste_mult = 2
	reagent_state = LIQUID
	nutriment_factor = 0.8
	color = "#899613"
	taste_tag = list(TASTE_SOUR)
/datum/reagent/organic/nutriment/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 0.4
	color = "#FF00FF"
	taste_tag = list(TASTE_SWEET)

/datum/reagent/organic/nutriment/mint
	name = "Mint"
	id = "mint"
	description = "Also known as Mentha."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#CF3600"
	taste_tag = list(TASTE_REFRESHING)

/datum/reagent/other/lipozine // The anti-nutriment.
	name = "Lipozine"
	id = "lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/other/lipozine/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.nutrition = max(M.nutrition - 1 * effect_multiplier, 0)

/* Non-food stuff like condiments */
/datum/reagent/other/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/organic/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. Used in many medicinal and beauty products."
	taste_description = "pepper"
	reagent_state = SOLID
	color = "#000000"
	taste_tag = list(TASTE_SPICY,)

/datum/reagent/organic/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	reagent_state = LIQUID
	color = "#365E30"
	overdose = REAGENTS_OVERDOSE
	taste_tag = list(TASTE_SOUR)

/datum/reagent/organic/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	taste_description = "mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#B31008"
	taste_tag = list(TASTE_SPICY)

/datum/reagent/organic/frostoil/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(isslime(M))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent("capsaicin", 5)

/datum/reagent/organic/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#B31008"
	var/agony_dose = 5
	var/agony_amount = 2
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10
	taste_tag = list(TASTE_SPICY)

/datum/reagent/organic/capsaicin/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustToxLoss(0.05 * effect_multiplier)

/datum/reagent/organic/capsaicin/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && (H.species.flags & (NO_PAIN)))
			return
	if(dose < agony_dose)
		if(prob(5) || dose == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, AGONY, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
	if(isslime(M))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent("frostoil", 5)

/datum/reagent/organic/capsaicin/condensed
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_description = "satan's piss"
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly
	color = "#B31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15
	taste_tag = list(TASTE_SPICY)

/datum/reagent/organic/capsaicin/condensed/affect_touch(mob/living/carbon/M, alien, effect_multiplier)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/no_pain = 0
	var/obj/item/eye_protection
	var/obj/item/face_protection

	var/list/protection
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		protection = list(H.head, H.glasses, H.wear_mask)
		if(H.species && (H.species.flags & NO_PAIN))
			no_pain = 1 //TODO: living-level can_feel_pain() proc
	else
		protection = list(M.wear_mask)

	for(var/obj/item/I in protection)
		if(I)
			if(I.body_parts_covered & EYES)
				eyes_covered = 1
				eye_protection = I.name
			if((I.body_parts_covered & FACE) && !(I.item_flags & FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name

	var/message
	if(eyes_covered)
		if(!mouth_covered)
			message = SPAN_WARNING("Your [eye_protection] protects your eyes from the pepperspray!")
	else
		message = SPAN_WARNING("The pepperspray gets in your eyes!")
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, 15)
			M.eye_blind = max(M.eye_blind, 5)
		else
			M.eye_blurry = max(M.eye_blurry, 25)
			M.eye_blind = max(M.eye_blind, 10)

	if(mouth_covered)
		if(!message)
			message = SPAN_WARNING("Your [face_protection] protects you from the pepperspray!")
	else if(!no_pain)
		message = SPAN_DANGER("Your face and throat burn!")
		if(prob(25))
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
		M.Stun(5)
		M.Weaken(5)

/datum/reagent/organic/capsaicin/condensed/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && (H.species.flags & NO_PAIN))
			return
	if(dose == metabolism)
		to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
	else
		M.apply_effect(4, AGONY, 0)
		if(prob(5))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>", SPAN_DANGER("You feel like your insides are burning!"))
	if(isslime(M))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent("frostoil", 5)

/* Drinks */

/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	color = "#E78108"
	var/nutrition = 0 // Per metabolism tick
	var/adj_dizzy = 0 // Per metabolism tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0
	reagent_type = "Drink"

/datum/reagent/drink/affect_blood(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustToxLoss(0.2) // Probably not a good idea; not very deadly though
	return

/datum/reagent/drink/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	M.adjustNutrition(nutrition * effect_multiplier)
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.AdjustSleeping(adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices

/datum/reagent/drink/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#C3AF00"
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "banana"
	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/datum/reagent/drink/berryjuice
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "berryjuice"
	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/drink/carrotjuice
	name = "Carrot juice"
	id = "carrotjuice"
	description = "Has a uniquely sweet flavour of concentrated carrots."
	taste_description = "carrots"
	color = "#FF8C00" // rgb: 255, 140, 0
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "carrotjuice"
	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/datum/reagent/drink/carrotjuice/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.reagents.add_reagent("imidazoline", effect_multiplier * 0.1)

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	description = "The juice is often sold in stores or fermented and made into wine, brandy, or vinegar."
	taste_description = "grapes"
	color = "#863333"
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "grapejuice"
	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/lemonjuice
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "Used to make lemonade, soft drinks, and cocktails."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#AFAF00"
	taste_tag = list(TASTE_BITTER,TASTE_SOUR)

	glass_icon_state = "lemonjuice"
	glass_name = "lemon juice"
	glass_desc = "Sour..."

/datum/reagent/drink/limejuice
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	taste_description = "unbearable sourness"
	taste_mult = 1.1
	color = "#365E30"
	taste_tag = list(TASTE_BITTER,TASTE_SOUR)

	glass_icon_state = "glass_green"
	glass_name = "lime juice"
	glass_desc = "It's some sweet-sour lime juice"

/datum/reagent/drink/limejuice/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.adjustToxLoss(-0.05 * effect_multiplier)

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	id = "orangejuice"
	description = "Liquid extract of the orange tree fruit, produced by squeezing or reaming oranges."
	taste_description = "oranges"
	color = "#E78108"
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "glass_orange"
	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/orangejuice/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.adjustOxyLoss(-0.2 * effect_multiplier)

/datum/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	taste_description = "berries"
	color = "#863353"
	strength = 5

	glass_icon_state = "poisonberryjuice"
	glass_name = "poison berry juice"
	glass_desc = "Looks like some deadly juice."

/datum/reagent/drink/potato_juice
	name = "Potato Juice"
	id = "potato"
	description = "Juice of the potato. Best served fresh."
	taste_description = "irish sadness"
	nutrition = 2
	color = "#302000"
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "glass_brown"
	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Juice made from tomatoes, usually used as a beverage, either plain or in cocktails"
	taste_description = "tomatoes"
	color = "#731008"
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "glass_red"
	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/drink/tomatojuice/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.heal_organ_damage(0, 0.05 * effect_multiplier)

/datum/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#B83333"
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "glass_red"
	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

// Everything else
/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	taste_description = "milk"
	color = "#DFDFDF"
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "glass_white"
	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.heal_organ_damage(0.05 * effect_multiplier, 0)
	holder.remove_reagent("capsaicin", 1 * effect_multiplier)

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "Dairy product composed of the higher-fat layer skimmed from the top of milk before homogenization."
	taste_description = "creamy milk"
	color = "#DFD7AF"
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "glass_white"
	glass_name = "cream"
	glass_desc = "Ewwww..."

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#DFDFC7"
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "glass_white"
	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea. Contains caffeine."
	taste_description = "tart black tea"
	color = "#AC3700"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20
	taste_tag = list(TASTE_LIGHT,TASTE_BITTER)

	glass_icon_state = "teaglass"
	glass_name = "black tea"
	glass_desc = "Tasty black tea. It has antioxidants; it's good for you!"

/datum/reagent/drink/tea/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.adjustToxLoss(-0.05 * effect_multiplier)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "A form of cold tea. Though usually served in a glass with ice"
	taste_description = "sweet tea"
	color = "#B43A003"
	adj_temp = -5
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "icedteaglass"
	glass_name = "iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_center_of_mass = list("x"=15, "y"=10)

//green tea
/datum/reagent/drink/tea/green
	name = "Green Tea"
	id = "greentea"
	taste_description = "subtle green tea"
	color = "#C33F00"
	glass_name = "green tea"
	glass_desc = "Tasty green tea. It has antioxidants; it's good for you!"
	taste_tag = list(TASTE_LIGHT)

/datum/reagent/drink/tea/icetea/green
	name = "Iced Green Tea"
	id = "icegreentea"
	taste_description = "cold green tea"
	color = "#CE4200"
	glass_name = "iced green tea"
	glass_desc = "It looks like green tea with ice. One might even call it iced green tea."
	taste_tag = list(TASTE_LIGHT)

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	taste_description = "bitterness"
	taste_mult = 1.3
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = 45
	taste_tag = list(TASTE_BITTER)

	glass_icon_state = "hot_coffee"
	glass_name = "coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	if(adj_temp > 0)
		holder.remove_reagent("frostoil", 1 * effect_multiplier)
	// Coffee is really bad for you with busted kidneys.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/kidney/K = H.random_organ_by_process(OP_KIDNEYS)
		if(istype(K))
			if(K.is_bruised())
				M.adjustToxLoss(0.1)
			else if(K.is_broken())
				M.adjustToxLoss(0.3)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/drink/coffee/overdose(mob/living/carbon/M, alien)
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	taste_description = "bitter coldness"
	color = "#102838"
	adj_temp = -5
	taste_tag = list(TASTE_BITTER)

	glass_icon_state = "icedcoffeeglass"
	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A coffee drink made with espresso and steamed soy milk."
	taste_description = "creamy coffee"
	color = "#664300"
	adj_temp = 5
	taste_tag = list(TASTE_BITTER)

	glass_icon_state = "soy_latte"
	glass_name = "soy latte"
	glass_desc = "A nice and refrshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/soy_latte/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.heal_organ_damage(0.05 * effect_multiplier, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	taste_description = "bitter cream"
	color = "#664300" // rgb: 102, 67, 0
	adj_temp = 5
	taste_tag = list(TASTE_BITTER)

	glass_icon_state = "cafe_latte"
	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/cafe_latte/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.heal_organ_damage(0.05 * effect_multiplier, 0)

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "A heated drink consisting melted chocolate and heated milk."
	taste_description = "creamy chocolate"
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "chocolateglass"
	glass_name = "hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/datum/reagent/drink/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "Water containing dissolved carbon dioxide gas."
	taste_description = "carbonated water"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5
	taste_tag = list(TASTE_SWEET,TASTE_BUBBLY)

	glass_icon_state = "glass_clear"
	glass_name = "soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"

/datum/reagent/drink/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	description = "Sweetened drink with a grape flavor and a deep purple color."
	taste_description = "grape soda"
	color = "#421C52"
	adj_drowsy = -3
	taste_tag = list(TASTE_SWEET,TASTE_BUBBLY)

	glass_icon_state = "gsodaglass"
	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"

/datum/reagent/drink/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "A carbonated soft drink in which quinine is dissolved. "
	taste_description = "tart and fresh"
	color = "#664300"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5
	taste_tag = list(TASTE_BUBBLY)

	glass_icon_state = "glass_clear"
	glass_name = "tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/lemonade
	name = "Lemonade"
	description = "Drink using lemon juice, water, and a sweetener such as cane sugar or honey."
	taste_description = "tartness"
	id = "lemonade"
	color = "#FFFF00"
	adj_temp = -5
	taste_tag = list(TASTE_SWEET,TASTE_SOUR)

	glass_icon_state = "lemonadeglass"
	glass_name = "lemonade"
	glass_desc = "Oh the nostalgia..."

/datum/reagent/drink/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	taste_description = "fruity sweetness"
	id = "kiraspecial"
	color = "#CCCC99"
	adj_temp = -5
	taste_tag = list(TASTE_SWEET,TASTE_BUBBLY)

	glass_icon_state = "kiraspecial"
	glass_name = "Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/drink/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	taste_description = "orange and cola soda"
	id = "brownstar"
	color = "#9F3400"
	adj_temp = -2
	taste_tag = list(TASTE_SWEET,TASTE_BUBBLY)

	glass_icon_state = "brownstar"
	glass_name = "Brown Star"
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/milkshake
	name = "Milkshake"
	description = "Sweet, cold beverage that is usually made from milk"
	taste_description = "creamy vanilla"
	id = "milkshake"
	color = "#AEE5E4"
	adj_temp = -9
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "milkshake"
	glass_name = "milkshake"
	glass_desc = "Glorious brainfreezing mixture."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "a bad night out"
	id = "rewriter"
	color = "#485000"
	adj_temp = -5
	taste_tag = list(TASTE_SOUR)

	glass_icon_state = "rewriter"
	glass_name = "Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/drink/rewriter/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.make_jittery(5)

/datum/reagent/drink/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	description = "Cola, cola never changes."
	taste_description = "the future"
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2
	nerve_system_accumulations = 50
	taste_tag = list(TASTE_SWEET,TASTE_BUBBLY)

	glass_icon_state = "nuka_colaglass"
	glass_name = "Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/drink/nuka_cola/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 0.8)
	M.make_jittery(20 * effect_multiplier)
	M.druggy = max(M.druggy, 30 * effect_multiplier)
	M.dizziness += 5 * effect_multiplier
	M.drowsyness = 0

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#FF004F"
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "grenadineglass"
	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/space_cola
	name = "Space Cola"
	id = "cola"
	description = "A refreshing beverage."
	taste_description = "cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5
	taste_tag = list(TASTE_SWEET,TASTE_BUBBLY)

	glass_icon_state  = "glass_brown"
	glass_name = "Space Cola"
	glass_desc = "Ah, refreshing Space Cola!"

/datum/reagent/drink/spacemountainwind
	name = "Mountain Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	taste_description = "sweet citrus soda"
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5
	taste_tag = list(TASTE_LIGHT)

	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."

/datum/reagent/drink/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5
	taste_tag = list(TASTE_SOUR,TASTE_BITTER,TASTE_SWEET,TASTE_STRONG, TASTE_LIGHT, TASTE_BUBBLY, TASTE_SPICY, TASTE_SALTY)

	glass_icon_state = "dr_gibb_glass"
	glass_name = "Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	taste_description = "a hull breach"
	color = "#202800"
	adj_temp = -8
	taste_tag = list(TASTE_STRONG,TASTE_BUBBLY)

	glass_icon_state = "space-up_glass"
	glass_name = "Space-up"
	glass_desc = "Space-up. It helps keep your cool."

/datum/reagent/drink/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of lime and lemon."
	taste_description = "tangy lime and lemon soda"
	id = "lemon_lime"
	color = "#878F00"
	adj_temp = -8
	taste_tag = list(TASTE_SOUR)

	glass_icon_state = "lemonlime"
	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	taste_description = "homely fruit"
	reagent_state = LIQUID
	color = "#FF8CFF"
	nutrition = 1
	taste_tag = list(TASTE_SWEET)

	glass_icon_state = "doctorsdelightglass"
	glass_name = "The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/drink/doctor_delight/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.adjustOxyLoss(-0.4 * effect_multiplier)
	M.heal_organ_damage(0.2 * effect_multiplier, 0.2 * effect_multiplier)
	M.adjustToxLoss(-0.2 * effect_multiplier)
	if(M.dizziness)
		M.dizziness = max(0, M.dizziness - 15 * effect_multiplier)
	if(M.confused)
		M.confused = max(0, M.confused - 5 * effect_multiplier)

/datum/reagent/drink/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry and cheap noodles"
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/drink/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5
	taste_tag = list(TASTE_SLIMEY)

/datum/reagent/drink/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles on fire"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	taste_tag = list(TASTE_SLIMEY,TASTE_SPICY)

/datum/reagent/drink/hell_ramen/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/drink/ice
	name = "Ice"
	id = "ice"
	description = "Water frozen into a solid state."
	taste_description = "ice"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5
	taste_tag = list(TASTE_REFRESHING)

	glass_icon_state = "iceglass"
	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

/datum/reagent/drink/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_icon_state = "nothing"
	glass_name = "nothing"
	glass_desc = "Absolutely nothing."

/* Alcohol */

// Basic

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "A anise-flavoured spirit derived from botanicals."
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33EE00"
	strength = 12

	glass_icon_state = "absintheglass"
	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."
	glass_center_of_mass = list("x"=16, "y"=5)
	taste_tag = list(TASTE_BITTER,TASTE_STRONG)

/datum/reagent/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#664300"
	strength = 25

	glass_icon_state = "aleglass"
	glass_name = "ale"
	glass_desc = "A freezing pint of delicious ale"
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_STRONG,TASTE_BITTER)

/datum/reagent/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#664300"
	strength = 35
	nutriment_factor = 1

	glass_icon_state = "beerglass"
	glass_name = "beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_BUBBLY)

/datum/reagent/ethanol/beer/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.jitteriness = max(M.jitteriness - 3 * effect_multiplier, 0)

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000CD"
	strength = 15

	glass_icon_state = "curacaoglass"
	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."
	glass_center_of_mass = list("x"=16, "y"=5)
	taste_tag = list(TASTE_STRONG,TASTE_SWEET)

/datum/reagent/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#AB3C05"
	strength = 15

	glass_icon_state = "cognacglass"
	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	glass_center_of_mass = list("x"=16, "y"=6)
	taste_tag = list(TASTE_SWEET,TASTE_STRONG)

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	id = "deadrum"
	description = "Distilled alcoholic drink made from saltwater."
	taste_description = "salty sea water"
	color = "#664300"
	strength = 30

	glass_icon_state = "rumglass"
	glass_name = "rum"
	glass_desc = "Popular with the sailors. Not very popular with everyone else."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_SALTY, TASTE_STRONG)

/datum/reagent/ethanol/deadrum/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.dizziness += 5 * effect_multiplier

/datum/reagent/ethanol/gin
	name = "Gin"
	id = "gin"
	description = "A distilled alcoholic drink that derives its predominant flavour from juniper berries."
	taste_description = "an alcoholic christmas tree"
	color = "#664300"
	strength = 25
	taste_tag = list(TASTE_STRONG,TASTE_DRY)

	glass_icon_state = "ginvodkaglass"
	glass_name = "gin"
	glass_desc = "Crystal clear Griffeater gin."
	glass_center_of_mass = list("x"=16, "y"=12)

//Base type for alchoholic drinks containing coffee
/datum/reagent/ethanol/coffee
	overdose = 45
	taste_tag = list(TASTE_BITTER,TASTE_SWEET)

/datum/reagent/ethanol/coffee/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.dizziness = max(0, M.dizziness - 5 * effect_multiplier)
	M.drowsyness = max(0, M.drowsyness - 3 * effect_multiplier)
	M.sleeping = max(0, M.sleeping - 2 * effect_multiplier)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT) * effect_multiplier)

/datum/reagent/ethanol/coffee/overdose(mob/living/carbon/M, alien)
	M.make_jittery(5)

/datum/reagent/ethanol/coffee/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur."
	taste_description = "spiked latte"
	taste_mult = 1.1
	color = "#664300"
	strength = 25

	glass_icon_state = "kahluaglass"
	glass_name = "RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"
	glass_center_of_mass = list("x"=15, "y"=7)
	taste_tag = list(TASTE_SWEET, TASTE_BITTER)

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 30

	glass_icon_state = "emeraldglass"
	glass_name = "melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."
	glass_center_of_mass = list("x"=16, "y"=5)
	taste_tag = list(TASTE_SWEET)

/datum/reagent/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Distilled alcoholic drink made from sugarcane byproducts"
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#664300"
	strength = 15

	glass_icon_state = "rumglass"
	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_BITTER,TASTE_SWEET)

/datum/reagent/ethanol/sake
	name = "Sake"
	id = "sake"
	description = " Alcoholic beverage made by fermenting rice that has been polished."
	taste_description = "dry alcohol"
	color = "#664300"
	strength = 25

	glass_icon_state = "ginvodkaglass"
	glass_name = "sake"
	glass_desc = "Wine made from rice: it's sake!"
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_SWEET)

/datum/reagent/ethanol/tequilla
	name = "Tequila"
	id = "tequilla"
	description = "A strong and mildly flavoured, mexican produced spirit."
	taste_description = "paint stripper"
	color = "#FFFF91"
	strength = 25

	glass_icon_state = "tequillaglass"
	glass_name = "Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_STRONG)

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "A potent mixture of caffeine and alcohol."
	taste_description = "jitters and death"
	color = "#102000"
	strength = 25
	nutriment_factor = 1
	taste_tag = list(TASTE_BITTER,TASTE_BUBBLY)

	glass_icon_state = "thirteen_loko_glass"
	glass_name = "Thirteen Loko"
	glass_desc = "This is a container of Thirteen Loko, it appears to be of the highest quality. The drink, not the container."

/datum/reagent/ethanol/thirteenloko/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.drowsyness = max(0, M.drowsyness - 7 * effect_multiplier)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT) * effect_multiplier)
	M.make_jittery(5 * effect_multiplier)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	id = "vermouth"
	description = "Aromatized, fortified white wine flavored with various botanicals."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 15

	glass_icon_state = "vermouthglass"
	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_BITTER,TASTE_SWEET)

/datum/reagent/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Clear distilled alcoholic beverage that originates from Poland and Russia."
	taste_description = "grain alcohol"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 5

	glass_icon_state = "ginvodkaglass"
	glass_name = "vodka"
	glass_desc = "Number one drink and fueling choice for Russians worldwide."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_STRONG)

/datum/reagent/ethanol/vodka/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.apply_effect(max(M.radiation - 0.1 * effect_multiplier, 0), IRRADIATE, check_protection = 0)

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A type of distilled alcoholic beverage made from fermented grain mash."
	taste_description = "molasses"
	color = "#664300"
	strength = 25

	glass_icon_state = "whiskeyglass"
	glass_name = "whiskey"
	glass_desc = "The silky, smoky whiskey goodness inside makes the drink look very classy."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_STRONG,TASTE_SWEET)

/datum/reagent/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15

	glass_icon_state = "wineglass"
	glass_name = "wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)
	taste_tag = list(TASTE_SWEET, TASTE_BITTER)

/datum/reagent/ethanol/ntcahors
	name = "NeoTheology Cahors Wine"
	id = "ntcahors"
	description = "Fortified dessert wine made from cabernet sauvignon, saperavi and other grapes."
	taste_description = "sweet charcoal"
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 30

	glass_icon_state = "wineglass"
	glass_name = "cahors"
	glass_desc = "It looks like wine, but more dark."
	glass_center_of_mass = list("x"=15, "y"=7)
	taste_tag = list(TASTE_SWEET, TASTE_BITTER)

/datum/reagent/ethanol/ntcahors/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.adjust_hallucination(-0.9 * effect_multiplier)
	M.adjustToxLoss(-0.5 * effect_multiplier)

// Cocktails
/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#365000"
	strength = 30

	glass_icon_state = "acidspitglass"
	glass_name = "Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."
	glass_center_of_mass = list("x"=16, "y"=7)
	taste_tag = list(TASTE_SOUR)

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	taste_description = "bitter yet free"
	color = "#664300"
	strength = 25

	glass_icon_state = "alliescocktail"
	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_BITTER,TASTE_DRY)

/datum/reagent/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "So very, very, very good."
	taste_description = "sweet 'n creamy"
	color = "#664300"
	strength = 15

	glass_icon_state = "aloe"
	glass_name = "Aloe"
	glass_desc = "Very, very, very good."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_SWEET,TASTE_SLIMEY)

/datum/reagent/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Official drink of the Gun Club!"
	taste_description = "dark and metallic"
	reagent_state = LIQUID
	color = "#664300"
	strength = 25

	glass_icon_state = "amasecglass"
	glass_name = "Amasec"
	glass_desc = "Always handy before COMBAT!!!"
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_SALTY,TASTE_DRY)

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "A nice, strangely named drink."
	taste_description = "lemons"
	color = "#664300"
	strength = 15

	glass_icon_state = "andalusia"
	glass_name = "Andalusia"
	glass_desc = "A nice, strange named drink."
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_SOUR)

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ultimate refreshment."
	taste_description = "Jack Frost's piss"
	color = "#664300"
	strength = 12
	adj_temp = 20
	targ_temp = 330

	glass_icon_state = "antifreeze"
	glass_name = "Anti-freeze"
	glass_desc = "The ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_STRONG,TASTE_SOUR,TASTE_REFRESHING)

/datum/reagent/ethanol/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Nuclear proliferation never tasted so good."
	taste_description = "da bomb"
	reagent_state = LIQUID
	color = "#666300"
	strength = 5
	druggy = 50

	glass_icon_state = "atomicbombglass"
	glass_name = "Atomic Bomb"
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."
	glass_center_of_mass = list("x"=15, "y"=7)
	taste_tag = list(TASTE_BUBBLY)

/datum/reagent/ethanol/coffee/b52
	name = "B-52"
	id = "b52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	taste_description = "angry and irish"
	taste_mult = 1.3
	color = "#664300"
	strength = 10

	glass_icon_state = "b52glass"
	glass_name = "B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."
	taste_tag = list(TASTE_BITTER,TASTE_STRONG)

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Tropical cocktail."
	taste_description = "lime and orange"
	color = "#FF7F3B"
	strength = 15

	glass_icon_state = "bahama_mama"
	glass_name = "Bahama Mama"
	glass_desc = "Tropical cocktail"
	glass_center_of_mass = list("x"=16, "y"=5)
	taste_tag = list(TASTE_SWEET)

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	taste_description = "a bad joke"
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 6

	glass_icon_state = "bananahonkglass"
	glass_name = "Banana Honk"
	glass_desc = "A drink from Banana Heaven."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_SWEET)

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Barefoot and pregnant"
	taste_description = "creamy berries"
	color = "#664300"
	strength = 10

	glass_icon_state = "b&p"
	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant"
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_SWEET)

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
	description = "Deny drinking this and prepare for THE LAW."
	taste_description = "JUSTICE"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#664300"
	strength = 12

	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
	glass_center_of_mass = list("x"=18, "y"=10)
	taste_tag = list(TASTE_STRONG,TASTE_SOUR)

/datum/reagent/ethanol/beepsky_smash/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.Stun(2)

/datum/reagent/ethanol/bilk
	name = "Bilk"
	id = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "desperation and lactate"
	color = "#895C4C"
	strength = 40
	nutriment_factor = 2

	glass_icon_state = "glass_brown"
	glass_name = "bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."
	taste_tag = list(TASTE_BUBBLY,TASTE_BITTER)

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	taste_description = "bitterness"
	color = "#360000"
	strength = 15

	glass_icon_state = "blackrussianglass"
	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_BITTER)

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Tastes like liquid murder"
	taste_description = "tomatoes with a hint of lime"
	color = "#664300"
	strength = 15

	glass_icon_state = "bloodymaryglass"
	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."
	taste_tag = list(TASTE_SALTY,TASTE_REFRESHING)

/datum/reagent/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Ewww..."
	taste_description = "sweet 'n creamy"
	color = "#8CFF8C"
	strength = 30

	glass_icon_state = "booger"
	glass_name = "Booger"
	glass_desc = "Ewww..."
	taste_tag = list(TASTE_SWEET,TASTE_SALTY)

/datum/reagent/ethanol/coffee/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "It's just as effective as Dutch-Courage!"
	taste_description = "alcoholic bravery"
	taste_mult = 1.1
	color = "#664300"
	strength = 15

	glass_icon_state = "bravebullglass"
	glass_name = "Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."
	glass_center_of_mass = list("x"=15, "y"=8)
	taste_tag = list(TASTE_STRONG,TASTE_DRY)

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "You take a tiny sip and feel a burning sensation..."
	taste_description = "your brain coming out your nose"
	color = "#2E6671"
	strength = 5

	glass_icon_state = "changelingsting"
	glass_name = "Changeling Sting"
	glass_desc = "A stingy drink."
	taste_tag = list(TASTE_STRONG,TASTE_SOUR)

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "dry class"
	color = "#664300"
	strength = 15

	glass_icon_state = "martiniglass"
	glass_name = "classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_SALTY,TASTE_DRY)

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Rum, mixed with cola. Viva la revolucion."
	taste_description = "cola"
	color = "#3E1B00"
	strength = 10

	glass_icon_state = "cubalibreglass"
	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum and cola."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_BUBBLY,TASTE_SWEET)

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "AHHHH!!!!"
	taste_description = "sweet tasting iron"
	taste_mult = 1.5
	color = "#820000"
	strength = 10

	glass_icon_state = "demonsblood"
	glass_name = "Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."
	glass_center_of_mass = list("x"=16, "y"=2)
	taste_tag = list(TASTE_SPICY,TASTE_DRY)

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "Creepy time!"
	taste_description = "bitter iron"
	color = "#A68310"
	strength = 15

	glass_icon_state = "devilskiss"
	glass_name = "Devil's Kiss"
	glass_desc = "Creepy time!"
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_BITTER,TASTE_DRY,TASTE_SLIMEY)

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	taste_description = "a beach"
	nutriment_factor = 1
	color = "#2E6671"
	strength = 12

	glass_icon_state = "driestmartiniglass"
	glass_name = "Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_BITTER,TASTE_DRY) //and again TASTE_DRY just for the extra

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#664300"
	strength = 25

	glass_icon_state = "ginfizzglass"
	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."
	glass_center_of_mass = list("x"=16, "y"=7)
	taste_tag = list(TASTE_BUBBLY,TASTE_SOUR,TASTE_DRY)

/datum/reagent/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Watered-down rum, pirate approved!"
	taste_description = "a poor excuse for alcohol"
	reagent_state = LIQUID
	color = "#664300"
	strength = 90

	glass_icon_state = "grogglass"
	glass_name = "grog"
	glass_desc = "A fine and cepa drink for Space."
	taste_tag = list(TASTE_STRONG)

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "The surprise is, it's green!"
	taste_description = "tartness and bananas"
	color = "#2E6671"
	strength = 10

	glass_icon_state = "erikasurprise"
	glass_name = "Erika Surprise"
	glass_desc = "The surprise is, it's green!"
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_SWEET)


/datum/reagent/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	taste_mult = 5
	reagent_state = LIQUID
	color = "#664300"
	strength = 1

	glass_icon_state = "gargleblasterglass"
	glass_name = "Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
	glass_center_of_mass = list("x"=17, "y"=6)
	taste_tag = list(TASTE_SOUR, TASTE_SPICY,TASTE_STRONG)

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "An all time classic, mild cocktail."
	taste_description = "mild and tart"
	color = "#664300"
	strength = 20

	glass_icon_state = "gintonicglass"
	glass_name = "gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."
	glass_center_of_mass = list("x"=16, "y"=7)
	taste_tag = list(TASTE_STRONG,TASTE_SOUR,TASTE_DRY)

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	taste_description = "burning cinnamon"
	taste_mult = 1.3
	color = "#664300"
	strength = 15

	glass_icon_state = "ginvodkaglass"
	glass_name = "Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_LIGHT,TASTE_DRY)

/datum/reagent/ethanol/hippies_delight
	name = "Hippies' Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	taste_description = "giving peace a chance"
	reagent_state = LIQUID
	color = "#664300"
	strength = 15
	druggy = 50

	glass_icon_state = "hippiesdelightglass"
	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_SWEET,TASTE_LIGHT)

/datum/reagent/ethanol/hooch
	name = "Hooch"
	id = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#664300"
	strength = 1
	toxicity = 2

	glass_icon_state = "glass_brown2"
	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_tag = list(TASTE_BITTER,TASTE_DRY)

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "A beer which is so cold the air around it freezes."
	taste_description = "refreshingly cold"
	color = "#664300"
	strength = 20
	adj_temp = -20
	targ_temp = 270

	glass_icon_state = "iced_beerglass"
	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_center_of_mass = list("x"=16, "y"=7)
	taste_tag = list(TASTE_BUBBLY, TASTE_STRONG,TASTE_REFRESHING)

/datum/reagent/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Mmm, tastes like chocolate cake..."
	taste_description = "delicious anger"
	color = "#2E6671"
	strength = 15

	glass_icon_state = "irishcarbomb"
	glass_name = "Irish Car Bomb"
	glass_desc = "An irish car bomb."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_BUBBLY,TASTE_SWEET,TASTE_BITTER)

/datum/reagent/ethanol/coffee/irishcoffee
	name = "Irish Coffee"
	id = "irishcoffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	taste_description = "giving up on the day"
	color = "#664300"
	strength = 15

	glass_icon_state = "irishcoffeeglass"
	glass_name = "Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
	glass_center_of_mass = list("x"=15, "y"=10)
	taste_tag = list(TASTE_SWEET,TASTE_BITTER)

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	taste_description = "creamy alcohol"
	color = "#664300"
	strength = 25

	glass_icon_state = "irishcreamglass"
	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_STRONG,TASTE_SWEET)

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	taste_description = "a mixture of cola and alcohol"
	color = "#664300"
	strength = 12

	glass_icon_state = "longislandicedteaglass"
	glass_name = "Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_LIGHT,TASTE_SWEET)

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	taste_description = "mild dryness"
	color = "#664300"
	strength = 15

	glass_icon_state = "manhattanglass"
	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_LIGHT,TASTE_BITTER)

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	taste_description = "death, the destroyer of worlds"
	color = "#664300"
	strength = 10
	druggy = 30

	glass_icon_state = "proj_manhattanglass"
	glass_name = "Manhattan Project"
	glass_desc = "A scienitst drink of choice, for thinking how to blow up the station."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_LIGHT,TASTE_DRY)

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	taste_description = "hair on your chest and your chin"
	color = "#664300"
	strength = 25

	glass_icon_state = "manlydorfglass"
	glass_name = "The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."
	taste_tag = list(TASTE_BUBBLY,TASTE_STRONG)

/datum/reagent/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	taste_description = "dry and salty"
	color = "#8CFF8C"
	strength = 15

	glass_icon_state = "margaritaglass"
	glass_name = "margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_SALTY,TASTE_BITTER)

/datum/reagent/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	reagent_state = LIQUID
	color = "#664300"
	strength = 30
	nutriment_factor = 1

	glass_icon_state = "meadglass"
	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."
	glass_center_of_mass = list("x"=17, "y"=10)
	taste_tag = list(TASTE_SWEET, TASTE_STRONG)

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#664300"
	strength = 12

	glass_icon_state = "glass_clear"
	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_tag = list(TASTE_BITTER,TASTE_STRONG)

/datum/reagent/ethanol/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "a numbing sensation"
	reagent_state = LIQUID
	color = "#2E2E61"
	strength = 10

	glass_icon_state = "neurotoxinglass"
	glass_name = "Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_STRONG,TASTE_SLIMEY)

/datum/reagent/ethanol/neurotoxin/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	M.Weaken(3 * effect_multiplier)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/ethanol/patron
	name = "Patron"
	id = "patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic and expensive"
	color = "#585840"
	strength = 20

	glass_icon_state = "patronglass"
	glass_name = "Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	glass_center_of_mass = list("x"=7, "y"=8)
	taste_tag = list(TASTE_STRONG)

/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	id = "pwine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	taste_description = "purified alcoholic death"
	color = "#000000"
	strength = 1
	druggy = 50
	halluci = 10

	glass_icon_state = "pwineglass"
	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	glass_center_of_mass = list("x"=16, "y"=5)
	taste_tag = list(TASTE_SPICY,TASTE_SWEET,TASTE_BITTER)

/datum/reagent/ethanol/pwine/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	if(dose > 30)
		M.adjustToxLoss(0.2 * effect_multiplier)
	if(dose > 60 && ishuman(M) && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.random_organ_by_process(OP_HEART)
		if(L && istype(L))
			if(dose < 120)
				L.take_damage(1 * effect_multiplier, 0)
			else
				L.take_damage(10 * effect_multiplier, 0)

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#C73C00"
	strength = 30

	glass_icon_state = "red_meadglass"
	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."
	glass_center_of_mass = list("x"=17, "y"=10)
	taste_tag = list(TASTE_SWEET, TASTE_SALTY)

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "A spicy Vodka! Might be a little hot for the little guys!"
	taste_description = "hot and spice"
	color = "#664300"
	strength = 5
	adj_temp = 50
	targ_temp = 360

	glass_icon_state = "sbitenglass"
	glass_name = "Sbiten"
	glass_desc = "A spicy mix of Vodka and Spice. Very hot."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_SPICY,TASTE_SLIMEY)

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	taste_description = "oranges"
	color = "#A68310"
	strength = 15

	glass_icon_state = "screwdriverglass"
	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
	glass_center_of_mass = list("x"=15, "y"=10)
	taste_tag = list(TASTE_SOUR,TASTE_SWEET)

/datum/reagent/ethanol/silencer
	name = "Silencer"
	id = "silencer"
	description = "A drink from Mime Heaven."
	taste_description = "a pencil eraser"
	taste_mult = 1.2
	nutriment_factor = 1
	color = "#664300"
	strength = 12

	glass_icon_state = "silencerglass"
	glass_name = "Silencer"
	glass_desc = "A drink from mime Heaven."
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_SWEET,TASTE_DRY)

/datum/reagent/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "A blue-space beverage!"
	taste_description = "concentrated matter"
	color = "#2E6671"
	strength = 10

	glass_icon_state = "singulo"
	glass_name = "Singulo"
	glass_desc = "A blue-space beverage."
	glass_center_of_mass = list("x"=17, "y"=4)
	taste_tag = list(TASTE_BITTER,TASTE_STRONG)

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "A cold refreshment"
	taste_description = "refreshing cold"
	color = "#FFFFFF"
	strength = 20

	glass_icon_state = "snowwhite"
	glass_name = "Snow White"
	glass_desc = "A cold refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)
	taste_tag = list(TASTE_LIGHT,TASTE_REFRESHING)

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	id = "suidream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	taste_description = "fruit"
	color = "#00A86B"
	strength = 50

	glass_icon_state = "sdreamglass"
	glass_name = "Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."
	glass_center_of_mass = list("x"=16, "y"=5)
	taste_tag = list(TASTE_BUBBLY,TASTE_SWEET)

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Tastes like terrorism!"
	taste_description = "purified antagonism"
	color = "#2E6671"
	strength = 10

	glass_icon_state = "syndicatebomb"
	glass_name = "Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"
	glass_center_of_mass = list("x"=16, "y"=4)
	taste_tag = list(TASTE_STRONG,TASTE_DRY)

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	id = "tequillasunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	taste_description = "oranges"
	color = "#FFE48C"
	strength = 25

	glass_icon_state = "tequillasunriseglass"
	glass_name = "Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."
	taste_tag = list(TASTE_SOUR, TASTE_STRONG)

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Made for a woman, strong enough for a man."
	taste_description = "dry"
	color = "#666340"
	strength = 10
	druggy = 50

	glass_icon_state = "threemileislandglass"
	glass_name = "Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."
	glass_center_of_mass = list("x"=16, "y"=2)
	taste_tag = list(TASTE_DRY,TASTE_STRONG) // well desc says strong enough for a man so lets make it.. strong. the heck

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	id = "plasmaspecial"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	taste_description = "spicy toxins"
	reagent_state = LIQUID
	color = "#664300"
	strength = 10
	adj_temp = 15
	targ_temp = 330

	glass_icon_state = "toxinsspecialglass"
	glass_name = "Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"
	taste_tag = list(TASTE_SPICY)

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "shaken, not stirred"
	color = "#664300"
	strength = 12

	glass_icon_state = "martiniglass"
	glass_name = "vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."
	glass_center_of_mass = list("x"=17, "y"=8)
	taste_tag = list(TASTE_LIGHT,TASTE_SOUR)

/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "For when a gin and tonic isn't russian enough."
	taste_description = "tart bitterness"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_icon_state = "vodkatonicglass"
	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."
	glass_center_of_mass = list("x"=16, "y"=7)
	taste_tag = list(TASTE_BITTER,TASTE_SOUR)

/datum/reagent/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "That's just, like, your opinion, man..."
	taste_description = "bitter cream"
	color = "#A68340"
	strength = 15

	glass_icon_state = "whiterussianglass"
	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_BITTER,TASTE_SLIMEY)


/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	taste_description = "cola"
	color = "#3E1B00"
	strength = 25

	glass_icon_state = "whiskeycolaglass"
	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_BUBBLY,TASTE_SWEET)

/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "For the more refined griffon."
	color = "#664300"
	strength = 15

	glass_icon_state = "whiskeysodaglass2"
	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=9)
	taste_tag = list(TASTE_BUBBLY,TASTE_SWEET,TASTE_STRONG)

/datum/reagent/ethanol/specialwhiskey // I have no idea what this is and where it comes from
	name = "Special Blend Whiskey"
	id = "specialwhiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	taste_description = "the whiskey gods pissed in your mouth"
	color = "#664300"
	strength = 5

	glass_icon_state = "whiskeyglass"
	glass_name = "special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_LIGHT,TASTE_STRONG)

/datum/reagent/ethanol/atomic_vodka
	name = "Atomic Vodka"
	id = "atomvodka"
	description = "Clear distilled alcoholic beverage that originates from Poland and Russia, now with nuclear taste!"
	taste_description = "strong grain alcohol"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 5
	strength_mod = 10
	toxicity = 10

	glass_icon_state = "ginvodkaglass"
	glass_name = "atomic vodka"
	glass_desc = "Booze for true drunkers."
	glass_center_of_mass = list("x"=16, "y"=12)
	taste_tag = list(TASTE_STRONG)

/datum/reagent/ethanol/atomic_vodka/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	..()
	if(!M.stats.getTempStat(STAT_TGH, "atomvodka") && M.stats.getPerk(/datum/perk/sommelier))
		M.stats.addTempStat(STAT_TGH, STAT_LEVEL_ADEPT, 10 MINUTES, "atomvodka")
