
var/global/BSACooldown = 0
var/global/floorIsLava = 0
#define NO_ANTAG 0
#define LIMITED_ANTAG 1
#define ANTAG 2


////////////////////////////////
/proc/message_admins(msg)
	msg = "<span class=\"log_message\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">69msg69</span></span>"
	log_adminwarn(msg)
	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C,69sg)

/proc/msg_admin_attack(text) //Toggleable Attack69essages
	log_attack(text)
	var/rendered = "<span class=\"log_message\"><span class=\"prefix\">ATTACK:</span> <span class=\"message\">69text69</span></span>"
	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			if(C.get_preference_value(/datum/client_preference/staff/show_attack_logs) == GLOB.PREF_SHOW)
				var/msg = rendered
				to_chat(C,69sg)

/**
 * Sends a69essage to the staff able to see admin tickets
 * Arguments:
 *69sg - The69essage being send
 * important - If the69essage is important. If TRUE it will ignore the PREF_HEAR preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/proc/message_adminTicket(msg, important = FALSE)
	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C,69sg)
			if(important || (C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR))
				sound_to(C, 'sound/effects/adminhelp.ogg')

/**
 * Sends a69essage to the staff able to see69entor tickets
 * Arguments:
 *69sg - The69essage being send
 * important - If the69essage is important. If TRUE it will ignore the PREF_HEAR preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/proc/message_mentorTicket(msg, important = FALSE)
	for(var/client/C in admins)
		if(check_rights(R_ADMIN | R_MENTOR | R_MOD, 0, C.mob))
			to_chat(C,69sg)
			if(important || (C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR))
				sound_to(C, 'sound/effects/adminhelp.ogg')

proc/admin_notice(message, rights)
	for(var/mob/M in SSmobs.mob_list)
		if(check_rights(rights, 0,69))
			to_chat(M,69essage)

// Not happening.
/datum/admins/SDQL_update(const/var_name, new_value)
	return 0


///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/view_log_panel(mob/M)
	if(!M)
		to_chat(usr, "That69ob doesn't seem to exist! Something went wrong.")
		return

	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Log Panel of 69M.real_name69</title></head>"
	body += "<body><center>Logs of <b>69M69</b><br>"
	body += "<a href='?src=\ref69src69;viewlogs=\ref69M69'>REFRESH</a></center><br>"


	var/i = length(M.attack_log)
	while(i > 0)
		body +=69.attack_log69i69 + "<br>"
		i--

	usr << browse(body, "window=\ref69M69logs;size=500x500")




ADMIN_VERB_ADD(/datum/admins/proc/show_player_panel, null, TRUE)
//shows an interface for individual players, with69arious links (links require additional flags
/datum/admins/proc/show_player_panel(mob/M in SSmobs.mob_list)
	set category = null
	set name = "Show Player Panel"
	set desc = "Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "You seem to be selecting a69ob that doesn't exist anymore.")
		return
	if (!istype(src, /datum/admins))
		src = usr.client.holder
	if (!istype(src, /datum/admins))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/body = "<html><head><title>Options for 69M.key69</title></head>"
	body += "<body>Options panel for <b>69M69</b>"

	if(M.client)
		body += " played by <b><a href='http://byond.com/members/69M.client.ckey69'>69M.client69</b></a> "
		body += "\69<A href='?src=\ref69src69;editrights=show'>69M.client.holder ?69.client.holder.rank : "Player"69</A>\69<br>"
		body += "<b>Registration date:</b> 69M.client.registration_date ?69.client.registration_date : "Unknown"69<br>"
		body += "<b>IP:</b> 69M.client.address ?69.client.address : "Unknown"69<br>"

		var/country =69.client.country
		var/country_code =69.client.country_code
		if(country && country_code)
			// TODO (28.07.17): uncomment after flag icons resize
			// <img src=\"flag_69country_code69.png\">
			// usr << browse_rsc(icon('icons/country_flags.dmi', country_code), "flag_69country_code69.png")
			body += "<b>Country:</b> 69country69<br><br>"


	if(isnewplayer(M))
		body += " <B>Hasn't Entered Game</B> "
	else
		body += " \69<A href='?src=\ref69src69;revive=\ref69M69'>Heal</A>\69 "

	body += {"
		<br><br>\69
		<a href='?_src_=vars;Vars=\ref69M69'>VV</a> -
		<a href='?src=\ref69src69;contractor=\ref69M69'>TP</a> -
		<a href='?src=\ref69usr69;priv_msg=\ref69M69'>PM</a> -
		<a href='?src=\ref69src69;subtlemessage=\ref69M69'>SM</a> -
		<a href='?src=\ref69src69;manup=\ref69M69'>MAN_UP</a> -
		<a href='?src=\ref69src69;paralyze=\ref69M69'>PARA</a> -
		69admin_jump_link(M, src)69 -
		<a href='?src=\ref69src69;viewlogs=\ref69M69'>LOGS</a>\69 <br>
		<b>Mob type</b> = 69M.type69<br><br>
		<A href='?src=\ref69src69;boot2=\ref69M69'>Kick</A> |
		<A href='?_src_=holder;warn=69M.ckey69'>Warn</A> |
		<A href='?src=\ref69src69;newban=\ref69M69'>Ban</A> |
		<A href='?src=\ref69src69;jobban2=\ref69M69'>Jobban</A> |
		<A href='?src=\ref69src69;notes=show;mob=\ref69M69'>Notes</A> |

	"}

	if(M.client)
		body += "\ <A href='?_src_=holder;sendbacktolobby=\ref69M69'>Send back to Lobby</A> | "
		var/muted =69.client.prefs.muted
		body += {"<br><b>Mute: </b>
			\69<A href='?src=\ref69src69;mute=\ref69M69;mute_type=69MUTE_IC69'><font color='69(muted &69UTE_IC)?"red":"blue"69'>IC</font></a> |
			<A href='?src=\ref69src69;mute=\ref69M69;mute_type=69MUTE_OOC69'><font color='69(muted &69UTE_OOC)?"red":"blue"69'>OOC</font></a> |
			<A href='?src=\ref69src69;mute=\ref69M69;mute_type=69MUTE_PRAY69'><font color='69(muted &69UTE_PRAY)?"red":"blue"69'>PRAY</font></a> |
			<A href='?src=\ref69src69;mute=\ref69M69;mute_type=69MUTE_ADMINHELP69'><font color='69(muted &69UTE_ADMINHELP)?"red":"blue"69'>ADMINHELP</font></a> |
			<A href='?src=\ref69src69;mute=\ref69M69;mute_type=69MUTE_DEADCHAT69'><font color='69(muted &69UTE_DEADCHAT)?"red":"blue"69'>DEADCHAT</font></a>\69
			(<A href='?src=\ref69src69;mute=\ref69M69;mute_type=69MUTE_ALL69'><font color='69(muted &69UTE_ALL)?"red":"blue"69'>toggle all</font></a>)
		"}

	body += {"<br><br>
		<A href='?src=\ref69src69;jumpto=\ref69M69'><b>Jump to</b></A> |
		<A href='?src=\ref69src69;getmob=\ref69M69'>Get</A>
		<br><br>
		69check_rights(R_ADMIN|R_MOD,0) ? "<A href='?src=\ref69src69;contractor=\ref69M69'>Contractor panel</A> | " : "" 69
		<A href='?src=\ref69src69;narrateto=\ref69M69'>Narrate to</A> |
		<A href='?src=\ref69src69;subtlemessage=\ref69M69'>Subtle69essage</A>
	"}

	if (M.client)
		if(!isnewplayer(M))
			body += "<br><br>"
			body += "<b>Transformation:</b>"
			body += "<br>"

			//Monkey
			if(issmall(M))
				body += "<B>Monkeyized</B> | "
			else
				body += "<A href='?src=\ref69src69;monkeyone=\ref69M69'>Monkeyize</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Corgized</B> | "
			else
				body += "<A href='?src=\ref69src69;corgione=\ref69M69'>Corgize</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Is an AI</B> "
			else if(ishuman(M))
				body += {"<A href='?src=\ref69src69;makeai=\ref69M69'>Make AI</A> |
					<A href='?src=\ref69src69;makerobot=\ref69M69'>Make Robot</A> |
					<A href='?src=\ref69src69;makeslime=\ref69M69'>Make slime</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='?src=\ref69src69;makeanimal=\ref69M69'>Re-Animalize</A> | "
			else
				body += "<A href='?src=\ref69src69;makeanimal=\ref69M69'>Animalize</A> | "

			// DNA2 - Admin Hax
			if(M.dna && iscarbon(M))
				body += "<br><br>"
				body += "<b>DNA Blocks:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=DNA_SE_LENGTH;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>69block-169</th>"
					bname = assigned_blocks69block69
					body += "<td>"
					if(bname)
						var/bstate=M.dna.GetSEState(block)
						var/bcolor="69(bstate)?"#006600":"#ff0000"69"
						body += "<A href='?src=\ref69src69;togmutate=\ref69M69;block=69block69' style='color:69bcolor69;'>69bname69</A><sub>69block69</sub>"
					else
						body += "69block69"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Rudimentary transformation:</b><font size=2><br>These transformations only create a new69ob type and copy stuff over. They do not take into account69MIs and similar69ob-specific things. The buttons in 'Transformations' are preferred, when possible.</font><br>
				<A href='?src=\ref69src69;simplemake=observer;mob=\ref69M69'>Observer</A> |
				<A href='?src=\ref69src69;simplemake=angel;mob=\ref69M69'>ANGEL</A> |
				\69 Crew: <A href='?src=\ref69src69;simplemake=human;mob=\ref69M69'>Human</A>
				<A href='?src=\ref69src69;simplemake=nymph;mob=\ref69M69'>Nymph</A>
				\69 slime: <A href='?src=\ref69src69;simplemake=slime;mob=\ref69M69'>Baby</A>,
				<A href='?src=\ref69src69;simplemake=adultslime;mob=\ref69M69'>Adult</A> \69
				<A href='?src=\ref69src69;simplemake=monkey;mob=\ref69M69'>Monkey</A> |
				<A href='?src=\ref69src69;simplemake=robot;mob=\ref69M69'>Cyborg</A> |
				<A href='?src=\ref69src69;simplemake=cat;mob=\ref69M69'>Cat</A> |
				<A href='?src=\ref69src69;simplemake=runtime;mob=\ref69M69'>Runtime</A> |
				<A href='?src=\ref69src69;simplemake=corgi;mob=\ref69M69'>Corgi</A> |
				<A href='?src=\ref69src69;simplemake=ian;mob=\ref69M69'>Ian</A> |
				<A href='?src=\ref69src69;simplemake=crab;mob=\ref69M69'>Crab</A> |
				<A href='?src=\ref69src69;simplemake=coffee;mob=\ref69M69'>Coffee</A> |
				\69 Construct: <A href='?src=\ref69src69;simplemake=constructarmoured;mob=\ref69M69'>Armoured</A> ,
				<A href='?src=\ref69src69;simplemake=constructbuilder;mob=\ref69M69'>Builder</A> ,
				<A href='?src=\ref69src69;simplemake=constructwraith;mob=\ref69M69'>Wraith</A> \69
				<A href='?src=\ref69src69;simplemake=shade;mob=\ref69M69'>Shade</A>
				<br>
			"}
	body += {"<br><br>
			<b>Other actions:</b>
			<br>
			<A href='?src=\ref69src69;forcespeech=\ref69M69'>Forcesay</A> |
			<A href='?src=\ref69src69;forcesanity=\ref69M69'>Sanity Break</A>
			"}
	body += "<br><br><b>Languages:</b><br>"
	var/f = 1
	for(var/k in all_languages)
		var/datum/language/L = all_languages69k69
		if(!(L.flags & INNATE))
			if(!f) body += " | "
			else f = 0
			if(L in69.languages)
				body += "<a href='?src=\ref69src69;toglang=\ref69M69;lang=69html_encode(k)69' style='color:#006600'>69k69</a>"
			else
				body += "<a href='?src=\ref69src69;toglang=\ref69M69;lang=69html_encode(k)69' style='color:#ff0000'>69k69</a>"

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x515")



/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who69ade the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

ADMIN_VERB_ADD(/datum/admins/proc/access_news_network, R_ADMIN, FALSE)
//allows access of newscasters
/datum/admins/proc/access_news_network() //MARKER
	set category = "Fun"
	set name = "Access Newscaster Network"
	set desc = "Allows you to69iew, add and edit news feeds."

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
				dat+= "<HR><A href='?src=\ref69src69;admincaster=view_wanted'>Read Wanted Issue</A>"

			dat+= {"<HR><BR><A href='?src=\ref69src69;admincaster=create_channel'>Create Feed Channel</A>
				<BR><A href='?src=\ref69src69;admincaster=view'>View Feed Channels</A>
				<BR><A href='?src=\ref69src69;admincaster=create_feed_story'>Submit new Feed story</A>
				<BR><BR><A href='?src=\ref69usr69;mach_close=newscaster_main'>Exit</A>
			"}

			var/wanted_already = 0
			if(news_network.wanted_issue)
				wanted_already = 1

			dat+={"<HR><B>Feed Security functions:</B><BR>
				<BR><A href='?src=\ref69src69;admincaster=menu_wanted'>69(wanted_already) ? ("Manage") : ("Publish")69 \"Wanted\" Issue</A>
				<BR><A href='?src=\ref69src69;admincaster=menu_censor_story'>Censor Feed Stories</A>
				<BR><A href='?src=\ref69src69;admincaster=menu_censor_channel'>Mark Feed Channel with 69company_name69 D-Notice (disables and locks the channel.</A>
				<BR><HR><A href='?src=\ref69src69;admincaster=set_signature'>The newscaster recognises you as:<BR> <FONT COLOR='green'>69src.admincaster_signature69</FONT></A>
			"}
		if(1)
			dat+= "Station Feed Channels<HR>"
			if( isemptylist(news_network.network_channels) )
				dat+="<I>No active channels found...</I>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					if(CHANNEL.is_admin_channel)
						dat+="<B><FONT style='BACKGROUND-COLOR: LightGreen'><A href='?src=\ref69src69;admincaster=show_channel;show_channel=\ref69CHANNEL69'>69CHANNEL.channel_name69</A></FONT></B><BR>"
					else
						dat+="<B><A href='?src=\ref69src69;admincaster=show_channel;show_channel=\ref69CHANNEL69'>69CHANNEL.channel_name69</A> 69(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null69<BR></B>"
			dat+={"<BR><HR><A href='?src=\ref69src69;admincaster=refresh'>Refresh</A>
				<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Back</A>
			"}

		if(2)
			dat+={"
				Creating new Feed Channel...
				<HR><B><A href='?src=\ref69src69;admincaster=set_channel_name'>Channel Name</A>:</B> 69src.admincaster_feed_channel.channel_name69<BR>
				<B><A href='?src=\ref69src69;admincaster=set_signature'>Channel Author</A>:</B> <FONT COLOR='green'>69src.admincaster_signature69</FONT><BR>
				<B><A href='?src=\ref69src69;admincaster=set_channel_lock'>Will Accept Public Feeds</A>:</B> 69(src.admincaster_feed_channel.locked) ? ("NO") : ("YES")69<BR><BR>
				<BR><A href='?src=\ref69src69;admincaster=submit_new_channel'>Submit</A><BR><BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Cancel</A><BR>
			"}
		if(3)
			dat+={"
				Creating new Feed69essage...
				<HR><B><A href='?src=\ref69src69;admincaster=set_channel_receiving'>Receiving Channel</A>:</B> 69src.admincaster_feed_channel.channel_name69<BR>" //MARK
				<B>Message Author:</B> <FONT COLOR='green'>69src.admincaster_signature69</FONT><BR>
				<B><A href='?src=\ref69src69;admincaster=set_new_message'>Message Body</A>:</B> 69src.admincaster_feed_message.body69 <BR>
				<BR><A href='?src=\ref69src69;admincaster=submit_new_message'>Submit</A><BR><BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Cancel</A><BR>
			"}
		if(4)
			dat+={"
					Feed story successfully submitted to 69src.admincaster_feed_channel.channel_name69.<BR><BR>
					<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Return</A><BR>
				"}
		if(5)
			dat+={"
				Feed Channel 69src.admincaster_feed_channel.channel_name69 created successfully.<BR><BR>
				<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Return</A><BR>
			"}
		if(6)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name=="")
				dat+="<FONT COLOR='maroon'>Invalid receiving channel name.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\69REDACTED\69")
				dat+="<FONT COLOR='maroon'>Invalid69essage body.</FONT><BR>"
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69369'>Return</A><BR>"
		if(7)
			dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_channel.channel_name =="" || src.admincaster_feed_channel.channel_name == "\69REDACTED\69")
				dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					check = 1
					break
			if(check)
				dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69269'>Return</A><BR>"
		if(9)
			dat+="<B>69src.admincaster_feed_channel.channel_name69: </B><FONT SIZE=1>\69created by: <FONT COLOR='maroon'>69src.admincaster_feed_channel.author69</FONT>\69</FONT><HR>"
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and69arked with a 69company_name69 D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed69essages found in channel...</I><BR>"
				else
					var/i = 0
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						i++
						dat+="-69MESSAGE.body69 <BR>"
						if(MESSAGE.img)
							usr << browse_rsc(MESSAGE.img, "tmp_photo69i69.png")
							dat+="<img src='tmp_photo69i69.png' width = '180'><BR><BR>"
						dat+="<FONT SIZE=1>\69Story by <FONT COLOR='maroon'>69MESSAGE.author69</FONT>\69</FONT><BR>"
			dat+={"
				<BR><HR><A href='?src=\ref69src69;admincaster=refresh'>Refresh</A>
				<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69169'>Back</A>
			"}
		if(10)
			dat+={"
				<B>69company_name69 Feed Censorship Tool</B><BR>
				<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>
				Keep in69ind that users attempting to69iew a censored feed will instead see the \69REDACTED\69 tag above it.</FONT>
				<HR>Select Feed channel to get Stories from:<BR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='?src=\ref69src69;admincaster=pick_censor_channel;pick_censor_channel=\ref69CHANNEL69'>69CHANNEL.channel_name69</A> 69(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null69<BR>"
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Cancel</A>"
		if(11)
			dat+={"
				<B>69company_name69 D-Notice Handler</B><HR>
				<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handling Authority deems it as harmful for the station's
				morale, integrity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deleting any feed
				stories it69ight contain at the time. You can lift a D-Notice if you have the required access at any time.</FONT><HR>
			"}
			if(isemptylist(news_network.network_channels))
				dat+="<I>No feed channels found active...</I><BR>"
			else
				for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
					dat+="<A href='?src=\ref69src69;admincaster=pick_d_notice;pick_d_notice=\ref69CHANNEL69'>69CHANNEL.channel_name69</A> 69(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null69<BR>"

			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Back</A>"
		if(12)
			dat+={"
				<B>69src.admincaster_feed_channel.channel_name69: </B><FONT SIZE=1>\69 created by: <FONT COLOR='maroon'>69src.admincaster_feed_channel.author69</FONT> \69</FONT><BR>
				<FONT SIZE=2><A href='?src=\ref69src69;admincaster=censor_channel_author;censor_channel_author=\ref69src.admincaster_feed_channel69'>69(src.admincaster_feed_channel.author=="\69REDACTED\69") ? ("Undo Author censorship") : ("Censor channel Author")69</A></FONT><HR>
			"}
			if( isemptylist(src.admincaster_feed_channel.messages) )
				dat+="<I>No feed69essages found in channel...</I><BR>"
			else
				for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
					dat+={"
						-69MESSAGE.body69 <BR><FONT SIZE=1>\69Story by <FONT COLOR='maroon'>69MESSAGE.author69</FONT>\69</FONT><BR>
						<FONT SIZE=2><A href='?src=\ref69src69;admincaster=censor_channel_story_body;censor_channel_story_body=\ref69MESSAGE69'>69(MESSAGE.body == "\69REDACTED\69") ? ("Undo story censorship") : ("Censor story")69</A>  -  <A href='?src=\ref69src69;admincaster=censor_channel_story_author;censor_channel_story_author=\ref69MESSAGE69'>69(MESSAGE.author == "\69REDACTED\69") ? ("Undo Author Censorship") : ("Censor69essage Author")69</A></FONT><BR>
					"}
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=691069'>Back</A>"
		if(13)
			dat+={"
				<B>69src.admincaster_feed_channel.channel_name69: </B><FONT SIZE=1>\69 created by: <FONT COLOR='maroon'>69src.admincaster_feed_channel.author69</FONT> \69</FONT><BR>
				Channel69essages listed below. If you deem them dangerous to the station, you can <A href='?src=\ref69src69;admincaster=toggle_d_notice;toggle_d_notice=\ref69src.admincaster_feed_channel69'>Bestow a D-Notice upon the channel</A>.<HR>
			"}
			if(src.admincaster_feed_channel.censored)
				dat+={"
					<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatening to the welfare of the station, and69arked with a 69company_name69 D-Notice.<BR>
					No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>
				"}
			else
				if( isemptylist(src.admincaster_feed_channel.messages) )
					dat+="<I>No feed69essages found in channel...</I><BR>"
				else
					for(var/datum/feed_message/MESSAGE in src.admincaster_feed_channel.messages)
						dat+="-69MESSAGE.body69 <BR><FONT SIZE=1>\69Story by <FONT COLOR='maroon'>69MESSAGE.author69</FONT>\69</FONT><BR>"

			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=691169'>Back</A>"
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
				<A href='?src=\ref69src69;admincaster=set_wanted_name'>Criminal Name</A>: 69src.admincaster_feed_message.author69 <BR>
				<A href='?src=\ref69src69;admincaster=set_wanted_desc'>Description</A>: 69src.admincaster_feed_message.body69 <BR>
			"}
			if(wanted_already)
				dat+="<B>Wanted Issue created by:</B><FONT COLOR='green'> 69news_network.wanted_issue.backup_author69</FONT><BR>"
			else
				dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='green'> 69src.admincaster_signature69</FONT><BR>"
			dat+="<BR><A href='?src=\ref69src69;admincaster=submit_wanted;submit_wanted=69end_param69'>69(wanted_already) ? ("Edit Issue") : ("Submit")69</A>"
			if(wanted_already)
				dat+="<BR><A href='?src=\ref69src69;admincaster=cancel_wanted'>Take down Issue</A>"
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Cancel</A>"
		if(15)
			dat+={"
				<FONT COLOR='green'>Wanted issue for 69src.admincaster_feed_message.author69 is now in Network Circulation.</FONT><BR><BR>
				<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Return</A><BR>
			"}
		if(16)
			dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
			if(src.admincaster_feed_message.author =="" || src.admincaster_feed_message.author == "\69REDACTED\69")
				dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
			if(src.admincaster_feed_message.body == "" || src.admincaster_feed_message.body == "\69REDACTED\69")
				dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Return</A><BR>"
		if(17)
			dat+={"
				<B>Wanted Issue successfully deleted from Circulation</B><BR>
				<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Return</A><BR>
			"}
		if(18)
			dat+={"
				<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\69Submitted by: <FONT COLOR='green'>69news_network.wanted_issue.backup_author69</FONT>\69</FONT><HR>
				<B>Criminal</B>: 69news_network.wanted_issue.author69<BR>
				<B>Description</B>: 69news_network.wanted_issue.body69<BR>
				<B>Photo:</B>:
			"}
			if(news_network.wanted_issue.img)
				usr << browse_rsc(news_network.wanted_issue.img, "tmp_photow.png")
				dat+="<BR><img src='tmp_photow.png' width = '180'>"
			else
				dat+="None"
			dat+="<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Back</A><BR>"
		if(19)
			dat+={"
				<FONT COLOR='green'>Wanted issue for 69src.admincaster_feed_message.author69 successfully edited.</FONT><BR><BR>
				<BR><A href='?src=\ref69src69;admincaster=setScreen;setScreen=69069'>Return</A><BR>
			"}
		else
			dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

	//world << "Channelname: 69src.admincaster_feed_channel.channel_name69 69src.admincaster_feed_channel.author69"
	//world << "Msg: 69src.admincaster_feed_message.author69 69src.admincaster_feed_message.body69"
	usr << browse(dat, "window=admincaster_main;size=400x600")
	onclose(usr, "admincaster_main")



/datum/admins/proc/Jobbans()
	if(!check_rights(R_MOD) && !check_rights(R_ADMIN))
		return

	var/dat = "<B>Job Bans!</B><HR><table>"
	for(var/t in jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>69t69 (<A href='?src=\ref69src69;removejobban=69r69'>unban</A>)</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(0))
		return

	var/dat = "<center><B>Game Panel</B></center><hr>"
	if(get_storyteller() && (SSticker.current_state != GAME_STATE_PREGAME))
		dat += "<A href='?src=\ref69get_storyteller()69'>Storyteller Panel</A><br>"
	else
		dat += "<A href='?src=\ref69src69;c_mode=1'>Change Storyteller</A><br>"

	dat += {"
		<BR>
		<A href='?src=\ref69src69;create_object=1'>Create Object</A><br>
		<A href='?src=\ref69src69;quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=\ref69src69;create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref69src69;create_mob=1'>Create69ob</A><br>
		<br><A href='?src=\ref69src69;vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='?src=\ref69src69;vsc=plasma'>Edit Plasma Settings</A><br>
		<A href='?src=\ref69src69;vsc=default'>Choose a default ZAS setting</A><br>
		"}

	usr << browse(dat, "window=admin2;size=210x280")
	return

/datum/admins/proc/Secrets()
	if(!check_rights(0))
		return

	var/dat = "<B>The first rule of adminbuse is: you don't talk about the adminbuse.</B><HR>"
	for(var/datum/admin_secret_category/category in admin_secrets.categories)
		if(!category.can_view(usr))
			continue
		dat += "<B>69category.name69</B><br>"
		if(category.desc)
			dat += "<I>69category.desc69</I><BR>"
		for(var/datum/admin_secret_item/item in category.items)
			if(!item.can_view(usr))
				continue
			dat += "<A href='?src=\ref69src69;admin_secrets=\ref69item69'>69item.name()69</A><BR>"
		dat += "<BR>"
	usr << browse(dat, "window=secrets")
	return



/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm69erge
//i.e. buttons/verbs


ADMIN_VERB_ADD(/datum/admins/proc/restart, R_SERVER, FALSE)
/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_chat(world, "<span class='danger'>Restarting world!</span> <span class='notice'>Initiated by 69usr.client.holder.fakekey ? "Admin" : usr.key69!</span>")
		log_admin("69key_name(usr)69 initiated a reboot.")


		sleep(50)
		world.Reboot()


ADMIN_VERB_ADD(/datum/admins/proc/announce, R_ADMIN, FALSE)
//priority announce something to all clients.
/datum/admins/proc/announce()
	set category = "Special69erbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	if(!check_rights(0))
		return

	var/message = input("Global69essage to send:", "Admin Announce", null, null)  as69essage
	if(message)
		if(!check_rights(R_SERVER,0))
			message = sanitize(message, 500, extra = 0)
		message = replacetext(message, "\n", "<br>") // required since we're putting it in a <p> tag
		to_chat(world, "<span class=notice><b>69usr.client.holder.fakekey ? "Administrator" : usr.key69 Announces:</b><p style='text-indent: 50px'>69message69</p></span>")
		log_admin("Announce: 69key_name(usr)69 : 69message69")


ADMIN_VERB_ADD(/datum/admins/proc/toggleooc, R_ADMIN, FALSE)
//toggles ooc on/off for everyone
/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"

	if(!check_rights(R_ADMIN))
		return

	config.ooc_allowed = !(config.ooc_allowed)
	if (config.ooc_allowed)
		to_chat(world, "<B>The OOC channel has been globally enabled!</B>")
	else
		to_chat(world, "<B>The OOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled OOC.")

ADMIN_VERB_ADD(/datum/admins/proc/togglelooc, R_ADMIN, FALSE)
//toggles looc on/off for everyone
/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle LOOC"

	if(!check_rights(R_ADMIN))
		return

	config.looc_allowed = !(config.looc_allowed)
	if (config.looc_allowed)
		to_chat(world, "<B>The LOOC channel has been globally enabled!</B>")
	else
		to_chat(world, "<B>The LOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled LOOC.")


ADMIN_VERB_ADD(/datum/admins/proc/toggledsay, R_ADMIN, FALSE)
//toggles dsay on/off for everyone
/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"

	if(!check_rights(R_ADMIN))
		return

	config.dsay_allowed = !(config.dsay_allowed)
	if (config.dsay_allowed)
		to_chat(world, "<B>Deadchat has been globally enabled!</B>")
	else
		to_chat(world, "<B>Deadchat has been globally disabled!</B>")
	log_admin("69key_name(usr)69 toggled deadchat.")
	message_admins("69key_name_admin(usr)69 toggled deadchat.", 1)

ADMIN_VERB_ADD(/datum/admins/proc/toggleoocdead, R_ADMIN, FALSE)
//toggles ooc on/off for everyone who is dead
/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle Dead OOC."
	set name="Toggle Dead OOC"

	if(!check_rights(R_ADMIN))
		return

	config.dooc_allowed = !( config.dooc_allowed )
	log_admin("69key_name(usr)69 toggled Dead OOC.")
	message_admins("69key_name_admin(usr)69 toggled Dead OOC.", 1)


ADMIN_VERB_ADD(/datum/admins/proc/startnow, R_SERVER, FALSE)
/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(SSticker.current_state <= GAME_STATE_PREGAME)
		SSticker.start_immediately = TRUE
		log_admin("69usr.key69 has started the game.")
		var/msg = ""
		if(SSticker.current_state == GAME_STATE_STARTUP)
			msg = " (The server is still setting up, but the round will be \
				started as soon as possible.)"
		message_admins("<font color='blue'>\
			69usr.key69 has started the game.69msg69</font>")
	else
		to_chat(usr, "<font color='red'>Error: Start Now: Game has already started.</font>")

ADMIN_VERB_ADD(/datum/admins/proc/toggleenter, R_ADMIN, FALSE)
//toggles whether people can join the current game
/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	config.enter_allowed = !(config.enter_allowed)
	if (!(config.enter_allowed))
		to_chat(world, "<B>New players69ay no longer enter the game.</B>")
	else
		to_chat(world, "<B>New players69ay now enter the game.</B>")
	log_admin("69key_name(usr)69 toggled new player game entering.")
	message_admins("\blue 69key_name_admin(usr)69 toggled new player game entering.", 1)
	world.update_status()


ADMIN_VERB_ADD(/datum/admins/proc/toggleAI, R_ADMIN, FALSE)
/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"

	config.allow_ai = !( config.allow_ai )

	if (!( config.allow_ai ))
		to_chat(world, "<B>The AI job is no longer chooseable.</B>")
	else
		to_chat(world, "<B>The AI job is chooseable now.</B>")

	message_admins("69key_name(usr)69 has toggled 69config.allow_ai ? "On" : "Off"69 AI allowed.")
	log_admin("69key_name(usr)69 toggled AI allowed.")

	world.update_status()


ADMIN_VERB_ADD(/datum/admins/proc/toggleRespawn, R_SERVER, FALSE)
/datum/admins/proc/toggleRespawn()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	config.abandon_allowed = !(config.abandon_allowed)
	if(config.abandon_allowed)
		to_chat(world, "<B>You69ay now respawn.</B>")
	else
		to_chat(world, "<B>You69ay no longer respawn :(</B>")
	message_admins("\blue 69key_name_admin(usr)69 toggled respawn to 69config.abandon_allowed ? "On" : "Off"69.", 1)
	log_admin("69key_name(usr)69 toggled respawn to 69config.abandon_allowed ? "On" : "Off"69.")
	world.update_status()

ADMIN_VERB_ADD(/datum/admins/proc/delay, R_SERVER, FALSE)
/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER))
		return
	if (SSticker.current_state != GAME_STATE_PREGAME && SSticker.current_state != GAME_STATE_STARTUP)
		SSticker.delay_end = !SSticker.delay_end
		log_admin("69key_name(usr)69 69SSticker.delay_end ? "delayed the round end" : "has69ade the round end normally"69.")
		message_admins("\blue 69key_name(usr)69 69SSticker.delay_end ? "delayed the round end" : "has69ade the round end normally"69.", 1)
		return
	round_progressing = !round_progressing
	if (!round_progressing)
		to_chat(world, "<b>The game start has been delayed.</b>")
		log_admin("69key_name(usr)69 delayed the game.")
	else
		to_chat(world, "<b>The game will start soon.</b>")
		log_admin("69key_name(usr)69 removed the delay.")

ADMIN_VERB_ADD(/datum/admins/proc/immreboot, R_SERVER, FALSE)
/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.holder)
		return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_chat(world, "\red <b>Rebooting world!</b> \blue Initiated by 69usr.client.holder.fakekey ? "Admin" : usr.key69!")
	log_admin("69key_name(usr)69 initiated an immediate reboot.")
	world.Reboot()


////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(mob/M) // returns 1 for special characters
	if (!istype(M))
		return NO_ANTAG

	if(M.mind && player_is_limited_antag(M.mind))
		return LIMITED_ANTAG

	if(M.mind && player_is_antag(M.mind))
		return ANTAG

	if(isrobot(M))
		var/mob/living/silicon/robot/R =69
		if(R.emagged)
			return ANTAG

	return NO_ANTAG

/proc/is_limited_antag(mob/M)
	if(M.mind && player_is_limited_antag(M.mind))
		return TRUE
	return FALSE

ADMIN_VERB_ADD(/datum/admins/proc/spawn_fruit, R_DEBUG, FALSE)
/datum/admins/proc/spawn_fruit(seedtype in plant_controller.seeds)
	set category = "Debug"
	set desc = "Spawn the product of a seed."
	set name = "Spawn Fruit"

	if(!check_rights(R_DEBUG))
		return

	if(!seedtype || !plant_controller.seeds69seedtype69)
		return
	var/datum/seed/S = plant_controller.seeds69seedtype69
	S.harvest(usr,0,0,1)
	log_admin("69key_name(usr)69 spawned 69seedtype69 fruit at (69usr.x69,69usr.y69,69usr.z69)")

ADMIN_VERB_ADD(/datum/admins/proc/spawn_custom_item, R_DEBUG, FALSE)
/datum/admins/proc/spawn_custom_item()
	set category = "Debug"
	set desc = "Spawn a custom item."
	set name = "Spawn Custom Item"

	if(!check_rights(R_DEBUG))
		return

	var/owner = input("Select a ckey.", "Spawn Custom Item") as null|anything in custom_items
	if(!owner|| !custom_items69owner69)
		return

	var/list/possible_items = custom_items69owner69
	var/datum/custom_item/item_to_spawn = input("Select an item to spawn.", "Spawn Custom Item") as null|anything in possible_items
	if(!item_to_spawn)
		return

	item_to_spawn.spawn_item(get_turf(usr))


ADMIN_VERB_ADD(/datum/admins/proc/check_custom_items, R_DEBUG, FALSE)
/datum/admins/proc/check_custom_items()
	set category = "Debug"
	set desc = "Check the custom item list."
	set name = "Check Custom Items"

	if(!check_rights(R_DEBUG))
		return

	if(!custom_items)
		to_chat(usr, "Custom item list is null.")
		return

	if(!custom_items.len)
		to_chat(usr, "Custom item list not populated.")
		return

	for(var/assoc_key in custom_items)
		to_chat(usr, "69assoc_key69 has:")
		var/list/current_items = custom_items69assoc_key69
		for(var/datum/custom_item/item in current_items)
			to_chat(usr, "- name: 69item.name69 icon: 69item.item_icon69 path: 69item.item_path69 desc: 69item.item_desc69")


ADMIN_VERB_ADD(/datum/admins/proc/spawn_plant, R_DEBUG, FALSE)
/datum/admins/proc/spawn_plant(seedtype in plant_controller.seeds)
	set category = "Debug"
	set desc = "Spawn a spreading plant effect."
	set name = "Spawn Plant"

	if(!check_rights(R_DEBUG))
		return

	if(!seedtype || !plant_controller.seeds69seedtype69)
		return
	new /obj/effect/plant(get_turf(usr), plant_controller.seeds69seedtype69)
	log_admin("69key_name(usr)69 spawned 69seedtype6969ines at (69usr.x69,69usr.y69,69usr.z69)")


ADMIN_VERB_ADD(/datum/admins/proc/spawn_atom, R_DEBUG, FALSE)
// allows us to spawn instances
/datum/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_DEBUG))
		return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("69path69", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen =69atches69169
	else
		chosen = input("Select an atom type", "Spawn Atom",69atches69169) as null|anything in69atches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned 69chosen69 at (69usr.x69,69usr.y69,69usr.z69)")

//interface which shows a69ob's69ind
/datum/admins/proc/show_contractor_panel(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set desc = "Edit69obs's69emory and role"
	set name = "Show Contractor Panel"

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This69ob has no69ind!")
		return

	M.mind.edit_memory()

/*
ADMIN_VERB_ADD(/datum/admins/proc/show_game_mode, R_ADMIN, FALSE)
//Configuration window for the current game69ode.
/datum/admins/proc/show_game_mode()
	set category = "Admin"
	set desc = "Show the current round storyteller."
	set name = "Show Storyteller"

	if(!get_storyteller())
		alert("Not before roundstart!", "Alert")
		return

	var/out = "<font size=3><b>Current storyteller: 69get_storyteller().name69 (<a href='?src=\ref69get_storyteller()69;debug_antag=self'>69get_storyteller().config_tag69</a>)</b></font><br/>"
	out += "<hr>"

	if(SSticker.mode.antag_tags && SSticker.mode.antag_tags.len)
		out += "<b>Core antag templates:</b></br>"
		for(var/antag_tag in SSticker.mode.antag_tags)
			out += "<a href='?src=\ref69SSticker.mode69;debug_antag=69antag_tag69'>69antag_tag69</a>.</br>"

	out += "<b>All antag ids:</b>"
	if(SSticker.mode.antag_templates && SSticker.mode.antag_templates.len).
		for(var/datum/antagonist/antag in SSticker.mode.antag_templates)
			antag.update_current_antag_max()
			out += " <a href='?src=\ref69SSticker.mode69;debug_antag=69antag.id69'>69antag.id69</a>"
			out += " (69antag.get_antag_count()69/69antag.cur_max69) "
			out += " <a href='?src=\ref69SSticker.mode69;remove_antag_type=69antag.id69'>\69-\69</a><br/>"
	else
		out += " None."
	out += " <a href='?src=\ref69SSticker.mode69;add_antag_type=1'>\69+\69</a><br/>"

	usr << browse(out, "window=edit_mode69src69")
*/


