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
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE // Handles power use in Process()
	layer = BELOW_OBJ_LAYER

	var/ui_title = "Chem Dispenser 5000"
	var/energy = 100
	var/max_energy = 100
	var/amount = 30
	var/accept_beaker = TRUE //At TRUE, ONLY accepts beakers.
	var/recharged = 0
	var/hackedcheck = FALSE
	var/list/dispensable_reagents = list(
		"hydrazine","lithium","carbon",
		"ammonia","acetone","sodium",
		"aluminum","silicon","phosphorus",
		"sulfur","hclacid","potassium",
		"iron","copper","mercury",
		"radium","water","ethanol",
		"sugar","sacid","tungsten"
	)
	var/list/hacked_reagents = list()
	var/obj/item/weapon/reagent_containers/beaker = null

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

/obj/machinery/chemical_dispenser/Initialize()
	. = ..()
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


/obj/machinery/chemical_dispenser/ui_data()
	var/list/data = list()
	data["amount"] = amount
	data["energy"] = round(energy)
	data["maxEnergy"] = round(max_energy)
	data["accept_beaker"] = accept_beaker

	var/list/chemicals = list()
	for (var/re in dispensable_reagents)
		var/datum/reagent/temp = chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	if(beaker)
		data["beaker"] = beaker.reagents.ui_data()

	return data

/obj/machinery/chemical_dispenser/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "chem_dispenser.tmpl", ui_title, 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/chemical_dispenser/Topic(href, href_list)
	if(..())
		return

	if(href_list["amount"])
		// Since the user can actually type the commands himself, some sanity checking
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		amount = CLAMP(amount, 0, 120)

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


/obj/machinery/chemical_dispenser/MouseDrop_T(atom/movable/I, mob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
		return ..()
	if(istype(I, /obj/item/weapon/reagent_containers) && I.is_open_container() && !beaker)
		I.forceMove(src)
		I.add_fingerprint(user)
		beaker = I
		to_chat(user, SPAN_NOTICE("You add [I] to [src]."))
		SSnano.update_uis(src) // update all UIs attached to src
		return
	. = ..()

/obj/machinery/chemical_dispenser/attackby(obj/item/weapon/reagent_containers/B, mob/living/user)
	if(beaker)
		to_chat(user, "Something is already loaded into the machine.")
		return
	if(istype(B, /obj/item/weapon/reagent_containers/glass) || istype(B, /obj/item/weapon/reagent_containers/food))
		if(accept_beaker && istype(B, /obj/item/weapon/reagent_containers/food))
			to_chat(user, SPAN_NOTICE("This machine only accepts beakers"))
		src.beaker =  B
		if (user.unEquip(B, src))
			to_chat(user, "You set [B] on the machine.")
			SSnano.update_uis(src) // update all UIs attached to src
			return

/obj/machinery/chemical_dispenser/attack_ai(mob/living/user)
	return src.attack_hand(user)

/obj/machinery/chemical_dispenser/attack_hand(mob/living/user)
	if(stat & BROKEN)
		return
	ui_interact(user)

/obj/machinery/chemical_dispenser/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	layer = OBJ_LAYER
	ui_title = "Soda Dispens-o-matic"
	accept_beaker = FALSE
	density = FALSE
	dispensable_reagents = list("water","ice","coffee","cream","tea","greentea","icetea","icegreentea","cola","spacemountainwind","dr_gibb","space_up","tonic","sodawater","lemon_lime","sugar","orangejuice","limejuice","watermelonjuice")
	hacked_reagents = list("thirteenloko","grapesoda")

/obj/machinery/chemical_dispenser/soda/attackby(obj/item/I, mob/living/user)
	..()
	if(istype(I, /obj/item/weapon/tool/multitool) && length(hacked_reagents))
		hackedcheck = !hackedcheck
		if(!hackedcheck)
			to_chat(user, "You change the mode from 'McNano' to 'Pizza King'.")
			dispensable_reagents += hacked_reagents

		else
			to_chat(user, "You change the mode from 'Pizza King' to 'McNano'.")
			dispensable_reagents -= hacked_reagents

/obj/machinery/chemical_dispenser/beer
	icon_state = "booze_dispenser"
	name = "booze dispenser"
	layer = OBJ_LAYER
	ui_title = "Booze Portal 9001"
	accept_beaker = FALSE
	density = FALSE
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list("lemon_lime","sugar","orangejuice","limejuice","sodawater","tonic","beer","kahlua","whiskey","wine","vodka","gin","rum","tequilla","vermouth","cognac","ale","mead")
	hacked_reagents = list("goldschlager","patron","watermelonjuice","berryjuice")

/obj/machinery/chemical_dispenser/beer/attackby(obj/item/I, mob/living/user)
	..()

	if(istype(I, /obj/item/weapon/tool/multitool) && length(hacked_reagents))
		hackedcheck = !hackedcheck
		if(!hackedcheck)
			to_chat(user, "You disable the 'cheap bastards' lock, enabling hidden and very expensive boozes.")
			dispensable_reagents += hacked_reagents

		else
			to_chat(user, "You re-enable the 'cheap bastards' lock, disabling hidden and very expensive boozes.")
			dispensable_reagents -= hacked_reagents

/obj/machinery/chemical_dispenser/meds
	name = "chem dispenser magic"
	ui_title = "Chem Dispenser 9000"
	dispensable_reagents = list(
		"inaprovaline","ryetalyn","paracetamol",
		"tramadol","oxycodone","sterilizine",
		"leporazine","kelotane","dermaline",
		"dexalin","dexalinp","tricordrazine",
		"anti_toxin","synaptizine","hyronalin",
		"arithrazine","alkysine","imidazoline",
		"peridaxon","bicaridine","hyperzine",
		"rezadone","spaceacillin","ethylredoxrazine",
		"stoxin","chloralhydrate","cryoxadone",
		"clonexadone"
	)

/obj/machinery/chemical_dispenser/industrial
	name = "industrial chem dispenser"
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "industrial_dispenser"
	ui_title = "Industrial Dispenser 4835"
	dispensable_reagents = list(
		"acetone","aluminum","ammonia",
		"copper","ethanol","hydrazine",
		"iron","radium","sacid",
		"hclacid","silicon","tungsten"
	)