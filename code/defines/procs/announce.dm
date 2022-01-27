/var/datum/announcement/priority/priority_announcement =69ew(do_lo69 = 0)
/var/datum/announcement/priority/command/command_announcement =69ew(do_lo69 = 0, do_newscast = 1)

/datum/announcement
	var/title = "Attention"
	var/announcer = ""
	var/lo69 = 0
	var/sound
	var/newscast = 0
	var/channel_name = "Ship Announcements"
	var/announcement_type = "Announcement"

/datum/announcement/New(var/do_lo69 = 0,69ar/new_sound =69ull,69ar/do_newscast = 0)
	sound =69ew_sound
	lo69 = do_lo69
	newscast = do_newscast

/datum/announcement/priority/New(var/do_lo69 = 1,69ar/new_sound = 'sound/misc/notice2.o6969',69ar/do_newscast = 0)
	..(do_lo69,69ew_sound, do_newscast)
	title = "Priority Announcement"
	announcement_type = "Priority Announcement"

/datum/announcement/priority/command/New(var/do_lo69 = 1,69ar/new_sound = 'sound/misc/notice2.o6969',69ar/do_newscast = 0)
	..(do_lo69,69ew_sound, do_newscast)
	title = "69command_name()69 Update"
	announcement_type = "69command_name()69 Update"

/datum/announcement/priority/security/New(var/do_lo69 = 1,69ar/new_sound = 'sound/misc/notice2.o6969',69ar/do_newscast = 0)
	..(do_lo69,69ew_sound, do_newscast)
	title = "Security Announcement"
	announcement_type = "Security Announcement"

/datum/announcement/proc/Announce(var/messa69e as text,69ar/new_title = "",69ar/new_sound =69ull,69ar/do_newscast =69ewscast,69ar/ms69_sanitized = 0,69ar/zlevels = 69LOB.maps_data.contact_levels)
	if(!messa69e)
		return
	var/messa69e_title =69ew_title ?69ew_title : title
	var/messa69e_sound =69ew_sound ?69ew_sound : sound

	if(!ms69_sanitized)
		messa69e = sanitize(messa69e, extra = 0)
	messa69e_title = html_encode(messa69e_title)

	Messa69e(messa69e,69essa69e_title)
	if(do_newscast)
		NewsCast(messa69e,69essa69e_title)

	for(var/mob/M in 69LOB.player_list)
		if((M.z in (zlevels | 69LOB.maps_data.admin_levels)) && !istype(M,/mob/new_player) && !isdeaf(M) &&69essa69e_sound)
			sound_to(M,69essa69e_sound)
	Lo69(messa69e,69essa69e_title)

datum/announcement/proc/Messa69e(messa69e as text,69essa69e_title as text)
	69lobal_announcer.autosay("<span class='warnin69'>69title69:</span> 69messa69e69", announcer ? announcer : ANNOUNCER_NAME)

datum/announcement/minor/Messa69e(messa69e as text,69essa69e_title as text)
	69lobal_announcer.autosay(messa69e, ANNOUNCER_NAME)

datum/announcement/priority/Messa69e(messa69e as text,69essa69e_title as text)
	69lobal_announcer.autosay("<span class='alert'>69messa69e_title69:</span> 69messa69e69", announcer ? announcer : ANNOUNCER_NAME)

datum/announcement/priority/command/Messa69e(messa69e as text,69essa69e_title as text)
	69lobal_announcer.autosay("<span class='warnin69'>69messa69e_title69:</span> 69messa69e69", ANNOUNCER_NAME)

datum/announcement/priority/security/Messa69e(messa69e as text,69essa69e_title as text)
	69lobal_announcer.autosay("<font color='red'>69messa69e_title69:</span> 69messa69e69", ANNOUNCER_NAME)

datum/announcement/proc/NewsCast(messa69e as text,69essa69e_title as text)
	if(!newscast)
		return

	var/datum/news_announcement/news =69ew
	news.channel_name = channel_name
	news.author = announcer
	news.messa69e =69essa69e
	news.messa69e_type = announcement_type
	news.can_be_redacted = 0
	announce_newscaster_news(news)

datum/announcement/proc/PlaySound(var/messa69e_sound)
	if(!messa69e_sound)
		return
	for(var/mob/M in 69LOB.player_list)
		if(!isnewplayer(M) && !isdeaf(M))
			M <<69essa69e_sound

datum/announcement/proc/Sound(var/messa69e_sound)
	PlaySound(messa69e_sound)

datum/announcement/priority/Sound(var/messa69e_sound)
	if(messa69e_sound)
		world <<69essa69e_sound

datum/announcement/priority/command/Sound(var/messa69e_sound)
	PlaySound(messa69e_sound)

datum/announcement/proc/Lo69(messa69e as text,69essa69e_title as text)
	if(lo69)
		lo69_say("69key_name(usr)69 has69ade \a 69announcement_type69: 69messa69e_title69 - 69messa69e69 - 69announcer69")
		messa69e_admins("69key_name_admin(usr)69 has69ade \a 69announcement_type69.", 1)

/proc/69etNameAndAssi69nmentFromId(var/obj/item/card/id/I)
	// Format currently69atches that of69ewscaster feeds: Re69istered69ame (Assi69ned Rank)
	return I.assi69nment ? "69I.re69istered_name69 (69I.assi69nment69)" : I.re69istered_name

/proc/level_seven_announcement()
	command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard 69station_name()69. All personnel69ust contain the outbreak.", "Biohazard Alert",69ew_sound = 'sound/AI/outbreak7.o6969')

/proc/level_ei69ht_announcement() //new announcment so the crew doesn't have to fuck around tryin69 to fi69ure out if its a blob, hivemind, or a literal fun69us
	command_announcement.Announce("Confirmed outbreak of level 8 Bio-mechanical infestation aboard 69station_name()69. All personnel69ust contain the outbreak.", "Biohazard Alert")

/proc/level_ei69ht_beta_announcement() //announcment which tells the crew that the hivemind has been killed, job well done crew.
	command_announcement.Announce("Dia69nostic Systems report level 8 Bio-mechanical infestation aboard 69station_name()69 has been contained.")

/proc/level_nine_announcement()
	command_announcement.Announce("Confirmed outbreak of level 9 Excelsior communist infestation aboard 69station_name()69. All personnel69ust contain the outbreak.", "Biohazard Alert")

/proc/ion_storm_announcement()
	command_announcement.Announce("It has come to our attention that the ship passed throu69h an ion storm.  Please69onitor all electronic equipment for69alfunctions.", "Anomaly Alert")

/proc/AnnounceArrival(var/mob/livin69/character,69ar/rank,69ar/join_messa69e)
	if (join_messa69e && SSticker.current_state == 69AME_STATE_PLAYIN69 && SSjob.ShouldCreateRecords(rank))
		if(issilicon(character))
			69lobal_announcer.autosay("A69ew 69rank69 69join_messa69e69.", ANNOUNCER_NAME)
		else
			69lobal_announcer.autosay("69character.real_name69, 69rank69, 69join_messa69e69.", ANNOUNCER_NAME)
