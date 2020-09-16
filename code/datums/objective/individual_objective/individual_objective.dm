/datum/mind/var/list/individual_objetives = list()

/mob/living/carbon/human/proc/pick_individual_objective()
	admin_notice(SPAN_DANGER("ENTRO AL INIDICUAL OBJECTIVE"))
	if(!mind) return FALSE
	admin_notice(SPAN_DANGER("TIENE MENTE"))
	var/list/valid_objectives = subtypesof(/datum/individual_objetive/common)
	admin_notice(SPAN_DANGER("esta es la cantidad de objectivos comunes [valid_objectives.len]"))
	if(mind.assigned_job)
		for(var/datum/individual_objetive/job/IO in GLOB.individual_job_objetives)
			if(mind.assigned_job.department == IO.department)
				valid_objectives += GLOB.individual_job_objetives[IO]
	admin_notice(SPAN_DANGER("esta es la cantidad de objectivos totales [valid_objectives.len]"))
	var/individual_objetive = pick(valid_objectives)
	new individual_objetive(mind)

/datum/individual_objetive
	var/name = "individual"
	var/datum/mind/owner				//Who owns the objective.
	var/completed = 0					//currently only used for custom objectives.
	var/per_unit = 0
	var/units_completed = 0
	var/units_compensated = 0 			//Shit paid for
	var/units_requested = INFINITY
	var/completion_payment = 0			//Credits paid to owner when completed
	var/department

/datum/individual_objetive/New(datum/mind/new_owner)
	if(!new_owner) return FALSE
	owner = new_owner
	owner.individual_objetives += src
	. = TRUE


/datum/individual_objetive/proc/get_description()
	var/desc = "Placeholder Objective"
	return desc

/datum/individual_objetive/proc/unit_completed(var/count=1)
	units_completed += count

/datum/individual_objetive/proc/is_completed()
	if(!completed)
		completed = check_for_completion()
	return completed

/datum/individual_objetive/proc/check_for_completion()
	if(per_unit)
		if(units_completed > 0)
			return 1
	return 0

/*
/datum/game_mode/proc/declare_job_completion()
	var/text = "<hr><b><u>Job Completion</u></b>"

	for(var/datum/mind/employee in SSticker.minds)

		if(!employee.individual_objetives.len)//If the employee had no objectives, don't need to process this.
			continue

		if(employee.assigned_role == employee.special_role || employee.offstation_role) //If the character is an offstation character, skip them.
			continue

		var/tasks_completed=0

		text += "<br>[employee.name] was a [employee.assigned_role]:"

		var/count = 1
		for(var/datum/individual_objetive/objective in employee.individual_objetives)
			if(objective.is_completed(1))
				text += "<br>&nbsp;-&nbsp;<B>Task #[count]</B>: [objective.get_description()] <font color='green'><B>Completed!</B></font>"
				feedback_add_details("employee_objective","[objective.type]|SUCCESS")
				tasks_completed++
			else
				text += "<br>&nbsp;-&nbsp;<B>Task #[count]</B>: [objective.get_description()] <font color='red'><b>Failed.</b></font>"
				feedback_add_details("employee_objective","[objective.type]|FAIL")
			count++

		if(tasks_completed >= 1)
			text += "<br>&nbsp;<font color='green'><B>[employee.name] did [employee.p_their()] fucking job!</B></font>"
			feedback_add_details("employee_success","SUCCESS")
		else
			feedback_add_details("employee_success","FAIL")

	return text
*/