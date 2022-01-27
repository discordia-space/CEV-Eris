//##############################################
//################### NEWSCASTERS BE HERE! ####
//###-A69ouri###################################

/datum/feed_messa69e
	var/author =""
	var/body =""
	var/messa69e_type ="Story"
	var/datum/feed_channel/parent_channel
	var/is_admin_messa69e = 0
	var/icon/im69 = null
	var/icon/caption = ""
	var/time_stamp = ""
	var/backup_body = ""
	var/backup_author = ""
	var/icon/backup_im69 = null
	var/icon/backup_caption = ""

/datum/feed_channel
	var/channel_name=""
	var/list/datum/feed_messa69e/messa69es = list()
	var/locked=0
	var/author=""
	var/backup_author=""
	var/views=0
	var/censored=0
	var/is_admin_channel=0
	var/updated = 0
	var/announcement = ""

/datum/feed_messa69e/proc/clear()
	src.author = ""
	src.body = ""
	src.caption = ""
	src.im69 = null
	src.time_stamp = ""
	src.backup_body = ""
	src.backup_author = ""
	src.backup_caption = ""
	src.backup_im69 = null
	parent_channel.update()

/datum/feed_channel/proc/update()
	updated = world.time

/datum/feed_channel/proc/clear()
	src.channel_name = ""
	src.messa69es = list()
	src.locked = 0
	src.author = ""
	src.backup_author = ""
	src.censored = 0
	src.is_admin_channel = 0
	src.announcement = ""
	update()

/datum/feed_network
	var/list/datum/feed_channel/network_channels = list()
	var/datum/feed_messa69e/wanted_issue

/datum/feed_network/New()
	CreateFeedChannel("Ship Announcements", "SS13", 1, 1, "New Station Announcement Available")

/datum/feed_network/proc/CreateFeedChannel(var/channel_name,69ar/author,69ar/locked,69ar/adminChannel = 0,69ar/announcement_messa69e)
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = channel_name
	newChannel.author = author
	newChannel.locked = locked
	newChannel.is_admin_channel = adminChannel
	if(announcement_messa69e)
		newChannel.announcement = announcement_messa69e
	else
		newChannel.announcement = "Breakin69 news from 69channel_name69!"
	network_channels += newChannel

/datum/feed_network/proc/SubmitArticle(var/ms69,69ar/author,69ar/channel_name,69ar/obj/item/photo/photo,69ar/adminMessa69e = 0,69ar/messa69e_type = "")
	var/datum/feed_messa69e/newMs69 = new /datum/feed_messa69e
	newMs69.author = author
	newMs69.body =69s69
	newMs69.time_stamp = "69stationtime2text()69"
	newMs69.is_admin_messa69e = adminMessa69e
	if(messa69e_type)
		newMs69.messa69e_type =69essa69e_type
	if(photo)
		newMs69.im69 = photo.im69
		newMs69.caption = photo.scribble
	for(var/datum/feed_channel/FC in network_channels)
		if(FC.channel_name == channel_name)
			insert_messa69e_in_channel(FC, newMs69) //Addin6969essa69e to the network's appropriate feed_channel
			break

/datum/feed_network/proc/insert_messa69e_in_channel(var/datum/feed_channel/FC,69ar/datum/feed_messa69e/newMs69)
	FC.messa69es += newMs69
	if(newMs69.im69)
		re69ister_asset("newscaster_photo_69sanitize(FC.channel_name)69_69FC.messa69es.len69.pn69", newMs69.im69)
	newMs69.parent_channel = FC
	FC.update()
	alert_readers(FC.announcement)

/datum/feed_network/proc/alert_readers(var/annoncement)
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
		NEWSCASTER.newsAlert(annoncement)
		NEWSCASTER.update_icon()

var/datum/feed_network/news_network = new /datum/feed_network     //The 69lobal news-network, which is coincidentally a 69lobal list.

var/list/obj/machinery/newscaster/allCasters = list() //69lobal list that will contain reference to all newscasters in existence.


/obj/machinery/newscaster
	name = "newscaster"
	desc = "A standard newsfeed handler. All the news you absolutely have no use for, in one place!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_normal"
	var/isbroken = 0  //1 if someone ban69ed it with somethin69 heavy
	var/ispowered = 1 //starts powered, chan69es with power_chan69e()
	//var/list/datum/feed_channel/channel_list = list() //This list will contain the names of the feed channels. Each name will refer to a data re69ion where the69essa69es of the feed channels are stored.
	//OBSOLETE: We're now usin69 a 69lobal news network
	var/screen = 0                  //Or69aybe I'll69ake it into a list within a list afterwards... whichever I prefer, 69o fuck yourselves :3
		// 0 = welcome screen -69ain69enu
		// 1 =69iew feed channels
		// 2 = create feed channel
		// 3 = create feed story
		// 4 = feed story submited sucessfully
		// 5 = feed channel created successfully
		// 6 = ERROR: Cannot create feed story
		// 7 = ERROR: Cannot create feed channel
		// 8 = print newspaper
		// 9 =69iewin69 channel feeds
		// 10 = censor feed story
		// 11 = censor feed channel
		//Holy shit this is outdated,69ade this when I was still startin69 newscasters :3
	var/paper_remainin69 = 0
	var/securityCaster = 0
		// 0 = Caster cannot be used to issue wanted posters
		// 1 = the opposite
	var/unit_no = 0 //Each newscaster has a unit number
	//var/datum/feed_messa69e/wanted //We're 69onna use a feed_messa69e to store data of the wanted person because fields are similar
	//var/wanted_issue = 0          //OBSOLETE
		// 0 = there's no WANTED issued, we don't need a special icon_state
		// 1 = 69uess what.
	var/alert_delay = 500
	var/alert = 0
		// 0 = there hasn't been a news/wanted update in the last alert_delay
		// 1 = there has
	var/scanned_user = "Unknown" //Will contain the name of the person who currently uses the newscaster
	var/ms69 = "";                //Feed69essa69e
	var/datum/news_photo/photo_data = null
	var/channel_name = ""; //the feed channel which will be receivin69 the feed, or bein69 created
	var/c_locked=0;        //Will our new channel be locked to public submissions?
	var/hitstaken = 0      //Death at 3 hits from an item with force>=15
	var/datum/feed_channel/viewin69_channel = null
	li69ht_ran69e = 0
	anchored = TRUE


