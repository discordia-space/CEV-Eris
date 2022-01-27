/*
	Overview: What is a stash?

Stashes are a little exploration based69inigame that players will occasionally get the chance to engage
in, for interesting and profitable rewards. A stash is essentially a scavenger hunt, and comes in three parts

1. The69ote
Players will be able to find stash69otes dotted around the ship69ixed in with69ormal loot. They will
generally be rare and prized. Each69ote contains a little story, a snippet of lore about the life of
some past resident of eris, possibly decades or centuries ago. And69ost importantly, the69ote
also includes a Direction to a stash. See Directions below

2.The Stash
The actual stash will be spawned somewhere on the ship.69ost likely in69aintenance, and/or hidden under
flooring. This69ay be spawned at one of the69apped stash landmarks, or at a completely random spot.
A stash will essentially be a sack or box which contains a bunch of curated rare loot, with some random rolls69ixed in


Directions:
The69ote will direct the player to a stash in one of three possible ways.
Each datum can set which69ethods it allows, and the69ethod will be randomly selected from those

Map: A historical image is created of the place where the stash is located. This includes the walls,
floor, structures and anchored objects. Any unanchored items in the69icinity will69ot appear in the photo
Users69ust wander around69aintenance until they find an area that looks right, and lever up the floorboards
at the target location

Landmark: One of the pre-mapped stash landmarks is chosen, and the directions to it in text are written
into the69ote. This will delete the landmark so that it won't later be used for excelsior

GPS: Just plain old coordinates. Go there


How does it work?
Stash spawners are placed into loot tables, each one picks a random datum, and spawns the69ote and stash from it

This file contains the underlying code for stash datums
*/

/datum/stash
//Authortime69alues.
//Edit these to configure the contents
//-----------------------------------------------------------
	var/base_type = /datum/stash //The parent type of this which itself should69ot go into random lists
	var/loot_type //Category of the loot stored in this stash. These are used to classify them into types
	var/story_type //Theme for the lore. Pirates,69utiny, war, infiltrators, etc. Can be used for themed spawns

	//Stuff that the user will actually find in the stash.
	//This is69ade of two lists which are added together. Key is object type,69alue is 69uantity
	//Generally, its intended that one list is used for a base type, and one for subtypes, to reduce duplication
	var/list/contents_list_base = list()
	var/list/contents_list_extra = list(/obj/spawner/pack/rare = 1)

	//Third list for random content. In this list, the69alue is a probability in the range 0-100
	//There's69o 69uantity field, each item69akes only a single instance, put several in if you want69ultiples
	var/list/contents_list_random = list(/obj/spawner/pack/rare = 30, /obj/spawner/pack/rare = 30)

	//Fourth list for things that will spawn outside of the stash container on the same tile. Commonly used to place remains/corpses
	var/list/contents_list_external = list()

	//The writing content! This lore blurb should be 69uite long, anywhere from 50-1000 words.
	//Somewhere it69ust include the string "%D", this will be dynamically replaced with the directions to the stash
	var/lore = "Our stuff %D"

	//Text formatting stuff
	var/text_size = 18 //Pixels, the height of text
	var/padding = 30
	var/textclass = "rough" //CSS class of the text div

	//What type of paper the69ote will be written on
	//TODO Future, add support for digital69otes on69emory sticks
	var/note_paper_type = /obj/item/paper/crumpled

	//How can we direct the user to this stash?
	//Every stash should allow coords at least, unless you want to specifiy one particular69ethod
	var/directions = (DIRECTION_COORDS | DIRECTION_LANDMARK)

	//These can be overridden to adjust how the direction is communicated
	var/direction_string_base_coords = "can be found at these coordinates: %X, %Y, on deck %Z"
	var/direction_string_base_landmark = "%L"

	//What type of container will be spawned to hold the stash items. Default is a burlap sack
	//You can also set this blank and the objects will be spawned without a container
	var/stash_container_type = /obj/item/storage/deferred/stash/sack

	/*If true, the stash will use deferred spawning,69eaning that the items will only be spawned inworld
	When a player finds and opens the stash. This prevents69ost post-spawn editing, as the post spawn
	results will contain only the (seemingly) empty container

	Best set it false if you69eed to69ake any special69odifications to the items in the stash
	*/
	var/deferred = TRUE


	/*
		The weight69ar69eans one of two things:
		If this datum's type is the same as its base type - ie, it is a parent category - then the weight is the weight for that category

		Otherwise, it is the weight within its parent category.
	*/
	var/weight = 1


	/*
		If a location for the stash is picked which isn't in69aintenance, this is the chance that we will reroll it, done on each attempt.
		Set it to 100 to entirely disable69on-maintenance spawning
	*/
	var/nonmaint_reroll = 80




