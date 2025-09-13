// please don't use these defines outside of this file in order to ensure a unified framework. unless you have a really good reason to make them global, then whatever

// these four are just text spans that furnish the TEXT itself with the appropriate CSS classes
#define MAJOR_ANNOUNCEMENT_TITLE(string) ("<span class='major_announcement_title'>" + string + "</span>")
#define SUBHEADER_ANNOUNCEMENT_TITLE(string) ("<span class='subheader_announcement_text'>" + string + "</span>")
#define MAJOR_ANNOUNCEMENT_TEXT(string) ("<span class='major_announcement_text'>" + string + "</span>")
#define MINOR_ANNOUNCEMENT_TITLE(string) ("<span class='minor_announcement_title'>" + string + "</span>")
#define MINOR_ANNOUNCEMENT_TEXT(string) ("<span class='minor_announcement_text'>" + string + "</span>")

#define ANNOUNCEMENT_HEADER(string) ("<span class='announcement_header'>" + string + "</span>")

// these two are the ones that actually give the striped background
#define CHAT_ALERT_DEFAULT_SPAN(string) ("<div class='chat_alert_default'>" + string + "</div>")
#define CHAT_ALERT_COLORED_SPAN(color, string) ("<div class='chat_alert_" + color + "'>" + string + "</div>")

#define ANNOUNCEMENT_COLORS list("default", "green", "blue", "pink", "yellow", "orange", "red", "purple", "grey", "amber", "crimson")

/**
 * Make a big red text announcement to
 *
 * Formatted like:
 *
 * " Message from sender "
 *
 * " Title "
 *
 * " Text "
 *
 * Arguments
 * * text - required, the text to announce
 * * title - optional, the title of the announcement.
 * * sound - optional, the sound played accompanying the announcement
 * * type - optional, the type of the announcement, for some "preset" announcement templates. See __DEFINES/announcements.dm
 * * sender_override - optional, modifies the sender of the announcement
 * * has_important_message - is this message critical to the game (and should not be overridden by station traits), or not
 * * players - a list of all players to send the message to. defaults to all players (not including new players)
 * * encode_title - if TRUE, the title will be HTML encoded
 * * encode_text - if TRUE, the text will be HTML encoded
 */
/proc/priority_announce(text, title = "", sound, type, sender_override, has_important_message = FALSE, list/mob/players = GLOB.player_list, encode_title = TRUE, encode_text = TRUE, color_override, append_update = FALSE, use_text_to_speech = FALSE)
	if(!text)
		return

	if(encode_title && title && length(title) > 0)
		title = html_encode(title)
	if(encode_text)
		text = html_encode(text)
		if(!length(text))
			return

	var/list/announcement_strings = list()

	// if(!sound)
	// 	sound = SSship.announcer.get_rand_alert_sound()
	// else if(SSstation.announcer.event_sounds[sound])
	// 	sound = SSstation.announcer.event_sounds[sound]

	var/header
	switch(type)
		if(ANNOUNCEMENT_TYPE_PRIORITY)
			header = MAJOR_ANNOUNCEMENT_TITLE("Priority Announcement")
			if(length(title) > 0)
				header += SUBHEADER_ANNOUNCEMENT_TITLE(title)
		if(ANNOUNCEMENT_TYPE_CAPTAIN)
			header = MAJOR_ANNOUNCEMENT_TITLE("Captain's Announcement")

			DirectNewsCast(text, "Captain's Announcement", "Ship Announcements", "")
		if(ANNOUNCEMENT_TYPE_AI)
			var/mob/living/silicon/ai/sender = usr
			if(!istype(sender))
				CRASH("Non-AI tried to send an AI ship announcement")
			header = MAJOR_ANNOUNCEMENT_TITLE("Ship Announcement by [sender.name] (AI)")
		else
			header += generate_unique_announcement_header(title, sender_override, append_update)

	announcement_strings += ANNOUNCEMENT_HEADER(header)

	announcement_strings += MAJOR_ANNOUNCEMENT_TEXT(text)

	var/finalized_announcement
	if(color_override)
		finalized_announcement = CHAT_ALERT_COLORED_SPAN(color_override, jointext(announcement_strings, ""))
	else
		finalized_announcement = CHAT_ALERT_DEFAULT_SPAN(jointext(announcement_strings, ""))

	dispatch_announcement_to_players(finalized_announcement, players, sound)

	if(isnull(sender_override) && players == GLOB.player_list)
		if(length(title) > 0)
			DirectNewsCast(title + "<br><br>" + text, "[station_name()]", "Ship Announcements", "")
		else
			DirectNewsCast(text, "[station_name()][append_update ? " Update" : ""]", "Ship Announcements", "")


