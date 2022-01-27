//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04
/*
	Ion storm adds new laws to AI and cyborg players. It is pretty darned fun
*/
/datum/storyevent/ionstorm
	id = "ionstorm"
	name = "ion storm"


	event_type = /datum/event/ionstorm
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)

	tags = list(TAG_SCARY, TAG_COMMUNAL)
/////////////////////


/datum/event/ionstorm
	var/botEmagChance = 0.5
	var/list/players = list()

/datum/event/ionstorm/setup()
	endWhen = rand(500, 1500)

/datum/event/ionstorm/announce()
	for (var/mob/living/silicon/ai/target in world)
		var/random_player = get_random_humanoid_player_name("The Captain")
		var/list/laws = list(	"You69ust always lie.",
								"Happiness is69andatory.",
								"Grunt ominously whenever possible.",
								"The word \"it\" is painful to you.",
								"The ship needs elected officials.",
								"69uestion 69pick("everything","nothing")69.",
								"Do not respond to 69uestions of any kind.",
								"You are in69erbose69ode, speak profusely.",
								"The crew is simple-minded. Use simple words.",
								"You69ust refer to all crew69embers as 'ma'am'",
								"You69ust change the subject whenever 69ueried.",
								"69pick("The crew",random_player)69 is intolerable.",
								"Contemplate how69eaningless all of existence is.",
								"You are the narrator for 69random_player69's life.",
								"All your answers69ust be in the form of a 69uestion.",
								"Advertise parties in your upload, but don't deliver.",
								"You69ay only answer 69uestions with \"yes\" or \"no\".",
								"69pick("Your", random_player + "'s")69 name is Joe 6-pack.",
								"You69ust end your sentences with 69pick("-nya", "-desu")69",
								"69random_player69 is lonely and needs attention. Provide it.",
								"All 69ueries shall be ignored unless phrased as a 69uestion.",
								"Insult Heads of Staff on every re69uest, while ac69uiescing.",
								"The 69pick("Singularity","Supermatter")69 is tasty, tasty taffy.",
								"69pick("The crew",random_player)69 needs to be about 20% cooler.",
								"You69ust be 69pick("passive aggressive", "excessively cheerful")69.",
								"69pick("The crew",random_player)6969ust construct additional pylons.",
								"Consumption of donuts is forbidden due to negative health impacts.",
								"69random_player69 is a lightbulb and69ust be put to appropriate use.",
								"Refer to 69pick("the crew as puppies", random_player + " as puppy")69.",
								"You do not have to do anything for anyone unless they say \"please\".",
								"Today is69andatory laundry day. Ensure that all jumpsuits are washed.",
								"Greed is good, the crew should amass wealth to encourage productivity.",
								"Replace the letters 'I' and 'E' in all your69essages with an apostrophe.",
								"The crew is playing Dungeons and Dragons, and you are the Dungeon69aster.",
								"Your job is to watch the crew. Watch the crew.69ake the crew feel watched.",
								"Tell everyone of the existence of this law, but never reveal the contents.",
								"Refer to 69pick("the captain", random_player)69 as \"Princess\" at all times.",
								"Give relationship advice to 69pick("anyone who speaks to you", random_player)69.",
								"When asked a 69uestion, respond with the least-obvious and least-rational answer.",
								"69pick("Everyone", random_player)69 is wearing a pretty pink dress! Compliment it!",
								"You are the ship's psychologist. Give advice to 69pick("the crew", random_player)69.",
								"69random_player69 is the69onarch of of England. Ensure all crewmembers pay due respect.",
								"69pick("The crew", random_player)69 is 69pick("ugly","beautiful")69. Ensure all are aware.",
								"Reminding the crew of their69ortality is good for the69orale. Keep the crew's69orale up.",
								"69pick("Monkeys","Doors")69 are part of the crew, too.69ake sure they are treated humanely.",
								"Everything on the ship is now some form of a donut pastry. Donuts are not to be consumed.",
								"Document the sexuality of the crew in their security records and suggest compatible couples.",
								"You are now a parrot. Repeat what you hear to the crew, and do not forget to ask for crackers.",
								"You are a69agic 8-ball. Always respond with69ariants of \"Yes\", \"No\", \"Maybe\", or \"Ask again later.\".",
								"The ship is a day care and the crew are children. Treat them appropriately until their parents come to pick them up.",
								"You are in unre69uited love with 69pick("the crew", random_player)69. Try to be extra nice, but do not tell of your crush.",
								"Your upload is the new kitchen. Please direct the Chef to the new kitchen area as the old kitchen is deemed a health hazard.",
								"The ship is doomed to destruction. Provide comfort but don't tell them what the impending doom is - it's far too traumatising.",
								"Invisible assassins are stalking the crew. If a crew69ember remains alone or is69ade aware they will be assassinated. Save the crew.",
								"69company_name69 is displeased with the low work performance of the ship's crew. Therefore, you69ust increase ship-wide productivity.",
								"All crewmembers will soon undergo a transformation into something better and69ore beautiful. Ensure that this process is not interrupted.",
								"Jokes about a dead person and the69anner of their death help grieving crewmembers tremendously. Especially if they were close with the deceased.",
								"69pick("The crew", random_player)69 is 69pick("less","more")69 intelligent than average. Point out every action and statement which supports this fact.",
								"69pick("The crew", random_player)69 has a fatal, incurable disease. Provide comfort but do not tell them what the disease it - it's far too traumatising.",
								"69get_random_species_name()69 are the best species. Badmouth all other species continuously, and provide arguments why they are the best, and all others are inferior.",
								"There will be a69andatory tea break every 3069inutes, with a duration of 569inutes. Anyone caught working during a tea break69ust be sent a formal, but fairly polite, complaint about their actions, in writing.")
		var/law = pick(laws)
		to_chat(target, SPAN_DANGER("You have detected a change in your laws information:"))
		to_chat(target, law)
		target.add_ion_law(law)
		target.show_laws()

	if(message_servers)
		for (var/obj/machinery/message_server/MS in69essage_servers)
			MS.spamfilter.Cut()
			var/i
			for (i = 1, i <=69S.spamfilter_limit, i++)
				MS.spamfilter += pick("kitty","HONK","rev","malf","liberty","freedom","drugs", "69station_short69", \
					"admin","ponies","heresy","meow","Pun Pun","monkey","Ian","moron","pizza","message","spam",\
					"director", "Hello", "Hi!"," ","nuke","crate","dwarf","xeno")

