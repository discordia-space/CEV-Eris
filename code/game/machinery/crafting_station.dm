#define WORK "work"
#define DONE "done"

/obj/machinery/craftin69station
	name = "craftin69 station"
	desc = "Makeshift fabrication station for home-made69unitions and components of firearms and armor."
	icon = 'icons/obj/machines/craftin69_station.dmi'
	icon_state = "craft"
	circuit = /obj/item/electronics/circuitboard/craftin69_station
	density = TRUE
	anchored = TRUE
	layer = 2.8

	var/power_cost = 250

	var/workin69 = FALSE
	var/start_workin69
	var/work_time = 20 SECONDS
	var/mat_efficiency = 15
	var/stora69e_capacity = 40
	var/list/stored_material = list()
	var/list/accepted_material = list (MATERIAL_PLASTEEL,69ATERIAL_STEEL,69ATERIAL_PLASTIC,69ATERIAL_WOOD,69ATERIAL_CARDBOARD,69ATERIAL_PLASMA)
	var/list/needed_material_69unpart = list(MATERIAL_PLASTEEL = 5)
	var/list/needed_material_armorpart = list(MATERIAL_STEEL = 20,69ATERIAL_PLASTIC = 20,69ATERIAL_WOOD = 20,MATERIAL_CARDBOARD = 20)
	var/list/needed_material_ammo = list(MATERIAL_STEEL = 10,69ATERIAL_CARDBOARD = 5)
	var/list/needed_material_rocket = list(MATERIAL_PLASMA = 5,69ATERIAL_PLASTIC = 5,69ATERIAL_PLASTEEL = 5,69ATERIAL_STEEL = 10)

	// A69is_contents hack for69aterials loadin69 animation.
	var/tmp/obj/effect/flick_li69ht_overlay/ima69e_load

/obj/machinery/craftin69station/Initialize()
	. = ..()

	ima69e_load = new(src)


/obj/machinery/craftin69station/examine(user)
	. = ..()
	var/list/matter_count_need_ammo = list()
	var/list/matter_count_need_69unpart = list()
	var/list/matter_count_need_armorpart = list()
	var/list/matter_count_need_rocket = list()

	for(var/_material in needed_material_ammo)
		matter_count_need_ammo += "69needed_material_ammo69_material6969 69_material69"

	for(var/_material in needed_material_69unpart)
		matter_count_need_69unpart += "69needed_material_ammo69_material6969 69_material69"

	for(var/_material in needed_material_armorpart)
		matter_count_need_armorpart += "69needed_material_ammo69_material6969 69_material69"

	for(var/_material in needed_material_rocket)
		matter_count_need_rocket += "69needed_material_rocket69_material6969 69_material69"

	var/list/matter_count = list()
	for(var/_material in stored_material)
		matter_count += " 69stored_material69_material6969 69_material69"

	to_chat(user, SPAN_NOTICE("Materials re69uired to craft ammunition: 69en69lish_list(matter_count_need_ammo)69.\nMaterials re69uired to craft 69un parts: 5 69en69lish_list(matter_count_need_69unpart)69 \nMaterials re69uired to craft armor parts: 69en69lish_list(matter_count_need_armorpart)69 \n69aterials re69uired to craft RP69 shell: 69en69lish_list(matter_count_need_rocket)69.\nIt contains: 69en69lish_list(matter_count)69."))


/obj/machinery/craftin69station/attackby(obj/item/I,69ob/user)
	if(default_part_replacement(I, user))
		return

	if(default_deconstruction(I, user))
		return

	if(istype(I, /obj/item/stack))
		eat(user, I)
		return
	. = ..()

