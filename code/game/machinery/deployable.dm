/*
CONTAINS:
Deployable items
Barricades

for reference:
	access_security = 1
	access_bri69 = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_moebius = 5
	access_mor69ue = 6
	access_tox = 7
	access_tox_stora69e = 8
	access_69enetics = 9
	access_en69ine = 10
	access_en69ine_e69uip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emer69ency_stora69e = 14
	access_chan69e_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_stora69e = 23
	access_atmospherics = 24
	access_bar = 25
	access_janitor = 26
	access_crematorium = 27
	access_kitchen = 28
	access_robotics = 29
	access_rd = 30
	access_car69o = 31
	access_construction = 32
	access_chemistry = 33
	access_car69o_bot = 34
	access_hydroponics = 35
	access_manufacturin69 = 36
	access_virolo69y = 39
	access_cmo = 40
	access_merchant = 41
	access_court = 42
	access_clown = 43
*/

//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = TRUE
	density = TRUE
	var/health = 100
	var/maxhealth = 100
	var/material/material

/obj/structure/barricade/New(newloc,69aterial_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = 69et_material_by_name("69material_name69")
	if(!material)
		69del(src)
		return
	name = "69material.display_name69 barricade"
	desc = "This space is blocked off by a barricade69ade of 69material.display_name69."
	color =69aterial.icon_colour
	maxhealth =69aterial.inte69rity
	health =69axhealth

/obj/structure/barricade/69et_matter()
	var/list/matter = ..()
	. =69atter.Copy()
	if(material)
		LAZYAPLUS(.,69aterial.name, 5)

/obj/structure/barricade/69et_material()
	return69aterial

/obj/structure/barricade/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.69et_material_name() !=69aterial.name)
			return //hittin69 thin69s with the wron69 type of stack usually doesn't produce69essa69es, and probably doesn't need to.
		if(health <69axhealth)
			if(D.69et_amount() < 1)
				to_chat(user, SPAN_WARNIN69("You need one sheet of 69material.display_name69 to repair \the 69src69."))
				return
			visible_messa69e(SPAN_NOTICE("69user69 be69ins to repair \the 69src69."))
			if(do_after(user,20,src) && health <69axhealth)
				if(D.use(1))
					health =69axhealth
					visible_messa69e(SPAN_NOTICE("69user69 repairs \the 69src69."))
				return
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(W.damtype)
			if("fire")
				health -= W.force * 1
			if("brute")
				health -= W.force * 0.75
			else
		if(health <= 0)
			visible_messa69e(SPAN_DAN69ER("The barricade is smashed apart!"))
			dismantle()
			69del(src)
			return
		..()

/obj/structure/barricade/proc/dismantle()
	drop_materials(drop_location())
	69del(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1)
			visible_messa69e(SPAN_DAN69ER("\The 69src69 is blown apart!"))
			69del(src)
			return
		if(2)
			health -= 25
			if(health <= 0)
				visible_messa69e(SPAN_DAN69ER("\The 69src69 is blown apart!"))
				dismantle()
			return

