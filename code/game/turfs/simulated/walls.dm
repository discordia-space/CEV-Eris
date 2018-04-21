/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = 0
	var/material/material
	var/material/reinf_material
	var/last_state
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/list/wall_connections = list("0", "0", "0", "0")

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/New(var/newloc, var/materialtype, var/rmaterialtype)
	..(newloc)
	icon_state = "blank"
	if(!materialtype)
		materialtype = MATERIAL_STEEL
	material = get_material_by_name(materialtype)
	if(!isnull(rmaterialtype))
		reinf_material = get_material_by_name(rmaterialtype)
	update_material()
	hitsound = material.hitsound
	processing_turfs |= src

/turf/simulated/wall/Destroy()
	processing_turfs -= src
	dismantle_wall(null,null,1)
	. = ..()

/turf/simulated/wall/Process()
	// Calling parent will kill processing
	if(!radiate())
		return PROCESS_KILL

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(500)//TODO : fucking write these two procs not only for plasma (see plasma in materials.dm:283) ~
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	//cut some projectile damage here and not in projectile.dm, becouse we need not to all things what are using get_str_dam() becomes thin and weak.
	//in general, bullets have 35-95 damage, and they are plased in ~30 bullets magazines, so 50*30 = 150, but plasteel walls have only 400 hp =|
	//but you may also increase materials thickness or etc.
	var/proj_damage = Proj.get_structure_damage() / 3//Yo may replace 3 to 5-6 to make walls fucking stronk as a Poland

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	take_damage(damage)
	return

/turf/simulated/wall/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return

	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if (tforce < 15)
		return

	take_damage(tforce)

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/plant/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0
		plant.update_neighbors()

/turf/simulated/wall/ChangeTurf(var/newtype)
	clear_plants()
	..(newtype)

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!damage)
		user << SPAN_NOTICE("It looks fully intact.")
	else
		var/dam = damage / material.integrity
		if(dam <= 0.3)
			user << SPAN_WARNING("It looks slightly damaged.")
		else if(dam <= 0.6)
			user << SPAN_WARNING("It looks moderately damaged.")
		else
			user << SPAN_DANGER("It looks heavily damaged.")

	if(locate(/obj/effect/overlay/wallrot) in src)
		user << SPAN_WARNING("There is fungus growing on [src].")

//Damage

/turf/simulated/wall/melt()

	if(!can_melt())
		return

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	if(!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message(SPAN_DANGER("\The [src] spontaneously combusts!.")) //!!OH SHIT!!
	return

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		if(reinf_material)
			reinf_material.place_dismantled_girder(src, reinf_material)
		else
			material.place_dismantled_girder(src)
		material.place_dismantled_product(src,devastated)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/item/weapon/contraband/poster))
			var/obj/item/weapon/contraband/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src

	clear_plants()
	material = get_material_by_name("placeholder")
	reinf_material = null
	update_connections(1)

	ChangeTurf(/turf/simulated/floor/plating)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(get_base_turf(src.z))
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))
		else
	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(material.flags & MATERIAL_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(!can_melt())
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.density = 1
	O.layer = 5

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "wall_thermite"
	user << SPAN_WARNING("The thermite starts melting through the wall.")

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	for(var/mob/living/L in range(3,src))
		L.apply_effect(total_radiation, IRRADIATE,0)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if(material.combustion_effect(src, temperature, 0.7))//it wont return something in any way, this proc is commented and it belongs to plasma material.(see materials.dm:283)
		spawn(2)
			new /obj/structure/girder(src)
			src.ChangeTurf(/turf/simulated/floor)
			for(var/turf/simulated/wall/W in trange(3, src) - src)
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/plasma/D in range(3,src))
				D.ignite(temperature/4)
