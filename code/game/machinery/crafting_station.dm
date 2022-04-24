#define WORK "work"
#define DONE "done"

/obj/machinery/craftingstation
	name = "crafting station"
	desc = "Makeshift fabrication station for home-made munitions and components of firearms and armor."
	icon = 'icons/obj/machines/crafting_station.dmi'
	icon_state = "craft"
	circuit = /obj/item/electronics/circuitboard/crafting_station
	density = TRUE
	anchored = TRUE
	layer = 2.8

	var/power_cost = 250

	var/working = FALSE
	var/start_working
	var/work_time = 20 SECONDS
	var/mat_efficiency = 15
	var/storage_capacity = 40
	var/list/stored_material = list()
	var/list/accepted_material = list (MATERIAL_PLASTEEL, MATERIAL_STEEL, MATERIAL_PLASTIC, MATERIAL_WOOD, MATERIAL_CARDBOARD, MATERIAL_PLASMA)
	var/list/needed_material_gunpart = list(MATERIAL_PLASTEEL = 5)
	var/list/needed_material_armorpart = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 20, MATERIAL_WOOD = 20,MATERIAL_CARDBOARD = 20)
	var/list/needed_material_ammo = list(MATERIAL_STEEL = 10, MATERIAL_CARDBOARD = 5)
	var/list/needed_material_rocket = list(MATERIAL_PLASMA = 5, MATERIAL_PLASTIC = 5, MATERIAL_PLASTEEL = 5, MATERIAL_STEEL = 10)

	// A vis_contents hack for materials loading animation.
	var/tmp/obj/effect/flick_light_overlay/image_load

/obj/machinery/craftingstation/Initialize()
	. = ..()

	image_load = new(src)


/obj/machinery/craftingstation/examine(user)
	. = ..()
	var/list/matter_count_need_ammo = list()
	var/list/matter_count_need_gunpart = list()
	var/list/matter_count_need_armorpart = list()
	var/list/matter_count_need_rocket = list()

	for(var/_material in needed_material_ammo)
		matter_count_need_ammo += "[needed_material_ammo[_material]] [_material]"

	for(var/_material in needed_material_gunpart)
		matter_count_need_gunpart += "[needed_material_ammo[_material]] [_material]"

	for(var/_material in needed_material_armorpart)
		matter_count_need_armorpart += "[needed_material_ammo[_material]] [_material]"

	for(var/_material in needed_material_rocket)
		matter_count_need_rocket += "[needed_material_rocket[_material]] [_material]"

	var/list/matter_count = list()
	for(var/_material in stored_material)
		matter_count += " [stored_material[_material]] [_material]"

	to_chat(user, SPAN_NOTICE("Materials required to craft ammunition: [english_list(matter_count_need_ammo)].\nMaterials required to craft gun parts: 5 [english_list(matter_count_need_gunpart)] \nMaterials required to craft armor parts: [english_list(matter_count_need_armorpart)] \n Materials required to craft RPG shell: [english_list(matter_count_need_rocket)].\nIt contains: [english_list(matter_count)]."))


/obj/machinery/craftingstation/attackby(obj/item/I, mob/user)
	if(default_part_replacement(I, user))
		return

	if(default_deconstruction(I, user))
		return

	if(istype(I, /obj/item/stack))
		eat(user, I)
		return
	. = ..()

