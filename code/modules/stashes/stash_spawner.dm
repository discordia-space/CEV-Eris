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

	if (!isStationLevel(src.z))
		//We wont spawn that on derelicts, because it makes no sense to spawn those notes there
		return INITIALIZE_HINT_QDEL

	datum.spawn_stash()
	datum.spawn_note(src)



	//Aaaand we are done
	return INITIALIZE_HINT_QDEL


//Selecting a datum is done in two pickweight stages
//First, the categories are weighted against each other
//Then everything within that category is weighted
/obj/item/stash_spawner/proc/select_datum()
	//First of all, we pick our category
	var/list/possible_categories = GLOB.stash_categories.Copy()
	var/category_resolved = FALSE
	var/category = null
	var/list/possible_stashes = list()
	while (category_resolved == FALSE)
		if (!possible_categories.len)
			break

		category = pickweight_n_take(possible_categories)

		//Now lets check that this category actually has any stashes left in it
		possible_stashes = GLOB.all_stash_datums[category]
		if (possible_stashes.len)
			category_resolved = TRUE
		else
			category = null //Go around again

	//Now we pickweight our datum
	if (category)
		datum = pickweight_n_take(possible_stashes)
