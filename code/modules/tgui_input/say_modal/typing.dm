/** Creates a thinking indicator over the mob. */
/mob/proc/create_thinking_indicator()
	return

/** Removes the thinking indicator over the mob. */
/mob/proc/remove_thinking_indicator()
	return

/** Creates a typing indicator over the mob. */
/mob/proc/create_typing_indicator()
	return

/** Removes the typing indicator over the mob. */
/mob/proc/remove_typing_indicator()
	return

/** Removes any indicators and marks the mob as not speaking IC. */
/mob/proc/remove_all_indicators()
	return

/mob/set_stat(new_stat)
	. = ..()
	if(.)
		remove_all_indicators()

/mob/Logout()
	remove_all_indicators()
	return ..()

/** Sets the mob as "thinking" - with indicator and the TRAIT_THINKING_IN_CHARACTER trait */
/datum/tgui_say/proc/start_thinking()
	if(!window_open)
		return FALSE
	return client.start_thinking()

/** Removes typing/thinking indicators and flags the mob as not thinking */
/datum/tgui_say/proc/stop_thinking()
	return client.stop_thinking()

/**
 * Handles the user typing. After a brief period of inactivity,
 * signals the client mob to revert to the "thinking" icon.
 */
/datum/tgui_say/proc/start_typing()
	if(!window_open)
		return FALSE
	return client.start_typing()

/**
 * Remove the typing indicator after a brief period of inactivity or during say events.
 * If the user was typing IC, the thinking indicator is shown.
 */
/datum/tgui_say/proc/stop_typing()
	if(!window_open)
		return FALSE
	client.stop_typing()

/// Overrides for overlay creation
/mob/living/create_typing_indicator()
	if(hud_typing || typing || stat != CONSCIOUS)
		return FALSE
	set_typing_indicator(TRUE)

/mob/living/remove_typing_indicator()
	set_typing_indicator(FALSE)

/mob/living/remove_all_indicators()
	remove_typing_indicator()

