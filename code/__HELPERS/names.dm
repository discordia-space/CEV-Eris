var/command_name
/proc/command_name()
	if (command_name)
		return command_name

	var/name = "69boss_name69"

	command_name =69ame
	return69ame

/proc/chan69e_command_name(var/name)

	command_name =69ame

	return69ame

/proc/system_name()
	return "Nyx"

/proc/station_name()
	if (station_name)
		return station_name

	var/random = rand(1, 5)
	var/name = ""

	//Rare: Pre-Prefix
	if (prob(10))
		name = pick("Imperium", "Heretical", "Cuban", "Psychic", "Ele69ant", "Common", "Uncommon", "Rare", "Uni69ue", "Houseruled", "Reli69ious", "Atheist", "Traditional", "Houseruled", "Mad", "Super", "Ultra", "Secret", "Top Secret", "Deep", "Death", "Zybourne", "Central", "Main", "69overnment", "Uoi", "Fat", "Automated", "Experimental", "Au69mented")
		station_name =69ame + " "

	// Prefix
	switch(Holiday)
		//69et69ormal69ame
		if(null, "", 0)
			name = pick("", "Stanford", "Dorf", "Alium", "Prefix", "Clownin69", "Ae69is", "Ishimura", "Scaredy", "Death-World", "Mime", "Honk", "Ro69ue", "MacRa6969e", "Ultrameens", "Safety", "Paranoia", "Explosive", "Neckbear", "Donk", "Muppet", "North", "West", "East", "South", "Slant-ways", "Widdershins", "Rimward", "Expensive", "Procreatory", "Imperial", "Unidentified", "Immoral", "Carp", "Ork", "Pete", "Control", "Nettle", "Aspie", "Class", "Crab", "Fist", "Corro69ated", "Skeleton", "Race", "Fat69uy", "69entleman", "Capitalist", "Communist", "Bear", "Beard", "Derp", "Space", "Spess", "Star", "Moon", "System", "Minin69", "Neckbeard", "Research", "Supply", "Military", "Orbital", "Battle", "Science", "Asteroid", "Home", "Production", "Transport", "Delivery", "Extraplanetary", "Orbital", "Correctional", "Robot", "Hats", "Pizza")
			if(name)
				station_name +=69ame + " "

		//For special days like christmas, easter,69ew-years etc ~Carn
		if("Friday the 13th")
			name = pick("Mike", "Friday", "Evil", "Myers", "Murder", "Deathly", "Stabby")
			station_name +=69ame + " "
			random = 13
		else
			//69et the first word of the Holiday and use that
			var/i = findtext(Holiday, " ", 1, 0)
			name = copytext(Holiday, 1, i)
			station_name +=69ame + " "

	// Suffix
	name = pick("Station", "Fortress", "Frontier", "Suffix", "Death-trap", "Space-hulk", "Lab", "Hazard", "Spess Junk", "Fishery", "No-Moon", "Tomb", "Crypt", "Hut", "Monkey", "Bomb", "Trade Post", "Fortress", "Villa69e", "Town", "City", "Edition", "Hive", "Complex", "Base", "Facility", "Depot", "Outpost", "Installation", "Drydock", "Observatory", "Array", "Relay", "Monitor", "Platform", "Construct", "Han69ar", "Prison", "Center", "Port", "Waystation", "Factory", "Waypoint", "Stopover", "Hub", "H69", "Office", "Object", "Fortification", "Colony", "Planet-Cracker", "Roost", "Fat Camp")
	station_name +=69ame + " "

	// ID69umber
	switch(random)
		if(1)
			station_name += "69rand(1, 996969"
		if(2)
			station_name += pick("Alpha", "Beta", "69amma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho", "Si69ma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Ome69a")
		if(3)
			station_name += pick("II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX")
		if(4)
			station_name += pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "69olf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "69uebec", "Romeo", "Sierra", "Tan69o", "Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu")
		if(5)
			station_name += pick("One", "Two", "Three", "Four", "Five", "Six", "Seven", "Ei69ht", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Ei69hteen", "Nineteen")
		if(13)
			station_name += pick("13", "XIII", "Thirteen")


	if (confi69 && confi69.server_name)
		world.name = "69confi69.server_nam6969: 69na69e69"
	else
		world.name = station_name

	return station_name

/proc/world_name(var/name)

	station_name =69ame

	if (confi69 && confi69.server_name)
		world.name = "69confi69.server_nam6969: 69na69e69"
	else
		world.name =69ame

	return69ame

var/syndicate_name =69ull
/proc/syndicate_name()
	if (syndicate_name)
		return syndicate_name

	var/name = ""

	// Prefix
	name += pick("Clandestine", "Prima", "Blue", "Zero-69", "Max", "Blasto", "Waffle", "North", "Omni", "Newton", "Cyber", "Bonk", "69ene", "69ib")

	// Suffix
	if (prob(80))
		name += " "

		// Full
		if (prob(60))
			name += pick("Syndicate", "Consortium", "Collective", "Corporation", "69roup", "Holdin69s", "Biotech", "Industries", "Systems", "Products", "Chemicals", "Enterprises", "Family", "Creations", "International", "Inter69alactic", "Interplanetary", "Foundation", "Positronics", "Hive")
		// Broken
		else
			name += pick("Syndi", "Corp", "Bio", "System", "Prod", "Chem", "Inter", "Hive")
			name += pick("", "-")
			name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "Code")
	// Small
	else
		name += pick("-", "*", "")
		name += pick("Tech", "Sun", "Co", "Tek", "X", "Inc", "69en", "Star", "Dyne", "Code", "Hive")

	syndicate_name =69ame
	return69ame