/datum/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces69iew range when wearing welding helmets"
	set name="Toggle tinted welding helmets."
	config.welder_vision = !( config.welder_vision )
	if (config.welder_vision)
		to_chat(world, "<B>Reduced welder69ision has been enabled!</B>")
	else
		to_chat(world, "<B>Reduced welder69ision has been disabled!</B>")
	log_admin("69key_name(usr)69 toggled welder69ision.")
	message_admins("69key_name_admin(usr)69 toggled welder69ision.", 1)


ADMIN_VERB_ADD(/datum/admins/proc/toggleguests, R_ADMIN, FALSE)
//toggles whether guests can join the current game
/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	config.guests_allowed = !(config.guests_allowed)
	if (!(config.guests_allowed))
		to_chat(world, "<B>Guests69ay no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests69ay now enter the game.</B>")
	log_admin("69key_name(usr)69 toggled guests game entering 69config.guests_allowed?"":"dis"69allowed.")
	message_admins("\blue 69key_name_admin(usr)69 toggled guests game entering 69config.guests_allowed?"":"dis"69allowed.", 1)


/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in SSmobs.mob_list)
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI 69key_name(S, usr)69's laws:</b>")
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			to_chat(usr, "<b>CYBORG 69key_name(S, usr)69 69R.connected_ai?"(Slaved to: 69R.connected_ai69)":"(Independant)"69: laws:</b>")
		else if (ispAI(S))
			to_chat(usr, "<b>pAI 69key_name(S, usr)69's laws:</b>")
		else
			to_chat(usr, "<b>SOMETHING SILICON 69key_name(S, usr)69's laws:</b>")

		if (S.laws == null)
			to_chat(usr, "69key_name(S, usr)69's laws are null?? Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AIs located</b>" ) //Just so you know the thing is actually working and not just ignoring you.