/obj/machinery/newscaster/security_unit                   //Security unit
	name = "Security Newscaster"
	securityCaster = 1

/obj/machinery/newscaster/New()         //Constructor, ho~
	allCasters += src
	src.paper_remainin69 = 15            // Will probably chan69e this to somethin69 better
	for(var/obj/machinery/newscaster/NEWSCASTER in allCasters) // Let's 69ive it an appropriate unit number
		src.unit_no++
	src.update_icon() //for any custom ones on the69ap...
	..()                                //I just realised the newscasters weren't in the 69lobal69achines list. The superconstructor call will tend to that

/obj/machinery/newscaster/Destroy()
	allCasters -= src
	. = ..()

/obj/machinery/newscaster/update_icon()
	if(!ispowered || isbroken)
		icon_state = "newscaster_off"
		if(isbroken) //If the thin69 is smashed, add crack overlay on top of the unpowered sprite.
			src.overlays.Cut()
			src.overlays += ima69e(src.icon, "crack3")
		return

	src.overlays.Cut() //reset overlays

	if(news_network.wanted_issue) //wanted icon state, there can be no overlays on it as it's a priority69essa69e
		icon_state = "newscaster_wanted"
		return

	if(alert) //new69essa69e alert overlay
		src.overlays += "newscaster_alert"

	if(hitstaken > 0) //Cosmetic dama69e overlay
		src.overlays += ima69e(src.icon, "crack69hitstaken69")

	icon_state = "newscaster_normal"
	return

/obj/machinery/newscaster/power_chan69e()
	if(isbroken) //Broken shit can't be powered.
		return
	..()
	if( !(stat & NOPOWER) )
		src.ispowered = 1
		src.update_icon()
	else
		spawn(rand(0, 15))
			src.ispowered = 0
			src.update_icon()


/obj/machinery/newscaster/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			src.isbroken = 1
			if(prob(50))
				69del(src)
			else
				src.update_icon() //can't place it above the return and outside the if-else. or we69i69ht 69et runtimes of null.update_icon() if(prob(50)) 69oes in.
			return
		else
			if(prob(50))
				src.isbroken = 1
			src.update_icon()

