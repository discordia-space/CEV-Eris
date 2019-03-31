GLOBAL_DATUM_INIT(bounty_master, /datum/bounty_master, new)


/datum/bounty_master
	var/list/bounties = list()
	var/list/bounty_boards = list() //For craptain to set fees / withdraw fee cash.

/datum/bounty_master/proc/register_bounty(var/datum/bounty/F)
	if(!F)
		return
	bounties += F
	log_game("Bounty: [F.name] created by [F.owner]")
	for(var/X in bounty_boards) //Typeless loops are faster
		var/obj/structure/bounty_board/target = X
		playsound(target, 'sound/machines/buzz-two.ogg', 50, 1)
		target.visible_message("New bounty posted by [F.owner]!")
		target.icon_state = "bountyboard-alert"

/datum/bounty_master/proc/remove_bounty(var/datum/bounty/F)
	if(!F)
		return
	bounties -= F
	log_game("Bounty: [F.name] claimed by [F.claimedby]")
	qdel(F)

/datum/bounty
	var/name = "Kill clowns"
	var/desc = "Nothing"
	var/reward = 1 //In credits
	var/mob/living/carbon/human/owner //Who set this bounty
	var/mob/living/carbon/human/claimedby //Who completed this bounty, and was confirmed by the owner?
	var/list/claimants = list() //Who is trying to claim this bounty?
	var/icon = 'icons/obj/bountyboard.dmi'
	var/icon_state = "bounty-low"

/datum/bounty/test
	name = "Destroy cockroaches"
	desc = "Fucking roach is stealing my vodka kill it <br> I give very good prize to person who is kill it."
	reward = 1000
	icon_state = "bounty-med"
/*
Bounties by Kmc!

Click a bounty board to see all bounties, click the new option to make a bounty
Money is then taken from your account and added to the bounty. With a small fee going to the ship's acc.
Bounties can be claimed, which pings whoever set it. Payment is not automatic and the owner must swipe their card to confirm the claimant.
Upon claiming, the claimant gets the bounty money

*/

/obj/structure/bounty_board
	name = "Bounty board"
	desc = "Looking to earn? Perhaps you have a job that needs doing... In either case this board will give you a selection of jobs and payouts. Swipe it with a captain level ID to modify settings or withdraw takings."
	icon = 'icons/obj/bountyboard.dmi'
	icon_state = "bountyboard-off"
	req_one_access = list(access_captain, access_cent_captain)
	anchored = TRUE
	density = FALSE
	pixel_y = 25 //So it sits on the wall
	var/stored_credits = 0 //How much money have we collected from fees?
	var/fee_multiplier = 0.05 //5% default, craptain can change

/obj/structure/bounty_board/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/card/id))
		if(!ishuman(user))
			return ..()
		var/mob/living/carbon/human/human_user
		playsound(user.loc, 'sound/machines/id_swipe.ogg', 100, 1)
		if(check_access(I)) //Captain or admin logging in.
			var/list/options = list("raise_fee", "withdraw")
			for(var/option in options)
				options[option] = image(icon = icon, icon_state = "[option]")
			var/selected
			selected = show_radial_menu(user, src, options, radius = 42)
			if(!selected)
				return
			switch(selected)
				if("raise_fee")
					var/inflation = input("Enter a new transaction fee (max 100%)", "Enter Fee") as num
					if(inflation > 100)
						user << "<span class='warning'>You cannot set a fee above 100%</span>"
						return
					for(var/X in GLOB.bounty_master.bounty_boards)
						var/obj/structure/bounty_board/bb = X
						bb.fee_multiplier = (inflation / 100)
					user << "<span class='warning'>Global bounty fee set to [inflation]%</span>"
				if("withdraw")
					var/money = 0
					for(var/X in GLOB.bounty_master.bounty_boards)
						var/obj/structure/bounty_board/bb = X
						if(bb.stored_credits > 0)
							money += bb.stored_credits
							bb.stored_credits = 0
					if(money > 0)
						var/obj/item/weapon/card/id/held_card = I
						if(!held_card) //fuck if i know how this happened but hey ho
							return
						var/tried_account_num = input("Enter account number", "[name]") as num
						var/tried_pin = input("Enter PIN number", "[name]") as num
						if(!tried_account_num || !tried_pin)
							user << "<span class='warning'>You must enter a valid bank account + PIN to withdraw fees!</span>"
							return
						var/datum/money_account/authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
						if(authenticated_account)
							playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
							user << "<span class='warning'>Fee takings withdrawn.</span>"
							var/obj/item/weapon/spacecash/ewallet/E = new /obj/item/weapon/spacecash/ewallet(loc)
							if(ishuman(human_user) && !human_user.get_active_hand())
								human_user.put_in_hands(E)
							E.worth = money
							E.owner_name = authenticated_account.owner_name
					else
						user << "<span class='warning'>No machines have collected any fees.</span>"
	else
		. = ..()

