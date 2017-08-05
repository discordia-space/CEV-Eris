/datum/event/payday
	var/total_money_ship = 0

/datum/event/payday/start()
	var/datum/transaction/T = PoolOrNew(/datum/transaction, list(0, "Central Payment Account", "Payday", "NTGalaxyNet Terminal #[rand(111,1111)]"))

	for(var/record in data_core.general)
		var/datum/data/record/R = record
		var/datum/job/temp_job = job_master.GetJob(R.fields["real_rank"])
		if(!temp_job)
			job_master.GetJob("Assistant")
		var/datum/money_account/pay_accaunt = get_account(R.fields["pay_account"])

		var/money_amount = temp_job.one_time_payment()
		T.set_amount(money_amount, FALSE) //FALSE - not update Transaction time
		if(T.apply_to(pay_accaunt))
			total_money_ship += money_amount

/datum/event/payday/announce()
	command_announcement.Announce("A new payday has come. Check your non-suspended accounts for additional funds. The ship's crew totally earned [total_money_ship] credits this time.", "Payday")