/proc/DirectNewsCast(message, author, channel_name, type = "Story", can_be_redacted = FALSE)
	var/datum/news_announcement/news = new
	news.message = message
	news.author = author
	news.channel_name = channel_name
	news.message_type = type
	news.can_be_redacted = 0
	announce_newscaster_news(news)


/**
 * Sends a minor annoucement to players.
 * Minor announcements are large text, with the title in red and message in white.
 * Only mobs that can hear can see the announcements.
 *
 * message - the message contents of the announcement.
 * title - the title of the announcement, which is often "who sent it".
 * alert - whether this announcement is an alert, or just a notice. Only changes the sound that is played by default.
 * html_encode - if TRUE, we will html encode our title and message before sending it, to prevent player input abuse.
 * players - optional, a list mobs to send the announcement to. If unset, sends to all palyers.
 * sound_override - optional, use the passed sound file instead of the default notice sounds.
 * should_play_sound - Whether the notice sound should be played or not.
 * color_override - optional, use the passed color instead of the default notice color.
 */
/proc/minor_announce(message, title = "Attention:", alert = FALSE, html_encode = TRUE, list/players, sound_override, should_play_sound = TRUE, color_override, use_text_to_speech = FALSE)
	if(!message)
		return

	if (html_encode)
		title = html_encode(title)
		message = html_encode(message)

	var/list/minor_announcement_strings = list()
	if(title != null && title != "")
		minor_announcement_strings += ANNOUNCEMENT_HEADER(MINOR_ANNOUNCEMENT_TITLE(title))
	minor_announcement_strings += MINOR_ANNOUNCEMENT_TEXT(message)

	var/finalized_announcement
	if(color_override)
		finalized_announcement = CHAT_ALERT_COLORED_SPAN(color_override, jointext(minor_announcement_strings, ""))
	else
		finalized_announcement = CHAT_ALERT_DEFAULT_SPAN(jointext(minor_announcement_strings, ""))

	var/custom_sound = sound_override || (alert ? 'sound/misc/notice1.ogg' : 'sound/misc/notice2.ogg')
	dispatch_announcement_to_players(finalized_announcement, players, custom_sound, should_play_sound)


/**
 * Sends a div formatted chat box announcement
 *
 * Formatted like:
 *
 * " Server Announcement " (or sender_override)
 *
 * " Title "
 *
 * " Text "
 *
 * Arguments
 * * text - required, the text to announce
 * * title - optional, the title of the announcement.
 * * players - optional, a list of all players to send the message to. defaults to the entire world
 * * play_sound - if TRUE, play a sound with the announcement (based on player option)
 * * sound_override - optional, override the default announcement sound
 * * sender_override - optional, modifies the sender of the announcement
 * * encode_title - if TRUE, the title will be HTML encoded
 * * encode_text - if TRUE, the text will be HTML encoded
 * * color_override - optional, set a color for the announcement box
 */

/proc/send_formatted_announcement(
	text,
	title = "",
	players,
	play_sound = TRUE,
	sound_override = 'sound/misc/notice2.ogg',
	sender_override = "Server Admin Announcement",
	encode_title = TRUE,
	encode_text = FALSE,
	color_override = "grey",
)
	if(isnull(text))
		return

	var/list/announcement_strings = list()

	if(encode_title && title && length(title) > 0)
		title = html_encode(title)
		if(encode_text)
			text = html_encode(text)
			if(!length(text))
				return

		announcement_strings += span_announcement_header(generate_unique_announcement_header(title, sender_override))
		announcement_strings += span_major_announcement_text(text)
		var/finalized_announcement = create_announcement_div(jointext(announcement_strings, ""), color_override)

		if(islist(players))
			for(var/mob/target in players)
				to_chat(target, finalized_announcement)
				if(play_sound && target.client?.get_preference_value(/datum/client_preference/play_sound_announcements))
					SEND_SOUND(target, sound(sound_override))
		else
			to_chat(world, finalized_announcement)

			if(!play_sound)
				return

			for(var/mob/player in GLOB.player_list)
				if(player.client?.get_preference_value(/datum/client_preference/play_sound_announcements))
					SEND_SOUND(player, sound(sound_override))