/obj/structure/bounty_board/Initialize()
	. = ..()
	GLOB.bounty_master.bounty_boards += src

/obj/structure/bounty_board/attack_hand(mob/theuser)
	if(!ishuman(theuser))
		return
	icon_state = initial(icon_state) //Remove the alert icon.
	var/mob/living/carbon/human/user = theuser
	var/list/options = list("read", "create", "claim")
	var/owns_bounty = FALSE //Do they own a bounty? used to avoid spamming their radial with buttons.
	for(var/datum/bounty/F in GLOB.bounty_master.bounties)
		if(F.owner == user && !owns_bounty)
			options += "confirm_bounty"
			owns_bounty = TRUE
		if(F.claimedby == user)
			var/obj/item/weapon/card/id/held_card = user.get_idcard()
			if(!held_card) //fuck if i know how this happened but hey ho
				return
			var/tried_account_num = input("Enter account number to claim your reward", "[name]") as num
			var/tried_pin = input("Enter PIN number", "[name]") as num
			if(!tried_account_num || !tried_pin)
				user << "<span class='warning'>You must enter a valid bank account + PIN to accept a bounty!</span>"
				return
			var/datum/money_account/authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
			if(authenticated_account)
				playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
				user << "<span class='warning'>Bounty reward claimed.</span>"
				var/obj/item/weapon/spacecash/ewallet/E = new /obj/item/weapon/spacecash/ewallet(loc)
				if(!user.get_active_hand())
					user.put_in_hands(E)
				E.worth = F.reward
				E.owner_name = authenticated_account.owner_name
				GLOB.bounty_master.remove_bounty(F)
	var/selected
	for(var/option in options)
		options[option] = image(icon = icon, icon_state = "[option]")
	selected = show_radial_menu(user, src, options, radius = 42)
	if(!selected)
		return
	switch(selected)
		if("read")
			if(!GLOB.bounty_master.bounties.len)
				user << "<span class='warning'>There are no bounties listed at the moment.</span>"
			var/datum/bounty/A = input(user,"Bounties:", "[name]", null) as anything in GLOB.bounty_master.bounties
			if(A)
				view_bounty(A)
		if("create")
			var/new_name = input(user,"Enter a name for your bounty","Bounty Board.") as text
			new_name = sanitize_text(new_name)
			if(!new_name)
				return
			var/new_desc = input(user,"Enter a description for your bounty (so people know what to do).","Bounty Board.")
			new_desc = sanitize_text(new_desc) //DROP_TABLE(*)
			if(!new_desc)
				return
			var/reward = input("Enter a reward (in credits)", "Enter reward") as num
			if(!reward)
				return
			if(alert(user, "Are you sure you want to create this bounty ([new_name]). [reward] credits will be instantly debited from your account with a [fee_multiplier*100]% service charge.","[name]", "Yes", "No") == "No")
				return
			var/obj/item/weapon/card/id/held_card = user.get_idcard()
			if(!held_card)
				user << "<span class='warning'>You don't seem to be wearing an ID. Bounty creation cancelled.</span>"
			var/tried_account_num = input("Enter account number", "[name]") as num
			var/tried_pin = input("Enter PIN number", "[name]") as num
			if(!tried_account_num || !tried_pin)
				user << "<span class='warning'>You must enter a valid bank account + PIN to create a bounty!</span>"
				return
			var/datum/money_account/authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
			if(authenticated_account)
				var/fee = (reward*fee_multiplier) //Service charge. Craptain can configure, defaults to 5%
				var/charge = (reward + fee)
				var/datum/transaction/T = new(-charge, authenticated_account.owner_name, "Bounty Placed", "[name]")
				if(T.apply_to(authenticated_account))
					user << "<span class='warning'>Bounty created. You will be notified when someone submits a claim so you can reward them!</span>"
					playsound(user.loc, 'sound/machines/id_swipe.ogg', 100, 1)
					stored_credits += fee
				else
					user << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"
					return
				var/datum/bounty/thebounty = new
				thebounty.name = new_name
				thebounty.desc = new_desc
				thebounty.reward = reward
				thebounty.owner = user
				GLOB.bounty_master.register_bounty(thebounty)
			else
				user << "<span class='warning'>You need to have a bank account to do that!</span>"
		if("claim")
			if(!GLOB.bounty_master.bounties.len)
				user << "<span class='warning'>There are no bounties listed at the moment.</span>"
			var/datum/bounty/A = input(user,"Which bounty would you like to claim? (Sponsor must confirm before you are rewarded):", "[name]", null) as anything in GLOB.bounty_master.bounties
			if(A)
				claim_bounty(A, user)
			return
		if("confirm_bounty")
			var/datum/bounty/A = input(user,"Bounties you own:", "[name]", null) as anything in GLOB.bounty_master.bounties
			if(A)
				if(A.claimedby)
					user << "<span class='warning'>This bounty was already claimed.</span>"
					return
				if(!A.claimants.len)
					user << "<span class='warning'>Nobody has submitted a claim for this bounty.</span>"
					return
				if(A.claimants.len == 1) //Just one person. If we had an input list here it'd just insta accept.
					var/mob/living/carbon/human/X = locate(/mob/living/carbon/human) in A.claimants
					if(alert(user, "[X] has submitted a bounty claim for [A.name], do you wish to accept their claim?.","[name]", "Yes", "No") == "No")
						A.claimants -= X
						X << "<span class='warning'>Your bounty claim for [A.name] was rejected.</span>"
						return
					else
						X << "<span class='warning'>Your bounty claim for [A.name] was accepted! Find a bounty console to claim your reward.</span>"
						A.claimedby = X
				else
					var/mob/living/carbon/human/H = input(user,"There are several claimants, whose claim would you like to accept?", "[name]", null) as anything in A.claimants
					for(var/XD in A.claimants)
						XD << "<span class='warning'>Your bounty claim for [A.name] was rejected.</span>"
						A.claimants -= XD
					H << "<span class='warning'>Your bounty claim for [A.name] was accepted! Find a bounty console to claim your reward.</span>"
					A.claimedby = H

