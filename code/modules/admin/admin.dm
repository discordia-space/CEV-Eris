
var/global/BSACooldown = 0
var/global/floorIsLava = 0
#define NO_ANTAG 0
#define LIMITED_ANTAG 1
#define ANTAG 2


////////////////////////////////
/proc/message_admins(msg)
	msg = "<span class='admin'><span class='prefix'>ADMIN LOG:</span> <span class='message'>[msg]</span></span>"
	to_chat(GLOB.admins,
		type = MESSAGE_TYPE_ADMINLOG,
		html = msg,
		confidential = TRUE)

/proc/msg_admin_attack(text) //Toggleable Attack Messages
	log_attack(text)
	var/rendered = "<span class='log_message'><span class='prefix'>ATTACK:</span> <span class='message'>[text]</span></span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			if(C.get_preference_value(/datum/client_preference/staff/show_attack_logs) == GLOB.PREF_SHOW)
				var/msg = rendered
				to_chat(C, msg)

/**
 * Sends a message to the staff able to see admin tickets
 * Arguments:
 * msg - The message being send
 * important - If the message is important. If TRUE it will ignore the PREF_HEAR preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/proc/message_adminTicket(msg, important = FALSE)
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			if(important || (C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR))
				sound_to(C, 'sound/effects/adminhelp.ogg')

/**
 * Sends a message to the staff able to see mentor tickets
 * Arguments:
 * msg - The message being send
 * important - If the message is important. If TRUE it will ignore the PREF_HEAR preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/proc/message_mentorTicket(msg, important = FALSE)
	for(var/client/C in GLOB.admins)
		if(check_rights(R_ADMIN | R_MENTOR, 0, C.mob))
			to_chat(C, msg)
			if(important || (C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR))
				sound_to(C, 'sound/effects/adminhelp.ogg')

/proc/admin_notice(message, rights)
	var/list/mob_list = SSmobs.mob_list | SShumans.mob_list
	for(var/mob/M in mob_list)
		if(check_rights(rights, 0, M))
			to_chat(M, message)

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/view_log_panel(mob/M)
	if(!M)
		to_chat(usr, "That mob doesn't seem to exist! Something went wrong.")
		return

	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<center>Logs of <b>[M]</b><br>"
	body += "<a href='byond://?src=\ref[src];[HrefToken()]viewlogs=\ref[M]'>REFRESH</a></center><br>"


	var/i = length(M.attack_log)
	while(i > 0)
		body += M.attack_log[i] + "<br>"
		i--

	usr << browse(HTML_SKELETON_TITLE("Log Panel of [M.real_name]", body), "window=\ref[M]logs;size=500x500")


/// shows an interface for individual players, with various links (links require additional flags
/datum/admins/proc/show_player_panel(mob/M in GLOB.mob_list)
	set category = null
	set name = "Show Player Panel"
	set desc = "Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a mob that doesn't exist anymore.")
		return
	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = ""
	body += "Options panel for <b>[M]</b>"

	if(M.client)
		body += " played by <b><a href='http://byond.com/members/[M.client.ckey]'>[M.client]</b></a> "
		body += "\[<A href='byond://?src=\ref[src];[HrefToken()];editrights=show'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\]<br>"
		body += "<b>Registration date:</b> [M.client.account_join_date ? M.client.account_join_date : "Unknown"]<br>"
		body += "<b>IP:</b> [M.client.address ? M.client.address : "Unknown"]<br>"

		var/country = M.client.country
		var/country_code = M.client.country_code
		if(country && country_code)
			// TODO (28.07.17): uncomment after flag icons resize
			// <img src=\"flag_[country_code].png\">
			// usr << browse_rsc(icon('icons/country_flags.dmi', country_code), "flag_[country_code].png")
			body += "<b>Country:</b> [country]<br><br>"


	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \[<A href='byond://?src=\ref[src];[HrefToken()];revive=\ref[M]'>Heal</A>\] "

	if(M.ckey)
		body += "<br>\[<A href='byond://?_src_=holder;[HrefToken()];ppbyckey=[M.ckey];ppbyckeyorigmob=\ref[M]'>Find Updated Panel</A>\]"

	body += {"
		<br><br>\[
		<a href='byond://?_src_=vars;[HrefToken()];Vars=\ref[M]'>VV</a> -
		<a href='byond://?src=\ref[src];[HrefToken()];contractor=\ref[M]'>TP</a> -
		<a href='byond://?src=\ref[usr];[HrefToken()];priv_msg=\ref[M]'>PM</a> -
		<a href='byond://?src=\ref[src];[HrefToken()];subtlemessage=\ref[M]'>SM</a> -
		<a href='byond://?src=\ref[src];[HrefToken()];manup=\ref[M]'>MAN_UP</a> -
		<a href='byond://?src=\ref[src];[HrefToken()];paralyze=\ref[M]'>PARA</a> -
		[admin_jump_link(M, src)] -
		<a href='byond://?src=\ref[src];[HrefToken()];viewlogs=\ref[M]'>LOGS</a>\] <br>
		<b>Mob type</b> = [M.type]<br><br>
		<A href='byond://?src=\ref[src];[HrefToken()];boot2=\ref[M]'>Kick</A> |
		<A href='byond://?_src_=holder;[HrefToken()];warn=[M.ckey]'>Warn</A> |
		<A href='byond://?src=\ref[src];[HrefToken()];notes=show;mob=\ref[M]'>Notes</A> |
	"}

	if(M.client)
		body += "<A href='byond://?_src_=holder;[HrefToken()];newbankey=[M.key];newbanip=[M.client.address];newbancid=[M.client.computer_id]'>Ban</A> | "
	else
		body += "<A href='byond://?_src_=holder;[HrefToken()];newbankey=[M.key]'>Ban</A> | "

	body += "<A href='byond://?_src_=holder;[HrefToken()];showmessageckey=[M.ckey]'>Notes | Messages | Watchlist</A> | "
	if(M.client)
		body += "\ <A href='byond://?_src_=holder;[HrefToken()];sendbacktolobby=\ref[M]'>Send back to Lobby</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\[<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"blue"]'>IC</font></a> |
			<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"blue"]'>OOC</font></a> |
			<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"blue"]'>PRAY</font></a> |
			<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"blue"]'>ADMINHELP</font></a> |
			<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"blue"]'>DEADCHAT</font></a>\]
			<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_TTS]'><font color='[(muted & MUTE_TTS)?"red":"blue"]'>TTS</font></a>\]
			(<A href='byond://?src=\ref[src];[HrefToken()];mute=\ref[M];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"blue"]'>toggle all</font></a>)
		"}

	body += {"<br><br>
		<A href='byond://?src=\ref[src];[HrefToken()];jumpto=\ref[M]'><b>Jump to</b></A> |
		<A href='byond://?src=\ref[src];[HrefToken()];getmob=\ref[M]'>Get</A>
		<br><br>
		[check_rights(R_ADMIN,0) ? "<A href='byond://?src=\ref[src];[HrefToken()];contractor=\ref[M]'>Contractor panel</A> | " : "" ]
		<A href='byond://?src=\ref[src];[HrefToken()];narrateto=\ref[M]'>Narrate to</A> |
		<A href='byond://?src=\ref[src];[HrefToken()];subtlemessage=\ref[M]'>Subtle message</A>
	"}

	if (M.client)
		if(!isnewplayer(M))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='byond://?src=\ref[src];[HrefToken()];makeai=\ref[M]'>Make AI</A> |
					<A href='byond://?src=\ref[src];[HrefToken()];makerobot=\ref[M]'>Make Robot</A> |
					<A href='byond://?src=\ref[src];[HrefToken()];makeslime=\ref[M]'>Make slime</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='byond://?src=\ref[src];[HrefToken()];makeanimal=\ref[M]'>Re-Animalize</A> | "
			else
				body += "<A href='byond://?src=\ref[src];[HrefToken()];makeanimal=\ref[M]'>Animalize</A> | "

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new mob type and copy stuff over. They do not take into account MMIs and similar mob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=observer;mob=\ref[M]'>Observer</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=angel;mob=\ref[M]'>ANGEL</A> |
				\[ Crew: <A href='byond://?src=\ref[src];[HrefToken()];simplemake=human;mob=\ref[M]'>Human</A>
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=nymph;mob=\ref[M]'>Nymph</A>
				\[ slime: <A href='byond://?src=\ref[src];[HrefToken()];simplemake=slime;mob=\ref[M]'>Baby</A>,
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=adultslime;mob=\ref[M]'>Adult</A> \]
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=monkey;mob=\ref[M]'>Monkey</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=robot;mob=\ref[M]'>Cyborg</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=cat;mob=\ref[M]'>Cat</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=runtime;mob=\ref[M]'>Runtime</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=corgi;mob=\ref[M]'>Corgi</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=ian;mob=\ref[M]'>Ian</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=crab;mob=\ref[M]'>Crab</A> |
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=coffee;mob=\ref[M]'>Coffee</A> |
				\[ Construct: <A href='byond://?src=\ref[src];[HrefToken()];simplemake=constructarmoured;mob=\ref[M]'>Armoured</A> ,
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=constructbuilder;mob=\ref[M]'>Builder</A> ,
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=constructwraith;mob=\ref[M]'>Wraith</A> \]
				<A href='byond://?src=\ref[src];[HrefToken()];simplemake=shade;mob=\ref[M]'>Shade</A>
				<br>
			"}
	body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='byond://?src=\ref[src];[HrefToken()];forcespeech=\ref[M]'>Forcesay</A> |
			<A href='byond://?src=\ref[src];[HrefToken()];forcesanity=\ref[M]'>Sanity Break</A>
			"}
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	for(var/k in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[k]
		if(!(L.flags & INNATE))
			if(!f) body += " | "
			else f = 0
			if(L in M.languages)
				body += "<a href='byond://?src=\ref[src];[HrefToken()];toglang=\ref[M];lang=[html_encode(k)]' style='color:#006600'>[k]</a>"
			else
				body += "<a href='byond://?src=\ref[src];[HrefToken()];toglang=\ref[M];lang=[html_encode(k)]' style='color:#ff0000'>[k]</a>"

	body += "<br>"

	usr << browse(HTML_SKELETON_TITLE("Options for [M.key]", body), "window=adminplayeropts;size=550x515")

/// Admin who authored the information
/datum/player_info/var/author
/// Rank of admin who made the notes
/datum/player_info/var/rank
/// Text content of the information
/datum/player_info/var/content
/// Because this is bloody annoying
/datum/player_info/var/timestamp

/// allows access of newscasters
/datum/admins/proc/access_news_network() //MARKER
	set category = "Fun"
	set name = "Access Newscaster Network"
	set desc = "Allows you to view, add and edit news feeds."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return
	var/dat
	dat = text("<HEAD><TITLE>Admin Newscaster</TITLE></HEAD><H3>Admin Newscaster Unit</H3>")

	switch(admincaster_screen)
		if(0)
			dat += {"Welcome to the admin newscaster.<BR> Here you can add, edit and censor every newspiece on the network.
				<BR>Feed channels and stories entered through here will be uneditable and handled as official news by the rest of the units.
				<BR>Note that this panel allows full freedom over the news network, there are no constrictions except the few basic ones. Don't break things!
			"}
			if(news_network.wanted_issue)
				dat+= "<HR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=view_wanted'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=create_channel'>Create Feed Channel</A>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=view'>View Feed Channels</A>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=create_feed_story'>Submit new Feed story</A>
				<BR><BR><A href='byond://?src=\ref[usr];mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(news_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=menu_wanted'>[(wanted_already) ? ("Manage") : ("Publish")] \"Wanted\" Issue</A>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=menu_censor_story'>Censor Feed Stories</A>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=menu_censor_channel'>Mark Feed Channel with [GLOB.company_name] D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_signature'>The newscaster recognises you as:<BR> <FONT COLOR='green'>[src.admincaster_signature]</FONT></A>
			"}
		if(1)
			dat+= "Station Feed Channels<HR>"
			if( isemptylist(news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='byond://?src=\ref[src];[HrefToken()];admincaster=show_channel;show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A></FONT></B><BR>"
					else
						dat+="<B><A href='byond://?src=\ref[src];[HrefToken()];admincaster=show_channel;show_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR></B>"
			dat+={"<BR><HR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=refresh'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_channel_name'>Channel Name</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>
				<B><A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_signature'>Channel Author</A>:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_channel_lock'>Will Accept Public Feeds</A>:</B> [(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")]<BR><BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=submit_new_channel'>Submit</A><BR><BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed Message...
				<HR><B><A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_channel_receiving'>Receiving Channel</A>:</B> [src.admincaster_feed_channel.channel_name]<BR>" //MARK
				<B>Message Author:</B> <FONT COLOR='green'>[src.admincaster_signature]</FONT><BR>
				<B><A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_new_message'>Message Body</A>:</B> [src.admincaster_feed_message.body] <BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=submit_new_message'>Submit</A><BR><BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to [src.admincaster_feed_channel.channel_name].<BR><BR>
					<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel [src.admincaster_feed_channel.channel_name] created successfully.<BR><BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Return</A><BR>
			"}
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid message body.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[3]'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[2]'>Return</A><BR>"
		if(9)
			dat+="<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT>\]</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a [GLOB.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						dat+="-[MESSAGE.body] <BR>"
						if(MESSAGE.img)
							usr << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
							dat+="<img src='tmp_photo[i].png' width = '180'><BR><BR>"
						dat+="<FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"
			dat+={"
				<BR><HR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=refresh'>Refresh</A>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[1]'>Back</A>
			"}
		if(10)
			dat+={"
				<B>[GLOB.company_name] Feed Censorship Tool</B><BR>
				<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in mind that users attempting to view a censored feed will instead see the \[REDACTED\] tag above it.</FONT>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];[HrefToken()];admincaster=pick_censor_channel;pick_censor_channel=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Cancel</A>"
		if(11)
			dat+={"
				<B>[GLOB.company_name] D-Notice Handler</B><HR>
				<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it might contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='byond://?src=\ref[src];[HrefToken()];admincaster=pick_d_notice;pick_d_notice=\ref[CHANNEL]'>[CHANNEL.channel_name]</A> [(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null]<BR>"

			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Back</A>"
		if(12)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				<FONT SIZE=2><A href='byond://?src=\ref[src];[HrefToken()];admincaster=censor_channel_author;censor_channel_author=\ref[src.admincaster_feed_channel]'>[(src.admincaster_feed_channel.author=="\[REDACTED\]") ? ("Undo Author censorship") : ("Censor channel Author")]</A></FONT><HR>
			"}
			if( isemptylist(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed messages found in channel...</I><BR>"
			else
				for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+={"
						-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>
						<FONT SIZE=2><A href='byond://?src=\ref[src];[HrefToken()];admincaster=censor_channel_story_body;censor_channel_story_body=\ref[MESSAGE]'>[(MESSAGE.body == "\[REDACTED\]") ? ("Undo story censorship") : ("Censor story")]</A>  -  <A href='byond://?src=\ref[src];[HrefToken()];admincaster=censor_channel_story_author;censor_channel_story_author=\ref[MESSAGE]'>[(MESSAGE.author == "\[REDACTED\]") ? ("Undo Author Censorship") : ("Censor message Author")]</A></FONT><BR>
					"}
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[10]'>Back</A>"
		if(13)
			dat+={"
				<B>[src.admincaster_feed_channel.channel_name]: </B><FONT SIZE=1>\[ created by: <FONT COLOR='maroon'>[src.admincaster_feed_channel.author]</FONT> \]</FONT><BR>
				Channel messages listed below. If you deem them dangerous to the station, you can <A href='byond://?src=\ref[src];[HrefToken()];admincaster=toggle_d_notice;toggle_d_notice=\ref[src.admincaster_feed_channel]'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and marked with a [GLOB.company_name] D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed messages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-[MESSAGE.body] <BR><FONT SIZE=1>\[Story by <FONT COLOR='maroon'>[MESSAGE.author]</FONT>\]</FONT><BR>"

			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[11]'>Back</A>"
		if(14)
			dat+="<B>Wanted Issue Handler:</B>"
			var/wanted_already = 0
			var/end_param = 1
			if(news_network.wanted_issue)
				wanted_already = 1
				end_param = 2
			if(wanted_already)
				dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
			dat+={"
				<HR>
				<A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_wanted_name'>Criminal Name</A>: [src.admincaster_feed_message.author] <BR>
				<A href='byond://?src=\ref[src];[HrefToken()];admincaster=set_wanted_desc'>Description</A>: [src.admincaster_feed_message.body] <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> [news_network.wanted_issue.backup_author]</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> [src.admincaster_signature]</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=submit_wanted;submit_wanted=[end_param]'>[(wanted_already) ? ("Edit Issue") : ("Submit")]</A>"
			if(wanted_already)
				dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=cancel_wanted'>Take down Issue</A>"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Cancel</A>"
		if(15)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] is now in Network Circulation.</FONT><BR><BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Return</A><BR>
			"}
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\[REDACTED\]")
				dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Return</A><BR>
			"}
		if(18)
			dat+={"
				<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\[Submitted by: <FONT COLOR='green'>[news_network.wanted_issue.backup_author]</FONT>\]</FONT><HR>
				<B>Criminal</B>: [news_network.wanted_issue.author]<BR>
				<B>Description</B>: [news_network.wanted_issue.body]<BR>
				<B>Photo:</B>:
			"}
			if(news_network.wanted_issue.img)
				usr << browse_rsc(news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Back</A><BR>"
		if(19)
			dat+={"
				<FONT COLOR='green'>Wanted issue for [src.admincaster_feed_message.author] successfully edited.</FONT><BR><BR>
				<BR><A href='byond://?src=\ref[src];[HrefToken()];admincaster=setScreen;setScreen=[0]'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

	//world << "Channelname: [src.admincaster_feed_channel.channel_name] [src.admincaster_feed_channel.author]"
	//world << "Msg: [src.admincaster_feed_message.author] [src.admincaster_feed_message.body]"
	usr << browse(HTML_SKELETON_TITLE("Admincaster", dat), "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")

/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = "<center><B>Game Panel</B></center><hr>"
	if(get_storyteller() && (SSticker.current_state != GAME_STATE_PREGAME))
		dat += "<A href='byond://?src=\ref[get_storyteller()]'>Storyteller Panel</A><br>"
	else
		dat += "<A href='byond://?src=\ref[src];[HrefToken()];c_mode=1'>Change Storyteller</A><br>"

	dat += {"
		<BR>
		<A href='byond://?src=\ref[src];[HrefToken()];create_object=1'>Create Object</A><br>
		<A href='byond://?src=\ref[src];[HrefToken()];quick_create_object=1'>Quick Create Object</A><br>
		<A href='byond://?src=\ref[src];[HrefToken()];create_turf=1'>Create Turf</A><br>
		<A href='byond://?src=\ref[src];[HrefToken()];create_mob=1'>Create Mob</A><br>
		<br><A href='byond://?src=\ref[src];[HrefToken()];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='byond://?src=\ref[src];[HrefToken()];vsc=plasma'>Edit Plasma Settings</A><br>
		<A href='byond://?src=\ref[src];[HrefToken()];vsc=default'>Choose a default ZAS setting</A><br>
		"}

	usr << browse(HTML_SKELETON_TITLE("Game Panel", dat), "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets()
	if(!check_rights(0))
		return

	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"
	for(var/datum/admin_secret_category/category in admin_secrets.categories)
		if(!category.can_view(usr))
			continue
		dat += "<B>[category.name]</B><br>"
		if(category.desc)
			dat += "<I>[category.desc]</I><BR>"
		for(var/datum/admin_secret_item/item in category.items)
			if(!item.can_view(usr))
				continue
			dat += "<A href='byond://?src=\ref[src];[HrefToken()];admin_secrets=\ref[item]'>[item.name()]</A><BR>"
		dat += "<BR>"
	usr << browse(HTML_SKELETON_TITLE("Secrets", dat), "window=secrets")
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs

/datum/admins/proc/restart()
	set category = "Server"
	set name = "Reboot World"
	set desc = "Restarts the world immediately"
	if (!usr.client.holder)
		return

	var/localhost_addresses = list("127.0.0.1", "::1")
	var/list/options = list("Regular Restart", "Regular Restart (with delay)", "Hard Restart (No Delay/Feedback Reason)", "Hardest Restart (No actions, just reboot)")
	if(world.TgsAvailable())
		options += "Server Restart (Kill and restart DD)";

	if(SSticker.admin_delay_notice)
		if(alert(usr, "Are you sure? An admin has already delayed the round end for the following reason: [SSticker.admin_delay_notice]", "Confirmation", "Yes", "No") != "Yes")
			return FALSE

	var/result = input(usr, "Select reboot method", "World Reboot", options[1]) as null|anything in options
	if(result)
		// SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		var/init_by = "Initiated by [usr.client.holder.fakekey ? "Admin" : usr.key]."
		switch(result)
			if("Regular Restart")
				if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
					if(alert(usr, "Are you sure you want to restart the server?","This server is live", "Restart", "Cancel") != "Restart")
						return FALSE
				// SSplexora.restart_requester = usr
				// SSplexora.restart_type = PLEXORA_SHUTDOWN_NORMAL
				SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", 10)
			if("Regular Restart (with delay)")
				var/delay = input("What delay should the restart have (in seconds)?", "Restart Delay", 5) as num|null
				if(!delay)
					return FALSE
				if(!(isnull(usr.client.address) || (usr.client.address in localhost_addresses)))
					if(alert(usr,"Are you sure you want to restart the server?","This server is live", "Restart", "Cancel") != "Restart")
						return FALSE
				// SSplexora.restart_requester = usr
				// SSplexora.restart_type = PLEXORA_SHUTDOWN_NORMAL
				SSticker.Reboot(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", delay * 10)
			if("Hard Restart (No Delay, No Feedback Reason)")
				// SSplexora.restart_type = PLEXORA_SHUTDOWN_HARD
				// SSplexora.restart_requester = usr
				to_chat(world, "World reboot - [init_by]")
				world.Reboot()
			if("Hardest Restart (No actions, just reboot)")
				// SSplexora.restart_type = PLEXORA_SHUTDOWN_HARDEST
				// SSplexora.restart_requester = usr
				to_chat(world, "Hard world reboot - [init_by]")
				world.Reboot(fast_track = TRUE)
			if("Server Restart (Kill and restart DD)")
				// SSplexora.restart_type = PLEXORA_SHUTDOWN_KILLDD
				// SSplexora.restart_requester = usr
				to_chat(world, "Server restart - [init_by]")
				world.TgsEndProcess()

/// priority announce something to all clients.
/datum/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))
		return

	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		send_formatted_announcement(message, "From [usr.client.holder.fakekey ? "Administrator" : usr.key]")
		log_admin("Announce: [key_name(usr)] : [message]")

/datum/admins/proc/set_respawn_timer()
	set name = "Set Respawn Timer"
	set category = "Server"

	if(!check_rights(R_ADMIN))
		return

	var/delay = input(usr, "Enter new respawn delays in minutes", "Respawn timer configuration") as null|num
	if(!isnull(delay))
		delay = CLAMP(delay, 0, INFINITY)
		CONFIG_SET(number/respawn_delay, delay)
		log_and_message_admins("changed respawn delay to [delay] minutes.")

/datum/admins/proc/end_round()
	set category = "Server"
	set name = "End Round"
	set desc = "Attempts to produce a round end report and then restart the server organically."

	if (!check_rights(R_ADMIN))
		return
	if(SSticker.current_state == GAME_STATE_FINISHED)
		return to_chat(usr, span_adminnotice("The round has already ended!"))
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		return to_chat(usr, span_adminnotice("The game hasnt started yet!"))

	var/confirm = tgui_alert(usr, "End the round forcibly?", "End Round", list("Yes", "Cancel"))
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		SSticker.force_ending = ADMIN_FORCE_END_ROUND

/// toggles ooc on/off for everyone
/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"

	if(!check_rights(R_ADMIN))
		return

	GLOB.ooc_allowed = !(GLOB.ooc_allowed)
	if (GLOB.ooc_allowed)
		to_chat(world, "<B>The OOC channel has been globally enabled!</B>")
	else
		to_chat(world, "<B>The OOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled OOC.")

/// toggles looc on/off for everyone
/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle LOOC"

	if(!check_rights(R_ADMIN))
		return

	GLOB.looc_allowed = !(GLOB.looc_allowed)
	if (GLOB.looc_allowed)
		to_chat(world, "<B>The LOOC channel has been globally enabled!</B>")
	else
		to_chat(world, "<B>The LOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled LOOC.")

/// toggles dsay on/off for everyone
/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"

	if(!check_rights(R_ADMIN))
		return

	GLOB.dsay_allowed = !(GLOB.dsay_allowed)
	if (GLOB.dsay_allowed)
		to_chat(world, "<B>Deadchat has been globally enabled!</B>")
	else
		to_chat(world, "<B>Deadchat has been globally disabled!</B>")
	log_admin("[key_name(usr)] toggled deadchat.")
	message_admins("[key_name_admin(usr)] toggled deadchat.", 1)

/// toggles ooc on/off for everyone who is dead
/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle Dead OOC."
	set name="Toggle Dead OOC"

	if(!check_rights(R_ADMIN))
		return

	GLOB.dooc_allowed = !( GLOB.dooc_allowed )
	log_admin("[key_name(usr)] toggled Dead OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(SSticker.current_state <= GAME_STATE_PREGAME)
		if(!SSticker.start_immediately)
			if(tgui_alert(usr, "Are you sure you want to start the round?","Start Now",list("Start Now","Cancel")) != "Start Now")
				return FALSE
			SSticker.start_immediately = TRUE
			log_admin("[usr.key] has started the game.")
			var/msg = ""
			if(SSticker.current_state == GAME_STATE_STARTUP)
				msg = " (The server is still setting up, but the round will be started as soon as possible.)"
			message_admins(span_blue("[usr.key] has started the game.[msg]"))
			return TRUE
		SSticker.start_immediately = FALSE
		SSticker.SetTimeLeft(1800)
		to_chat(world, span_infoplain("<b>The game will start in [DisplayTimeText(SSticker.GetTimeLeft())].</b>"))
		SEND_SOUND(world, sound('sound/misc/notice2.ogg'))
		message_admins(span_blue("[usr.key] has cancelled immediate game start. Game will start in [DisplayTimeText(SSticker.GetTimeLeft())]."))
		log_admin("[usr.key] has cancelled immediate game start.")
	else
		to_chat(usr, span_warning(span_red("Error: Start Now: Game has already started.")))
	return FALSE

/// toggles whether people can join the current game
/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"

	GLOB.enter_allowed = !GLOB.enter_allowed
	if (!GLOB.enter_allowed)
		to_chat(world, "<B>New players may no longer enter the game.</B>")
	else
		to_chat(world, "<B>New players may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled new player game entering. ([GLOB.enter_allowed ? "Allowed" : "Disabled"])")
	message_admins(span_blue("[key_name_admin(usr)] toggled new player game entering.  ([GLOB.enter_allowed ? "Allowed" : "Disabled"])"), 1)
	world.update_status()

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"

	CONFIG_SET(flag/allow_ai, !CONFIG_GET(flag/allow_ai))

	if (!CONFIG_GET(flag/allow_ai))
		to_chat(world, "<B>The AI job is no longer chooseable.</B>")
	else
		to_chat(world, "<B>The AI job is chooseable now.</B>")

	message_admins("[key_name(usr)] has toggled [CONFIG_GET(flag/allow_ai) ? "On" : "Off"] AI allowed.")
	log_admin("[key_name(usr)] toggled AI allowed.")

	world.update_status()

/datum/admins/proc/toggleRespawn()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	CONFIG_SET(flag/abandon_allowed, !CONFIG_GET(flag/abandon_allowed))

	if(CONFIG_GET(flag/abandon_allowed))
		to_chat(world, "<B>You may now respawn.</B>")
	else
		to_chat(world, "<B>You may no longer respawn :(</B>")
	message_admins(span_blue("[key_name_admin(usr)] toggled respawn to [CONFIG_GET(flag/abandon_allowed) ? "On" : "Off"]."), 1)
	log_admin("[key_name(usr)] toggled respawn to [CONFIG_GET(flag/abandon_allowed) ? "On" : "Off"].")
	world.update_status()

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start"
	set name="Delay Pre-game"

	if(!check_rights(R_SERVER))
		return

	var/newtime = input("Set a new time in seconds. Set -1 for indefinite delay.","Set Delay",round(SSticker.GetTimeLeft()/10)) as num|null
	if(SSticker.current_state > GAME_STATE_PREGAME)
		return to_chat(usr, span_adminnotice("Too late... The game has already started!"))
	if(newtime)
		newtime = newtime*10
		SSticker.SetTimeLeft(newtime)
		SSticker.start_immediately = FALSE
		if(newtime < 0)
			to_chat(world, span_infoplain("<b>The game start has been delayed.</b>"))
			log_admin("[key_name(usr)] delayed the round start.")
		else
			to_chat(world, span_infoplain("<b>The game will start in [DisplayTimeText(newtime)].</b>"))
			SEND_SOUND(world, sound('sound/effects/compbeep2.ogg'))
			log_admin("[key_name(usr)] set the pre-game delay to [DisplayTimeText(newtime)].")

/datum/admins/proc/delay_round_end()
	set category = "Server"
	set desc = "Prevent the server from restarting"
	set name = "Delay Round End"

	if(!check_rights(R_SERVER))
		return

	if(SSticker.delay_end)
		to_chat(usr, "The round end is already delayed. The reason for the current delay is: \"[SSticker.admin_delay_notice]\"")
		return

	var/delay_reason = input(usr, "Enter a reason for delaying the round end", "Round Delay Reason") as null|text

	if(isnull(delay_reason))
		return

	if(SSticker.delay_end)
		to_chat(usr, "The round end is already delayed. The reason for the current delay is: \"[SSticker.admin_delay_notice]\"")
		return

	SSticker.delay_end = TRUE
	SSticker.admin_delay_notice = delay_reason
	SSticker.cancel_reboot(usr)

	log_admin("[key_name(usr)] delayed the round end for reason: [SSticker.admin_delay_notice]")
	message_admins("[key_name_admin(usr)] delayed the round end for reason: [SSticker.admin_delay_notice]")


////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(mob/M) // returns 1 for special characters
	if (!istype(M))
		return NO_ANTAG

	if(M.mind && player_is_limited_antag(M.mind))
		return LIMITED_ANTAG

	if(M.mind && player_is_antag(M.mind))
		return ANTAG

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.HasTrait(CYBORG_TRAIT_EMAGGED))
			return ANTAG

	return NO_ANTAG

/proc/is_limited_antag(mob/M)
	if(M.mind && player_is_limited_antag(M.mind))
		return TRUE
	return FALSE

/datum/admins/proc/spawn_fruit(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn the product of a seed."
	set name = "Spawn Fruit"

	if(!check_rights(R_DEBUG))
		return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	var/datum/seed/S = SSplants.seeds[seedtype]
	S.harvest(usr,0,0,1)
	log_admin("[key_name(usr)] spawned [seedtype] fruit at ([usr.x],[usr.y],[usr.z])")

/datum/admins/proc/spawn_plant(seedtype in SSplants.seeds)
	set category = "Debug"
	set desc = "Spawn a spreading plant effect."
	set name = "Spawn Plant"

	if(!check_rights(R_DEBUG))
		return

	if(!seedtype || !SSplants.seeds[seedtype])
		return
	new /obj/effect/plant(get_turf(usr), SSplants.seeds[seedtype])
	log_admin("[key_name(usr)] spawned [seedtype] vines at ([usr.x],[usr.y],[usr.z])")

/// allows us to spawn instances
/datum/admins/proc/spawn_atom(object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_DEBUG))
		return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")

/// interface which shows a mob's mind
/datum/admins/proc/show_contractor_panel(mob/M in SSmobs.mob_list | SShumans.mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Contractor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()

/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmets."
	CONFIG_SET(flag/welder_vision, !CONFIG_GET(flag/welder_vision))
	if (CONFIG_GET(flag/welder_vision))
		to_chat(world, "<B>Reduced welder vision has been enabled!</B>")
	else
		to_chat(world, "<B>Reduced welder vision has been disabled!</B>")
	log_admin("[key_name(usr)] toggled welder vision.")
	message_admins("[key_name_admin(usr)] toggled welder vision.", 1)

/// toggles whether guests can join the current game
/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	CONFIG_SET(flag/guests_allowed, !(CONFIG_GET(flag/guests_allowed)))
	if (!CONFIG_GET(flag/guests_allowed))
		to_chat(world, "<B>Guests may no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [CONFIG_GET(flag/guests_allowed)?"":"dis"]allowed.")
	message_admins(span_blue("[key_name_admin(usr)] toggled guests game entering [CONFIG_GET(flag/guests_allowed)?"":"dis"]allowed."), 1)

/datum/admins/proc/toggle_tts()
	set category = "Server"
	set name = "Toggle text-to-speech"

	if(GLOB.tts_bearer)
		CONFIG_SET(flag/tts_enabled, !CONFIG_GET(flag/tts_enabled))
	else
		to_chat(usr, "Configuration file [CONFIG_GET(string/tts_key) ? "contains invalid" : "is missing"] authentication key.")
		return

	to_chat(world, "<B>The text-to-speech has been globally [CONFIG_GET(flag/tts_enabled) ? "enabled" : "disabled"]!</B>")

	message_admins(span_blue("[key_name_admin(usr)] set text-to-speech to [CONFIG_GET(flag/tts_enabled) ? "On" : "Off"]."), 1)
	log_admin("[key_name(usr)] set text-to-speech to [CONFIG_GET(flag/tts_enabled) ? "On" : "Off"].")

/datum/admins/proc/toggle_tts_cache()
	set category = "Server"
	set name = "Toggle text-to-speech caching"

	CONFIG_SET(flag/tts_cache, !CONFIG_GET(flag/tts_cache))

	message_admins(span_blue("[key_name_admin(usr)] set text-to-speech caching to [CONFIG_GET(flag/tts_cache) ? "On" : "Off"]."), 1)
	log_admin("[key_name(usr)] set text-to-speech caching to [CONFIG_GET(flag/tts_cache) ? "On" : "Off"].")

/datum/admins/proc/check_tts_stat()
	set category = "Server"
	set name = "Print text-to-speech stats"

	to_chat(usr, "Text-to-speech is globally [CONFIG_GET(flag/tts_enabled) ? "enabled" : (GLOB.tts_bearer ? "disabled" : "disabled and authentication data is missing")]")
	to_chat(usr, "Total tts files wanted this round: [GLOB.tts_wanted]")
	to_chat(usr, "Successfully generated tts files: [GLOB.tts_request_succeeded]")
	to_chat(usr, "Failed to generate tts files: [GLOB.tts_request_failed]")
	to_chat(usr, "Reused tts files: [GLOB.tts_reused]")
	to_chat(usr, "Files waiting to be deleted: [LAZYLEN(GLOB.tts_death_row)]")
	if(LAZYLEN(GLOB.tts_errors))
		to_chat(usr, "Following errors occured:")
		for(var/i in GLOB.tts_errors)
			to_chat(usr, "[i] - [GLOB.tts_errors[i]]")
	if(GLOB.tts_error_raw)
		to_chat(usr, "Last raw response: [GLOB.tts_error_raw]")

/datum/admins/proc/add_tts_seed()
	set category = "Fun"
	set name = "Add text-to-speech seed"

	var/seed_name = input(usr, "Give it a name. It should not contain any spaces.", "Add text-to-speech seed") as null|text
	if(!seed_name)
		return
	var/seed_value = input(usr, "Enter a seed value. No spaces.", "Add text-to-speech seed") as null|text
	if(!seed_value)
		return
	var/seed_category = "any" // To be implemented, for now there is only humans who can choose, so catergory doesn't matter
	var/seed_gender_restriction = "any"
	var/gender = alert(usr, "Should it have gender restriction?", "Add text-to-speech seed", "Male only", "Female only", "No")
	switch(gender)
		if("Male only")
			seed_gender_restriction = "male"
		if("Female only")
			seed_gender_restriction = "female"

	if(!tts_seeds[seed_name])
		tts_seeds += seed_name
	tts_seeds[seed_name] = list("value" = seed_value, "category" = seed_category, "gender" = seed_gender_restriction)

	LIBCALL(RUST_G, "file_write")("[seed_value]", "sound/tts_cache/[seed_name]/seed.txt")
	LIBCALL(RUST_G, "file_write")("[seed_value]", "sound/tts_scrambled/[seed_name]/seed.txt")

	message_admins(span_blue("[key_name_admin(usr)] added text-to-speech seed \"[seed_value]\", named \"[seed_name]\"."), 1)
	log_admin("[key_name(usr)] added text-to-speech seed \"[seed_value]\", named \"[seed_name]\".")

/datum/admins/proc/select_tts_seed()
	set category = "Fun"
	set name = "Select text-to-speech seed"

	if(!isliving(usr))
		to_chat(usr, "Only living mobs may have TTS.")
		return

	var/mob/living/user = usr
	var/choice = input(user, "Pick a voice preset.") as null|anything in tts_seeds
	if(choice)
		user.tts_seed = choice


/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in SSmobs.mob_list | SShumans.mob_list)
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI [key_name(S, usr)]'s laws:</b>")
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			to_chat(usr, "<b>CYBORG [key_name(S, usr)] [R.connected_ai?"(Slaved to: [R.connected_ai])":"(Independant)"]: laws:</b>")
		else if (ispAI(S))
			to_chat(usr, "<b>pAI [key_name(S, usr)]'s laws:</b>")
		else
			to_chat(usr, "<b>SOMETHING SILICON [key_name(S, usr)]'s laws:</b>")

		if (S.laws == null)
			to_chat(usr, "[key_name(S, usr)]'s laws are null?? Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AIs located</b>" ) //Just so you know the thing is actually working and not just ignoring you.

/client/proc/update_mob_sprite(mob/living/carbon/human/H)
	set category = "Admin"
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."

	if (!holder)
		to_chat(src, "Only administrators may use this command.")
		return

	if(istype(H))
		H.regenerate_icons()


/*
	helper proc to test if someone is a mentor or not.  Got tired of writing this same check all over the place.
*/
/proc/is_mentor(client/C)

	if(!istype(C))
		return FALSE
	if(!C.holder)
		return FALSE

	if(C.holder.rights == R_MENTOR)
		return TRUE
	return FALSE

