/*
	Grants a large sum of money to one player
	//TODO: APPROPRIATE lore factions for things mentioned here
	//Clock give me some factions, don't merge it til we fix this
*/
/datum/storyevent/money_lotto
	id = "money_lotto"
	name = "money_lotto"

	weight = 0.3

	event_type = /datum/event/money_lotto
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE)

	tags = list(TAG_POSITIVE)



/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 15000)
	if(all_money_accounts.len)
		var/list/private_accounts = all_money_accounts.Copy()
		for(var/i in department_accounts)
			private_accounts.Remove(department_accounts[i])
		var/datum/money_account/D = pick(private_accounts)
		winner_name = D.get_name()
		var/datum/transaction/T = new(winner_sum, "Nyx Daily Grand Slam -Stellar- Lottery", "Winner!", "Biesel TCD Terminal #[rand(111,333)]")
		if(T.apply_to(D))
			deposit_success = 1

/datum/event/money_lotto/announce()
	var/author = "[company_name] Editor"
	var/channel = "Nyx Daily"

	var/body = "Nyx Daily wishes to congratulate [winner_name] for winning the Nyx Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] credits!"
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. Send a cheque containing the sum of 5000 credits to ND 'Stellar Slam' office on the Nyx gateway containing updated details, and your winnings'll be re-sent within the month."

	command_announcement.Announce(body, "Lottery")

	news_network.SubmitArticle(body, author, channel, null, 1)
