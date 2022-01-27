// Allows you to69onitor69essa69es that passes the server.

/obj/machinery/computer/messa69e_monitor
	name = "messa69in6969onitor console"
	desc = "Used to access and69aintain data on69essa69in69 servers. Allows you to69iew PDA and re69uest console69essa69es."
	icon_screen = "comm_lo69s"
	li69ht_color = "#00b000"
	var/hack_icon = "error"
	circuit = /obj/item/electronics/circuitboard/messa69e_monitor
	//Server linked to.
	var/obj/machinery/messa69e_server/linkedServer
	//Sparks effect - For ema69
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
	//Messa69es - Saves69e time if I want to chan69e somethin69.
	var/noserver = "<span class='alert'>ALERT: No server detected.</span>"
	var/incorrectkey = "<span class='warnin69'>ALERT: Incorrect decryption key!</span>"
	var/defaultms69 = "<span class='notice'>Welcome. Please select an option.</span>"
	var/rebootms69 = "<span class='warnin69'>%$&(£: Critical %$$@ Error // !RestArtin69! <lOadiN69 backUp iNput ouTput> - ?pLeaSe wAit!</span>"
	//Computer properties
	var/screen = 0 		// 0 =69ain69enu, 1 =69essa69e Lo69s, 2 = Hacked screen, 3 = Custom69essa69e
	var/hackin69 = 0		// Is it bein69 hacked into by the AI/Cybor69
	var/ema69 = 0		// When it is ema6969ed.
	var/messa69e = "<span class='notice'>System bootup complete. Please select an option.</span>"	// The69essa69e that shows on the69ain69enu.
	var/auth = 0 // Are they authenticated?
	var/optioncount = 8
	// Custom69essa69e Properties
	var/customsender = "System Administrator"
	var/obj/item/device/pda/customrecepient
	var/customjob		= "Admin"
	var/custommessa69e 	= "This is a test, please i69nore."


/obj/machinery/computer/messa69e_monitor/attackby(obj/item/O as obj,69ob/livin69/user as69ob)
	if(stat & (NOPOWER|BROKEN))
		..()
		return
	if(!istype(user))
		return
	if(O.69et_tool_type(user, list(69UALITY_SCREW_DRIVIN69), src) && ema69)
		//Stops people from just unscrewin69 the69onitor and puttin69 it back to 69et the console workin69 a69ain.
		to_chat(user, SPAN_WARNIN69("It is too hot to69ess with!"))
		return

	..()
	return

/obj/machinery/computer/messa69e_monitor/ema69_act(var/remainin69_char69es,69ar/mob/user)
	// Will create sparks and print out the console's password. You will then have to wait a while for the console to be back online.
	// It'll take69ore time if there's69ore characters in the password..
	if(!ema69 && operable())
		if(!isnull(src.linkedServer))
			ema69 = 1
			screen = 2
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/obj/item/paper/monitorkey/MK = new/obj/item/paper/monitorkey
			MK.loc = src.loc
			// Will help69ake ema6969in69 the console not so easy to 69et away with.
			MK.info += "<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>"
			spawn(100*len69th(src.linkedServer.decryptkey)) Unma69Console()
			messa69e = rebootms69
			update_icon()
			return 1
		else
			to_chat(user, SPAN_NOTICE("A no server error appears on the screen."))

/obj/machinery/computer/messa69e_monitor/update_icon()
	if(ema69 || hackin69)
		icon_screen = hack_icon
	else
		icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/messa69e_monitor/Initialize()
	. = ..()
	//Is the server isn't linked to a server, and there's a server available, default it to the first one in the list.
	if(!linkedServer)
		if(messa69e_servers &&69essa69e_servers.len > 0)
			linkedServer =69essa69e_servers69169

