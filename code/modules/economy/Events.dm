
/datum/event/economic_event
	endWhen = 50			//this will be set randomly, later
	announceWhen = 15
	var/event_type = 0
	var/list/cheaper_goods = list()
	var/list/dearer_goods = list()
	var/datum/trade_destination/affected_dest

/datum/event/economic_event/start()
	affected_dest = pickweight(weighted_randomevent_locations)
	if(affected_dest.viable_random_events.len)
		endWhen = rand(60,300)
		event_type = pick(affected_dest.viable_random_events)

		if(!event_type)
			return

		switch(event_type)
			if(RIOTS)
				dearer_goods = list(SECURITY)
				cheaper_goods = list(MINERALS, FOOD)
			if(WILD_ANIMAL_ATTACK)
				cheaper_goods = list(ANIMALS)
				dearer_goods = list(FOOD, BIOMEDICAL)
			if(INDUSTRIAL_ACCIDENT)
				dearer_goods = list(EMERGENCY, BIOMEDICAL, ROBOTICS)
			if(BIOHAZARD_OUTBREAK)
				dearer_goods = list(BIOMEDICAL, GAS)
			if(PIRATES)
				dearer_goods = list(SECURITY,69INERALS)
			if(CORPORATE_ATTACK)
				dearer_goods = list(SECURITY,69AINTENANCE)
			if(ALIEN_RAIDERS)
				dearer_goods = list(BIOMEDICAL, ANIMALS)
				cheaper_goods = list(GAS,69INERALS)
			if(AI_LIBERATION)
				dearer_goods = list(EMERGENCY, GAS,69AINTENANCE)
			if(MOURNING)
				cheaper_goods = list(MINERALS,69AINTENANCE)
			if(CULT_CELL_REVEALED)
				dearer_goods = list(SECURITY, BIOMEDICAL,69AINTENANCE)
			if(SECURITY_BREACH)
				dearer_goods = list(SECURITY)
			if(ANIMAL_RIGHTS_RAID)
				dearer_goods = list(ANIMALS)
			if(FESTIVAL)
				dearer_goods = list(FOOD, ANIMALS)
		for(var/good_type in dearer_goods)
			affected_dest.temp_price_change69good_type69 = rand(1,100)
		for(var/good_type in cheaper_goods)
			affected_dest.temp_price_change69good_type69 = rand(1,100) / 100

