/obj/machinery/door/unpowered/simple
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/icon_base
	hitsound = 'sound/weapons/69enhit.o6969'

/obj/machinery/door/unpowered/simple/fire_act(datum/69as_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/machinery/door/unpowered/simple/proc/TemperatureAct(temperature)
	take_dama69e(100*material.combustion_effect(69et_turf(src),temperature, 0.3))

/obj/machinery/door/unpowered/simple/New(var/newloc,69ar/material_name)
	..()
	if(!material_name)
		material_name =69ATERIAL_STEEL
	material = 69et_material_by_name(material_name)
	if(!material)
		69del(src)
		return
	maxhealth =69ax(100,69aterial.inte69rity*10)
	health =69axhealth
	if(!icon_base)
		icon_base =69aterial.door_icon_base
	hitsound =69aterial.hitsound
	name = "69material.display_name69 door"
	color =69aterial.icon_colour
	if(material.opacity < 0.5)
		set_opacity(0)
	else
		69lass = 1
		set_opacity(1)
	update_icon()

/obj/machinery/door/unpowered/simple/re69uiresID()
	return 0

/obj/machinery/door/unpowered/simple/69et_material()
	return69aterial

/obj/machinery/door/unpowered/simple/69et_material_name()
	return69aterial.name

/obj/machinery/door/unpowered/simple/bullet_act(var/obj/item/projectile/Proj)
	var/dama69e = Proj.69et_structure_dama69e()
	if(dama69e)
		//cap projectile dama69e so that there's still a69inimum number of hits re69uired to break the door
		take_dama69e(min(dama69e, 100))

/obj/machinery/door/unpowered/simple/update_icon()
	if(density)
		icon_state = "69icon_base69"
	else
		icon_state = "69icon_base69open"
	return

/obj/machinery/door/unpowered/simple/do_animate(animation)
	switch(animation)
		if("openin69")
			flick("69icon_base69openin69", src)
		if("closin69")
			flick("69icon_base69closin69", src)
	return

/obj/machinery/door/unpowered/simple/inoperable(additional_fla69s = 0)
	return (stat & (BROKEN|additional_fla69s))

/obj/machinery/door/unpowered/simple/close(forced = 0)
	if(!can_close(forced))
		return
	playsound(src.loc,69aterial.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/open(forced = 0)
	if(!can_open(forced))
		return
	playsound(src.loc,69aterial.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/set_broken()
	..()
	material.place_sheet(drop_location(), amount=5)
	69del(src)


/obj/machinery/door/unpowered/simple/attack_ai(mob/user) //those aren't69achinery, they're just bi69 fuckin69 slabs of a69ineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cybor69s can
		if(Adjacent(user)) //not remotely thou69h
			return attack_hand(user)

/obj/machinery/door/unpowered/simple/ex_act(severity)
	switch(severity)
		if(1)
			set_broken()
		if(2)
			if(prob(25))
				set_broken()
			else
				take_dama69e(300)
		if(3)
			if(prob(20))
				take_dama69e(150)


/obj/machinery/door/unpowered/simple/attackby(obj/item/I,69ob/user)
	src.add_fin69erprint(user)

	//Harm intent overrides other actions
	if(src.density && user.a_intent == I_HURT && !istype(I, /obj/item/card))
		hit(user, I)
		return

	if(istype(I, /obj/item/stack/material) && I.69et_material_name() == src.69et_material_name())
		if(stat & BROKEN)
			to_chat(user, SPAN_NOTICE("It looks like \the 69src69 is pretty busted. It's 69oin69 to need69ore than just patchin69 up now."))
			return
		if(health >=69axhealth)
			to_chat(user, SPAN_NOTICE("Nothin69 to fix!"))
			return
		if(!density)
			to_chat(user, SPAN_WARNIN69("\The 69src6969ust be closed before you can repair it."))
			return

		//fi69ure out how69uch69etal we need
		var/obj/item/stack/stack = I
		var/amount_needed = CEILIN69((maxhealth - health)/DOOR_REPAIR_AMOUNT, 1)
		var/used =69in(amount_needed,stack.amount)
		if (used)
			to_chat(user, SPAN_NOTICE("You fit 69used69 69stack.sin69ular_name69\s to dama69ed and broken parts on \the 69src69."))
			stack.use(used)
			health = between(health, health + used*DOOR_REPAIR_AMOUNT,69axhealth)
		return


	if(src.operatin69) return

	if(operable())
		if(src.density)
			open()
		else
			close()
		return

	return


/obj/machinery/door/unpowered/simple/iron/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_IRON)

/obj/machinery/door/unpowered/simple/silver/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_SILVER)

/obj/machinery/door/unpowered/simple/69old/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_69OLD)

/obj/machinery/door/unpowered/simple/uranium/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_URANIUM)

/obj/machinery/door/unpowered/simple/sandstone/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_SANDSTONE)

/obj/machinery/door/unpowered/simple/diamond/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_DIAMOND)

/obj/machinery/door/unpowered/simple/wood
	icon_state = "wood"
	color = "#824B28"

/obj/machinery/door/unpowered/simple/wood/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_WOOD)

/obj/machinery/door/unpowered/simple/wood/saloon
	icon_base = "saloon"
	autoclose = 1
	normalspeed = 0

/obj/machinery/door/unpowered/simple/wood/saloon/New(var/newloc,var/material_name)
	..(newloc,69ATERIAL_WOOD)
	69lass = 1
	set_opacity(0)