/proc/get_options_bar(whom, detail = 2, name = 0, link = 1, highlight_special = 1)
	if(!whom)
		return "<b>(*null*)</b>"
	var/mob/M
	var/client/C
	if(isclient(whom))
		C = whom
		M = C.mob
	else if(ismob(whom))
		M = whom
		C = M.client
	else
		return "<b>(*not an mob*)</b>"
	switch(detail)
		if(0)
			return "<b>[key_name(C, link, name, highlight_special)]</b>"

		if(1)	//Private Messages
			return "<b>[key_name(C, link, name, highlight_special)][ADMIN_QUE(M)]</b>"

		if(2)	//Admins
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special)] [ADMIN_QUE(ref_mob)] [ADMIN_PP(ref_mob)] [ADMIN_VV(ref_mob)] [ADMIN_SM(ref_mob)] ([admin_jump_link(M, UNLINT(src))]) (<A href='byond://?_src_=holder;[HrefToken()];check_antagonist=1'>CA</A>)</b>"

		if(3)	//Devs
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special)] [ADMIN_VV(ref_mob)] ([admin_jump_link(M, UNLINT(src))])</b>"

		if(4)	//Mentors
			var/ref_mob = "\ref[M]"
			return "<b>[key_name(C, link, name, highlight_special)] [ADMIN_QUE(M)] [ADMIN_PP(ref_mob)] [ADMIN_VV(ref_mob)] [ADMIN_SM(ref_mob)] ([admin_jump_link(M, UNLINT(src))])</b>"


