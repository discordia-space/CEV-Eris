/obj/item/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage_types = list(BRUTE = 5)
	sharp = TRUE
	embed = 1 //the dart is shot fast enough to pierce space suits, so I guess splintering inside the target can be a thing. Should be rare due to low damage.
	kill_count = 15 //shorter range
	muzzle_type =69ull
	var/reagent_amount = 15

/obj/item/projectile/bullet/chemdart/New()
	create_reagents(reagent_amount)
	..()

/obj/item/projectile/bullet/chemdart/on_hit(atom/target, def_zone =69ull)
	if(isliving(target))
		var/mob/living/L = target
		if(L.can_inject(target_zone = def_zone))
			reagents.trans_to_mob(L, reagent_amount, CHEM_BLOOD)

/obj/item/ammo_casing/chemdart
	name = "chemical dart"
	desc = "A small hardened, hollow dart."
	icon_state = "dart"
	caliber = CAL_DART
	projectile_type = /obj/item/projectile/bullet/chemdart

/obj/item/ammo_casing/chemdart/expend()
	69del(src)

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	mag_type =69AGAZINE
	caliber = CAL_DART
	ammo_type = /obj/item/ammo_casing/chemdart
	max_ammo = 5
	mag_well =69AG_WELL_DART
	ammo_states = list(1, 2, 3, 4, 5)

/obj/item/gun/projectile/dartgun
	name = "Z-H P Artemis"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms69arket, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances."
	icon = 'icons/obj/guns/projectile/dartgun.dmi'
	icon_state = "dartgun-empty"
	caliber = CAL_DART
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a69etallic click"
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_PLASTIC = 10)
	gun_parts = list(/obj/item/stack/material/steel = 15 ,/obj/item/stack/material/plastic = 2)
	recoil_buildup = 0
	silenced = TRUE
	load_method =69AGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	auto_eject = 0
	mag_well =69AG_WELL_DART
	rarity_value = 10

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for69ixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/beaker_type = /obj/item/reagent_containers/glass/beaker
	var/list/starting_chems

/obj/item/gun/projectile/dartgun/New()
	..()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B =69ew beaker_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	update_icon()

/obj/item/gun/projectile/dartgun/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "dartgun-69round(ammo_magazine.stored_ammo.len,2)69"
	else
		icon_state = "dartgun-empty"
	return

/obj/item/gun/projectile/dartgun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/bullet/chemdart/dart = .
	if(istype(dart))
		fill_dart(dart)

/obj/item/gun/projectile/dartgun/examine(mob/user)
	//update_icon()
	//if (!..(user, 2))
	//	return
	..()
	if(beakers.len)
		to_chat(user, SPAN_NOTICE("69src69 contains:"))
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					to_chat(user, SPAN_NOTICE("69R.volume69 units of 69R.name69"))

/obj/item/gun/projectile/dartgun/attackby(obj/item/I as obj,69ob/user as69ob)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!istype(I, beaker_type))
			to_chat(user, SPAN_NOTICE("69I69 doesn't seem to fit into 69src69."))
			return
		if(beakers.len >=69ax_beakers)
			to_chat(user, SPAN_NOTICE("69src69 already has 69max_beakers69 beakers in it - another one isn't going to fit!"))
			return
		var/obj/item/reagent_containers/glass/beaker/B = I
		user.drop_item()
		B.loc = src
		beakers += B
		to_chat(user, SPAN_NOTICE("You slot 69B69 into 69src69."))
		src.updateUsrDialog()
		return 1
	..()

//fills the given dart with reagents
/obj/item/gun/projectile/dartgun/proc/fill_dart(var/obj/item/projectile/bullet/chemdart/dart)
	if(mixing.len)
		var/mix_amount = dart.reagent_amount/mixing.len
		for(var/obj/item/reagent_containers/glass/beaker/B in69ixing)
			B.reagents.trans_to_obj(dart,69ix_amount)

/obj/item/gun/projectile/dartgun/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<b>69src6969ixing control:</b><br><br>"

	if (beakers.len)
		var/i = 1
		for(var/obj/item/reagent_containers/glass/beaker/B in beakers)
			dat += "Beaker 69i69 contains: "
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					dat += "<br>    69R.volume69 units of 69R.name69, "
				if (check_beaker_mixing(B))
					dat += text("<A href='?src=\ref69src69;stop_mix=69i69'><font color='green'>Mixing</font></A> ")
				else
					dat += text("<A href='?src=\ref69src69;mix=69i69'><font color='red'>Not69ixing</font></A> ")
			else
				dat += "nothing."
			dat += " \69<A href='?src=\ref69src69;eject=69i69'>Eject</A>\69<br>"
			i++
	else
		dat += "There are69o beakers inserted!<br><br>"

	if(ammo_magazine)
		if(ammo_magazine.stored_ammo && ammo_magazine.stored_ammo.len)
			dat += "The dart cartridge has 69ammo_magazine.stored_ammo.len69 shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \69<A href='?src=\ref69src69;eject_cart=1'>Eject</A>\69"

	user << browse(dat, "window=dartgun")
	onclose(user, "dartgun", src)

/obj/item/gun/projectile/dartgun/proc/check_beaker_mixing(var/obj/item/B)
	if(!mixing || !beakers)
		return 0
	for(var/obj/item/M in69ixing)
		if(M == B)
			return 1
	return 0

/obj/item/gun/projectile/dartgun/Topic(href, href_list)
	if(..()) return 1
	src.add_fingerprint(usr)
	if(href_list69"stop_mix"69)
		var/index = text2num(href_list69"stop_mix"69)
		if(index <= beakers.len)
			for(var/obj/item/M in69ixing)
				if(M == beakers69index69)
					mixing -=69
					break
	else if (href_list69"mix"69)
		var/index = text2num(href_list69"mix"69)
		if(index <= beakers.len)
			mixing += beakers69index69
	else if (href_list69"eject"69)
		var/index = text2num(href_list69"eject"69)
		if(index <= beakers.len)
			if(beakers69index69)
				var/obj/item/reagent_containers/glass/beaker/B = beakers69index69
				to_chat(usr, "You remove 69B69 from 69src69.")
				mixing -= B
				beakers -= B
				B.loc = get_turf(src)
	else if (href_list69"eject_cart"69)
		unload_ammo(usr)
	src.updateUsrDialog()
	return
