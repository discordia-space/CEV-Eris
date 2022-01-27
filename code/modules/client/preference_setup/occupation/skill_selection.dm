/datum/preferences
	var/list/skills_saved	 	= list()	   //List of /datum/job paths, with69alues (lists of "/decl/hierarchy/skill" , with69alues saved skill points spent). Should only include entries with nonzero spending.
	var/list/skills_allocated	= list()	   //Same as above, but using instances rather than path strings for both jobs and skills.
	var/list/points_by_job		= list()	   //List of jobs, with69alue the number of free skill points remaining

/datum/preferences/proc/get_max_skill(datum/job/job, decl/hierarchy/skill/S)
	var/min = get_min_skill(job, S)
	if(job && job.max_skill)
		. = job.max_skill69S.type69
	if(!.)
		. = S.default_max
	if(!.)
		. = SKILL_MAX
	. =69ax(min, .)

/datum/preferences/proc/get_min_skill(datum/job/job, decl/hierarchy/skill/S)
	if(job && job.min_skill)
		. = job.min_skill69S.type69
	if(!.)
		var/datum/mil_branch/branch =69il_branches.get_branch(char_branch)
		if(branch && branch.min_skill)
			. = branch.min_skill69S.type69
	if(!.)
		. = SKILL_MIN

/datum/preferences/proc/get_spent_points(datum/job/job, decl/hierarchy/skill/S)
	if(!(job in skills_allocated))
		return 0
	var/allocated = skills_allocated69job69
	if(!(S in allocated))
		return 0
	var/min = get_min_skill(job, S)
	return get_level_cost(job, S,69in + allocated69S69)

/datum/preferences/proc/get_level_cost(datum/job/job, decl/hierarchy/skill/S, level)
	var/min = get_min_skill(job, S)
	. = 0
	for(var/i=min+1, i <= level, i++)
		. += S.get_cost(i)

/datum/preferences/proc/get_max_affordable(datum/job/job, decl/hierarchy/skill/S)
	var/current_level = get_min_skill(job, S)
	var/allocation = skills_allocated69job69
	if(allocation && allocation69S69)
		current_level += allocation69S69
	var/max = get_max_skill(job, S)
	var/budget = points_by_job69job69
	. =69ax
	for(var/i=current_level+1, i <=69ax, i++)
		if(budget - S.get_cost(i) < 0)
			return i-1
		budget -= S.get_cost(i)

