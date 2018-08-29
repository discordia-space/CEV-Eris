//The hatton is a breaching tool in the form of a melee-range "gun" which uses compressed gas to breach walls, airlocks and similar obstacles.
//The gas is supplied in expendable tubes, magazines essentially
//There's also a robot version which uses power instead of gas tubes.

/obj/item/weapon/hatton_magazine
	name="Excelsior BD \"Hatton\" gas tube"
	icon_state="Hatton_box1"
	icon='icons/obj/Hatton.dmi'
	var/charge=3
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
	var/fire_cooldown = 0
	var/last_fired = 0



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


/obj/item/weapon/hatton/proc/use_charge()
	if (magazine && magazine.charge > 0)
		magazine.charge--
		return TRUE
	return FALSE

/obj/item/weapon/hatton/proc/Fire(atom/target as mob|obj|turf, mob/living/user as mob|obj, params)
	if (world.time < last_fired + fire_cooldown)
		user << "\red [src] is still cooling down, wait for [((last_fired + fire_cooldown) - world.time)*0.1] seconds"
		click_empty()
		return

	if(isliving(user))
		var/mob/living/M = user
		if (HULK in M.mutations)
			M << "\red Your meaty finger is much too large for the trigger guard!"
			return
	if (!Adjacent(loc, target))
		user << "\red You're too far away to breach that!"
		return
	/*if(ishuman(user))
		if(user.dna && user.dna.mutantrace == "adamantine")
			user << "\red Your metal fingers don't fit in the trigger guard!"
			return*/

	add_fingerprint(user)



	if(isliving(user))
		var/mob/living/M = user
		if ((CLUMSY in M.mutations) && prob(50))
			M << SPAN_DANGER("[src] blows up in your face.")
			M.drop_item()
			Fire(get_turf(M))
			del(src)
			return

	if (use_charge())
		last_fired = world.time
		playsound(user, fire_sound, 70, 1)
		update_icon()
		var/turf/target_turf = get_turf(target)

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(4, 1, target_turf)
		s.start()

		new /obj/effect/effect/smoke(target_turf)

		//The recoil stops you for a few seconds
		user.Stun(2)
		shake_camera(user, 3, 1)
		//and knocks you back a tile
		var/dir = turn(get_dir(get_turf(src), target_turf), 180)
		user.Move(get_step(get_turf(src), dir))

		for(var/atom/A in target_turf.contents)
			A.hatton_act()
		target_turf.hatton_act()
		new /obj/effect/effect/smoke(src.loc)
	else
		click_empty()





//Variants
//Robot variation draws power from internal cell instead of using magazines
//Just imagine the robot is using that power to run an internal air compressor to refill the tube.
//This also explains the cooldown between uses
/obj/item/weapon/hatton/robot
	var/power_cost = 150 KILOWATTS //This uses about 7.5% of the charge on a rescue robot
	fire_cooldown = 100 //ten second cooldown between uses
	desc = "More instrument than a weapon, this breaching device was designed for emergency situations. It uses a massive surge of power to break down obstacles."

/obj/item/weapon/hatton/robot/use_charge()
	var/mob/living/silicon/robot/R = loc
	if (!istype(R))
		return FALSE

	if (R.cell_use_power(power_cost))
		return TRUE
	return FALSE




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



//strucutres


/*/obj/structure/mineral_door/hatton_act()
	Dismantle()*/

/obj/structure/hatton_act()
	ex_act(1)

/obj/machinery/deployable/barrier/hatton_act()
	visible_message("\red <B>The [src] is blown apart!</B>")
	qdel(src)




//machines

/obj/machinery/hatton_act()
	ex_act(2)

/obj/machinery/computer/hatton_act()
	..()
	set_broken()
	return

/obj/machinery/door/hatton_act()
	ex_act(1)


//ignore

/obj/machinery/atmospherics/hatton_act()
	return

/obj/structure/cable/hatton_act()
	return



