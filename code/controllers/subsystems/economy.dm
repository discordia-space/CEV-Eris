/*
	The economy subsystem will handle everything related to finances, trade, wages, etc.

	In this initial implementation, it only handles wages
*/
SUBSYSTEM_DEF(economy)
	name = "Economy"
	init_order = INIT_ORDER_LATELOAD

	wait = 300 //Ticks once per 30 seconds
	var/payday_interval = 30 MINUTES
	var/next_payday = 30 MINUTES

/datum/controller/subsystem/economy/Initialize()
	.=..()

/datum/controller/subsystem/economy/fire()
	if (world.time >= next_payday)
		next_payday = world.time + payday_interval
		//Its payday time!
		do_payday()


/proc/do_payday()
	var/total_paid = 0
	var/paid_internal = 0
	var/paid_external = 0

	// Departments pay to departments first
	for(var/i in department_accounts)
		var/datum/money_account/A = department_accounts[i]
		var/datum/department/D = GLOB.all_departments[A.department_id]
		var/datum/department/ED = GLOB.all_departments[D.funding_source]

		if(!A.employer)
			continue

		if(D && !A.wage_manual)
			A.wage = D.get_total_budget()

		var/amount_to_pay = A.debt + A.wage
		if(amount_to_pay <= 0)
			continue

		if(!ED) // If no employer department found - payment is external
			deposit_to_account(A, A.employer, "Payroll Funding", "Hansa payroll system", amount_to_pay)
			paid_external += amount_to_pay
			continue
		else
			var/datum/money_account/EA = get_account(ED.account_number)
			if(amount_to_pay <= EA.money)
				transfer_funds(EA, A, "Payroll Funding", "CEV Eris payroll system", amount_to_pay)
				paid_internal += amount_to_pay
				ED.total_debt -= A.debt
				A.debt = 0
			else
				A.debt += A.wage
				ED.total_debt += A.wage

	// Departments pay to the crew
	for(var/datum/money_account/A in personal_accounts)
		if(!A.employer)
			continue

		var/amount_to_pay = A.debt + A.wage
		if(amount_to_pay <= 0)
			continue

		var/datum/department/ED = GLOB.all_departments[A.employer]
		var/datum/money_account/EA = department_accounts[ED.id]
		var/datum/computer_file/report/crew_record/R = get_crewmember_record(A.owner_name)

		if(amount_to_pay <= EA.money)
			transfer_funds(EA, A, "Payroll Funding", "CEV Eris payroll system", amount_to_pay)
			paid_internal += amount_to_pay
			ED.total_debt -= A.debt
			A.debt = 0
			if(R)
				payroll_mail_account_holder(R, "[ED.name] account", amount_to_pay)
		else
			A.debt += A.wage
			ED.total_debt += A.wage
			// payroll_mail_where_is_my_money

	// Mail commanding officers and politely ask "Where's the fucking money, shithead?"
	for(var/i in GLOB.all_departments)
		var/datum/department/D = GLOB.all_departments[i]
		var/datum/money_account/A = department_accounts[D.id]
		if(D.total_debt && A)
			var/ownername = A.owner_name
			if(ownername)
				var/datum/computer_file/report/crew_record/R = get_crewmember_record(ownername)
				if(R)
					payroll_failure_mail(R, A, D.total_debt)

	total_paid = paid_internal + paid_external
	priority_announce("Half hourly crew wages have been paid, please check your email for details. In total the crew of [station_name()] have earned [total_paid] credits, including [paid_external] credits from external sources.\nPlease contact your Department Heads in case of errors or missing payments.", "Dispensation")


//Sent to a head of staff when their department account fails to pay out wages
/proc/payroll_failure_mail(datum/computer_file/report/crew_record/R, datum/money_account/fail_account, amount)
	var/address = R.get_email()

	var/datum/computer_file/data/email_message/message = new()
	message.title = "Payment Processing Error"

	message.stored_data = "Warning: Automated payroll processing has failed for account \"[fail_account.get_name()]\"\n\n \
	The pending balance to pay out is [amount][CREDITS]\n \
	Crewmembers who should be paid from this account have not been paid. \n\n \
	The pending payments will roll over and another attempt will be made in one hour. Please ensure the account balance is corrected\n"

	message.source = payroll_mailer.login
	if(!payroll_mailer.send_mail(address, message))
		return FALSE
	return TRUE


/proc/payroll_mail_account_holder(datum/computer_file/report/crew_record/R, sender, amount)
	//In future, this will be expanded to include a report on penalties, bonuses and taxes that affected your wages

	var/address = R.get_email()

	var/datum/computer_file/data/email_message/message = new()
	message.title = "You have recieved funds"

	message.stored_data = "You have recieved a payment\n\n \
	From: [sender]\n \
	Reason: Regular Wages\n\n \
	----------------------------\n \
	Balance: [amount][CREDITS] \n\n"

	message.source = payroll_mailer.login
	if(!payroll_mailer.send_mail(address, message))
		return FALSE
	return TRUE
