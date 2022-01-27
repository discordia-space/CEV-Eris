
/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/electronics/circuitboard/chemmaster
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	var/obj/item/reagent_containers/glass/beaker =69ull
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "bottle"
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 24 //max of pills that can be69ade in a bottle
	var/max_pill_vol = 60 //max69ol pills can have
	reagent_flags = OPENCONTAINER

/obj/machinery/chem_master/RefreshParts()
	if(!reagents)
		create_reagents(10)
	reagents.maximum_volume = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		reagents.maximum_volume += G.volume
		G.reagents.trans_to_holder(reagents, G.volume)

/obj/machinery/chem_master/on_deconstruction()
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		var/amount = G.reagents.get_free_space()
		reagents.trans_to_holder(G, amount)
	..()

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if (prob(50))
				69del(src)

/obj/machinery/chem_master/MouseDrop_T(atom/movable/I,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
		return ..()
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container() && !beaker)
		I.forceMove(src)
		I.add_fingerprint(user)
		src.beaker = I
		to_chat(user, SPAN_NOTICE("You add 69I69 to 69src69."))
		updateUsrDialog()
		icon_state = "mixer1"
		return
	. = ..()

/obj/machinery/chem_master/attackby(var/obj/item/B as obj,69ar/mob/user as69ob)
	if(default_deconstruction(B, user))
		return

	if(default_part_replacement(B, user))
		return

	if(istype(B, /obj/item/reagent_containers/glass))

		if(src.beaker)
			to_chat(user, "A beaker is already loaded into the69achine.")
			return

		if (usr.unE69uip(B, src))
			src.beaker = B
			to_chat(user, "You add the beaker to the69achine!")
			icon_state = "mixer1"
		updateUsrDialog()

	return

