/datum/category_group/setup_option_category/background/fate
	name = "Fate"
	category_item_type = /datum/category_item/setup_option/background/fate

/datum/category_item/setup_option/background/fate

/datum/category_item/setup_option/background/fate/paper_worm
	name = "Paper Worm"
	desc = "You were a clerk and bureaucrat for all your life. Cramped offices with angry people is where your personality was forged. \
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
			You were always on the move, looking for a brighter future on the other side. \
			And because of that you never specialised as much as you should, but have broader array of other skills."

	perks = list(PERK_FREELANCER)

/datum/category_item/setup_option/background/fate/nihilist
	name = "Nihilist"
	desc = "You simply ran out of fucks to give at some point in your life. \
			Deciding to ignore the illusion of morals and justice, you realize there is only one thing of worth. You. \
			Will you still be loyal only to yourself when the gates of hell open?"

	perks = list(PERK_NIHILIST)

/datum/category_item/setup_option/background/fate/moralist
	name = "Moralist"
	desc = "A day may come when the courage of men fails, when we forsake our friends and break all bonds of fellowship. \
			But it is not this day. This day you fight! \
			Carry this fire with you - light the way for others."

	perks = list(PERK_MORALIST)


/datum/category_item/setup_option/background/fate/drug_addict
	name = "Drug Addict"
	desc = "For reasons you cannot remember, you decided to resort to major drug use. You have lost the battle, and now you suffer the consequences. \
			Now it is all you that drives you forward. All you have left to fight the cruel reality, or escape from it for some time."

	perks = list(PERK_DRUG_ADDICT)


/datum/category_item/setup_option/background/fate/alcoholic
	name = "Alcoholic"
	desc = "You imagined the egress from all your trouble and pain at the bottom of the bottle, but the way only led to a labyrinth. \
			You never stopped from coming back to it, trying again and again, poisoning your mind until you lost control. Now your face bears witness to your self-destruction. \
			There is only one key to survival, and it is the liquid that has shown you the way down."

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
	desc = "For all you know, taking what isn't yours is what you were best at. Be that roguery, theft or murder. It’s all the same no matter how you name it, after all. \
			You know the ways of infiltration, salvaging and getting away unharmed and with heavier pockets."

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
			Finally this expedition will reveal the secrets of the universe. Or break you forever."

	perks = list(PERK_REJECTED_GENIUS)

/datum/category_item/setup_option/background/fate/oborin_syndrome
	name = "Oborin Syndrome"
	desc = "A condition manifested at some recent point in human history. \
			It’s origin and prevalence are unknown, but it is speculated to be a psionic phenomenom.\
			You are affected by this so called Oborin Syndrome and are unable to see the colors of the world. You see what lies beyond them."

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