/obj/machinery/craftingstation/attack_hand(mob/user as mob)
	if(working)
		to_chat(user, SPAN_NOTICE("You are already crafting something."))
		return

	var/cog_stat = user.stats.getStat(STAT_COG)

	var/list/options = list(
		".20 Rifle ammunition" = "srifle",
		".25 Caseless Rifle ammunition" = "clrifle",
		".30 Rifle ammunition" = "lrifle",
		".35 Auto ammunition" = "pistol",
		".40 Magnum ammunition" = "magnum",
		".50 Shotgun Buckshot ammunition" = "shot",
		".50 Shotgun Beanbag ammunition" = "bean",
		".50 Shotgun Slug ammunition" = "slug",
		".60 Anti-Material ammunition" = "antim",
		"RPG shell" = "rocket",
		"Gun parts" = "gunpart",
		"Armor parts"= "armorpart",
		)

	var/choice = input(user,"What do you want to craft?") as null|anything in options
	if(choice == null)
		return

	var/produce_type = options[choice]

	switch(produce_type)
		if("pistol")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("magnum")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("srifle")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("clrifle")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("lrifle")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("shot")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("bean")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("slug")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with"))
					return
		if("antim")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("rocket")
			for(var/material in needed_material_rocket)
				var/amount = needed_material_rocket[material]
				if(amount > stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return
		if("gunpart")
			if(stored_material[MATERIAL_PLASTEEL] < needed_material_gunpart[MATERIAL_PLASTEEL])
				to_chat(user, SPAN_NOTICE("You do not have enough plasteel to craft gun part."))
				return
		if("armorpart")
			for(var/material in needed_material_armorpart)
				var/amount = needed_material_armorpart[material]
				if(amount>stored_material[material])
					to_chat(user, SPAN_NOTICE("You don't have enough [material] to work with."))
					return

	flick("[initial(icon_state)]_warmup", src)
	working = TRUE
	START_PROCESSING(SSmachines, src)
	if(do_after(user, work_time, src))
		STOP_PROCESSING(SSmachines, src)
		working = FALSE
		flick("[initial(icon_state)]_done", src)
		icon_state = "[initial(icon_state)]"
		update_icon()
	else
		STOP_PROCESSING(SSmachines, src)
		working = FALSE
		flick("[initial(icon_state)]_done", src)
		icon_state = "[initial(icon_state)]"
		update_icon()
		return

	var/dice_roll = (rand(0,20) * (1 + cog_stat / mat_efficiency))

	if(user.stats.getPerk(/datum/perk/oddity/gunsmith))
		dice_roll = dice_roll * 2
	switch(produce_type)//God forgive me
		if("pistol")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]
			spawn_pistol(dice_roll,user)
		if("magnum")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_magnum(dice_roll,user)
		if("srifle")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_rifle(dice_roll,user,1)
		if("clrifle")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_rifle(dice_roll,user,2)
		if("lrifle")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_rifle(dice_roll,user,3)
		if("antim")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_antim(dice_roll,user)
		if("rocket")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]
			spawn_rocket(dice_roll,user)
		if("shot")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_shotgun(dice_roll,user,1)
		if("bean")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_shotgun(dice_roll,user,2)
		if("slug")
			for(var/_material in needed_material_ammo)
				stored_material[_material] -= needed_material_ammo[_material]

			spawn_shotgun(dice_roll,user,3)
		if("gunpart")
			for(var/_material in needed_material_gunpart)
				stored_material[_material] -= needed_material_gunpart[_material]

			spawn_gunpart(dice_roll,user)
		if("armorpart")
			for(var/_material in needed_material_armorpart)
				stored_material[_material] -= needed_material_armorpart[_material]

			spawn_armorpart(dice_roll,user)

	if(choice)
		user.visible_message("[user] finishes trying to craft some [choice] using [src]")
	else
		to_chat(user, "You reconsider the path of craftsmanship.")

////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_pistol(dice = 0, mob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

	var/boxxes = 0
	var/piles = 0
	var/mags = 0

	switch(dice)
		if(-99 to 10)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		if(10 to 20)
			mags = 1
		if(20 to 30)
			boxxes = 1
			mags = 1
		if(30 to 40)
			boxxes = 1
			mags = 2
		if(40 to 50)
			piles = 1
			boxxes = 2
			mags = 1
		else
			boxxes = 3+ round(dice/10-5,1)	//rich get richer

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/pistol/scrap/prespawned(get_turf(src))
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_magazine/ammobox/pistol/scrap(get_turf(src))
	if(mags)
		for(var/j = 1 to mags)
			if(prob(50))
				new /obj/item/ammo_magazine/pistol/scrap(get_turf(src))
			else
				new /obj/item/ammo_magazine/smg/scrap(get_turf(src))

