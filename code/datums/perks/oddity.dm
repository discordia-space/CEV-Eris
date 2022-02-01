/datum/perk/oddity
	gain_text = "You feel different. Exposure to oddities has changed you. Now you can't go back."

/datum/perk/oddity/fast_walker
	name = "Fast Walker"
	desc = "Slow and steady wins the race. Prove them wrong. \
			You move slightly faster."
	icon_state = "fast" // https://game-icons.net

/datum/perk/oddity/gunmaster
	name = "Gunmaster"
	desc = "You truly understand ranged weaponry. \
			You fire 33% faster with a one-handed gun, produce twice as much ammo from ammo kits, and have more options to pick from when assembling a gun."
	icon_state = "gunmaster" // https://game-icons.net

/datum/perk/oddity/menace_to_society
	name = "Menace to Society"
	desc = "Even your mere presence is terrifying. \
			People around you lose sanity. Anyone who is around you at the moment of your death must roll a Vigilance sanity check; if they fail, their sanity will instantly be dropped to 0."
	icon_state = "menace" // https://game-icons.net

/datum/perk/oddity/menace_to_society/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity_damage += 2

/datum/perk/oddity/menace_to_society/remove()
	if(holder)
		holder.sanity_damage -= 2
	..()

/datum/perk/oddity/unfinished_delivery
	name = "Unfinished Delivery"
	desc = "Even though destination is your death, you have not reached it yet. \
			When you die, your organs will regenerate for 15 seconds and bring you back to life. If you wake up."
	icon_state = "delivery" // https://game-icons.net/1x1/delapouite/stump-regrowth.html

/datum/perk/oddity/prime_endurance
	name = "Prime Endurance"
	desc = "You can survive injuries that would kill others. \
			You take only half breathing and toxin damage, and your pain tolerance is higher."
	icon_state = "prime" // https://game-icons.net/1x1/lorc/one-eyed.html

/datum/perk/oddity/space_asshole
	name = "Space Asshole"
	desc = "Your only desire is to cause chaos. \
			You take half damage from falling, and can dive into disposal chutes. Disposals deal no damage to you."
	icon_state = "ass" // https://game-icons.net

/datum/perk/oddity/space_asshole/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.falls_mod -= 0.5

/datum/perk/oddity/space_asshole/remove()
	if(holder)
		holder.falls_mod += 0.5
	..()

/datum/perk/oddity/parkour
	name = "Parkour"
	desc = "You cling to railings and low walls, climb faster, and get up after diving or sliding sooner."
	icon_state = "parkour" //https://game-icons.net/1x1/delapouite/jump-across.html

/datum/perk/oddity/parkour/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.mod_climb_delay -= 0.5

/datum/perk/oddity/parkour/remove()
	if(holder)
		holder.mod_climb_delay += 0.5
	..()

/datum/perk/oddity/mentor
	name = "Mentor"
	desc = "You have the wisdom of many others. \
			Your passive sanity regeneration is increased, as well as your insight gain. \
			People recover sanity around you."
	icon_state = "mentor" // https://game-icons.net/1x1/lorc/flowers.html

/datum/perk/oddity/mentor/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity_damage -= 2
		holder.sanity.insight_passive_gain_multiplier *= 1.2
		holder.sanity.sanity_passive_gain_multiplier *= 1.2

/datum/perk/oddity/mentor/remove()
	if(holder)
		holder.sanity_damage += 2
		holder.sanity.insight_passive_gain_multiplier /= 1.2
		holder.sanity.sanity_passive_gain_multiplier /= 1.2
	..()

/datum/perk/oddity/triumph_of_the_will
	name = "Triumph of the Will"
	desc = "You know the blood will be spilt and you are ready for it. \
	Your chances to incur a positive breakdown are increased."
	icon_state = "triumph" //https://game-icons.net

/datum/perk/oddity/triumph_of_the_will/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.sanity.positive_prob += 30

/datum/perk/oddity/triumph_of_the_will/remove()
	if(holder)
		holder.sanity.positive_prob -= 30
	..()

/datum/perk/oddity/chaingun_smoker
	name = "Chaingun Smoker"
	desc = "The cigarette is your way of life. It makes you feel less sick and tougher when you chomp down on cigars. \
			You heal a slight amount by smoking and recover sanity more quickly."
	icon_state = "smoker" // https://game-icons.net

