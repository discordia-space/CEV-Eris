/obj/item/cartrid69e
	name = "69eneric cartrid69e"
	desc = "A data cartrid69e for portable69icrocomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = ITEM_SIZE_TINY

	var/obj/item/radio/inte69rated/radio = null
	var/access_security = 0
	var/access_en69ine = 0
	var/access_atmos = 0
	var/access_moebius = 0
	var/access_clown = 0
	var/access_mime = 0
	var/access_janitor = 0
//	var/access_flora = 0
	var/access_rea69ent_scanner = 0
	var/access_remote_door = 0 // Control some blast doors remotely!!
	var/remote_door_id = ""
	var/access_status_display = 0
	var/access_69uartermaster = 0
	var/access_detonate_pda = 0
	var/access_hydroponics = 0
	var/char69es = 0
	var/mode
	var/menu
	var/datum/data/record/active1 //69eneral
	var/datum/data/record/active2 //Medical
	var/datum/data/record/active3 //Security
	var/selected_sensor // Power Sensor
	var/messa69e1	// used for status_displays
	var/messa69e2
	var/list/stored_data = list()

/obj/item/cartrid69e/en69ineerin69
	name = "\improper Power-ON cartrid69e"
	icon_state = "cart-e"
	access_en69ine = 1

/obj/item/cartrid69e/atmos
	name = "\improper BreatheDeep cartrid69e"
	icon_state = "cart-a"
	access_atmos = 1

/obj/item/cartrid69e/medical
	name = "\improper69ed-U cartrid69e"
	icon_state = "cart-m"
	access_moebius = 1

/obj/item/cartrid69e/chemistry
	name = "\improper ChemWhiz cartrid69e"
	icon_state = "cart-chem"
	access_rea69ent_scanner = 1

/obj/item/cartrid69e/security
	name = "\improper R.O.B.U.S.T. cartrid69e"
	icon_state = "cart-s"
	access_security = 1

/obj/item/cartrid69e/security/Initialize()
	radio = new /obj/item/radio/inte69rated/beepsky(src)
	. = ..()

/obj/item/cartrid69e/detective
	name = "\improper D.E.T.E.C.T. cartrid69e"
	icon_state = "cart-s"
	access_security = 1
	access_moebius = 1


/obj/item/cartrid69e/janitor
	name = "\improper CustodiPRO cartrid69e"
	desc = "The ultimate in clean-room desi69n."
	icon_state = "cart-j"
	access_janitor = 1

/obj/item/cartrid69e/lawyer
	name = "\improper P.R.O.V.E. cartrid69e"
	icon_state = "cart-s"
	access_security = 1

/obj/item/cartrid69e/clown
	name = "\improper Honkworks 5.0 cartrid69e"
	icon_state = "cart-clown"
	access_clown = 1
	char69es = 5

/obj/item/cartrid69e/mime
	name = "\improper 69estur-O 1000 cartrid69e"
	icon_state = "cart-mi"
	access_mime = 1
	char69es = 5
/*
/obj/item/cartrid69e/botanist
	name = "69reen Thumb694.20"
	icon_state = "cart-b"
	access_flora = 1
*/

/obj/item/cartrid69e/si69nal
	name = "69eneric si69naler cartrid69e"
	desc = "A data cartrid69e with an inte69rated radio si69naler69odule."
	var/69deled = 0

/obj/item/cartrid69e/si69nal/science
	name = "\improper Si69nal Ace 2 cartrid69e"
	desc = "Complete with inte69rated radio si69naler!"
	icon_state = "cart-tox"
	access_rea69ent_scanner = 1
	access_atmos = 1

/obj/item/cartrid69e/si69nal/Initialize()
	radio = new /obj/item/radio/inte69rated/si69nal(src)
	. = ..()

/obj/item/cartrid69e/si69nal/Destroy()
	69del(radio)
	. = ..()

/obj/item/cartrid69e/69uartermaster
	name = "\improper Asters 69uild Parts &69endors cartrid69e"
	desc = "Perfect for the 69uild69erchant on the 69o!"
	icon_state = "cart-69"
	access_69uartermaster = 1

/obj/item/cartrid69e/69uartermaster/Initialize()
	radio = new /obj/item/radio/inte69rated/mule(src)
	. = ..()

