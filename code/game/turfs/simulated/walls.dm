/turf/simulated/wall
	name = "wall"
	desc = "A hu69e chunk of69etal used to seperate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "69eneric"
	layer = CLOSED_TURF_LAYER
	opacity = 1
	density = TRUE
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 169 by 2.569 by 0.2569 plasteel wall

	var/ricochet_id = 0
	var/dama69e = 0
	var/dama69e_overlay = 0
	var/active
	var/can_open = 0
	var/material/material
	var/material/reinf_material
	var/last_state
	var/construction_sta69e
	var/hitsound = 'sound/weapons/69enhit.o6969'
	var/list/wall_connections = list("0", "0", "0", "0")

	/*
		If set, these69ars will be used instead of the icon base taken from the69aterial.
		These should be set at authortime
		Currently, they can only be set at authortime, on specially coded wall69ariants

		In future we should add some way to create walls of specific styles. Possibly durin69 the construction process
	*/
	var/icon_base_override = ""
	var/icon_base_reinf_override = ""
	var/base_color_override = ""
	var/reinf_color_override = ""

	//These will be set from the set_material function. It just caches which base we're 69oin69 to use, to simplify icon updatin69 lo69ic.
	//These should69ot be set at compiletime, they will be overwritten
	var/icon_base = ""
	var/icon_base_reinf = ""
	var/base_color = ""
	var/reinf_color = ""

	var/static/list/dama69e_overlays
	is_wall = TRUE

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(TRUE)
		SEND_SI69NAL(O, COMSI69_TURF_LEVELUPDATE, TRUE)

/turf/simulated/wall/New(newloc,69aterialtype, rmaterialtype)
	if (!dama69e_overlays)
		dama69e_overlays =69ew

		var/overlayCount = 16
		var/alpha_inc = 256 / overlayCount

		for(var/i = 1; i <= overlayCount; i++)
			var/ima69e/im69 = ima69e(icon = 'icons/turf/walls.dmi', icon_state = "overlay_dama69e")
			im69.blend_mode = BLEND_MULTIPLY
			im69.alpha = (i * alpha_inc) - 1
			dama69e_overlays.Add(im69)


	icon_state = "blank"
	if(!materialtype)
		materialtype =69ATERIAL_STEEL
	material = 69et_material_by_name(materialtype)
	if(!isnull(rmaterialtype))
		reinf_material = 69et_material_by_name(rmaterialtype)
	update_material(FALSE) //We call update69aterial with update set to false, so it won't update connections or icon yet
	..(newloc)


/turf/simulated/wall/Initialize(mapload)
	..()

	if (mapload)
		//We defer icon updates to late initialize at roundstart
		return INITIALIZE_HINT_LATELOAD

	else
		//If we 69et here, this wall was built durin69 the round
		//We'll update its connections and icons as69ormal
		update_connections(TRUE)
		update_icon()


/turf/simulated/wall/LateInitialize()
	//If we 69et here, this wall was69apped in at roundstart
	update_connections(FALSE)
	/*We set propa69ate to false when updatin69 connections at roundstart
	This ensures that each wall will only update itself, once.
	*/

	update_icon()


/turf/simulated/wall/Destroy()
	STOP_PROCESSIN69(SSturf, src)
	dismantle_wall(null,null,1)
	. = ..()

/turf/simulated/wall/Process(wait, times_fired)
	// Callin69 parent will kill processin69
	var/how_often =69ax(round(2 SECONDS / wait), 1)
	if(times_fired % how_often)
		return //We only work about every 2 seconds
	if(!radiate())
		return PROCESS_KILL

// Extracts an69le's tan if ischance = TRUE.
// In other case it just69akes bullets and lazorz 69o where they're supposed to.

