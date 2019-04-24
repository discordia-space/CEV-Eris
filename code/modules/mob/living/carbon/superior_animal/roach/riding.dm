/mob/living/carbon/superior_animal/roach
	var/taming_window = 30 //How long you have to tame this roach, once it's pacified.

/mob/living/carbon/superior_animal/roach/Move()
	. = ..()
	if(buckled_mob)
		buckled_mob.dir = dir
		buckled_mob.forceMove(get_turf(src))
		buckled_mob.pixel_x = pixel_x

/mob/living/carbon/superior_animal/roach/proc/try_tame(var/mob/living/carbon/user, var/obj/item/weapon/reagent_containers/food/snacks/grown/thefood)
	if(!istype(thefood))
		return FALSE
	if(thefood.reagents.has_reagent("sugar") || thefood.reagents.has_reagent("space_drugs") || thefood.reagents.has_reagent("vodka"))
		if(prob(40))
			visible_message("[src] hesitates for a moment...and then charges at [user]!")
			return FALSE //Sometimes roach just be like that
		visible_message("[src] scuttles towards [user], examining the [thefood] they have in their hand.")
		can_buckle = TRUE
		if(do_after(src, taming_window, src)) //Here's your window to climb onto it.
			if(!buckled_mob || user != buckled_mob) //They need to be riding us
				can_buckle = FALSE
				visible_message("[src] snaps out of its trance and rushes at [user]!")
				return FALSE
			visible_message("[src] bucks around wildly, trying to shake [user] off!") //YEEEHAW
			if(prob(40))
				visible_message("[src] thrashes around and, throws [user] clean off!")
				user.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
				unbuckle_mob()
				can_buckle = FALSE
				return FALSE
			unbuckle_mob()
			visible_message("[src] chomps [thefood] and slurps it down whole!.")
			qdel(thefood)
			visible_message("[src] looks slightly stoned.")
			/* WARNING. THIS CODE IS UNSPEAKABLY SHIT. I AM SO FUCKING SORRY FOR WRITING THIS CLOCKRIGGER BUT I HAVE TO. I'VE PREPARED A PRAYER OF EXCORCISM FOR YOUR PROTECTION, READER. ~KMC
			Pater noster qui est in caelis, dimittite peccatum mihi etiam
			Regna terrae, cantata Deo, psallite Cernunnos,
			Regna terrae, cantata Dea psallite Aradia. caeli Deus, Deus terrae, Humiliter majestati gloriae tuae supplicamus Ut ab omni infernalium spirituum potestate, Laqueo, and deceptione nequitia,
			Omnis fallaciae, libera nos, dominates. Exorcizamus you omnis immundus spiritus Omnis satanica potestas, omnis incursio, Infernalis adversarii, omnis legio, Omnis and congregatio secta diabolica.
			Ab insidiis diaboli, libera nos, dominates, Ut coven tuam secura tibi libertate servire facias, Te rogamus, audi nos! Ut inimicos sanctae circulae humiliare digneris, Te rogamus, audi nos! Terribilis Deus Sanctuario suo,
			Cernunnos ipse truderit virtutem plebi Suae, Aradia ipse fortitudinem plebi Suae. Benedictus Deus, Gloria Patri, Benedictus Dea, Matri gloria!
			*/
			var/obj/structure/bed/chair/wheelchair/roach/mobility_roach = new(get_turf(src))
			mobility_roach.icon = icon
			mobility_roach.icon_state = icon_state
			mobility_roach.name = name
			mobility_roach.desc = desc
			qdel(src)
			return TRUE
		visible_message("[src] snaps out of its trance and rushes at [user]!")
		return FALSE
	else
		visible_message("[user] cluelessly holds their hand out, but [src] just looks pissed off!")
		return FALSE //Sometimes roach just be like that

/obj/structure/bed/chair/wheelchair/roach
	name = "MOBILITY ROACH"
	desc = "THIS DOESNT LOOK RIGHT"
	icon = 'icons/mob/animal.dmi'
	icon_state = "roach"
	animate_movement = 3 //So it doesnt just slide around skrt skrt