//
//
//ALL DONE
//*********************************************************************************************************
//

//Returns 1 to let the dragdrop code know we are trapping this event
//Returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(mob/observer/ghost/frommob, mob/living/tomob)
	if(!istype(frommob))
		return //Extra sanity check to make sure only observers are shoved into things

	//Same as assume-direct-control perm requirements.
	if (!check_rights(R_ADMIN|R_DEBUG,0))
		return FALSE
	if (!frommob.ckey)
		return FALSE
	var/question = ""
	if (tomob.ckey)
		question = "This mob already has a user ([tomob.key]) in control of it! "
	question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"
	var/ask = alert(question, "Place ghost in control of mob?", "Yes", "No")
	if (ask != "Yes")
		return TRUE
	if (!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
		return TRUE
	if(tomob.client) //No need to ghostize if there is no client
		tomob.ghostize(0)
	message_admins(span_adminnotice("[key_name_admin(usr)] has put [frommob.ckey] in control of [tomob.name]."))
	log_admin("[key_name(usr)] stuffed [frommob.ckey] into [tomob.name].")

	tomob.ckey = frommob.ckey
	if(tomob.client)
		if(tomob.client.UI)
			tomob.client.UI.show()
		else
			tomob.client.create_UI(tomob.type)

	qdel(frommob)
	return TRUE

/datum/admins/proc/paralyze_mob(mob/living/H)
	set category = "Fun"
	set name = "Toggle Paralyze"
	set desc = "Paralyzes a player. Or unparalyses them."

	var/msg

	if(check_rights(R_ADMIN))
		if (H.paralysis == 0)
			H.paralysis = 8000
			msg = "has paralyzed [key_name(H)]."
		else
			H.paralysis = 0
			msg = "has unparalyzed [key_name(H)]."
		log_and_message_admins(msg)

// Returns a list of the number of admins in various categories
// result[1] is the number of staff that match the rank mask and are active
// result[2] is the number of staff that do not match the rank mask
// result[3] is the number of staff that match the rank mask and are inactive
/proc/staff_countup(rank_mask = R_ADMIN)
	var/list/result = list(0, 0, 0)
	for(var/client/X in GLOB.admins)
		if(rank_mask && !check_rights_for(X, rank_mask))
			result[2]++
			continue
		if(X.holder.fakekey)
			result[2]++
			continue
		if(X.is_afk())
			result[3]++
			continue
		result[1]++
	return result

//This proc checks whether subject has at least ONE of the rights specified in rights_required.
/proc/check_rights_for(_subject, rights_required)
	var/client/subject
	if (ismob(_subject))
		var/mob/M = _subject
		subject = M?.client

	if(subject && subject.holder)
		if(rights_required && !(rights_required & subject.holder.rights))
			return FALSE
		return TRUE
	return FALSE

/datum/admins/proc/z_level_shooting()
	set category = "Server"
	set name = "Toggle shooting between z-levels"

	if(!check_rights(R_ADMIN))
		return
	CONFIG_SET(flag/z_level_shooting, !(CONFIG_GET(flag/z_level_shooting)))

	if (CONFIG_GET(flag/z_level_shooting))
		to_chat(world, "<B>Shooting between z-levels has been globally enabled! Use the lookup verb to shoot up, click on empty spaces to shoot down!</B>")
	else
		to_chat(world, "<B>Shooting between z-levels has been globally disabled!</B>")
	log_and_message_admins("toggled z_level_shooting.")

/// Sends a message to adminchat when anyone with a holder logs in or logs out.
/// TODO: Add player/admin prefs for this.
/client/proc/adminGreet(logout = FALSE)
	if(!SSticker.HasRoundStarted())
		return

	if(logout)
		message_admins("Admin logout: [key_name(src)]")
		return

	if(!logout)
		message_admins("Admin login: [key_name(src)]")
		return

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk()) //Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message, confidential = TRUE)
			kicked_client_names.Add("[C.key]")
			qdel(C)
	return kicked_client_names

