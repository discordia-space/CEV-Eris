/datum/computer_file/program/tax
	filename = "taxquickly"
	filedesc = "TaxQuickly 2565"
	program_icon_state = "uplink"
	extended_desc = "An online tax filing software."
	size = 0 // it is cloud based
	requires_ntnet = 0
	available_on_ntnet = 1
	usage_flags = PROGRAM_PDA
	nanomodule_path = /datum/nano_module/program/tax


/datum/nano_module/program/tax
	name = "TaxQuickly 2565"
	var/logined = FALSE
	var/login_failed = FALSE
	var/browsing_logs = FALSE
	var/account_num
	var/account_pin
	var/datum/money_account/account


/datum/nano_module/program/tax/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["enter_login"])
		account_num = input("Enter account number", "Login") as num
		return

	if(href_list["enter_pin"])
		account_pin = input("Enter pin code", "Password") as num
		return

	if(href_list["log_in"])
		if(!account_num)
			login_failed = TRUE
			return

		if(!account_pin)
			login_failed = TRUE
			return

		account = attempt_account_access(account_num, account_pin, 2, force_security = TRUE)

		if(!account)
			login_failed = TRUE
			//create an entry in the account transaction log
			var/datum/money_account/failed_account = get_account(account_num)
			if(failed_account)
				var/datum/transaction/T = new(0, failed_account.owner_name, "Unauthorised login attempt", name)
				T.apply_to(failed_account)

		else
			//create a transaction log entry
			var/datum/transaction/T = new(0, account.owner_name, "Remote terminal access", name)
			T.apply_to(account)
			logined = TRUE

		return

	if(href_list["log_out"])
		logined = FALSE
		account = null
		account_num = null
		account_pin = null

	if(href_list["back"])
		login_failed = FALSE
		browsing_logs = FALSE
	
	if(href_list["transfer"])
		var/target	= input(usr,"Enter target account number", "Funds transfer") as num
		var/amount	= input(usr,"Enter amount to transfer", "Funds transfer") as num
		var/purpose	= input(usr,"Enter transfer purpose", "Funds transfer") as text
		transfer_funds(account.account_number, target, purpose, name, amount)

	if(href_list["logs"])
		browsing_logs = TRUE
		return

	if(href_list["resign"])
		account.employer = null
		account.wage = null
		return

/datum/nano_module/program/tax/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
//	var/datum/computer_file/program/tax/PRG = program
	data["login_failed"] = login_failed
	data["logined"] = logined
	data["browsing_logs"] = browsing_logs

	if(account)
		data["is_department_account"] = (account in department_accounts)
		data["is_command_account"] = account == department_accounts[DEPARTMENT_COMMAND]
		data["is_guild_account"] = account == department_accounts[DEPARTMENT_GUILD]

		data["account_owner"] = account.get_name()
		data["account_balance"] = account.money
		data["account_wage"] = account.wage? account.wage : "None"
		data["account_alignment"] = account.employer? account.employer : "None"
		data["account_logs"] = get_logs()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "tax_app.tmpl", "TaxQuickly 2565", 450, 600, state = state)
		if(host.update_layout())
			ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)


/datum/nano_module/program/tax/proc/get_logs()
	if(!account)
		return

	var/list/logs = list()
	for(var/i = account.transaction_log.len; i > 1; i--)
		logs.Add(list(list(
			"entry" = account.transaction_log[i]
		)))
	return logs


/*
(if !logined)
Authentication:
	"Enter login"  "Enter Pin" "login"
		on fail - fail message      // program icon turns red // (uplink icon)
		on success - logined = true

(if logined)                        // program icon turns green //
For any account:
	View owner name (stat)
	View balance (stat)
	View aligned organization (stat)
	View hourly wage (stat)
	View transaction logs (button, "logs")
	Transfer funds (button, "transfer")
	Resign (button, "Resign?") // clear account's alignment and wage, allowing to get on payroll of other department

If department account:            // program icon turns blue //
	For each account with department alignment
		View owner name (stat)
		View hourly wage (stat)
		Change hourly wage (button, "change")
		Disavow (button, "Fire?/Disavow?/Remove?")  // clear account's alignment and wage, removing it from that list
		Link an account to department (button, "Link account")
			Enter target account number (input) // fail if account already linked to a department
				Set hourly wage (input)

If command or guild account:      // program icon turns gold //
	View current tax percent (stat) // How much guild gonna pay to command account from each transaction
	Create account (button, "Register Account") // require 500(or 1000?) creds to be paid from creator's account)
		Enter new account's owner name (input)
			Login and pin displayed on the screen

If command account:
	Set tax percent (button, "set taxes") // Up to 100% :death:
*/