/datum/perk/oddity/nightcrawler
	name = "Nightcrawler"
	desc = "You strive in the dark. \
			You move faster in the darkness, while also being 50% more quiet."
	icon_state = "nightcrawler" // https://game-icons.net

/datum/perk/oddity/nightcrawler/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.noise_coeff -= 0.5

/datum/perk/oddity/nightcrawler/remove()
	if(holder)
		holder.noise_coeff += 0.5
	..()

/datum/perk/oddity/junkborn
	name = "Junkborn"
	desc = "One man's trash is a another man's comeup. \
			You have a higher chance of finding a rare item in trash piles."
	icon_state = "junkborn" // https://game-icons.net

/datum/perk/oddity/ass_of_concrete
	name = "Ass of Concrete"
	desc = "Years of training your body made you a hulk of a person. No more pushing around. \
			Nobody can move past you, even on help intent. You won\'t slip in gravity. \
			You break regular windows when you dive into them."
	icon_state = "concrete" // https://game-icons.net

/datum/perk/oddity/ass_of_concrete/assign(mob/living/carbon/human/H)
	..()
	if(holder)
		holder.mob_bump_flag = HEAVY

/datum/perk/oddity/ass_of_concrete/remove()
	if(holder)
		holder.mob_bump_flag = ~HEAVY
	..()

/datum/perk/oddity/absolute_grab
	name = "Absolute Grab"
	desc = "It pays to be a predator. You don't grab, you lunge. \
			You upgrade grabs twice as fast."
	icon_state = "grab" // https://game-icons.net

/datum/perk/oddity/sure_step
	name = "Sure Step"
	desc = " You are more likely to avoid traps. You never trip on underplating while running."
	icon_state = "sure_step"

/datum/perk/oddity/profit_maker
	name = "Profit Maker"
	desc = "You know that money comes first. And it doesn't matter where it comes from. \
			Taking items off others is without sound and prompts, it's also quicker, and you can slip pills into drinks unnoticed, while also being able to appraise the value of an item just by looking at it."
	icon_state = "robber_hand" //https://game-icons.net/1x1/darkzaitzev/robber-hand.html

/datum/perk/hive_oddity/hive_born
	name = "Hiveborn"
	desc = "You feel electricty flow within your body to your hands. Powercells recharge in your hands."
	icon_state = "hiveborn"  //https://game-icons.net/1x1/lorc/circuitry.html
	gain_text = "You feel a stabbing pain of something being injected into you, and with it a painfully pleaseant feeling of being improved."
	var/cooldown = 10 SECONDS
	var/initial_time
	var/obj/item/cell/C

/datum/perk/hive_oddity/hive_born/assign(mob/living/carbon/human/H)
	..()
	initial_time = world.time

/datum/perk/hive_oddity/hive_born/on_process()
	if(!..())
		return
	if(world.time < initial_time + cooldown)
		return
	initial_time = world.time
	if((holder.l_hand && istype(holder.l_hand, /obj/item/cell)))
		C = holder.l_hand
		if(!C.fully_charged())
			C.give(50)
	if((holder.r_hand && istype(holder.r_hand, /obj/item/cell)))
		C = holder.r_hand
		if(!C.fully_charged())
			C.give(50)

//////////////////////////////////
//////// NT ODDITY PERKS /////////
//////////////////////////////////
/datum/perk/nt_oddity
	gain_text = "God chose you to expand his will."

/datum/perk/nt_oddity/holy_light
	name = "Holy Light"
	desc = "You have been touched by the divine. You now provide a weak healing aura, healing both brute and burn damage to any NeoThelogists nearby as well as yourself."
	icon_state = "holy"  //https://game-icons.net/1x1/lorc/aura.html
	var/healing_power = 0.1
	var/cooldown = 1 SECONDS // Just to make sure that perk don't go berserk.
	var/initial_time

/datum/perk/nt_oddity/holy_light/assign(mob/living/carbon/human/H)
	..()
	initial_time = world.time

/datum/perk/nt_oddity/holy_light/on_process()
	if(!..())
		return
	if(!holder.get_core_implant(/obj/item/implant/core_implant/cruciform))
		return
	if(world.time < initial_time + cooldown)
		return
	initial_time = world.time
	for(var/mob/living/L in viewers(holder, 7))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.stat == DEAD || !(H.get_core_implant(/obj/item/implant/core_implant/cruciform)))
				continue
			H.adjustBruteLoss(-healing_power)
			H.adjustFireLoss(-healing_power)

