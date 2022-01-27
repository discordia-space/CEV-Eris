var/list/obj/machinery/photocopier/faxmachine/allfaxes = list()
var/list/admin_departments = list("69boss_name69", "Sol Government", "Supply")
var/list/alldepartments = list()

var/list/adminfaxes = list()	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax69achine"
	icon = 'icons/obj/library.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_heads, access_armory, access_merchant)

	density = FALSE//It's a small69achine that sits on a table, this allows small things to walk under that table
	use_power = IDLE_POWER_USE
	idle_power_usage = 30
	active_power_usage = 200

	var/obj/item/card/id/scan =69ull // identification
	var/authenticated = 0
	var/sendcooldown = 0 // to avoid spamming fax69essages
	var/department = "Unknown" // our department
	var/destination =69ull // the department we're sending to

/obj/machinery/photocopier/faxmachine/New()
	..()
	allfaxes += src
	if(!destination) destination = "69boss_name69"
	if( !(("69department69" in alldepartments) || ("69department69" in admin_departments)) )
		alldepartments |= department

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as69ob)
	user.set_machine(src)

	var/dat = "Fax69achine<BR>"

	var/scan_name
	if(scan)
		scan_name = scan.name
	else
		scan_name = "--------"

	dat += "Confirm Identity: <a href='byond://?src=\ref69src69;scan=1'>69scan_name69</a><br>"

	if(authenticated)
		dat += "<a href='byond://?src=\ref69src69;logout=1'>{Log Out}</a>"
	else
		dat += "<a href='byond://?src=\ref69src69;auth=1'>{Log In}</a>"

	dat += "<hr>"

	if(authenticated)
		dat += "<b>Logged in to:</b> 69boss_name69 Quantum Entanglement69etwork<br><br>"

		if(copyitem)
			dat += "<a href='byond://?src=\ref69src69;remove=1'>Remove Item</a><br><br>"

			if(sendcooldown)
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"

			else

				dat += "<a href='byond://?src=\ref69src69;send=1'>Send</a><br>"
				dat += "<b>Currently sending:</b> 69copyitem.name69<br>"
				dat += "<b>Sending to:</b> <a href='byond://?src=\ref69src69;dept=1'>69destination69</a><br>"

		else
			if(sendcooldown)
				dat += "Please insert paper to send69ia secure connection.<br><br>"
				dat += "<b>Transmitter arrays realigning. Please stand by.</b><br>"
			else
				dat += "Please insert paper to send69ia secure connection.<br><br>"

	else
		dat += "Proper authentication is required to use this device.<br><br>"

		if(copyitem)
			dat += "<a href ='byond://?src=\ref69src69;remove=1'>Remove Item</a><br>"

	user << browse(dat, "window=copier")
	onclose(user, "copier")
	return

/obj/machinery/photocopier/faxmachine/Topic(href, href_list)
	if(href_list69"send"69)
		if(copyitem)
			if (destination in admin_departments)
				send_admin_fax(usr, destination)
			else
				sendfax(destination)

			if (sendcooldown)
				spawn(sendcooldown) // cooldown time
					sendcooldown = 0

	else if(href_list69"remove"69)
		if(copyitem)
			copyitem.loc = usr.loc
			usr.put_in_hands(copyitem)
			to_chat(usr, SPAN_NOTICE("You take \the 69copyitem69 out of \the 69src69."))
			copyitem =69ull
			updateUsrDialog()

	if(href_list69"scan"69)
		if (scan)
			if(ishuman(usr))
				scan.loc = usr.loc
				if(!usr.get_active_hand())
					usr.put_in_hands(scan)
				scan =69ull
			else
				scan.loc = src.loc
				scan =69ull
		else
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/card/id) && usr.unEquip(I))
				I.loc = src
				scan = I
		authenticated = 0

	if(href_list69"dept"69)
		var/lastdestination = destination
		destination = input(usr, "Which department?", "Choose a department", "") as69ull|anything in (alldepartments + admin_departments)
		if(!destination) destination = lastdestination

	if(href_list69"auth"69)
		if ( (!( authenticated ) && (scan)) )
			if (check_access(scan))
				authenticated = 1

	if(href_list69"logout"69)
		authenticated = 0

	updateUsrDialog()

