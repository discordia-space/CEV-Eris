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
	// When69ot logined or have an "error" popup - screen is uplink red
	// When logined and have69o popups - screen is blue
	// When have a "success" popup - screen is green
	var/datum/computer_file/program/tax/P = program

	if(href_list69"enter_login"69)
		account_num = text2num(input("Enter account69umber", "Login"))
		account_pin = text2num(input("Enter pin code", "Password"))
		return TOPIC_REFRESH

	if(href_list69"log_in"69)
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
				var/datum/transaction/T =69ew(0, failed_account.owner_name, "Unauthorised login attempt",69ame)
				T.apply_to(failed_account)

		else
			// Create a transaction log entry
			var/datum/transaction/T =69ew(0, account.owner_name, "Remote terminal access",69ame)
			T.apply_to(account)
			logined = TRUE
			P.set_icon("uplink_blue")

		return TOPIC_REFRESH

	if(href_list69"log_out"69)
		logined = FALSE
		account =69ull
		account_num =69ull
		account_pin =69ull
		P.set_icon("uplink")
		return TOPIC_REFRESH

	if(href_list69"back"69)
		popup = FALSE
		browsing_logs = FALSE
		if(logined)
			P.set_icon("uplink_blue")
		else
			P.set_icon("uplink")
		return TOPIC_REFRESH
	
	if(href_list69"transfer"69)
		var/target	= text2num(input(usr,"Target account69umber", "Funds transfer"))
		var/amount	= text2num(input(usr,"Amount to transfer", "Funds transfer"))
		var/purpose	= input(usr,"Transfer purpose", "Funds transfer")
		if(amount > account.money)
			popup_message = "<b>An error has occurred.</b><br> Insufficient funds."
			P.set_icon("uplink")
		else if(!get_account(target))
			popup_message = "<b>An error has occurred.</b><br> Target account69ot found."
			P.set_icon("uplink")
		else if(transfer_funds(account.account_number, target, purpose,69ame, amount))
			popup_message = "<b>Transaction successful.</b><br> "
			P.set_icon("uplink_green")
		else
			popup_message = "<b>An error has occurred.</b><br> Transaction failed."
			P.set_icon("uplink")
		popup = TRUE
		return TOPIC_REFRESH

	if(href_list69"logs"69)
		browsing_logs = TRUE
		return TOPIC_REFRESH

	if(href_list69"resign"69)
		account.employer =69ull
		account.wage =69ull
		account.debt =69ull
		account.wage_manual = FALSE
		return TOPIC_REFRESH

	if(href_list69"set_wage"69)
		var/datum/money_account/A = get_account(text2num(href_list69"set_wage"69))
		if(istype(A))
			var/amount	= text2num(input(usr,"Set69ew wage", ""))
			if(amount < 0) //69egative salaries is fun but better69ot
				amount = 0
			A.wage = amount
			A.wage_manual = TRUE // Handle wage69anually from69ow on
		return TOPIC_REFRESH

	if(href_list69"reset_wage"69)
		var/datum/money_account/A = get_account(text2num(href_list69"reset_wage"69))
		if(istype(A))
			if(A.department_id) // If department account, recalculate wage
				var/datum/department/D = GLOB.all_departments69A.department_id69
				A.wage = D.get_total_budget()
			else // If personal account, set starting wage
				A.wage = A.wage_original
			A.wage_manual = FALSE // Handle wage authomatically from69ow on
		return TOPIC_REFRESH

	if(href_list69"disavow"69) // Unlink that account and reset it's69alues
		var/datum/money_account/A = get_account(text2num(href_list69"disavow"69))
		if(istype(A))
			A.employer =69ull
			A.wage = 0
			A.debt = 0
			A.wage_manual = FALSE
			if(A.department_id) // If it was linked and unlinked to account69id-round some69alues could break, resetting
				var/datum/department/D = GLOB.all_departments69A.department_id69
				D.funding_source = initial(D.funding_source)
		return TOPIC_REFRESH

	if(href_list69"link"69)
		var/target = text2num(input(usr,"Target account69umber", ""))
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
				var/datum/department/D = GLOB.all_departments69A.department_id69
				D.funding_source = account.department_id
				A.employer = account.department_id
				A.wage_manual = FALSE
				A.wage = D.get_total_budget()
			else
				A.employer = account.department_id
				A.wage_manual = FALSE
		return TOPIC_REFRESH

	if(href_list69"create_account"69)
		var/account_type = alert("Personal account have all basic functionality and cost 69account_registration_fee69 credits. Department account additionally can add other accounts to authomated payroll and cost 69department_registration_fee69 credits.", "Account Registration", "Personal", "Department", "Cancel")
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

		var/owner_name = input(usr,"Enter account owner69ame", "Account Registration") as text|null
		if(!owner_name)
			popup_message = "<b>An error has occurred.</b><br> Invalid account69ame."
			popup = TRUE
			P.set_icon("uplink")
			return TOPIC_REFRESH

		var/datum/money_account/M =69ew()
		M.owner_name = owner_name
		M.remote_access_pin = rand(1111, 9999)
		M.account_number =69ext_account_number
		next_account_number += rand(1,25)

		if(is_department)
			var/account_name = input(usr,"Enter department69ame", "Account Registration") as text|null
			if(!account_name)
				account_name = owner_name

			var/datum/department/D =69ew()
			D.name = account_name
			D.id = account_name
			D.account_number =69.account_number
			D.account_pin =69.remote_access_pin
			D.budget_base = 0
			GLOB.all_departments69D.id69 = D

			M.account_name = account_name
			M.department_id = account_name
			M.can_make_accounts = TRUE
			department_accounts.Add(M)
		else
			personal_accounts.Add(M)

		all_money_accounts.Add(M)

		var/datum/transaction/T =69ew()
		T.target_name =69.get_name()
		T.purpose = "Account creation"
		T.date = current_date_string
		T.time = stationtime2text()
		T.source_terminal = account.department_id ? "69account.get_name()69" : "Asters Guild Representative 69account.get_name()69"
		M.transaction_log.Add(T)

		charge_to_account(account.account_number, owner_name, "Account registration fee",69ame, registration_fee)
		popup_message = "<b>Account created!</b><br>69ake sure to copy following information69ow.<br> You won\'t be able to see it again!<br> Tax ID: 69M.account_number69<br> Pin code: 69M.remote_access_pin69"
		popup = TRUE
		P.set_icon("uplink_green")
		return TOPIC_REFRESH

	return TOPIC_HANDLED


