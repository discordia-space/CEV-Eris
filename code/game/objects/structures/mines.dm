/obj/structure/mine
	name = "Excelsior69ine"
	desc = "It looks like ancient, and rather dan69erous69ine."
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine"
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_ta69s = SPAWN_TA69_MINE_STUCTURE
	bad_type = /obj/structure/mine

/obj/structure/mine/mine_no_primer/attack_hand(mob/livin69/user as69ob)
	if(do_after(user,10,src))
		visible_messa69e(SPAN_WARNIN69("Mine deactivated"))
		new /obj/item/plasti69ue(src.loc)
		69del(src)

/obj/structure/mine/mine_scraps/attack_hand(mob/livin69/user as69ob)
	if(do_after(user,10,src))
		visible_messa69e(SPAN_WARNIN69("Mine fell apart into pieces of69etal"))
		new /obj/item/stack/material/steel/random(src.loc)
		69del(src)