/obj/item/cartrid69e/head
	name = "\improper Easy-Record DELUXE"
	icon_state = "cart-h"
	access_status_display = 1

/obj/item/cartrid69e/hop
	name = "\improper HumanResources9001 cartrid69e"
	icon_state = "cart-h"
	access_status_display = 1
	access_69uartermaster = 1
	access_janitor = 1
	access_security = 1

/obj/item/cartrid69e/hop/Initialize()
	radio = new /obj/item/radio/inte69rated/mule(src)
	. = ..()

/obj/item/cartrid69e/hos
	name = "\improper R.O.B.U.S.T. DELUXE"
	icon_state = "cart-hos"
	access_status_display = 1
	access_security = 1

/obj/item/cartrid69e/hos/Initialize()
	radio = new /obj/item/radio/inte69rated/beepsky(src)
	. = ..()

/obj/item/cartrid69e/ce
	name = "\improper Power-On DELUXE"
	icon_state = "cart-ce"
	access_status_display = 1
	access_en69ine = 1
	access_atmos = 1

/obj/item/cartrid69e/cmo
	name = "\improper69ed-U DELUXE"
	icon_state = "cart-cmo"
	access_status_display = 1
	access_rea69ent_scanner = 1
	access_moebius = 1

/obj/item/cartrid69e/rd
	name = "\improper Si69nal Ace DELUXE"
	icon_state = "cart-rd"
	access_status_display = 1
	access_rea69ent_scanner = 1
	access_atmos = 1

/obj/item/cartrid69e/rd/Initialize()
	radio = new /obj/item/radio/inte69rated/si69nal(src)
	. = ..()

/obj/item/cartrid69e/captain
	name = "\improper69alue-PAK cartrid69e"
	desc = "Now with 200%69ore69alue!"
	icon_state = "cart-c"
	access_69uartermaster = 1
	access_janitor = 1
	access_en69ine = 1
	access_security = 1
	access_moebius = 1
	access_rea69ent_scanner = 1
	access_status_display = 1
	access_atmos = 1

/obj/item/cartrid69e/syndicate
	name = "\improper Detomatix cartrid69e"
	icon_state = "cart"
	access_remote_door = 1
	access_detonate_pda = 1
	remote_door_id = "smindicate" //Make sure this69atches the syndicate shuttle's shield/door id!!	//don't ask about the name, testin69.
	char69es = 4

/obj/item/cartrid69e/proc/post_status(var/command,69ar/data1,69ar/data2)

	var/datum/radio_fre69uency/fre69uency = SSradio.return_fre69uency(1435)
	if(!fre69uency) return

	var/datum/si69nal/status_si69nal = new
	status_si69nal.source = src
	status_si69nal.transmission_method = 1
	status_si69nal.data69"command"69 = command

	switch(command)
		if("messa69e")
			status_si69nal.data69"ms691"69 = data1
			status_si69nal.data69"ms692"69 = data2
			if(loc)
				var/obj/item/PDA = loc
				var/mob/user = PDA.fin69erprintslast
				if(islivin69(PDA.loc))
					name = PDA.loc
				lo69_admin("STATUS: 69user69 set status screen with 69PDA69.69essa69e: 69data169 69data269")
				messa69e_admins("STATUS: 69user69 set status screen with 69PDA69.69essa69e: 69data169 69data269")

		if("alert")
			status_si69nal.data69"picture_state"69 = data1

	fre69uency.post_si69nal(src, status_si69nal)


/*
	This 69enerates the nano69alues of the cart69enus.
	Because we close the UI when we insert a new cart
	we don't have to worry about null69alues on items
	the user can't access.  Well, unless they are href hackin69.
	But in that case their UI will just lock up.
*/


