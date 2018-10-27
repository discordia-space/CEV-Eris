//This has to be here because it uses defines in _hydro_setup.dm which are later undefined
//It is used for the spacevine event

/proc/spacevine_infestation(var/turf/T = null, var/potency_min=70, var/potency_max=100, var/maturation_min=5, var/maturation_max=15)
	spawn() //to stop the secrets panel hanging

		if (!T)
			if (prob(20))//Sometimes spawn in hallway
				T = pick_area_turf(/area/eris/hallway, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
			else
				//Otherwise spawn in a random area
				var/area/A = random_ship_area(TRUE)
				T = A.random_space()

		if(T)
			var/datum/seed/seed = plant_controller.create_random_seed(1)
			seed.set_trait(TRAIT_SPREAD,2)             // So it will function properly as vines.
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
			return
		log_and_message_admins(SPAN_NOTICE("Event: Spacevines failed to find a viable turf."))