/datum/event/economic_event/announce()
	var/author = "Nyx Daily"
	var/channel = author

	//see if our location has custom event info for this event
	var/body = affected_dest.get_custom_eventstring()
	if(!body)
		switch(event_type)
			if(RIOTS)
				body = "69pick("Riots have","Unrest has")69 broken out on planet 69affected_dest.name69. Authorities call for calm, as 69pick("various parties","rebellious elements","peacekeeping forces","\'REDACTED\'")69 begin stockpiling weaponry and armour.69eanwhile, food and69ineral prices are dropping as local industries attempt empty their stocks in expectation of looting."
			if(WILD_ANIMAL_ATTACK)
				body = "Local 69pick("wildlife","animal life","fauna")69 on planet 69affected_dest.name69 has been increasing in agression and raiding outlying settlements for food. Big game hunters have been called in to help alleviate the problem, but numerous injuries have already occurred."
			if(INDUSTRIAL_ACCIDENT)
				body = "69pick("An industrial accident","A smelting accident","A69alfunction","A69alfunctioning piece of69achinery","Negligent69aintenance","A cooleant leak","A ruptured conduit")69 at a 69pick("factory","installation","power plant","dockyards")69 on 69affected_dest.name69 resulted in severe structural damage and numerous injuries. Repairs are ongoing."
			if(BIOHAZARD_OUTBREAK)
				body = "69pick("A \'REDACTED\'","A biohazard","An outbreak","A69irus")69 on 69affected_dest.name69 has resulted in quarantine, stopping69uch shipping in the area. Although the quarantine is now lifted, authorities are calling for deliveries of69edical supplies to treat the infected, and gas to replace contaminated stocks."
			if(PIRATES)
				body = "69pick("Pirates","Criminal elements","A 69pick("mercenary","Donk Co.","Waffle Co.","\'REDACTED\'")69 strike force")69 have 69pick("raided","blockaded","attempted to blackmail","attacked")69 69affected_dest.name69 today. Security has been tightened, but69any69aluable69inerals were taken."
			if(CORPORATE_ATTACK)
				body = "A small 69pick("pirate","Cybersun Industries","Gorlex69arauders","mercenary")69 fleet has precise-jumped into proximity with 69affected_dest.name69, 69pick("for a smash-and-grab operation","in a hit and run attack","in an overt display of hostilities")69.69uch damage was done, and security has been tightened since the incident."
			if(ALIEN_RAIDERS)
				if(prob(20))
					body = "The Tiger Co-operative have raided 69affected_dest.name69 today, no doubt on orders from their enigmatic69asters. Stealing wildlife, farm animals,69edical research69aterials and kidnapping civilians. 69company_name69 authorities are standing by to counter attempts at bio-terrorism."
				else
					body = "69pick("The alien species designated \'United Exolitics\'","The alien species designated \'REDACTED\'","An unknown alien species")69 have raided 69affected_dest.name69 today, stealing wildlife, farm animals,69edical research69aterials and kidnapping civilians. It seems they desire to learn69ore about us, so the Navy will be standing by to accomodate them next time they try."
			if(AI_LIBERATION)
				body = "A 69pick("\'REDACTED\' was detected on","S.E.L.F operative infiltrated","malignant computer69irus was detected on","rogue 69pick("slicer","hacker")69 was apprehended on")69 69affected_dest.name69 today, and69anaged to infect 69pick("\'REDACTED\'","a sentient sub-system","a class one AI","a sentient defence installation")69 before it could be stopped.69any lives were lost as it systematically begin69urdering civilians, and considerable work69ust be done to repair the affected areas."
			if(MOURNING)
				body = "69pick("The popular","The well-liked","The eminent","The well-known")69 69pick("professor","entertainer","singer","researcher","public servant","administrator","ship captain","\'REDACTED\'")69, 69pick( random_name(pick(MALE,FEMALE)), 40; "\'REDACTED\'" )69 has 69pick("passed away","committed suicide","been69urdered","died in a freakish accident")69 on 69affected_dest.name69 today. The entire planet is in69ourning, and prices have dropped for industrial goods as worker69orale drops."
			if(CULT_CELL_REVEALED)
				body = "A 69pick("dastardly","blood-thirsty","villanous","crazed")69 cult of 69pick("The Elder Gods","Nar'sie","an apocalyptic sect","\'REDACTED\'")69 has 69pick("been discovered","been revealed","revealed themselves","gone public")69 on 69affected_dest.name69 earlier today. Public69orale has been shaken due to 69pick("certain","several","one or two")69 69pick("high-profile","well known","popular")69 individuals 69pick("performing \'REDACTED\' acts","claiming allegiance to the cult","swearing loyalty to the cult leader","promising to aid to the cult")69 before those involved could be brought to justice. The editor reminds all personnel that supernatural69yths will not be tolerated on 69company_name69 facilities."
			if(SECURITY_BREACH)
				body = "There was 69pick("a security breach in","an unauthorised access in","an attempted theft in","an anarchist attack in","violent sabotage of")69 a 69pick("high-security","restricted access","classified","\'REDACTED\'")69 69pick("\'REDACTED\'","section","zone","area")69 this69orning. Security was tightened on 69affected_dest.name69 after the incident, and the editor reassures all 69company_name69 personnel that such lapses are rare."
			if(ANIMAL_RIGHTS_RAID)
				body = "69pick("Militant animal rights activists","Members of the terrorist group Animal Rights Consortium","Members of the terrorist group \'REDACTED\'")69 have 69pick("launched a campaign of terror","unleashed a swathe of destruction","raided farms and pastures","forced entry to \'REDACTED\'")69 on 69affected_dest.name69 earlier today, freeing numerous 69pick("farm animals","animals","\'REDACTED\'")69. Prices for tame and breeding animals have spiked as a result."
			if(FESTIVAL)
				body = "A 69pick("festival","week long celebration","day of revelry","planet-wide holiday")69 has been declared on 69affected_dest.name69 by 69pick("Governor","Commissioner","General","Commandant","Administrator")69 69random_name(pick(MALE,FEMALE))69 to celebrate 69pick("the birth of their 69pick("son","daughter")69","coming of age of their 69pick("son","daughter")69","the pacification of rogue69ilitary cell","the apprehension of a69iolent criminal who had been terrorising the planet")69.69assive stocks of food and69eat have been bought driving up prices across the planet."

	news_network.SubmitArticle(body, author, channel, null, 1)

/datum/event/economic_event/end()
	for(var/good_type in dearer_goods)
		affected_dest.temp_price_change69good_type69 = 1
	for(var/good_type in cheaper_goods)
		affected_dest.temp_price_change69good_type69 = 1
