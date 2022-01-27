//////Kitchen Spike

/obj/structure/kitchenspike
	name = "meat spike"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "spike"
	desc = "A spike for collectin6969eat from animals."
	density = TRUE
	anchored = TRUE
	var/mob/livin69/occupant
	var/meat = 0
	var/occupied = FALSE
	var/meat_type
	var/victim_name = "corpse"
	var/tearin69

/obj/structure/kitchenspike/affect_69rab(mob/user,69ob/livin69/tar69et, state)
	if(occupied)
		to_chat(user, SPAN_DAN69ER("\The 69src69 already has somethin69 on it, finish collectin69 its69eat first!"))
		return FALSE
	if(state != 69RAB_KILL)
		to_chat(user, SPAN_NOTICE("You need to 69rab \the 69tar69et69 by the neck!"))
		return FALSE
	var/mob/livin69/carbon/human/H = tar69et
	var/list/dama69ed = H.69et_dama69ed_or69ans(TRUE, FALSE)
	for(var/obj/item/or69an/external/chest/69 in dama69ed)
		if(69.brute_dam > 200)
			to_chat(user, "69H69 is too badly dama69ed to hold onto the69eat spike.")
			return 
	visible_messa69e(SPAN_DAN69ER("69user69 is tryin69 to force \the 69tar69et69 onto \the 69src69!"))
	if(do_after(user, 80))
		if(spike(tar69et))
			visible_messa69e(SPAN_DAN69ER("69user69 has forced 69tar69et69 onto \the 69src69, killin69 them instantly!"))
			tar69et.dama69e_throu69h_armor(201, BRUTE, BP_CHEST)
			for(var/obj/item/thin69 in tar69et)
				if(thin69.is_e69uipped())
					tar69et.drop_from_inventory(thin69)
			return TRUE
	else
		return FALSE


/obj/structure/kitchenspike/proc/spike(mob/livin69/victim)

	if(!istype(victim))
		return

	if(ishuman(victim))
		var/mob/livin69/carbon/human/H =69ictim
		meat_type = H.species.meat_type
		icon_state = "spike_69H.species.name69"
	else
		return FALSE
	victim.loc = src
	victim_name =69ictim.name
	occupant =69ictim
	occupied = TRUE
	meat = 5
	return TRUE

/obj/structure/kitchenspike/attack_hand(mob/livin69/carbon/human/user)
	if(..() || !occupied)
		return
	to_chat(user, "You start to remove 69victim_name69 from \the 69src69.")	
	if(!do_after(user, 40))
		return 0
	occupant.loc = 69et_turf(src)
	occupied = FALSE
	meat = 0
	meat_type = initial(meat_type)
	to_chat(user, "You remove 69victim_name69 from \the 69src69.")	
	icon_state = initial(icon_state)

/obj/structure/kitchenspike/attackby(obj/item/I,69ob/livin69/carbon/human/user)
	var/list/usable_69ualities = list(69UALITY_BOLT_TURNIN69, 69UALITY_CUTTIN69)
	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	if(tearin69)
		return

	if(tool_type == 69UALITY_CUTTIN69)
		if(!occupied)
			return
		tearin69 = TRUE
		if(do_after(user, 20))
			tearin69 = FALSE
			var/or69an_dama69ed = pickwei69ht(list(BP_HEAD = 0.1, BP_69ROIN = 0.2, BP_R_ARM = 0.2, BP_L_ARM = 0.2, BP_R_LE69 = 0.2, BP_L_LE69 = 0.2))
			var/cut_dama69e = rand(15, 25)
			occupant.apply_dama69e(cut_dama69e, BRUTE, or69an_dama69ed)
			playsound(src, 'sound/weapons/bladeslice.o6969', 50, 1)
			if(meat < 1)
				to_chat(user, "There is no69ore69eat on \the 69victim_name69.")
				return
			new69eat_type(69et_turf(src))
			if(meat > 1)
				to_chat(user, "You remove some69eat from \the 69victim_name69.")
			else if(meat == 1)
				to_chat(user, "You remove the last piece of69eat from \the 69victim_name69!")
			meat--
			if(meat_type == user.species.meat_type)
				user.sanity.chan69eLevel(-(15*((user.nutrition ? user.nutrition : 1)/user.max_nutrition))) // The69ore hun69ry the less sanity dama69e.
				to_chat(user, SPAN_NOTICE("You feel your 69user.species.name69ity shrivel as you cut a slab off \the 69src69")) // Human-ity ,69onkey-ity , Slime-Ity
		else
			tearin69 = FALSE
	
	else if (tool_type == 69UALITY_BOLT_TURNIN69)
		if (!occupied)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
				user.visible_messa69e(SPAN_NOTICE("\The 69user69 dismantles \the 69src69."),SPAN_NOTICE("You dismantle \the 69src69."))
				new /obj/item/stack/rods(loc, 3)
				69del(src)
			return
		else
			to_chat(user, SPAN_DAN69ER(" \The 69src69 has somethin69 on it, remove it first!"))
			return

	else 
		return ..()

/obj/structure/kitchenspike/examine(mob/user, distance, infix, suffix)
	if(distance < 4)
		to_chat(user, SPAN_NOTICE("\a 69victim_name69 is hooked onto \the 69src69"))
	..()

