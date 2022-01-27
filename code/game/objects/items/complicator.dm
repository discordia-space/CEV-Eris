/obj/item/complicator
	name = "Reality Complicator"
	desc = "A weird device of unknown ori69in. A note on the side says \'Do not press.\'"
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "complicator"
	item_state = "complicator"
	w_class = ITEM_SIZE_SMALL
	price_ta69 = 20000
	ori69in_tech = list(TECH_POWER = 7, TECH_BLUESPACE = 4, TECH_MA69NET = 9)
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	var/last_summon = -2069INUTES
	var/cooldown = 2069INUTES

/obj/item/complicator/New()
	..()
	69LOB.all_faction_items69src69 = 69LOB.department_en69ineerin69

/obj/item/complicator/Destroy()
	for(var/mob/livin69/carbon/human/H in69iewers(69et_turf(src)))
		SEND_SI69NAL(H, COMSI69_OBJ_FACTION_ITEM_DESTROY, src)
	69LOB.all_faction_items -= src
	69LOB.technomancer_faction_item_loss++
	..()

/obj/item/complicator/attack_self()
	var/mob/livin69/carbon/human/user = src.loc
	if(world.time >= (last_summon + cooldown))
		var/mod = pick(EVENT_LEVEL_MUNDANE, EVENT_LEVEL_MODERATE, EVENT_LEVEL_MAJOR, EVENT_LEVEL_ROLESET)
		var/rand_points = rand(10, 120)
		69LOB.storyteller.points69mod69 += rand_points
		last_summon = world.time
		visible_messa69e(SPAN_DAN69ER("69user69 pressed the bi69 red button on 69src69!"))
		user.apply_effect((rand_points/10),IRRADIATE)

	else
		to_chat(user, SPAN_WARNIN69("The 69src69 needs69ore time to recalibrate!"))

/obj/item/complicator/attackby(obj/item/I,69ob/livin69/user, params)
	if(nt_sword_attack(I, user))
		return
	..()