/////////////////////////////////
////////////BIG SHIT/////////////
/////////////////////////////////
/datum/perk/big_shot
	name = "BIG SHOT"
	desc = "YOU\'RE THE BEST \[SALESMAN 2321\] AND IT SHOWS! YOU\'RE NOT IN THIS FOR \[THE FREE SPACEBUX\], YOU\'RE HERE FOR FOR \[THE FREEDOM\]"
	icon_state = "shot_big"

	var/enough_kromer = TRUE

	var/obj/item/clothing/mask/gas/big_shot/my_mask

	gain_text = "You feel the KROMERS flowing through you. You feel \[very marketable\]."
	lose_text = "You snap out of a bizarre commerce-themed trance. You feel much less financially stable. That was weird."

	var/static/list/list_of_great_deals = list(
		"Hochi Mama",
		"Great Deal",
		"HOT \[hyperlink blocked\] IN YOUR SECTOR",
		"hyperlink blocked",
		"?!$@!",
		"help",
		"BIG SHOT",
		"pipis",
		"hey is someone out there I need help please",
		"AHEUHEUHEU",
		"wetskrell.nt exonet archive",
		"CEV Eris schematics",
		"borg keygen free download",
		"special deal",
		"HEAVEN",
		"Like and Subscribe",
		"$!$$",
		"MONEY",
		"Storing up for the winter!",
		"On A Friday Night?",
		"For A LimiTed Time Only!",
		"TOP 10 HANSA CELEBRITIES!",
		"Predstraza Gun Schematics!",
		"Royalty Free Tapes!",
		"Big",
		"BIG",
		"BIG! BIG BIG!",
		"TELEKRYSTALS CHEAP",
		"[pick(1, 5, 8, 1997)] KROMER CHEAP!",
		"Burning acid",
		"A Ride around the Colony on Our Specil Kestrel",
		"Breathe",
		"Free Security Certificate",
		"Die",
		"BUY",
		"The Low Low Price Of",
		"Frozen Chicken",
		"Free Pizza Voucher",
		"It Burns! Ow! Stop! Help Me! It Burns!",
		"Clown Around Town",
		"Artist Around Ship",
		"Communion",
		"TOO MANY EXCESS VACATION DAYS?? TAKE A GOD DAMN VACATION STRAIGHT TO HELL!",
		"Easels",
		"Children eat free",
		"Five small payments of 599.45!",
		"Man, Woman, or Child",
		"At Half Price",
		"As seen on TV!",
		"Free subscribers",
		"5 lifehacks that will change your life",
		"Encyclopedia of",
		"Being afraid",
		"worm",
		"funky",
		"thrifty shopper",
		"I'm young and I'm lonely, see my photos",
		"hyperlink expunged",
		"Pass My Savings Onto You!",
		"Do you consent to the terms and agreements?",
		"consent to the terms and agreements",
		"we use cookies",
		"Request Accepted",
		"Stranger",
		"That's not very Big Shot of you",
		"VALUES",
		"free ink and toner",
		"Oxycodone without prescription!",
		"Replica watches with custom inscriptions!",
		"is your old Earth coin worth 5000 credits?",
		"maps of deepmaint download for free",
		"proceed",
		"PROCEED",
		"one weird tip discovered by a mom",
		"she looks half her age!",
		"whoa nelly",
		"it;s yours my friend",
		"as long as you have enough [pick("Kromer", "Credits", "Rubies", "Rupees", "dosh")]",
		"Total Jackass stunts",
		"Becomed",
		"$!$!",
		"Gameshow Host",
		"honestman",
		"Rapidly Shrinking",
		"The Big One",
		"THERE'S NOTHING TO FEAR EXCEPT",
		"ENL4RGE Yourself",
		"DVDs of ANY movie at Half-pr1ce",
		"3 WAYS TO EVADE BANS",
		"use this simple trick to evade chat filter",
		"TELL ME MORE",
		"Hyperlink Blocked",
		"Small business owner",
		"you should kill your \[HYPERLINK BLOCKED\]",
		"here's why  \[HYPERLINK BLOCKED\] never love you",
		"THERE'S NOTHING WRONG WITH HAVING A NICE \[Splurge\] EVERY ONCE IN A WHILE",
		"Healthy Breakfast Options",
		"which space ranger are you",
		"take this quirky quiz",
		"fill out a survey and earn credits",
		"There's nothing wrong.",
		"Smells like KROMER.",
		"Cungadero",
		"Kestrel",
		"BIGGER AND BETTER THAN EVER",
		"Attention Customers! Clean up on Aisle 3!",
		"Proud",
		"Kill",
		"Unforgettable D3als",
		"Aster's guild gift cards",
		"Click here for",
		"Turn up the JUICE!",
		"Half-Pr1ce Replicator Salamy",
		"watch free online dub",
		"Hyperlink Blocked!",
		"Chicken Nuggets",
		"Exotic Butters",
		"use",
		"Commemorative Ring"
	)

	var/cooldown = 5 SECONDS
	var/initial_time