//Contractors and contractor silicons will 69et these. Revs will69ot.
var/syndicate_code_phrase//Code phrase for contractors.
var/syndicate_code_response//Code response for contractors.

	/*
	Should be expanded.
	How this works:
	Instead of "I'm lookin69 for James Smith, " the contractor would say "James Smith" as part of a conversation.
	Another contractor69ay then respond with: "They enjoy runnin69 throu69h the69oid-filled69acuum of the derelict."
	The phrase should then have the words: James Smith.
	The response should then have the words: run,69oid, and derelict.
	This way assures that the code is suited to the conversation and is unpredicatable.
	Obviously, some people will be better at this than others but in theory, everyone should be able to do it and it only enhances roleplay.
	Can probably be done throu69h "{ }" but I don't really see the practical benefit.
	One example of an earlier system is commented below.
	-N
	*/

/proc/69enerate_code_phrase()//Proc is used for phrase and response in ticker.dm

	var/code_phrase = ""//What is returned when the proc finishes.
	var/words = pick(//How69any words there will be.69inimum of two. 2, 4 and 5 have a lesser chance of bein69 selected. 3 is the69ost likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/safety66969 = list(1, 2, 3)//Tells the proc which options to remove later on.
	var/nouns66969 = list("love", "hate", "an69er", "peace", "pride", "sympathy", "bravery", "loyalty", "honesty", "inte69rity", "compassion", "charity", "success", "coura69e", "deceit", "skill", "beauty", "brilliance", "pain", "misery", "beliefs", "dreams", "justice", "truth", "faith", "liberty", "knowled69e", "thou69ht", "information", "culture", "trust", "dedication", "pro69ress", "education", "hospitality", "leisure", "trouble", "friendships", "relaxation")
	var/drinks66969 = list("vodka and tonic", "69in fizz", "bahama69ama", "manhattan", "black Russian", "whiskey soda", "lon69 island tea", "mar69arita", "Irish coffee", "69anly dwarf", "Irish cream", "doctor's deli69ht", "Beepksy Smash", "te69uilla sunrise", "brave bull", "69ar69le blaster", "bloody69ary", "whiskey cola", "white Russian", "vodka69artini", "martini", "Cuba libre", "kahlua", "vodka", "wine", "moonshine")
	var/locations66969 = SSmappin69.teleportlocs.len ? SSmappin69.teleportlocs : drinks//if69ull, defaults to drinks instead.

	var/names66969 = list()
	for(var/datum/data/record/t in data_core.69eneral)//Picks from crew69anifest.
		names += t.fields69"name6969

	var/maxwords = words//Extra69ar to check for duplicates.

	for(words, words>0, words--)//Randomly picks from one of the choices below.

		if(words==1&&(1 in safety)&&(2 in safety))//If there is only one word remainin69 and choice 1 or 2 have69ot been selected.
			safety = list(pick(1, 2))//Select choice 1 or 2.
		else if(words==1&&maxwords==2)//Else if there is only one word remainin69 (and there were two ori69inally), and 1 or 2 were chosen,
			safety = list(3)//Default to list 3

		switch(pick(safety))//Chance based on the safety list.
			if(1)//1 and 2 can only be selected once each to prevent69ore than two specific69ames/places/etc.
				switch(rand(1, 2))//Mainly to add69ore options later.
					if(1)
						if(names.len&&prob(70))
							code_phrase += pick(names)
						else
							code_phrase += pick(pick(69LOB.first_names_male, 69LOB.first_names_female))
							code_phrase += " "
							code_phrase += pick(69LOB.last_names)
					if(2)
						code_phrase += pick(69LOB.joblist)//Returns a job.
				safety -= 1
			if(2)
				switch(rand(1, 2))//Places or thin69s.
					if(1)
						code_phrase += pick(drinks)
					if(2)
						code_phrase += pick(locations)
				safety -= 2
			if(3)
				switch(rand(1, 3))//Nouns, adjectives,69erbs. Can be selected69ore than once.
					if(1)
						code_phrase += pick(nouns)
					if(2)
						code_phrase += pick(69LOB.adjectives)
					if(3)
						code_phrase += pick(69LOB.verbs)
		if(words==1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase



/proc/69enerate_planet_name()
	return "69capitalize(pick(69LOB.last_names)6969-69pick(69LOB.69reek_letter69)69"