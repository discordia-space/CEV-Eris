SUBSYSTEM_DEF(plants)
	name = "Plants"
	init_order = INIT_ORDER_PLANTS // keep this above SSatoms, seeds initialization depends on it
	wait = 75
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING

	var/list/current_run = list()

	var/list/product_descs = list()         // Stores generated fruit descs.
	var/list/plant_queue = list()           // All queued plants.
	var/list/seeds = list()                 // All seed data stored here.
	var/list/gene_tag_masks = list()        // Gene obfuscation for delicious trial and error goodness.
	var/list/plant_icon_cache = list()      // Stores images of growth, fruits and seeds.
	var/list/plant_sprites = list()         // List of all harvested product sprites.
	var/list/plant_product_sprites = list() // List of all growth sprites plus number of growth stages.

// Predefined/roundstart varieties use a string key to make it
// easier to grab the new variety when mutating. Post-roundstart
// and mutant varieties use their uid converted to a string instead.
// Looks like shit but it's sort of necessary.
/datum/controller/subsystem/plants/Initialize(start_timeofday)
	// Build the icon lists.
	for(var/icostate in icon_states('icons/obj/hydroponics_growing.dmi'))
		var/split = findtext(icostate,"-")
		if(!split)
			// invalid icon_state
			continue

		var/ikey = copytext(icostate,(split+1))
		if(ikey == "dead")
			// don't count dead icons
			continue
		ikey = text2num(ikey)
		var/base = copytext(icostate,1,split)

		if(!(plant_sprites[base]) || (plant_sprites[base]<ikey))
			plant_sprites[base] = ikey

	for(var/icostate in icon_states('icons/obj/hydroponics_products.dmi'))
		var/split = findtext(icostate,"-")
		if(split)
			plant_product_sprites |= copytext(icostate,1,split)

	// Populate the global seed datum list.
	for(var/type in typesof(/datum/seed)-/datum/seed)
		var/datum/seed/S = new type
		seeds[S.name] = S
		S.uid = "[seeds.len]"
		S.roundstart = 1

	//Might as well mask the gene types while we're at it.
	var/list/used_masks = list()
	var/list/plant_traits = ALL_GENES
	while(plant_traits && plant_traits.len)
		var/gene_tag = pick(plant_traits)
		var/gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		while(gene_mask in used_masks)
			gene_mask = "[uppertext(num2hex(rand(0,255)))]"

		used_masks += gene_mask
		plant_traits -= gene_tag
		gene_tag_masks[gene_tag] = gene_mask
	return ..()

/datum/controller/subsystem/plants/fire(resumed = 0)
	if (!resumed)
		src.current_run = plant_queue.Copy()

	var/list/current_run = src.current_run

	while(current_run.len)
		var/obj/effect/plant/plant = current_run[current_run.len]
		current_run.len--
		plant_queue -= plant

		if(!QDELETED(plant))
			plant.Process()

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/plants/stat_entry()
	..("P:[plant_queue.len]")

// Proc for creating a random seed type.
/datum/controller/subsystem/plants/proc/create_random_seed(survive_on_station)
	var/datum/seed/seed = new()
	seed.randomize()
	seed.uid = SSplants.seeds.len + 1
	seed.name = "[seed.uid]"
	seeds[seed.name] = seed

	if(survive_on_station)
		if(seed.consume_gasses)
			seed.consume_gasses["plasma"] = null
			seed.consume_gasses["carbon_dioxide"] = null
		if(seed.chems && !isnull(seed.chems["pacid"]))
			seed.chems["pacid"] = null // Eating through the hull will make these plants completely inviable, albeit very dangerous.
			seed.chems -= null // Setting to null does not actually remove the entry, which is weird.
		seed.set_trait(TRAIT_IDEAL_HEAT,293)
		seed.set_trait(TRAIT_HEAT_TOLERANCE,20)
		seed.set_trait(TRAIT_IDEAL_LIGHT,8)
		seed.set_trait(TRAIT_LIGHT_TOLERANCE,5)
		seed.set_trait(TRAIT_LOWKPA_TOLERANCE,25)
		seed.set_trait(TRAIT_HIGHKPA_TOLERANCE,200)
	return seed

/datum/controller/subsystem/plants/proc/add_plant(obj/effect/plant/plant)
	plant_queue |= plant

/datum/controller/subsystem/plants/proc/remove_plant(obj/effect/plant/plant)
	plant_queue -= plant

/datum/controller/subsystem/plants/Recover()
	flags |= SS_NO_INIT
	product_descs = SSplants.product_descs
	plant_queue = SSplants.plant_queue
	seeds = SSplants.seeds
	gene_tag_masks = SSplants.gene_tag_masks
	plant_icon_cache = SSplants.plant_icon_cache
	plant_sprites = SSplants.plant_sprites
	plant_product_sprites = SSplants.plant_product_sprites

ADMIN_VERB_ADD(/client/proc/show_plant_genes, R_DEBUG, FALSE)
// Debug for testing seed genes.
/client/proc/show_plant_genes()
	set category = "Debug"
	set name = "Show Plant Genes"
	set desc = "Prints the round's plant gene masks."

	if(!holder)
		return

	if(!SSplants.gene_tag_masks)
		usr << "Gene masks not set."
		return

	for(var/mask in SSplants.gene_tag_masks)
		usr << "[mask]: [SSplants.gene_tag_masks[mask]]"
