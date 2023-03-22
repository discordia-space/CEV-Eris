/obj/machinery/door/unpowered/simple
	name = "door"
	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/icon_base
	hitsound = 'sound/weapons/genhit.ogg'

/obj/machinery/door/unpowered/simple/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/machinery/door/unpowered/simple/proc/TemperatureAct(temperature)
	take_damage(100*material.combustion_effect(get_turf(src),temperature, 0.3))

/obj/machinery/door/unpowered/simple/New(var/newloc, var/material_name)
	..()
	if(!material_name)
		material_name = MATERIAL_STEEL
	material = get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	maxHealth = max(100, material.integrity*10)
	health = maxHealth
	if(!icon_base)
		icon_base = material.door_icon_base
	hitsound = material.hitsound
	name = "[material.display_name] door"
	color = material.icon_colour
	if(material.opacity < 0.5)
		set_opacity(0)
	else
		glass = 1
		set_opacity(1)
	update_icon()

/obj/machinery/door/unpowered/simple/requiresID()
	return 0

/obj/machinery/door/unpowered/simple/get_material()
	return material

/obj/machinery/door/unpowered/simple/get_material_name()
	return material.name

/obj/machinery/door/unpowered/simple/bullet_act(var/obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()
	if(damage)
		//cap projectile damage so that there's still a minimum number of hits required to break the door
		take_damage(min(damage, 100))

/obj/machinery/door/unpowered/simple/update_icon()
	if(density)
		icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]open"
	return

/obj/machinery/door/unpowered/simple/do_animate(animation)
	switch(animation)
		if("opening")
			flick("[icon_base]opening", src)
		if("closing")
			flick("[icon_base]closing", src)
	return

/obj/machinery/door/unpowered/simple/inoperable(additional_flags = 0)
	return (stat & (BROKEN|additional_flags))

/obj/machinery/door/unpowered/simple/close(forced = 0)
	if(!can_close(forced))
		return
	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/open(forced = 0)
	if(!can_open(forced))
		return
	playsound(src.loc, material.dooropen_noise, 100, 1)
	..()

/obj/machinery/door/unpowered/simple/set_broken()
	..()
	material.place_sheet(drop_location(), amount=5)
	qdel(src)


/obj/machinery/door/unpowered/simple/attack_ai(mob/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(Adjacent(user)) //not remotely though
			return attack_hand(user)

/obj/machinery/door/unpowered/simple/take_damage(damage)
	. = ..()
	if(QDELETED(src))
		return .
	if(health < maxHealth * 0.75)
		set_broken()

/obj/machinery/door/unpowered/simple/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)

	//Harm intent overrides other actions
	if(src.density && user.a_intent == I_HURT && !istype(I, /obj/item/card))
		hit(user, I)
		return

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
			return
		if(health >= maxHealth)
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
			return
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return

		//figure out how much metal we need
		var/obj/item/stack/stack = I
		var/amount_needed = CEILING((maxHealth - health)/DOOR_REPAIR_AMOUNT, 1)
		var/used = min(amount_needed,stack.amount)
		if (used)
			to_chat(user, SPAN_NOTICE("You fit [used] [stack.singular_name]\s to damaged and broken parts on \the [src]."))
			stack.use(used)
			health = between(health, health + used*DOOR_REPAIR_AMOUNT, maxHealth)
		return


	if(src.operating) return

	if(operable())
		if(src.density)
			open()
		else
			close()
		return

	return


/obj/machinery/door/unpowered/simple/iron/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_IRON)

/obj/machinery/door/unpowered/simple/silver/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_SILVER)

/obj/machinery/door/unpowered/simple/gold/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_GOLD)

/obj/machinery/door/unpowered/simple/uranium/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_URANIUM)

/obj/machinery/door/unpowered/simple/sandstone/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_SANDSTONE)

/obj/machinery/door/unpowered/simple/diamond/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_DIAMOND)

/obj/machinery/door/unpowered/simple/wood
	icon_state = "wood"
	color = "#824B28"

/obj/machinery/door/unpowered/simple/wood/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_WOOD)

/obj/machinery/door/unpowered/simple/wood/saloon
	icon_base = "saloon"
	autoclose = 1
	normalspeed = 0

/obj/machinery/door/unpowered/simple/wood/saloon/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_WOOD)
	glass = 1
	set_opacity(0)
