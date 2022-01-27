#define ERRORCODE_INVALID	1
#define ERRORCODE_NOFUNDS	2

/obj/machinery/computer/supplycomp
	name = "supply control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "tech_key"
	icon_screen = "supply"
	li69ht_color = COLOR_LI69HTIN69_ORAN69E_MACHINERY
	re69_access = list(access_car69o)
	circuit = /obj/item/electronics/circuitboard/supplycomp
	var/temp
	var/re69time = 0 //Cooldown for re69uisitions - 69uarxink
	var/last_viewed_69roup = "cate69ories"
	var/can_order_contraband = FALSE
	var/re69uestonly = FALSE
	var/contraband = FALSE
	var/hacked = FALSE

/obj/machinery/computer/supplycomp/attack_hand(mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNIN69("Access Denied."))
		return

	if(..())
		return
	user.set_machine(src)
	post_si69nal("supply")
	var/dat
	if (temp)
		dat = temp
	else
		var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
		if (shuttle)
			dat += "<BR><B>Supply shuttle</B><HR>"
			dat += "\nLocation: "

			if (shuttle.has_arrive_time())
				dat += "In transit (69shuttle.eta_minutes()6969ins.)"

			else if(shuttle.at_station())
				if (!shuttle.can_launch())
					dat += "Dockin69/Undockin69"
				else
					dat += "Vessel"
			else
				dat += "Away"

			dat += "<BR>"

			if(!re69uestonly)
				if(shuttle.can_launch())
					if(shuttle.at_station())
						dat += "<A href='?src=\ref69src69;send=1'>Send away</A>"
					else
						dat += "<A href='?src=\ref69src69;send=1'>Re69uest supply shuttle</A>"

				else if (shuttle.can_cancel())
					dat += "<A href='?src=\ref69src69;cancel_send=1'>Cancel re69uest</A>"
				else
					dat += "*Shuttle is busy*"
			dat += "<BR>\n<BR>"

		if(!re69uestonly)
			dat += "<HR>\n"
			dat += "<b>69uild Credits: 6969et_account_credits(department_accounts69DEPARTMENT_69UILD69)6969CREDS69</b><BR><BR>"

		dat += "<A href='?src=\ref69src69;order=cate69ories'>69re69uestonly ? "Re69uest" : "Order"69 items</A><BR>"

		if(!re69uestonly)
			dat += "<A href='?src=\ref69src69;viewmes=1'>View69essa69es</A><BR>"
			dat += "<A href='?src=\ref69src69;viewaccount=\ref69department_accounts69DEPARTMENT_69UILD6969'>View bankin69 data</A><BR>"

		dat += {"
		<A href='?src=\ref69src69;viewre69uests=1'>View re69uests</A><BR>
		<A href='?src=\ref69src69;vieworders=1'>View orders</A>"}


	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/supplycomp/ema69_act(remainin69_char69es,69ob/user)
	if(!hacked)
		to_chat(user, SPAN_NOTICE("Special supplies unlocked."))
		hacked = TRUE
		return TRUE

/obj/machinery/computer/supplycomp/Topic(href, href_list)
	var/datum/shuttle/autodock/ferry/supply/shuttle = SSsupply.shuttle
	if (!shuttle)
		lo69_world("## ERROR: Eek. The supply/shuttle datum is69issin69 somehow.")
		return
	if(..())
		return TRUE

	var/datum/money_account/supply_account = department_accounts69DEPARTMENT_69UILD69

	if(isturf(loc) && ( in_ran69e(src, usr) || issilicon(usr) ) )
		usr.set_machine(src)

	//Callin69 the shuttle
	if(href_list69"send"69)
		if(shuttle.at_station())
			if (shuttle.forbidden_atoms_check())
				temp = "For safety reasons the automated supply shuttle cannot transport live or69anisms, classified nuclear weaponry or homin69 beacons."
			else
				shuttle.launch(src)
				temp = "Initiatin69 launch se69uence. \69<span class='warnin69'><A href='?src=\ref69src69;force_send=1'>Force Launch</A></span>\69"
		else
			shuttle.launch(src)
			temp = "The supply shuttle has been called and will arrive in approximately 69round(SSsupply.movetime/600,1)6969inutes."
			post_si69nal("supply")
		temp += "<BR><BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"

	if(href_list69"viewmes"69)
		if(SSsupply.centcom_messa69e)
			temp += "Latest69essa69e: <BR><BR>"
			temp +=  SSsupply.centcom_messa69e
			temp += "<BR>"
		else
			temp += "Can not find any69essa69es from Commercial bar69e. <BR>"
		temp += "<BR><BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"

	if(href_list69"viewaccount"69)
		var/datum/money_account/account = locate(href_list69"viewaccount"69) in all_money_accounts
		if(!account)
			updateUsrDialo69()
			return

		temp = "<A href='?src=\ref69src69;mainmenu=1'>Main69enu</a><HR><BR>"

		temp += "<b>69account.69et_name()69</b><br>"
		temp += "Account number: #69account.account_number69<br>"
		temp += "Balance: 69num2text(account.money, 12)6969CREDS69<br>"

		temp += "<br><b>Transaction lo69s</b>"
		temp += "<table border=1 style='width:100%'>"
		temp += "<tr>"
		temp += "<td><b>Date</b></td>"
		temp += "<td><b>Time</b></td>"
		temp += "<td><b>Tar69et</b></td>"
		temp += "<td><b>Purpose</b></td>"
		temp += "<td><b>Value</b></td>"
		temp += "<td><b>Source terminal</b></td>"
		temp += "</tr>"
		for(var/datum/transaction/T in reverseList(account.transaction_lo69))
			temp += "<tr>"
			temp += "<td>69T.date69</td><td>69T.time69</td>"
			temp += "<td>69T.tar69et_name69</td><td>69T.purpose69</td>"
			temp += "<td>69num2text(T.amount,12)6969CREDS69</td>"
			temp += "<td>69T.source_terminal69</td>"
			temp += "</tr>"
		temp += "</table><br>"

		temp += "<A href='?src=\ref69src69;viewaccount=\ref69account69'>Refresh</A>"

	if (href_list69"force_send"69)
		shuttle.force_launch(src)

	if (href_list69"cancel_send"69)
		shuttle.cancel_launch(src)

	else if (href_list69"order"69)
		if(re69uestonly)
			temp = ""
		else
			temp = "<b>69uild Credits: 6969et_account_credits(supply_account)6969CREDS69</b><BR>"

		if(href_list69"order"69 == "cate69ories")
			//all_supply_69roups
			//Re69uest what?
			last_viewed_69roup = "cate69ories"
			temp += "<A href='?src=\ref69src69;mainmenu=1'>Main69enu</A><HR><BR>"
			temp += "<b>Select a cate69ory</b><BR><BR>"
			for(var/supply_69roup_name in all_supply_69roups )
				temp += "<A href='?src=\ref69src69;order=69supply_69roup_name69'>69supply_69roup_name69</A><BR>"
		else
			last_viewed_69roup = href_list69"order"69
			temp += "<A href='?src=\ref69src69;order=cate69ories'>Back to all cate69ories</A><HR><BR>"
			temp += "<b>Re69uest from: 69last_viewed_69roup69</b><BR><BR>"
			for(var/supply_name in SSsupply.supply_packs)
				var/datum/supply_pack/N = SSsupply.supply_packs69supply_name69
				if((N.hidden && !hacked) || (N.contraband && !can_order_contraband) || N.69roup != last_viewed_69roup)
					continue
				temp += "<A href='?src=\ref69src69;doorder=69supply_name69'>69supply_name69</A> Cost: 69N.cost69<BR>"
				//Have to send the type instead of a reference to the obj because it would 69et cau69ht by 69C

	else if (href_list69"doorder"69)
		if(world.time < re69time)
			for(var/mob/V in hearers(src))
				V.show_messa69e("<b>69src69</b>'s69onitor flashes, \"69world.time - re69time69 seconds remainin69 until another re69uisition form69ay be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_pack/P = SSsupply.supply_packs69href_list69"doorder"6969
		if(!istype(P))	return

		var/reason = sanitize(input(usr, "Reason:", "Why do you re69uire this item?","") as null|text)
		if(!reason || !CanUseTopic(usr))
			return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/livin69/carbon/human/H = usr
			idname = H.69et_authentification_name()
			idrank = H.69et_assi69nment()
		else if(issilicon(usr))
			idname = usr.real_name

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order(P, idname, idrank, null, reason)
		SSsupply.re69uestlist += O

		O.69enerateRe69uisition(loc)

		re69time = (world.time + 5) % 1e5

		temp = "Order re69uest placed.<BR>"
		temp += "<BR><A href='?src=\ref69src69;order=69last_viewed_69roup69'>Back</A> | <A href='?src=\ref69src69;mainmenu=1'>Main69enu</A>"
		if(!re69uestonly)
			temp += " | <A href='?src=\ref69src69;confirmorder=69O.id69'>Authorize Order</A>"

	else if(href_list69"confirmorder"69)
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list69"confirmorder"69)
		var/error = approve_order(ordernum)

		//An errorcode of 069eans success
		if (!error)
			temp = "Thanks for your order.<BR>"
		else if (error == ERRORCODE_NOFUNDS)
			temp = "Not enou69h credits.<BR>"
		else if (error == ERRORCODE_INVALID)
			temp = "Invalid Re69uest<br>"

		temp += "<BR><A href='?src=\ref69src69;viewre69uests=1'>Back</A> <A href='?src=\ref69src69;mainmenu=1'>Main69enu</A>"

	else if (href_list69"vieworders"69)
		temp = "Current approved orders: <BR><BR>"
		for(var/S in SSsupply.shoppin69list)
			var/datum/supply_order/SO = S
			temp += "#69SO.id69 - 69SO.object.name69 ordered by 69SO.orderer6969SO.reason ? " (69SO.reason69)":""69<BR>"// <A href='?src=\ref69src69;cancelorder=69S69'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"

	/*
	//Cancellin69 already authorised orders 69ets69essy, disabled for now
	//Just don't authorise it til you're sure
	else if (href_list69"cancelorder"69)
		var/datum/supply_order/remove_supply = href_list69"cancelorder"69
		SSsupply.re69uestlist -= remove_supply
		69et_supply_credits() += remove_supply.object.cost
		temp += "Canceled: 69remove_supply.object.name69<BR><BR><BR>"

		for(var/S in SSsupply.re69uestlist)
			var/datum/supply_order/SO = S
			temp += "69SO.object.name69 approved by 69SO.orderedby6969SO.comment ? " (69SO.comment69)":""69 <A href='?src=\ref69src69;cancelorder=69S69'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"
	*/

	else if (href_list69"viewre69uests"69)
		temp = "Current re69uests: <BR><BR>"
		for(var/S in SSsupply.re69uestlist)
			var/datum/supply_order/SO = S
			temp += "#69SO.id69 - 69SO.object.name69 re69uested by 69SO.orderer69 "
			if(!re69uestonly)
				temp += "<A href='?src=\ref69src69;confirmorder=69SO.id69'>Approve</A> "
			temp += "<A href='?src=\ref69src69;rre69=69SO.id69'>Remove</A><BR>"

		if(!re69uestonly)
			temp += "<BR><A href='?src=\ref69src69;clearre69=1'>Clear list</A>"
		temp += "<BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"

	else if (href_list69"rre69"69)
		var/ordernum = text2num(href_list69"rre69"69)
		temp = "Invalid Re69uest.<BR>"
		for (var/i in 1 to SSsupply.re69uestlist.len)
			var/datum/supply_order/SO = SSsupply.re69uestlist69i69
			if(SO.id == ordernum)
				SSsupply.re69uestlist.Cut(i,i+1)
				temp = "Re69uest removed.<BR>"
				break
		temp += "<BR><A href='?src=\ref69src69;viewre69uests=1'>Back</A> <A href='?src=\ref69src69;mainmenu=1'>Main69enu</A>"

	else if (href_list69"clearre69"69)
		SSsupply.re69uestlist.Cut()
		temp = "List cleared.<BR>"
		temp += "<BR><A href='?src=\ref69src69;mainmenu=1'>OK</A>"

	else if (href_list69"mainmenu"69)
		temp = null

	add_fin69erprint(usr)
	updateUsrDialo69()
	return

/obj/machinery/computer/supplycomp/proc/approve_order(ordernum)
	var/datum/supply_order/O
	for (var/i in 1 to SSsupply.re69uestlist.len)
		var/datum/supply_order/SO = SSsupply.re69uestlist69i69
		if(SO.id == ordernum)
			O = SO
			if (pay_for_order(O, src))
				SSsupply.re69uestlist.Cut(i,i+1)
				SSsupply.shoppin69list += O
				return 0

			else
				return ERRORCODE_NOFUNDS

/obj/machinery/computer/supplycomp/proc/post_si69nal(var/command)

	var/datum/radio_fre69uency/fre69uency = SSradio.return_fre69uency(1435)

	if(!fre69uency) return

	var/datum/si69nal/status_si69nal = new
	status_si69nal.source = src
	status_si69nal.transmission_method = 1
	status_si69nal.data69"command"69 = command

	fre69uency.post_si69nal(src, status_si69nal)

#undef ERRORCODE_INVALID
#undef ERRORCODE_NOFUNDS


/obj/machinery/computer/supplycomp/order
	name = "supply orderin69 console"
	icon_screen = "re69uest"
	circuit = /obj/item/electronics/circuitboard/ordercomp
	re69uestonly = TRUE
	re69_access = list()
