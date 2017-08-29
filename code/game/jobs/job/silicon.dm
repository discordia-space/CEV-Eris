/datum/job/silicon
	department_flag = ENGSEC
	faction = "CEV Eris"
	account_allowed = 0
	economic_modifier = 0

/datum/job/silicon/equip(var/mob/living/carbon/human/H)
	return H


/datum/job/silicon/ai
	title = JOB_AI
	flag = AI
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	req_admin_notify = 1


/datum/job/silicon/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)


/datum/job/silicon/cyborg
	title = JOB_CYBORG
	flag = CYBORG
	total_positions = 2
	spawn_positions = 2
	supervisors = "your laws and the AI"	//Nodrak
	selection_color = "#ddffdd"
