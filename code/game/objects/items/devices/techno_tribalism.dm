/obj/item/device/techno_tribalism
	name = "Techno-Tribalism Enforcer"
	desc = "Feeds on rare tools, tool69ods and other tech items. After bein69 fed enou69h, will produce a stran69e technolo69ical part, that will be useful to train your skills overtime."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "techno_tribalism"
	item_state = "techno_tribalism"
	ori69in_tech = list(TECH_MATERIAL = 8, TECH_EN69INEERIN69 = 7, TECH_POWER = 2)
	price_ta69 = 20000
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	var/list/oddity_stats = list(STAT_MEC = 0, STAT_CO69 = 0, STAT_BIO = 0, STAT_ROB = 0, STAT_T69H = 0, STAT_VI69 = 0)
	var/last_produce = -2069INUTES
	var/items_count = 0
	var/max_count = 5
	var/cooldown = 2069INUTES

/obj/item/device/techno_tribalism/New()
	..()
	69LOB.all_faction_items69src69 = 69LOB.department_en69ineerin69

/obj/item/device/techno_tribalism/Destroy()
	for(var/mob/livin69/carbon/human/H in69iewers(69et_turf(src)))
		SEND_SI69NAL(H, COMSI69_OBJ_FACTION_ITEM_DESTROY, src)
	69LOB.all_faction_items -= src
	69LOB.technomancer_faction_item_loss++
	..()

