#define SOLID 1
#define LIQUID 2
#define GAS 3

#define chemical_dispenser_ENERGY_COST	0.1	//How many energy points do we use per unit of chemical?
#define BOTTLE_SPRITES list("bottle-1", "bottle-2", "bottle-3", "bottle-4") //list of available bottle sprites
#define REAGENTS_PER_SHEET 20


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/obj/machinery/chemical_dispenser
	name = "chem dispenser"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 0
	idle_power_usage = 40
	layer = BELOW_OBJ_LAYER
	var/ui_title = "Chem Dispenser 5000"
	var/energy = 100
	var/max_energy = 100
	var/amount = 30
	var/accept_glass = 0 //At 0 ONLY accepts glass containers. Kinda misleading varname.
	var/atom/beaker = null
	var/recharged = 0
	var/hackedcheck = 0
	var/list/dispensable_reagents = list("hydrazine","lithium","carbon","ammonia","acetone",
	"sodium","aluminum","silicon","phosphorus","sulfur","hclacid","potassium","iron",
	"copper","mercury","radium","water","ethanol","sugar","sacid","tungsten")

/obj/machinery/chemical_dispenser/proc/recharge()
	if(stat & (BROKEN|NOPOWER)) return
	var/addenergy = 6
	var/oldenergy = energy
	energy = min(energy + addenergy, max_energy)
	if(energy != oldenergy)
		use_power(CHEM_SYNTH_ENERGY / chemical_dispenser_ENERGY_COST) // This thing uses up "alot" of power (this is still low as shit for creating reagents from thin air)
		SSnano.update_uis(src) // update all UIs attached to src

/obj/machinery/chemical_dispenser/power_change()
	..()
	SSnano.update_uis(src) // update all UIs attached to src

/obj/machinery/chemical_dispenser/Process()
	if(recharged <= 0)
		recharge()
		recharged = 15
	else
		recharged -= 1

/obj/machinery/chemical_dispenser/New()
	..()
	recharge()
	dispensable_reagents = sortList(dispensable_reagents)


