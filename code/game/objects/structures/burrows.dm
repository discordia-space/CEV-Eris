/*
	A burrow is an entrance to an abstract network of tunnels inside the walls of eris. Animals and creatures of
	all types, but mostly roaches, can travel from one burrow to another, bypassing all obstacles inbetween
*/
/obj/structure/burrow
	name = "burrow"
	desc = "Some sort of hole that leads inside a wall. It's full of hardened resin and secretions. Collapsing this would require some heavy digging tools"
	anchored = TRUE
	density = FALSE
	plane = FLOOR_PLANE
	//layer = LOW_OBJ_LAYER

	//Integrity is used when attempting to collapse this hole. It is a multiplier on the time taken and failure rate
	//Any failed attempt to collapse it will reduce the integrity, making future attempts easier
	var/integrity = 100

	//A list of the mobs that are near this hole, and considered to be living here.
	//Since this list is updated infrequently, it stores refs instead of direct pointers, to prevent GC issues
	var/list/population = list()


	//If true, this burrow is located in a maintenance tunnel. Most of them will be
	//Ones located outside of maint are much less likely to be picked for migration
	var/maintenance = FALSE



/obj/structure/burrow/New(var/turf/anchor)
	.=..()
	all_burrows.Add(src)
	if (anchor)
		offset_to(anchor)



//This is called from the migration subsystem. It scans for nearby creatures
//Any kind of simple or superior animal is valid, all of them are treated as population for this burrow
/obj/structure/burrow/proc/life_scan()
	population.Cut()
	for (var/mob/living/L in dview(14, loc))
		if (is_valid(L))
			population |= "\ref[L]"

	if (population.len)
		populated_burrows |= src
		unpopulated_burrows -= src
	else
		populated_burrows -= src
		unpopulated_burrows |= src


/*
	Returns true/false to indicate if the passed mob is valid to be considered population for this burrow
*/
/obj/structure/burrow/proc/is_valid(var/mob/living/L)
	//Dead mobs don't count
	if (L.stat == DEAD)
		return FALSE

	//We don't want player controlled mobs getting sucked up by holes
	if (L.client)
		return FALSE


	//Creatures only. No humans or robots
	if (!isanimal(L) || !issuperioranimal(L))
		return FALSE

	return TRUE