//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_magnum(dice = 0, mob/user)

	var/boxxes = 0
	var/piles = 0
	var/mags = 0

	switch(dice)
		if(-99 to 8)
			piles = 2
		if(8 to 16)
			piles = 2
			mags = 1
		if(16 to 24)
			boxxes = 1
		if(24 to 32)
			boxxes = 1
			mags = 1
		if(32 to 40)
			piles = 2
			boxxes = 1
			mags = 1
		if(40 to 48)
			boxxes = 1
			mags = 3
		else
			boxxes = 3 + round(dice/10-5,1)

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/magnum/scrap/prespawned(get_turf(src))
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_magazine/ammobox/magnum/scrap(get_turf(src))
	if(mags)
		for(var/j = 1 to mags)
			if(prob(50))
				new /obj/item/ammo_magazine/magnum/scrap(get_turf(src))
			else
				new /obj/item/ammo_magazine/msmg/scrap(get_turf(src))

//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_rifle(dice = 0, mob/user,rifle=1)	//All rifles use same spawning stats

	var/boxxes = 0
	var/piles = 0
	var/mags = 0

	switch(dice)
		if(-99 to 6)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		if(6 to 12)
			piles = 2
		if(12 to 18)
			piles = 1
			mags = 1
		if(18 to 24)
			piles = 2
			mags = 1
		if(24 to 30)
			boxxes = 1
		if(30 to 42)
			boxxes = 1
			mags = 1
		if(42 to 48)
			boxxes = 1
			piles = 2
			mags = 1
		else
			boxxes = 2 + round(dice/10-5,1)

	if(rifle == 1) //srifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/srifle/scrap/prespawned(get_turf(src))
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/srifle_small/scrap(get_turf(src))
		if(mags)
			for(var/j = 1 to mags)
				new /obj/item/ammo_magazine/srifle/scrap(get_turf(src))

	if(rifle == 2) //clrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/clrifle/scrap/prespawned(get_turf(src))
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/clrifle_small/scrap(get_turf(src))
		if(mags)
			for(var/j = 1 to mags)
				new /obj/item/ammo_magazine/ihclrifle/scrap(get_turf(src))

	if(rifle == 3) //lrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/lrifle/scrap/prespawned(get_turf(src))
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_magazine/ammobox/lrifle_small/scrap(get_turf(src))
		if(mags)
			for(var/j = 1 to mags)
				new /obj/item/ammo_magazine/lrifle/scrap(get_turf(src))
//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_antim(dice = 0, mob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

	var/boxxes = 0
	var/piles = 0

	switch(dice)
		if(-99 to 10)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		if(10 to 20)
			piles = 2
		if(20 to 30)
			piles = 3
		if(30 to 40)
			piles = 4
		if(40 to 50)
			piles = 5
		else
			boxxes = 1
			piles = round(dice/10-6,1)

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/antim/scrap/prespawned(get_turf(src))
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_magazine/ammobox/antim/scrap(get_turf(src))

//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_shotgun(dice = 0, mob/user,shotgun=1)	//All rifles use same spawning stats

	var/piles = 0

	switch(dice)
		if(-99 to 0)	//if someone gets less than -99, they deserve the ammo
			piles = 1
		else
			piles = 1 + round(dice/7-1,1)	//We can use math here because it's just piles

	if(shotgun==1) //shot
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/shotgun/pellet/scrap/prespawned(get_turf(src))

	if(shotgun==2) //bean
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/shotgun/beanbag/scrap/prespawned(get_turf(src))

	if(shotgun==3) //slug
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casing/shotgun/scrap/prespawned(get_turf(src))

//////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_rocket(dice = 0, mob/user)	//All rifles use same spawning stats

	var/piles

	switch(dice)
		if(-99 to 20)
			piles = 1
		if(20 to 50)
			piles = 2

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casing/rocket/scrap/prespawned(user.loc)

