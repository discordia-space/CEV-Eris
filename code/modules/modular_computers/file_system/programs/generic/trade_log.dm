#define SHIPPING_SCREEN "Shipping"
#define EXPORT_SCREEN "Export"
#define OFFER_SCREEN "Offer"
#define ORDER_SCREEN "Order"
#define SCREEN_LIST list(SHIPPING_SCREEN, EXPORT_SCREEN, OFFER_SCREEN, ORDER_SCREEN)

/datum/computer_file/program/trade_log
	filename = "trade_log"
	filedesc = "Aster\'s Trade Beacon Logs"
	extended_desc = "Digital log showing all trade beacon transactions made by your account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 2
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/trade_log
	usage_flags = PROGRAM_ALL

	var/screen = null
	var/datum/money_account/account
	var/current_page = 1

/datum/computer_file/program/trade_log/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["PRG_print"] || href_list["PRG_print_internal"])
		var/log_id = href_list["PRG_print"] || href_list["PRG_print_internal"]
		if(computer?.printer)
			var/list/log_data = SStrade.get_log_data_by_id(log_id)

			if(!log_data.len)
				to_chat(usr, SPAN_WARNING("Unable to print invoice: no log with id \"[log_id]\" found."))
				return

			var/id_data = splittext(log_id, "-")
			var/log_type = id_data[2]

			switch(log_type)
				if("S")
					log_type = "Shipping"
				if("E")
					log_type = "Export"
				if("SO")
					log_type = "Special Offer"
				if("O")
					log_type = "Order"
				else
					return

			var/title
			title = "[lowertext(log_type)] invoice - #[log_id]"
			title += href_list["PRG_print_internal"] ? " (internal)" : null

			var/text
			text += "<h3>[log_type] Invoice - #[log_id]</h3>"
			text += "<hr><font size = \"2\">"
			text += href_list["PRG_print_internal"] ? "FOR INTERNAL USE ONLY<br><br>" : null
			text += log_type != "Shipping" && log_type ? "Recipient: [log_data["ordering_acct"]]<br>" : "Recipient: \[field\]<br>"
			text += log_type == "Shipping" ? "Package Name: \[field\]<br>" : null
			text += "Contents:<br>"
			text += "<ul>"
			text += log_data["contents"]
			text += "</ul>"
			text += href_list["PRG_print_internal"] ? "Order Cost: [log_data["total_paid"]]<br>" : null
			text += log_type == "Shipping" ? "Total Credits Paid: \[field\]<br>" : "Total Credits Paid: [log_data["total_paid"]]<br>"
			text += "</font>"
			text += log_type == "Shipping" ? "<hr><h5>Stamp below to confirm receipt of goods:</h5>" : null

			computer.printer.print_text(text, title)
		else
			to_chat(usr, SPAN_WARNING("Unable to print invoice: no printer component installed."))
		return TRUE

	if(href_list["PRG_screen"])
		screen = input("Select log type", "Log Type", null) as null|anything in SCREEN_LIST
		current_page = 1
		return TRUE

	if(href_list["PRG_account"])
		var/acc_num = input("Enter account number", "Account linking", computer?.card_slot?.stored_card?.associated_account_number) as num|null
		if(!acc_num)
			return

		var/acc_pin = input("Enter PIN", "Account linking") as num|null
		if(!acc_pin)
			return

		var/card_check = computer?.card_slot?.stored_card?.associated_account_number == acc_num
		var/datum/money_account/A = attempt_account_access(acc_num, acc_pin, card_check ? 2 : 1, TRUE)
		if(!A)
			to_chat(usr, SPAN_WARNING("Unable to link account: access denied."))
			return

		account = A
		return TRUE

	if(account)
		if(href_list["PRG_account_unlink"])
			account = null
			return TRUE

	if(href_list["PRG_page_first"])
		current_page = 1
		return TRUE

	if(href_list["PRG_page_prev_10"])
		current_page = max(1, current_page - 10)
		return TRUE

	if(href_list["PRG_page_prev"])
		current_page = max(1, current_page - 1)
		return TRUE

	if(href_list["PRG_page_select"])
		var/page_max = text2num(href_list["PRG_page_select"])
		var/input = input("Enter page number (1-[page_max])", "Page Selection") as num|null
		if(!input)
			return
		current_page = clamp(input, 1, page_max)
		return TRUE

	if(href_list["PRG_page_next"])
		var/page_max = text2num(href_list["PRG_page_next"])
		current_page = min(page_max, current_page + 1)
		return TRUE

	if(href_list["PRG_page_next_10"])
		var/page_max = text2num(href_list["PRG_page_next_10"])
		current_page = min(page_max, current_page + 10)
		return TRUE

	if(href_list["PRG_page_last"])
		var/page_max = text2num(href_list["PRG_page_last"])
		current_page = page_max
		return TRUE

/datum/nano_module/program/trade_log
	name = "Trade Beacon Logs"

/datum/nano_module/program/trade_log/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "trade_log.tmpl", name, 700, 640, state = state)
		ui.set_auto_update(TRUE)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/trade_log/ui_data()
	. = ..()
	var/datum/computer_file/program/trade_log/PRG = program
	if(!istype(PRG))
		return

	var/list/current_log = list()
	var/is_all_access = FALSE

	if(PRG.account)
		.["account"] = "[PRG.account.get_name()] #[PRG.account.account_number]"
		var/dept_id = PRG.account.department_id
		if(dept_id)
			is_all_access = (dept_id == DEPARTMENT_GUILD) ? TRUE : FALSE

	.["screen"] = PRG.screen
	.["log_page"] = PRG.current_page
	.["is_all_access"] = is_all_access

	switch(PRG.screen)
		if(SHIPPING_SCREEN)
			current_log = SStrade.shipping_log
		if(EXPORT_SCREEN)
			current_log = SStrade.export_log
		if(OFFER_SCREEN)
			current_log = SStrade.offer_log
		if(ORDER_SCREEN)
			current_log = SStrade.order_log
		else
			current_log = list()

	if(!is_all_access)
		var/list/sanitized_log = list()
		for(var/log_entry in current_log)
			var/list/log_data = log_entry
			if(log_data["ordering_acct"] == PRG.account.get_name())
				sanitized_log |= list(log_data)
		current_log = sanitized_log

	var/logs_per_page = 10
	var/logs_to_display = logs_per_page
	var/page_max = round(current_log.len / logs_per_page, 1)
	var/page_remainder = current_log.len % logs_per_page
	if(current_log.len < logs_per_page * PRG.current_page)
		logs_to_display = page_remainder
	if(page_remainder < logs_per_page / 2)
		++page_max

	.["page_max"] = page_max ? page_max : 1

	var/list/page_of_logs = list()

	if(logs_to_display)
		for(var/i in 1 to logs_to_display)
			page_of_logs += list(current_log[i + (logs_per_page * (PRG.current_page - 1))])

	.["current_log_data"] = page_of_logs

#undef SHIPPING_SCREEN
#undef EXPORT_SCREEN
#undef OFFER_SCREEN
#undef ORDER_SCREEN
#undef SCREEN_LIST
