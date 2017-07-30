/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(all_money_accounts.len)
		var/datum/money_account/D = pick(all_money_accounts)
		winner_name = D.owner_name
		var/datum/transaction/T = PoolOrNew(/datum/transaction, list(
			winner_sum, "Nyx Daily Grand Slam -Stellar- Lottery",
			"Winner!", "Biesel TCD Terminal #[rand(111,333)]"
		))
		if(T.apply_to(D))
			deposit_success = 1

/datum/event/money_lotto/announce()
	var/author = "[company_name] Editor"
	var/channel = "Nyx Daily"

	var/body = "Nyx Daily wishes to congratulate <b>[winner_name]</b> for recieving the Nyx Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] credits!"
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. Send a cheque containing the sum of 5000 credits to ND 'Stellar Slam' office on the Nyx gateway containing updated details, and your winnings'll be re-sent within the month."

	news_network.SubmitArticle(body, author, channel, null, 1)
