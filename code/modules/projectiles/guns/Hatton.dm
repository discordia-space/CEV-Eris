/obj/item/weapon/hatton_magazine
	name="Excelsior BD \"Hatton\" gas tube"
	icon_state="Hatton_box1"
	icon='icons/obj/Hatton.dmi'
	var/charge=1
	//m_amt = 15

/obj/item/weapon/hatton_magazine/New()
	update_icon()

/obj/item/weapon/hatton_magazine/update_icon()
	if(charge)
		icon_state="Hatton_box1"
	else
		icon_state="Hatton_box0"



/obj/item/weapon/hatton
	name = "Excelsior BD \"Hatton\""
	desc = "More instrument than a weapon, this breaching device was designed for emergency situations."
	icon = 'icons/obj/Hatton.dmi'
	icon_state = "Hatton_Hammer_1"
	item_state = "Hatton_Hammer_1"
	flags = PASSTABLE | CONDUCT
	slot_flags = SLOT_BELT
	//m_amt = 2000
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "combat=2"
	attack_verb = list("struck", "hit", "bashed")
	var/obj/item/weapon/hatton_magazine/magazine=new()
	var/fire_sound = 'sound/weapons/pulse.ogg'



/obj/item/weapon/hatton/New()
	update_icon()

/obj/item/weapon/hatton/update_icon()
	overlays.Cut()
	if(magazine)
		if(magazine.charge)
			icon_state="Hatton_Hammer_1"
			overlays += icon(icon, "3/3")
		else
			icon_state="Hatton_Hammer_1_empty"
			overlays += icon(icon, "1/3")
	else
		icon_state="Hatton_Hammer_0"



/obj/item/weapon/hatton/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/hatton_magazine))
		if(!magazine)
			user.drop_item()
			magazine = W
			magazine.loc = src
			update_icon()
			return
	return


/obj/item/weapon/hatton/attack_self(mob/living/user as mob)
	if(magazine)
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine.update_icon()
		magazine = null
		user << SPAN_NOTICE("You pull the magazine out of \the [src]!")
	update_icon()
	return






/obj/item/weapon/hatton/afterattack(atom/A as mob|obj|turf, mob/living/user as mob|obj, flag, params)
	if(!flag)
		return
	if(A.loc==user || istype(A, /obj/structure/closet) || istype(A,/obj/structure/table) || istype(A,/obj/item/weapon/storage))
		return
	Fire(A,user,params)




/obj/item/weapon/hatton/proc/click_empty(mob/user = null)
	if (user)
		user.visible_message("*click click*", "\red <b>*click*</b>")
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	else
		src.visible_message("*click click*")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)





/obj/item/weapon/hatton/proc/Fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params)

	if (!user.IsAdvancedToolUser())
		user << "\red You don't have the dexterity to do this!"
		return

	if(isliving(user))
		var/mob/living/M = user
		if (HULK in M.mutations)
			M << "\red Your meaty finger is much too large for the trigger guard!"
			return
	/*if(ishuman(user))
		if(user.dna && user.dna.mutantrace == "adamantine")
			user << "\red Your metal fingers don't fit in the trigger guard!"
			return*/

	add_fingerprint(user)

	if(!magazine || !magazine.charge)
		click_empty()
		return

	if(isliving(user))
		var/mob/living/M = user
		if ((CLUMSY in M.mutations) && prob(50))
			M << SPAN_DANGER("[src] blows up in your face.")
			M.drop_item()
			Fire(get_turf(M))
			del(src)
			return

	playsound(user, fire_sound, 70, 1)
	magazine.charge--
	update_icon()
	var/turf/target_turf = get_turf(target)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(4, 1, target_turf)
	s.start()
	new /obj/effect/effect/smoke(target_turf)
	for(var/atom/A in target_turf.contents)
		A.hatton_act()
	target_turf.hatton_act()
	new /obj/effect/effect/smoke(src.loc)









//reactions

/atom/proc/hatton_act()
	return


/mob/hatton_act()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.take_overall_damage(35, 10)
	else
		ex_act(2)
//turfs

/turf/simulated/wall/hatton_act()
	src.ChangeTurf("/turf/simulated/floor")

/turf/simulated/wall/r_wall/hatton_act()
	take_damage(1000)

/turf/simulated/mineral/hatton_act()
	ex_act(1)



//sturcutres

/obj/structure/hatton_act()
	ex_act(2)

/*/obj/structure/mineral_door/hatton_act()
	Dismantle()*/

/obj/structure/girder/hatton_act()
	new /obj/item/stack/material/steel(src.loc)
	qdel(src)

/obj/structure/grille/hatton_act()
	new /obj/item/stack/rods(loc)
	qdel(src)


/obj/structure/table/hatton_act()// ÑÄÅËÀÒÜ ÏÐÎÂÅÐÊÓ ÈÇ ÊÀÊÎÃÎ ÌÀÒÅÐÈÀËÀ ÑÄÅËÀÍ ÑÒÎË ???
	new /obj/item/stack/material/steel(src.loc)
	qdel(src)


/obj/structure/barricade/hatton_act()
	visible_message("\red <B>The [src] is blown apart!</B>")
	qdel(src)


/obj/machinery/deployable/barrier/hatton_act()
	visible_message("\red <B>The [src] is blown apart!</B>")
	qdel(src)




//machines

/obj/machinery/hatton_act()
	ex_act(2)

/obj/machinery/computer/hatton_act()
	set_broken()
	return

/obj/machinery/door/hatton_act()
	ex_act(1)


//ignore

/obj/machinery/atmospherics/hatton_act()
	return

/obj/structure/cable/hatton_act()
	return



