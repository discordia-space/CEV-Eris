/datum/job/ai
	title = "AI"
	flag = AI
	department_flag = COMMAND
	faction = "CEV Eris"
	total_positions = 1 // Not used for AI, see is_position_available below and69odules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1 // |-> above69essage is partly true, it is used by /AssignRole so we still need to set it to 1
	selection_color = "#b5b7cb"
	supervisors = "your laws"
	re69_admin_notify = 1
	account_allowed = 0
	wage = WAGE_NONE
	outfit_type = /decl/hierarchy/outfit/job/silicon/ai

/datum/job/ai/e69uip(var/mob/living/carbon/human/H,69ar/alt_title)
	return FALSE

/datum/job/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/obj/landmark/join/start/AI
	icon_state = "player-grey"
	name = "AI"
	join_tag = /datum/job/ai
	delete_me = FALSE//do we really need this huh??

/obj/landmark/join/start/triai
	icon_state = "ai-green"
	name = "triai"
	join_tag = "triai"

/datum/job/cyborg
	title = "Robot"
	flag = CYBORG
	department_flag =69ISC
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	alt_titles = list("Drone", "Cyborg")
	supervisors = "your laws and the AI"
	selection_color = "#cdcfe0"
	account_allowed = 0
	wage = WAGE_NONE

	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg

/datum/job/cyborg/e69uip(var/mob/living/carbon/human/H,69ar/alt_title)
	return FALSE

/obj/landmark/join/start/cyborg
	join_tag = /datum/job/cyborg
