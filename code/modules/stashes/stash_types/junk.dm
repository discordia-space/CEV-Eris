//Junk stashes contain a69ariety of random69aint loot,
//but with a69uuuch higher concentration of rare items
/datum/stash/junk
	base_type = /datum/stash/junk
	loot_type = "Junk"

	contents_list_base = list(/obj/spawner/pack/rare = 2,
	/obj/spawner/pouch = 2,
	/obj/spawner/tool_upgrade = 3,
	/obj/spawner/lowkeyrandom = 5)

	contents_list_random = list(/obj/spawner/pack/rare = 30,
	/obj/spawner/pack/rare = 30,
	/obj/spawner/lowkeyrandom = 40,
	/obj/spawner/lowkeyrandom = 40,
	/obj/spawner/tool/advanced = 70)
/*
/datum/stash/junk/inspection
	story_type = STORY_CRIME
	directions = DIRECTION_IMAGE
	lore = "Dear Diary,<br>\
That prick First Officer keeps doing inspections of personal lockers, claiming some idiot terrorist\
threat. I think he just wants to go poking around through69y unmentionables, but still, he'll start \
wondering where all these little odds and ends come from, or what kind of favors he can get. I'll \
just stuff it here for69ow, and he can go stuff himself. %D"
*/
/datum/stash/junk/illicit_trade
	story_type = STORY_CRIME
	lore =  "Hey jackass! The ship's computer69onitors the emails, the radios, and probably turns on \
	the fucking69icrophones when we aren't looking. So here, let69e help you out. That shit you wanted\
	 is HERE.<br>%D <br>\
	 <br>\
	69ow you're all paid up so don't go fucking talking about our deal, any which damn way,\
	  because you'll get us both brigged. And for fuck's sake, burn this when you're done?<br><br>\
	  (The69ote is69ildly singed around the edges, but 69uite readable)"
/*
/datum/stash/junk/scrawl
	story_type = STORY_CRIME
	directions = DIRECTION_IMAGE
	lore = "(the handwriting is69essy and barely legible)<br><br>\
	calling69e a packrat im69ot a packrat i just like to be prepared for shit thats all and whats wrong\
	 with that sometimes you gotta have shit to swap for whatever when the shit goes down and it always\
	  goes down and when it does i go down to better69ot write it i go down to here and these stupid \
	  people will69ever find it either"
	contents_list_extra = list(/obj/spawner/tool = 10)
*/
/datum/stash/junk/handoff
	story_type = STORY_CRIME
	lore = "Joe, and69o that isn't your real69ame,<br>\
 I don't know what in the hell you want all this stuff for but I'm69ot getting caught handing it to you.<br>\
 <br>\
	So take your69oney, roll it all tight, stick it in a clean beer bottle and hand it to69e in a box of recycling or something.<br>\
 Once that's done I'll stick your things at %D. <br>\
<br>\
Signed your pal who isn't69amed Bob."

/datum/stash/junk/guild
	contents_list_extra = list(/obj/spawner/contraband = 6)
	base_type = /datum/stash/junk/guild //Prevents this parent type being picked

/datum/stash/junk/guild/crackdown
	story_type = STORY_CRIME
	lore = "Guildsman,<br>\
 With the recent crackdown on what sorts of69erchandise we can sell I am going to teach you a69ital lesson in entrepreneurship.<br>\
 <br>\

 Take all that stuff we aren't allowed to sell anymore and69ove it to a jurisdiction with a little less69arket regulation.<br>\
 I even saw somewhere with a69ice bit of curb appeal.<br>\
%D"

/datum/stash/junk/guild/protection
	contents_list_external = list(/obj/item/remains/human = 1) //Corrupt security69urdered this guy for69ot paying protection69oney
	story_type = STORY_CRIME
	lore = "Guild69aster,<br>\
 The current protection racket for our little lemonade stand is exceeding tolerable levels.<br>\
 I have relocated to %D, just in case you'd think I69ade off with the lot.<br>\
 <br>\
 Send people69y way if they ask, but when those Ironhammers start bitching about where I went, get it on tape, would you?"


/datum/stash/junk/guild/drop
	story_type = STORY_CRIME
	lore = "Ishmael,<br>\
	<br>\
	Its here for you. %D. <br>\
	Now I've done69y end of the deal, so I'd best find your end of the deal where it belongs.<br>\
	<br>\
	You guilds-men have your reputation to uphold, do you69ot?<br>\
	<br>\
	Johannes"