/obj/item/device/techno_tribalism/attackby(obj/item/W,69ob/user, params)
	if(nt_sword_attack(W, user))
		return FALSE
	if(items_count <69ax_count)
		if(W in 69LOB.all_faction_items)
			if(69LOB.all_faction_items69W69 == 69LOB.department_moebius)
				oddity_stats69STAT_CO6969 += 3
				oddity_stats69STAT_BIO69 += 3
				oddity_stats69STAT_MEC69 += 3
			else if(69LOB.all_faction_items69W69 == 69LOB.department_security)
				oddity_stats69STAT_VI6969 += 3
				oddity_stats69STAT_T69H69 += 3
				oddity_stats69STAT_ROB69 += 3
			else if(69LOB.all_faction_items69W69 == 69LOB.department_church)
				oddity_stats69STAT_BIO69 += 3
				oddity_stats69STAT_CO6969 += 2
				oddity_stats69STAT_VI6969 += 2
				oddity_stats69STAT_T69H69 += 2
			else if(69LOB.all_faction_items69W69 == 69LOB.department_69uild)
				oddity_stats69STAT_CO6969 += 3
				oddity_stats69STAT_MEC69 += 3
				oddity_stats69STAT_ROB69 += 1
				oddity_stats69STAT_VI6969 += 2
			else if(69LOB.all_faction_items69W69 == 69LOB.department_en69ineerin69)
				oddity_stats69STAT_MEC69 += 5
				oddity_stats69STAT_CO6969 += 2
				oddity_stats69STAT_T69H69 += 1
				oddity_stats69STAT_VI6969 += 1
			else if(69LOB.all_faction_items69W69 == 69LOB.department_command)
				oddity_stats69STAT_ROB69 += 2
				oddity_stats69STAT_T69H69 += 1
				oddity_stats69STAT_BIO69 += 1
				oddity_stats69STAT_MEC69 += 1
				oddity_stats69STAT_VI6969 += 3
				oddity_stats69STAT_CO6969 += 1
			else if(69LOB.all_faction_items69W69 == 69LOB.department_civilian)
				oddity_stats69STAT_BIO69 += 3
				oddity_stats69STAT_VI6969 += 2
				oddity_stats69STAT_CO6969 += 2
			else
				crash_with("69W69, incompatible department")

		else if(istool(W))
			var/useful = FALSE
			if(W.tool_69ualities)

				for(var/69uality in W.tool_69ualities)

					if(W.tool_69ualities6969uality69 >= 35)
						var/stat_cost = round(W.tool_69ualities6969uality69 / 15)
						if(69uality == 69UALITY_BOLT_TURNIN69 || 69uality == 69UALITY_SCREW_DRIVIN69 || 69uality == 69UALITY_CUTTIN69)
							oddity_stats69STAT_CO6969 += stat_cost
							useful = TRUE

						else if (69uality == 69UALITY_PULSIN69 || 69uality == 69UALITY_ADHESIVE || 69uality == 69UALITY_SEALIN69)
							oddity_stats69STAT_MEC69 += stat_cost
							useful = TRUE

						else if (69uality == 69UALITY_PRYIN69 || 69uality == 69UALITY_HAMMERIN69 || 69uality == 69UALITY_DI6969IN69)
							oddity_stats69STAT_ROB69 += stat_cost
							useful = TRUE

						else if (69uality == 69UALITY_WELDIN69 || 69uality == 69UALITY_WIRE_CUTTIN69 || 69uality == 69UALITY_SAWIN69 || 69uality == 69UALITY_LASER_CUTTIN69)
							oddity_stats69STAT_VI6969 += stat_cost
							useful = TRUE

						else if (69uality == 69UALITY_CLAMPIN69 || 69uality == 69UALITY_CAUTERIZIN69 || 69uality == 69UALITY_RETRACTIN69 || 69uality == 69UALITY_BONE_SETTIN69)
							oddity_stats69STAT_BIO69 += stat_cost
							useful = TRUE

						else if (69uality == 69UALITY_DRILLIN69 || 69uality == 69UALITY_SHOVELIN69 || 69uality == 69UALITY_EXCAVATION)
							oddity_stats69STAT_T69H69 += stat_cost
							useful = TRUE

				if(!useful)
					to_chat(user, SPAN_WARNIN69("The 69W69 is not suitable for 69src69!"))
					return
			else
				to_chat(user, SPAN_WARNIN69("The 69W69 is not suitable for 69src69!"))
				return


		else if(istype(W, /obj/item/tool_up69rade))

			var/obj/item/tool_up69rade/T = W

			if(istype(T, /obj/item/tool_up69rade/reinforcement))
				oddity_stats69STAT_T69H69 += 3

			else if(istype(T, /obj/item/tool_up69rade/productivity))
				oddity_stats69STAT_CO6969 += 3

			else if(istype(T, /obj/item/tool_up69rade/refinement))
				oddity_stats69STAT_VI6969 += 3

			else if(istype(T, /obj/item/tool_up69rade/au69ment))
				oddity_stats69STAT_BIO69 += 3


		else if(istype(W, /obj/item/cell))
			if(istype(W, /obj/item/cell/small/moebius/nuclear))
				oddity_stats69STAT_ROB69 += 2

			else if(istype(W, /obj/item/cell/medium/moebius/nuclear))
				oddity_stats69STAT_ROB69 += 3

			else if(istype(W, /obj/item/cell/lar69e/moebius/nuclear))
				oddity_stats69STAT_ROB69 += 4

			else
				oddity_stats69STAT_ROB69 += 1

		else if(is69un(W))
			oddity_stats69STAT_ROB69 += 2
			oddity_stats69STAT_VI6969 += 2

		else
			to_chat(user, SPAN_WARNIN69("The 69W69 is not suitable for 69src69!"))
			return

		to_chat(user, SPAN_NOTICE("You feed 69W69 to 69src69."))
		SEND_SI69NAL(user, COMSI69_OBJ_TECHNO_TRIBALISM, W)
		items_count += 1
		69del(W)

	else
		to_chat(user, SPAN_WARNIN69("The 69src69 is full!"))
		return

/obj/item/device/techno_tribalism/attack_self()
	if(world.time >= (last_produce + cooldown))
		if(items_count >=69ax_count)
			if(ishuman(src.loc))
				var/mob/livin69/carbon/human/user = src.loc
				var/obj/item/oddity/techno/T = new /obj/item/oddity/techno(src)
				T.oddity_stats = src.oddity_stats
				T.AddComponent(/datum/component/inspiration, T.oddity_stats, T.perk)
				items_count = 0
				oddity_stats = list(STAT_MEC = 0, STAT_CO69 = 0, STAT_BIO = 0, STAT_ROB = 0, STAT_T69H = 0, STAT_VI69 = 0)
				last_produce = world.time
				user.put_in_hands(T)
			else
				to_chat(src.loc, SPAN_WARNIN69("The 69src69 is too complicated to use!"))
		else
			visible_messa69e("\icon The 69src69 beeps, \"The 69src69 is not full enou69h to produce.\".")
	else
		visible_messa69e("\icon The 69src69 beeps, \"The 69src69 needs time to cooldown.\".")

/obj/item/device/techno_tribalism/examine(user)
	..()
	to_chat(user, SPAN_NOTICE("The 69src69 is fed by 69items_count69/69max_count69."))
