/datum/event/payday
	var/total_money_ship = 0

/datum/event/payday/start()
	var/datum/transaction/T = new(0, "Central Payment Account", "Payday", "NTGalaxyNet Terminal #[rand(111,1111)]")

	for(var/datum/data/record/R in data_core.general)
		var/datum/money_account/pay_account = get_account(R.fields["pay_account"])
		if (!istype(pay_account))
			continue

		var/datum/job/temp_job = SSjob.GetJob(R.fields["real_rank"])
		if(!istype(temp_job))
			temp_job = SSjob.GetJob("Assistant")
		if(!istype(temp_job))
			continue

		var/money_amount = temp_job.one_time_payment()
		T.set_amount(money_amount, FALSE) //FALSE - not update Transaction time
		if(T.apply_to(pay_account))
			total_money_ship += money_amount

/datum/event/payday/announce()
	command_announcement.Announce("A new payday has come. Check your non-suspended accounts for additional funds. The ship's crew totally earned [total_money_ship] credits this time.", "Payday")
