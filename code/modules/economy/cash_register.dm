/obj/machinery/cash_register
	name = "cash register"
	desc = "Swipe your ID card to69ake purchases electronically."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "register_idle"
	flags = NOBLUDGEON
	req_access = list()
	anchored = TRUE

	var/locked = 1
	var/cash_locked = 1
	var/cash_open = 0
	var/machine_id = ""
	var/transaction_amount = 0 // cumulatd amount of69oney to pay in a single purchase
	var/transaction_purpose = null // text that gets used in ATM transaction logs
	var/list/transaction_logs = list() // list of strings using html code to69isualise data
	var/list/item_list = list()  // entities and according
	var/list/price_list = list() // prices for each purchase
	var/manipulating = 0
	var/pin_code = null

	var/cash_stored = 0
	var/obj/item/confirm_item
	var/datum/money_account/linked_account
	var/account_to_connect = null


// Claim69achine ID
/obj/machinery/cash_register/New()
	. = ..()
	machine_id = "69station_name()69 RETAIL #69num_financial_terminals++69"
	cash_stored = rand(10, 70)*10
	transaction_devices += src // Global reference list to be properly set up by /proc/setup_economy()


/obj/machinery/cash_register/examine(mob/user)
	..(user)
	if(cash_open)
		if(cash_stored)
			to_chat(user, "It holds 69cash_stored69 Credit\s of69oney.")
		else
			to_chat(user, "It's completely empty.")


/obj/machinery/cash_register/attack_hand(mob/user as69ob)
	// Don't be accessible from the wrong side of the69achine
	if(get_dir(src, user) & reverse_dir69src.dir69) return

	if(cash_open)
		if(cash_stored)
			spawn_money(cash_stored, loc, user)
			cash_stored = 0
			overlays -= "register_cash"
		else
			open_cash_box()
	else
		user.set_machine(src)
		interact(user)

/obj/machinery/cash_register/AltClick(mob/user)
	if(Adjacent(user))
		open_cash_box()


/obj/machinery/cash_register/interact(mob/user as69ob)
	var/dat = "<h2>Cash Register<hr></h2>"
	if (locked)
		dat += "<a href='?src=\ref69src69;choice=toggle_lock'>Unlock</a><br>"
		dat += "Linked account: <b>69linked_account ? linked_account.owner_name : "None"69</b><br>"
		dat += "<b>69cash_locked? "Unlock" : "Lock"69 Cash Box</b> | "
	else
		dat += "<a href='?src=\ref69src69;choice=toggle_lock'>Lock</a><br>"
		dat += "Linked account: <a href='?src=\ref69src69;choice=link_account'>69linked_account ? linked_account.owner_name : "None"69</a><br>"
		dat += "<a href='?src=\ref69src69;choice=toggle_cash_lock'>69cash_locked? "Unlock" : "Lock"69 Cash Box</a> | "
	dat += "<a href='?src=\ref69src69;choice=custom_order'>Custom Order</a><hr>"

	if(item_list.len)
		dat += get_current_transaction()
		dat += "<br>"

	for(var/i=transaction_logs.len, i>=1, i--)
		dat += "69transaction_logs69i6969<br>"

	if(transaction_logs.len)
		dat += locked ? "<br>" : "<a href='?src=\ref69src69;choice=reset_log'>Reset Log</a><br>"
		dat += "<br>"
	dat += "<i>Device ID:</i> 69machine_id69"
	user << browse(dat, "window=cash_register;size=350x500")
	onclose(user, "cash_register")


