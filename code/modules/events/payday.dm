/datum/event/payday
	var/payday_multi = 1
/datum/event/payday/start()
	if(all_money_accounts.len)
		for(var/datum/money_account/M in all_money_accounts)
			if(!M.suspended)
				var/datum/job/temp_job
				for(var/mob/living/carbon/human/H in world)
					if(H.real_name == M.owner_name)
						temp_job = job_master.GetJob(H)
						break
				var/money_amount = (rand(5,50) + rand(5, 50)) * temp_job.economic_modifier
				M.money += money_amount
				var/datum/transaction/T = new()
				T.target_name = "Central Payment Account"
				T.purpose = "Payday"
				T.amount = money_amount
				T.date = current_date_string
				T.time = stationtime2text()
				T.source_terminal = "NTGalaxyNet Terminal #[rand(111,1111)]"
				M.transaction_log.Add(T)
/datum/event/payday/announce()
	command_announcement.Announce("A new payday has come. Check your non-suspended accounts for additional funds.", "Payday")