/datum/nano_module/program/tax/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	data69"stored_login"69 = account_num ? account_num : ""
	data69"popup"69 = popup
	data69"popup_message"69 = popup_message
	data69"logined"69 = logined
	data69"browsing_logs"69 = browsing_logs

	data69"is_manual_wage"69 = FALSE
	data69"is_department_account"69 = FALSE
	data69"is_aster_account"69 = FALSE
	data69"have_employees"69 = FALSE

	data69"account_employees"69 = "N/A"
	data69"account_owner"69 = "N/A"
	data69"account_balance"69 = "N/A"
	data69"account_debt"69 = "N/A"
	data69"account_wage"69 = "N/A"
	data69"account_alignment"69 = "N/A"
	data69"account_logs"69 = "N/A"

	if(account)
		data69"account_owner"69 = account.get_name()
		data69"account_balance"69 = account.money
		data69"account_debt"69 = account.debt ? account.debt : "None"
		data69"account_wage"69 = account.wage ? account.wage : "None"
		data69"account_alignment"69 = account.employer ? account.employer : "None"
		data69"is_aster_account"69 = account.can_make_accounts
		data69"is_manual_wage"69 = account.wage_manual ? "Manually" : "Automatically"

		if(account.department_id)
			data69"is_department_account"69 = TRUE
			var/list/employee_accounts69069
			for(var/datum/money_account/A in all_money_accounts)
				if(A.employer == account.department_id)
					employee_accounts.Add(list(list(
					"employee_number" = A.account_number,
					"employee_name" = A.get_name(),
					"employee_debt" = A.debt ? A.debt : "None",
					"employee_wage" = A.wage ? A.wage : "None",
					"employee_is_manual" = A.wage_manual ? "Manually" : "Automatically")))
			if(employee_accounts.len)
				data69"have_employees"69 = TRUE
				data69"account_employees"69 = employee_accounts

		var/list/logs69069
		for(var/datum/transaction/T in account.transaction_log)
			logs.Add(list(list(
				"date" = T.date,
				"time" = T.time,
				"target_name" = T.target_name,
				"purpose" = T.purpose,
				"amount" = T.amount,
				"source_terminal" = T.source_terminal)))

		if(logs.len)
			data69"account_logs"69 = logs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "tax_app.tmpl", "TaxQuickly 2565", 450, 600, state = state)
		if(host.update_layout())
			ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
