// SPCR 2022
// Pay extra attention to Topic() security for anything in this code-file , everything about money_Accounts is read in HTML , printed in paper
// and can be used for exploits if variables are not safety checked. transactions too.

/datum/computer_file/program/tax
	filename = "taxapp"
	filedesc = "TaxQuickly 2565"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software."
	size = 0 // it is cloud based
	requires_ntnet = 1
	available_on_ntnet = 1
	usage_flags = PROGRAM_PDA
	nanomodule_path = /datum/nano_module/program/tax


/datum/nano_module/program/tax
	name = "TaxQuickly 2565"
	var/popup_message = ""
	var/popup = FALSE
	var/logined = FALSE
	var/browsing_logs = FALSE
	var/account_num
	var/account_pin
	var/datum/money_account/account

	var/account_registration_fee = 500
	var/department_registration_fee = 2000


/datum/nano_module/program/tax/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	// Used to call set_icon()
	// When not logined or have an "error" popup - screen is uplink red
	// When logined and have no popups - screen is blue
	// When have a "success" popup - screen is green
	var/datum/computer_file/program/tax/P = program

	if(href_list["enter_login"])
		account_num = text2num(input("Enter account number", "Login"))
		account_pin = text2num(input("Enter pin code", "Password"))
		return TOPIC_REFRESH

	if(href_list["log_in"])
		if(!account_num)
			popup_message = "<b>An error has occurred.</b><br> Invalid Credentials."
			popup = TRUE
			P.set_icon("uplink")
			return TOPIC_REFRESH

		if(!account_pin)
			popup_message = "<b>An error has occurred.</b><br> Invalid Credentials."
			popup = TRUE
			P.set_icon("uplink")
			return TOPIC_REFRESH

		account = attempt_account_access(account_num, account_pin, 1, force_security = TRUE)

		if(!account)
			popup_message = "<b>An error has occurred.</b><br> Invalid Credentials."
			popup = TRUE
			P.set_icon("uplink")
			// Create an entry in the account transaction log
			var/datum/money_account/failed_account = get_account(account_num)
			if(failed_account)
				var/datum/transaction/T = new(0, failed_account.owner_name, "Unauthorised login attempt", name)
				T.apply_to(failed_account)

		else
			// Create a transaction log entry
			var/datum/transaction/T = new(0, account.owner_name, "Remote terminal access", name)
			T.apply_to(account)
			logined = TRUE
			P.set_icon("uplink_blue")

		return TOPIC_REFRESH

	if(href_list["log_out"])
		logined = FALSE
		account = null
		account_num = null
		account_pin = null
		P.set_icon("uplink")
		return TOPIC_REFRESH

	if(href_list["back"])
		popup = FALSE
		browsing_logs = FALSE
		if(logined)
			P.set_icon("uplink_blue")
		else
			P.set_icon("uplink")
		return TOPIC_REFRESH

	if(href_list["transfer"])
		var/target	= text2num(input(usr,"Target account number", "Funds transfer"))
		var/amount	= text2num(input(usr,"Amount to transfer", "Funds transfer"))
		var/purpose	= input(usr,"Transfer purpose", "Funds transfer")
		purpose = sanitizeSafe(purpose, 128, TRUE)
		if(amount > account.money)
			popup_message = "<b>An error has occurred.</b><br> Insufficient funds."
			P.set_icon("uplink")
		else if(!get_account(target))
			popup_message = "<b>An error has occurred.</b><br> Target account not found."
			P.set_icon("uplink")
		else if(transfer_funds(account.account_number, target, purpose, name, amount))
			popup_message = "<b>Transaction successful.</b><br> "
			P.set_icon("uplink_green")
		else
			popup_message = "<b>An error has occurred.</b><br> Transaction failed."
			P.set_icon("uplink")
		popup = TRUE
		return TOPIC_REFRESH

	if(href_list["logs"])
		browsing_logs = TRUE
		return TOPIC_REFRESH

	if(href_list["resign"])
		account.employer = null
		account.wage = null
		account.debt = null
		account.wage_manual = FALSE
		return TOPIC_REFRESH

	if(href_list["set_wage"])
		var/datum/money_account/A = get_account(text2num(href_list["set_wage"]))
		if(istype(A))
			var/amount	= text2num(input(usr,"Set new wage", ""))
			if(amount < 0) // Negative salaries is fun but better not
				amount = 0
			A.wage = amount
			A.wage_manual = TRUE // Handle wage manually from now on
		return TOPIC_REFRESH

	if(href_list["reset_wage"])
		var/datum/money_account/A = get_account(text2num(href_list["reset_wage"]))
		if(istype(A))
			if(A.department_id) // If department account, recalculate wage
				var/datum/department/D = GLOB.all_departments[A.department_id]
				A.wage = D.get_total_budget()
			else // If personal account, set starting wage
				A.wage = A.wage_original
			A.wage_manual = FALSE // Handle wage authomatically from now on
		return TOPIC_REFRESH

	if(href_list["disavow"]) // Unlink that account and reset it's values
		var/datum/money_account/A = get_account(text2num(href_list["disavow"]))
		if(istype(A))
			A.employer = null
			A.wage = 0
			A.debt = 0
			A.wage_manual = FALSE
			if(A.department_id) // If it was linked and unlinked to account mid-round some values could break, resetting
				var/datum/department/D = GLOB.all_departments[A.department_id]
				D.funding_source = initial(D.funding_source)
		return TOPIC_REFRESH

	if(href_list["link"])
		var/target = text2num(input(usr,"Target account number", ""))
		var/datum/money_account/A = get_account(target)
		if(istype(A))
			if(A.employer)
				popup_message = "<b>An error has occurred.</b><br> Account already bound to a department. Request employee to resign first."
				popup = TRUE
				P.set_icon("uplink")
			else if(A == account)
				popup_message = "<b>An error has occurred.</b><br> Can\'t link an account to itself."
				popup = TRUE
				P.set_icon("uplink")
			else if(A.department_id)
				var/datum/department/D = GLOB.all_departments[A.department_id]
				D.funding_source = account.department_id
				A.employer = account.department_id
				A.wage_manual = FALSE
				A.wage = D.get_total_budget()
			else
				A.employer = account.department_id
				A.wage_manual = FALSE
		return TOPIC_REFRESH

	if(href_list["create_account"])
		var/account_type = alert("Personal account have all basic functionality and cost [account_registration_fee] credits. Department account additionally can add other accounts to authomated payroll and cost [department_registration_fee] credits.", "Account Registration", "Personal", "Department", "Cancel")
		var/registration_fee
		var/is_department
		switch(account_type)
			if("Personal")
				registration_fee = account_registration_fee

			if("Department")
				registration_fee = department_registration_fee
				is_department = TRUE

			if("Cancel")
				return TOPIC_HANDLED

		if(account.money < registration_fee)
			popup_message = "<b>An error has occurred.</b><br> Can\'t afford account registration fee.<br> Try again when you\'re a little richer."
			popup = TRUE
			P.set_icon("uplink")
			return TOPIC_REFRESH

		var/owner_name = input(usr,"Enter account owner name", "Account Registration") as text|null
		if(!owner_name)
			popup_message = "<b>An error has occurred.</b><br> Invalid account name."
			popup = TRUE
			P.set_icon("uplink")
			return TOPIC_REFRESH

		var/datum/money_account/M = new()
		M.owner_name = sanitizeSafe(owner_name, MAX_NAME_LEN, TRUE)
		M.remote_access_pin = rand(1111, 9999)
		M.account_number = next_account_number
		next_account_number += rand(1,25)

		if(is_department)
			var/account_name = input(usr,"Enter department name", "Account Registration") as text|null
			if(!account_name)
				account_name = owner_name

			account_name = sanitizeSafe(account_name, MAX_NAME_LEN, TRUE)
			var/datum/department/D = new()
			D.name = account_name
			D.id = account_name
			D.account_number = M.account_number
			D.account_pin = M.remote_access_pin
			D.budget_base = 0
			GLOB.all_departments[D.id] = D

			M.account_name = account_name
			M.department_id = account_name
			M.can_make_accounts = TRUE
			department_accounts.Add(M)
		else
			personal_accounts.Add(M)

		all_money_accounts.Add(M)

		var/datum/transaction/T = new(0, M.get_name(), "Account creation", account.department_id ? "[account.get_name()]" : "Asters Guild Representative [account.get_name()]", current_date_string, stationtime2text() )
		M.transaction_log.Add(T)

		charge_to_account(account.account_number, owner_name, "Account registration fee", name, registration_fee)
		popup_message = "<b>Account created!</b><br> Make sure to copy following information now.<br> You won\'t be able to see it again!<br> Tax ID: [M.account_number]<br> Pin code: [M.remote_access_pin]"
		popup = TRUE
		P.set_icon("uplink_green")
		return TOPIC_REFRESH

	return TOPIC_HANDLED


