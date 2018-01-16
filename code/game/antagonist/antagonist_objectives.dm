/datum/antagonist/proc/create_objectives(var/survive = FALSE)
	for(var/obj in possible_objectives)
		var/chance = possible_objectives[obj]
		if(!chance)
			chance = 100

		if(!prob(chance))
			continue

		if(islist(obj))
			var/list/L = obj
			var/chosen
			var/total = 0
			for(var/O in L)
				total += L[O]

			var/picked = rand(0,total)
			total = 0

			for(var/O in L)
				total += L[O]
				if(total > picked)
					chosen = O
					break

			if(!chosen)
				chosen = pick(L)

			obj = chosen

		if(ispath(obj))
			objectives.Add(new obj(src))

	if(survive)
		create_survive_objective()

/datum/antagonist/proc/set_objectives(var/list/new_objectives)
	if(!owner || !owner.current)
		return

	if(objectives.len)
		owner.current << "<span class='danger'><font size=3>Your objectives were updated.</font></span>"

	objectives.Cut()
	objectives.Add(new_objectives)

	show_objectives()

/datum/antagonist/proc/create_survive_objective()
	if(ispath(survive_objective))
		objectives.Add(new survive_objective(src))
