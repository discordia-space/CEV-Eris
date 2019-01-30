//This is the object you put into the world to spawn a stash.
//It picks a stash datum, spawns the note and stash, links them together, and then deletes itself
/obj/item/stash_spawner
	name = "Stash Spawner"
	desc = "You shouldn't see this, report it!"

	//Reference of the stash datum we're spawning from.
	//These are all singletons in a global list, but each will be removed from that list when we take it
	var/datum/stash/datum


/obj/item/stash_spawner/Initialize()
	select_datum()
	if (!datum)
		//If it failed to get a datum, we can't do anything
		return INITIALIZE_HINT_QDEL

	datum.select_location()
	if (!datum.stash_location)
		//We require a found location
		return INITIALIZE_HINT_QDEL

	datum.spawn_stash()
	datum.spawn_note(src)

	world << "Stash spawned at [jumplink(datum.stash_location)]"
	world << "Stashnote spawned at [jumplink(src)]"


	//Aaaand we are done
	return INITIALIZE_HINT_QDEL

/obj/item/stash_spawner/proc/select_datum()
	datum = pick_n_take(GLOB.all_stash_datums)
	//We take the stash datum from the global list.This ensures the same one can never be picked twice