/**
 * Inserts a span styled message into an alert box div
 *
 *
 * Arguments
 * * message - required, the message contents
 * * color - optional, set a div color other than default
 */
/proc/create_announcement_div(message, color = "default")
	var/processed_message = "<div class='chat_alert_[color]'>[message]</div>"
	return processed_message

/// Proc that just generates a custom header based on variables fed into `priority_announce()`
/// Will return a string.
/proc/generate_unique_announcement_header(title, sender_override, append_update = TRUE)
	var/list/returnable_strings = list()
	if(isnull(sender_override))
		returnable_strings += MAJOR_ANNOUNCEMENT_TITLE("[station_name()][append_update ? " Update" : ""]")
	else
		returnable_strings += MAJOR_ANNOUNCEMENT_TITLE("[sender_override][append_update ? " Update" : ""]")

	if(length(title) > 0)
		returnable_strings += SUBHEADER_ANNOUNCEMENT_TITLE(title)

	return jointext(returnable_strings, "")

/// Proc that just dispatches the announcement to our applicable audience. Only the announcement is a mandatory arg.
/proc/dispatch_announcement_to_players(announcement, list/mob/players = GLOB.player_list, sound_override = null, should_play_sound = TRUE)
	var/sound_to_play = !isnull(sound_override) ? sound_override : 'sound/misc/notice2.ogg'

	for(var/mob/target in players)
		if (players == GLOB.player_list && isnewplayer(target))
			continue

		to_chat(target, announcement)
		if(!should_play_sound)
			continue

		if(target.client?.get_preference_value(/datum/client_preference/play_sound_announcements) && !isdeaf(target))
			var/sound/mixed_sound = sound(sound_to_play)
			// if("[CHANNEL_VOX]" in target.client?.prefs?.channel_volume)
			// 	mixed_sound.volume = target.client?.prefs?.channel_volume["[CHANNEL_VOX]"]
			if(!isnull(target.client))
				SEND_SOUND(target, mixed_sound)

/proc/GetNameAndAssignmentFromId(obj/item/card/id/I)
	// Format currently matches that of newscaster feeds: Registered Name (Assigned Rank)
	return I.assignment ? "[I.registered_name] ([I.assignment])" : I.registered_name

/proc/level_seven_announcement()
	priority_announce("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak7.ogg')

/proc/level_eight_announcement() //new announcment so the crew doesn't have to fuck around trying to figure out if its a blob, hivemind, or a literal fungus
	priority_announce("Confirmed outbreak of level 8 Bio-mechanical infestation aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")

/proc/level_eight_beta_announcement() //announcment which tells the crew that the hivemind has been killed, job well done crew.
	priority_announce("Diagnostic Systems report level 8 Bio-mechanical infestation aboard [station_name()] has been contained.")

/proc/ion_storm_announcement()
	priority_announce("Ion storm detected near the ship. Please check all AI and electronic equipment for errors.", "Anomaly Alert")

/proc/AnnounceArrival(mob/living/character, rank, join_message)
	if (join_message && SSticker.IsRoundInProgress() && SSjob.ShouldCreateRecords(rank))
		if(issilicon(character))
			GLOB.announcer.autosay("A new [rank] [join_message].", ANNOUNCER_NAME, use_text_to_speech = TRUE)
		else
			GLOB.announcer.autosay("[character.real_name], [rank], [join_message].", ANNOUNCER_NAME, use_text_to_speech = TRUE)

#undef MAJOR_ANNOUNCEMENT_TITLE
#undef MAJOR_ANNOUNCEMENT_TEXT
#undef MINOR_ANNOUNCEMENT_TITLE
#undef MINOR_ANNOUNCEMENT_TEXT
#undef CHAT_ALERT_DEFAULT_SPAN
#undef CHAT_ALERT_COLORED_SPAN
