//This is set of item created to work with Eris stat and perk systems
//The idea here is simple, you find oddities in random spawners, you use them, and they grant you stats, or even perks.
//After use, the object is claimed, and cannot be used by someone else
//If rebalancing is needed, keep in mind spawning rate of those items, it might be good idea to change that as well
//Clockrigger 2019

/obj/item/weapon/oddity
	name = "Oddity"
	desc = "Strange item of uncertain origin."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "gift3"
	item_state = "electronic"
	w_class = ITEM_SIZE_SMALL
	var/claimed = FALSE

//You choose what stat can be increased, and a maximum value that will be added to this stat
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
		var/stat_change = rand (1, oddity_stats[chosen_stat])
		user.stats.changeStat(chosen_stat, stat_change)
		claim(user)
		to_chat(user, SPAN_NOTICE("Something sparks in your mind as you examine the [name]. A brief moment of understanding to this item's past granting you insight to a bigger picture. \
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
		name = "[user.name]'s [name]"
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