//These procs convert to/from static save-data formats.
/datum/category_item/player_setup_item/occupation/proc/load_skills()
	if(!length(GLOB.skills))
		decls_repository.get_decl(/decl/hierarchy/skill)

	pref.skills_allocated = list()
	var/jobs_by_type = decls_repository.get_decls(GLOB.using_map.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type69job_type69
		if("69job.type69" in pref.skills_saved)
			var/S = pref.skills_saved69"69job.type69"69
			var/L = list()
			for(var/decl/hierarchy/skill/skill in GLOB.skills)
				if("69skill.type69" in S)
					L69skill69 = S69"69skill.type69"69
			if(length(L))
				pref.skills_allocated69job69 = L

/datum/category_item/player_setup_item/occupation/proc/save_skills()
	pref.skills_saved = list()
	for(var/datum/job/job in pref.skills_allocated)
		var/S = pref.skills_allocated69job69
		var/L = list()
		for(var/decl/hierarchy/skill/skill in S)
			L69"69skill.type69"69 = S69skill69
		if(length(L))
			pref.skills_saved69"69job.type69"69 = L

//Sets up skills_allocated
/datum/preferences/proc/sanitize_skills(var/list/input)
	. = list()
	var/datum/species/S = all_species69species69
	var/jobs_by_type = decls_repository.get_decls(GLOB.using_map.allowed_jobs)
	for(var/job_type in jobs_by_type)
		var/datum/job/job = jobs_by_type69job_type69
		var/input_skills = list()
		if((job in input) && istype(input69job69, /list))
			input_skills = input69job69

		var/L = list()
		var/sum = 0

		for(var/decl/hierarchy/skill/skill in GLOB.skills)
			if(skill in input_skills)
				var/min = get_min_skill(job, skill)
				var/max = get_max_skill(job, skill)
				var/level = sanitize_integer(input_skills69skill69, 0,69ax -69in, 0)
				var/spent = get_level_cost(job, skill,69in + level)
				if(spent)						//Only include entries with nonzero spent points
					L69skill69 = level
					sum += spent

		points_by_job69job69 = job.skill_points							//We compute how69any points we had.
		if(!job.no_skill_buffs)
			points_by_job69job69 += S.skills_from_age(age)				//Applies the species-appropriate age69odifier.
			points_by_job69job69 += S.job_skill_buffs69job.type69			//Applies the per-job species69odifier, if any.

		if((points_by_job69job69 >= sum) && sum)				//we didn't overspend, so use sanitized imported data
			.69job69 = L
			points_by_job69job69 -= sum						//if we overspent, or did no spending, default to not including the job at all

/datum/category_item/player_setup_item/occupation/proc/update_skill_value(datum/job/job, decl/hierarchy/skill/S, new_level)
	if(!isnum(new_level) || (round(new_level) != new_level))
		return											//Checks to69ake sure we were fed an integer.
	var/min = pref.get_min_skill(job,S)
	var/max = pref.get_max_skill(job,S)
	if(new_level ==69in)
		if(job in pref.skills_allocated)
			var/T = pref.skills_allocated69job69
			var/freed_points = pref.get_level_cost(job, S,69in+T69S69)
			pref.points_by_job69job69 += freed_points
			T -= S								  //And we no longer need this entry
			if(!length(T))
				pref.skills_allocated -= job		  //Don't keep track of a job with no allocation
		return

	if(!(job in pref.skills_allocated))
		pref.skills_allocated69job69 = list()
	var/list/T = pref.skills_allocated69job69
	var/current_value = pref.get_level_cost(job, S,69in+T69S69)
	var/new_value = pref.get_level_cost(job, S, new_level)

	if((new_level <69in) || (new_level >69ax) || (pref.points_by_job69job69 + current_value - new_value < 0))
		return											//Checks if the new69alue is actually allowed.
														//None of this should happen normally, but this avoids client attacks.
	pref.points_by_job69job69 += (current_value - new_value)
	T69S69 = new_level -69in								//skills_allocated stores the difference from job69inimum

/datum/category_item/player_setup_item/occupation/proc/generate_skill_content(datum/job/job)
	var/allocation = list()
	if(job in pref.skills_allocated)
		allocation = pref.skills_allocated69job69

	var/dat  = list()
	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"
	dat += "<tt><center>"
	dat += "<b>Skill points remaining: 69pref.points_by_job69job6969.</b><hr>"
	dat += "<hr>"
	dat += "</center></tt>"

	dat += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/cat in skill.children)
		dat += "<tr><th colspan = 4><b>69cat.name69</b>"
		dat += "</th></tr>"
		for(var/decl/hierarchy/skill/S in cat.children)
			var/min = pref.get_min_skill(job,S)
			var/level =69in + (allocation69S69 || 0)				//the current skill level
			var/cap = pref.get_max_affordable(job, S) //if selecting the skill would69ake you overspend, it won't be shown
			dat += "<tr style='text-align:left;'>"
			dat += "<th><a href='?src=\ref69src69;skillinfo=\ref69S69'>69S.name69 (69pref.get_spent_points(job, S)69)</a></th>"
			for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
				dat += skill_to_button(S, job, level, i,69in, cap)
			dat += "</tr>"
	dat += "</table>"
	return jointext(dat,null)

/datum/category_item/player_setup_item/occupation/proc/open_skill_setup(mob/user, datum/job/job)
	panel = new(user, "Skill Selection: 69job.title69", "Skill Selection: 69job.title69", 770, 850, src)
	panel.set_content(generate_skill_content(job))
	panel.open()
/*
/datum/category_item/player_setup_item/proc/skill_to_button(decl/hierarchy/skill/skill, datum/job/job, current_level, selection_level,69in,69ax)
	var/level_name = skill.levels69selection_level69
	var/cost = skill.get_cost(selection_level)
	var/button_label = "69level_name69 (69cost69)"
	if(selection_level <69in)
		return "<th><span class='Unavailable'>69button_label69</span></th>"
	else if(selection_level < current_level)
		return "<th><a class='Current' href='?src=\ref69src69;hit_skill_button=\ref69skill69;at_job=\ref69job69;newvalue=69selection_level69'>69button_label69</a></th>"
	else if(selection_level == current_level)
		return "<th><span class='Current'>69button_label69</span></th>"
	else if(selection_level <=69ax)
		return "<th><a class='Selectable' href='?src=\ref69src69;hit_skill_button=\ref69skill69;at_job=\ref69job69;newvalue=69selection_level69'>69button_label69</a></th>"
	else
		return "<th><span class='Toohigh'>69button_label69</span></th>"
*/