/obj/machinery/cash_register/Topic(var/href,69ar/href_list)
	if(..())
		return

	usr.set_machine(src)

	if(href_list69"choice"69)
		switch(href_list69"choice"69)
			if("toggle_lock")
				if(pin_code == null)
					pin_code = input("Please set a lock code") as num
				if(locked == 1)
					if(pin_code != null)
						var/try_pin = input("Cash register lock code") as num
						if(try_pin == pin_code)
							locked = !locked
						else
							to_chat(usr, "\icon69src69<span class='warning'>Insufficient access.</span>")
				else
					locked = !locked
					to_chat(usr, "You lock cash register.")
			if("toggle_cash_lock")
				cash_locked = !cash_locked
			if("link_account")
				var/attempt_account_num = input("Enter account number", "New account number") as num
				var/attempt_pin = input("Enter PIN", "Account PIN") as num
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, 2)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						src.visible_message("\icon69src69<span class='warning'>Account has been suspended.</span>")
				else
					to_chat(usr, "\icon69src69<span class='warning'>Account not found.</span>")
			if("custom_order")
				var/t_purpose = sanitize(input("Enter purpose", "New purpose") as text)
				if (!t_purpose || !Adjacent(usr)) return
				transaction_purpose = t_purpose
				item_list += t_purpose
				var/t_amount = round(input("Enter price", "New price") as num)
				if (!t_amount || !Adjacent(usr)) return
				transaction_amount += t_amount
				price_list += t_amount
				playsound(src, 'sound/machines/twobeep.ogg', 25)
				src.visible_message("\icon69src6969transaction_purpose69: 69t_amount69 Credit\s.")
			if("set_amount")
				var/item_name = locate(href_list69"item"69)
				var/n_amount = round(input("Enter amount", "New amount") as num)
				n_amount = CLAMP(n_amount, 0, 20)
				if (!item_list69item_name69 || !Adjacent(usr)) return
				transaction_amount += (n_amount - item_list69item_name69) * price_list69item_name69
				if(!n_amount)
					item_list -= item_name
					price_list -= item_name
				else
					item_list69item_name69 = n_amount
			if("subtract")
				var/item_name = locate(href_list69"item"69)
				if(item_name)
					transaction_amount -= price_list69item_name69
					item_list69item_name69--
					if(item_list69item_name69 <= 0)
						item_list -= item_name
						price_list -= item_name
			if("add")
				var/item_name = locate(href_list69"item"69)
				if(item_list69item_name69 >= 20) return
				transaction_amount += price_list69item_name69
				item_list69item_name69++
			if("clear")
				var/item_name = locate(href_list69"item"69)
				if(item_name)
					transaction_amount -= price_list69item_name69 * item_list69item_name69
					item_list -= item_name
					price_list -= item_name
				else
					transaction_amount = 0
					item_list.Cut()
					price_list.Cut()
			if("reset_log")
				transaction_logs.Cut()
				to_chat(usr, "\icon69src69<span class='notice'>Transaction log reset.</span>")
	updateDialog()