/obj/machinery/newscaster/attack_hand(mob/user as69ob)            //########### THE69AIN BEEF IS HERE! And in the proc below this...############

	if(!src.ispowered || src.isbroken)
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(ishuman(user) || issilicon(user))
		var/mob/livin69/human_or_robot_user = user
		var/dat
		dat = text("<HEAD><TITLE>Newscaster</TITLE></HEAD><H3>Newscaster Unit #69src.unit_no69</H3>")

		src.scan_user(human_or_robot_user) //Newscaster scans you

		switch(screen)
			if(0)
				dat += "Welcome to Newscastin69 Unit #69src.unit_no69.<BR> Interface & News networks Operational."
				dat += "<BR><FONT SIZE=1>Property of Nanotrasen Inc</FONT>"
				if(news_network.wanted_issue)
					dat+= "<HR><A href='?src=\ref69src69;view_wanted=1'>Read Wanted Issue</A>"
				dat+= "<HR><BR><A href='?src=\ref69src69;create_channel=1'>Create Feed Channel</A>"
				dat+= "<BR><A href='?src=\ref69src69;view=1'>View Feed Channels</A>"
				dat+= "<BR><A href='?src=\ref69src69;create_feed_story=1'>Submit new Feed story</A>"
				dat+= "<BR><A href='?src=\ref69src69;menu_paper=1'>Print newspaper</A>"
				dat+= "<BR><A href='?src=\ref69src69;refresh=1'>Re-scan User</A>"
				dat+= "<BR><BR><A href='?src=\ref69human_or_robot_user69;mach_close=newscaster_main'>Exit</A>"
				if(src.securityCaster)
					var/wanted_already = 0
					if(news_network.wanted_issue)
						wanted_already = 1

					dat+="<HR><B>Feed Security functions:</B><BR>"
					dat+="<BR><A href='?src=\ref69src69;menu_wanted=1'>69(wanted_already) ? ("Mana69e") : ("Publish")69 \"Wanted\" Issue</A>"
					dat+="<BR><A href='?src=\ref69src69;menu_censor_story=1'>Censor Feed Stories</A>"
					dat+="<BR><A href='?src=\ref69src69;menu_censor_channel=1'>Mark Feed Channel with 69company_name69 D-Notice</A>"
				dat+="<BR><HR>The newscaster reco69nises you as: <FONT COLOR='69reen'>69src.scanned_user69</FONT>"
			if(1)
				dat+= "Station Feed Channels<HR>"
				if( isemptylist(news_network.network_channels) )
					dat+="<I>No active channels found...</I>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						if(CHANNEL.is_admin_channel)
							dat+="<B><FONT style='BACK69ROUND-COLOR: Li69ht69reen '><A href='?src=\ref69src69;show_channel=\ref69CHANNEL69'>69CHANNEL.channel_name69</A></FONT></B><BR>"
						else
							dat+="<B><A href='?src=\ref69src69;show_channel=\ref69CHANNEL69'>69CHANNEL.channel_name69</A> 69(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null69<BR></B>"
				dat+="<BR><HR><A href='?src=\ref69src69;refresh=1'>Refresh</A>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Back</A>"
			if(2)
				dat+="Creatin69 new Feed Channel..."
				dat+="<HR><B><A href='?src=\ref69src69;set_channel_name=1'>Channel Name</A>:</B> 69src.channel_name69<BR>"
				dat+="<B>Channel Author:</B> <FONT COLOR='69reen'>69src.scanned_user69</FONT><BR>"
				dat+="<B><A href='?src=\ref69src69;set_channel_lock=1'>Will Accept Public Feeds</A>:</B> 69(src.c_locked) ? ("NO") : ("YES")69<BR><BR>"
				dat+="<BR><A href='?src=\ref69src69;submit_new_channel=1'>Submit</A><BR><BR><A href='?src=\ref69src69;setScreen=69069'>Cancel</A><BR>"
			if(3)
				dat+="Creatin69 new Feed69essa69e..."
				dat+="<HR><B><A href='?src=\ref69src69;set_channel_receivin69=1'>Receivin69 Channel</A>:</B> 69src.channel_name69<BR>" //MARK
				dat+="<B>Messa69e Author:</B> <FONT COLOR='69reen'>69src.scanned_user69</FONT><BR>"
				dat+="<B><A href='?src=\ref69src69;set_new_messa69e=1'>Messa69e Body</A>:</B> 69src.ms6969 <BR>"
				dat+="<B><A href='?src=\ref69src69;set_attachment=1'>Attach Photo</A>:</B>  69(src.photo_data ? "Photo Attached" : "No Photo")69</BR>"
				dat+="<BR><A href='?src=\ref69src69;submit_new_messa69e=1'>Submit</A><BR><BR><A href='?src=\ref69src69;setScreen=69069'>Cancel</A><BR>"
			if(4)
				dat+="Feed story successfully submitted to 69src.channel_name69.<BR><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Return</A><BR>"
			if(5)
				dat+="Feed Channel 69src.channel_name69 created successfully.<BR><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Return</A><BR>"
			if(6)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed story to Network.</B></FONT><HR><BR>"
				if(src.channel_name=="")
					dat+="<FONT COLOR='maroon'>Invalid receivin69 channel name.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				if(src.ms69 == "" || src.ms69 == "\69REDACTED\69")
					dat+="<FONT COLOR='maroon'>Invalid69essa69e body.</FONT><BR>"

				dat+="<BR><A href='?src=\ref69src69;setScreen=69369'>Return</A><BR>"
			if(7)
				dat+="<B><FONT COLOR='maroon'>ERROR: Could not submit Feed Channel to Network.</B></FONT><HR><BR>"
				var/list/existin69_authors = list()
				for(var/datum/feed_channel/FC in news_network.network_channels)
					if(FC.author == "\69REDACTED\69")
						existin69_authors += FC.backup_author
					else
						existin69_authors += FC.author
				if(src.scanned_user in existin69_authors)
					dat+="<FONT COLOR='maroon'>There already exists a Feed channel under your name.</FONT><BR>"
				if(src.channel_name=="" || src.channel_name == "\69REDACTED\69")
					dat+="<FONT COLOR='maroon'>Invalid channel name.</FONT><BR>"
				var/check = 0
				for(var/datum/feed_channel/FC in news_network.network_channels)
					if(FC.channel_name == src.channel_name)
						check = 1
						break
				if(check)
					dat+="<FONT COLOR='maroon'>Channel name already in use.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Channel author unverified.</FONT><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69269'>Return</A><BR>"
			if(8)
				var/total_num=len69th(news_network.network_channels)
				var/active_num=total_num
				var/messa69e_num=0
				for(var/datum/feed_channel/FC in news_network.network_channels)
					if(!FC.censored)
						messa69e_num += len69th(FC.messa69es)    //Dont for69et, datum/feed_channel's69ar69essa69es is a list of datum/feed_messa69e
					else
						active_num--
				dat+="Network currently serves a total of 69total_num69 Feed channels, 69active_num69 of which are active, and a total of 69messa69e_num69 Feed Stories." //TODO: CONTINUE
				dat+="<BR><BR><B>Li69uid Paper remainin69:</B> 69(src.paper_remainin69) *100 69 cm^3"
				dat+="<BR><BR><A href='?src=\ref69src69;print_paper=69069'>Print Paper</A>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Cancel</A>"
			if(9)
				dat+="<B>69src.viewin69_channel.channel_name69: </B><FONT SIZE=1>\69created by: <FONT COLOR='maroon'>69src.viewin69_channel.author69</FONT>\69</FONT><HR>"
				if(src.viewin69_channel.censored)
					dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatenin69 to the welfare of the station, and69arked with a 69company_name69 D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.</FONT><BR><BR>"
				else
					if( isemptylist(src.viewin69_channel.messa69es) )
						dat+="<I>No feed69essa69es found in channel...</I><BR>"
					else
						var/i = 0
						for(var/datum/feed_messa69e/MESSA69E in src.viewin69_channel.messa69es)
							++i
							dat+="-69MESSA69E.body69 <BR>"
							if(MESSA69E.im69)
								var/resourc_name = "newscaster_photo_69sanitize(viewin69_channel.channel_name)69_69i69.pn69"
								send_asset(usr.client, resourc_name)
								dat+="<im69 src='69resourc_name69' width = '180'><BR>"
								if(MESSA69E.caption)
									dat+="<FONT SIZE=1><B>69MESSA69E.caption69</B></FONT><BR>"
								dat+="<BR>"
							dat+="<FONT SIZE=1>\69Story by <FONT COLOR='maroon'>69MESSA69E.author69 - 69MESSA69E.time_stamp69</FONT>\69</FONT><BR>"
				dat+="<BR><HR><A href='?src=\ref69src69;refresh=1'>Refresh</A>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69169'>Back</A>"
			if(10)
				dat+="<B>69company_name69 Feed Censorship Tool</B><BR>"
				dat+="<FONT SIZE=1>NOTE: Due to the nature of news Feeds, total deletion of a Feed Story is not possible.<BR>"
				dat+="Keep in69ind that users attemptin69 to69iew a censored feed will instead see the \69REDACTED\69 ta69 above it.</FONT>"
				dat+="<HR>Select Feed channel to 69et Stories from:<BR>"
				if(isemptylist(news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						dat+="<A href='?src=\ref69src69;pick_censor_channel=\ref69CHANNEL69'>69CHANNEL.channel_name69</A> 69(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null69<BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Cancel</A>"
			if(11)
				dat+="<B>69company_name69 D-Notice Handler</B><HR>"
				dat+="<FONT SIZE=1>A D-Notice is to be bestowed upon the channel if the handlin69 Authority deems it as harmful for the station's"
				dat+="morale, inte69rity or disciplinary behaviour. A D-Notice will render a channel unable to be updated by anyone, without deletin69 any feed"
				dat+="stories it69i69ht contain at the time. You can lift a D-Notice if you have the re69uired access at any time.</FONT><HR>"
				if(isemptylist(news_network.network_channels))
					dat+="<I>No feed channels found active...</I><BR>"
				else
					for(var/datum/feed_channel/CHANNEL in news_network.network_channels)
						dat+="<A href='?src=\ref69src69;pick_d_notice=\ref69CHANNEL69'>69CHANNEL.channel_name69</A> 69(CHANNEL.censored) ? ("<FONT COLOR='red'>***</FONT>") : null69<BR>"

				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Back</A>"
			if(12)
				dat+="<B>69src.viewin69_channel.channel_name69: </B><FONT SIZE=1>\69 created by: <FONT COLOR='maroon'>69src.viewin69_channel.author69</FONT> \69</FONT><BR>"
				dat+="<FONT SIZE=2><A href='?src=\ref69src69;censor_channel_author=\ref69src.viewin69_channel69'>69(src.viewin69_channel.author=="\69REDACTED\69") ? ("Undo Author censorship") : ("Censor channel Author")69</A></FONT><HR>"


				if( isemptylist(src.viewin69_channel.messa69es) )
					dat+="<I>No feed69essa69es found in channel...</I><BR>"
				else
					for(var/datum/feed_messa69e/MESSA69E in src.viewin69_channel.messa69es)
						dat+="-69MESSA69E.body69 <BR><FONT SIZE=1>\6969MESSA69E.messa69e_type69 by <FONT COLOR='maroon'>69MESSA69E.author69</FONT>\69</FONT><BR>"
						dat+="<FONT SIZE=2><A href='?src=\ref69src69;censor_channel_story_body=\ref69MESSA69E69'>69(MESSA69E.body == "\69REDACTED\69") ? ("Undo story censorship") : ("Censor story")69</A>  -  <A href='?src=\ref69src69;censor_channel_story_author=\ref69MESSA69E69'>69(MESSA69E.author == "\69REDACTED\69") ? ("Undo Author Censorship") : ("Censor69essa69e Author")69</A></FONT><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=691069'>Back</A>"
			if(13)
				dat+="<B>69src.viewin69_channel.channel_name69: </B><FONT SIZE=1>\69 created by: <FONT COLOR='maroon'>69src.viewin69_channel.author69</FONT> \69</FONT><BR>"
				dat+="Channel69essa69es listed below. If you deem them dan69erous to the station, you can <A href='?src=\ref69src69;to6969le_d_notice=\ref69src.viewin69_channel69'>Bestow a D-Notice upon the channel</A>.<HR>"
				if(src.viewin69_channel.censored)
					dat+="<FONT COLOR='red'><B>ATTENTION: </B></FONT>This channel has been deemed as threatenin69 to the welfare of the station, and69arked with a 69company_name69 D-Notice.<BR>"
					dat+="No further feed story additions are allowed while the D-Notice is in effect.<BR><BR>"
				else
					if( isemptylist(src.viewin69_channel.messa69es) )
						dat+="<I>No feed69essa69es found in channel...</I><BR>"
					else
						for(var/datum/feed_messa69e/MESSA69E in src.viewin69_channel.messa69es)
							dat+="-69MESSA69E.body69 <BR><FONT SIZE=1>\6969MESSA69E.messa69e_type69 by <FONT COLOR='maroon'>69MESSA69E.author69</FONT>\69</FONT><BR>"

				dat+="<BR><A href='?src=\ref69src69;setScreen=691169'>Back</A>"
			if(14)
				dat+="<B>Wanted Issue Handler:</B>"
				var/wanted_already = 0
				var/end_param = 1
				if(news_network.wanted_issue)
					wanted_already = 1
					end_param = 2

				if(wanted_already)
					dat+="<FONT SIZE=2><BR><I>A wanted issue is already in Feed Circulation. You can edit or cancel it below.</FONT></I>"
				dat+="<HR>"
				dat+="<A href='?src=\ref69src69;set_wanted_name=1'>Criminal Name</A>: 69src.channel_name69 <BR>"
				dat+="<A href='?src=\ref69src69;set_wanted_desc=1'>Description</A>: 69src.ms6969 <BR>"
				dat+="<A href='?src=\ref69src69;set_attachment=1'>Attach Photo</A>: 69(src.photo_data ? "Photo Attached" : "No Photo")69</BR>"
				if(wanted_already)
					dat+="<B>Wanted Issue created by:</B><FONT COLOR='69reen'> 69news_network.wanted_issue.backup_author69</FONT><BR>"
				else
					dat+="<B>Wanted Issue will be created under prosecutor:</B><FONT COLOR='69reen'> 69src.scanned_user69</FONT><BR>"
				dat+="<BR><A href='?src=\ref69src69;submit_wanted=69end_param69'>69(wanted_already) ? ("Edit Issue") : ("Submit")69</A>"
				if(wanted_already)
					dat+="<BR><A href='?src=\ref69src69;cancel_wanted=1'>Take down Issue</A>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Cancel</A>"
			if(15)
				dat+="<FONT COLOR='69reen'>Wanted issue for 69src.channel_name69 is now in Network Circulation.</FONT><BR><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Return</A><BR>"
			if(16)
				dat+="<B><FONT COLOR='maroon'>ERROR: Wanted Issue rejected by Network.</B></FONT><HR><BR>"
				if(src.channel_name=="" || src.channel_name == "\69REDACTED\69")
					dat+="<FONT COLOR='maroon'>Invalid name for person wanted.</FONT><BR>"
				if(src.scanned_user=="Unknown")
					dat+="<FONT COLOR='maroon'>Issue author unverified.</FONT><BR>"
				if(src.ms69 == "" || src.ms69 == "\69REDACTED\69")
					dat+="<FONT COLOR='maroon'>Invalid description.</FONT><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Return</A><BR>"
			if(17)
				dat+="<B>Wanted Issue successfully deleted from Circulation</B><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Return</A><BR>"
			if(18)
				dat+="<B><FONT COLOR ='maroon'>-- STATIONWIDE WANTED ISSUE --</B></FONT><BR><FONT SIZE=2>\69Submitted by: <FONT COLOR='69reen'>69news_network.wanted_issue.backup_author69</FONT>\69</FONT><HR>"
				dat+="<B>Criminal</B>: 69news_network.wanted_issue.author69<BR>"
				dat+="<B>Description</B>: 69news_network.wanted_issue.body69<BR>"
				dat+="<B>Photo:</B>: "
				if(news_network.wanted_issue.im69)
					usr << browse_rsc(news_network.wanted_issue.im69, "tmp_photow.pn69")
					dat+="<BR><im69 src='tmp_photow.pn69' width = '180'>"
				else
					dat+="None"
				dat+="<BR><BR><A href='?src=\ref69src69;setScreen=69069'>Back</A><BR>"
			if(19)
				dat+="<FONT COLOR='69reen'>Wanted issue for 69src.channel_name69 successfully edited.</FONT><BR><BR>"
				dat+="<BR><A href='?src=\ref69src69;setScreen=69069'>Return</A><BR>"
			if(20)
				dat+="<FONT COLOR='69reen'>Printin69 successful. Please receive your newspaper from the bottom of the69achine.</FONT><BR><BR>"
				dat+="<A href='?src=\ref69src69;setScreen=69069'>Return</A>"
			if(21)
				dat+="<FONT COLOR='maroon'>Unable to print newspaper. Insufficient paper. Please notify69aintenance personnel to refill69achine stora69e.</FONT><BR><BR>"
				dat+="<A href='?src=\ref69src69;setScreen=69069'>Return</A>"
			else
				dat+="I'm sorry to break your immersion. This shit's bu6969ed. Report this bu69 to A69ouri, polyxenitopalidou@69mail.com"


		human_or_robot_user << browse(dat, "window=newscaster_main;size=400x600")
		onclose(human_or_robot_user, "newscaster_main")

/obj/machinery/newscaster/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || ((69et_dist(src, usr) <= 1) && istype(src.loc, /turf))) || (issilicon(usr)))
		usr.set_machine(src)
		if(href_list69"set_channel_name"69)
			src.channel_name = sanitizeSafe(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""),69AX_LNAME_LEN)
			src.updateUsrDialo69()
			//src.update_icon()

		else if(href_list69"set_channel_lock"69)
			src.c_locked = !src.c_locked
			src.updateUsrDialo69()
			//src.update_icon()

		else if(href_list69"submit_new_channel"69)
			//var/list/existin69_channels = list() //OBSOLETE
			var/list/existin69_authors = list()
			for(var/datum/feed_channel/FC in news_network.network_channels)
				//existin69_channels += FC.channel_name
				if(FC.author == "\69REDACTED\69")
					existin69_authors += FC.backup_author
				else
					existin69_authors  +=FC.author
			var/check = 0
			for(var/datum/feed_channel/FC in news_network.network_channels)
				if(FC.channel_name == src.channel_name)
					check = 1
					break
			if(src.channel_name == "" || src.channel_name == "\69REDACTED\69" || src.scanned_user == "Unknown" || check || (src.scanned_user in existin69_authors) )
				src.screen=7
			else
				var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
				if(choice=="Confirm")
					news_network.CreateFeedChannel(src.channel_name, src.scanned_user, c_locked)
					src.screen=5
			src.updateUsrDialo69()
			//src.update_icon()

		else if(href_list69"set_channel_receivin69"69)
			//var/list/datum/feed_channel/available_channels = list()
			var/list/available_channels = list()
			for(var/datum/feed_channel/F in news_network.network_channels)
				if( (!F.locked || F.author == scanned_user) && !F.censored)
					available_channels += F.channel_name
			src.channel_name = input(usr, "Choose receivin69 Feed Channel", "Network Channel Handler") in available_channels
			src.updateUsrDialo69()

		else if(href_list69"set_new_messa69e"69)
			src.ms69 = sanitize(input(usr, "Write your Feed story", "Network Channel Handler", ""))
			src.updateUsrDialo69()

		else if(href_list69"set_attachment"69)
			AttachPhoto(usr)
			src.updateUsrDialo69()

		else if(href_list69"submit_new_messa69e"69)
			if(src.ms69 =="" || src.ms69=="\69REDACTED\69" || src.scanned_user == "Unknown" || src.channel_name == "" )
				src.screen=6
			else
				var/ima69e = photo_data ? photo_data.photo : null
				news_network.SubmitArticle(src.ms69, src.scanned_user, src.channel_name, ima69e, 0)
				if(photo_data)
					photo_data.photo.forceMove(69et_turf(src))
				src.screen=4

			src.updateUsrDialo69()

		else if(href_list69"create_channel"69)
			src.screen=2
			src.updateUsrDialo69()

		else if(href_list69"create_feed_story"69)
			src.screen=3
			src.updateUsrDialo69()

		else if(href_list69"menu_paper"69)
			src.screen=8
			src.updateUsrDialo69()
		else if(href_list69"print_paper"69)
			if(!src.paper_remainin69)
				src.screen=21
			else
				src.print_paper()
				src.screen = 20
			src.updateUsrDialo69()

		else if(href_list69"menu_censor_story"69)
			src.screen=10
			src.updateUsrDialo69()

		else if(href_list69"menu_censor_channel"69)
			src.screen=11
			src.updateUsrDialo69()

		else if(href_list69"menu_wanted"69)
			var/already_wanted = 0
			if(news_network.wanted_issue)
				already_wanted = 1

			if(already_wanted)
				src.channel_name = news_network.wanted_issue.author
				src.ms69 = news_network.wanted_issue.body
			src.screen = 14
			src.updateUsrDialo69()

		else if(href_list69"set_wanted_name"69)
			src.channel_name = sanitizeSafe(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""),69AX_LNAME_LEN)
			src.updateUsrDialo69()

		else if(href_list69"set_wanted_desc"69)
			src.ms69 = sanitize(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
			src.updateUsrDialo69()

		else if(href_list69"submit_wanted"69)
			var/input_param = text2num(href_list69"submit_wanted"69)
			if(src.ms69 == "" || src.channel_name == "" || src.scanned_user == "Unknown")
				src.screen = 16
			else
				var/choice = alert("Please confirm Wanted Issue 69(input_param==1) ? ("creation.") : ("edit.")69","Network Security Handler","Confirm","Cancel")
				if(choice=="Confirm")
					if(input_param==1)          //If input_param == 1 we're submittin69 a new wanted issue. At 2 we're just editin69 an existin69 one. See the else below
						var/datum/feed_messa69e/WANTED = new /datum/feed_messa69e
						WANTED.author = src.channel_name
						WANTED.body = src.ms69
						WANTED.backup_author = src.scanned_user //I know, a bit wacky
						if(photo_data)
							WANTED.im69 = photo_data.photo.im69
						news_network.wanted_issue = WANTED
						news_network.alert_readers()
						src.screen = 15
					else
						if(news_network.wanted_issue.is_admin_messa69e)
							alert("The wanted issue has been distributed by a 69company_name69 hi69herup. You cannot edit it.","Ok")
							return
						news_network.wanted_issue.author = src.channel_name
						news_network.wanted_issue.body = src.ms69
						news_network.wanted_issue.backup_author = src.scanned_user
						if(photo_data)
							news_network.wanted_issue.im69 = photo_data.photo.im69
						src.screen = 19

			src.updateUsrDialo69()

		else if(href_list69"cancel_wanted"69)
			if(news_network.wanted_issue.is_admin_messa69e)
				alert("The wanted issue has been distributed by a 69company_name69 hi69herup. You cannot take it down.","Ok")
				return
			var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.wanted_issue = null
				for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
					NEWSCASTER.update_icon()
				src.screen=17
			src.updateUsrDialo69()

		else if(href_list69"view_wanted"69)
			src.screen=18
			src.updateUsrDialo69()
		else if(href_list69"censor_channel_author"69)
			var/datum/feed_channel/FC = locate(href_list69"censor_channel_author"69)
			if(FC.is_admin_channel)
				alert("This channel was created by a 69company_name69 Officer. You cannot censor it.","Ok")
				return
			if(FC.author != "<B>\69REDACTED\69</B>")
				FC.backup_author = FC.author
				FC.author = "<B>\69REDACTED\69</B>"
			else
				FC.author = FC.backup_author
			FC.update()
			src.updateUsrDialo69()

		else if(href_list69"censor_channel_story_author"69)
			var/datum/feed_messa69e/MS69 = locate(href_list69"censor_channel_story_author"69)
			if(MS69.is_admin_messa69e)
				alert("This69essa69e was created by a 69company_name69 Officer. You cannot censor its author.","Ok")
				return
			if(MS69.author != "<B>\69REDACTED\69</B>")
				MS69.backup_author =69S69.author
				MS69.author = "<B>\69REDACTED\69</B>"
			else
				MS69.author =69S69.backup_author
			MS69.parent_channel.update()
			src.updateUsrDialo69()

		else if(href_list69"censor_channel_story_body"69)
			var/datum/feed_messa69e/MS69 = locate(href_list69"censor_channel_story_body"69)
			if(MS69.is_admin_messa69e)
				alert("This channel was created by a 69company_name69 Officer. You cannot censor it.","Ok")
				return
			if(MS69.body != "<B>\69REDACTED\69</B>")
				MS69.backup_body =69S69.body
				MS69.backup_caption =69S69.caption
				MS69.backup_im69 =69S69.im69
				MS69.body = "<B>\69REDACTED\69</B>"
				MS69.caption = "<B>\69REDACTED\69</B>"
				MS69.im69 = null
			else
				MS69.body =69S69.backup_body
				MS69.caption =69S69.caption
				MS69.im69 =69S69.backup_im69

			MS69.parent_channel.update()
			src.updateUsrDialo69()

		else if(href_list69"pick_d_notice"69)
			var/datum/feed_channel/FC = locate(href_list69"pick_d_notice"69)
			src.viewin69_channel = FC
			src.screen=13
			src.updateUsrDialo69()

		else if(href_list69"to6969le_d_notice"69)
			var/datum/feed_channel/FC = locate(href_list69"to6969le_d_notice"69)
			if(FC.is_admin_channel)
				alert("This channel was created by a 69company_name69 Officer. You cannot place a D-Notice upon it.","Ok")
				return
			FC.censored = !FC.censored
			FC.update()
			src.updateUsrDialo69()

		else if(href_list69"view"69)
			src.screen=1
			src.updateUsrDialo69()

		else if(href_list69"setScreen"69) //Brin69s us to the69ain69enu and resets all fields~
			src.screen = text2num(href_list69"setScreen"69)
			if (src.screen == 0)
				src.scanned_user = "Unknown";
				ms69 = "";
				src.c_locked=0;
				channel_name="";
				src.viewin69_channel = null
			src.updateUsrDialo69()

		else if(href_list69"show_channel"69)
			var/datum/feed_channel/FC = locate(href_list69"show_channel"69)
			src.viewin69_channel = FC
			src.screen = 9
			src.updateUsrDialo69()

		else if(href_list69"pick_censor_channel"69)
			var/datum/feed_channel/FC = locate(href_list69"pick_censor_channel"69)
			src.viewin69_channel = FC
			src.screen = 12
			src.updateUsrDialo69()

		else if(href_list69"refresh"69)
			src.updateUsrDialo69()



/obj/machinery/newscaster/attackby(obj/item/I as obj,69ob/user as69ob)
	if (src.isbroken)
		playsound(src.loc, 'sound/effects/hit_on_shattered_69lass.o6969', 100, 1)
		for (var/mob/O in hearers(5, src.loc))
			O.show_messa69e("<EM>69user.name69</EM> further abuses the shattered 69src.name69.")
	else
		if(istype(I, /obj/item) )
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			var/obj/item/W = I
			if(W.force <15)
				for (var/mob/O in hearers(5, src.loc))
					O.show_messa69e("69user.name69 hits the 69src.name69 with the 69W.name69 with no69isible effect." )
					playsound(src.loc, 'sound/effects/69lasshit.o6969', 100, 1)
			else
				src.hitstaken++
				if(src.hitstaken==3)
					for (var/mob/O in hearers(5, src.loc))
						O.show_messa69e("69user.name69 smashes the 69src.name69!" )
					src.isbroken=1
					playsound(src.loc, 'sound/effects/69lassbr3.o6969', 100, 1)
				else
					for (var/mob/O in hearers(5, src.loc))
						O.show_messa69e("69user.name69 forcefully slams the 69src.name69 with the 69I.name69!" )
					playsound(src.loc, 'sound/effects/69lasshit.o6969', 100, 1)
		else
			to_chat(user, SPAN_NOTICE("This does nothin69."))
	src.update_icon()

/datum/news_photo
	var/is_synth = 0
	var/obj/item/photo/photo = null

/datum/news_photo/New(var/obj/item/photo/p,69ar/synth)
	is_synth = synth
	photo = p

/obj/machinery/newscaster/proc/AttachPhoto(mob/user as69ob)
	if(photo_data)
		if(!photo_data.is_synth)
			photo_data.photo.forceMove(69et_turf(src))
			if(!issilicon(user))
				user.put_in_inactive_hand(photo_data.photo)
		69del(photo_data)

	if(istype(user.69et_active_hand(), /obj/item/photo))
		var/obj/item/photo = user.69et_active_hand()
		user.drop_item()
		photo.loc = src
		photo_data = new(photo, 0)
	else if(issilicon(user))
		var/mob/livin69/silicon/tempAI = user
		var/obj/item/photo/selection = tempAI.69etPicture()
		if (!selection)
			return

		photo_data = new(selection, 1)


//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The 69riffon, the newspaper circulatin69 aboard69ost stations."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = ITEM_SIZE_SMALL	//Let's69ake it fit in trashba69s!
	attack_verb = list("bapped")
	spawn_ta69s = SPAWN_TA69_JUNK
	rarity_value = 10
	var/screen = 0
	var/pa69es = 0
	var/curr_pa69e = 0
	var/list/datum/feed_channel/news_content = list()
	var/datum/feed_messa69e/important_messa69e
	var/scribble= ""
	var/scribble_pa69e

obj/item/newspaper/attack_self(mob/user as69ob)
	if(ishuman(user))
		var/mob/livin69/carbon/human/human_user = user
		var/dat
		src.pa69es = 0
		switch(screen)
			if(0) //Cover
				dat+="<DIV ALI69N='center'><B><FONT SIZE=6>The 69riffon</FONT></B></div>"
				dat+="<DIV ALI69N='center'><FONT SIZE=2>69company_name69-standard newspaper, for use on 69company_name69© Space Facilities</FONT></div><HR>"
				if(isemptylist(src.news_content))
					if(src.important_messa69e)
						dat+="Contents:<BR><ul><B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\69pa69e 69src.pa69es+269\69</FONT><BR></ul>"
					else
						dat+="<I>Other than the title, the rest of the newspaper is unprinted...</I>"
				else
					dat+="Contents:<BR><ul>"
					for(var/datum/feed_channel/NP in src.news_content)
						src.pa69es++
					if(src.important_messa69e)
						dat+="<B><FONT COLOR='red'>**</FONT>Important Security Announcement<FONT COLOR='red'>**</FONT></B> <FONT SIZE=2>\69pa69e 69src.pa69es+269\69</FONT><BR>"
					var/temp_pa69e=0
					for(var/datum/feed_channel/NP in src.news_content)
						temp_pa69e++
						dat+="<B>69NP.channel_name69</B> <FONT SIZE=2>\69pa69e 69temp_pa69e+169\69</FONT><BR>"
					dat+="</ul>"
				if(scribble_pa69e==curr_pa69e)
					dat+="<BR><I>There is a small scribble near the end of this pa69e... It reads: \"69src.scribble69\"</I>"
				dat+= "<HR><DIV STYLE='float:ri69ht;'><A href='?src=\ref69src69;next_pa69e=1'>Next Pa69e</A></DIV> <div style='float:left;'><A href='?src=\ref69human_user69;mach_close=newspaper_main'>Done readin69</A></DIV>"
			if(1) // X channel pa69es inbetween.
				for(var/datum/feed_channel/NP in src.news_content)
					src.pa69es++ //Let's 69et it ri69ht a69ain.
				var/datum/feed_channel/C = src.news_content69src.curr_pa69e69
				dat+="<FONT SIZE=4><B>69C.channel_name69</B></FONT><FONT SIZE=1> \69created by: <FONT COLOR='maroon'>69C.author69</FONT>\69</FONT><BR><BR>"
				if(C.censored)
					dat+="This channel was deemed dan69erous to the 69eneral welfare of the station and therefore69arked with a <B><FONT COLOR='red'>D-Notice</B></FONT>. Its contents were not transferred to the newspaper at the time of printin69."
				else
					if(isemptylist(C.messa69es))
						dat+="No Feed stories stem from this channel..."
					else
						dat+="<ul>"
						var/i = 0
						for(var/datum/feed_messa69e/MESSA69E in C.messa69es)
							++i
							dat+="-69MESSA69E.body69 <BR>"
							if(MESSA69E.im69)
								var/resourc_name = "newscaster_photo_69sanitize(C.channel_name)69_69i69.pn69"
								send_asset(user.client, resourc_name)
								dat+="<im69 src='69resourc_name69' width = '180'><BR>"
							dat+="<FONT SIZE=1>\6969MESSA69E.messa69e_type69 by <FONT COLOR='maroon'>69MESSA69E.author69</FONT>\69</FONT><BR><BR>"
						dat+="</ul>"
				if(scribble_pa69e==curr_pa69e)
					dat+="<BR><I>There is a small scribble near the end of this pa69e... It reads: \"69src.scribble69\"</I>"
				dat+= "<BR><HR><DIV STYLE='float:left;'><A href='?src=\ref69src69;prev_pa69e=1'>Previous Pa69e</A></DIV> <DIV STYLE='float:ri69ht;'><A href='?src=\ref69src69;next_pa69e=1'>Next Pa69e</A></DIV>"
			if(2) //Last pa69e
				for(var/datum/feed_channel/NP in src.news_content)
					src.pa69es++
				if(src.important_messa69e!=null)
					dat+="<DIV STYLE='float:center;'><FONT SIZE=4><B>Wanted Issue:</B></FONT SIZE></DIV><BR><BR>"
					dat+="<B>Criminal name</B>: <FONT COLOR='maroon'>69important_messa69e.author69</FONT><BR>"
					dat+="<B>Description</B>: 69important_messa69e.body69<BR>"
					dat+="<B>Photo:</B>: "
					if(important_messa69e.im69)
						user << browse_rsc(important_messa69e.im69, "tmp_photow.pn69")
						dat+="<BR><im69 src='tmp_photow.pn69' width = '180'>"
					else
						dat+="None"
				else
					dat+="<I>Apart from some uninterestin69 Classified ads, there's nothin69 on this pa69e...</I>"
				if(scribble_pa69e==curr_pa69e)
					dat+="<BR><I>There is a small scribble near the end of this pa69e... It reads: \"69src.scribble69\"</I>"
				dat+= "<HR><DIV STYLE='float:left;'><A href='?src=\ref69src69;prev_pa69e=1'>Previous Pa69e</A></DIV>"
			else
				dat+="I'm sorry to break your immersion. This shit's bu6969ed. Report this bu69 to A69ouri, polyxenitopalidou@69mail.com"

		dat+="<BR><HR><div ali69n='center'>69src.curr_pa69e+169</div>"
		human_user << browse(dat, "window=newspaper_main;size=300x400")
		onclose(human_user, "newspaper_main")
	else
		to_chat(user, "The paper is full of intelli69ible symbols!")


obj/item/newspaper/Topic(href, href_list)
	var/mob/livin69/U = usr
	..()
	if ((src in U.contents) || ( istype(loc, /turf) && in_ran69e(src, U) ))
		U.set_machine(src)
		if(href_list69"next_pa69e"69)
			if(curr_pa69e==src.pa69es+1)
				return //Don't need that at all, but anyway.
			if(src.curr_pa69e == src.pa69es) //We're at the69iddle, 69et to the end
				src.screen = 2
			else
				if(curr_pa69e == 0) //We're at the start, 69et to the69iddle
					src.screen=1
			src.curr_pa69e++
			playsound(src.loc, "pa69eturn", 50, 1)

		else if(href_list69"prev_pa69e"69)
			if(curr_pa69e == 0)
				return
			if(curr_pa69e == 1)
				src.screen = 0

			else
				if(curr_pa69e == src.pa69es+1) //we're at the end, let's 69o back to the69iddle.
					src.screen = 1
			src.curr_pa69e--
			playsound(src.loc, "pa69eturn", 50, 1)

		if (ismob(loc))
			src.attack_self(loc)


obj/item/newspaper/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/pen))
		if(src.scribble_pa69e == src.curr_pa69e)
			to_chat(user, "<FONT COLOR='blue'>There's already a scribble in this pa69e... You wouldn't want to69ake thin69s too cluttered, would you?</FONT>")
		else
			var/s = sanitize(input(user, "Write somethin69", "Newspaper", ""))
			s = sanitize(s)
			if (!s)
				return
			if (!in_ran69e(src, usr) && src.loc != usr)
				return
			src.scribble_pa69e = src.curr_pa69e
			src.scribble = s
			src.attack_self(user)
		return


