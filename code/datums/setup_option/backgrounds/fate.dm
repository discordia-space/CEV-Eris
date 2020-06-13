/datum/category_group/setup_option_category/background/fate
	name = "Fate"
	category_item_type = /datum/category_item/setup_option/background/fate

/datum/category_item/setup_option/background/fate

/datum/category_item/setup_option/background/fate/rat
	name = "Paper Worm"
	desc = "Papers and bureaucracy were your life, cramped offices with angry people is where your personality was forged. \
			Coffee is your blood, your mind is corporate slogans, and personal life is nonexistent. \
			But here you are, on a spaceship flying to hell. There is something more to you, something that may come to light later."

	stat_modifiers = list(
		STAT_ROB = -10,
		STAT_TGH = -10,
		STAT_BIO = -10,
		STAT_MEC = -10,
		STAT_VIG = -10,
		STAT_COG = -10
	)
	perks = list(PERK_PAPER_WORM)

/datum/category_item/setup_option/background/fate/freelancer
	name = "Freelancer"
	desc = "Whatever was your job, you never stayed in one place for too long or had lasting contracts. \
			You was always on a move, looking for a greener grass on the other side. \
			And because of that, you never specialised as much as you should, but have broader array of other skills."

	perks = list(PERK_FREELACER)

/datum/category_item/setup_option/background/fate/nihilist
	name = "Nihilist"
	desc = "You simply run out of fucks to give at some point in your life. \
			Putting illusion of morality to side, you decided to focus your own desires in life. \
			But will you stay true to your beliefs when shit hits the fan?"

	perks = list(PERK_NIHILIST)

/datum/category_item/setup_option/background/fate/moralist
	name = "Moralist"
	desc = "No matter how hard it is, you faith in humanity will always be strong. \
	Carry this torch with you, and light the way for others. \
	me, one must make the choice: to remain free and die impoverished and starving, or join the cult of NeoTheology to survive with a stable job and a place to live."

	perks = list(PERK_MORALIST)


/datum/category_item/setup_option/background/fate/drug_addict
	name = "Drug Addict"
	desc = "For some reason you decided to resort to major drug use, to escape from cruel realty, or to get that edge you need to fight it. \
			And now you are suffering the consequences."

	perks = list(PERK_DRUG_ADDICT)


/datum/category_item/setup_option/background/fate/alcoholic
	name = "Alcoholic"
	desc = "You saw escape at the bottom of the bottle, but you found none. \
			Which never stopped you from trying again and again, poisoning your mind until your pants are piss soaked, and face looks like a one of corpse. \
			But there is a balance for you in this state."
	stat_modifiers = list(STAT_COG = -10)
	perks = list(PERK_ALCOHOLIC)

/datum/category_item/setup_option/background/fate/noble
	name = "Noble"
	desc = "At some point of the past your family played important part in human history. \
			Those were captains and bridge crew of the colony ships, a CEO of first corporations, an admirals and generals. \
			All of them decided to entrench their accomplishments by creating noble leaninges, and here you are, a lost soul of high origin. \
			What does it makes you?"
	
	perks = list(PERK_ALCOHOLIC)

/datum/category_item/setup_option/background/fate/rat
	name = "Rat"
	desc = "In your life you decided to feast upon what’s not yours, be that thief, raiding, or scavenging and exploring. It’s all the same no matter how you name it, after all. \
			You know the ways of infiltrating, salvaging, and getting away with the loot."

	perks = list(PERK_RAT)
	stat_modifiers = list(
		STAT_MEC = 10,
		STAT_VIG = -10
	)

/datum/category_item/setup_option/background/fate/rejected_genius
	name = "Rejected Genius"
	desc = "You see the world in different shape. \
			You know that the Truth is somewhere there, that you only need to push it further and all will be revealed. \
			And so you pushed, far and wide, and the road did not shorten a bit. \
			Maybe this expedition will reveal the Light."

	perks = list(PERK_REJECTED_GENIUS)

/datum/category_item/setup_option/background/fate/oborin_syndrome
	name = "Oborin Syndrome"
	desc = "A disease manifested at some recent point in human history. \
			It’s origin and spread methods are unknown, but it’s speculated it’s related to psy phenomena. \
			People affected by it are unable to see world colors, and generally disinterested in world around them."

	perks = list(PERK_OBORIN_SYNDROME)

/datum/category_item/setup_option/background/fate/lowborn
	name = "Lowborn"
	desc = "Your origin is literally bottom of the society, be that a hobo gangs or underground trash communities. \
			You did not knew your parents, and was just lucky enough to learn how to read, and that, in time, landed you on position at this ship."
	restricted_jobs = list(/datum/job/captain, /datum/job/chaplain, /datum/job/merchant, /datum/job/cmo, /datum/job/rd, /datum/job/ihc)
	perks = list(PERK_LOWBORN)

/datum/category_item/setup_option/background/fate/veteran
	name = "Veteran"
	desc = "At some point in your life gears of war drag you in, used you and break you, \
			just to spill you back into the civil world, with zero thoughts put into what will happen \
			with you next. Was it Corporate War, or one of the many End Point conflict? Does it even matter at this point?"
