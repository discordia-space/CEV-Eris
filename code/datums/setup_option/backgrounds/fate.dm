/datum/category_group/setup_option_category/background/fate
	name = "Fate"
	category_item_type = /datum/category_item/setup_option/background/fate

/datum/category_item/setup_option/background/fate

/datum/category_item/setup_option/background/fate/paper_worm
	name = "Paper Worm"
	desc = "You were a clerk and bureaucrat for all your life. Cramped offices with angry people is where your personality was forged. \
			Coffee is your blood, your mind is corporate slogans, and personal life is nonexistent. \
			And here you are, on a spaceship flying to hell. Yet, there is something more to you; when they fall into despair, you'll stand up and fight. \
			Your stats are lowered by 10, but you gain a higher chance to have a positive breakdown."

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
			You were always on the move, looking for a brighter future on the other side. \
			And because of that you never specialised as much as you should, but have broader array of other skills. \
			This perk checks your highest stat, lowers it by 10 and improves all others by 4."

	perks = list(PERK_FREELACER)

/datum/category_item/setup_option/background/fate/nihilist
	name = "Nihilist"
	desc = "You simply ran out of fucks to give at some point in your life. \
			Deciding to ignore the illusion of morals and justice, you realize there is only one thing of worth. You. \
			Will you still be loyal only to yourself when the gates of hell open? \
			This perk increases chance of positive breakdowns by 10% and negative breakdowns by 20%. Seeing someone die has a random effect on you: \
			sometimes you won’t take any sanity loss and you can even gain back sanity, or get a boost to your cognition."

	perks = list(PERK_NIHILIST)

/datum/category_item/setup_option/background/fate/moralist
	name = "Moralist"
	desc = "A day may come when the courage of men fails, when we forsake our friends and break all bonds of fellowship. \
			But it is not this day. This day you fight! \
			Carry this fire with you - light the way for others. \
			You gain insight when you are around sane people and they will recover sanity when around you. \
			When you are around people that are low on sanity, you will take sanity damage. \
			When you heal people using bandages, ointment or their improved versions, you recover sanity."

	perks = list(PERK_MORALIST)


/datum/category_item/setup_option/background/fate/drug_addict
	name = "Drug Addict"
	desc = "For reasons you cannot remember, you decided to resort to major drug use. You have lost the battle, and now you suffer the consequences. \
			Now it is all you that drives you forward. All you have left to fight the cruel reality, or escape from it for some time. \
			You start with a permanent addiction to a random stimulator, as well as a bottle of pills containing the drug. \
			Beware, if you get addicted to another stim, you will not get rid of the addiction."

	perks = list(PERK_DRUG_ADDICT)


/datum/category_item/setup_option/background/fate/alcoholic
	name = "Alcoholic"
	desc = "You imagined the egress from all your trouble and pain at the bottom of the bottle, but the way only led to a labyrinth. \
			You have a permanent alcohol addiction, which gives you a boost to combat stats while under the influence and lowers your cognition permanently."

	stat_modifiers = list(STAT_COG = -10)
	perks = list(PERK_ALCOHOLIC)

/datum/category_item/setup_option/background/fate/noble
	name = "Noble"
	desc = "You are a descendant of a long-lasting family, being part of a lineage of high status that can be traced back to the early civilization of your domain. \
			What legacy will you build? \
			Start with an heirloom weapon, higher chance to be on contractor contracts and removed sanity cap. Stay clear of filth and danger."
			
	perks = list(PERK_NOBLE)

/datum/category_item/setup_option/background/fate/rat
	name = "Rat"
	desc = "For all you know, taking what isn't yours is what you were best at. Be that information, items or life. It’s all the same no matter how you name it, after all. \
			You know the ways of infiltration, salvaging and getting away unharmed and with heavier pockets. \
			Secrets do not escape your ears, but loud noises are especially dangerous to you. \
			You start with a +10 to Mechanical stat and -10 to Vigilance. You will have a -10 to overall sanity health, meaning you will incur a breakdown faster than most. \
			Additionally you have more quiet footsteps and a chance to not trigger traps on the ground. You also have further listening range, but flashbangs stun you for double the time."

	perks = list(PERK_RAT)
	stat_modifiers = list(
		STAT_MEC = 10,
		STAT_VIG = -10
	)

/datum/category_item/setup_option/background/fate/rejected_genius
	name = "Rejected Genius"
	desc = "You see the world in different shapes and colors. \
			You know that the truth is out there, that you only need that one last push to uncover the terrible truth beyond.\
			So you pressed on, never stopping the pursuit of knowledge, to absorb all life and death had to offer. \
			Finally this expedition will reveal the secrets of the universe. Or break you forever. \
			Your sanity loss cap is removed, so stay clear of corpses or filth. You have less maximum sanity and no chance to have positive breakdowns. \
			As tradeoff, you have 50% faster insight gain."

	perks = list(PERK_REJECTED_GENIUS)

/datum/category_item/setup_option/background/fate/oborin_syndrome
	name = "Oborin Syndrome"
	desc = "A condition manifested at some recent point in human history. \
			It’s origin and prevalence are unknown, but it is speculated to be a psionic phenomenom.\
			You are affected by this so called Oborin Syndrome and are unable to see the colors of the world. You see what lies beyond them. \
			Your sanity pool is higher than that of others."

	perks = list(PERK_OBORIN_SYNDROME)

/datum/category_item/setup_option/background/fate/lowborn
	name = "Lowborn"
	desc = "You are the bottom of society. The dirt and grime on the heel of a boot. You had one chance. You took it. \
			You never knew your parents and were lucky enough to learn how to read, and that, in time, landed you a position on this ship. \
			Would you still choose to be part of this journey if you knew what it meant? Will you leave a mark or be forgotten forever? \
			You cannot play command roles. Additionally, you have the ability to have a name without a last name and have an increased sanity pool."

	restricted_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/chaplain, /datum/job/merchant, /datum/job/cmo, /datum/job/rd, /datum/job/ihc)
	restricted_depts = IRONHAMMER | MEDICAL | SCIENCE
	perks = list(PERK_LOWBORN)