/obj/machinery/chemical_dispenser/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return


 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/chemical_dispenser/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	data["amount"] = amount
	data["energy"] = round(energy)
	data["maxEnergy"] = round(max_energy)
	data["isBeakerLoaded"] = beaker ? 1 : 0
	data[MATERIAL_GLASS] = accept_glass
	var beakerContents[0]
	var beakerCurrentVolume = 0
	if(beaker && beaker:reagents && beaker:reagents.reagent_list.len)
		for(var/datum/reagent/R in beaker:reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if (beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker:volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var chemicals[0]
	for (var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "chem_disp.tmpl", ui_title, 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/chemical_dispenser/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		if (amount < 0) // Since the user can actually type the commands himself, some sanity checking
			amount = 0
		if (amount > 120)
			amount = 120

	if(href_list["dispense"])
		if (dispensable_reagents.Find(href_list["dispense"]) && beaker && beaker.is_refillable())
			var/obj/item/weapon/reagent_containers/B = src.beaker
			var/datum/reagents/R = B.reagents
			var/space = R.maximum_volume - R.total_volume

			//uses 1 energy per 10 units.
			var/added_amount = min(amount, energy / chemical_dispenser_ENERGY_COST, space)
			R.add_reagent(href_list["dispense"], added_amount)
			energy = max(energy - added_amount * chemical_dispenser_ENERGY_COST, 0)

	if(href_list["ejectBeaker"])
		if(beaker)
			var/obj/item/weapon/reagent_containers/B = beaker
			B.loc = loc
			beaker = null

	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/chemical_dispenser/attackby(var/obj/item/weapon/reagent_containers/B as obj, var/mob/user as mob)
	if(src.beaker)
		user << "Something is already loaded into the machine."
		return
	if(istype(B, /obj/item/weapon/reagent_containers/glass) || istype(B, /obj/item/weapon/reagent_containers/food))
		if(!accept_glass && istype(B,/obj/item/weapon/reagent_containers/food))
			user << SPAN_NOTICE("This machine only accepts beakers")
		src.beaker =  B
		if (user.unEquip(B, src))
			user << "You set [B] on the machine."
			SSnano.update_uis(src) // update all UIs attached to src
			return

/obj/machinery/chemical_dispenser/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chemical_dispenser/attack_hand(mob/user as mob)
	if(stat & BROKEN)
		return
	ui_interact(user)

/obj/machinery/chemical_dispenser/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	layer = OBJ_LAYER
	ui_title = "Soda Dispens-o-matic"
	energy = 100
	accept_glass = 1
	max_energy = 100
	density = 0
	dispensable_reagents = list("water","ice","coffee","cream","tea","greentea","icetea","icegreentea","cola","spacemountainwind","dr_gibb","space_up","tonic","sodawater","lemon_lime","sugar","orangejuice","limejuice","watermelonjuice")

/obj/machinery/chemical_dispenser/soda/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	..()
	if(istype(B, /obj/item/weapon/tool/multitool))
		if(hackedcheck == 0)
			user << "You change the mode from 'McNano' to 'Pizza King'."
			dispensable_reagents += list("thirteenloko","grapesoda")
			hackedcheck = 1
			return

		else
			user << "You change the mode from 'Pizza King' to 'McNano'."
			dispensable_reagents -= list("thirteenloko","grapesoda")
			hackedcheck = 0
			return

/obj/machinery/chemical_dispenser/beer
	icon_state = "booze_dispenser"
	name = "booze dispenser"
	layer = OBJ_LAYER
	ui_title = "Booze Portal 9001"
	energy = 100
	accept_glass = 1
	max_energy = 100
	density = 0
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list("lemon_lime","sugar","orangejuice","limejuice","sodawater","tonic","beer","kahlua","whiskey","wine","vodka","gin","rum","tequilla","vermouth","cognac","ale","mead")

/obj/machinery/chemical_dispenser/beer/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)
	..()

	if(istype(B, /obj/item/weapon/tool/multitool))
		if(hackedcheck == 0)
			user << "You disable the 'nanotrasen-are-cheap-bastards' lock, enabling hidden and very expensive boozes."
			dispensable_reagents += list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 1
			return

		else
			user << "You re-enable the 'nanotrasen-are-cheap-bastards' lock, disabling hidden and very expensive boozes."
			dispensable_reagents -= list("goldschlager","patron","watermelonjuice","berryjuice")
			hackedcheck = 0
			return

/obj/machinery/chemical_dispenser/meds
	name = "chem dispenser magic"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	use_power = 0
	idle_power_usage = 40
	ui_title = "Chem Dispenser 9000"
	energy = 100
	max_energy = 100
	amount = 30
	accept_glass = 0 //At 0 ONLY accepts glass containers. Kinda misleading varname.
	beaker = null
	recharged = 0
	hackedcheck = 0
	dispensable_reagents = list("inaprovaline","ryetalyn","paracetamol","tramadol","oxycodone","sterilizine","leporazine","kelotane","dermaline","dexalin","dexalinp","tricordrazine","anti_toxin","synaptizine","hyronalin","arithrazine","alkysine","imidazoline","peridaxon","bicaridine","hyperzine","rezadone","spaceacillin","ethylredoxrazine","stoxin","chloralhydrate","cryoxadone","clonexadone")



/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	layer = BELOW_OBJ_LAYER
	circuit = /obj/item/weapon/circuitboard/chemmaster
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "bottle-1" //yes, strings
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 20
	reagent_flags = OPENCONTAINER

/obj/machinery/chem_master/RefreshParts()
	if(!reagents)
		create_reagents(10)
	reagents.maximum_volume = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		reagents.maximum_volume += G.volume
		G.reagents.trans_to_holder(reagents, G.volume)

/obj/machinery/chem_master/dismantle()
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		var/amount = G.reagents.get_free_space()
		reagents.trans_to_holder(G, amount)
	. = ..()

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)

/obj/machinery/chem_master/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/weapon/reagent_containers/glass))

		if(src.beaker)
			user << "A beaker is already loaded into the machine."
			return

		if (usr.unEquip(B, src))
			src.beaker = B
			user << "You add the beaker to the machine!"
			src.updateUsrDialog()
			icon_state = "mixer1"

	else if(istype(B, /obj/item/weapon/storage/pill_bottle))

		if(src.loaded_pill_bottle)
			user << "A pill bottle is already loaded into the machine."
			return


		if (usr.unEquip(B, src))
			src.loaded_pill_bottle = B
			user << "You add the pill bottle into the dispenser slot!"
			src.updateUsrDialog()
	return

