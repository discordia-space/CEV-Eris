/obj/item/device/techno_tribalism
	name = "Techno-Tribalism Enforcer"
	desc = "Feeds on rare tools, tool mods and other tech items, according to their loot rarity and tag. When is feeded enough, will produce an oddity."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "techno_tribalism"
	item_state = "techno_tribalism"
	origin_tech = list(TECH_MATERIAL = 10, TECH_ENGINEERING = 7, TECH_POWER = 2)
	price_tag = 20000
	var/list/oddity_stats = list(STAT_MEC = 0,STAT_COG = 0,STAT_BIO = 0,STAT_ROB = 0,STAT_TGH = 0,STAT_VIG = 0)
	var/last_produce = -30 MINUTES
	var/items_count = 0
	var/cooldown = 30 MINUTES

/obj/item/device/techno_tribalism/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(items_count < 5)
		if(istype(W, /obj/item/weapon/tool))

			if(istype(W, /obj/item/weapon/tool/sword) || istype(W, /obj/item/weapon/tool/knife) || istype(W, /obj/item/weapon/tool/hammer))
				var/high_force = max(W.force, W.force_unwielded, W.force_wielded)
				oddity_stats[STAT_ROB] += round(high_force / 5)

			else
				oddity_stats[STAT_MEC] += 1


		else if(istype(W, /obj/item/weapon/tool_upgrade))

			var/obj/item/weapon/tool_upgrade/T = W

			if(istype(T, /obj/item/weapon/tool_upgrade/reinforcement))
				oddity_stats[STAT_TGH] += 3

			else if(istype(T, /obj/item/weapon/tool_upgrade/productivity))
				oddity_stats[STAT_COG] += 3

			else if(istype(T, /obj/item/weapon/tool_upgrade/refinement))
				oddity_stats[STAT_VIG] += 3

			else if(istype(T, /obj/item/weapon/tool_upgrade/augment))
				oddity_stats[STAT_BIO] += 3


		else if(istype(W, /obj/item/weapon/cell))
			if(istype(W, /obj/item/weapon/cell/small/moebius/nuclear))
				oddity_stats[STAT_ROB] += 2

			else if(istype(W, /obj/item/weapon/cell/medium/moebius/nuclear))
				oddity_stats[STAT_ROB] += 3

			else if(istype(W, /obj/item/weapon/cell/large/moebius/nuclear))
				oddity_stats[STAT_ROB] += 4

			else
				oddity_stats[STAT_ROB] += 1

		else if(istype(W, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = W
			oddity_stats[STAT_ROB] += round(G.damage_multiplier + G.penetration_multiplier, 1)
			oddity_stats[STAT_VIG] += round(G.recoil_buildup / 10, 1)

		else
			to_chat(user, SPAN_WARNING("The [W] is not suitable for [src]!"))
			return

		to_chat(user, SPAN_NOTICE("You feed [W] to [src]."))
		items_count += 1
		qdel(W)

	else
		to_chat(user, SPAN_WARNING("The [src] is full!"))
		return

/obj/item/device/techno_tribalism/attack_self()
	if(world.time >= (last_produce + cooldown))
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/user = src.loc
			var/obj/item/weapon/oddity/techno/T = new /obj/item/weapon/oddity/techno(src)
			T.oddity_stats = src.oddity_stats
			T.AddComponent(/datum/component/inspiration, T.oddity_stats)
			items_count = 0
			last_produce = world.time
			user.put_in_hands(T)
		else
			to_chat(src.loc, SPAN_WARNING("The [src] is too complicated to use!"))
	else
		visible_message("\The [src] beeps, \"The [src] need time to cooldown.\".")
