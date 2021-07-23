//This has to be here because it uses defines in _hydro_setup.dm which are later undefined
//It is used for the spacevine event

/proc/spacevine_infestation(var/turf/T = null, var/potency_min=70, var/potency_max=100, var/maturation_min=5, var/maturation_max=15)
	//Vines will spawn at a burrow
	var/obj/structure/burrow/origin
	var/list/burrows = GLOB.all_burrows.Copy()
	while (burrows.len)
		var/obj/structure/burrow/B = pick_n_take(burrows)

		//Needs to not already have plants
		if (B.plant)
			continue

		//We ideally want to spawn in crew areas, but we will accept a maintenance burrow as a fallback
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
	seed.set_trait(TRAIT_SPREAD,3)             // So it will function properly as vines.
	seed.set_trait(TRAIT_POTENCY,rand(potency_min, potency_max)) // 70-100 potency will help guarantee a wide spread and powerful effects.
	seed.set_trait(TRAIT_MATURATION,rand(maturation_min, maturation_max))
	seed.force_layer = LOW_OBJ_LAYER //Vines will grow in the background underneath and around objects



	//make vine zero start off fully matured
	var/obj/effect/plant/vine = new(T,seed)
	vine.health = vine.max_health
	vine.mature_time = 0
	vine.layer = SPACEVINE_LAYER
	vine.Process()
	log_and_message_admins("Spacevines spawned at \the [jumplink(T)]", location = T)


	//Force an immediate spread
	SSmigration.handle_plant_spreading()

	for (var/a in origin.plantspread_burrows)
		var/obj/structure/burrow/B = locate(a)
		if (istype(B))
			spawn(RAND_DECIMAL(5, 30))
				B.break_open() //Break the floor at each of the burrows it spreads to
				log_and_message_admins("Spacevines spread to burrow [jumplink(B)]")


