//Junk stashes contain a variety of random maint loot,
//but with a muuuch higher concentration of rare items
/datum/stash/junk
	base_type = /datum/stash/junk
	loot_type = "Junk"

	contents_list_base = list(/obj/random/rare = 2,
	/obj/random/pouch = 2,
	/obj/random/tool_upgrade = 3,
	/obj/random/lowkeyrandom = 5)

	contents_list_random = list(/obj/random/rare = 30,
	/obj/random/rare = 30,
	/obj/random/lowkeyrandom = 40,
	/obj/random/lowkeyrandom = 40,
	/obj/random/tool/advanced = 70)

/datum/stash/junk/inspection
	story_type = STORY_CRIME
	directions = DIRECTION_IMAGE
	lore = "Dear Diary,\n\
That prick First Officer keeps doing inspections of personal lockers, claiming some idiot terrorist\
threat. I think he just wants to go poking around through my unmentionables, but still, he'll start \
wondering where all these little odds and ends come from, or what kind of favors he can get. I'll \
just stuff it here for now, and he can go stuff himself. %D"

/datum/stash/junk/illicit_trade
	story_type = STORY_CRIME
	lore =  "Hey jackass! The ship's computer monitors the emails, the radios, and probably turns on \
	the fucking microphones when we aren't looking. So here, let me help you out. That shit you wanted\
	 is HERE.%D Now you're all paid up so don't go fucking talking about our deal, any which damn way,\
	  because you'll get us both brigged. And for fuck's sake, burn this when you're done?\n\n\
	  (The note is mildly singed around the edges, but quite readable)"

/datum/stash/junk/scrawl
	story_type = STORY_CRIME
	directions = DIRECTION_IMAGE
	lore = "(the handwriting is messy and barely legible)\n\n\
	calling me a packrat im not a packrat i just like to be prepared for shit thats all and whats wrong\
	 with that sometimes you gotta have shit to swap for whatever when the shit goes down and it always\
	  goes down and when it does i go down to better not write it i go down to here and these stupid \
	  people will never find it either"
	contents_list_extra = list(/obj/random/tool = 10)