/turf/simulated/wall/proc/projectile_reflection(obj/item/projectile/Proj,69ar/ischance = FALSE)
	if(Proj.startin69)
		var/ricochet_temp_id = rand(1,1000)
		if(!ischance)
			Proj.ricochet_id = ricochet_temp_id
		var/turf/curloc = 69et_turf(src)

		var/check_x0 = 32 * curloc.x
		var/check_y0 = 32 * curloc.y
		var/check_x1 = 32 * Proj.startin69.x
		var/check_y1 = 32 * Proj.startin69.y
		var/check_x2 = 32 * Proj.ori69inal.x
		var/check_y2 = 32 * Proj.ori69inal.y
		var/corner_x0 = check_x0
		var/corner_y0 = check_y0
		if(check_y0 - check_y1 > 0)
			corner_y0 = corner_y0 - 16
		else
			corner_y0 = corner_y0 + 16
		if(check_x0 - check_x1 > 0)
			corner_x0 = corner_x0 - 16
		else
			corner_x0 = corner_x0 + 16

		// Checks if ori69inal is lower or upper than line connectin69 proj's startin69 and wall
		// In specific coordinate system that has wall as (0,0) and 'startin69' as (r, 0), where r > 0.
		// So, this checks whether 'ori69inal's' y-coordinate is positive or69e69ative in69ew c.s.
		// In order to understand, in which direction bullet will ricochet.
		// Actually69ew_y isn't y-coordinate, but it has the same si69n.
		var/new_y = (check_y2 - corner_y0) * (check_x1 - corner_x0) - (check_x2 - corner_x0) * (check_y1 - corner_y0)
		// Here comes the thin69 which differs two situations:
		// First - bullet comes from69orth-west or south-east, with69e69ative func69alue. Second -69E or SW.
		var/new_func = (corner_x0 - check_x1) * (corner_y0 - check_y1)

		// Added these wall thin69s because69y ori69inal code works well with one-tiled walls, but i69nores adjacent turfs which in69y current opinion was pretty wron69.
		var/wallnorth = 0
		var/wallsouth = 0
		var/walleast = 0
		var/wallwest = 0
		for (var/turf/simulated/wall/W in ran69e(2, curloc))
			var/turf/tempwall = 69et_turf(W)
			if (tempwall.x == curloc.x)
				if (tempwall.y == (curloc.y - 1))
					wallnorth = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id
				else if (tempwall.y == (curloc.y + 1))
					wallsouth = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id
			if (tempwall.y == curloc.y)
				if (tempwall.x == (curloc.x + 1))
					walleast = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id
				else if (tempwall.x == (curloc.x - 1))
					wallwest = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id

		if((wallnorth || wallsouth) && ((Proj.startin69.y - curloc.y)*(wallsouth - wallnorth) >= 0))
			if(!ischance)
				Proj.redirect(round(check_x1 / 32), round((2 * check_y0 - check_y1)/32), curloc, src)
				return
			else
				return abs((check_y0 - check_y1) / (check_x0 - check_x1))

		if((walleast || wallwest) && ((Proj.startin69.x - curloc.x)*(walleast-wallwest) >= 0))
			if(!ischance)
				Proj.redirect(round((2 * check_x0 - check_x1) / 32), round(check_y1 / 32), curloc, src)
				return
			else
				return abs((check_x0 - check_x1) / (check_y0 - check_y1))

		if((new_y *69ew_func) > 0)
			if(!ischance)
				Proj.redirect(round((2 * check_x0 - check_x1) / 32), round(check_y1 / 32), curloc, src)
			else
				return abs((check_x0 - check_x1) / (check_y0 - check_y1))
		else
			if(!ischance)
				Proj.redirect(round(check_x1 / 32), round((2 * check_y0 - check_y1)/32), curloc, src)
			else
				return abs((check_y0 - check_y1) / (check_x0 - check_x1))
		return


/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)

	if(src.ricochet_id != 0)
		if(src.ricochet_id == Proj.ricochet_id)
			src.ricochet_id = 0
			new /obj/effect/sparks(69et_turf(Proj))
			return PROJECTILE_CONTINUE
		src.ricochet_id = 0
	var/proj_dama69e = Proj.69et_structure_dama69e()
	if(istype(Proj,/obj/item/projectile/beam))
		burn(500)//TODO : fuckin69 write these two procs69ot only for plasma (see plasma in69aterials.dm:283) ~
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	if(Proj.can_ricochet && proj_dama69e != 0 && (src.x != Proj.startin69.x) && (src.y != Proj.startin69.y))
		var/ricochetchance = 1
		if(proj_dama69e <= 60)
			ricochetchance = 2 + round((60 - proj_dama69e) / 5)
			ricochetchance =69in(ricochetchance * ricochetchance, 100)
		// here it is69ultiplied by 1/2 temporally, chan69es will be re69uired when69ew wall system 69ets implemented
		ricochetchance = round(ricochetchance * projectile_reflection(Proj, TRUE) / 2)
		
		ricochetchance *= Proj.ricochet_ability
		ricochetchance =69in(max(ricochetchance, 0), 100)
		if(prob(ricochetchance))
			// projectile loses up to 50% of its dama69e when it ricochets, dependin69 on situation
			var/dama69ediff = round(proj_dama69e / 2 + proj_dama69e * ricochetchance / 200) // projectile loses up to 50% of its dama69e when it ricochets, dependin69 on situation
			Proj.dama69e_types69BRUTE69 = round(Proj.dama69e_types69BRUTE69 / 2 + Proj.dama69e_types69BRUTE69 * ricochetchance / 200)
			Proj.dama69e_types69BURN69 = round(Proj.dama69e_types69BURN69 / 2 + Proj.dama69e_types69BURN69 * ricochetchance / 200)
			take_dama69e(min(proj_dama69e - dama69ediff, 100))
			visible_messa69e("<span class='dan69er'>The 69Proj69 ricochets from the surface of wall!</span>")
			projectile_reflection(Proj)
			new /obj/effect/sparks(69et_turf(Proj))
			return PROJECTILE_CONTINUE // complete projectile permutation

	//cut some projectile dama69e here and69ot in projectile.dm, because we69eed69ot to all thin69s what are usin69 69et_str_dam() becomes thin and weak.
	//in 69eneral, bullets have 35-95 dama69e, and they are plased in ~30 bullets69a69azines, so 50*30 = 150, but plasteel walls have only 400 hp =|
	//but you69ay also increase69aterials thickness or etc.
	proj_dama69e = round(Proj.69et_structure_dama69e() / 3)//Yo69ay replace 3 to 5-6 to69ake walls fuckin69 stronk as a Poland

	//cap the amount of dama69e, so that thin69s like emitters can't destroy walls in one hit.
	var/dama69e_taken = 0
	if(Proj.nocap_structures)
		dama69e_taken = proj_dama69e * 4
	else
		dama69e_taken =69in(proj_dama69e, 100)

	create_bullethole(Proj)//Potentially infinite bullet holes but69ost walls don't last lon69 enou69h for this to be a problem.

	if(Proj.dama69e_types69BRUTE69 && prob(src.dama69e / (material.inte69rity + reinf_material?.inte69rity) * 33))
		var/obj/item/trash/material/metal/slu69 =69ew(69et_turf(Proj))
		slu69.matter.Cut()
		slu69.matter69reinf_material ? reinf_material.name :69aterial.name69 = 0.1
		slu69.throw_at(69et_turf(Proj), 0, 1)

	take_dama69e(dama69e_taken)

