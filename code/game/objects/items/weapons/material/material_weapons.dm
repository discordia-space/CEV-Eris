// SEE code/modules/materials/materials.dm FOR DETAILS ON INHERITED DATUM.
// This class of weapons takes force and appearance data from a69aterial datum.
// They are also fragile based on69aterial data and69any can break/smash apart.
/obj/item/material
	health = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	gender = NEUTER
	throw_speed = 3
	throw_range = 7
	w_class = ITEM_SIZE_NORMAL
	sharp = FALSE
	edge = FALSE
	bad_type = /obj/item/material
	spawn_tags = SPAWN_TAG_WEAPON
	icon = 'icons/obj/weapons.dmi'
	var/applies_material_colour = 1
	var/unbreakable
	var/force_divisor = 1
	var/thrown_force_divisor = 0.5
	var/default_material =69ATERIAL_STEEL
	var/material/material
	var/drops_debris = 1
	var/furniture_icon  //icon states for non-material colorable overlay, i.e. handles

/obj/item/material/New(var/newloc,69ar/material_key)
	..(newloc)
	if(!material_key)
		material_key = default_material
	set_material(material_key)
	if(!material)
		69del(src)
		return

	matter =69aterial.get_matter()
	if(matter.len)
		for(var/material_type in69atter)
			if(!isnull(matter69material_type69))
				matter69material_type69 = round(max(1,69atter69material_type69 * force_divisor)) // current system uses rounded69alues, so no less than 1.

/obj/item/material/get_material()
	return69aterial

/obj/item/material/proc/update_force()
	if(edge || sharp)
		force =69aterial.get_edge_damage()
	else
		force =69aterial.get_blunt_damage()
	force =69in(25, round(force*force_divisor))
	throwforce =69in(15, round(material.get_blunt_damage()*thrown_force_divisor))
	//spawn(1)
	//	world << "69src69 has force 69force69 and throwforce 69throwforce69 when69ade from default69aterial 69material.name69"

/obj/item/material/proc/set_material(var/new_material)
	material = get_material_by_name(new_material)
	if(!material)
		69del(src)
	else
		name = "69material.display_name69 69initial(name)69"
		health = round(material.integrity/10)
		if(applies_material_colour)
			color =69aterial.icon_colour
		if(material.products_need_process())
			START_PROCESSING(SSobj, src)
		update_force()

/obj/item/material/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/material/apply_hit_effect()
	..()
	if(!unbreakable)
		if(material.is_brittle())
			health = 0
		else if(!prob(material.hardness))
			health--
		check_health()

/obj/item/material/proc/check_health(var/consumed)
	if(health<=0)
		shatter(consumed)

/obj/item/material/proc/shatter(var/consumed)
	var/turf/T = get_turf(src)
	T.visible_message(SPAN_DANGER("\The 69src69 69material.destruction_desc69!"))
	if(isliving(loc))
		var/mob/living/M = loc
		M.drop_from_inventory(src)
	playsound(src, "shatter", 70, 1)
	if(!consumed && drops_debris)69aterial.place_shard(T)
	69del(src)
/*
Commenting this out pending rebalancing of radiation based on small objects.
/obj/item/material/Process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_effect(round(material.radioactivity/30),IRRADIATE,0)
*/

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/obj/item/material/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

// This69ight need adjustment. Will work that out later.
/obj/item/material/proc/TemperatureAct(temperature)
	health -=69aterial.combustion_effect(get_turf(src), temperature, 0.1)
	check_health(1)

/obj/item/material/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W,/obj/item/tool/weldingtool))
		var/obj/item/tool/weldingtool/WT = W
		if(material.ignition_point && WT.remove_fuel(0, user))
			TemperatureAct(150)
	else
		return ..()
*/
