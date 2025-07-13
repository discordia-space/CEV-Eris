/datum/admin_secret_item/fun_secret/triple_ai_mode
	name = "Triple AI Mode"

/datum/admin_secret_item/fun_secret/triple_ai_mode/can_execute(mob/user)
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return 0

	return ..()

/datum/admin_secret_item/admin_secret/triple_ai_mode/execute(mob/user)
	. = ..()
	if(.)
		user.client.triple_ai()