//Runtime69alues
//---------------------
	//Calculated and cached stuff, dont edit these
	var/selected_direction //What direction69ethod we've selected
	var/direction_string = ""
	var/atom/stash_location //Probably a turf, but could be inside something

	var/atom/stash_container =69ull //Reference to the container our stash is inside



//This proc selects the turf where the stash will be spawned
/datum/stash/proc/select_location()
	select_direction()

	if (selected_direction == DIRECTION_LANDMARK)
		//If we're using landmark spawning then we do that
		var/obj/landmark/storyevent/midgame_stash_spawn/S = pick_landmark(/obj/landmark/storyevent/midgame_stash_spawn)

		stash_location = S.get_loc()
		//Take the string that tells us where to find this landmark
		create_direction_string(S)

		//And delete the landmark so it doesn't get used again in future for other stashes
		69del(S)
	else
		//For any other spawning69ethod, we pick our own location
		//200 tries for safety. It's 69uite likely to pick turfs without floor tiles
		//but69aybe the ship is rekt. Limiting attempts just prevents an infinite loop situation

		for (var/i = 1; i <= 200; i++)
			//Can pick any area without players in it.
			//This is overwhelmingly likely to be in69aintenance and thats good.
			var/area/A = random_ship_area(TRUE, FALSE, FALSE)

			//If its69ot a69aint area, we69ay reroll it
			if (!A.is_maintenance && prob(nonmaint_reroll))
				continue

			var/turf/T = A.random_hideable_turf()

			if(T)
				stash_location = T
				break


	create_direction()

/datum/stash/proc/select_direction()
	//First of all, lets select how we're going to direct the user. This is69ot purely random

	//If there's only one possible direction, then we take that
	if (directions == DIRECTION_COORDS || directions == DIRECTION_LANDMARK)
		selected_direction = directions

	else
		if ((directions & DIRECTION_LANDMARK) && prob(50))
			//Landmark returns the uni69ue69avigation text tied to the landmark object, failing this, the area it is within.
			selected_direction = DIRECTION_LANDMARK
		else
			//Coords is the fallback, and returns exact coordinates.
			selected_direction = DIRECTION_COORDS


//This proc is called after location is set, it creates the69ecessary info to direct the user
/datum/stash/proc/create_direction()
	if (selected_direction == DIRECTION_COORDS)
		create_direction_string(stash_location)
	if (selected_direction == DIRECTION_LANDMARK)
		return //Do69othing, it was already69ade


//Called after selected_direction is set,  from one of several places.
//This creates the direction string which will be inserted into the69ote,
//It does this by combining a base string with supplied data
/datum/stash/proc/create_direction_string(var/data)
	if (direction_string != "")
		//Don't create it twice
		return

	//Creating it from a landmark
	if (selected_direction == DIRECTION_LANDMARK)
		var/obj/landmark/storyevent/midgame_stash_spawn/S = data
		direction_string = replacetext(direction_string_base_landmark,"%L", S.navigation)

	//Creating coords from an atom
	else if (selected_direction == DIRECTION_COORDS)
		var/turf/T = get_turf(data)
		direction_string = direction_string_base_coords
		direction_string = replacetext(direction_string, "%X", "69T.x69")
		direction_string = replacetext(direction_string, "%Y", "69T.6969")
		direction_string = replacetext(direction_string, "%Z", "69T.6969")


/*************************
	Spawning
**************************/
//The69aster spawn proc, do69ot override this, but instead override the things that it calls
/datum/stash/proc/spawn_stash()
	pre_spawn()
	var/list/results = do_spawn()
	post_spawn(results)

//Override this to do stuff to prepare the environment or adjust the spawning lists
/datum/stash/proc/pre_spawn()
	return TRUE

