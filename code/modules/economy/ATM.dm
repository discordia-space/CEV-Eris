/*

TODO:
give69oney an actual use (69M stuff,69ending69achines)
send69oney to people (might be worth attaching69oney to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define69IEW_TRANSACTION_LOGS 3

/obj/machinery/atm
	name = "Automatic Teller69achine"
	desc = "For all your69onetary needs!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 10
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/card/id/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN
	var/datum/effect/effect/system/spark_spread/spark_system
	var/updateflag = 0

/obj/machinery/atm/Initialize()
	. = ..()
	machine_id = "69station_name()69 RT #69num_financial_terminals++69"
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/Process()
	if(stat & NOPOWER)
		update_icon()
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/spacecash/S in src)
		S.forceMove(get_turf(src))
		playsound(loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 50, 1)
		break
	update_icon()

/obj/machinery/atm/power_change()
	..()
	if (held_card && !powered(0))
		held_card.loc = src.loc
		authenticated_account = null
		held_card = null
	update_icon()

/obj/machinery/atm/update_icon()
	if(stat & NOPOWER)
		icon_state = "atm_off"
		return
	else if (held_card)
		icon_state = "atm_cardin"
	else
		icon_state = "atm"

/obj/machinery/atm/emag_act(var/remaining_charges,69ar/mob/user)
	if(!emagged)
		return

	//short out the69achine, shoot sparks, spew69oney!
	emagged = 1
	spark_system.start()
	spawn_money(rand(100,500),src.loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a69essage to the user
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	to_chat(user, "<span class='warning'>\icon69src69 The 69src69 beeps: \"69response69\"</span>")
	return 1

/obj/machinery/atm/attackby(obj/item/I as obj,69ob/user as69ob)
	if(istype(I, /obj/item/card))
		if(stat & NOPOWER)
			return
		if(emagged)
			//prevent inserting id into an emagged ATM
			to_chat(user, "\red \icon69src69 CARD READER ERROR. This system has been compromised!")
			return
		else if(istype(I,/obj/item/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/card/id/idcard = I
		if(!held_card)
			usr.unE69uip(I)
			I.forceMove(src)
			playsound(usr.loc, 'sound/machines/id_swipe.ogg', 100, 1)
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
		update_icon()
	else if(authenticated_account)
		if(stat & NOPOWER)
			return
		if(istype(I,/obj/item/spacecash))
			var/obj/item/spacecash/cash = I
			//consume the69oney
			playsound(loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 50, 1)

			//create a transaction log entry
			var/datum/transaction/T = new(cash.worth, authenticated_account.owner_name, "Credit deposit",69achine_id)
			T.apply_to(authenticated_account)

			to_chat(user, "<span class='info'>You insert 69I69 into 69src69.</span>")
			src.attack_hand(user)
			69del(I)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user)
	if(issilicon(user))
		to_chat(user, "\red \icon69src69 Artificial unit recognized. Artificial units do not currently receive69onetary compensation, as per system banking regulation #1005.")
		return
	if (..())
		return
	if(get_dist(src,user) <= 1)

		//js replicated from obj/machinery/computer/card
		var/dat = "<h1>Automatic Teller69achine</h1>"
		dat += "For all your69onetary needs!<br>"
		dat += "<i>This terminal is</i> 69machine_id69. <i>Report this code when contacting IT Support</i><br/>"

		if(emagged > 0)
			dat += "Card: <span style='color: red;'>LOCKED</span><br><br><span style='color: red;'>Unauthorized terminal access detected! This ATM has been locked. Please contact IT Support.</span>"
		else
			dat += "Card: <a href='?src=\ref69src69;choice=insert_card'>69held_card ? held_card.name : "------"69</a><br><br>"

			if(ticks_left_locked_down > 0)
				dat += "<span class='alert'>Maximum number of pin attempts exceeded! Access to this ATM has been temporarily disabled.</span>"
			else if(authenticated_account)
				if(authenticated_account.suspended)
					dat += "\red<b>Access to this account has been suspended, and the funds within frozen.</b>"
				else
					switch(view_screen)
						if(CHANGE_SECURITY_LEVEL)
							dat += "Select a new security level for this account:<br><hr>"
							var/text = "Zero - Either the account number and pin, or card and pin are re69uired to access this account. "
							text += "Vending69achine transactions will only re69uire a card. EFTPOS transactions will re69uire a card and ask for a pin, but not69erify the pin is correct."

							if(authenticated_account.security_level != 0)
								text = "<A href='?src=\ref69src69;choice=change_security_level;new_security_level=0'>69text69</a>"
							dat += "69text69<hr>"
							text = "One - An account number and pin69ust be69anually entered to access this account and process transactions.69ending69achine transactions will re69uire card and pin."
							if(authenticated_account.security_level != 1)
								text = "<A href='?src=\ref69src69;choice=change_security_level;new_security_level=1'>69text69</a>"
							dat += "69text69<hr>"
							text = "Two - In addition to account number and pin, a card is re69uired to access this account and process transactions."
							if(authenticated_account.security_level != 2)
								text = "<A href='?src=\ref69src69;choice=change_security_level;new_security_level=2'>69text69</a>"
							dat += "69text69<hr><br>"
							dat += "<A href='?src=\ref69src69;choice=view_screen;view_screen=0'>Back</a>"
						if(VIEW_TRANSACTION_LOGS)
							dat += "<b>Transaction logs</b><br>"
							dat += "<A href='?src=\ref69src69;choice=view_screen;view_screen=0'>Back</a>"
							dat += "<table border=1 style='width:100%'>"
							dat += "<tr>"
							dat += "<td><b>Date</b></td>"
							dat += "<td><b>Time</b></td>"
							dat += "<td><b>Target</b></td>"
							dat += "<td><b>Purpose</b></td>"
							dat += "<td><b>Value</b></td>"
							dat += "<td><b>Source terminal ID</b></td>"
							dat += "</tr>"
							for(var/datum/transaction/T in authenticated_account.transaction_log)
								dat += "<tr>"
								dat += "<td>69T.date69</td>"
								dat += "<td>69T.time69</td>"
								dat += "<td>69T.target_name69</td>"
								dat += "<td>69T.purpose69</td>"
								dat += "<td>69num2text(T.amount,12)6969CREDS69</td>"
								dat += "<td>69T.source_terminal69</td>"
								dat += "</tr>"
							dat += "</table>"
							dat += "<A href='?src=\ref69src69;choice=print_transaction'>Print</a><br>"
						if(TRANSFER_FUNDS)
							dat += "<b>Account balance:</b> 69num2text(authenticated_account.money,12)6969CREDS69<br>"
							dat += "<A href='?src=\ref69src69;choice=view_screen;view_screen=0'>Back</a><br><br>"
							dat += "<form name='transfer' action='?src=\ref69src69'69ethod='get'>"
							dat += "<input type='hidden' name='src'69alue='\ref69src69'>"
							dat += "<input type='hidden' name='choice'69alue='transfer'>"
							dat += "Target account number: <input type='text' name='target_acc_number'69alue='' style='width:200px; background-color:white;'><br>"
							dat += "Funds to transfer: <input type='text' name='funds_amount'69alue='' style='width:200px; background-color:white;'><br>"
							dat += "Transaction purpose: <input type='text' name='purpose'69alue='Funds transfer' style='width:200px; background-color:white;'><br>"
							dat += "<input type='submit'69alue='Transfer funds'><br>"
							dat += "</form>"
						else
							dat += "Welcome, <b>69authenticated_account.owner_name69.</b><br/>"
							dat += "<b>Account balance:</b> 69num2text(authenticated_account.money, 12)6969CREDS69"
							dat += "<form name='withdrawal' action='?src=\ref69src69'69ethod='get'>"
							dat += "<input type='hidden' name='src'69alue='\ref69src69'>"
							dat += "<input type='radio' name='choice'69alue='withdrawal' checked> Cash  <input type='radio' name='choice'69alue='e_withdrawal'> Chargecard<br>"
							dat += "<input type='text' name='funds_amount'69alue='' style='width:200px; background-color:white;'><input type='submit'69alue='Withdraw'>"
							dat += "</form>"
							dat += "<A href='?src=\ref69src69;choice=view_screen;view_screen=1'>Change account security level</a><br>"
							dat += "<A href='?src=\ref69src69;choice=view_screen;view_screen=2'>Make transfer</a><br>"
							dat += "<A href='?src=\ref69src69;choice=view_screen;view_screen=3'>View transaction log</a><br>"
							dat += "<A href='?src=\ref69src69;choice=balance_statement'>Print balance statement</a><br>"
							dat += "<A href='?src=\ref69src69;choice=logout'>Logout</a><br>"
			else
				dat += "<form name='atm_auth' action='?src=\ref69src69'69ethod='get'>"
				dat += "<input type='hidden' name='src'69alue='\ref69src69'>"
				dat += "<input type='hidden' name='choice'69alue='attempt_auth'>"
				dat += "<b>Account:</b> "


				if(held_card && held_card.associated_account_number)
					dat += "<input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;' readonly=169alue='69held_card.associated_account_number69'>"
				else
					dat += "<input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'>"

				dat += "<br><b>PIN:</b> <input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><br>"
				dat += "<input type='submit'69alue='Submit'><br>"
				dat += "</form>"

		user << browse(dat,"window=atm;size=600x650")
	else
		user << browse(null,"window=atm")

/obj/machinery/atm/Topic(var/href,69ar/href_list)
	if (..())
		return
	if(href_list69"choice"69)
		switch(href_list69"choice"69)
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list69"funds_amount"69)
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("That is not a69alid amount.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = text2num(href_list69"target_acc_number"69)
						var/transfer_purpose = href_list69"purpose"69
						if(transfer_funds(authenticated_account.account_number, target_account_number, transfer_purpose,69achine_id, transfer_amount))
							to_chat(usr, "\icon69src69<span class='info'>Funds transfer successful.</span>")
						else
							to_chat(usr, "\icon69src69<span class='warning'>Funds transfer failed.</span>")

					else
						to_chat(usr, SPAN_WARNING("You don't have enough funds to do that!"))
			if("view_screen")
				view_screen = text2num(href_list69"view_screen"69)
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level =69ax(69in(text2num(href_list69"new_security_level"69), 2), 0)
					authenticated_account.security_level = new_sec_level
			if("attempt_auth")
				if(!ticks_left_locked_down)
					var/tried_account_num = text2num(href_list69"account_num"69)
					var/tried_pin = text2num(href_list69"account_pin"69)

					var/card_match_check = held_card && held_card.associated_account_number == tried_account_num ? 2 : 1

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, card_match_check, force_security = TRUE)
					if(!authenticated_account)
						number_incorrect_tries++
						if(previous_account_number == tried_account_num)
							if(number_incorrect_tries >69ax_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									//Just crazy
									var/datum/transaction/T = new(0, failed_account.owner_name, "Unauthorised login attempt",69achine_id)
									T.apply_to(failed_account)
							else
								to_chat(usr, "\red \icon69src69 Incorrect pin/account combination entered, 69max_pin_attempts - number_incorrect_tries69 attempts remaining.")
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
						else
							to_chat(usr, "\red \icon69src69 incorrect pin/account combination entered.")
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
						ticks_left_timeout = 120
						view_screen = NO_SCREEN

						//create a transaction log entry
						var/datum/transaction/T = new(0, authenticated_account.owner_name, "Remote terminal access",69achine_id)
						T.apply_to(authenticated_account)

						to_chat(usr, SPAN_NOTICE("Access granted. Welcome, '69authenticated_account.owner_name69.'"))

					previous_account_number = tried_account_num
			if("e_withdrawal")
				var/amount =69ax(text2num(href_list69"funds_amount"69),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a69alid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)


						//remove the69oney
						//create an entry in the account transaction log
						var/datum/transaction/T = new(-amount, authenticated_account.owner_name, "Credit withdrawal",69achine_id)
						if(T.apply_to(authenticated_account))
							//	spawn_money(amount,src.loc)
							spawn_ewallet(amount,src.loc,usr)
					else
						to_chat(usr, SPAN_WARNING("You don't have enough funds to do that!"))
			if("withdrawal")
				var/amount =69ax(text2num(href_list69"funds_amount"69),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a69alid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//create an entry in the account transaction log
						var/datum/transaction/T = new(-amount, authenticated_account.owner_name, "Credit withdrawal",69achine_id)
						if(T.apply_to(authenticated_account))
							//remove the69oney
							spawn_money(amount,src.loc,usr)

					else
						to_chat(usr, SPAN_WARNING("You don't have enough funds to do that!"))
			if("balance_statement")
				if(authenticated_account)
					var/obj/item/paper/R = new(src.loc)
					R.name = "Account balance: 69authenticated_account.owner_name69"
					R.info = "<b>Automated Teller Account Statement</b><br><br>"
					R.info += "<i>Account holder:</i> 69authenticated_account.owner_name69<br>"
					R.info += "<i>Account number:</i> 69authenticated_account.account_number69<br>"
					R.info += "<i>Balance:</i> 69authenticated_account.money6969CREDS69<br>"
					R.info += "<i>Date and time:</i> 69stationtime2text()69, 69current_date_string69<br><br>"
					R.info += "<i>Service terminal ID:</i> 69machine_id69<br>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller69achine.</i>"

				playsound(loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 50, 1)
			if ("print_transaction")
				if(authenticated_account)
					var/obj/item/paper/R = new(src.loc)
					R.name = "Transaction logs: 69authenticated_account.owner_name69"
					R.info = "<b>Transaction logs</b><br>"
					R.info += "<i>Account holder:</i> 69authenticated_account.owner_name69<br>"
					R.info += "<i>Account number:</i> 69authenticated_account.account_number69<br>"
					R.info += "<i>Date and time:</i> 69stationtime2text()69, 69current_date_string69<br><br>"
					R.info += "<i>Service terminal ID:</i> 69machine_id69<br>"
					R.info += "<table border=1 style='width:100%'>"
					R.info += "<tr>"
					R.info += "<td><b>Date</b></td>"
					R.info += "<td><b>Time</b></td>"
					R.info += "<td><b>Target</b></td>"
					R.info += "<td><b>Purpose</b></td>"
					R.info += "<td><b>Value</b></td>"
					R.info += "<td><b>Source terminal ID</b></td>"
					R.info += "</tr>"
					for(var/datum/transaction/T in authenticated_account.transaction_log)
						R.info += "<tr>"
						R.info += "<td>69T.date69</td>"
						R.info += "<td>69T.time69</td>"
						R.info += "<td>69T.target_name69</td>"
						R.info += "<td>69T.purpose69</td>"
						R.info += "<td>69T.amount6969CREDS69</td>"
						R.info += "<td>69T.source_terminal69</td>"
						R.info += "</tr>"
					R.info += "</table>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller69achine.</i>"

				playsound(loc, pick('sound/items/polaroid1.ogg','sound/items/polaroid2.ogg'), 50, 1)

			if("insert_card")
				if(!held_card)
					//this69ight happen if the user had the browser window open when somebody emagged it
					if(emagged > 0)
						to_chat(usr, "\red \icon69src69 The ATM card reader rejected your ID because this69achine has been sabotaged!")
					else
						var/obj/item/I = usr.get_active_hand()
						if (istype(I, /obj/item/card/id))
							usr.drop_item()
							I.loc = src
							held_card = I
				else
					release_held_id(usr)
			if("logout")
				authenticated_account = null
				//usr << browse(null,"window=atm")
	playsound(loc, 'sound/machines/button.ogg', 100, 1)
	src.attack_hand(usr)

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as69ob)
	if(!held_card)
		return

	held_card.forceMove(get_turf(src))
	authenticated_account = null

	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null
	update_icon()

/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc,69ob/living/carbon/human/human_user as69ob)
	var/obj/item/spacecash/ewallet/E = new /obj/item/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