/obj/machinery/chem_master/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.loc = src.loc
			loaded_pill_bottle = null
	else if(href_list["close"])
		usr << browse(null, "window=chemmaster")
		usr.unset_machine()
		return

	if(beaker)
		var/datum/reagents/R = beaker.reagents
		if (href_list["analyze"])
			var/dat = ""
			if(!condi)
				if(href_list["name"] == "Blood")
					var/datum/reagent/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list["name"])
							G = F
							break
					var/A = G.name
					var/B = G.data["blood_type"]
					var/C = G.data["blood_DNA"]
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[A]<BR><BR>Description:<BR>Blood Type: [B]<br>DNA: [C]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
				else
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if (href_list["add"])
			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = Clamp(text2num(href_list["amount"]), 0, reagents.get_free_space())
				R.trans_id_to(src, id, amount)
				if(reagents.get_free_space() < 1)
					usr << SPAN_WARNING("The [name] is full!")

		else if (href_list["addcustom"])
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			src.Topic(null, list("amount" = "[useramount]", "add" = href_list["addcustom"]))

		else if (href_list["remove"])
			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = Clamp(text2num(href_list["amount"]), 0, beaker.reagents.get_free_space())
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
					if(beaker.reagents.get_free_space() < 1)
						usr << SPAN_WARNING("The [name] is full!")
				else
					reagents.remove_reagent(id, amount)


		else if (href_list["removecustom"])
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			src.Topic(null, list("amount" = "[useramount]", "remove" = href_list["removecustom"]))

		else if (href_list["toggle"])
			mode = !mode

		else if (href_list["main"])
			attack_hand(usr)
			return
		else if (href_list["eject"])
			if(beaker)
				beaker:loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"
		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if (href_list["createpill_multiple"])
				count = input("Select the number of pills to make.", "Max [max_pill_count]", pillamount) as num
				count = Clamp(count, 1, max_pill_count)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			var/amount_per_pill = reagents.total_volume/count
			if (amount_per_pill > 60) amount_per_pill = 60

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill] units)"), MAX_NAME_LEN)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count--)
				var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill"+pillsprite
				reagents.trans_to_obj(P,amount_per_pill)
				if(src.loaded_pill_bottle)
					if(loaded_pill_bottle.contents.len < loaded_pill_bottle.storage_slots)
						P.loc = loaded_pill_bottle
						src.updateUsrDialog()

		else if (href_list["createbottle"])
			if(!condi)
				var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()), MAX_NAME_LEN)
				var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = bottlesprite
				reagents.trans_to_obj(P,60)
				P.update_icon()
			else
				var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
				reagents.trans_to_obj(P,50)
		else if(href_list["change_pill"])
			#define MAX_PILL_SPRITE 20 //max icon state of the pill sprites
			var/dat = "<table>"
			for(var/i = 1 to MAX_PILL_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			for(var/sprite in BOTTLE_SPRITES)
				dat += "<tr><td><a href=\"?src=\ref[src]&bottle_sprite=[sprite]\"><img src=\"[sprite].png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	playsound(loc, 'sound/machines/button.ogg', 100, 1)
	src.updateUsrDialog()
	return

/obj/machinery/chem_master/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to MAX_PILL_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "pill" + num2text(i)), "pill[i].png")
			for(var/sprite in BOTTLE_SPRITES)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', sprite), "[sprite].png")
	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.storage_slots]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.storage_slots]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			var/free_space = reagents.get_free_space()
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in R.reagent_list)
				dat += "[G.name] , [G.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[G.description];name=[G.name]'>(Analyze)</A> "
				for(var/volume in list(1, 5, 10))
					if(free_space >= volume)
						dat += "<A href='?src=\ref[src];add=[G.id];amount=[volume]'>([volume])</A> "
					else
						dat += "([volume]) "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=[G.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];addcustom=[G.id]'>(Custom)</A><BR>"
			if(free_space < 1)
				dat += "The [name] is full!"

		dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.name] , [N.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;desc=[N.description];name=[N.name]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];remove=[N.id];amount=[N.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];removecustom=[N.id]'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (60 units max)</A><a href=\"?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
			dat += "<A href='?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (60 units max)<a href=\"?src=\ref[src]&change_bottle=1\"><img src=\"[bottlesprite].png\" /></A>"
		else
			dat += "<A href='?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
	if(!condi)
		user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	else
		user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	onclose(user, "chem_master")
	return

/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = BELOW_OBJ_LAYER
	density = 0
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/sheet_reagents = list(
		/obj/item/stack/material/iron = "iron",
		/obj/item/stack/material/uranium = MATERIAL_URANIUM,
		/obj/item/stack/material/plasma = "plasma",
		/obj/item/stack/material/gold = MATERIAL_GOLD,
		/obj/item/stack/material/silver = MATERIAL_SILVER,
		/obj/item/stack/material/mhydrogen = "hydrogen"
		)

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	return

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			update_icon()
			src.updateUsrDialog()
			return 0

	//Useability tweak for borgs
	if (istype(O,/obj/item/weapon/gripper))
		interact(user)
		return

	if(holdingitems && holdingitems.len >= limit)
		usr << "The machine cannot hold anymore items."
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			user << "Nothing in the plant bag is usable."
			return 1

		if(!O.contents.len)
			user << "You empty \the [O] into \the [src]."
		else
			user << "You fill \the [src] from \the [O]."

		src.updateUsrDialog()
		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		user << "\The [O] is not suitable for blending."
		return 1

	user.remove_from_mob(O)
	O.loc = src
	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_ai(mob/user as mob)
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu
	if(inoperable())
		return
	user.set_machine(src)
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Process the reagents</a><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	user << browse("<HEAD><TITLE>All-In-One Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return 1

	switch(href_list["action"])
		if ("grind")
			grind()
		if("eject")
			eject()
		if ("detach")
			detach()
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	src.updateUsrDialog()
	return 1

/obj/machinery/reagentgrinder/proc/detach()

	if (usr.stat != 0)
		return
	if (!beaker)
		return
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()

	if (usr.stat != 0)
		return
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.loc = src.loc
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind()

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0
		interact(usr)

	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					beaker.reagents.add_reagent(sheet_reagents[stack.type], (amount_to_take*REAGENTS_PER_SHEET))
					continue

		if(O.reagents)
			O.reagents.trans_to(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

#undef REAGENTS_PER_SHEET
