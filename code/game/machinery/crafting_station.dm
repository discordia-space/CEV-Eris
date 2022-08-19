/obj/machinery/craftingstation
	name = "crafting station"
	desc = "Makeshift fabrication station for home-made munitions and components of firearms and armor."
	icon = 'icons/obj/machines/crafting_station.dmi'
	icon_state = "craft"
	circuit = /obj/item/electronics/circuitboard/crafting_station
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/is_working = FALSE
	var/storage_capacity = 20 // How many of each resource could be stored. Multiplied by matter bin rating
	var/productivity_bonus = 2 // Sum of micro-laser and manipulator ratings, increases effectiveness of ammo crafting
	var/list/materials_stored = list()
	var/list/materials_compatible = list (MATERIAL_PLASTEEL, MATERIAL_STEEL, MATERIAL_PLASTIC, MATERIAL_WOOD, MATERIAL_CARDBOARD, MATERIAL_PLASMA)
	var/list/materials_gunpart = list(MATERIAL_PLASTEEL = 5)
	var/list/materials_armorpart = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 20)
	var/list/materials_ammo = list(MATERIAL_STEEL = 10, MATERIAL_CARDBOARD = 1)
	var/list/materials_rocket = list(MATERIAL_PLASMA = 5, MATERIAL_PLASTIC = 5, MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 10)

	// A vis_contents hack for materials loading animation.
	var/tmp/obj/effect/flick_light_overlay/image_load


/obj/machinery/craftingstation/Initialize()
	. = ..()
	image_load = new(src)


/obj/machinery/craftingstation/examine(user)
	. = ..()
	var/list/craft_options = list(
		"ammunition" = materials_ammo,
		"RPG shell" = materials_rocket,
		"gun parts" = materials_gunpart,
		"armor parts" = materials_armorpart)

	for(var/i in craft_options)
		var/list/required_materials = craft_options[i]
		var/list/requirements = list()
		for(var/material in required_materials)
			requirements += "[required_materials[material]] [material]"
		to_chat(user, SPAN_NOTICE("Materials required to craft [i]: [english_list(requirements)]."))

	var/list/matter_count = list()
	for(var/material in materials_stored)
		matter_count += " [materials_stored[material]] [material]"
	to_chat(user, SPAN_NOTICE("It contains: [english_list(matter_count)]."))


/obj/machinery/craftingstation/attackby(obj/item/I, mob/user)
	if(default_part_replacement(I, user))
		return

	if(default_deconstruction(I, user))
		return

	if(istype(I, /obj/item/stack/material))
		eat(user, I)
		return
	. = ..()


/obj/machinery/craftingstation/attack_hand(mob/living/user)
	if(!istype(user) || is_working || stat & NOPOWER || !in_range(src, user))
		return

	// Only one user can interact with the machine at the same time
	// This is always true, but we need to wait for that proc's return
	if(!interface(user))
		is_working = FALSE
		icon_state = "craft"
		flick("craft_done", src)


/obj/machinery/craftingstation/proc/interface(mob/living/user)
	is_working = TRUE
	icon_state = "craft_ready"
	flick("craft_warmup", src)

	var/choice = input(user, "What do you want to craft?") as null|anything in list(
		"Ammunition",
		"RPG shell",
		"Gun parts",
		"Armor parts")

	var/list/required_resources = list()
	var/list/items_to_spawn = list()

	switch(choice)
		if("Ammunition")
			required_resources = materials_ammo

		if("RPG shell")
			required_resources = materials_rocket
			items_to_spawn = list("" = /obj/item/ammo_casing/rocket/scrap/prespawned)

		if("Gun parts")
			required_resources = materials_gunpart
			items_to_spawn = list("" = /obj/item/part/gun)

		if("Armor parts")
			required_resources = materials_armorpart
			items_to_spawn = list("" = /obj/item/part/armor)
		else
			return

	for(var/i in required_resources)
		if(required_resources[i] > materials_stored[i])
			to_chat(user, SPAN_NOTICE("Not enough materials."))
			return

	if(!items_to_spawn.len)
		items_to_spawn = make_scrap_ammo(user, src, productivity_bonus)

	if(!items_to_spawn || !items_to_spawn.len)
		return

	update_use_power(ACTIVE_POWER_USE)
	icon_state = "craft_[pick("cut", "points", "square")]"

	if(do_mob(user, src, 5 SECONDS))
		var/tampering_detected
		for(var/i in required_resources)
			if(required_resources[i] == materials_stored[i])
				materials_stored.Remove(i)
			else if(required_resources[i] < materials_stored[i])
				materials_stored[i] -= required_resources[i]
			else // Materials pulled out during make_scrap_ammo()
				to_chat(user, SPAN_WARNING("Nice try, but you only wasted some materials."))
				tampering_detected = TRUE
				break

		if(!tampering_detected)
			for(var/i in items_to_spawn)
				var/item_type = items_to_spawn[i]
				new item_type(loc)

	update_use_power(IDLE_POWER_USE)


/obj/machinery/craftingstation/proc/eat(mob/living/carbon/user, obj/item/stack/material/M)
	if(stat || user.stat || !Adjacent(user) || !M.matter)
		return

	var/materials_used = 0
	var/material_type = M.default_type

	if(!(material_type in materials_compatible))
		to_chat(user, SPAN_WARNING("[src] can not hold [material_type]."))
		return

	if(materials_stored[material_type] >= storage_capacity)
		to_chat(user, SPAN_WARNING("The [src] is full of [material_type]."))
		return

	if(materials_stored[material_type] + M.amount > storage_capacity)
		materials_used = storage_capacity - materials_stored[material_type]
	else
		materials_used = M.amount

	materials_stored[material_type] += materials_used

	if(!M.use(materials_used))
		qdel(M)

	to_chat(user, SPAN_NOTICE("You add [materials_used] of [M]\s to \the [src]."))


/obj/machinery/craftingstation/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "craft_off"
	else
		icon_state = "craft"


/obj/machinery/craftingstation/RefreshParts()
	productivity_bonus = 0
	for(var/obj/item/stock_parts/i in component_parts)
		if(istype(i, /obj/item/stock_parts/matter_bin))
			storage_capacity = 20 * i.rating
		else
			productivity_bonus += i.rating


/obj/machinery/craftingstation/on_deconstruction()
	for(var/i in materials_stored)
		eject(i, materials_stored[i])

//Autolathes can eject decimal quantities of material as a shard
/obj/machinery/craftingstation/proc/eject(material/M, amount)
	if(!amount || !M.stack_type)
		return

	amount = min(amount, materials_stored[M])

	var/whole_amount = round(amount)
	var/remainder = amount - whole_amount

	if(whole_amount)
		var/obj/item/stack/material/S = new M.stack_type(drop_location())

		//Accounting for the possibility of too much to fit in one stack
		if(whole_amount <= S.max_amount)
			S.amount = whole_amount
			S.update_strings()
			S.update_icon()
		else
			//There's too much, how many stacks do we need
			var/fullstacks = round(whole_amount / S.max_amount)
			//And how many sheets leftover for this stack
			S.amount = whole_amount % S.max_amount

			if(!S.amount)
				qdel(S)

			for(var/i = 0; i < fullstacks; i++)
				var/obj/item/stack/material/MS = new M.stack_type(drop_location())
				MS.amount = MS.max_amount
				MS.update_strings()
				MS.update_icon()

	//And if there's any remainder, we eject that as a shard
	if(remainder)
		new /obj/item/material/shard(drop_location(), M, _amount = remainder)

	//The stored material gets the amount (whole+remainder) subtracted
	materials_stored[M] -= amount
