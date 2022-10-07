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
	var/list/materials_armorpart = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 10)
	var/list/materials_ammo = list(MATERIAL_STEEL = 10, MATERIAL_CARDBOARD = 1)
	var/list/materials_rocket = list(MATERIAL_PLASMA = 5, MATERIAL_PLASTIC = 5, MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 10)
	var/list/materials_lbarrel = list(MATERIAL_PLASTEEL = 8)
	var/list/materials_sbarrel = list(MATERIAL_PLASTEEL = 4)
	var/list/materials_lmechanism = list(MATERIAL_PLASTEEL = 10)
	var/list/materials_smechanism = list(MATERIAL_PLASTEEL = 5)
	var/list/materials_lbarrel_steel = list(MATERIAL_STEEL = 8)
	var/list/materials_sbarrel_steel = list(MATERIAL_STEEL = 4)
	var/list/materials_lmechanism_steel = list(MATERIAL_STEEL = 10)
	var/list/materials_smechanism_steel = list(MATERIAL_STEEL = 5)
	var/list/materials_hpart = list(MATERIAL_PLASTEEL = 16)
	var/list/materials_pgrip = list(MATERIAL_PLASTIC = 6)
	var/list/materials_wgrip = list(MATERIAL_WOOD = 6)

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
		"armor parts" = materials_armorpart,
		"barrels" = "4 plasteel for small; 8 plasteel for large; 16 plasteel for heavy",
		"mechanisms" ="5 plasteel for small; 10 plasteel for large; 16 plasteel for heavy",
		"cheap barrels" = "4 steel for small; 8 steel for large",
		"cheap mechanisms" = "5 steel for small; 10 steel for large",
		"grips" = "6 plastic or 6 wood")

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

	var/list/required_resources = list()
	var/list/items_to_spawn = list()

	var/choice = input(user, "What do you want to craft?") as null|anything in list("Ammunition","RPG shell","Gun parts","Armor parts")
	switch(choice)
		if("Ammunition")
			required_resources = materials_ammo

		if("RPG shell")
			required_resources = materials_rocket
			items_to_spawn = list("" = /obj/item/ammo_casing/rocket/scrap/prespawned)

		if("Gun parts")
			choice = input(user, "Which type of part do you want to craft?") as null|anything in list("Small parts", "Large parts", "Heavy parts", "Cheap parts", "Grips")
			switch(choice)
				if("Small parts")
					choice = input(user, "Which type of part do you want to craft?") as null|anything in list("Barrels", "Mechanisms")
					switch(choice)
						if("Barrels")
							required_resources = materials_sbarrel
							choice = input(user) as null|anything in list(".35 barrel", ".40 barrel")
							switch(choice)
								if(".35 barrel")
									items_to_spawn = list("" = /obj/item/part/gun/barrel/pistol)
								if(".40 barrel")
									items_to_spawn = list("" = /obj/item/part/gun/barrel/magnum)
						if("Mechanisms")
							required_resources = materials_smechanism
							choice = input(user) as null|anything in list("Pistol mechanism", "Revolver mechanism", "SMG mechanism")
							switch(choice)
								if("Pistol mechanism")
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/pistol)
								if("Revolver mechanism")
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/revolver)
								if("SMG mechanism")
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/smg)

				if("Large parts")
					choice = input(user, "Which type of part do you want to craft?") as null|anything in list("Barrels", "Mechanisms")
					switch(choice)
						if("Barrels")
							required_resources = materials_lbarrel
							choice = input(user) as null|anything in list(".20 barrel", ".25 barrel", ".30 barrel", "Shotgun barrel")
							switch(choice)
								if(".20 barrel")
									items_to_spawn = list("" = /obj/item/part/gun/barrel/srifle)
								if(".25 barrel")
									items_to_spawn = list("" = /obj/item/part/gun/barrel/clrifle)
								if(".30 barrel")
									items_to_spawn = list("" = /obj/item/part/gun/barrel/lrifle)
								if("Shotgun barrel")
									items_to_spawn = list("" = /obj/item/part/gun/barrel/shotgun)									
						if("Mechanisms")
							required_resources = materials_lmechanism
							choice = input(user) as null|anything in list("Self-loading mechanism", "Shotgun mechanism")
							switch(choice)					
								if("Self-loading mechanism")
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/autorifle)
								if("Shotgun mechanism")
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/shotgun)

				if("Heavy parts")
					required_resources = materials_hpart
					choice = input(user, "Which type of part do you want to craft?") as null|anything in list("Anti-materiel barrel", "Machinegun mechanism")
					switch(choice)
						if("Anti-materiel barrel")
							items_to_spawn = list("" = /obj/item/part/gun/barrel/antim)
						if("Machinegun mechanism")
							items_to_spawn = list("" = /obj/item/part/gun/mechanism/machinegun)
					
				if("Cheap parts")
					choice = input(user, "Which type of part do you want to craft?") as null|anything in list("Barrels", "Mechanisms")
					switch(choice)
						if("Barrels")
							choice = input(user) as null|anything in list(".35 barrel", ".40 barrel", ".20 barrel", ".25 barrel", ".30 barrel", "Shotgun barrel")
							switch(choice)
								if(".35 barrel")
									required_resources = materials_sbarrel_steel
									items_to_spawn = list("" = /obj/item/part/gun/barrel/pistol/steel)
								if(".40 barrel")
									required_resources = materials_sbarrel_steel
									items_to_spawn = list("" = /obj/item/part/gun/barrel/magnum/steel)
								if(".20 barrel")
									required_resources = materials_lbarrel_steel
									items_to_spawn = list("" = /obj/item/part/gun/barrel/srifle/steel)
								if(".25 barrel")
									required_resources = materials_lbarrel_steel
									items_to_spawn = list("" = /obj/item/part/gun/barrel/clrifle/steel)
								if(".30 barrel")
									required_resources = materials_lbarrel_steel
									items_to_spawn = list("" = /obj/item/part/gun/barrel/lrifle/steel)
								if("Shotgun barrel")
									required_resources = materials_lbarrel_steel
									items_to_spawn = list("" = /obj/item/part/gun/barrel/shotgun/steel)
						if("Mechanisms")
							choice = input(user) as null|anything in list("Pistol mechanism", "Revolver mechanism", "SMG mechanism", "Manual-action mechanism", "Self-loading mechanism", "Shotgun mechanism")
							switch(choice)
								if("Pistol mechanism")
									required_resources = materials_smechanism_steel
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/pistol/steel)
								if("Revolver mechanism")
									required_resources = materials_smechanism_steel
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/revolver/steel)
								if("SMG mechanism")
									required_resources = materials_smechanism_steel
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/smg/steel)
								if("Manual-action mechanism")
									required_resources = materials_lmechanism_steel
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/boltgun)
								if("Self-loading mechanism")
									required_resources = materials_lmechanism_steel
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/autorifle/steel)
								if("Shotgun mechanism")
									required_resources = materials_lmechanism_steel
									items_to_spawn = list("" = /obj/item/part/gun/mechanism/shotgun/steel)

				if("Grips")
					choice = input(user) as null|anything in list("Plastic grip", "Rubber grip", "Excelsior grip", "Bakelite grip", "Wooden grip")
					switch(choice)
						if("Plastic grip")
							required_resources = materials_pgrip
							items_to_spawn = list("" = /obj/item/part/gun/grip/black)
						if("Rubber grip")
							required_resources = materials_pgrip
							items_to_spawn = list("" = /obj/item/part/gun/grip/rubber)
						if("Excelsior grip")
							required_resources = materials_pgrip
							items_to_spawn = list("" = /obj/item/part/gun/grip/excel)
						if("Bakelite grip")
							required_resources = materials_pgrip
							items_to_spawn = list("" = /obj/item/part/gun/grip/serb)
						if("Wooden grip")
							required_resources = materials_wgrip
							items_to_spawn = list("" = /obj/item/part/gun/grip/wood)

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
