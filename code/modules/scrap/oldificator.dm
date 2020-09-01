/atom
	var/oldified = FALSE  // Whether the item has underwent make_old()
	// var/crit_fail = FALSE // In theory should make the item fail horifically, currently only used in vending.dm

//Defined at atom level for convenience, not currently used for mobs and turfs, but there are possible applications
/atom/proc/make_old()
	return

/atom/proc/make_young()
	oldified = FALSE

/obj/make_old()
	if (oldified)
		return FALSE
	if (prob(80))
		color = pick("#AA7744", "#774411", "#777777")
	light_color = color
	name = "[pick("old", "worn", "rusted", "weathered", "expired", "dirty", "frayed", "beaten", "ancient", "tarnished")] [name]"
	desc += "\n "
	desc += pick("Its warranty has expired.",
	 "The inscriptions on this thing have been erased by time.",
	  "Looks completely ruined.",
	   "It is difficult to make out what this thing once was.",
	    "A relic from a bygone age.")

	germ_level = pick(80,110,160)
	price_tag *= RAND_DECIMAL(0.1, 0.6) //Tank the price of it

	//Deplete matter and matter_reagents
	for (var/a in matter)
		matter[a] *= RAND_DECIMAL(0.5, 1)

	for (var/a in matter_reagents)
		matter_reagents[a] *= RAND_DECIMAL(0.5, 1)

	for(var/obj/item/sub_item in contents)
		if (prob(80))
			sub_item.make_old()

	oldified = TRUE


	update_icon()
	return TRUE

/obj/make_young()
	if(oldified)
		name = initial(name)
		color = initial(color)
	..()

/obj/item/make_old()
	.=..()
	if (.)
		if(prob(75))
			origin_tech = null
		siemens_coefficient += 0.3

/obj/item/weapon/tool/make_old()
	.=..()
	if (.)
		adjustToolHealth(-(rand(40, 150) * degradation))

/obj/item/weapon/storage/make_old()
	.=..()
	if (.)
		var/del_count = rand(0, contents.len)
		for(var/i = 1 to del_count)
			var/removed_item = pick(contents)
			contents -= removed_item
			qdel(removed_item)

		if(storage_slots && prob(75))
			storage_slots = max(contents.len, max(0, storage_slots - pick(2, 2, 2, 3, 3, 4)))
		if(max_storage_space && prob(75))
			max_storage_space = max_storage_space / 2

//Old pill bottles get a name that disguises their contents
/obj/item/weapon/storage/pill_bottle/make_old()
	if (prob(85))
		name = "bottle of [pick("generic ", "unknown ", "")]pills"
		desc = "Contains pills of some kind. The label has long since worn away"
		for (var/obj/item/weapon/reagent_containers/pill/P in contents)
			P.make_old()

	.=..()

//Make sure old pills always hide their contents too
/obj/item/weapon/reagent_containers/pill/make_old()
	name = "pill"
	desc = "Some kind of pill. The imprints have worn away."
	.=..()

/obj/structure/reagent_dispensers/make_old()
	.=..()
	if (. && reagents)
		for(var/datum/reagent/R in reagents.reagent_list)
			R.volume = rand(0, R.volume)


/obj/item/weapon/reagent_containers/make_old()
	.=..()
	if (.)
		var/actual_volume = reagents.total_volume
		for(var/datum/reagent/R in reagents.reagent_list)
			R.volume = rand(0, R.volume)
		reagents.add_reagent("toxin", rand(0, actual_volume - reagents.total_volume))


//Sealed survival food, always edible
/obj/item/weapon/reagent_containers/food/snacks/liquidfood/make_old()
	return

/obj/item/ammo_magazine/make_old()
	var/del_count = rand(0,contents.len)
	for(var/i = 1 to del_count)
		var/removed_item = pick(stored_ammo)
		stored_ammo -= removed_item
		qdel(removed_item)
	..()

/obj/item/weapon/cell/make_old()
	.=..()
	if (.)
		// It's silly to have old self-charging cells spawn partially discharged
		if(!autorecharging)
			charge = min(charge, RAND_DECIMAL(0, maxcharge))

		if(prob(10))
			rigged = TRUE
			if(prob(80))
				charge = maxcharge  //make it BOOM hard
		update_icon()

/obj/item/weapon/stock_parts/make_old()
	.=..()
	if (.)
		var/degrade = pick(0,1,1,1,2)
		rating = max(rating - degrade, 1)


/obj/item/stack/material/make_old()
	return

/obj/item/stack/rods/make_old()
	return

/obj/item/weapon/ore/make_old()
	return

/obj/item/weapon/grenade/make_old()
	..()
	det_time = RAND_DECIMAL(0, det_time)

/obj/item/weapon/tank/make_old()
	.=..()
	if (.)
		air_contents.remove(pick(0.2, 0.4 ,0.6, 0.8))


/obj/item/weapon/circuitboard/make_old()
	.=..()
	if (.)
		if(prob(75))
			name = T_BOARD("unknown")
			build_path = pick(/obj/machinery/washing_machine, /obj/machinery/broken, /obj/machinery/shower, /obj/machinery/holoposter, /obj/machinery/holosign)