/obj/structure/bounty_board/proc/claim_bounty(var/datum/bounty/target,var/mob/user)
	if(!target)
		return
	target.claimants += user
	if(!target.owner) //Welp. That shouldn't happen
		message_admins("Someone tried to claim bounty: [target] but it had no owner.")
		return
	target.owner << "<span class='warning'>[user] has submitted a claim for your bounty! ([target.name]). Please visit a bounty board to reject or confirm this claim.</span>"

/obj/structure/bounty_board/proc/view_bounty(var/datum/bounty/target)
	if(target) //Theyve clicked our bounty. Nice.
		var/colour = "#008000"//Goes from green - > red in order of payment
		switch(target.reward)
			if(0 to 100)
				colour = "#008000"
			if(100 to 200)
				colour = "#FFFF00"
			if(200 to 300)
				colour = "#FF0000"
			if(300 to 100000000)
				colour = "#B22222"
		var/dat = "<!DOCTYPE html>\
		<html>\
		<head>\
		<style>\
		div.transbox {\
			margin: 30px;\
			opacity: 1;\
			width:90%;\
			filter: alpha(opacity=100);\
			padding: 12px 20px;\
			box-sizing: border-box;\
			border: 2px solid [colour];\
			border-radius: 4px;\
			border-style: outset;\
			background-color: #383838;\
			max-height: 200px;\
			overflow-y: auto;\
			align-content: left;\
			scrollbar-face-color:[colour];\
			scrollbar-arrow-color:[colour];\
			scrollbar-track-color:[colour];\
			scrollbar-highlight-color:[colour];\
			scrollbar-darkshadow-Color:[colour];\
		}\
		</style>\
		</head>\
		<body>\
		<div class='transbox'>\
			<p><FONT color='#98b0c3'><b>Name: [target.name]</b></font></p>\
			<p><FONT color='#98b0c3'><b> Description: </b> <br>[target.desc]</font></p>\
			<p><FONT color='#98b0c3'><b> Reward: </b> <br>[target.reward] credits</font></p>\
			<p><FONT color='#98b0c3'><b> Sponsor: </b> <br>[target.owner]</font></p>\
			<p><FONT color='#98b0c3'><b> -Sponsor must confirm bounty completion before funds are rewarded-</font></p>\
		</div>\
		</body>\
		</html>"
		var/datum/browser/popup = new(usr, "bounty menu", name, 590, 400)
		popup.set_content(dat)
		popup.open()