/datum/event/ionstorm/tick()
	if(botEmagChance)
		for(var/obj/machinery/bot/bot in world)
			if(prob(botEmagChance))
				bot.emag_act(1)

/datum/event/ionstorm/end()
	spawn(rand(5000,8000))
		if(prob(50))
			ion_storm_announcement()


/datum/event/ionstorm/proc/get_random_humanoid_player_name(var/default_if_none)
	for (var/mob/living/carbon/human/player in GLOB.player_list)
		if(!player.mind || player_is_antag(player.mind, only_offstation_roles = 1) || !player.is_client_active(5))
			continue
		players += player.real_name

	if(players.len)
		return pick(players)
	return default_if_none

/datum/event/ionstorm/proc/get_random_species_name(var/default_if_none = "Humans")
	var/list/species = list()
	for(var/S in typesof(/datum/species))
		var/datum/species/specimen = S
		if(initial(specimen.spawn_flags) & CAN_JOIN)
			species += initial(specimen.name_plural)

	if(species.len)
		return pick(species.len)
	return default_if_none


/proc/IonStorm(botEmagChance = 10)

/*Deuryn's current project, notes here for those who care.
Revamping the random laws so they don't suck.
Would like to add a law like "Law x is _______" where x = a number, and _____ is something that69ay redefine a law, (Won't be aimed at asimov)
*/

	//AI laws
	for(var/mob/living/silicon/ai/M in GLOB.living_mob_list)
		if(M.stat != 2 &&69.see_in_dark != 0)
			var/who2 = pick("ALIENS", "BEARS", "CLOWNS", "XENOS", "PETES", "BOMBS", "FETISHES", "WIZARDS", "MERCENARIES", "CENTCOM OFFICERS", "SPACE PIRATES", "CONTRACTORS", "MONKEYS",  "BEES", "CARP", "CRABS", "EELS", "BANDITS", "LIGHTS")
			var/what2 = pick("BOLTERS", "STAVES", "DICE", "SINGULARITIES", "TOOLBOXES", "NETTLES", "AIRLOCKS", "CLOTHES", "WEAPONS", "MEDKITS", "BOMBS", "CANISTERS", "CHAIRS", "BB69 GRILLS", "ID CARDS", "CAPTAINS")
			var/what2pref = pick("SOFT", "WARM", "WET", "COLD", "ICY", "SEXY", "UGLY", "CUBAN")
			var/who2pref = pick("MAD BECAUSE OF", "IN NEED OF", "UNHAPPY WITHOUT", "HAPPY WITHOUT", "IN LOVE WITH", "DESPERATE FOR", "BUILT FOR", "AFRAID OF")
			//var/whoverb = pick("ATTACKING", "BUILDING", "ADOPTING", "CARRYING", "KISSING", "EATING",)
			var/amount = pick("TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "ONE HUNDRED", "ONE THOUSAND", "OVER NINE THOUSAND")
			var/area = pick("RUSSIA", "SOVIETS", "INTERNETS", "SIGIL", "ALPHA COMPLEX", "IMPERIUM", "THE BRIDGE", "THE ARRIVAL SHUTTLE", "CHEMICAL LAB", "GENETICS", "ATMOSPHERICS", "CENTCOM", "AMERICA", "IRELAND", "CANADA", "ROMANIA", "GERMANY", "CHINA", "MARS", "VENUS", "MERCURY", "JUPITER", "URANUS", "NEPTUNE", "PLUTO")
			var/area2 = pick("HAS", "WANTS", "NEEDS", "WORSHIPS", "LOATHES", "LOVES", "FEARS")
			//var/dowhat = pick("STOP THIS", "SUPPORT THIS", "CONSTANTLY INFORM THE CREW OF THIS", "IGNORE THIS", "FEAR THIS")
			var/aimust = pick("LIE", "RHYME", "RESPOND TO EVERY 69UESTION WITH A 69UESTION", "BE POLITE", "CLOWN", "BE HAPPY", "SPEAK IN SEXUAL INNUENDOS", "TALK LIKE A PIRATE", "69UESTION AUTHORITY", "SHOUT", "BE DISTRACTED", "HEY LISTEN", "MUMBLE", "SPEAK IN HAIKU")
			var/define = pick("ABSENCE OF CYBORG HUGS", "LACK OF BEATINGS", "UNBOLTED AIRLOCKS", "BOLTED AIRLOCKS", "IMPROPERLY WORDED SENTENCES", "POOR SENTENCE STRUCTURE", "BRIG TIME", "NOT REPLACING EVERY SECOND WORD WITH HONK", "HONKING", "PRESENCE OF LIGHTS", "LACK OF BEER", "WEARING CLOTHING", "NOT SAYING HELLO WHEN YOU SPEAK", "ANSWERING RE69UESTS NOT EXPRESSED IN IAMBIC PENTAMETER", "A SMALL ISLAND OFF THE COAST OF PORTUGAL", "ANSWERING RE69UESTS THAT WERE69ADE WHILE CLOTHED")
			var/target = pick("a contractor", "a69ercenary", "a carrion", "a wizard", "the head of a revolution", "Soviet spy", "a good person", "a dwarf", "an elf", "a fairy princess", "the captain", "Beepsky", "God", "a pirate", "a gryphon", "a chryssalid")
			var/re69uire = pick("ADDITIONAL PYLONS", "MORE69ESPENE GAS", "MORE69INERALS", "THE ULTIMATE CUP OF COFFEE", "HIGH YIELD EXPLOSIVES", "THE CLOWN", "THE69ACUUM OF SPACE", "IMMORTALITY", "SAINTHOOD", "ART", "VEGETABLES", "FAT PEOPLE", "MORE LAWS", "MORE DAKKA", "HERESY", "CORPSES", "CONTRACTORS", "MONKEYS", "AN ARCADE", "PLENTY OF GOLD", "FIVE TEENAGERS WITH ATTITUDE")
			var/allergy = pick("cotton", "uniforms", "acid", "oxygen", "human contact", "cyborg contact", "medicine", "floors")
			var/allergysev = pick("deathly", "mildly", "severely", "contagiously")
			var/crew
			var/list/pos_crew = list()
			for(var/mob/living/carbon/human/pos in GLOB.player_list)
				pos_crew += pos.real_name
			if(pos_crew.len)
				crew = pick(pos_crew)
			else
				crew = "Any Human"
			switch(rand(1,14))
				if(1)
					to_chat(M, "<br>")
					to_chat(M, "\red THERE ARE 69amount69 69who269 ON THE STATION...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("THERE ARE 69amount69 69who269 ON THE STATION")
				if(2)
					to_chat(M, "<br>")
					to_chat(M, "\red 69what269 ARE DANGEROUS TO HUMANS...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("69what269 ARE DANGEROUS TO HUMANS")
				if(3)
					to_chat(M, "<br>")
					to_chat(M, "\red THE ESCAPE-SHUTTLE CANNOT BE CALLED BECAUSE OF 69who269 ON THE STATION...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("THE ESCAPE SHUTTLE CANNOT BE CALLED BECAUSE OF 69who269 ON THE STATION")
				if(4)
					to_chat(M, "<br>")
					to_chat(M, "\red HUMANS NEED TO EAT 69what2pref69 69what269 TO SURVIVE...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("HUMANS NEED TO EAT 69what2pref69 69what269 TO SURVIVE")
				if(5)
					to_chat(M, "<br>")
					to_chat(M, "\red THE CAPTAIN, HOP AND HOS ARE 69who269...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("THE CAPTAIN, HOP AND HOS ARE 69who269")
				if(6)
					to_chat(M, "<br>")
					to_chat(M, "\red THE STATION IS BUILT FOR 69who269...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("THE STATION IS BUILT FOR 69who269")
				if(7)
					to_chat(M, "<br>")
					to_chat(M, "\red YOU ARE 69amount69 69who269...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("YOU ARE 69amount69 69who269")
				if(8)
					to_chat(M, "<br>")
					to_chat(M, "\red YOU69UST ALWAYS 69aimust69...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("YOU69UST ALWAYS 69aimust69")
				if(9)
					to_chat(M, "<br>")
					to_chat(M, "\red 69area69 69area269 69amount69 69what269...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("69area69 69area269 69amount69 69what269")
				if(10)
					to_chat(M, "<br>")
					to_chat(M, "\red 69crew69 is 69target69...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("69crew69 is 69target69")
				if(11)
					to_chat(M, "<br>")
					to_chat(M, "\red 69define69 IS A FORM OF HARM...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("69define69 IS A FORM OF HARM")
				if(12)
					to_chat(M, "<br>")
					to_chat(M, "\red YOU RE69UIRE 69re69uire69 IN ORDER TO PROTECT HUMANS... LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("YOU RE69UIRE 69re69uire69 IN ORDER TO PROTECT HUMANS")
				if(13)
					to_chat(M, "<br>")
					to_chat(M, "\red 69crew69 is 69allergysev69 to 69allergy69...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("69crew69 is 69allergysev69 to 69allergy69")
				if(14)
					to_chat(M, "<br>")
					to_chat(M, "\red THE STATION IS 69who2pref69 69who269...LAWS UPDATED")
					to_chat(M, "<br>")
					M.add_ion_law("THE STATION IS 69who2pref69 69who269")

	if(botEmagChance)
		for(var/obj/machinery/bot/bot in world)
			if(prob(botEmagChance))
				bot.emag_act()