/obj/item/cartrid69e/proc/create_NanoUI_values(mob/user as69ob)
	var/values69069

	/*		Si69naler (Mode: 40)				*/


	if(istype(radio,/obj/item/radio/inte69rated/si69nal) && (mode==40))
		var/obj/item/radio/inte69rated/si69nal/R = radio
		values69"si69nal_fre69"69 = format_fre69uency(R.fre69uency)
		values69"si69nal_code"69 = R.code


	/*		Station Display (Mode: 42)			*/

	if(mode==42)
		values69"messa69e1"69 =69essa69e1 ?69essa69e1 : "(none)"
		values69"messa69e2"69 =69essa69e2 ?69essa69e2 : "(none)"



	/*		Power69onitor (Mode: 43 / 433)			*/

	if(mode==43 ||69ode==433)
		var/list/sensors = list()
		var/obj/machinery/power/sensor/MS = null

		for(var/obj/machinery/power/sensor/S in 69LOB.machines)
			sensors.Add(list(list("name_ta69" = S.name_ta69)))
			if(S.name_ta69 == selected_sensor)
				MS = S
		values69"power_sensors"69 = sensors
		if(selected_sensor &&69S)
			values69"sensor_readin69"69 =69S.return_readin69_data()


	/*		69eneral Records (Mode: 44 / 441 / 45 / 451)	*/
	if(mode == 44 ||69ode == 441 ||69ode == 45 ||69ode ==451)
		if(istype(active1, /datum/data/record) && (active1 in data_core.69eneral))
			values69"69eneral"69 = active1.fields
			values69"69eneral_exists"69 = 1

		else
			values69"69eneral_exists"69 = 0



	/*		Medical Records (Mode: 44 / 441)	*/

	if(mode == 44 ||69ode == 441)
		var/medData69069
		for(var/datum/data/record/R in sortRecord(data_core.69eneral))
			medData69++medData.len69 = list(Name = R.fields69"name"69,"ref" = "\ref69R69")
		values69"medical_records"69 =69edData

		if(istype(active2, /datum/data/record) && (active2 in data_core.medical))
			values69"medical"69 = active2.fields
			values69"medical_exists"69 = 1
		else
			values69"medical_exists"69 = 0

	/*		Security Records (Mode:45 / 451)	*/

	if(mode == 45 ||69ode == 451)
		var/secData69069
		for (var/datum/data/record/R in sortRecord(data_core.69eneral))
			secData69++secData.len69 = list(Name = R.fields69"name"69, "ref" = "\ref69R69")
		values69"security_records"69 = secData

		if(istype(active3, /datum/data/record) && (active3 in data_core.security))
			values69"security"69 = active3.fields
			values69"security_exists"69 = 1
		else
			values69"security_exists"69 = 0

	/*		Security Bot Control (Mode: 46)		*/

	if(mode==46)
		var/botsData69069
		var/beepskyData69069
		if(istype(radio,/obj/item/radio/inte69rated/beepsky))
			var/obj/item/radio/inte69rated/beepsky/SC = radio
			beepskyData69"active"69 = SC.active
			if(SC.active && !isnull(SC.botstatus))
				var/area/loca = SC.botstatus69"loca"69
				var/loca_name = sanitize(loca.name)
				beepskyData69"botstatus"69 = list("loca" = loca_name, "mode" = SC.botstatus69"mode"69)
			else
				beepskyData69"botstatus"69 = list("loca" = null, "mode" = -1)
			var/botsCount=0
			if(SC.botlist && SC.botlist.len)
				for(var/mob/livin69/bot/B in SC.botlist)
					botsCount++
					if(B.loc)
						botsData69++botsData.len69 = list("Name" = sanitize(B.name), "Location" = sanitize(B.loc.loc.name), "ref" = "\ref69B69")

			if(!botsData.len)
				botsData69++botsData.len69 = list("Name" = "No bots found", "Location" = "Invalid", "ref"= null)

			beepskyData69"bots"69 = botsData
			beepskyData69"count"69 = botsCount

		else
			beepskyData69"active"69 = 0
			botsData69++botsData.len69 = list("Name" = "No bots found", "Location" = "Invalid", "ref"= null)
			beepskyData69"botstatus"69 = list("loca" = null, "mode" = null)
			beepskyData69"bots"69 = botsData
			beepskyData69"count"69 = 0

		values69"beepsky"69 = beepskyData


	/*		MULEBOT Control	(Mode: 48)		*/

	if(mode==48)
		var/muleData69069
		var/mulebotsData69069
		if(istype(radio,/obj/item/radio/inte69rated/mule))
			var/obj/item/radio/inte69rated/mule/69C = radio
			muleData69"active"69 = 69C.active
			if(69C.active && !isnull(69C.botstatus))
				var/area/loca = 69C.botstatus69"loca"69
				var/loca_name = sanitize(loca.name)
				muleData69"botstatus"69 =  list("loca" = loca_name, "mode" = 69C.botstatus69"mode"69,"home"=69C.botstatus69"home"69,"powr" = 69C.botstatus69"powr"69,"retn" =69C.botstatus69"retn"69, "pick"=69C.botstatus69"pick"69, "load" = 69C.botstatus69"load"69, "dest" = sanitize(69C.botstatus69"dest"69))

			else
				muleData69"botstatus"69 = list("loca" = null, "mode" = -1,"home"=null,"powr" = null,"retn" =null, "pick"=null, "load" = null, "dest" = null)


			var/mulebotsCount=0
			for(var/obj/machinery/bot/B in 69C.botlist)
				mulebotsCount++
				if(B.loc)
					mulebotsData69++mulebotsData.len69 = list("Name" = sanitize(B.name), "Location" = sanitize(B.loc.loc.name), "ref" = "\ref69B69")

			if(!mulebotsData.len)
				mulebotsData69++mulebotsData.len69 = list("Name" = "No bots found", "Location" = "Invalid", "ref"= null)

			muleData69"bots"69 =69ulebotsData
			muleData69"count"69 =69ulebotsCount

		else
			muleData69"botstatus"69 =  list("loca" = null, "mode" = -1,"home"=null,"powr" = null,"retn" =null, "pick"=null, "load" = null, "dest" = null)
			muleData69"active"69 = 0
			mulebotsData69++mulebotsData.len69 = list("Name" = "No bots found", "Location" = "Invalid", "ref"= null)
			muleData69"bots"69 =69ulebotsData
			muleData69"count"69 = 0

		values69"mulebot"69 =69uleData



	/*	Supply Shuttle Re69uests69enu (Mode: 47)		*/

	if(mode==47)
		var/supplyData69069
		var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
		if (shuttle)
			supplyData69"shuttle_movin69"69 = shuttle.has_arrive_time()
			supplyData69"shuttle_eta"69 = shuttle.eta_minutes()
			supplyData69"shuttle_loc"69 = shuttle.at_station() ? "Station" : "Dock"
		var/supplyOrderCount = 0
		var/supplyOrderData69069
		for(var/S in SSsupply.shoppin69list)
			var/datum/supply_order/SO = S

			supplyOrderData69++supplyOrderData.len69 = list("Number" = SO.id, "Name" = html_encode(SO.object.name), "ApprovedBy" = SO.orderer, "Comment" = html_encode(SO.reason))
		if(!supplyOrderData.len)
			supplyOrderData69++supplyOrderData.len69 = list("Number" = null, "Name" = null, "OrderedBy"=null)

		supplyData69"approved"69 = supplyOrderData
		supplyData69"approved_count"69 = supplyOrderCount

		var/re69uestCount = 0
		var/re69uestData69069
		for(var/S in SSsupply.re69uestlist)
			var/datum/supply_order/SO = S
			re69uestCount++
			re69uestData69++re69uestData.len69 = list("Number" = SO.id, "Name" = html_encode(SO.object.name), "OrderedBy" = SO.orderer, "Comment" = html_encode(SO.reason))
		if(!re69uestData.len)
			re69uestData69++re69uestData.len69 = list("Number" = null, "Name" = null, "orderedBy" = null, "Comment" = null)

		supplyData69"re69uests"69 = re69uestData
		supplyData69"re69uests_count"69 = re69uestCount


		values69"supply"69 = supplyData



	/* 	Janitor Supplies Locator  (Mode: 49)      */
	if(mode==49)
		var/JaniData69069
		var/turf/cl = 69et_turf(src)

		if(cl)
			JaniData69"user_loc"69 = list("x" = cl.x, "y" = cl.y)
		else
			JaniData69"user_loc"69 = list("x" = 0, "y" = 0)
		var/MopData69069
		for(var/obj/item/mop/M in world)
			var/turf/ml = 69et_turf(M)
			if(ml)
				if(ml.z != cl.z)
					continue
				var/direction = 69et_dir(src,69)
				MopData69++MopData.len69 = list ("x" =69l.x, "y" =69l.y, "dir" = uppertext(dir2text(direction)), "status" =69.rea69ents.total_volume ? "Wet" : "Dry")

		if(!MopData.len)
			MopData69++MopData.len69 = list("x" = 0, "y" = 0, dir=null, status = null)


		var/BucketData69069
		for(var/obj/structure/mopbucket/B in world)
			var/turf/bl = 69et_turf(B)
			if(bl)
				if(bl.z != cl.z)
					continue
				var/direction = 69et_dir(src,B)
				BucketData69++BucketData.len69 = list ("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.rea69ents.total_volume/100)

		if(!BucketData.len)
			BucketData69++BucketData.len69 = list("x" = 0, "y" = 0, dir=null, status = null)

		var/CbotData69069
		for(var/mob/livin69/bot/cleanbot/B in world)
			var/turf/bl = 69et_turf(B)
			if(bl)
				if(bl.z != cl.z)
					continue
				var/direction = 69et_dir(src,B)
				CbotData69++CbotData.len69 = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.on ? "Online" : "Offline")


		if(!CbotData.len)
			CbotData69++CbotData.len69 = list("x" = 0, "y" = 0, dir=null, status = null)
		var/CartData69069
		for(var/obj/structure/janitorialcart/B in world)
			var/turf/bl = 69et_turf(B)
			if(bl)
				if(bl.z != cl.z)
					continue
				var/direction = 69et_dir(src,B)
				CartData69++CartData.len69 = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.rea69ents.total_volume/100)
		if(!CartData.len)
			CartData69++CartData.len69 = list("x" = 0, "y" = 0, dir=null, status = null)




		JaniData69"mops"69 =69opData
		JaniData69"buckets"69 = BucketData
		JaniData69"cleanbots"69 = CbotData
		JaniData69"carts"69 = CartData
		values69"janitor"69 = JaniData

	return69alues





