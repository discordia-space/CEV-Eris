/obj/structure/reagent_dispensers
	name = "dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = TRUE
	anchored = FALSE
	reagent_flags = DRAINABLE | AMOUNT_VISIBLE
	//sapwn_values
	bad_type = /obj/structure/reagent_dispensers
	rarity_value = 10
	spawn_fre69uency = 10
	spawn_tags = SPAWN_TAG_REAGENT_DISPENSER
	var/volume = 1500
	var/starting_reagent
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)
	var/contents_cost

/obj/structure/reagent_dispensers/Initialize(mapload, bolt=FALSE)
	. = ..()
	create_reagents(volume)
	if(starting_reagent)
		reagents.add_reagent(starting_reagent,69olume)
	if(!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
	anchored = bolt
	var/turf/T = get_turf(src)
	T?.levelupdate()

/obj/structure/reagent_dispensers/attackby(obj/item/W,69ob/user)
	if(istype(W, /obj/item/device/spy_bug))
		user.drop_item()
		W.loc = get_turf(src)

	else if(W.is_refillable())
		return FALSE //so we can refill them69ia their afterattack.

	else if(69UALITY_BOLT_TURNING in W.tool_69ualities && user.a_intent == I_HELP)
		if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNING, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			src.add_fingerprint(user)
			if(anchored)
				user.visible_message("\The 69user69 begins unsecuring \the 69src69 from the floor.", "You start unsecuring \the 69src69 from the floor.")
			else
				user.visible_message("\The 69user69 begins securing \the 69src69 to the floor.", "You start securing \the 69src69 to the floor.")

			if(do_after(user, 20, src))
				if(!src) return
				if(set_anchored(!anchored))
					to_chat(user, SPAN_NOTICE("You 69anchored? "" : "un"69secured \the 69src69!"))
				else
					to_chat(user, SPAN_WARNING("Ugh. You done something wrong!"))
			return FALSE
	else
		return ..()

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set69ame = "Set transfer amount"
	set category = "Object"
	set src in69iew(1)
	var/N = input("Amount per transfer from this:","69src69") as69ull|anything in possible_transfer_amounts
	if (N)
		amount_per_transfer_from_this =69

/obj/structure/reagent_dispensers/proc/explode()
	visible_message(SPAN_DANGER("\The 69src69 ruptures!"))
	chem_splash(loc, 5, list(reagents))
	69del(src)

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(1)
			explode()
			return
		if(2)
			if (prob(50))
				explode()
				return
		if(3)
			if (prob(5))
				explode()
				return




//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A water tank. It is used to store high amounts of water."
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	volume = 1500
	starting_reagent = "water"
	price_tag = 50
	contents_cost = 150

/obj/structure/reagent_dispensers/watertank/derelict
	icon_state = "watertank-derelict"
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/watertank/huge
	name = "high-capacity water tank"
	desc = "A high-capacity water tank. It is used to store HUGE amounts of water."
	icon_state = "hvwatertank"
	volume = 3000
	price_tag = 100
	contents_cost = 300
	rarity_value = 30

/obj/structure/reagent_dispensers/watertank/huge/derelict
	icon_state = "hvwatertank-derelict"
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A tank full of industrial welding fuel. Do69ot consume."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	volume = 500
	starting_reagent = "fuel"
	price_tag = 50
	contents_cost = 750
	var/modded = FALSE
	var/obj/item/device/assembly_holder/rig

/obj/structure/reagent_dispensers/fueltank/derelict
	icon_state = "weldtank-derelict"
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/fueltank/huge
	name = "high-capacity fuel tank"
	desc = "A high-capacity tank full of industrial welding fuel. Do69ot consume."
	icon_state = "hvweldtank"
	volume = 1000
	price_tag = 100
	contents_cost = 1500
	rarity_value = 30

/obj/structure/reagent_dispensers/fueltank/huge/derelict
	icon_state = "hvweldtank-derelict"
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	if(!..(user, 2))
		return
	if(modded)
		to_chat(user, SPAN_WARNING("Fuel faucet is open, leaking the fuel!"))
	if(rig)
		to_chat(user, SPAN_NOTICE("There is some kind of device rigged to the tank."))

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if (rig)
		usr.visible_message(SPAN_NOTICE("\The 69usr69 begins to detach 69rig69 from \the 69src69."), SPAN_NOTICE("You begin to detach 69rig69 from \the 69src69."))
		if(do_after(usr, 20, src))
			usr.visible_message(SPAN_NOTICE("\The 69usr69 detaches \the 69rig69 from \the 69src69."), SPAN_NOTICE("You detach 69rig69 from \the 69src69"))
			rig.loc = get_turf(usr)
			rig =69ull
			overlays =69ew/list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/I,69ob/user)
	src.add_fingerprint(user)
	if(69UALITY_SCREW_DRIVING in I.tool_69ualities && user.a_intent == I_HURT)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_SCREW_DRIVING, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			user.visible_message("69user69 screws 69src69's faucet 69modded ? "closed" : "open"69.", \
				"You screw 69src69's faucet 69modded ? "closed" : "open"69")
			modded = !modded
			if (modded)
				message_admins("69key_name_admin(user)69 opened fueltank at 69loc.loc.name69 (69loc.x69,69loc.y69,69loc.z69), leaking fuel. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69loc.x69;Y=69loc.y69;Z=69loc.z69'>JMP</a>)")
				log_game("69key_name(user)69 opened fueltank at 69loc.loc.name69 (69loc.x69,69loc.y69,69loc.z69), leaking fuel.")
				leak_fuel(amount_per_transfer_from_this)
	if (istype(I,/obj/item/device/assembly_holder))
		if (rig)
			to_chat(user, SPAN_WARNING("There is another device in the way."))
			return ..()
		user.visible_message(SPAN_DANGER("\The 69user69 begins rigging 69I69 to \the 69src69."), SPAN_WARNING("You begin rigging 69I69 to \the 69src69"))
		if(do_after(user, 20, src))
			user.visible_message(SPAN_DANGER("\The 69user69 rigs 69I69 to \the 69src69."), SPAN_WARNING("You rig 69I69 to \the 69src69.</span>"))

			var/obj/item/device/assembly_holder/H = I
			if (istype(H.left_assembly,/obj/item/device/assembly/igniter) || istype(H.right_assembly,/obj/item/device/assembly/igniter))
				message_admins("69key_name_admin(user)69 rigged fueltank at 69loc.loc.name69 (69loc.x69,69loc.y69,69loc.z69) for explosion. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69loc.x69;Y=69loc.y69;Z=69loc.z69'>JMP</a>)")
				log_game("69key_name(user)69 rigged fueltank at 69loc.loc.name69 (69loc.x69,69loc.y69,69loc.z69) for explosion.")

			rig = I
			user.drop_item()
			I.loc = src

			var/icon/test = getFlatIcon(I)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			overlays += test

	var/obj/item/tool/T = I
	if(istype(T) && T.use_fuel_cost)
		return 0

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			message_admins("69key_name_admin(Proj.firer)69 shot fueltank at 69loc.loc.name69 (69loc.x69,69loc.y69,69loc.z69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69loc.x69;Y=69loc.y69;Z=69loc.z69'>JMP</a>).")
			log_game("69key_name(Proj.firer)69 shot fueltank at 69loc.loc.name69 (69loc.x69,69loc.y69,69loc.z69).")

		if(!istype(Proj ,/obj/item/projectile/beam/lastertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/ex_act()
	explode()

/obj/structure/reagent_dispensers/fueltank/ignite_act()
	if(modded)
		explode()

/obj/structure/reagent_dispensers/fueltank/explode()
	if (reagents.total_volume > 500)
		explosion(src.loc,1,2,4)
	else if (reagents.total_volume > 100)
		explosion(src.loc,0,1,3)
	else if (reagents.total_volume > 50)
		explosion(src.loc,-1,1,2)
	if(src)
		69del(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, temperature,69olume)
	if (modded)
		explode()
	else if (temperature > T0C+500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	if ((. = ..()) &&69odded)
		leak_fuel(amount_per_transfer_from_this/10)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (reagents.total_volume == 0)
		return

	amount =69in(amount, reagents.total_volume)
	reagents.remove_reagent("fuel",amount)
	new /obj/effect/decal/cleanable/li69uid_fuel(src.loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "pepper spray refiller"
	desc = "Contains condensed capsaicin for use in law \"enforcement.\""
	icon_state = "peppertank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 45
	volume = 1000
	starting_reagent = "condensedcapsaicin"
	spawn_blacklisted = TRUE


/obj/structure/reagent_dispensers/water_cooler
	name = "water cooler"
	desc = "A69achine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts =69ull
	anchored = TRUE
	volume = 500
	starting_reagent = "water"
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10
	volume = 1000
	starting_reagent = "beer"
	price_tag = 50
	contents_cost = 700
	spawn_blacklisted = TRUE


/obj/structure/reagent_dispensers/cahorsbarrel
	name = "NeoTheology Cahors barrel"
	desc = "Barrel a day - keeps liver away."
	icon_state = "barrel"
	volume = 400
	starting_reagent = "ntcahors"
	price_tag = 50
	contents_cost = 950
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/virusfood
	name = "virus food dispenser"
	desc = "A dispenser of69irus food."
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	density = FALSE
	volume = 1000
	starting_reagent = "virusfood"
	spawn_blacklisted = TRUE

/obj/structure/reagent_dispensers/acid
	name = "sulphuric acid dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	density = FALSE
	volume = 1000
	starting_reagent = "sacid"
	spawn_blacklisted = TRUE

//this is big69ovable beaker
/obj/structure/reagent_dispensers/bidon
	name = "B.I.D.O.N. canister"
	desc = "Bulk Industrial Dispenser Omnitech-Nanochem. A canister with acid-resistant linings intended for handling big69olumes of chemicals."
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "bidon"
	rarity_value = 15
	matter = list(MATERIAL_STEEL = 16,69ATERIAL_GLASS = 8,69ATERIAL_PLASTIC = 6)
	reagent_flags = AMOUNT_VISIBLE
	amount_per_transfer_from_this = 30
	possible_transfer_amounts = list(10,30,60,120,200)
	var/filling_states = list(10,20,30,40,50,60,70,80,100)
	unacidable = 1
	anchored = FALSE
	density = TRUE
	volume = 600
	var/lid = TRUE

/obj/structure/reagent_dispensers/bidon/advanced
	name = "stasis B.I.D.O.N. canister"
	desc = "An advanced B.I.D.O.N. canister with stasis function."
	icon_state = "bidon_adv"
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_GLASS = 12,69ATERIAL_SILVER = 8)
	reagent_flags = TRANSPARENT
	filling_states = list(20,40,60,80,100)
	volume = 900
	rarity_value = 60

/obj/structure/reagent_dispensers/bidon/Initialize(mapload, ...)
	. = ..()
	update_icon()

/obj/structure/reagent_dispensers/bidon/examine(mob/user)
	if(!..(user, 2))
		return
	if(lid)
		to_chat(user, SPAN_NOTICE("It has lid on it."))
	if(reagents.total_volume)
		to_chat(user, SPAN_NOTICE("It's filled with 69reagents.total_volume69/69volume69 units of reagents."))

/obj/structure/reagent_dispensers/bidon/attack_hand(mob/user)
	lid = !lid
	if(lid)
		to_chat(user, SPAN_NOTICE("You put the lid on."))
		reagent_flags &= ~(REFILLABLE | DRAINABLE | DRAWABLE | INJECTABLE)
	else
		reagent_flags |= REFILLABLE | DRAINABLE | DRAWABLE | INJECTABLE
		to_chat(user, SPAN_NOTICE("You removed the lid."))
	playsound(src,'sound/items/trayhit2.ogg',50,1)
	update_icon()

/obj/structure/reagent_dispensers/bidon/attackby(obj/item/I,69ob/user)
	if(lid)
		to_chat(user, SPAN_NOTICE("Remove the lid first."))
		return
	else
		. = ..()
	update_icon()

/obj/structure/reagent_dispensers/bidon/update_icon()
	cut_overlays()
	if(lid)
		var/mutable_appearance/lid_icon =69utable_appearance(icon, "69icon_state69_lid")
		add_overlay(lid_icon)
	if(reagents.total_volume)
		var/mutable_appearance/filling =69utable_appearance('icons/obj/reagentfillings.dmi', "69icon_state6969get_filling_state()69")
		if(!istype(src,/obj/structure/reagent_dispensers/bidon/advanced))
			filling.color = reagents.get_color()
		add_overlay(filling)

/obj/structure/reagent_dispensers/bidon/proc/get_filling_state()
	var/percent = round((reagents.total_volume /69olume) * 100)
	for(var/increment in filling_states)
		if(increment >= percent)
			return increment

/obj/structure/reagent_dispensers/bidon/advanced/examine(mob/user)
	if(!..(user, 2))
		return
	if(reagents.reagent_list.len)
		for(var/I in reagents.reagent_list)
			var/datum/reagent/R = I
			to_chat(user, "<span class='notice'>69R.volume69 units of 69R.name69</span>")