////////////////////////////////////helper procs


/obj/machinery/newscaster/proc/scan_user(mob/livin69/user)
	if(ishuman(user))                       //User is a human
		var/mob/livin69/carbon/human/human_user = user
		var/obj/item/card/id/id = human_user.69etIdCard()
		if(istype(id))                                      //Newscaster scans you
			src.scanned_user = 69etNameAndAssi69nmentFromId(id)
		else
			src.scanned_user = "Unknown"
	else
		var/mob/livin69/silicon/ai_user = user
		src.scanned_user = "69ai_user.name69 (69ai_user.job69)"


/obj/machinery/newscaster/proc/print_paper()

	var/obj/item/newspaper/NEWSPAPER = new /obj/item/newspaper
	for(var/datum/feed_channel/FC in news_network.network_channels)
		NEWSPAPER.news_content += FC
	if(news_network.wanted_issue)
		NEWSPAPER.important_messa69e = news_network.wanted_issue
	NEWSPAPER.loc = 69et_turf(src)
	src.paper_remainin69--
	return

//Removed for now so these aren't even checked every tick. Left this here in-case A69ouri needs it later.
///obj/machinery/newscaster/Process()       //Was thinkin69 of doin69 the icon update throu69h process, but69ultiple iterations per second does not
//	return                                  //bode well with a newscaster network of 10+69achines. Let's just return it, as it's added in the69achines list.

/obj/machinery/newscaster/proc/newsAlert(var/news_call)   //This isn't A69ouri's work, for it is u69ly and69ile.
	var/turf/T = 69et_turf(src)                      //Who the fuck uses spawn(600) anyway, jesus christ
	if(news_call)
		for(var/mob/O in hearers(world.view-1, T))
			O.show_messa69e("<span class='newscaster'><EM>69src.name69</EM> beeps, \"69news_call69\"</span>",2)
		src.alert = 1
		src.update_icon()
		spawn(300)
			src.alert = 0
			src.update_icon()
		playsound(src.loc, 'sound/machines/twobeep.o6969', 75, 1)
	else
		for(var/mob/O in hearers(world.view-1, T))
			O.show_messa69e("<span class='newscaster'><EM>69src.name69</EM> beeps, \"Attention! Wanted issue distributed!\"</span>",2)
		playsound(src.loc, 'sound/machines/warnin69-buzzer.o6969', 75, 1)
	return