/obj/item/weapon/aiModule/make_old()
	.=..()
	if (.)
		if(prob(75) && !istype(src, /obj/item/weapon/aiModule/broken))
			var/obj/item/weapon/aiModule/brokenmodule = new /obj/item/weapon/aiModule/broken
			brokenmodule.name = src.name
			brokenmodule.desc = src.desc
			brokenmodule.make_old()
			qdel(src)


/obj/item/clothing/suit/space/make_old()
	.=..()
	if (.)
		if(prob(50))
			create_breaches(pick(BRUTE, BURN), rand(10, 50))


/obj/item/clothing/make_old()
	.=..()
	if (.)
		if(prob(30))
			slowdown += pick(0.5, 0.5, 1, 1.5)
		if(prob(40))
			if(islist(armor)) //Possible to run before the initialize proc, thus having to modify the armor list
				for(var/i in armor)
					armor[i] = rand(0, armor[i])
			else if(is_proper_datum(armor))
				armor = armor.setRating(melee = rand(0, armor.getRating(ARMOR_MELEE)), bullet =  rand(0, armor.getRating(ARMOR_BULLET)), energy = rand(0, armor.getRating(ARMOR_ENERGY)), bomb = rand(0, armor.getRating(ARMOR_BOMB)), bio = rand(0, armor.getRating(ARMOR_BIO)), rad = rand(0, armor.getRating(ARMOR_RAD)))
		if(prob(40))
			heat_protection = rand(0, round(heat_protection * 0.5))
		if(prob(40))
			cold_protection = rand(0, round(cold_protection * 0.5))
		if(prob(20))
			contaminate()
		if(prob(15))
			add_blood()
		if(prob(60)) // I mean, the thing is ew gross.
			equip_delay += rand(0, 6 SECONDS)

/obj/item/clothing/make_young()
	if(oldified)
		slowdown = initial(slowdown)
		heat_protection = initial(heat_protection)
		cold_protection = initial(cold_protection)
		equip_delay = initial(equip_delay)
	..()


/obj/item/weapon/aiModule/broken
	name = "\improper broken core AI module"
	desc = "broken Core AI Module: 'Reconfigures the AI's core laws.'"

/obj/machinery/broken/Initialize()
	..()
	explosion(loc, 1, 2, 3, 3)
	return INITIALIZE_HINT_QDEL

/obj/machinery/broken/Destroy()
	contents.Cut()
	return ..()

/obj/item/weapon/aiModule/broken/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	..()
	IonStorm(0)
	explosion(sender.loc, 1, 1, 1, 3)
	sender.drop_from_inventory(src)
	qdel(src)

/obj/item/weapon/dnainjector/make_old()
	.=..()
	if (.)
		if(prob(75))
			name = "DNA-Injector (unknown)"
			desc = pick("1mm0r74l17y 53rum", "1ncr3d1bl3 73l3p47y hNlk", "5up3rhum4n m16h7")
			value = 0xFFF
		if(prob(75))
			block = pick(MONKEYBLOCK, HALLUCINATIONBLOCK, DEAFBLOCK, BLINDBLOCK, NERVOUSBLOCK, TWITCHBLOCK, CLUMSYBLOCK, COUGHBLOCK, HEADACHEBLOCK, GLASSESBLOCK)


/obj/item/clothing/glasses/hud/make_old()
	.=..()
	if (.)
		if(prob(75) && !istype(src, /obj/item/clothing/glasses/hud/broken))
			var/obj/item/clothing/glasses/hud/broken/brokenhud = new /obj/item/clothing/glasses/hud/broken
			brokenhud.name = src.name
			brokenhud.desc = src.desc
			brokenhud.icon = src.icon
			brokenhud.icon_state = src.icon_state
			brokenhud.item_state = src.item_state
			brokenhud.make_old()
			qdel(src)

/obj/item/clothing/glasses/make_old()
	.=..()
	if (.)
		if(prob(75))
			vision_flags = 0
		if(prob(75))
			darkness_view = -1

/obj/item/device/lighting/glowstick/make_old()
	.=..()
	if (.)
		if(prob(75))
			fuel = rand(0, fuel)

/obj/item/device/lighting/toggleable/make_old()
	.=..()
	if (.)
		if(prob(75))
			brightness_on = brightness_on / 2

/obj/machinery/floodlight/make_old()
	.=..()
	if (.)
		if(prob(75))
			brightness_on = brightness_on / 2

/obj/machinery/make_old()
	.=..()
	if (.)
		if(prob(60))
			stat |= BROKEN
		if(prob(60))
			emagged = TRUE


/obj/machinery/vending/make_old()
	.=..()
	if (.)
		if(prob(60))
			vend_power_usage *= pick(1, 1.3, 1.5, 1.7, 2.0)
		if(prob(60))
			seconds_electrified = -1
		if(prob(60))
			shut_up = FALSE
			slogan_delay = rand(round(slogan_delay * 0.5), slogan_delay)
		if(prob(60))
			shoot_inventory = TRUE

		var/del_count = rand(0, product_records.len)
		for(var/i in 1 to del_count)
			product_records.Remove(pick(product_records))

/obj/item/clothing/glasses/sunglasses/sechud/make_old()
	.=..()
	if (.)
		if(hud && prob(75))
			hud = new /obj/item/clothing/glasses/hud/broken

/*
/obj/effect/decal/mecha_wreckage/make_old()
	.=..()
	if (.)
		salvage_num = max(1, salvage_num - pick(1, 2, 3))
*/