/datum/nano_module/program/tax/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/nano_topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["stored_login"] = account_num ? account_num : ""
	data["popup"] = popup
	data["popup_message"] = popup_message
	data["logined"] = logined
	data["browsing_logs"] = browsing_logs

	data["is_manual_wage"] = FALSE
	data["is_department_account"] = FALSE
	data["is_aster_account"] = FALSE
	data["have_employees"] = FALSE

	data["account_employees"] = "N/A"
	data["account_owner"] = "N/A"
	data["account_balance"] = "N/A"
	data["account_debt"] = "N/A"
	data["account_wage"] = "N/A"
	data["account_alignment"] = "N/A"
	data["account_logs"] = "N/A"

	if(account)
		data["account_owner"] = account.get_name()
		data["account_balance"] = account.money
		data["account_debt"] = account.debt ? account.debt : "None"
		data["account_wage"] = account.wage ? account.wage : "None"
		data["account_alignment"] = account.employer ? account.employer : "None"
		data["is_aster_account"] = account.can_make_accounts
		data["is_manual_wage"] = account.wage_manual ? "Manually" : "Automatically"

		if(account.department_id)
			data["is_department_account"] = TRUE
			var/list/employee_accounts[0]
			for(var/datum/money_account/A in all_money_accounts)
				if(A.employer == account.department_id)
					employee_accounts.Add(list(list(
					"employee_number" = A.account_number,
					"employee_name" = A.get_name(),
					"employee_debt" = A.debt ? A.debt : "None",
					"employee_wage" = A.wage ? A.wage : "None",
					"employee_is_manual" = A.wage_manual ? "Manually" : "Automatically")))
			if(employee_accounts.len)
				data["have_employees"] = TRUE
				data["account_employees"] = employee_accounts

		var/list/logs[0]
		for(var/datum/transaction/T in account.transaction_log)
			logs.Add(list(list(
				"date" = T.date,
				"time" = T.time,
				"target_name" = T.target_name,
				"purpose" = T.purpose,
				"amount" = T.amount,
				"source_terminal" = T.source_terminal)))

		if(logs.len)
			data["account_logs"] = logs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "tax_app.tmpl", "TaxQuickly 2565", 450, 600, state = state)
		if(host.update_layout())
			ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
