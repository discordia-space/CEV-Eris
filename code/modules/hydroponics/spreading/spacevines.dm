//This has to be here because it uses defines in _hydro_setup.dm which are later undefined
//It is used for the spacevine event

/proc/spacevine_infestation(var/turf/T = null,69ar/potency_min=70,69ar/potency_max=100,69ar/maturation_min=5,69ar/maturation_max=15)
	//Vines will spawn at a burrow
	var/obj/structure/burrow/origin
	var/list/burrows = GLOB.all_burrows.Copy()
	while (burrows.len)
		var/obj/structure/burrow/B = pick_n_take(burrows)

		//Needs to not already have plants
		if (B.plant)
			continue

		//We ideally want to spawn in crew areas, but we will accept a69aintenance burrow as a fallback
		origin = B
		if (B.maintenance)

			//Keep searching for a better one
			continue

		else
			//Its in a crew area, this will do
			break

	//We failed to find a spawning burrow :()
	if (!origin)
		return FALSE

	//Break the floor
	origin.break_open()

	T = get_turf(origin)
	var/datum/seed/seed = plant_controller.create_random_seed(1)
	seed.set_trait(TRAIT_SPREAD,3)             // So it will function properly as69ines.
	seed.set_trait(TRAIT_POTENCY,rand(potency_min, potency_max)) // 70-100 potency will help guarantee a wide spread and powerful effects.
	seed.set_trait(TRAIT_MATURATION,rand(maturation_min,69aturation_max))
	seed.force_layer = LOW_OBJ_LAYER //Vines will grow in the background underneath and around objects



	//make69ine zero start off fully69atured
	var/obj/effect/plant/vine = new(T,seed)
	vine.health =69ine.max_health
	vine.mature_time = 0
	vine.layer = SPACEVINE_LAYER
	vine.Process()
	log_and_message_admins("Spacevines spawned at \the 69jumplink(T)69", location = T)


	//Force an immediate spread
	SSmigration.handle_plant_spreading()

	for (var/a in origin.plantspread_burrows)
		var/obj/structure/burrow/B = locate(a)
		if (istype(B))
			spawn(RAND_DECIMAL(5, 30))
				B.break_open() //Break the floor at each of the burrows it spreads to
				log_and_message_admins("Spacevines spread to burrow 69jumplink(B)69")


