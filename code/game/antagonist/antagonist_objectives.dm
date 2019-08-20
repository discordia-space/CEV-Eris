/datum/antagonist/proc/create_objectives(var/survive = FALSE)

	if(!possible_objectives || !possible_objectives.len)
		return
	pick_objectives(src, possible_objectives, objective_quantity)

	if(survive)
		create_survive_objective()


// used only for factions antagonists
/datum/antagonist/proc/set_objectives(var/list/new_objectives)

	if(!owner || !owner.current)
		return

	if(objectives.len)
		to_chat(owner.current, "<span class='danger'><font size=3>Your objectives were updated.</font></span>")

	objectives.Cut()
	objectives.Add(new_objectives)

	show_objectives()

/datum/antagonist/proc/create_survive_objective()
	if(ispath(survive_objective))
		new survive_objective(src)

//Returns a list of all minds and atoms which have been targeted by our objectives
//This is used to disqualify them from being picked by farther objectives
/datum/antagonist/proc/get_targets()
	var/list/targets = list()
	for (var/datum/objective/O in objectives)
		targets.Add(O.get_target())
	return targets



//This function handles some of the logic for picking objectives for an antag or faction. It requires three inputs
//Owner: The antag or faction that will own this objective
//Possible objectives: The weighted list of objectives we choose from
//Quantity: How many objectives we will select
/proc/pick_objectives(var/owner, var/list/possible_objectives, var/quantity)
	//Safety checks first
	if(!possible_objectives || !possible_objectives.len)
		return

	if (!owner || (!istype(owner, /datum/faction) && !istype(owner, /datum/antagonist)))
		return

	if (!isnum(quantity) || quantity <= 0)
		return


	for (var/i = 0; i < quantity; i++)
		if (!possible_objectives.len)
			return

		var/chosen_obj = pickweight(possible_objectives)

		//Lets check for uniqueness
		var/datum/objective/O = chosen_obj
		if (initial(O.unique))
			//If this objective is unique, then we will search the list for an existing copy of it
			var/matched = FALSE
			for (var/datum/objective/P in owner:objectives) //We've already confirmed the type of owner, so : should be safe here
				if (P.type == chosen_obj)
					matched = TRUE
					break

			//We will remove it from the list regardless because we dont want to pick it again in future
			possible_objectives.Remove(chosen_obj)

			//If it already existed then we decrement i and continue to pick another objective
			if (matched)
				i--
				continue



		O = new chosen_obj(owner, ANTAG_SKIP_TARGET)


		//We pass ANTAG_SKIP_TARGET so we can manually search for targets
		if (!O.find_target())
			//If it fails to find a target, then bad things happen
			//First of all, we must delete this objective so we can get another
			qdel(O) //This will automatically remove itself from objective lists

			//Secondly, decrement i so we get another try
			i--

			//Thirdly, remove this objective from the possible list
			possible_objectives.Remove(chosen_obj)




