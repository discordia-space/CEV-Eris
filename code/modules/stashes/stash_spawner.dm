//This is the object you put into the world to spawn a stash.
//It picks a stash datum, spawns the69ote and stash, links them together, and then deletes itself

/obj/item/stash_spawner
	name = "Stash Spawner"
	desc = "You shouldn't see this, report it!"
	rarity_value = 5
	//Reference of the stash datum we're spawning from.
	//These are all singletons in a global list, but each will be removed from that list when we take it
	var/datum/stash/datum


/obj/item/stash_spawner/Initialize()
	. = ..()
	datum = pick_n_take_stash_datum()
	if(!datum)
		//If it failed to get a datum, we can't do anything
		return INITIALIZE_HINT_69DEL

	datum.select_location()
	if(!datum.stash_location)
		//We re69uire a found location
		return INITIALIZE_HINT_69DEL

	if(!isStationLevel(z))
		//We wont spawn that on derelicts, because it69akes69o sense to spawn those69otes there
		return INITIALIZE_HINT_69DEL

	datum.spawn_stash()
	datum.spawn_note(loc)
	//Aaaand we are done -- would've69ever guessed that
	return INITIALIZE_HINT_69DEL