/obj/machinery/chem_master/Topic(href, href_list)
	if(..())
		return 1

	else if(href_list69"close"69)
		usr << browse(null, "window=chemmaster")
		usr.unset_machine()
		return

	if(beaker)
		var/datum/reagents/R = beaker.reagents
		if (href_list69"analyze"69)
			var/dat = ""
			if(!condi)
				if(href_list69"name"69 == "Blood")
					var/datum/reagent/organic/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list69"name"69)
							G = F
							break
					var/A = G.name
					var/B = G.data69"blood_type"69
					var/C = G.data69"blood_DNA"69
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>69A69<BR><BR>Description:<BR>Blood Type: 69B69<br>DNA: 69C69<BR><BR><BR><A href='?src=\ref69src69;main=1'>(Back)</A>"
				else
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>69href_list69"name"6969<BR><BR>Description:<BR>69href_list69"desc"6969<BR><BR><BR><A href='?src=\ref69src69;main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>69href_list69"name"6969<BR><BR>Description:<BR>69href_list69"desc"6969<BR><BR><BR><A href='?src=\ref69src69;main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if (href_list69"add"69)
			if(href_list69"amount"69)
				var/id = href_list69"add"69
				var/amount = CLAMP(text2num(href_list69"amount"69), 0, reagents.get_free_space())
				R.trans_id_to(src, id, amount)
				if(reagents.get_free_space() < 1)
					to_chat(usr, SPAN_WARNING("The 69name69 is full!"))

		else if (href_list69"addcustom"69)
			useramount = input("Select the amount to transfer.", 30, useramount) as69um
			src.Topic(null, list("amount" = "69useramount69", "add" = href_list69"addcustom"69))

		else if (href_list69"remove"69)
			if(href_list69"amount"69)
				var/id = href_list69"remove"69
				var/amount = CLAMP(text2num(href_list69"amount"69), 0, beaker.reagents.get_free_space())
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
					if(beaker.reagents.get_free_space() < 1)
						to_chat(usr, SPAN_WARNING("The 69name69 is full!"))
				else
					reagents.remove_reagent(id, amount)


		else if (href_list69"removecustom"69)
			useramount = input("Select the amount to transfer.", 30, useramount) as69um
			src.Topic(null, list("amount" = "69useramount69", "remove" = href_list69"removecustom"69))

		else if (href_list69"toggle"69)
			mode = !mode

		else if (href_list69"main"69)
			attack_hand(usr)
			return
		else if (href_list69"eject"69)
			if(beaker)
				beaker:loc = src.loc
				beaker =69ull
				reagents.clear_reagents()
				icon_state = "mixer0"

		else if (href_list69"createpill"69 || href_list69"createpill_multiple"69)
			var/count = 0
			var/amount_per_pill = 0

			if(!reagents.total_volume) //Sanity checking.
				return
			var/create_pill_bottle = FALSE
			if (href_list69"createpill_multiple"69)
				if(alert("Create bottle ?","Container.","Yes","No") == "Yes")
					create_pill_bottle = TRUE
				switch(alert("How to create pills.","Choose69ethod.","By amount","By69olume"))
					if("By amount")
						count = input("Select the69umber of pills to69ake.", "Max 69max_pill_count69", pillamount) as69um
						if (count >69ax_pill_count)
							alert("Maximum supported pills amount is 69max_pill_count69","Error.","Ok")
							return
						if (pillamount >69ax_pill_vol)
							alert("Maximum69olume supported in pills is 69max_pill_vol69","Error.","Ok")
							return
						
						count = CLAMP(count, 1,69ax_pill_count)
					if("By69olume")
						amount_per_pill = input("Select the69olume that single pill should contain.", "Max 69R.total_volume69", 5) as69um
						amount_per_pill = CLAMP(amount_per_pill, 1, reagents.total_volume)
						if (amount_per_pill >69ax_pill_vol)
							alert("Maximum69olume supported in pills is 69max_pill_vol69","Error.","Ok")
							return
						if ((reagents.total_volume / amount_per_pill) >69ax_pill_count)
							alert("Maximum supported pills amount is 69max_pill_count69","Error.","Ok")
							return
					else
						return
			else
				count = 1

			if(count)
				if(reagents.total_volume < count) //Sanity checking.
					return
				amount_per_pill = reagents.total_volume/count

			if (amount_per_pill >69ax_pill_vol) amount_per_pill =69ax_pill_vol

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","69reagents.get_master_reagent_name()69 (69amount_per_pill69 units)"),69AX_NAME_LEN)
			var/obj/item/storage/pill_bottle/PB
			if(create_pill_bottle)
				PB =69ew(get_turf(src))
				PB.name = "69PB.name69 (69name69)"
			while (reagents.total_volume)
				var/obj/item/reagent_containers/pill/P =69ew/obj/item/reagent_containers/pill(src.loc)
				if(!name)69ame = reagents.get_master_reagent_name()
				P.name = "69name69 pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				reagents.trans_to_obj(P,amount_per_pill)
				if(PB)
					P.forceMove(PB)
					src.updateUsrDialog()

		else if (href_list69"createbottle"69)
			if(!condi)
				var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()),69AX_NAME_LEN)
				var/obj/item/reagent_containers/glass/bottle/P =69ew/obj/item/reagent_containers/glass/bottle(src.loc)
				if(!name)69ame = reagents.get_master_reagent_name()
				P.name = "69name69 bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = bottlesprite
				reagents.trans_to_obj(P,60)
				P.toggle_lid()
			else
				var/obj/item/reagent_containers/food/condiment/P =69ew/obj/item/reagent_containers/food/condiment(src.loc)
				reagents.trans_to_obj(P,50)
		else if(href_list69"change_pill"69)
			#define69AX_PILL_SPRITE 20 //max icon state of the pill sprites
			var/dat = "<table>"
			for(var/i = 1 to69AX_PILL_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref69src69&pill_sprite=69i69\"><img src=\"pill69i69.png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list69"change_bottle"69)
			var/dat = "<table>"
			for(var/sprite in BOTTLE_SPRITES)
				dat += "<tr><td><a href=\"?src=\ref69src69&bottle_sprite=69sprite69\"><img src=\"69sprite69.png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list69"pill_sprite"69)
			pillsprite = href_list69"pill_sprite"69
		else if(href_list69"bottle_sprite"69)
			bottlesprite = href_list69"bottle_sprite"69

	playsound(loc, 'sound/machines/button.ogg', 100, 1)
	src.updateUsrDialog()
	return

/obj/machinery/chem_master/attack_hand(mob/user)
	if(inoperable())
		return
	user.set_machine(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to69AX_PILL_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "pill" +69um2text(i)), "pill69i69.png")
			for(var/sprite in BOTTLE_SPRITES)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', sprite), "69sprite69.png")
	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		dat += "<A href='?src=\ref69src69;close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='?src=\ref69src69;eject=1'>Eject beaker and Clear Buffer</A><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			var/free_space = reagents.get_free_space()
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in R.reagent_list)
				dat += "69G.name69 , 69G.volume69 Units - "
				dat += "<A href='?src=\ref69src69;analyze=1;desc=69G.description69;name=69G.name69'>(Analyze)</A> "
				for(var/volume in list(1, 5, 10))
					if(free_space >=69olume)
						dat += "<A href='?src=\ref69src69;add=69G.id69;amount=69volume69'>(69volume69)</A> "
					else
						dat += "(69volume69) "
				dat += "<A href='?src=\ref69src69;add=69G.id69;amount=69G.volume69'>(All)</A> "
				dat += "<A href='?src=\ref69src69;addcustom=69G.id69'>(Custom)</A><BR>"
			if(free_space < 1)
				dat += "The 69name69 is full!"

		dat += "<HR>Transfer to <A href='?src=\ref69src69;toggle=1'>69(!mode ? "disposal" : "beaker")69:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "69N.name69 , 69N.volume69 Units - "
				dat += "<A href='?src=\ref69src69;analyze=1;desc=69N.description69;name=69N.name69'>(Analyze)</A> "
				dat += "<A href='?src=\ref69src69;remove=69N.id69;amount=1'>(1)</A> "
				dat += "<A href='?src=\ref69src69;remove=69N.id69;amount=5'>(5)</A> "
				dat += "<A href='?src=\ref69src69;remove=69N.id69;amount=10'>(10)</A> "
				dat += "<A href='?src=\ref69src69;remove=69N.id69;amount=69N.volume69'>(All)</A> "
				dat += "<A href='?src=\ref69src69;removecustom=69N.id69'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='?src=\ref69src69;createpill=1'>Create pill (69max_pill_count69 units69ax)</A><a href=\"?src=\ref69src69&change_pill=1\"><img src=\"pill69pillsprite69.png\" /></a><BR>"
			dat += "<A href='?src=\ref69src69;createpill_multiple=1'>Create69ultiple pills</A><BR>"
			dat += "<A href='?src=\ref69src69;createbottle=1'>Create bottle (60 units69ax)<a href=\"?src=\ref69src69&change_bottle=1\"><img src=\"69bottlesprite69.png\" /></A>"
		else
			dat += "<A href='?src=\ref69src69;createbottle=1'>Create bottle (50 units69ax)</A>"
	if(!condi)
		user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster69enu:<BR><BR>69dat69", "window=chem_master;size=575x400")
	else
		user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster69enu:<BR><BR>69dat69", "window=chem_master;size=575x400")
	onclose(user, "chem_master")
	return

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1
