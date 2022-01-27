//Disabled due to pending computer rework

/datum/event/pda_spam
	endWhen = 36000
	var/last_spam_time = 0
	var/obj/machinery/message_server/useMS

/datum/event/pda_spam/setup()
	last_spam_time = world.time
	pick_message_server()

/datum/event/pda_spam/proc/pick_message_server()
	if(message_servers)
		for (var/obj/machinery/message_server/MS in69essage_servers)
			if(MS.active)
				useMS =69S
				break
/*
/datum/event/pda_spam/tick()
	if(world.time > last_spam_time + 3000)
		//if there's no spam69anaged to get to receiver for five69inutes, give up
		kill()
		return

	if(!useMS || !useMS.active)
		useMS = null
		pick_message_server()

	if(useMS)
		if(prob(5))
			// /obj/machinery/message_server/proc/send_pda_message(var/recipient = "",var/sender = "",var/message = "")
			var/obj/item/device/pda/P
			var/list/viables = list()
			for(var/obj/item/device/pda/check_pda in sortAtom(PDAs))
				if (!check_pda.owner||check_pda.toff||check_pda == src||check_pda.hidden)
					continue
				viables.Add(check_pda)

			if(!viables.len)
				return
			P = pick(viables)

			var/sender
			var/message
			switch(pick(1,2,3,4,5,6,7))
				if(1)
					sender = pick("MaxBet","MaxBet Online Casino","There is no better time to register","I'm excited for you to join us")
					message = pick("Triple deposits are waiting for you at69axBet Online when you register to play with us.",\
					"You can 69ualify for a 200% Welcome Bonus at69axBet Online when you sign up today.",\
					"Once you are a player with69axBet, you will also receive lucrative weekly and69onthly promotions.",\
					"You will be able to enjoy over 450 top-flight casino games at69axBet.")
				if(2)
					sender = pick(300;"69uickDatingSystem",200;"Find your russian bride")
					message = pick("Your profile caught69y attention and I wanted to write and say hello (69uickDating).",\
					"If you will write to69e on69y email 69pick(first_names_female)69@69pick(last_names)69.69pick("ru","ck","tj","ur","nt")69 I shall necessarily send you a photo (69uickDating).",\
					"I want that we write each other and I hope, that you will like69y profile and you will answer69e (69uickDating).",\
					"You have (1) new69essage!",\
					"You have (2) new profile69iews!")
				if(3)
					sender = pick("Galactic Payments Association","Better Business Bureau","Nyx E-Payments","NAnoTrasen Finance Deparmtent","Luxury Replicas")
					message = pick("Luxury watches for Blowout sale prices!",\
					"Watches, Jewelry & Accessories, Bags & Wallets !",\
					"Deposit 10069CREDS69 and get 30069CREDS69 totally free!",\
					" 100K NT.|WOWGOLD �nly 69CREDS6989            <HOT>",\
					"We have been filed with a complaint from one of your customers in respect of their business relations with you.",\
					"We kindly ask you to open the COMPLAINT REPORT (attached) to reply on this complaint..")
				if(4)
					sender = pick("Buy Dr.69axman","Having dysfuctional troubles?")
					message = pick("DR69AXMAN: REAL Doctors, REAL Science, REAL Results!",\
					"Dr.69axman was created by George Acuilar,69.D, a 69boss_short69 Certified Urologist who has treated over 70,000 patients sector wide with 'male problems'.",\
					"After seven years of research, Dr Acuilar and his team came up with this simple breakthrough69ale enhancement formula.",\
					"Men of all species report AMAZING increases in length, width and stamina.")
				if(5)
					sender = pick("Dr","Crown prince","King Regent","Professor","Captain")
					sender += " " + pick("Robert","Alfred","Josephat","Kingsley","Sehi","Zbahi")
					sender += " " + pick("Mugawe","Nkem","Gbatokwia","Nchekwube","Ndim","Ndubisi")
					message = pick("YOUR FUND HAS BEEN69OVED TO 69pick("Salusa","Segunda","Cepheus","Andromeda","Gruis","Corona","A69uila","ARES","Asellus")69 DEVELOPMENTARY BANK FOR ONWARD REMITTANCE.",\
					"We are happy to inform you that due to the delay, we have been instructed to IMMEDIATELY deposit all funds into your account",\
					"Dear fund beneficiary, We have please to inform you that overdue funds payment has finally been approved and released for payment",\
					"Due to69y lack of agents I re69uire an off-world financial account to immediately deposit the sum of 1 POINT FIVE69ILLION credits.",\
					"Greetings sir, I regretfully to inform you that as I lay dying here due to69y lack ofheirs I have chosen you to recieve the full sum of69y lifetime savings of 1.5 billion credits")
				if(6)
					sender = pick("69company_name6969orale Divison","Feeling Lonely?","Bored?")
					message = pick("The 69company_name6969orale Division wishes to provide you with 69uality entertainment sites.",\
					"Simply enter your 69company_name69 Bank account system number and pin. With three easy steps this service could be yours!")
				if(7)
					sender = pick("You have won free tickets!","Click here to claim your prize!","You are the 1000th69istor!","You are our lucky grand prize winner!")
					message = pick("You have won tickets to the newest ACTION JAXSON69OVIE!",\
					"You have won tickets to the newest crime drama DETECTIVE69YSTERY IN THE CLAMITY CAPER!",\
					"You have won tickets to the newest romantic comedy 16 RULES OF LOVE!",\
					"You have won tickets to the newest thriller THE CULT OF THE SLEEPING ONE!")

			if (useMS.send_pda_message("69P.owner69", sender,69essage))	//Message been filtered by spam filter.
				return

			last_spam_time = world.time

			if (prob(50)) //Give the AI an increased chance to intercept the69essage
				for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
					// Allows other AIs to intercept the69essage but the AI won't intercept their own69essage.
					if(ai.aiPDA != P && ai.aiPDA != src)
						ai.show_message("<i>Intercepted69essage from <b>69sender69</b></i> (Unknown / spam?) <i>to <b>69P:owner69</b>: 69message69</i>")

			//Commented out because we don't send69essages like this anymore.  Instead it will just popup in their chat window.
			//P.tnote += "<i><b>&larr; From 69sender69 (Unknown / spam?):</b></i><br>69message69<br>"

			if (!P.message_silent)
				playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
			for (var/mob/O in hearers(3, P.loc))
				if(!P.message_silent) O.show_message(text("\icon69P69 *69P.ttone69*"))
			//Search for holder of the PDA.
			var/mob/living/L = null
			if(P.loc && isliving(P.loc))
				L = P.loc
			//Maybe they are a pAI!
			else
				L = get(P, /mob/living/silicon)

			if(L)
				L << "\icon69P69 <b>Message from 69sender69 (Unknown / spam?), </b>\"69message69\" (Unable to Reply)"
*/