/obj/item/cartrid69e/Topic(href, href_list)
	..()

	if (!usr.canmove || usr.stat || usr.restrained() || !in_ran69e(loc, usr))
		usr.unset_machine()
		usr << browse(null, "window=pda")
		return




	switch(href_list69"choice"69)
		if("Medical Records")
			var/datum/data/record/R = locate(href_list69"tar69et"69)
			var/datum/data/record/M = locate(href_list69"tar69et"69)
			loc:mode = 441
			mode = 441
			if (R in data_core.69eneral)
				for (var/datum/data/record/E in data_core.medical)
					if ((E.fields69"name"69 == R.fields69"name"69 || E.fields69"id"69 == R.fields69"id"69))
						M = E
						break
				active1 = R
				active2 =69

		if("Security Records")
			var/datum/data/record/R = locate(href_list69"tar69et"69)
			var/datum/data/record/S = locate(href_list69"tar69et"69)
			loc:mode = 451
			mode = 451
			if (R in data_core.69eneral)
				for (var/datum/data/record/E in data_core.security)
					if ((E.fields69"name"69 == R.fields69"name"69 || E.fields69"id"69 == R.fields69"id"69))
						S = E
						break
				active1 = R
				active3 = S

		if("Send Si69nal")
			spawn( 0 )
				radio:send_si69nal("ACTIVATE")
				return

		if("Si69nal Fre69uency")
			var/new_fre69uency = sanitize_fre69uency(radio:fre69uency + text2num(href_list69"sfre69"69))
			radio:set_fre69uency(new_fre69uency)

		if("Si69nal Code")
			radio:code += text2num(href_list69"scode"69)
			radio:code = round(radio:code)
			radio:code =69in(100, radio:code)
			radio:code =69ax(1, radio:code)

		if("Status")
			switch(href_list69"statdisp"69)
				if("messa69e")
					post_status("messa69e",69essa69e1,69essa69e2)
				if("alert")
					post_status("alert", href_list69"alert"69)
				if("setms691")
					messa69e1 = reject_bad_text(sanitize(input("Line 1", "Enter69essa69e Text",69essa69e1) as text|null, 40), 40)
					updateSelfDialo69()
				if("setms692")
					messa69e2 = reject_bad_text(sanitize(input("Line 2", "Enter69essa69e Text",69essa69e2) as text|null, 40), 40)
					updateSelfDialo69()
				else
					post_status(href_list69"statdisp"69)

		if("Power Select")
			selected_sensor = href_list69"tar69et"69
			loc:mode = 433
			mode = 433
		if("Power Clear")
			selected_sensor = null
			loc:mode = 43
			mode = 43


	return 1
