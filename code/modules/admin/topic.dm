/datum/admins/proc/formatJob(var/mob/mob, var/title, var/bantype)
	if(!bantype)
		bantype = title
	var/red = jobban_isbanned(mob, bantype)
	return \
		"<a href='?src=\ref[src];jobban3=[bantype];jobban4=\ref[mob]'>\
		[red ? "<font color=red>" : null][replacetext(title, " ", "&nbsp")][red ? "</font>" : null]\
		</a> "

/datum/admins/proc/formatJobGroup(var/mob/mob, var/title, var/color, var/bantype, var/list/jobList)
	. += "<tr bgcolor='[color]'><th><a href='?src=\ref[src];jobban3=[bantype];jobban4=\ref[mob]'>[title]</a></th></tr><tr><td class='jobs'>"
	for(var/jobPos in jobList)
		. += formatJob(mob, jobPos, jobList[jobPos])
	. += "</td></tr>"


/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	var/static/list/topic_handlers = AdminTopicHandlers()
	var/datum/world_topic/handler

	for(var/I in topic_handlers)
		if(I in href_list)
			handler = topic_handlers[I]
			break

	if(!handler)
		return

	handler = new handler()
	handler.TryRun(href_list, src)


	if(href_list["AdminFaxView"])
		var/obj/item/fax = locate(href_list["AdminFaxView"])
		if (istype(fax, /obj/item/weapon/paper))
			var/obj/item/weapon/paper/P = fax
			P.show_content(usr,1)
		else if (istype(fax, /obj/item/weapon/photo))
			var/obj/item/weapon/photo/H = fax
			H.show(usr)
		else if (istype(fax, /obj/item/weapon/paper_bundle))
			//having multiple people turning pages on a paper_bundle can cause issues
			//open a browse window listing the contents instead
			var/data = ""
			var/obj/item/weapon/paper_bundle/B = fax

			for (var/page = 1, page <= B.pages.len, page++)
				var/obj/pageobj = B.pages[page]
				data += "<A href='?src=\ref[src];AdminFaxViewPage=[page];paper_bundle=\ref[B]'>Page [page] - [pageobj.name]</A><BR>"

			usr << browse(data, "window=[B.name]")
		else
			usr << "\red The faxed item is not viewable. This is probably a bug, and should be reported on the tracker: [fax.type]"

	else if (href_list["AdminFaxViewPage"])
		var/page = text2num(href_list["AdminFaxViewPage"])
		var/obj/item/weapon/paper_bundle/bundle = locate(href_list["paper_bundle"])

		if (!bundle) return

		if (istype(bundle.pages[page], /obj/item/weapon/paper))
			var/obj/item/weapon/paper/P = bundle.pages[page]
			P.show_content(src.owner, 1)
		else if (istype(bundle.pages[page], /obj/item/weapon/photo))
			var/obj/item/weapon/photo/H = bundle.pages[page]
			H.show(src.owner)
		return

	else if(href_list["CentcommFaxReply"])
		var/mob/sender = locate(href_list["CentcommFaxReply"])
		var/obj/machinery/photocopier/faxmachine/fax = locate(href_list["originfax"])

		//todo: sanitize
		var/input = russian_to_utf8(input(src.owner, "Please enter a message to reply to [key_name(sender)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Centcomm", "") as message|null)
		if(!input)	return

		var/customname = russian_to_utf8(input(src.owner, "Pick a title for the report", "Title") as text|null)

		// Create the reply message
		var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( null ) //hopefully the null loc won't cause trouble for us
		P.name = "[command_name()]- [customname]"
		P.info = input
		P.update_icon()

		// Stamps
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		stampoverlay.icon_state = "paper_stamp-cent"
		if(!P.stamped)
			P.stamped = new
		P.stamped += /obj/item/weapon/stamp
		P.overlays += stampoverlay
		P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

		if(fax.recievefax(P))
			src.owner << "\blue Message reply to transmitted successfully."
			log_admin("[key_name(src.owner)] replied to a fax message from [key_name(sender)]: [input]")
			message_admins("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(sender)]", 1)
		else
			src.owner << "\red Message reply failed."

		spawn(100)
			qdel(P)
		return


	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")	return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		if(!GLOB.storyteller)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob."
			return
		show_traitor_panel(M)

	else if(href_list["create_object"])
		if(!check_rights(R_FUN))
			return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_FUN))
			return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_FUN))
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_FUN))
			return
		return create_mob(usr)

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_FUN))
			return

		if(!config.allow_admin_spawning)
			usr << "Spawning of items is not allowed."
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5)")
			return

		var/list/offset = splittext(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])


		var/atom/target //Where the object will be spawned
		var/where = href_list["object_where"]
		if (!( where in list("onfloor","inhand","inmarked") ))
			where = "onfloor"

		switch(where)
			if("inhand")
				if (!iscarbon(usr) && !isrobot(usr))
					usr << "Can only spawn in hand when you're a carbon mob or cyborg."
					where = "onfloor"
				target = usr

			if("onfloor")
				switch(href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if("inmarked")
				if(!marked_datum())
					usr << "You don't have any object marked. Abandoning spawn."
					return
				else if(!istype(marked_datum(),  /atom))
					usr << "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn."
					return
				else
					target = marked_datum()

		if(target)
			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N && obj_name)
							N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.set_dir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(istype(O,/mob))
									var/mob/M = O
									M.real_name = obj_name
							if(where == "inhand" && isliving(usr) && istype(O, /obj/item))
								var/mob/living/L = usr
								var/obj/item/I = O
								L.put_in_hands(I)
								if(isrobot(L))
									var/mob/living/silicon/robot/R = L
									if(R.module)
										R.module.modules += I
										I.loc = R.module
										R.module.rebuild()
										R.activate_module(I)

		log_and_message_admins("created [number] [english_list(paths)]")
		return

	else if(href_list["admin_secrets"])
		var/datum/admin_secret_item/item = locate(href_list["admin_secrets"]) in admin_secrets.items
		item.execute(usr)

	else if(href_list["ac_view_wanted"])            //Admin newscaster Topic() stuff be here
		src.admincaster_screen = 18                 //The ac_ prefix before the hrefs stands for AdminCaster.
		src.access_news_network()

	else if(href_list["ac_set_channel_name"])
		src.admincaster_feed_channel.channel_name = sanitizeSafe(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""))
		src.access_news_network()

	else if(href_list["ac_set_channel_lock"])
		src.admincaster_feed_channel.locked = !src.admincaster_feed_channel.locked
		src.access_news_network()

	else if(href_list["ac_submit_new_channel"])
		var/check = 0
		for(var/datum/feed_channel/FC in news_network.network_channels)
			if(FC.channel_name == src.admincaster_feed_channel.channel_name)
				check = 1
				break
		if(src.admincaster_feed_channel.channel_name == "" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]" || check )
			src.admincaster_screen=7
		else
			var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
			if(choice=="Confirm")
				news_network.CreateFeedChannel(admincaster_feed_channel.channel_name, admincaster_signature, admincaster_feed_channel.locked, 1)

				log_admin("[key_name_admin(usr)] created command feed channel: [src.admincaster_feed_channel.channel_name]!")
				src.admincaster_screen=5
		src.access_news_network()

	else if(href_list["ac_set_channel_receiving"])
		var/list/available_channels = list()
		for(var/datum/feed_channel/F in news_network.network_channels)
			available_channels += F.channel_name
		src.admincaster_feed_channel.channel_name = sanitizeSafe(input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels )
		src.access_news_network()

	else if(href_list["ac_set_new_message"])
		src.admincaster_feed_message.body = sanitize(input(usr, "Write your Feed story", "Network Channel Handler", ""))
		src.access_news_network()

	else if(href_list["ac_submit_new_message"])
		if(src.admincaster_feed_message.body =="" || src.admincaster_feed_message.body =="\[REDACTED\]" || src.admincaster_feed_channel.channel_name == "" )
			src.admincaster_screen = 6
		else

			news_network.SubmitArticle(src.admincaster_feed_message.body, src.admincaster_signature, src.admincaster_feed_channel.channel_name, null, 1)
			src.admincaster_screen=4

		log_admin("[key_name_admin(usr)] submitted a feed story to channel: [src.admincaster_feed_channel.channel_name]!")
		src.access_news_network()

	else if(href_list["ac_create_channel"])
		src.admincaster_screen=2
		src.access_news_network()

	else if(href_list["ac_create_feed_story"])
		src.admincaster_screen=3
		src.access_news_network()

	else if(href_list["ac_menu_censor_story"])
		src.admincaster_screen=10
		src.access_news_network()

	else if(href_list["ac_menu_censor_channel"])
		src.admincaster_screen=11
		src.access_news_network()

	else if(href_list["ac_menu_wanted"])
		var/already_wanted = 0
		if(news_network.wanted_issue)
			already_wanted = 1

		if(already_wanted)
			src.admincaster_feed_message.author = news_network.wanted_issue.author
			src.admincaster_feed_message.body = news_network.wanted_issue.body
		src.admincaster_screen = 14
		src.access_news_network()

	else if(href_list["ac_set_wanted_name"])
		src.admincaster_feed_message.author = sanitize(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""))
		src.access_news_network()

	else if(href_list["ac_set_wanted_desc"])
		src.admincaster_feed_message.body = sanitize(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
		src.access_news_network()

	else if(href_list["ac_submit_wanted"])
		var/input_param = text2num(href_list["ac_submit_wanted"])
		if(src.admincaster_feed_message.author == "" || src.admincaster_feed_message.body == "")
			src.admincaster_screen = 16
		else
			var/choice = alert("Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
					var/datum/feed_message/WANTED = new /datum/feed_message
					WANTED.author = src.admincaster_feed_message.author               //Wanted name
					WANTED.body = src.admincaster_feed_message.body                   //Wanted desc
					WANTED.backup_author = src.admincaster_signature                  //Submitted by
					WANTED.is_admin_message = 1
					news_network.wanted_issue = WANTED
					for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
						NEWSCASTER.newsAlert()
						NEWSCASTER.update_icon()
					src.admincaster_screen = 15
				else
					news_network.wanted_issue.author = src.admincaster_feed_message.author
					news_network.wanted_issue.body = src.admincaster_feed_message.body
					news_network.wanted_issue.backup_author = src.admincaster_feed_message.backup_author
					src.admincaster_screen = 19
				log_admin("[key_name_admin(usr)] issued a Station-wide Wanted Notification for [src.admincaster_feed_message.author]!")
		src.access_news_network()

	else if(href_list["ac_cancel_wanted"])
		var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
		if(choice=="Confirm")
			news_network.wanted_issue = null
			for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
				NEWSCASTER.update_icon()
			src.admincaster_screen=17
		src.access_news_network()

	else if(href_list["ac_censor_channel_author"])
		var/datum/feed_channel/FC = locate(href_list["ac_censor_channel_author"])
		if(FC.author != "<B>\[REDACTED\]</B>")
			FC.backup_author = FC.author
			FC.author = "<B>\[REDACTED\]</B>"
		else
			FC.author = FC.backup_author
		src.access_news_network()

	else if(href_list["ac_censor_channel_story_author"])
		var/datum/feed_message/MSG = locate(href_list["ac_censor_channel_story_author"])
		if(MSG.author != "<B>\[REDACTED\]</B>")
			MSG.backup_author = MSG.author
			MSG.author = "<B>\[REDACTED\]</B>"
		else
			MSG.author = MSG.backup_author
		src.access_news_network()

	else if(href_list["ac_censor_channel_story_body"])
		var/datum/feed_message/MSG = locate(href_list["ac_censor_channel_story_body"])
		if(MSG.body != "<B>\[REDACTED\]</B>")
			MSG.backup_body = MSG.body
			MSG.body = "<B>\[REDACTED\]</B>"
		else
			MSG.body = MSG.backup_body
		src.access_news_network()

	else if(href_list["ac_pick_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["ac_pick_d_notice"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen=13
		src.access_news_network()

	else if(href_list["ac_toggle_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["ac_toggle_d_notice"])
		FC.censored = !FC.censored
		src.access_news_network()

	else if(href_list["ac_view"])
		src.admincaster_screen=1
		src.access_news_network()

	else if(href_list["ac_setScreen"]) //Brings us to the main menu and resets all fields~
		src.admincaster_screen = text2num(href_list["ac_setScreen"])
		if (src.admincaster_screen == 0)
			if(src.admincaster_feed_channel)
				src.admincaster_feed_channel = new /datum/feed_channel
			if(src.admincaster_feed_message)
				src.admincaster_feed_message = new /datum/feed_message
		src.access_news_network()

	else if(href_list["ac_show_channel"])
		var/datum/feed_channel/FC = locate(href_list["ac_show_channel"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen = 9
		src.access_news_network()

	else if(href_list["ac_pick_censor_channel"])
		var/datum/feed_channel/FC = locate(href_list["ac_pick_censor_channel"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen = 12
		src.access_news_network()

	else if(href_list["ac_refresh"])
		src.access_news_network()

	else if(href_list["ac_set_signature"])
		src.admincaster_signature = sanitize(input(usr, "Provide your desired signature", "Network Identity Handler", ""))
		src.access_news_network()

	else if(href_list["populate_inactive_customitems"])
		if(check_rights(R_ADMIN|R_SERVER))
			populate_inactive_customitems_list(src.owner)

	else if(href_list["vsc"])
		if(check_rights(R_ADMIN|R_SERVER))
			if(href_list["vsc"] == "airflow")
				vsc.ChangeSettingsDialog(usr,vsc.settings)
			if(href_list["vsc"] == "plasma")
				vsc.ChangeSettingsDialog(usr,vsc.plc.settings)
			if(href_list["vsc"] == "default")
				vsc.SetDefault(usr)

	else if(href_list["toglang"])
		if(check_rights(R_FUN))
			var/mob/M = locate(href_list["toglang"])
			if(!istype(M))
				usr << "[M] is illegal type, must be /mob!"
				return
			var/lang2toggle = href_list["lang"]
			var/datum/language/L = all_languages[lang2toggle]

			if(L in M.languages)
				if(!M.remove_language(lang2toggle))
					usr << "Failed to remove language '[lang2toggle]' from \the [M]!"
			else
				if(!M.add_language(lang2toggle))
					usr << "Failed to add language '[lang2toggle]' from \the [M]!"

			show_player_panel(M)

	else if(href_list["viewruntime"])
		if(check_rights(R_DEBUG))
			var/datum/ErrorViewer/error_viewer = locate(href_list["viewruntime"])
			if(!istype(error_viewer))
				to_chat(usr, "<span class='warning'>That runtime viewer no longer exists.</span>")
				return
			if(href_list["viewruntime_backto"])
				error_viewer.showTo(usr, locate(href_list["viewruntime_backto"]), href_list["viewruntime_linear"])
			else
				error_viewer.showTo(usr, null, href_list["viewruntime_linear"])

mob/living/proc/can_centcom_reply()
	return 0

mob/living/carbon/human/can_centcom_reply()
	return istype(l_ear, /obj/item/device/radio/headset) || istype(r_ear, /obj/item/device/radio/headset)

mob/living/silicon/ai/can_centcom_reply()
	return common_radio != null && !check_unable(2)

/atom/proc/extra_admin_link()
	return

/mob/extra_admin_link(var/source)
	if(client && eyeobj)
		return "|<A HREF='?[source];adminplayerobservejump=\ref[eyeobj]'>EYE</A>"

/mob/observer/ghost/extra_admin_link(var/source)
	if(mind && mind.current)
		return "|<A HREF='?[source];adminplayerobservejump=\ref[mind.current]'>BDY</A>"

/proc/admin_jump_link(var/atom/target, var/source)
	if(!target) return
	// The way admin jump links handle their src is weirdly inconsistent...
	if(istype(source, /datum/admins))
		source = "src=\ref[source]"
	else
		source = "_src_=holder"

	. = "<A HREF='?[source];adminplayerobservejump=\ref[target]'>JMP</A>"
	. += target.extra_admin_link(source)
