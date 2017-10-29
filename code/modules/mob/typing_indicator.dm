#define TYPING_INDICATOR_LIFETIME 30 * 10	//grace period after which typing indicator disappears regardless of text in chatbar

/mob
	var/hud_typing = FALSE //set when typing in an input window instead of chatline
	var/typing
	var/last_typed
	var/last_typed_time

	var/obj/effect/decal/typing_indicator

/mob/proc/set_typing_indicator(var/state)
	if(!typing_indicator)
		typing_indicator = new
		typing_indicator.icon = 'icons/mob/talk.dmi'
		typing_indicator.icon_state = "typing"

	if(client && !stat)
		typing_indicator.invisibility = invisibility
		if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
			overlays -= typing_indicator
		else
			if(state)
				if(!typing)
					overlays += typing_indicator
					typing = TRUE
			else
				if(typing)
					overlays -= typing_indicator
					typing = FALSE
			return state

/mob/proc/handle_typing_indicator()
	if(is_preference_enabled(/datum/client_preference/show_typing_indicator) && !hud_typing)
		var/temp = winget(client, "input", "text")

		if (temp != last_typed)
			last_typed = temp
			last_typed_time = world.time

		if (world.time > last_typed_time + TYPING_INDICATOR_LIFETIME)
			set_typing_indicator(FALSE)
			return
		if(length(temp) > 5 && findtext(temp, "Say \"", 1, 7))
			set_typing_indicator(TRUE)
		else if(length(temp) > 3 && findtext(temp, "Me ", 1, 5))
			set_typing_indicator(FALSE)

		else
			set_typing_indicator(TRUE)