//////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/craftingstation/proc/spawn_gunpart(dice = 0, mob/user)

	var/parts = 0

	switch(dice)
		if(-99 to 5)	//crafting gunparts is difficult task, unlike with ammo, player can fail it completely
			parts = 0
			to_chat(user, SPAN_WARNING("Every step of the way you just made things worse and worse. You wasted all the materials."))
		if(5 to 20)
			parts = 1
		if(20 to 35)
			parts = 2
		if(35 to 50)
			parts = 3
		else
			parts = 4

	for(var/j = 1 to parts)
		new /obj/item/part/gun(get_turf(src))

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftingstation/proc/spawn_armorpart(dice = 0, mob/user)

	var/parts = 0

	switch(dice)
		if(-99 to 10)	//crafting armorparts is easier
			parts = 1
		if(10 to 25)
			parts = 2
		if(25 to 40)
			parts = 3
		else
			parts = 4

	for(var/j = 1 to parts)
		new /obj/item/part/armor(get_turf(src))

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/obj/machinery/craftingstation/proc/eat(mob/living/user, obj/item/eating)

	if(!eating && istype(user))
		eating = user.get_active_hand()

	if(!istype(eating))
		return FALSE

	if(stat)
		return FALSE

	if(!Adjacent(user) && !Adjacent(eating))
		return FALSE

	if(is_robot_module(eating))
		return FALSE

	if(!istype(eating, /obj/item/stack/material))
		to_chat(user, SPAN_WARNING("[src] does not support this type of recycling."))
		return FALSE

	if(!length(eating.get_matter()))
		to_chat(user, SPAN_WARNING("\The [eating] does not contain significant amounts of useful materials and cannot be accepted."))
		return FALSE

	var/total_used = 0     // Amount of material used.
	var/obj/item/stack/material/stack = eating
	var/material = stack.default_type

	if(!(material in accepted_material))
		to_chat(user, SPAN_WARNING("[src] does not support [material] recycle."))
		return FALSE

	if(stored_material[material] >= storage_capacity)
		to_chat(user, SPAN_WARNING("The [src] is full of [material]."))
		return FALSE

	if(stored_material[material] + stack.amount > storage_capacity)
		total_used = storage_capacity - stored_material[material]

	else
		total_used = stack.amount


	stored_material[material] += total_used

	if(!stack.use(total_used))
		qdel(stack)

	to_chat(user, SPAN_NOTICE("You add [total_used] of [stack]\s to \the [src]."))

/obj/machinery/craftingstation/power_change()
	..()
	if(stat & NOPOWER)
		working = FALSE
		icon_state = "[initial(icon_state)]_off"
	update_icon()

/obj/machinery/craftingstation/Process()
	if(working)
		use_power(power_cost)
		var/pick_string = list( "_cut" , "_points", "_square")
		pick_string = pick(pick_string)
		flick("[initial(icon_state)][pick_string]", src)
		icon_state = "[initial(icon_state)][pick_string]"
		update_icon()

/obj/machinery/craftingstation/RefreshParts()
	..()
	var/mb_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating

	storage_capacity = round(initial(storage_capacity) + 10*(mb_rating - 1))

	var/man_rating = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	var/las_rating = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		las_rating += M.rating

	work_time = initial(work_time) - 2 * (man_rating - 1) SECONDS
	mat_efficiency = initial(mat_efficiency) - (1.5 ^ las_rating)

/obj/machinery/craftingstation/on_deconstruction()
	for(var/mat in stored_material)
		eject(mat, stored_material[mat])
	..()

//Autolathes can eject decimal quantities of material as a shard
/obj/machinery/craftingstation/proc/eject(material, amount)
	if(!(material in stored_material))
		return

	if(!amount)
		return

	var/material/M = get_material_by_name(material)

	if(!M.stack_type)
		return
	amount = min(amount, stored_material[material])

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
		new /obj/item/material/shard(drop_location(), material, _amount = remainder)

	//The stored material gets the amount (whole+remainder) subtracted
	stored_material[material] -= amount

#undef WORK
#undef DONE
