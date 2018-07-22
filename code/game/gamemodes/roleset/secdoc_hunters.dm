/datum/storyevent/roleset/secdoc_hunters
	id = "secdoc_hunters"
	role_id = null
	multispawn = TRUE

	min_cost = 8
	max_cost = 16

	req_crew = 6
	req_heads = -1
	req_sec = 2
	req_eng = -1
	req_med = -1
	req_sci = 3

	spawn_times_max = 3

/datum/storyevent/roleset/secdoc_hunters/spawn_event()
	var/list/hunters = candidates_list(ROLE_TRAITOR)
	if(hunters.len < 1)
		return FALSE

	var/list/scientists = candidates_list(ROLE_SECDOC_DEFENDER)
	if(scientists.len < 1)
		return FALSE

	var/datum/mind/hunter = pick(hunters)
	scientists.Remove(hunter)

	var/datum/mind/sci = pick(scientists)

	var/datum/antagonist/H = get_antag_instance(ROLE_TRAITOR)
	var/datum/antagonist/S = get_antag_instance(ROLE_SECDOC_DEFENDER)

	H.create_antagonist(hunter, announce = FALSE)
	S.create_antagonist(sci, announce = FALSE)

	create_objectives(H,S)

	return TRUE

/datum/storyevent/roleset/secdoc_hunters/create_objectives(var/datum/antagonist/H, var/datum/antagonist/S)
	var/obj/item/weapon/secdocs/secdocs = new
	secdocs.place_docs()

	var/datum/objective/secdocs/steal/steal = new(H)
	var/datum/objective/secdocs/protect/protect = new(S)

	steal.target = S.owner
	steal.set_target(secdocs)
	H.objectives.Add(steal)

	protect.set_target(secdocs)
	S.objectives.Add(protect)

	H.create_survive_objective()
	S.create_survive_objective()

	H.greet()
	S.greet()