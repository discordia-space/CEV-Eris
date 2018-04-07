/datum/storyevent/roleset/excelsior
	id = "excelsior"
	role_id = null
	multispawn = FALSE

	min_cost = 10
	max_cost = 20

	req_crew = 10
	req_heads = 1
	req_sec = 3
	req_eng = -1
	req_med = -1
	req_sci = -1

	spawn_times_max = 1

/datum/storyevent/roleset/excelsior/spawn_event()
	if(get_faction_by_id(FACTION_EXCELSIOR))
		return FALSE

	var/list/candidates = candidates_list(ROLE_EXCELSIOR_REV)
	if(candidates.len < 1)
		return FALSE

	var/obj/landmark/storyevent/midgame_stash_spawn/landmark = null

	var/list/L = list()
	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in landmarks_list)
		L.Add(S)

	L = shuffle(L)

	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in L)
		if(!S.is_visible())
			landmark = S
			break

	//if(!landmark)
		//return FALSE

	//TODO Spawn some shit

	var/datum/mind/rev = pick(candidates)

	var/datum/antagonist/R = get_antag_instance(ROLE_EXCELSIOR_REV)

	var/datum/faction/revolutionary/excelsior/E = new

	R.create_antagonist(rev,announce = FALSE)
	E.add_leader(R)
	var/obj/item/weapon/implant/revolution/excelsior/implant = new(rev.current)
	implant.install(rev.current)

	return TRUE

/datum/storyevent/roleset/excelsior/create_objectives()
	return