/obj/machinery/photocopier/faxmachine/proc/sendfax(var/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if( F.department == destination )
			success = F.recievefax(copyitem)

	if (success)
		visible_message("69src69 beeps, \"Message transmitted successfully.\"")
		//sendcooldown = 600
	else
		visible_message("69src69 beeps, \"Error transmitting69essage.\"")

/obj/machinery/photocopier/faxmachine/proc/recievefax(var/obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(loc, "sound/items/polaroid1.ogg", 50, 1)

	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(var/mob/sender,69ar/destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/paper))
		rcvdcopy = copy(copyitem)
	else if (istype(copyitem, /obj/item/photo))
		rcvdcopy = photocopy(copyitem)
	else if (istype(copyitem, /obj/item/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("69src69 beeps, \"Error transmitting69essage.\"")
		return

	rcvdcopy.loc =69ull //hopefully this shouldn't cause trouble
	adminfaxes += rcvdcopy

	//message badmins that a fax has arrived
	switch(destination)
		if (boss_name)
			message_admins(sender, "69uppertext(boss_short)69 FAX", rcvdcopy, "CentcomFaxReply", "#006100")
		if ("Sol Government")
			message_admins(sender, "SOL GOVERNMENT FAX", rcvdcopy, "CentcomFaxReply", "#1F66A0")
			//message_admins(sender, "SOL GOVERNMENT FAX", rcvdcopy, "SolGovFaxReply", "#1F66A0")
		if ("Supply")
			message_admins(sender, "69uppertext(boss_short)69 SUPPLY FAX", rcvdcopy, "CentcomFaxReply", "#5F4519")

	sendcooldown = 1800
	sleep(50)
	visible_message("69src69 beeps, \"Message transmitted successfully.\"")


/obj/machinery/photocopier/faxmachine/proc/message_admins(var/mob/sender,69ar/faxname,69ar/obj/item/sent,69ar/reply_type, font_colour="#006100")
	var/msg = "\blue <b><font color='69font_colour69'>69faxname69: </font>69key_name(sender, 1)69 (<A HREF='?_src_=holder;adminplayeropts=\ref69sender69'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref69sender69'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref69sender69'>SM</A>) (69admin_jump_link(sender, src)69) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<a href='?_src_=holder;69reply_type69=\ref69sender69;originfax=\ref69src69'>REPLY</a>)</b>: Receiving '69sent.name69'69ia secure connection ... <a href='?_src_=holder;AdminFaxView=\ref69sent69'>view69essage</a>"

	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C,69sg)
	var/faxid = export_fax(sent)
	message_chat_admins(sender, faxname, sent, faxid, font_colour)

/obj/machinery/photocopier/faxmachine/proc/export_fax(fax)
	var faxid = "69num2text(world.realtime,12)69_69rand(10000)69"
	if (istype(fax, /obj/item/paper))
		var/obj/item/paper/P = fax
		var/text = "<HTML><HEAD><TITLE>69P.name69</TITLE></HEAD><BODY>69P.info6969P.stamps69</BODY></HTML>";
		file("69config.fax_export_dir69/fax_69faxid69.html") << text;
	else if (istype(fax, /obj/item/photo))
		var/obj/item/photo/H = fax
		fcopy(H.img, "69config.fax_export_dir69/photo_69faxid69.png")
		var/text = "<html><head><title>69H.name69</title></head>" \
			+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
			+ "<img src='photo_69faxid69.png'>" \
			+ "69H.scribble ? "<br>Written on the back:<br><i>69H.scribble69</i>" : ""69"\
			+ "</body></html>"
		file("69config.fax_export_dir69/fax_69faxid69.html") << text
	else if (istype(fax, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = fax
		var/data = ""
		for (var/page = 1, page <= B.pages.len, page++)
			var/obj/pageobj = B.pages69page69
			var/page_faxid = export_fax(pageobj)
			data += "<a href='fax_69page_faxid69.html'>Page 69page69 - 69pageobj.name69</a><br>"
		var/text = "<html><head><title>69B.name69</title></head><body>69data69</body></html>"
		file("69config.fax_export_dir69/fax_69faxid69.html") << text
	return faxid

/**
 * Call the chat webhook to transmit a69otification of an admin fax to the admin chat.
 */
/obj/machinery/photocopier/faxmachine/proc/message_chat_admins(var/mob/sender,69ar/faxname,69ar/obj/item/sent,69ar/faxid, font_colour="#006100")
	if (config.webhook_url)
		spawn(0)
			var/query_string = "type=fax"
			query_string += "&key=69url_encode(config.webhook_key)69"
			query_string += "&faxid=69url_encode(faxid)69"
			query_string += "&color=69url_encode(font_colour)69"
			query_string += "&faxname=69url_encode(faxname)69"
			query_string += "&sendername=69url_encode(sender.name)69"
			query_string += "&sentname=69url_encode(sent.name)69"
			world.Export("69config.webhook_url69?69query_string69")

//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//
/datum/configuration
	var/fax_export_dir = "data/faxes"	// Directory in which to write exported fax HTML files.
