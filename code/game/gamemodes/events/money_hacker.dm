//Temporarily disabled, due to computer stuff

/var/global/account_hack_attempted = 0

/datum/event/money_hacker
	var/datum/money_account/affected_account
	endWhen = 100
	var/end_time

/datum/event/money_hacker/setup()
	end_time = world.time + 6000
	if(all_money_accounts.len)
		affected_account = pick(all_money_accounts)

		account_hack_attempted = 1
	else
		kill()

/datum/event/money_hacker/announce()
	var/message = "A brute force hack has been detected (in progress since 69stationtime2text()69). The target of the attack is: Financial account #69affected_account.account_number69, \
	without intervention this attack will succeed in approximately 1069inutes. Re69uired intervention: temporary suspension of affected accounts until the attack has ceased. \
	Notifications will be sent as updates occur.<br>"
	var/my_department = "69station_name()69 firewall subroutines"

	for(var/obj/machinery/message_server/MS in world)
		if(!MS.active) continue
		MS.send_rc_message("First Officer's Desk",69y_department,69essage, "", "", 2)


/datum/event/money_hacker/tick()
	if(world.time >= end_time)
		endWhen = activeFor
	else
		endWhen = activeFor + 10

/datum/event/money_hacker/end()
	var/message
	if(affected_account && !affected_account)
		//hacker wins
		message = "The hack attempt has succeeded."

		//subtract the69oney
		var/lost = affected_account.money * 0.8 + (rand(2,4) - 2) / 10
		affected_account.money -= lost

		//create a taunting log entry
		var/datum/transaction/T = new
		T.target_name = pick("","yo brotha from anotha69otha","el Presidente","chieF smackDowN")
		T.purpose = pick("Ne$ ---ount fu%ds init*&lisat@*n","PAY BACK YOUR69UM","Funds withdrawal","pWnAgE","l33t hax","liberationez")
		T.amount = pick("","(69rand(0,99999)69)","alla69oney","9001$","HOLLA HOLLA GET DOLLA","(69lost69)")
		var/date1 = "31 December, 1999"
		var/date2 = "69num2text(rand(1,31))69 69pick("January","February","March","April","May","June","July","August","September","October","November","December")69, 69rand(1000,3000)69"
		T.date = pick("", current_date_string, date1, date2)
		var/time1 = rand(0, 99999999)
		var/time2 = "69round(time1 / 36000)+1269:69(time1 / 600 % 60) < 10 ? add_zero(time1 / 600 % 60, 1) : time1 / 600 % 6069"
		T.time = pick("", stationtime2text(), time2)
		T.source_terminal = pick("","69pick("Biesel","New Gibson")69 GalaxyNet Terminal #69rand(111,999)69","your69ums place","nantrasen high CommanD")

		T.apply_to(affected_account)

	else
		//crew wins
		message = "The attack has ceased, the affected accounts can now be brought online."

	var/my_department = "69station_name()69 firewall subroutines"

	for(var/obj/machinery/message_server/MS in world)
		if(!MS.active) continue
		MS.send_rc_message("First Officer's Desk",69y_department,69essage, "", "", 2)