/obj/machinery/cash_register/attackby(obj/O as obj, user as69ob)
	// Check for a69ethod of paying (ID, PDA, e-wallet, cash, ect.)
	var/obj/item/card/id/I = O.GetIdCard()
	if(I)
		scan_card(I, O)
	else if (istype(O, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = O
		scan_wallet(E)
	else if (istype(O, /obj/item/spacecash))
		var/obj/item/spacecash/SC = O
		if(cash_open)
			to_chat(user, "You neatly sort the cash into the box.")
			cash_stored += SC.worth
			overlays |= "register_cash"
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.drop_from_inventory(SC)
			qdel(SC)
		else
			scan_cash(SC)
	else if(istype(O, /obj/item/card/emag))
		return ..()
	else if(istype(O, /obj/item/tool/wrench))
		var/obj/item/tool/wrench/W = O
		toggle_anchors(W, user)
	// Not paying: Look up price and add it to transaction_amount
	else
		scan_item_price(O)


/obj/machinery/cash_register/MouseDrop_T(atom/dropping,69ob/user)
	if(Adjacent(dropping) && Adjacent(user) && !user.stat)
		attackby(dropping, user)


/obj/machinery/cash_register/proc/confirm(obj/item/I)
	if(confirm_item == I)
		return 1
	else
		confirm_item = I
		src.visible_message("\icon69src69<b>Total price:</b> 69transaction_amount69 Credit\s. Swipe again to confirm.")
		playsound(src, 'sound/machines/twobeep.ogg', 25)
		return 0


/obj/machinery/cash_register/proc/scan_card(obj/item/card/id/I, obj/item/ID_container)
	if (!transaction_amount)
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(usr, "\icon69src69<span class='warning'>The cash box is open.</span>")
		return

	if((item_list.len > 1 || item_list69item_list6916969 > 1) && !confirm(I))
		return

	if (!linked_account)
		usr.visible_message("\icon69src69<span class='warning'>Unable to connect to linked account.</span>")
		return

	// Access account for transaction
	if(check_account())
		var/datum/money_account/D = get_account(I.associated_account_number)
		var/attempt_pin = ""
		if(D && D.security_level)
			attempt_pin = input("Enter PIN", "Transaction") as num
			D = null
		D = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!D)
			src.visible_message("\icon69src69<span class='warning'>Unable to access account. Check security settings and try again.</span>")
		else
			if(D.suspended)
				src.visible_message("\icon69src69<span class='warning'>Your account has been suspended.</span>")
			else
				if(transaction_amount > D.money)
					src.visible_message("\icon69src69<span class='warning'>Not enough funds.</span>")
				else
					// Transfer the69oney
					D.money -= transaction_amount
					linked_account.money += transaction_amount

					// Create log entry in client's account
					var/datum/transaction/T = new()
					T.target_name = "69linked_account.owner_name69"
					T.purpose = transaction_purpose
					T.amount = "(69transaction_amount69)"
					T.source_terminal =69achine_id
					T.date = current_date_string
					T.time = stationtime2text()
					D.transaction_log.Add(T)

					// Create log entry in owner's account
					T = new()
					T.target_name = D.owner_name
					T.purpose = transaction_purpose
					T.amount = "69transaction_amount69"
					T.source_terminal =69achine_id
					T.date = current_date_string
					T.time = stationtime2text()
					linked_account.transaction_log.Add(T)

					// Save log
					add_transaction_log(I.registered_name ? I.registered_name : "n/A", "ID Card", transaction_amount)

					// Confirm and reset
					transaction_complete()


/obj/machinery/cash_register/proc/scan_wallet(obj/item/spacecash/ewallet/E)
	if (!transaction_amount)
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(usr, "\icon69src69<span class='warning'>The cash box is open.</span>")
		return

	if((item_list.len > 1 || item_list69item_list6916969 > 1) && !confirm(E))
		return

	// Access account for transaction
	if(check_account())
		if(transaction_amount > E.worth)
			src.visible_message("\icon69src69<span class='warning'>Not enough funds.</span>")
		else
			// Transfer the69oney
			E.worth -= transaction_amount
			linked_account.money += transaction_amount

			// Create log entry in owner's account
			var/datum/transaction/T = new()
			T.target_name = E.owner_name
			T.purpose = transaction_purpose
			T.amount = "69transaction_amount69"
			T.source_terminal =69achine_id
			T.date = current_date_string
			T.time = stationtime2text()
			linked_account.transaction_log.Add(T)

			// Save log
			add_transaction_log(E.owner_name, "E-Wallet", transaction_amount)

			// Confirm and reset
			transaction_complete()


/obj/machinery/cash_register/proc/scan_cash(obj/item/spacecash/SC)
	if (!transaction_amount)
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(usr, "\icon69src69<span class='warning'>The cash box is open.</span>")
		return

	if((item_list.len > 1 || item_list69item_list6916969 > 1) && !confirm(SC))
		return

	if(transaction_amount > SC.worth)
		src.visible_message("\icon69src69<span class='warning'>Not enough69oney.</span>")
	else
		// Insert cash into69agical slot
		SC.worth -= transaction_amount
		SC.update_icon()
		if(!SC.worth)
			if(ishuman(SC.loc))
				var/mob/living/carbon/human/H = SC.loc
				H.drop_from_inventory(SC)
			qdel(SC)
		cash_stored += transaction_amount

		// Save log
		add_transaction_log("n/A", "Cash", transaction_amount)

		// Confirm and reset
		transaction_complete()


/obj/machinery/cash_register/proc/scan_item_price(obj/O)
	if(!istype(O))	return
	if(item_list.len > 10)
		src.visible_message("\icon69src69<span class='warning'>Only up to ten different items allowed per purchase.</span>")
		return
	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		to_chat(usr, "\icon69src69<span class='warning'>The cash box is open.</span>")
		return

	// First check if item has a69alid price
	var/price = O.get_item_cost()
	if(isnull(price))
		src.visible_message("\icon69src69<span class='warning'>Unable to find item in database.</span>")
		return
	// Call out item cost
	src.visible_message("\icon69src69\A 69O69: 69price ? "69price69 Credit\s" : "free of charge"69.")
	// Note the transaction purpose for later use
	if(transaction_purpose)
		transaction_purpose += "<br>"
	transaction_purpose += "69O69: 69price69 Credit\s"
	transaction_amount += price
	for(var/previously_scanned in item_list)
		if(price == price_list69previously_scanned69 && O.name == previously_scanned)
			. = item_list69previously_scanned69++
	if(!.)
		item_list69O.name69 = 1
		price_list69O.name69 = price
		. = 1
	// Animation and sound
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	// Reset confirmation
	confirm_item = null
	updateDialog()


/obj/machinery/cash_register/proc/get_current_transaction()
	var/dat = {"
	<head><style>
		.tx-title-r {text-align: center; background-color:#ffdddd; font-weight: bold}
		.tx-name-r {background-color: #eebbbb}
		.tx-data-r {text-align: right; background-color: #ffcccc;}
	</head></style>
	<table width=300>
	<tr><td colspan="2" class="tx-title-r">New Entry</td></tr>
	<tr></tr>"}
	var/item_name
	for(var/i=1, i<=item_list.len, i++)
		item_name = item_list69i69
		dat += "<tr><td class=\"tx-name-r\">69item_list69item_name69 ? "<a href='?src=\ref69src69;choice=subtract;item=\ref69item_name69'>-</a> <a href='?src=\ref69src69;choice=set_amount;item=\ref69item_name69'>Set</a> <a href='?src=\ref69src69;choice=add;item=\ref69item_name69'>+</a> 69item_list69item_name6969 x " : ""6969item_name69 <a href='?src=\ref69src69;choice=clear;item=\ref69item_name69'>Remove</a></td><td class=\"tx-data-r\" width=50>69price_list69item_name69 * item_list69item_name6969 &thorn</td></tr>"
	dat += "</table><table width=300>"
	dat += "<tr><td class=\"tx-name-r\"><a href='?src=\ref69src69;choice=clear'>Clear Entry</a></td><td class=\"tx-name-r\" style='text-align: right'><b>Total Amount: 69transaction_amount69 &thorn</b></td></tr>"
	dat += "</table></html>"
	return dat


/obj/machinery/cash_register/proc/add_transaction_log(var/c_name,69ar/p_method,69ar/t_amount)
	var/dat = {"
	<head><style>
		.tx-title {text-align: center; background-color:#ddddff; font-weight: bold}
		.tx-name {background-color: #bbbbee}
		.tx-data {text-align: right; background-color: #ccccff;}
	</head></style>
	<table width=300>
	<tr><td colspan="2" class="tx-title">Transaction #69transaction_logs.len+169</td></tr>
	<tr></tr>
	<tr><td class="tx-name">Customer</td><td class="tx-data">69c_name69</td></tr>
	<tr><td class="tx-name">Pay69ethod</td><td class="tx-data">69p_method69</td></tr>
	<tr><td class="tx-name">Station Time</td><td class="tx-data">69stationtime2text()69</td></tr>
	</table>
	<table width=300>
	"}
	var/item_name
	for(var/i=1, i<=item_list.len, i++)
		item_name = item_list69i69
		dat += "<tr><td class=\"tx-name\">69item_list69item_name69 ? "69item_list69item_name6969 x " : ""6969item_name69</td><td class=\"tx-data\" width=50>69price_list69item_name69 * item_list69item_name6969 &thorn</td></tr>"
	dat += "<tr></tr><tr><td colspan=\"2\" class=\"tx-name\" style='text-align: right'><b>Total Amount: 69transaction_amount69 &thorn</b></td></tr>"
	dat += "</table></html>"

	transaction_logs += dat


/obj/machinery/cash_register/proc/check_account()
	if (!linked_account)
		usr.visible_message("\icon69src69<span class='warning'>Unable to connect to linked account.</span>")
		return 0

	if(linked_account.suspended)
		src.visible_message("\icon69src69<span class='warning'>Connected account has been suspended.</span>")
		return 0
	return 1


/obj/machinery/cash_register/proc/transaction_complete()
	///69isible confirmation
	playsound(src, 'sound/machines/chime.ogg', 25)
	src.visible_message("\icon69src69<span class='notice'>Transaction complete.</span>")
	flick("register_approve", src)
	reset_memory()
	updateDialog()


/obj/machinery/cash_register/proc/reset_memory()
	transaction_amount = null
	transaction_purpose = ""
	item_list.Cut()
	price_list.Cut()
	confirm_item = null


/obj/machinery/cash_register/verb/open_cash_box()
	set category = "Object"
	set name = "Open Cash Box"
	set desc = "Open/closes the register's cash box."
	set src in69iew(1)

	if(usr.stat) return

	if(cash_open)
		cash_open = 0
		overlays -= "register_approve"
		overlays -= "register_open"
		overlays -= "register_cash"
	else if(!cash_locked)
		cash_open = 1
		overlays += "register_approve"
		overlays += "register_open"
		if(cash_stored)
			overlays += "register_cash"
	else
		to_chat(usr, SPAN_WARNING("The cash box is locked."))


/obj/machinery/cash_register/proc/toggle_anchors(obj/item/tool/wrench/W,69ob/user)
	if(manipulating) return
	manipulating = 1
	if(!anchored)
		user.visible_message("\The 69user69 begins securing \the 69src69 to the floor.",
	                         "You begin securing \the 69src69 to the floor.")
	else
		user.visible_message(SPAN_WARNING("\The 69user69 begins unsecuring \the 69src69 from the floor."),
	                         "You begin unsecuring \the 69src69 from the floor.")
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(!do_after(user, 20))
		manipulating = 0
		return
	if(!anchored)
		user.visible_message(SPAN_NOTICE("\The 69user69 has secured \the 69src69 to the floor."),
	                         SPAN_NOTICE("You have secured \the 69src69 to the floor."))
	else
		user.visible_message(SPAN_WARNING("\The 69user69 has unsecured \the 69src69 from the floor."),
	                         SPAN_NOTICE("You have unsecured \the 69src69 from the floor."))
	anchored = !anchored
	manipulating = 0
	return



/obj/machinery/cash_register/emag_act(var/remaining_charges,69ar/mob/user)
	if(!emagged)
		src.visible_message(SPAN_DANGER("The 69src69's cash box springs open as 69user69 swipes the card through the scanner!"))
		playsound(src, "sparks", 50, 1)
		req_access = list()
		emagged = 1
		locked = 0
		cash_locked = 0
		open_cash_box()

/*
//--Premades--//

/obj/machinery/cash_register/command
	account_to_connect = "Command"
	..()

/obj/machinery/cash_register/medical
	account_to_connect = "Medical"
	..()

/obj/machinery/cash_register/engineering
	account_to_connect = "Engineering"
	..()

/obj/machinery/cash_register/science
	account_to_connect = "Science"
	..()

/obj/machinery/cash_register/security
	account_to_connect = "Security"
	..()

/obj/machinery/cash_register/cargo
	account_to_connect = "Guild"
	..()

/obj/machinery/cash_register/civilian
	account_to_connect = "Civilian"
	..()
*/