/obj/machinery/computer/messa69e_monitor/attack_hand(var/mob/livin69/user as69ob)
	if(..())
		return
	if(!istype(user))
		return
	//If the computer is bein69 hacked or is ema6969ed, display the reboot69essa69e.
	if(hackin69 || ema69)
		messa69e = rebootms69
	var/dat = "<head><title>Messa69e69onitor Console</title></head><body>"
	dat += "<center><h2>Messa69e69onitor Console</h2></center><hr>"
	dat += "<center><h4><font color='blue'69messa69e69</h5></center>"

	if(auth)
		dat += "<h4><dd><A href='?src=\ref69src69;auth=1'>&#09;<font color='69reen'>\69Authenticated\69</font></a>&#09;/"
		dat += " Server Power: <A href='?src=\ref69src69;active=1'>69src.linkedServer && src.linkedServer.active ? "<font color='69reen'>\69On\69</font>":"<font color='red'>\69Off\69</font>"69</a></h4>"
	else
		dat += "<h4><dd><A href='?src=\ref69src69;auth=1'>&#09;<font color='red'>\69Unauthenticated\69</font></a>&#09;/"
		dat += " Server Power: <u>69src.linkedServer && src.linkedServer.active ? "<font color='69reen'>\69On\69</font>":"<font color='red'>\69Off\69</font>"69</u></h4>"

	if(hackin69 || ema69)
		screen = 2
	else if(!auth || !linkedServer || (linkedServer.stat & (NOPOWER|BROKEN)))
		if(!linkedServer || (linkedServer.stat & (NOPOWER|BROKEN)))69essa69e = noserver
		screen = 0

	switch(screen)
		//Main69enu
		if(0)
			//&#09; = TAB
			var/i = 0
			dat += "<dd><A href='?src=\ref69src69;find=1'>&#09;69++i69. Link To A Server</a></dd>"
			if(auth)
				if(!linkedServer || (linkedServer.stat & (NOPOWER|BROKEN)))
					dat += "<dd><A>&#09;ERROR: Server not found!</A><br></dd>"
				else
					dat += "<dd><A href='?src=\ref69src69;view=1'>&#09;69++i69.69iew69essa69e Lo69s </a><br></dd>"
					dat += "<dd><A href='?src=\ref69src69;viewr=1'>&#09;69++i69.69iew Re69uest Console Lo69s </a></br></dd>"
					dat += "<dd><A href='?src=\ref69src69;clear=1'>&#09;69++i69. Clear69essa69e Lo69s</a><br></dd>"
					dat += "<dd><A href='?src=\ref69src69;clearr=1'>&#09;69++i69. Clear Re69uest Console Lo69s</a><br></dd>"
					dat += "<dd><A href='?src=\ref69src69;pass=1'>&#09;69++i69. Set Custom Key</a><br></dd>"
					dat += "<dd><A href='?src=\ref69src69;ms69=1'>&#09;69++i69. Send Admin69essa69e</a><br></dd>"
					dat += "<dd><A href='?src=\ref69src69;spam=1'>&#09;69++i69.69odify Spam Filter</a><br></dd>"
			else
				for(var/n = ++i; n <= optioncount; n++)
					dat += "<dd><font color='blue'>&#09;69n69. ---------------</font><br></dd>"
			if((isAI(user) || isrobot(user)) && (user.mind.anta69onist.len && user.mind.ori69inal == user))
				//Malf/Contractor AIs can bruteforce into the system to 69ain the Key.
				dat += "<dd><A href='?src=\ref69src69;hack=1'><i><font color='Red'>*&@#. Bruteforce Key</font></i></font></a><br></dd>"
			else
				dat += "<br>"

			//Bottom69essa69e
			if(!auth)
				dat += "<br><hr><dd><span class='notice'>Please authenticate with the server in order to show additional options.</span>"
			else
				dat += "<br><hr><dd><span class='warnin69'>Re69, #514 forbids sendin6969essa69es to a Head of Staff containin69 Erotic Renderin69 Properties.</span>"

		//Messa69e Lo69s
		if(1)
			var/index = 0
			//var/recipient = "Unspecified" //name of the person
			//var/sender = "Unspecified" //name of the sender
			//var/messa69e = "Blank" //transferred69essa69e
			dat += "<center><A href='?src=\ref69src69;back=1'>Back</a> - <A href='?src=\ref69src69;refresh=1'>Refresh</center><hr>"
			dat += "<table border='1' width='100%'><tr><th width = '5%'>X</th><th width='15%'>Sender</th><th width='15%'>Recipient</th><th width='300px' word-wrap: break-word>Messa69e</th></tr>"
			for(var/datum/data_pda_ms69/pda in src.linkedServer.pda_ms69s)
				index++
				if(index > 3000)
					break
				// Del - Sender   - Recepient -69essa69e
				// X   - Al 69reen - Your69om  - WHAT UP!?
				dat += "<tr><td width = '5%'><center><A href='?src=\ref69src69;delete=\ref69pda69' style='color: r69b(255,0,0)'>X</a></center></td><td width='15%'>69pda.sender69</td><td width='15%'>69pda.recipient69</td><td width='300px'>69pda.messa69e69</td></tr>"
			dat += "</table>"
		//Hackin69 screen.
		if(2)
			if(isAI(user) || isrobot(user))
				dat += "Brute-forcin69 for server key.<br> It will take 20 seconds for every character that the password has."
				dat += "In the69eantime, this console can reveal your true intentions if you let someone access it.69ake sure no humans enter the room durin69 that time."
			else
				//It's the same69essa69e as the one above but in binary. Because robots understand binary and humans don't... well I thou69ht it was clever.
				dat += {"01000010011100100111010101110100011001010010110<br>
				10110011001101111011100100110001101101001011011100110011<br>
				10010000001100110011011110111001000100000011100110110010<br>
				10111001001110110011001010111001000100000011010110110010<br>
				10111100100101110001000000100100101110100001000000111011<br>
				10110100101101100011011000010000001110100011000010110101<br>
				10110010100100000001100100011000000100000011100110110010<br>
				10110001101101111011011100110010001110011001000000110011<br>
				00110111101110010001000000110010101110110011001010111001<br>
				00111100100100000011000110110100001100001011100100110000<br>
				10110001101110100011001010111001000100000011101000110100<br>
				00110000101110100001000000111010001101000011001010010000<br>
				00111000001100001011100110111001101110111011011110111001<br>
				00110010000100000011010000110000101110011001011100010000<br>
				00100100101101110001000000111010001101000011001010010000<br>
				00110110101100101011000010110111001110100011010010110110<br>
				10110010100101100001000000111010001101000011010010111001<br>
				10010000001100011011011110110111001110011011011110110110<br>
				00110010100100000011000110110000101101110001000000111001<br>
				00110010101110110011001010110000101101100001000000111100<br>
				10110111101110101011100100010000001110100011100100111010<br>
				10110010100100000011010010110111001110100011001010110111<br>
				00111010001101001011011110110111001110011001000000110100<br>
				10110011000100000011110010110111101110101001000000110110<br>
				00110010101110100001000000111001101101111011011010110010<br>
				10110111101101110011001010010000001100001011000110110001<br>
				10110010101110011011100110010000001101001011101000010111<br>
				00010000001001101011000010110101101100101001000000111001<br>
				10111010101110010011001010010000001101110011011110010000<br>
				00110100001110101011011010110000101101110011100110010000<br>
				00110010101101110011101000110010101110010001000000111010<br>
				00110100001100101001000000111001001101111011011110110110<br>
				10010000001100100011101010111001001101001011011100110011<br>
				10010000001110100011010000110000101110100001000000111010<br>
				001101001011011010110010100101110"}

		//Fake69essa69es
		if(3)
			dat += "<center><A href='?src=\ref69src69;back=1'>Back</a> - <A href='?src=\ref69src69;Reset=1'>Reset</a></center><hr>"

			dat += {"<table border='1' width='100%'>
					<tr><td width='20%'><A href='?src=\ref69src69;select=Sender'>Sender</a></td>
					<td width='20%'><A href='?src=\ref69src69;select=RecJob'>Sender's Job</a></td>
					<td width='20%'><A href='?src=\ref69src69;select=Recepient'>Recipient</a></td>
					<td width='300px' word-wrap: break-word><A href='?src=\ref69src69;select=Messa69e'>Messa69e</a></td></tr>"}
				//Sender  - Sender's Job  - Recepient -69essa69e
				//Al 69reen- Your Dad	  - Your69om  - WHAT UP!?

			dat += {"<tr><td width='20%'>69customsender69</td>
			<td width='20%'>69customjob69</td>
			<td width='20%'>69customrecepient ? customrecepient.owner : "NONE"69</td>
			<td width='300px'>69custommessa69e69</td></tr>"}
			dat += "</table><br><center><A href='?src=\ref69src69;select=Send'>Send</a></center>"

		//Re69uest Console Lo69s
		if(4)

			var/index = 0
			/* 	data_rc_ms69
				X												 - 5%
				var/rec_dpt = "Unspecified" //name of the person - 15%
				var/send_dpt = "Unspecified" //name of the sender- 15%
				var/messa69e = "Blank" //transferred69essa69e		 - 300px
				var/stamp = "Unstamped"							 - 15%
				var/id_auth = "Unauthenticated"					 - 15%
				var/priority = "Normal"							 - 10%
			*/
			dat += "<center><A href='?src=\ref69src69;back=1'>Back</a> - <A href='?src=\ref69src69;refresh=1'>Refresh</center><hr>"
			dat += {"<table border='1' width='100%'><tr><th width = '5%'>X</th><th width='15%'>Sendin69 Dep.</th><th width='15%'>Receivin69 Dep.</th>
			<th width='300px' word-wrap: break-word>Messa69e</th><th width='15%'>Stamp</th><th width='15%'>ID Auth.</th><th width='15%'>Priority.</th></tr>"}
			for(var/datum/data_rc_ms69/rc in src.linkedServer.rc_ms69s)
				index++
				if(index > 3000)
					break
				// Del - Sender   - Recepient -69essa69e
				// X   - Al 69reen - Your69om  - WHAT UP!?
				dat += {"<tr><td width = '5%'><center><A href='?src=\ref69src69;deleter=\ref69rc69' style='color: r69b(255,0,0)'>X</a></center></td><td width='15%'>69rc.send_dpt69</td>
				<td width='15%'>69rc.rec_dpt69</td><td width='300px'>69rc.messa69e69</td><td width='15%'>69rc.stamp69</td><td width='15%'>69rc.id_auth69</td><td width='15%'>69rc.priority69</td></tr>"}
			dat += "</table>"

		//Spam filter69odification
		if(5)
			dat += "<center><A href='?src=\ref69src69;back=1'>Back</a> - <A href='?src=\ref69src69;refresh=1'>Refresh</center><hr>"
			var/index = 0
			for(var/token in src.linkedServer.spamfilter)
				index++
				if(index > 3000)
					break
				dat += "<dd>69index69&#09; <a href='?src=\ref69src69;deltoken=69index69'>\6969token69\69</a><br></dd>"
			dat += "<hr>"
			if (linkedServer.spamfilter.len < linkedServer.spamfilter_limit)
				dat += "<a href='?src=\ref69src69;addtoken=1'>Add token</a><br>"


	dat += "</body>"
	messa69e = defaultms69
	user << browse(dat, "window=messa69e;size=700x700")
	onclose(user, "messa69e")
	return

/obj/machinery/computer/messa69e_monitor/proc/BruteForce(mob/user as69ob)
	if(isnull(linkedServer))
		to_chat(user, SPAN_WARNIN69("Could not complete brute-force: Linked Server Disconnected!"))
	else
		var/currentKey = src.linkedServer.decryptkey
		to_chat(user, SPAN_WARNIN69("Brute-force completed! The key is '69currentKey69'."))
	src.hackin69 = 0
	update_icon()
	src.screen = 0 // Return the screen back to normal

/obj/machinery/computer/messa69e_monitor/proc/Unma69Console()
	src.ema69 = 0
	update_icon()

/obj/machinery/computer/messa69e_monitor/proc/ResetMessa69e()
	customsender 	= "System Administrator"
	customrecepient = null
	custommessa69e 	= "This is a test, please i69nore."
	customjob 		= "Admin"

/obj/machinery/computer/messa69e_monitor/Topic(href, href_list)
	if(..())
		return 1
	if(stat & (NOPOWER|BROKEN))
		return
	if(!islivin69(usr))
		return
	if ((usr.contents.Find(src) || (in_ran69e(src, usr) && istype(src.loc, /turf))) || (issilicon(usr)))
		//Authenticate
		if (href_list69"auth"69)
			if(auth)
				auth = 0
				screen = 0
			else
				var/dkey = trim(input(usr, "Please enter the decryption key.") as text|null)
				if(dkey && dkey != "")
					if(src.linkedServer.decryptkey == dkey)
						auth = 1
					else
						messa69e = incorrectkey

		//Turn the server on/off.
		if (href_list69"active"69)
			if(auth) linkedServer.active = !linkedServer.active
		//Find a server
		if (href_list69"find"69)
			if(messa69e_servers &&69essa69e_servers.len > 1)
				src.linkedServer = input(usr,"Please select a server.", "Select a server.", null) as null|anythin69 in69essa69e_servers
				messa69e = "<span class='alert'>NOTICE: Server selected.</span>"
			else if(messa69e_servers &&69essa69e_servers.len > 0)
				linkedServer =69essa69e_servers69169
				messa69e =  SPAN_NOTICE("NOTICE: Only Sin69le Server Detected - Server selected.")
			else
				messa69e = noserver

		//View the lo69s - KEY RE69UIRED
		if (href_list69"view"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					src.screen = 1

		//Clears the lo69s - KEY RE69UIRED
		if (href_list69"clear"69)
			if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					src.linkedServer.pda_ms69s = list()
					messa69e = SPAN_NOTICE("NOTICE: Lo69s cleared.")
		//Clears the re69uest console lo69s - KEY RE69UIRED
		if (href_list69"clearr"69)
			if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					src.linkedServer.rc_ms69s = list()
					messa69e = SPAN_NOTICE("NOTICE: Lo69s cleared.")
		//Chan69e the password - KEY RE69UIRED
		if (href_list69"pass"69)
			if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					var/dkey = trim(input(usr, "Please enter the decryption key.") as text|null)
					if(dkey && dkey != "")
						if(src.linkedServer.decryptkey == dkey)
							var/newkey = trim(input(usr,"Please enter the new key (3 - 16 characters69ax):"))
							if(len69th(newkey) <= 3)
								messa69e = SPAN_NOTICE("NOTICE: Decryption key too short!")
							else if(len69th(newkey) > 16)
								messa69e = SPAN_NOTICE("NOTICE: Decryption key too lon69!")
							else if(newkey && newkey != "")
								src.linkedServer.decryptkey = newkey
							messa69e = SPAN_NOTICE("NOTICE: Decryption key set.")
						else
							messa69e = incorrectkey

		//Hack the Console to 69et the password
		if (href_list69"hack"69)
			if((isAI(usr) || isrobot(usr)) && (usr.mind.anta69onist.len && usr.mind.ori69inal == usr))
				src.hackin69 = 1
				src.screen = 2
				update_icon()
				//Time it takes to bruteforce is dependant on the password len69th.
				spawn(100*len69th(src.linkedServer.decryptkey))
					if(src && src.linkedServer && usr)
						BruteForce(usr)
		//Delete the lo69.
		if (href_list69"delete"69)
			//Are they on the69iew lo69s screen?
			if(screen == 1)
				if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
					messa69e = noserver
				else //if(istype(href_list69"delete"69, /datum/data_pda_ms69))
					src.linkedServer.pda_ms69s -= locate(href_list69"delete"69)
					messa69e = SPAN_NOTICE("NOTICE: Lo69 Deleted!")
		//Delete the re69uest console lo69.
		if (href_list69"deleter"69)
			//Are they on the69iew lo69s screen?
			if(screen == 4)
				if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
					messa69e = noserver
				else //if(istype(href_list69"delete"69, /datum/data_pda_ms69))
					src.linkedServer.rc_ms69s -= locate(href_list69"deleter"69)
					messa69e = SPAN_NOTICE("NOTICE: Lo69 Deleted!")
		//Create a custom69essa69e
		if (href_list69"ms69"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					src.screen = 3
		//Fake69essa69in69 selection - KEY RE69UIRED
		if (href_list69"select"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
				screen = 0
			else
				switch(href_list69"select"69)

					//Reset
					if("Reset")
						ResetMessa69e()

					//Select Your Name
					if("Sender")
						customsender 	= sanitize(input(usr, "Please enter the sender's name.") as text|null)

					//Select Receiver
					if("Recepient")
						//69et out list of69iable PDAs
						var/list/obj/item/device/pda/sendPDAs = list()
						for(var/obj/item/device/pda/P in PDAs)
							if(!P.owner || P.toff || P.hidden) continue
							sendPDAs += P
						if(PDAs && PDAs.len > 0)
							customrecepient = input(usr, "Select a PDA from the list.") as null|anythin69 in sortNames(sendPDAs)
						else
							customrecepient = null

					//Enter custom job
					if("RecJob")
						customjob	 	= sanitize(input(usr, "Please enter the sender's job.") as text|null)

					//Enter69essa69e
					if("Messa69e")
						custommessa69e	= input(usr, "Please enter your69essa69e.") as text|null
						custommessa69e	= sanitize(custommessa69e)

					//Send69essa69e
					if("Send")

						if(isnull(customsender) || customsender == "")
							customsender = "UNKNOWN"

						if(isnull(customrecepient))
							messa69e = SPAN_NOTICE("NOTICE: No recepient selected!")
							return src.attack_hand(usr)

						if(isnull(custommessa69e) || custommessa69e == "")
							messa69e = SPAN_NOTICE("NOTICE: No69essa69e entered!")
							return src.attack_hand(usr)

						var/obj/item/device/pda/PDARec
						for (var/obj/item/device/pda/P in PDAs)
							if (!P.owner || P.toff || P.hidden)	continue
							if(P.owner == customsender)
								PDARec = P
						//Sender isn't fakin69 as someone who exists
						if(isnull(PDARec))
							src.linkedServer.send_pda_messa69e("69customrecepient.owner69", "69customsender69","69custommessa69e69")
							customrecepient.new_messa69e(customsender, customsender, customjob, custommessa69e)
						//Sender is fakin69 as someone who exists
						else

							src.linkedServer.send_pda_messa69e("69customrecepient.owner69", "69PDARec.owner69","69custommessa69e69")
							customrecepient.tnote.Add(list(list("sent" = 0, "owner" = "69PDARec.owner69", "job" = "69customjob69", "messa69e" = "69custommessa69e69", "tar69et" ="\ref69PDARec69")))

							if(!customrecepient.conversations.Find("\ref69PDARec69"))
								customrecepient.conversations.Add("\ref69PDARec69")

							customrecepient.new_messa69e(PDARec, custommessa69e)
						//Finally..
						ResetMessa69e()

		//Re69uest Console Lo69s - KEY RE69UIRED
		if(href_list69"viewr"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					src.screen = 4

			//usr << href_list69"select"69

		if(href_list69"spam"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				if(auth)
					src.screen = 5

		if(href_list69"addtoken"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				src.linkedServer.spamfilter += input(usr,"Enter text you want to be filtered out","Token creation") as text|null

		if(href_list69"deltoken"69)
			if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				messa69e = noserver
			else
				var/tokennum = text2num(href_list69"deltoken"69)
				src.linkedServer.spamfilter.Cut(tokennum,tokennum+1)

		if (href_list69"back"69)
			src.screen = 0

	return src.attack_hand(usr)


/obj/item/paper/monitorkey
	//..()
	name = "Monitor Decryption Key"
	spawn_blacklisted = TRUE
	var/obj/machinery/messa69e_server/server

/obj/item/paper/monitorkey/New()
	..()
	spawn(10)
		if(messa69e_servers)
			for(var/obj/machinery/messa69e_server/server in69essa69e_servers)
				if(!isnull(server))
					if(!isnull(server.decryptkey))
						info = "<center><h2>Daily Key Reset</h2></center><br>The new69essa69e69onitor key is '69server.decryptkey69'.<br>Please keep this a secret and away from the clown.<br>If necessary, chan69e the password to a69ore secure one."
						info_links = info
						icon_state = "paper_words"
						break
