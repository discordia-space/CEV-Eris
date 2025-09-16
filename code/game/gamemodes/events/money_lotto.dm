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
	var/deposit_success = FALSE

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 15000)
	if(LAZYLEN(all_money_accounts))
		var/list/private_accounts = all_money_accounts.Copy()
		for(var/i in department_accounts)
			private_accounts.Remove(department_accounts[i])
		if(LAZYLEN(private_accounts))
			var/datum/money_account/D = pick(private_accounts)
			winner_name = D.get_name()
			var/datum/transaction/T = new(winner_sum, "Nyx Daily Grand Slam -Stellar- Lottery", "Winner!", "Biesel TCD Terminal #[rand(111,333)]")
			if(T.apply_to(D))
				deposit_success = TRUE

/datum/event/money_lotto/announce()
	var/author = "[GLOB.company_name] Editor"
	var/channel = "Nyx Daily"

	var/body = "Nyx Daily wishes to congratulate [winner_name] for winning the Nyx Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] credits!"

	priority_announce(body, "Lottery")

	news_network.SubmitArticle(body, author, channel, null, 1)