/turf/simulated/wall/hitby(AM as69ob|obj,69ar/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return

	take_dama69e(tforce)


/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		69del(WR)
	for(var/obj/effect/plant/plant in ran69e(src, 1))
		if(plant.wall_mount == src) //shrooms drop to the floor
			69del(plant)
		plant.update_nei69hbors()

/turf/simulated/wall/Chan69eTurf(var/newtype)
	clear_plants()
	clear_bulletholes()
	..(newtype)

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!dama69e)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else
		var/dam = dama69e /69aterial.inte69rity
		if(dam <= 0.3)
			to_chat(user, SPAN_WARNIN69("It looks sli69htly dama69ed."))
		else if(dam <= 0.6)
			to_chat(user, SPAN_WARNIN69("It looks69oderately dama69ed."))
		else
			to_chat(user, SPAN_DAN69ER("It looks heavily dama69ed."))

	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, SPAN_WARNIN69("There is fun69us 69rowin69 on 69src69."))

//Dama69e

/turf/simulated/wall/melt()

	if(!can_melt())
		return

	src.Chan69eTurf(/turf/simulated/floor/platin69)

	var/turf/simulated/floor/F = src
	if(!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_messa69e(SPAN_DAN69ER("\The 69src69 spontaneously combusts!.")) //!!OH SHIT!!
	return

/turf/simulated/wall/proc/take_dama69e(dam)
	if(dam)
		dama69e =69ax(0, dama69e + dam)
		update_dama69e()
	return

/turf/simulated/wall/proc/update_dama69e()
	var/cap =69aterial.inte69rity
	if(reinf_material)
		cap += reinf_material.inte69rity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(dama69e >= cap)
		var/leftover = dama69e - cap
		if (leftover > 150)
			dismantle_wall(no_product = TRUE)
		else
			dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/fire_act(datum/69as_mixture/air, exposed_temperature, exposed_volume)//Doesn't fuckin69 work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/69as_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp >69aterial.meltin69_point)
		take_dama69e(lo69(RAND_DECIMAL(0.9, 1.1) * (adj_temp -69aterial.meltin69_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(devastated, explode,69o_product,69ob/user)
	playsound(src, 'sound/items/Welder.o6969', 100, 1)
	if(!no_product)
		if(reinf_material)
			reinf_material.place_dismantled_69irder(src, reinf_material)
		else
			material.place_dismantled_69irder(src)
		var/obj/sheets =69aterial.place_sheet(src, amount=3)
		sheets.add_fin69erprint(user)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/item/contraband/poster))
			var/obj/item/contraband/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	clear_plants()
	clear_bulletholes()
	material = 69et_material_by_name("placeholder")
	reinf_material =69ull
	update_connections(1)

	Chan69eTurf(/turf/simulated/floor/platin69)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1)
			take_dama69e(rand(500, 800))
		if(2)
			take_dama69e(rand(200, 500))
		if(3)
			take_dama69e(rand(90, 250))
		else
	return



/turf/simulated/wall/proc/can_melt()
	if(material.fla69s &69ATERIAL_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user)
	if(!can_melt())
		return
	var/obj/effect/overlay/O =69ew/obj/effect/overlay(src)
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.density = TRUE
	O.layer = 5

	src.Chan69eTurf(/turf/simulated/floor/platin69)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	to_chat(user, SPAN_WARNIN69("The thermite starts69eltin69 throu69h the wall."))

	spawn(100)
		if(O)
			69del(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/radiate()
	var/total_radiation =69aterial.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	for(var/mob/livin69/L in ran69e(3,src))
		L.apply_effect(total_radiation, IRRADIATE,0)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if(material.combustion_effect(src, temperature, 0.7))//it wont return somethin69 in any way, this proc is commented and it belon69s to plasma69aterial.(see69aterials.dm:283)
		spawn(2)
			new /obj/structure/69irder(src)
			src.Chan69eTurf(/turf/simulated/floor)
			for(var/turf/simulated/wall/W in RAN69E_TURFS(3, src) - src)
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/plasma/D in ran69e(3,src))
				D.i69nite(temperature/4)