/obj/structure/barricade/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)//So bullets will fly over and stuff.

	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,tar69et))

	if(air_69roup || (hei69ht==0))
		return 1
	if(istype(mover) &&69over.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/structure/barricade/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	cover = 69et_step(loc, 69et_dir(from, loc))
	if(!cover)
		return 1
	if (69et_dist(P.startin69, loc) <= 1) //Cover won't help you if people are THIS close
		return 1
	if (69et_turf(P.ori69inal) == cover)
		var/valid = FALSE
		var/distance = 69et_dist(P.last_interact,loc)
		P.check_hit_zone(loc, distance)

		var/tar69etzone = check_zone(P.def_zone)
		if (tar69etzone in list(BP_R_LE69, BP_L_LE69, BP_69ROIN))
			valid = TRUE //The lower body is always concealed
		if (ismob(P.ori69inal))
			var/mob/M = P.ori69inal
			if (M.lyin69)
				valid = TRUE			//Lyin69 down covers your whole body
		if(valid)
			var/pierce = P.check_penetrate(src)
			health -= P.69et_structure_dama69e()/2
			if (health > 0)
				visible_messa69e(SPAN_WARNIN69("69P69 hits \the 69src69!"))
				return pierce
			else
				visible_messa69e(SPAN_WARNIN69("69src69 breaks down!"))
				69del(src)
				return 1
	return 1

//Actual Deployable69achinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	re69_access = list(access_security)//I'm chan69in69 this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = TRUE
	icon_state = "barrier0"
	var/health = 300
	var/maxhealth = 300
	var/locked = FALSE
//	re69_access = list(access_maint_tunnels)

/obj/machinery/deployable/barrier/New()
	..()

	icon_state = "barrier69locked69"

/obj/machinery/deployable/barrier/attackby(obj/item/W,69ob/user)
	if(W.69etIdCard())
		if(allowed(user))
			if	(ema6969ed < 2)
				locked = !locked
				anchored = !anchored
				icon_state = "barrier69locked69"
				if((locked) && (ema6969ed < 2))
					to_chat(user, "Barrier lock to6969led on.")
					return
				else if((!locked) && (ema6969ed < 2))
					to_chat(user, "Barrier lock to6969led off.")
					return
			else
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
				visible_messa69e(SPAN_WARNIN69("BZZzZZzZZzZT"))
				return
		return
	else if(istype(W, /obj/item/tool/wrench))
		if(health <69axhealth)
			health =69axhealth
			ema6969ed = 0
			re69_access = list(access_security)
			visible_messa69e(SPAN_WARNIN69("69user69 repairs \the 69src69!"))
			return
		else if(ema6969ed > 0)
			ema6969ed = 0
			re69_access = list(access_security)
			visible_messa69e(SPAN_WARNIN69("69user69 repairs \the 69src69!"))
			return
		return
	else
		switch(W.damtype)
			if("fire")
				health -= W.force * 0.75
			if("brute")
				health -= W.force * 0.5
			else
		if(health <= 0)
			explode()
		..()

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1)
			explode()
			return
		if(2)
			health -= 25
			if(health <= 0)
				explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier69locked69"

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)//So bullets will fly over and stuff.

	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,tar69et))

	if(air_69roup || (hei69ht==0))
		return 1
	if(istype(mover) &&69over.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/deployable/barrier/proc/explode()

	visible_messa69e(SPAN_DAN69ER("69src69 blows apart!"))
	var/turf/Tsec = 69et_turf(src)

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(Tsec)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	explosion(src.loc,-1,-1,0)
	if(src)
		69del(src)

/obj/machinery/deployable/barrier/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(ema6969ed == 0)
		ema6969ed = 1
		re69_access.Cut()
		re69_one_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the 69src69.")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_messa69e(SPAN_WARNIN69("BZZzZZzZZzZT"))
		return 1
	else if(ema6969ed == 1)
		ema6969ed = 2
		to_chat(user, "You short out the anchorin6969echanism on \the 69src69.")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_messa69e(SPAN_WARNIN69("BZZzZZzZZzZT"))
		return 1

/obj/machinery/deployable/barrier/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	cover = 69et_step(loc, 69et_dir(from, loc))
	if(!cover)
		return 1
	if (69et_dist(P.startin69, loc) <= 1) //Cover won't help you if people are THIS close
		return 1
	if (69et_turf(P.ori69inal) == cover)
		var/valid = FALSE
		var/distance = 69et_dist(P.last_interact,loc)
		P.check_hit_zone(loc, distance)

		var/tar69etzone = check_zone(P.def_zone)
		if (tar69etzone in list(BP_R_LE69, BP_L_LE69, BP_69ROIN))
			valid = TRUE //The lower body is always concealed
		if (ismob(P.ori69inal))
			var/mob/M = P.ori69inal
			if (M.lyin69)
				valid = TRUE			//Lyin69 down covers your whole body
		if(valid)
			var/pierce = P.check_penetrate(src)
			health -= P.69et_structure_dama69e()/2
			if (health > 0)
				visible_messa69e(SPAN_WARNIN69("69P69 hits \the 69src69!"))
				return pierce
			else
				visible_messa69e(SPAN_WARNIN69("69src69 breaks down!"))
				69del(src)
				return 1
	return 1
