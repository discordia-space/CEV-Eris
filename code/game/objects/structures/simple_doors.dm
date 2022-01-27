/obj/structure/simple_door
	name = "door"
	density = TRUE
	anchored = TRUE

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7

/obj/structure/simple_door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/structure/simple_door/proc/TemperatureAct(temperature)
	hardness -=69aterial.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHardness()

/obj/structure/simple_door/New(var/newloc,69ar/material_name)
	..()
	if(!material_name)
		material_name =69ATERIAL_STEEL
	material = get_material_by_name(material_name)
	if(!material)
		69del(src)
		return
	hardness =69ax(1,round(material.integrity/10))
	icon_state =69aterial.door_icon_base
	name = "69material.display_name69 door"
	color =69aterial.icon_colour
	if(material.opacity < 0.5)
		set_opacity(FALSE)
	else
		set_opacity(TRUE)
	if(material.products_need_process())
		START_PROCESSING(SSobj, src)
	update_nearby_tiles(need_rebuild=1)

/obj/structure/simple_door/Destroy()
	STOP_PROCESSING(SSobj, src)
	update_nearby_tiles()
	. = ..()

/obj/structure/simple_door/get_material()
	return69aterial

/obj/structure/simple_door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/simple_door/attack_ai(mob/user as69ob) //those aren't69achinery, they're just big fucking slabs of a69ineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/simple_door/attack_hand(mob/user as69ob)
	return TryToSwitchState(user)

/obj/structure/simple_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/simple_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(!material.can_open_material_door(user))
			return
		if(world.time - user.last_bumped <= 60)
			return
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C =69
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(istype(user, /mob/living/exosuit))
		SwitchState()

/obj/structure/simple_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/simple_door/proc/Open()
	isSwitchingStates = 1
	playsound(loc,69aterial.dooropen_noise, 100, 1)
	flick("69material.door_icon_base69opening",src)
	sleep(10)
	density = FALSE
	set_opacity(FALSE)
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc,69aterial.dooropen_noise, 100, 1)
	flick("69material.door_icon_base69closing",src)
	sleep(10)
	density = TRUE
	set_opacity(TRUE)
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/update_icon()
	if(state)
		icon_state = "69material.door_icon_base69open"
	else
		icon_state =69aterial.door_icon_base

/obj/structure/simple_door/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W,/obj/item/pickaxe))
		var/obj/item/pickaxe/digTool = W
		user << "You start digging the 69name69."
		if(do_after(user,digTool.digspeed*hardness) && src)
			user << "You finished digging."
			Dismantle()
	else if(istype(W,/obj/item)) //not sure, can't not just weapons get passed to this proc?
		hardness -= W.force/100
		user << "You hit the 69name69 with your 69W.name69!"
		CheckHardness()
	else if(istype(W,/obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		attack_hand(user)
	return

/obj/structure/simple_door/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/simple_door/proc/Dismantle(devastated = 0)
	material.place_dismantled_product(get_turf(src))
	69del(src)

/obj/structure/simple_door/ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
			else
				hardness--
				CheckHardness()
		if(3)
			hardness -= 0.1
			CheckHardness()
	return

/obj/structure/simple_door/process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/3),IRRADIATE,0)

/obj/structure/simple_door/iron/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_IRON)

/obj/structure/simple_door/silver/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_SILVER)

/obj/structure/simple_door/gold/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_GOLD)

/obj/structure/simple_door/uranium/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_URANIUM)

/obj/structure/simple_door/sandstone/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_SANDSTONE)

/obj/structure/simple_door/plasma/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_PLASMA)

/obj/structure/simple_door/diamond/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_DIAMOND)

/obj/structure/simple_door/wood/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_WOOD)