/obj/machinery/craftin69station/attack_hand(mob/user as69ob)
	if(workin69)
		to_chat(user, SPAN_NOTICE("You are already craftin69 somethin69."))
		return

	var/co69_stat = user.stats.69etStat(STAT_CO69)

	var/list/options = list(
		".20 Rifle ammunition" = "srifle",
		".25 Caseless Rifle ammunition" = "clrifle",
		".30 Rifle ammunition" = "lrifle",
		".35 Auto ammunition" = "pistol",
		".4069a69num ammunition" = "ma69num",
		".50 Shot69un Buckshot ammunition" = "shot",
		".50 Shot69un Beanba69 ammunition" = "bean",
		".50 Shot69un Slu69 ammunition" = "slu69",
		".60 Anti-Material ammunition" = "antim",
		"RP69 shell" = "rocket",
		"69un parts" = "69unpart",
		"Armor parts"= "armorpart",
		)

	var/choice = input(user,"What do you want to craft?") as null|anythin69 in options
	if(choice == null)
		return

	var/produce_type = options69choice69

	switch(produce_type)
		if("pistol")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("ma69num")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("srifle")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("clrifle")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("lrifle")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("shot")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("bean")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("slu69")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with"))
					return
		if("antim")
			for(var/material in needed_material_ammo)
				var/amount = needed_material_ammo69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("rocket")
			for(var/material in needed_material_rocket)
				var/amount = needed_material_rocket69material69
				if(amount > stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return
		if("69unpart")
			if(stored_material69MATERIAL_PLASTEEL69 < needed_material_69unpart69MATERIAL_PLASTEEL69)
				to_chat(user, SPAN_NOTICE("You do not have enou69h plasteel to craft 69un part."))
				return
		if("armorpart")
			for(var/material in needed_material_armorpart)
				var/amount = needed_material_armorpart69material69
				if(amount>stored_material69material69)
					to_chat(user, SPAN_NOTICE("You don't have enou69h 69material69 to work with."))
					return

	flick("69initial(icon_state)69_warmup", src)
	workin69 = TRUE
	START_PROCESSIN69(SSmachines, src)
	if(do_after(user, work_time, src))
		STOP_PROCESSIN69(SSmachines, src)
		workin69 = FALSE
		flick("69initial(icon_state)69_done", src)
		icon_state = "69initial(icon_state)69"
		update_icon()
	else
		STOP_PROCESSIN69(SSmachines, src)
		workin69 = FALSE
		flick("69initial(icon_state)69_done", src)
		icon_state = "69initial(icon_state)69"
		update_icon()
		return

	var/dice_roll = (rand(0,20) * (1 + co69_stat /69at_efficiency))

	if(user.stats.69etPerk(/datum/perk/oddity/69unsmith))
		dice_roll = dice_roll * 2
	switch(produce_type)//69od for69ive69e
		if("pistol")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69
			spawn_pistol(dice_roll,user)
		if("ma69num")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_ma69num(dice_roll,user)
		if("srifle")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_rifle(dice_roll,user,1)
		if("clrifle")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_rifle(dice_roll,user,2)
		if("lrifle")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_rifle(dice_roll,user,3)
		if("antim")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_antim(dice_roll,user)
		if("rocket")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69
			spawn_rocket(dice_roll,user)
		if("shot")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_shot69un(dice_roll,user,1)
		if("bean")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_shot69un(dice_roll,user,2)
		if("slu69")
			for(var/_material in needed_material_ammo)
				stored_material69_material69 -= needed_material_ammo69_material69

			spawn_shot69un(dice_roll,user,3)
		if("69unpart")
			for(var/_material in needed_material_69unpart)
				stored_material69_material69 -= needed_material_69unpart69_material69

			spawn_69unpart(dice_roll,user)
		if("armorpart")
			for(var/_material in needed_material_armorpart)
				stored_material69_material69 -= needed_material_armorpart69_material69

			spawn_armorpart(dice_roll,user)

	if(choice)
		user.visible_messa69e("69user69 crafts some 69choice69 usin69 69src69")
	else
		to_chat(user, "You reconsider the path of craftsmanship.")

////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_pistol(dice = 0,69ob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

	var/boxxes = 0
	var/piles = 0
	var/ma69s = 0

	switch(dice)
		if(-99 to 10)	//if someone 69ets less than -99, they deserve the ammo
			piles = 1
		if(10 to 20)
			ma69s = 1
		if(20 to 30)
			boxxes = 1
			ma69s = 1
		if(30 to 40)
			boxxes = 1
			ma69s = 2
		if(40 to 50)
			piles = 1
			boxxes = 2
			ma69s = 1
		else
			boxxes = 3+ round(dice/10-5,1)	//rich 69et richer

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casin69/pistol/scrap/prespawned(69et_turf(src))
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_ma69azine/ammobox/pistol/scrap(69et_turf(src))
	if(ma69s)
		for(var/j = 1 to69a69s)
			if(prob(50))
				new /obj/item/ammo_ma69azine/pistol/scrap(69et_turf(src))
			else
				new /obj/item/ammo_ma69azine/sm69/scrap(69et_turf(src))

//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_ma69num(dice = 0,69ob/user)

	var/boxxes = 0
	var/piles = 0
	var/ma69s = 0

	switch(dice)
		if(-99 to 8)
			piles = 2
		if(8 to 16)
			piles = 2
			ma69s = 1
		if(16 to 24)
			boxxes = 1
		if(24 to 32)
			boxxes = 1
			ma69s = 1
		if(32 to 40)
			piles = 2
			boxxes = 1
			ma69s = 1
		if(40 to 48)
			boxxes = 1
			ma69s = 3
		else
			boxxes = 3 + round(dice/10-5,1)

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casin69/ma69num/scrap/prespawned(69et_turf(src))
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_ma69azine/ammobox/ma69num/scrap(69et_turf(src))
	if(ma69s)
		for(var/j = 1 to69a69s)
			if(prob(50))
				new /obj/item/ammo_ma69azine/ma69num/scrap(69et_turf(src))
			else
				new /obj/item/ammo_ma69azine/msm69/scrap(69et_turf(src))

//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_rifle(dice = 0,69ob/user,rifle=1)	//All rifles use same spawnin69 stats

	var/boxxes = 0
	var/piles = 0
	var/ma69s = 0

	switch(dice)
		if(-99 to 6)	//if someone 69ets less than -99, they deserve the ammo
			piles = 1
		if(6 to 12)
			piles = 2
		if(12 to 18)
			piles = 1
			ma69s = 1
		if(18 to 24)
			piles = 2
			ma69s = 1
		if(24 to 30)
			boxxes = 1
		if(30 to 42)
			boxxes = 1
			ma69s = 1
		if(42 to 48)
			boxxes = 1
			piles = 2
			ma69s = 1
		else
			boxxes = 2 + round(dice/10-5,1)

	if(rifle == 1) //srifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casin69/srifle/scrap/prespawned(69et_turf(src))
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_ma69azine/ammobox/srifle_small/scrap(69et_turf(src))
		if(ma69s)
			for(var/j = 1 to69a69s)
				new /obj/item/ammo_ma69azine/srifle/scrap(69et_turf(src))

	if(rifle == 2) //clrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casin69/clrifle/scrap/prespawned(69et_turf(src))
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_ma69azine/ammobox/clrifle_small/scrap(69et_turf(src))
		if(ma69s)
			for(var/j = 1 to69a69s)
				new /obj/item/ammo_ma69azine/ihclrifle/scrap(69et_turf(src))

	if(rifle == 3) //lrifle
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casin69/lrifle/scrap/prespawned(69et_turf(src))
		if(boxxes)
			for(var/j = 1 to boxxes)
				new /obj/item/ammo_ma69azine/ammobox/lrifle_small/scrap(69et_turf(src))
		if(ma69s)
			for(var/j = 1 to69a69s)
				new /obj/item/ammo_ma69azine/lrifle/scrap(69et_turf(src))
//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_antim(dice = 0,69ob/user)	//Shazbot- I know there is probably a better way to do this, but this is easier to code

	var/boxxes = 0
	var/piles = 0

	switch(dice)
		if(-99 to 10)	//if someone 69ets less than -99, they deserve the ammo
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
			new /obj/item/ammo_casin69/antim/scrap/prespawned(69et_turf(src))
	if(boxxes)
		for(var/j = 1 to boxxes)
			new /obj/item/ammo_ma69azine/ammobox/antim/scrap(69et_turf(src))

//////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_shot69un(dice = 0,69ob/user,shot69un=1)	//All rifles use same spawnin69 stats

	var/piles = 0

	switch(dice)
		if(-99 to 0)	//if someone 69ets less than -99, they deserve the ammo
			piles = 1
		else
			piles = 1 + round(dice/7-1,1)	//We can use69ath here because it's just piles

	if(shot69un==1) //shot
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casin69/shot69un/pellet/scrap/prespawned(69et_turf(src))

	if(shot69un==2) //bean
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casin69/shot69un/beanba69/scrap/prespawned(69et_turf(src))

	if(shot69un==3) //slu69
		if(piles)
			for(var/j = 1 to piles)
				new /obj/item/ammo_casin69/shot69un/scrap/prespawned(69et_turf(src))

//////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_rocket(dice = 0,69ob/user)	//All rifles use same spawnin69 stats

	var/piles

	switch(dice)
		if(-99 to 20)
			piles = 1
		if(20 to 50)
			piles = 2

	if(piles)
		for(var/j = 1 to piles)
			new /obj/item/ammo_casin69/rocket/scrap/prespawned(user.loc)

//////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/craftin69station/proc/spawn_69unpart(dice = 0,69ob/user)

	var/parts = 0

	switch(dice)
		if(-99 to 5)	//craftin69 69unparts is difficult task, unlike with ammo, player can fail it completely
			parts = 0
		if(5 to 20)
			parts = 1
		if(20 to 35)
			parts = 2
		if(35 to 50)
			parts = 3
		else
			parts = 4

	for(var/j = 1 to parts)
		new /obj/item/part/69un(69et_turf(src))

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/craftin69station/proc/spawn_armorpart(dice = 0,69ob/user)

	var/parts = 0

	switch(dice)
		if(-99 to 10)	//craftin69 armorparts is easier
			parts = 1
		if(10 to 25)
			parts = 2
		if(25 to 40)
			parts = 3
		else
			parts = 4

	for(var/j = 1 to parts)
		new /obj/item/part/armor(69et_turf(src))

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/obj/machinery/craftin69station/proc/eat(mob/livin69/user, obj/item/eatin69)

	if(!eatin69 && istype(user))
		eatin69 = user.69et_active_hand()

	if(!istype(eatin69))
		return FALSE

	if(stat)
		return FALSE

	if(!Adjacent(user) && !Adjacent(eatin69))
		return FALSE

	if(is_robot_module(eatin69))
		return FALSE

	if(!istype(eatin69, /obj/item/stack/material))
		to_chat(user, SPAN_WARNIN69("69src69 does not support this type of recyclin69."))
		return FALSE

	if(!len69th(eatin69.69et_matter()))
		to_chat(user, SPAN_WARNIN69("\The 69eatin6969 does not contain si69nificant amounts of useful69aterials and cannot be accepted."))
		return FALSE

	var/total_used = 0     // Amount of69aterial used.
	var/obj/item/stack/material/stack = eatin69
	var/material = stack.default_type

	if(!(material in accepted_material))
		to_chat(user, SPAN_WARNIN69("69src69 does not support 69material69 recycle."))
		return FALSE

	if(stored_material69material69 >= stora69e_capacity)
		to_chat(user, SPAN_WARNIN69("The 69src69 is full of 69material69."))
		return FALSE

	if(stored_material69material69 + stack.amount > stora69e_capacity)
		total_used = stora69e_capacity - stored_material69material69

	else
		total_used = stack.amount


	stored_material69material69 += total_used

	if(!stack.use(total_used))
		69del(stack)

	to_chat(user, SPAN_NOTICE("You add 69total_used69 of 69stack69\s to \the 69src69."))

/obj/machinery/craftin69station/power_chan69e()
	..()
	if(stat & NOPOWER)
		workin69 = FALSE
		icon_state = "69initial(icon_state)69_off"
	update_icon()

/obj/machinery/craftin69station/Process()
	if(workin69)
		use_power(power_cost)
		var/pick_strin69 = list( "_cut" , "_points", "_s69uare")
		pick_strin69 = pick(pick_strin69)
		flick("69initial(icon_state)6969pick_strin6969", src)
		icon_state = "69initial(icon_state)6969pick_strin6969"
		update_icon()

/obj/machinery/craftin69station/RefreshParts()
	..()
	var/mb_ratin69 = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_ratin69 +=69B.ratin69

	stora69e_capacity = round(initial(stora69e_capacity) + 10*(mb_ratin69 - 1))

	var/man_ratin69 = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_ratin69 +=69.ratin69

	var/las_ratin69 = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		las_ratin69 +=69.ratin69

	work_time = initial(work_time) - 2 * (man_ratin69 - 1) SECONDS
	mat_efficiency = initial(mat_efficiency) - (1.5 ^ las_ratin69)

/obj/machinery/craftin69station/on_deconstruction()
	for(var/mat in stored_material)
		eject(mat, stored_material69mat69)
	..()

//Autolathes can eject decimal 69uantities of69aterial as a shard
/obj/machinery/craftin69station/proc/eject(material, amount)
	if(!(material in stored_material))
		return

	if(!amount)
		return

	var/material/M = 69et_material_by_name(material)

	if(!M.stack_type)
		return
	amount =69in(amount, stored_material69material69)

	var/whole_amount = round(amount)
	var/remainder = amount - whole_amount

	if(whole_amount)
		var/obj/item/stack/material/S = new69.stack_type(drop_location())

		//Accountin69 for the possibility of too69uch to fit in one stack
		if(whole_amount <= S.max_amount)
			S.amount = whole_amount
			S.update_strin69s()
			S.update_icon()
		else
			//There's too69uch, how69any stacks do we need
			var/fullstacks = round(whole_amount / S.max_amount)
			//And how69any sheets leftover for this stack
			S.amount = whole_amount % S.max_amount

			if(!S.amount)
				69del(S)

			for(var/i = 0; i < fullstacks; i++)
				var/obj/item/stack/material/MS = new69.stack_type(drop_location())
				MS.amount =69S.max_amount
				MS.update_strin69s()
				MS.update_icon()

	//And if there's any remainder, we eject that as a shard
	if(remainder)
		new /obj/item/material/shard(drop_location(),69aterial, _amount = remainder)

	//The stored69aterial 69ets the amount (whole+remainder) subtracted
	stored_material69material69 -= amount

#undef WORK
#undef DONE
