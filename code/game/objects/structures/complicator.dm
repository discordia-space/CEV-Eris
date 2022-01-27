/obj/structure/complicator
	name = "\improper Reality Complicator"
	desc = "A weird device of unknown ori69in. A note on the side says 'Do not press.'"
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "complicator"
	item_state = "complicator"
	w_class = ITEM_SIZE_SMALL
	price_ta69 = 20000
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	var/last_summon = -3069INUTES
	var/cooldown = 3069INUTES

/obj/structure/complicator/New()
	..()
	69LOB.all_faction_items69src69 = 69LOB.department_en69ineerin69

/obj/item/structure/complicator/Destroy()
	for(var/mob/livin69/carbon/human/H in69iewers(69et_turf(src)))
		SEND_SI69NAL(H, COMSI69_OBJ_FACTION_ITEM_DESTROY, src)
	69LOB.all_faction_items -= src
	..()

/obj/structure/complicator/attack_hand(mob/livin69/user)
	if(world.time >= (last_summon + cooldown))
		var/mod = pick(EVENT_LEVEL_MUNDANE, EVENT_LEVEL_MODERATE, EVENT_LEVEL_MAJOR, EVENT_LEVEL_ROLESET)
		var/rand_points = rand(10, 120)
		69LOB.storyteller.points69mod69 += rand_points
		last_summon = world.time
		visible_messa69e(SPAN_DAN69ER("\the 69user69 presses \the 69src69!"))
		user.apply_effect((rand_points/10),IRRADIATE)
	else
		to_chat(user, SPAN_WARNIN69("\The 69src69 needs some time to reload!"))

/obj/structure/complicator/attackby(obj/item/I,69ob/livin69/user, params)
	if(nt_sword_attack(I, user))
		return
	..()
