/obj/item/device/techno_tribalism
	name = "Techno-Tribalism Enforcer"
	desc = "Feeds on rare tools, tool mods and other tech items. After feeded enough, will produce a strange technological part, that will usefull to train your skills overtime."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "techno_tribalism"
	item_state = "techno_tribalism"
	origin_tech = list(TECH_MATERIAL = 8, TECH_ENGINEERING = 7, TECH_POWER = 2)
	price_tag = 20000
	var/list/oddity_stats = list(STAT_MEC = 0, STAT_COG = 0, STAT_BIO = 0, STAT_ROB = 0, STAT_TGH = 0, STAT_VIG = 0)
	var/last_produce = -30 MINUTES
	var/items_count = 0
	var/max_count = 5
	var/cooldown = 30 MINUTES

/obj/item/device/techno_tribalism/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(items_count < max_count)
		if(istype(W, /obj/item/weapon/tool))

			if(istype(W, /obj/item/weapon/tool/sword) || istype(W, /obj/item/weapon/tool/knife) || istype(W, /obj/item/weapon/tool/hammer))
				oddity_stats[STAT_ROB] += 3

			else if(istype(W, /obj/item/weapon/tool/saw/circular/advanced) || istype(W, /obj/item/weapon/tool/saw/hyper))
				oddity_stats[STAT_ROB] += 2
				oddity_stats[STAT_MEC] += 1
				oddity_stats[STAT_BIO] += 1

			else if(istype(W, /obj/item/weapon/tool/crowbar/onestar) || istype(W, /obj/item/weapon/tool/crowbar/pneumatic))
				oddity_stats[STAT_TGH] += 2
				oddity_stats[STAT_ROB] += 2

			else if(istype(W, /obj/item/weapon/tool/scalpel/laser))
				oddity_stats[STAT_BIO] += 2
				oddity_stats[STAT_VIG] += 2

			else if(istype(W, /obj/item/weapon/tool/scalpel/advanced))
				oddity_stats[STAT_BIO] += 2
				oddity_stats[STAT_VIG] += 1

			else if(istype(W, /obj/item/weapon/tool/scalpel) || istype(W, /obj/item/weapon/tool/bonesetter) || istype(W, /obj/item/weapon/tool/cautery) || istype(W, /obj/item/weapon/tool/hemostat) || istype(W, /obj/item/weapon/tool/retractor) || istype(W, /obj/item/weapon/tool/surgicaldrill))
				oddity_stats[STAT_BIO] += 1
				oddity_stats[STAT_VIG] += 1

			else if(istype(W, /obj/item/weapon/tool/weldingtool/advanced) || istype(W, /obj/item/weapon/tool/weldingtool/onestar))
				oddity_stats[STAT_VIG] += 3
				oddity_stats[STAT_MEC] += 1

			else if(istype(W, /obj/item/weapon/tool/wrench/big_wrench))
				oddity_stats[STAT_ROB] += 2
				oddity_stats[STAT_MEC] += 2

			else if(istype(W, /obj/item/weapon/tool/pickaxe/diamonddrill) || istype(W, /obj/item/weapon/tool/pickaxe/drill/onestar))
				oddity_stats[STAT_VIG] += 2
				oddity_stats[STAT_ROB] += 2

			else if(istype(W, /obj/item/weapon/tool/pickaxe/jackhammer))
				oddity_stats[STAT_VIG] += 1
				oddity_stats[STAT_ROB] += 2

			else if(istype(W, /obj/item/weapon/tool/pickaxe))
				oddity_stats[STAT_ROB] += 2

			else if(istype(W, /obj/item/weapon/tool/hammer/charge) || istype(W, /obj/item/weapon/tool/hammer/powered_hammer))
				oddity_stats[STAT_ROB] += 4
				oddity_stats[STAT_VIG] -= 1


			else if(istype(W, /obj/item/weapon/tool/hammer))
				oddity_stats[STAT_ROB] += 3

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
			oddity_stats[STAT_ROB] += 2
			oddity_stats[STAT_VIG] += 2

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
		if(items_count >= max_count)
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
			visible_message("\The [src] beeps, \"The [src] is not full enough to produce.\".")
	else
		visible_message("\The [src] beeps, \"The [src] need time to cooldown.\".")

/obj/item/device/techno_tribalism/examine(user)
	..()
	to_chat(user, SPAN_NOTICE("The [src] is feeded by [items_count]/[max_count]."))