/datum/perk/big_shot/assign(mob/living/carbon/human/H)
	..()
	initial_time = world.time
	if(holder)
		holder.stats.addTempStat(STAT_ROB, 20, INFINITY, "Big Shot")
		holder.stats.addTempStat(STAT_TGH, 20, INFINITY, "Big Shot")
		holder.stats.addTempStat(STAT_BIO, 20, INFINITY, "Big Shot")
		holder.stats.addTempStat(STAT_MEC, 20, INFINITY, "Big Shot")
		holder.stats.addTempStat(STAT_VIG, 35, INFINITY, "Big Shot")
		holder.stats.addTempStat(STAT_COG, 35, INFINITY, "Big Shot")


/datum/perk/big_shot/remove()
	if(holder)
		holder.stats.removeTempStat(STAT_ROB, "Big Shot")
		holder.stats.removeTempStat(STAT_TGH, "Big Shot")
		holder.stats.removeTempStat(STAT_BIO, "Big Shot")
		holder.stats.removeTempStat(STAT_MEC, "Big Shot")
		holder.stats.removeTempStat(STAT_VIG, "Big Shot")
		holder.stats.removeTempStat(STAT_COG, "Big Shot")
	..()

/datum/perk/big_shot/on_process()
	if(!..())
		return
	var/datum/money_account/KROMER = holder.mind.initial_account
	if(holder.get_equipped_item(slot_wear_mask) != my_mask)
		if(!charge_to_account(KROMER.account_number, KROMER.get_name(), "THIS WAS NOT VERY BIG SHOT OF YOU", station_name(), 1997))
			holder.adjustCloneLoss(rand(19, 97))
			to_chat(src, SPAN_DANGER("You feel like you didn't have enough KROMERS."))
		holder.stats.removePerk(type)
		return
	if(world.time < initial_time + cooldown)
		return
	initial_time = world.time
	desc = "YOU\'RE THE BEST \[SALESMAN 2321\] AND IT SHOWS! YOU\'RE NOT IN THIS FOR \[THE FREE SPACEBUX\], YOU\'RE HERE FOR FOR \[[pick(list_of_great_deals)]\]"
	my_mask.style = rand(-2, 2)//EXCLUSIVE OFFICIAL SPAMTON
	var/KROMER_GOOD = TRUE
	if(KROMER)
		if(!charge_to_account(KROMER.account_number, KROMER.get_name(), "BIG SHOT", station_name(), rand(1, 4)))
			KROMER_GOOD = FALSE
	else
		KROMER_GOOD = FALSE

	if(KROMER_GOOD)
		enough_kromer = TRUE
	else
		enough_kromer = FALSE

	if(!enough_kromer && prob(25))//When you run out of kromies your start running out of chromies
		holder.adjustCloneLoss(rand(1, 4))



/datum/perk/big_shot/proc/screw_up_the_text(phrase)
	phrase = html_decode(phrase)

	var/list/split_phrase = splittext(phrase," ") //Split it up into words.

	var/list/unscrewed_words = split_phrase.Copy()

	var/i = rand(1, 3)

	for(,i > 0,i--) //Pick a few words to screw up.
		if (!unscrewed_words.len)
			break
		var/word = pick(unscrewed_words)
		unscrewed_words -= word //Remove from unstuttered words so we don't stutter it again.
		var/index = split_phrase.Find(word) //Find the word in the split phrase so we can replace it.
		//Repeat the first letter to create a stutter.
		if(prob(80))
			if(length(word) > 3)
				word = "\[[pick(list_of_great_deals)]\]"
			else
				word = "\[[pick(list_of_great_deals)]\] [word]"
		else
			if(prob(75))
				word = "[word] \[[pick(list_of_great_deals)]\]"
			else
				word = "  [word]  "

		split_phrase[index] = word

	return sanitize(jointext(split_phrase," "))
