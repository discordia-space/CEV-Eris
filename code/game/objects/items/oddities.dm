//This is set of item created to work with Eris stat and perk systems
//The idea here is simple, you find oddities in random spawners, you use them, and they grant you stats, or even perks.
//After use, the object is claimed, and cannot be used by someone else
//If rebalancing is needed, keep in mind spawning rate of those items, it might be good idea to change that as well
//Clockrigger 2019

#define MINIMUM_ODDITY_STAT 2

/obj/item/weapon/oddity
	name = "Oddity"
	desc = "Strange item of uncertain origin."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "gift3"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	var/claimed = FALSE

//You choose what stat can be increased, and a maximum value that will be added to this stat
//The minimum is defined above. The value of change will be decided by random
//As for perks, the second number in associated list will be a chance to get it
	var/list/oddity_stats
	var/list/oddity_perks


/obj/item/weapon/oddity/attack_self(mob/user as mob)

	if(!claim(user))
		to_chat(user, SPAN_NOTICE("This item is already someone's inspiration."))
		return FALSE

	if(!ishuman(user))
		to_chat(user, SPAN_NOTICE("There is no value in this item for you"))
		return FALSE

	if(oddity_stats)
		var/chosen_stat = pick(oddity_stats)
		var/stat_change = rand (2, oddity_stats[chosen_stat])
		user.stats.changeStat(chosen_stat, stat_change)
		claim(user)
		to_chat(user, SPAN_NOTICE("Something sparks in your mind as you examine the [initial(name)]. A brief moment of understanding to this item's past granting you insight to a bigger picture. \
									Your [chosen_stat] skill is increased by [stat_change]"))

	if(oddity_perks)
		var/chosen_perk = pick(oddity_perks)
		if(prob (oddity_perks[chosen_perk]))
			var/datum/perk/P = new chosen_perk
			P.teach(user.stats)
			claim(user)
			to_chat(user, SPAN_NOTICE("You are now something more. The abillity [P.name] is avalible for you."))

	return TRUE


/obj/item/weapon/oddity/proc/claim(mob/user as mob)
	if(!claimed)
		claimed = TRUE
		name = "[user.name] [name]"
		return TRUE
	else
		return FALSE


//Oddities are separated into categories depending on their origin. They are meant to be used both in maints and derelicts, so this is important
//This is done by subtypes, because this way even densiest code monkey will not able to misuse them
//They are meant to be put in appropriate random spawners

//Common - you can find those everywhere
/obj/item/weapon/oddity/common/blueprint
	name = "strange blueprint"
	desc = "You can't figure out what exactly this is. This is probably don't even works."
	icon_state = "blueprint"
	oddity_stats = list(
		STAT_COG = 5,
		STAT_MEC = 7,
	)

/obj/item/weapon/oddity/common/coin
	name = "strange coin"
	desc = "It look more like collectible rather than actual curency. But you can't figure out the alloy it made from."
	icon_state = "coin"
	oddity_stats = list(
		STAT_ROB = 5,
		STAT_TGH = 5,
	)

/obj/item/weapon/oddity/common/photo_landscape
	name = "alien landscape photo"
	desc = "There some ire about this planet."
	icon_state = "photo_landscape"
	oddity_stats = list(
		STAT_COG = 5,
		STAT_TGH = 5,
	)

/obj/item/weapon/oddity/common/photo_coridor
	name = "surreal maint photo"
	desc = "Something wrong, yet so familiar about this place."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAT_MEC = 5,
		STAT_TGH = 5,
	)

/obj/item/weapon/oddity/common/photo_eyes
	name = "observer photo"
	desc = "What the fuck is this even."
	icon_state = "photo_corridor"
	oddity_stats = list(
		STAR_ROB = 6,
		STAT_TGH = 6,
		STAT_VIG = 6,
	)

/obj/item/weapon/oddity/common/old_newspaper
	name = "old newspaper"
	desc = "It contains a report on some old and strange phenomenon. Maybe it's lies, maybe it's corporate experements gone wrong."
	icon_state = "old_newspaper"
	oddity_stats = list(
		STAT_MEC = 4,
		STAT_COG = 4,
		STAT_BIO = 4,
	)

/obj/item/weapon/oddity/common/paper_crumpled
	name = "turn-out page"
	desc = "This ALMOST makes sense."
	icon_state = "paper_crumpled"
	oddity_stats = list(
		STAT_MEC = 6,
		STAT_COG = 6,
		STAT_BIO = 6,
	)

/obj/item/weapon/oddity/common/paper_omega
	name = "collection of obscure reports"
	desc = "Even the authors seem to be rather skeptical about their findings. Yet they are not connected to each other, but results are simular."
	icon_state = "paper_omega"
	oddity_stats = list(
		STAT_MEC = 8,
		STAT_COG = 8,
		STAT_BIO = 8,
	)

/obj/item/weapon/oddity/common/book_eyes
	name = "observer book"
	desc = "This book details the information on some cyber creatures. Who did this, how this is even possible?"
	icon_state = "book_eyes"
	oddity_stats = list(
		STAR_ROB = 9,
		STAT_TGH = 9,
		STAT_VIG = 9,
	)

/obj/item/weapon/oddity/common/book_omega
	name = "occult book"
	desc = "This mostly does not make any sense. However, those stories are at least interesting."
	icon_state = "book_omega"
	oddity_stats = list(
		STAT_BIO = 6,
		STAR_ROB = 6,
		STAT_VIG = 6,
	)

/obj/item/weapon/oddity/common/book_bible
	name = "old bible"
	desc = "Oh, how quickly we forgot."
	icon_state = "book_bible"
	oddity_stats = list(
		STAR_ROB = 5,
		STAT_VIG = 5,
	)

/obj/item/weapon/oddity/common/old_money
	name = "old_money"
	desc = "It's not like organization that issues this exist now."
	icon_state = "old_money"
	oddity_stats = list(
		STAT_ROB = 4,
		STAT_TGH = 4,
	)

/obj/item/weapon/oddity/common/healthscanner
	name = "odd healthscanner"
	desc = "It's broken and stuck on some really strange readings. Was this even human?"
	icon_state = "healthscanner"
	item_state = "electronic"
	oddity_stats = list(
		STAT_COG = 8,
		STAT_BIO = 8,
	)

/obj/item/weapon/oddity/common/old_pda
	name = "broken pda"
	desc = "This is old, Nanotrasen era PDA, issued to employes of this corporation all over the galaxy."
	icon_state = "old_pda"
	item_state = "electronic"
	oddity_stats = list(
		STAT_COG = 6,
		STAT_MEC = 6,
	)

/obj/item/weapon/oddity/common/towel
	name = "trustworthy towel"
	desc = "Always have it with you."
	icon_state = "towel"
	oddity_stats = list(
		STAT_ROB = 6,
		STAT_TGH = 6,
	)

#undef MINIMUM_ODDITY_STAT
