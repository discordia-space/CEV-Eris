
/////////////////MINES
////////////////////////////////

/obj/structure/mine_no_primer
	name = "Excelsior Mine"
	desc = "An anti-personnel mine. IFF technology grants safe passage to Excelsior agents, and a mercifully brief end to others."
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine"

/obj/structure/mine_no_primer/attack_hand(mob/living/user as mob)
	if(do_after(user,10,src))
		new /obj/item/weapon/plastique(src.loc)
		qdel(src)

/obj/structure/mine_scraps
	name = "Excelsior Mine"
	desc = "An anti-personnel mine. IFF technology grants safe passage to Excelsior agents, and a mercifully brief end to others."
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine"

/obj/structure/mine_scraps/attack_hand(mob/living/user as mob)
	if(do_after(user,10,src))
		new /obj/item/stack/material/steel/random(src.loc)
		qdel(src)

/////////////////MINES
////////////////////////////////