
/obj/item/device/scanner/plant
	name = "plant analyzer"
	desc = "A hand-held botanical scanner used to analyze plants."
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"
	rarity_value = 50

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)

	var/global/list/valid_targets = list(
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/grown,
		/obj/machinery/portable_atmospherics/hydroponics,
		/obj/machinery/beehive,
		/obj/item/seeds
	)

/obj/item/device/scanner/plant/is_valid_scan_target(atom/O)
	if(is_type_in_list(O,69alid_targets))
		return TRUE
	return FALSE

/obj/item/device/scanner/plant/scan(atom/A,69ob/user)
	scan_title = "69A69 at 69get_area(A)69"
	scan_data = plant_scan_results(A)
	flick("hydro2", src)
	show_results(user)

/proc/plant_scan_results(obj/target)
	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents

	var/dat = list()
	if(istype(target, /obj/machinery/beehive))
		var/obj/machinery/beehive/BH = target
		dat += SPAN_NOTICE("Scan result of \the 69BH69...")
		dat += "Beehive is 69BH.bee_count ? "69round(BH.bee_count)69% full" : "empty"69.69BH.bee_count > 90 ? " Colony is ready to split." : ""69"
		if(BH.frames)
			dat += "69BH.frames69 frames installed, 69round(BH.honeycombs / 100)69 filled."
			if(BH.honeycombs < BH.frames * 100)
				dat += "Next frame is 69round(BH.honeycombs % 100)69% full."
		else
			dat += "No frames installed."
		if(BH.smoked)
			dat += "The hive is smoked."
		return jointext(dat, "<br>")

	else if(istype(target,/obj/item/reagent_containers/food/snacks/grown))

		var/obj/item/reagent_containers/food/snacks/grown/G = target
		grown_seed = plant_controller.seeds69G.plantname69
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/grown))

		var/obj/item/grown/G = target
		grown_seed = plant_controller.seeds69G.plantname69
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/seeds))

		var/obj/item/seeds/S = target
		grown_seed = S.seed

	else if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))

		var/obj/machinery/portable_atmospherics/hydroponics/H = target
		grown_seed = H.seed
		grown_reagents = H.reagents

	var/form_title = "69grown_seed.seed_name69 (#69grown_seed.uid69)"
	dat += "<h3>Plant data for 69form_title69</h3>"

	dat += "<h2>General Data</h2>"

	dat += "<table>"
	dat += "<tr><td><b>Endurance</b></td><td>69grown_seed.get_trait(TRAIT_ENDURANCE)69</td></tr>"
	dat += "<tr><td><b>Yield</b></td><td>69grown_seed.get_trait(TRAIT_YIELD)69</td></tr>"
	dat += "<tr><td><b>Maturation time</b></td><td>69grown_seed.get_trait(TRAIT_MATURATION)69</td></tr>"
	dat += "<tr><td><b>Production time</b></td><td>69grown_seed.get_trait(TRAIT_PRODUCTION)69</td></tr>"
	dat += "<tr><td><b>Potency</b></td><td>69grown_seed.get_trait(TRAIT_POTENCY)69</td></tr>"
	dat += "</table>"

	if(grown_reagents && grown_reagents.reagent_list && grown_reagents.reagent_list.len)
		dat += "<h2>Reagent Data</h2>"

		dat += "<br>This sample contains: "
		for(var/datum/reagent/R in grown_reagents.reagent_list)
			dat += "<br>- 69R.id69, 69grown_reagents.get_reagent_amount(R.id)69 unit(s)"

	dat += "<h2>Other Data</h2>"

	if(grown_seed.get_trait(TRAIT_HARVEST_REPEAT))
		dat += "This plant can be harvested repeatedly.<br>"

	if(grown_seed.get_trait(TRAIT_IMMUTABLE) == -1)
		dat += "This plant is highly69utable.<br>"
	else if(grown_seed.get_trait(TRAIT_IMMUTABLE) > 0)
		dat += "This plant does not possess genetics that are alterable.<br>"

	if(grown_seed.get_trait(TRAIT_RE69UIRES_NUTRIENTS))
		if(grown_seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
			dat += "It consumes a small amount of nutrient fluid.<br>"
		else if(grown_seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
			dat += "It re69uires a heavy supply of nutrient fluid.<br>"
		else
			dat += "It re69uires a supply of nutrient fluid.<br>"

	if(grown_seed.get_trait(TRAIT_RE69UIRES_WATER))
		if(grown_seed.get_trait(TRAIT_WATER_CONSUMPTION) < 1)
			dat += "It re69uires69ery little water.<br>"
		else if(grown_seed.get_trait(TRAIT_WATER_CONSUMPTION) > 5)
			dat += "It re69uires a large amount of water.<br>"
		else
			dat += "It re69uires a stable supply of water.<br>"

	if(grown_seed.mutants && grown_seed.mutants.len)
		dat += "It exhibits a high degree of potential subspecies shift.<br>"

	dat += "It thrives in a temperature of 69grown_seed.get_trait(TRAIT_IDEAL_HEAT)69 Kelvin."

	if(grown_seed.get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
		dat += "<br>It is well adapted to low pressure levels."
	if(grown_seed.get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
		dat += "<br>It is well adapted to high pressure levels."

	if(grown_seed.get_trait(TRAIT_HEAT_TOLERANCE) > 30)
		dat += "<br>It is well adapted to a range of temperatures."
	else if(grown_seed.get_trait(TRAIT_HEAT_TOLERANCE) < 10)
		dat += "<br>It is69ery sensitive to temperature shifts."

	dat += "<br>It thrives in a light level of 69grown_seed.get_trait(TRAIT_IDEAL_LIGHT)69 lumen69grown_seed.get_trait(TRAIT_IDEAL_LIGHT) == 1 ? "" : "s"69."

	if(grown_seed.get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
		dat += "<br>It is well adapted to a range of light levels."
	else if(grown_seed.get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
		dat += "<br>It is69ery sensitive to light level shifts."

	if(grown_seed.get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to toxins."
	else if(grown_seed.get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to toxins."

	if(grown_seed.get_trait(TRAIT_PEST_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to pests."
	else if(grown_seed.get_trait(TRAIT_PEST_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to pests."

	if(grown_seed.get_trait(TRAIT_WEED_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to weeds."
	else if(grown_seed.get_trait(TRAIT_WEED_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to weeds."

	switch(grown_seed.get_trait(TRAIT_SPREAD))
		if(1)
			dat += "<br>It is able to be planted outside of a tray."
		if(2)
			dat += "<br>It is a robust and69igorous69ine that will spread rapidly."

	switch(grown_seed.get_trait(TRAIT_CARNIVOROUS))
		if(1)
			dat += "<br>It is carnivorous and will eat tray pests for sustenance."
		if(2)
			dat += "<br>It is carnivorous and poses a significant threat to living things around it."

	if(grown_seed.get_trait(TRAIT_PARASITE))
		dat += "<br>It is capable of parisitizing and gaining sustenance from tray weeds."
	if(grown_seed.get_trait(TRAIT_ALTER_TEMP))
		dat += "<br>It will periodically alter the local temperature by 69grown_seed.get_trait(TRAIT_ALTER_TEMP)69 degrees Kelvin."

	if(grown_seed.get_trait(TRAIT_BIOLUM))
		dat += "<br>It is 69grown_seed.get_trait(TRAIT_BIOLUM_COLOUR)  ? "<font color='69grown_seed.get_trait(TRAIT_BIOLUM_COLOUR)69'>bio-luminescent</font>" : "bio-luminescent"69."

	if(grown_seed.get_trait(TRAIT_PRODUCES_POWER))
		dat += "<br>The fruit will function as a battery if prepared appropriately."

	if(grown_seed.get_trait(TRAIT_STINGS))
		dat += "<br>The fruit is covered in stinging spines."

	if(grown_seed.get_trait(TRAIT_JUICY) == 1)
		dat += "<br>The fruit is soft-skinned and juicy."
	else if(grown_seed.get_trait(TRAIT_JUICY) == 2)
		dat += "<br>The fruit is excessively juicy."

	if(grown_seed.get_trait(TRAIT_EXPLOSIVE))
		dat += "<br>The fruit is internally unstable."

	if(grown_seed.get_trait(TRAIT_TELEPORTING))
		dat += "<br>The fruit is temporal/spatially unstable."

	if(grown_seed.get_trait(TRAIT_EXUDE_GASSES))
		dat += "<br>It will release gas into the environment."

	if(grown_seed.get_trait(TRAIT_CONSUME_GASSES))
		dat += "<br>It will remove gas from the environment."

	return JOINTEXT(dat)