/client/proc/update_mob_sprite(mob/living/carbon/human/H as69ob)
	set category = "Admin"
	set name = "Update69ob Sprite"
	set desc = "Should fix any69ob sprite update errors."

	if (!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	if(istype(H))
		H.regenerate_icons()


/*
	helper proc to test if someone is a69entor or not.  Got tired of writing this same check all over the place.
*/
/proc/is_mentor(client/C)

	if(!istype(C))
		return 0
	if(!C.holder)
		return 0

	if(C.holder.rights == R_MENTOR)
		return 1
	return 0

/proc/get_options_bar(whom, detail = 2, name = 0, link = 1, highlight_special = 1)
	if(!whom)
		return "<b>(*null*)</b>"
	var/mob/M
	var/client/C
	if(istype(whom, /client))
		C = whom
		M = C.mob
	else if(ismob(whom))
		M = whom
		C =69.client
	else
		return "<b>(*not an69ob*)</b>"
	switch(detail)
		if(0)
			return "<b>69key_name(C, link, name, highlight_special)69</b>"

		if(1)	//Private69essages
			return "<b>69key_name(C, link, name, highlight_special)69(<A HREF='?_src_=holder;adminmoreinfo=\ref69M69'>?</A>)</b>"

		if(2)	//Admins
			var/ref_mob = "\ref69M69"
			return "<b>69key_name(C, link, name, highlight_special)69(<A HREF='?_src_=holder;adminmoreinfo=69ref_mob69'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=69ref_mob69'>PP</A>) (<A HREF='?_src_=vars;Vars=69ref_mob69'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=69ref_mob69'>SM</A>) (69admin_jump_link(M, UNLINT(src))69) (<A HREF='?_src_=holder;check_antagonist=1'>CA</A>)</b>"

		if(3)	//Devs
			var/ref_mob = "\ref69M69"
			return "<b>69key_name(C, link, name, highlight_special)69(<A HREF='?_src_=vars;Vars=69ref_mob69'>VV</A>)(69admin_jump_link(M, UNLINT(src))69)</b>"

		if(4)	//Mentors
			var/ref_mob = "\ref69M69"
			return "<b>69key_name(C, link, name, highlight_special)69 (<A HREF='?_src_=holder;adminmoreinfo=\ref69M69'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=69ref_mob69'>PP</A>) (<A HREF='?_src_=vars;Vars=69ref_mob69'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=69ref_mob69'>SM</A>) (69admin_jump_link(M, UNLINT(src))69)</b>"


//
//
//ALL DONE
//*********************************************************************************************************
//

//Returns 1 to let the dragdrop code know we are trapping this event
//Returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(var/mob/observer/ghost/frommob,69ar/mob/living/tomob)
	if(!istype(frommob))
		return //Extra sanity check to69ake sure only observers are shoved into things

	//Same as assume-direct-control perm requirements.
	if (!check_rights(R_ADMIN|R_DEBUG,0))
		return 0
	if (!frommob.ckey)
		return 0
	var/question = ""
	if (tomob.ckey)
		question = "This69ob already has a user (69tomob.key69) in control of it! "
	question += "Are you sure you want to place 69frommob.name69(69frommob.key69) in control of 69tomob.name69?"
	var/ask = alert(question, "Place ghost in control of69ob?", "Yes", "No")
	if (ask != "Yes")
		return 1
	if (!frommob || !tomob) //make sure the69obs don't go away while we waited for a response
		return 1
	if(tomob.client) //No need to ghostize if there is no client
		tomob.ghostize(0)
	message_admins("<span class='adminnotice'>69key_name_admin(usr)69 has put 69frommob.ckey69 in control of 69tomob.name69.</span>")
	log_admin("69key_name(usr)69 stuffed 69frommob.ckey69 into 69tomob.name69.")

	tomob.ckey = frommob.ckey
	if(tomob.client)
		if(tomob.client.UI)
			tomob.client.UI.show()
		else
			tomob.client.create_UI(tomob.type)

	qdel(frommob)
	return 1

/*
ADMIN_VERB_ADD(/datum/admins/proc/force_mode_latespawn, R_ADMIN, FALSE)
//Force the69ode to try a latespawn proc
/datum/admins/proc/force_mode_latespawn()
	set category = "Admin"
	set name = "Force69ode Spawn"
	set desc = "Force autocontractor to proc."

	if (!istype(src,/datum/admins))
		src = usr.client.holder
	if (!istype(src,/datum/admins) || !check_rights(R_ADMIN))
		to_chat(usr, "Error: you are not an admin!")
		return

	if(!SSticker.mode)
		to_chat(usr, "Mode has not started.")
		return

	log_and_message_admins("attempting to force69ode autospawn.")
	SSticker.mode.process_autoantag()
*/

ADMIN_VERB_ADD(/datum/admins/proc/paralyze_mob, R_ADMIN, FALSE)
/datum/admins/proc/paralyze_mob(mob/living/H as69ob)
	set category = "Fun"
	set name = "Toggle Paralyze"
	set desc = "Paralyzes a player. Or unparalyses them."

	var/msg

	if(check_rights(R_ADMIN))
		if (H.paralysis == 0)
			H.paralysis = 8000
			msg = "has paralyzed 69key_name(H)69."
		else
			H.paralysis = 0
			msg = "has unparalyzed 69key_name(H)69."
		log_and_message_admins(msg)

// Returns a list of the number of admins in69arious categories
// result69169 is the number of staff that69atch the rank69ask and are active
// result69269 is the number of staff that do not69atch the rank69ask
// result69369 is the number of staff that69atch the rank69ask and are inactive
/proc/staff_countup(rank_mask = R_ADMIN)
	var/list/result = list(0, 0, 0)
	for(var/client/X in admins)
		if(rank_mask && !check_rights_for(X, rank_mask))
			result69269++
			continue
		if(X.holder.fakekey)
			result69269++
			continue
		if(X.is_afk())
			result69369++
			continue
		result69169++
	return result

//This proc checks whether subject has at least ONE of the rights specified in rights_required.
/proc/check_rights_for(client/subject, rights_required)
	if(subject && subject.holder)
		if(rights_required && !(rights_required & subject.holder.rights))
			return 0
		return 1
	return 0