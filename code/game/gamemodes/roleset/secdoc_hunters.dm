/datum/storyevent/roleset/secdoc_hunters
	id = "secdoc_hunters"
	name = "secret document hunters"
	role_id = null

	//min_cost = 8
	//max_cost = 16

	req_crew = 6
	req_heads = -1
	req_sec = 2
	req_eng = -1
	req_med = -1
	req_sci = 3

/datum/storyevent/roleset/secdoc_hunters/can_trigger(var/severity = EVENT_LEVEL_ROLESET, var/report)
	var/list/scientists = candidates_list(ROLE_SECDOC_DEFENDER, report)
	if(scientists.len < 1)
		if (report) to_chat(report, SPAN_NOTICE("Failure: No scientist candidates found"))
		return FALSE

	var/scientist = pick(scientists)
	var/list/hunters = candidates_list(ROLE_TRAITOR, report)
	hunters -= scientist
	if(hunters.len < 1)
		if (report) to_chat(report, SPAN_NOTICE("Failure: No hunter candidates found"))
		return FALSE


	return TRUE


/datum/storyevent/roleset/secdoc_hunters/trigger_event()
	var/list/hunters = candidates_list(ROLE_TRAITOR)
	if(hunters.len < 1)
		return FALSE

	var/list/scientists = candidates_list(ROLE_SECDOC_DEFENDER)
	if(scientists.len < 1)
		return FALSE

	var/datum/mind/hunter = pick(hunters)
	scientists.Remove(hunter)

	var/datum/mind/sci = pick(scientists)

	var/datum/antagonist/H = create_antag_instance(ROLE_TRAITOR)
	var/datum/antagonist/S = create_antag_instance(ROLE_SECDOC_DEFENDER)

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