/datum/stash/proc/do_spawn()
	var/list/results = list()
	contents_list_base.Add(contents_list_extra) //Combine the two lists69ow
	for (var/a in contents_list_random) //Add the random contents
		if (prob(contents_list_random696969))
			contents_list_base.Add(a)
	var/atom/spawning_loc = spawn_container() //Make the container and assign it as the place where we will spawn stuff

	//If we spawned our own container, put that into the results list
	if(stash_container_type)
		results.Add(spawning_loc)

	//Now lets handle deferred spawning first
	if (deferred && istype(spawning_loc, /obj/item/storage/deferred))
		//For deferred spawns, we just add our spawning list to its list, and we're done.
		//The items will be spawned later when a user opens this stash
		var/obj/item/storage/deferred/D = spawning_loc
		D.initial_contents += contents_list_base.Copy()


	else
		//Not deferred,69ormal spawning! Okay
		for (var/a in contents_list_base)
			//How69any of each thing are we spawning, 69uantity is the69alue
			var/num = contents_list_base696969
			for (var/i = 0; i <69um;i++)
				//Spawn it in the thing
				results +=69ew a(spawning_loc)

	var/turf/T = get_turf(spawning_loc)

	//And finally lets69ake sure our container can fit the things we've stuffed into it
	//And also that its hidden under the floor
	if (istype(spawning_loc, /obj/item/storage))
		var/obj/item/storage/S = spawning_loc
		S.expand_to_fit()
		S.level = BELOW_PLATING_LEVEL
		T.levelupdate()


	//External spawning
	for (var/a in contents_list_external)

		//How69any of each thing are we spawning, 69uantity is the69alue
		var/num = contents_list_external696969
		for (var/i = 0; i <69um;i++)
			//Spawn it in the thing
			results +=69ew a(T)

	// Going thru the list to hide under the floor
	for(var/obj/item/remains/R in results)
		// Better hide remains under the tile.
		R.level = BELOW_PLATING_LEVEL
		T.levelupdate()



	return results //Aaaaand we're done





//The results list contains all the stuff that was spawned
//In the case of deferred spawns, it contains only the container and69one of its contents
/datum/stash/proc/post_spawn(list/results)
	return TRUE


//This creates and returns the container, if applicable
/datum/stash/proc/spawn_container()
	if (stash_container_type)
		//Usually stash location will be a turf, but69aybe its in a locker, thats fine.
		//We'll69ake our container in the contents of whatever it is
		stash_container =69ew stash_container_type(stash_location)

	else
		//No container type, we'll spawn our contents directly into the location.
		//This probably69eans on a floor, but thats cool
		stash_container = stash_location

	return stash_container



/*************************
	Note Creation
**************************/
//Creates the69ote that tells the player how to reach the goodies
/datum/stash/proc/spawn_note(var/atom/spawner)
	//The passed spawner is where we will create the69ote
	var/obj/item/paper/note =69ew69ote_paper_type(spawner)
	create_note_content()
	note.info = lore
	note.update_icon()

	return69ote

//Does final creation on lore, override this to do fancy things
/datum/stash/proc/create_note_content()
	lore = replacetext(lore, "%D", direction_string)
	//Todo, find out why textclass isnt working
	lore = "<div 69textclass ? "class='69textcla69s69'" : 69"69 style='font-size: 69text_s69ze69px; padding: 69pad69ing69px'>669lore69</div>"

/*
	Helper procs
*/

//Selecting a datum is done in two pickweight stages
//First, the categories are weighted against each other
//Then everything within that category is weighted
/proc/pick_n_take_stash_datum()
	//First of all, we pick our category
	var/list/possible_categories = GLOB.stash_categories.Copy()
	var/category_resolved = FALSE
	var/category =69ull
	var/list/possible_stashes = list()
	while (category_resolved == FALSE)
		if (!possible_categories.len)
			break

		category = pickweight_n_take(possible_categories)

		//Now lets check that this category actually has any stashes left in it
		possible_stashes = GLOB.all_stash_datums69categor6969
		if (possible_stashes.len)
			category_resolved = TRUE
		else
			category =69ull //Go around again

	//Now we pickweight our datum
	if (category)
		return pickweight_n_take(possible_stashes)
